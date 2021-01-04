### 1、概念

LRU是Least Recently Used的缩写，即最近最少使用。百度百科中说：LRU是一种常用的[页面置换算法](https://baike.baidu.com/item/页面置换算法/7626091)，选择最近最久未使用的页面予以淘汰。铁子们说：LRU是一种缓存淘汰算法，其核心思想是，如果数据最近被访问过，那么将来被访问的几率也更高。

### 2、实现原理分析

灵机一动，我瞬间想到了一种实现方法，为每一个缓存对象设置一个计数器，每次缓存命中则给计数器加1，随着新缓存的数量一直增加，一旦内存耗尽就需要淘汰旧缓存，但是淘汰缓存要遍历所有的计数器，并将计数器值最小的缓存对象丢弃。

显然，上述实现LRU的思路弊端很明显，如果缓存的数量少，问题不大， 但是缓存数量达到十万或者百万量级，如果需要淘汰缓存对象，则需要遍历所有计算器，想一想就非常可怕，其性能与资源消耗是巨大的，效率也就非常的慢了。

如果用数组做缓存对象存储，在数组中移动对象的话，需要进行整体copy，性能也是不佳。就在此时，电闪雷鸣，风雨交加，外面突然下起了雨，我站在窗前，发现雨点打在地上呈现出了链表两个字，顿时豁然开朗，土地平旷，屋舍俨然。

考虑到链表中进行节点的移动，只需要改变指针的指向，效率是很高的，但是获取元素的效率不高，故考虑HashMap和链表结合的方式，类似于LinkedHashMap的实现。

### 3、手写LRU简单实现

定义一个缓存节点

```java
/**



 * 缓存节点



 */



public class Node {



 



    String key;



 



    Object value;



 



    Node pre;



 



    Node next;



 



}
```

简单实现LRU策略 

```java
/**



* @Author:         liuliya



* @CreateDate:     2020/5/26 17:57



*/



public class LruCache {



 



    //缓存容器



    private Map<String, Node> cache = new ConcurrentHashMap<>();



 



    //缓存容量



    private int capacity;



 



    //当前缓存数量



    private int currentCount;



 



    //链表头



    private Node head;



 



    //链表尾



    private Node tail;



 



    //初始化一个双向链表



    public LruCache(int capacity) {



        this.capacity = capacity;



        this.currentCount = 0;



 



        head = new Node();



        head.pre = null;



 



        tail = new Node();



        tail.next = null;



 



        head.next = tail;



        tail.pre = head;



    }



 



    //读取缓存



    public Object get(String key) {



        Node node = cache.get(key);



        if (null == node) {



            return null;



        }



        //将读取的节点移动到链表头



        this.move2Head(node);



        return node.value;



    }



 



    //写入缓存



    public void set(String key, Object value) {



        Node existNode = cache.get(key);



        //如果该缓存节点不存在



        if (existNode == null) {



            Node node = new Node();



            node.key = key;



            node.value = value;



 



            this.cache.put(key, node);



            this.addNode(node);



 



            currentCount++;



 



            if (currentCount > capacity) {



                //淘汰链表尾结点



                Node tail = this.popTail();



                this.cache.remove(tail.key);



                currentCount--;



            }



        } else {



            existNode.value = value;



            this.move2Head(existNode);



        }



    }



 



    //添加节点



    public void addNode(Node node) {



        node.pre = head;



        node.next = head.next;



        head.next.pre = node;



        head.next = node;



    }



 



    //删除节点



    public void removeNode(Node node) {



        Node pre = node.pre;



        Node next = node.next;



        pre.next = next;



        next.pre = pre;



    }



 



    //将节点移动到链表头部



    public void move2Head(Node node) {



        this.removeNode(node);



        this.addNode(node);



    }



 



    //丢弃尾结点



    public Node popTail() {



        Node node = tail.pre;



        this.removeNode(node);



        return node;



    }



 



}
```

测试中定义一个容量为3的缓存lruCache，往lruCache依次存入三个缓存，使用缓存“a”后，lru策略将“a”缓存移动到链表头，再次往lruCache存入数据时就会淘汰“b”。

```java
 public static void main(String[] args) {



        LruCache lruCache = new LruCache(3);



        lruCache.set("a", 1);



        lruCache.set("b", 2);



        lruCache.set("c", 3);



        lruCache.get("a");     //返回1



        lruCache.set("d", 4);  //该操作会使缓存b作废



        lruCache.get("b");     //未找到



 }
```

 

### 4、LRU在Redis中的配置

在实际生产环境中有这样一个场景，如果预估Redis中的缓存数据为300M，但是部署Redis的服务器只腾出200M给Redis使用，这时候就要考虑配置Redis中的缓存淘汰策略了。

找到redis的配置文件redis.conf，配置文件中有一个maxmemory参数表示redis使用服务器内存大小。maxmemory设置为0，表示缓存大小无限制（无限制配置只限在64为操作系统环境下，如果为32位操作系统，maxmemory隐式不能超过3GB）。

![img](https://img-blog.csdnimg.cn/20200527102021533.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzI3MzI0NzYx,size_16,color_FFFFFF,t_70)

当然也可使用 CONFIG SET maxmemory 命令设置大小。

Redis默认提供了如下几种缓存淘汰策略：

```python
从设置ttl的key中选取最近不常用的key进行删除



# volatile-lru -> remove the key with an expire set using an LRU algorithm



 



优先删除最近不常用的key



# allkeys-lru -> remove any key according to the LRU algorithm



 



从设置ttl属性的key中进行随机删除



# volatile-random -> remove a random key with an expire set



 



随机删除key



# allkeys-random -> remove a random key, any key



 



从设置ttl属性的key中选取存活时间最短的key进行删除



# volatile-ttl -> remove the key with the nearest expire time (minor TTL)



 



不进行淘汰，若有写操作会返回error



# noeviction -> don't expire at all, just return an error on write operations
```

​       策略同样可以在redis.conf文件中进行配置:

![img](https://img-blog.csdnimg.cn/20200527103649718.png)