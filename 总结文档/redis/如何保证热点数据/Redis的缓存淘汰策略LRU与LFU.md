# 前言

Redis缓存淘汰策略与Redis键的过期删除策略并不完全相同，前者是在Redis内存使用超过一定值的时候（一般这个值可以配置）使用的淘汰策略；而后者是通过定期删除+惰性删除两者结合的方式进行内存淘汰的。
 这里参照官方文档的解释重新叙述一遍过期删除策略：当某个key被设置了过期时间之后，客户端每次对该key的访问（读写）都会事先检测该key是否过期，如果过期就直接删除；但有一些键只访问一次，因此需要主动删除，默认情况下redis每秒检测10次，检测的对象是所有设置了过期时间的键集合，每次从这个集合中随机检测20个键查看他们是否过期，如果过期就直接删除，如果删除后还有超过25%的集合中的键已经过期，那么继续检测过期集合中的20个随机键进行删除。这样可以保证过期键最大只占所有设置了过期时间键的25%。

# ZERO、Redis内存不足的缓存淘汰策略

- noeviction：当内存使用超过配置的时候会返回错误，不会驱逐任何键
- allkeys-lru：加入键的时候，如果过限，首先通过LRU算法驱逐最久没有使用的键
- volatile-lru：加入键的时候如果过限，首先从设置了过期时间的键集合中驱逐最久没有使用的键
- allkeys-random：加入键的时候如果过限，从所有key随机删除
- volatile-random：加入键的时候如果过限，从过期键的集合中随机驱逐
- volatile-ttl：从配置了过期时间的键中驱逐马上就要过期的键
- volatile-lfu：从所有配置了过期时间的键中驱逐使用频率最少的键
- allkeys-lfu：从所有键中驱逐使用频率最少的键

# 一、LRU

#### 1、Java中的LRU实现方式

在Java中LRU的实现方式是使用HashMap结合双向链表，HashMap的值是双向链表的节点，双向链表的节点也保存一份key value。

- 新增key value的时候首先在链表结尾添加Node节点，如果超过LRU设置的阈值就淘汰队头的节点并删除掉HashMap中对应的节点。
- 修改key对应的值的时候先修改对应的Node中的值，然后把Node节点移动队尾。
- 访问key对应的值的时候把访问的Node节点移动到队尾即可。

#### 2、Redis中LRU的实现

- Redis维护了一个24位时钟，可以简单理解为当前系统的时间戳，每隔一定时间会更新这个时钟。每个key对象内部同样维护了一个24位的时钟，当新增key对象的时候会把系统的时钟赋值到这个内部对象时钟。比如我现在要进行LRU，那么首先拿到当前的全局时钟，然后再找到内部时钟与全局时钟距离时间最久的（差最大）进行淘汰，这里值得注意的是全局时钟只有24位，按秒为单位来表示才能存储194天，所以可能会出现key的时钟大于全局时钟的情况，如果这种情况出现那么就两个相加而不是相减来求最久的key。



```cpp
struct redisServer {
       pid_t pid; 
       char *configfile; 
       //全局时钟
       unsigned lruclock:LRU_BITS; 
       ...
};
```



```cpp
typedef struct redisObject {
    unsigned type:4;
    unsigned encoding:4;
    /* key对象内部时钟 */
    unsigned lru:LRU_BITS;
    int refcount;
    void *ptr;
} robj;
```

- Redis中的LRU与常规的LRU实现并不相同，常规LRU会准确的淘汰掉队头的元素，但是Redis的LRU并不维护队列，只是根据配置的策略要么从所有的key中随机选择N个（N可以配置）要么从所有的设置了过期时间的key中选出N个键，然后再从这N个键中选出最久没有使用的一个key进行淘汰。

- 下图是常规LRU淘汰策略与Redis随机样本取一键淘汰策略的对比，浅灰色表示已经删除的键，深灰色表示没有被删除的键，绿色表示新加入的键，越往上表示键加入的时间越久。从图中可以看出，在redis 3中，设置样本数为10的时候能够很准确的淘汰掉最久没有使用的键，与常规LRU基本持平。

  ![img](https:////upload-images.jianshu.io/upload_images/12062369-7fae1afe70569623.png?imageMogr2/auto-orient/strip|imageView2/2/w/854/format/webp)

  image.png

# 二、LFU

LFU是在Redis4.0后出现的，LRU的最近最少使用实际上并不精确，考虑下面的情况，如果在|处删除，那么A距离的时间最久，但实际上A的使用频率要比B频繁，所以合理的淘汰策略应该是淘汰B。LFU就是为应对这种情况而生的。



```ruby
A~~A~~A~~A~~A~~A~~A~~A~~A~~A~~~|
B~~~~~B~~~~~B~~~~~B~~~~~~~~~~~B|
```

- LFU把原来的key对象的内部时钟的24位分成两部分，前16位还代表时钟，后8位代表一个计数器。16位的情况下如果还按照秒为单位就会导致不够用，所以一般这里以时钟为单位。而后8位表示当前key对象的访问频率，8位只能代表255，但是redis并没有采用线性上升的方式，而是通过一个复杂的公式，通过配置两个参数来调整数据的递增速度。
   下图从左到右表示key的命中次数，从上到下表示影响因子，在影响因子为100的条件下，经过10M次命中才能把后8位值加满到255.



```bash
# +--------+------------+------------+------------+------------+------------+
# | factor | 100 hits   | 1000 hits  | 100K hits  | 1M hits    | 10M hits   |
# +--------+------------+------------+------------+------------+------------+
# | 0      | 104        | 255        | 255        | 255        | 255        |
# +--------+------------+------------+------------+------------+------------+
# | 1      | 18         | 49         | 255        | 255        | 255        |
# +--------+------------+------------+------------+------------+------------+
# | 10     | 10         | 18         | 142        | 255        | 255        |
# +--------+------------+------------+------------+------------+------------+
# | 100    | 8          | 11         | 49         | 143        | 255        |
# +--------+------------+------------+------------+------------+------------+
```



```cpp
  uint8_t LFULogIncr(uint8_t counter) {
      if (counter == 255) return 255;
      double r = (double)rand()/RAND_MAX;
      double baseval = counter - LFU_INIT_VAL;
      if (baseval < 0) baseval = 0;
      double p = 1.0/(baseval*server.lfu_log_factor+1);
      if (r < p) counter++;
      return counter;
  }
```



```cpp
lfu-log-factor 10
lfu-decay-time 1
```

- 上面说的情况是key一直被命中的情况，如果一个key经过几分钟没有被命中，那么后8位的值是需要递减几分钟，具体递减几分钟根据衰减因子lfu-decay-time来控制



```cpp
unsigned long LFUDecrAndReturn(robj *o) {
    unsigned long ldt = o->lru >> 8;
    unsigned long counter = o->lru & 255;
    unsigned long num_periods = server.lfu_decay_time ? LFUTimeElapsed(ldt) / server.lfu_decay_time : 0;
    if (num_periods)
        counter = (num_periods > counter) ? 0 : counter - num_periods;
    return counter;
}
```



```cpp
lfu-log-factor 10
lfu-decay-time 1
```

- 上面递增和衰减都有对应参数配置，那么对于新分配的key呢？如果新分配的key计数器开始为0，那么很有可能在内存不足的时候直接就给淘汰掉了，所以默认情况下新分配的key的后8位计数器的值为5（应该可配资），防止因为访问频率过低而直接被删除。
- 低8位我们描述完了，那么高16位的时钟是用来干嘛的呢？目前我的理解是用来衰减低8位的计数器的，就是根据这个时钟与全局时钟进行比较，如果过了一定时间（做差）就会对计数器进行衰减。



作者：后厂村老司机
链接：https://www.jianshu.com/p/c8aeb3eee6bc
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。