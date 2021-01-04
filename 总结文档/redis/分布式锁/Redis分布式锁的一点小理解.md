```
Redis分布式锁的一点小理解
目录

1. 为何要分布式锁
2. redis如何实现分布式锁
2.1 setnx+expire存在的问题以及更好的实现
2.2 如何正确的释放分布式锁  
 

Top
1. 为何要分布式锁#
  现在假设一个场景，同时有十个请求需要对资源进行访问和修改，为了保证数据的正确性，那么你的程序可能是这么写的：

复制代码
/** 用于锁的对象*/
public static final Object lock = new Object();

/** 模拟业务的资源*/
public static volatile int source;

public static void main(String[] args) throws InterruptedException {
    ExecutorService executorService = Executors.newFixedThreadPool(10);
    // 模拟有十个请求同时请求同一个资源
    for (int i = 0; i < 10; i++) {
        executorService.execute(() -> {
            System.err.println("[" + Thread.currentThread().getName() + "]正在争夺锁...");
            synchronized (lock) {
                System.err.println("okay！[" + Thread.currentThread().getName() + "]拿到锁了，现在执行业务操作，执行后资源值为：" + ++source);
                try {
                    TimeUnit.SECONDS.sleep(3);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });
    }
}
复制代码
  结果图：

synchronized锁不住程序结果0

  从结果来看就算同时有多个请求，确实保证了一次只有一个请求访问的，抛去性能的问题不讲，这样写似乎确实能实现。但是真的没问题吗？对于单机程序来说这样确实是能保证正确性，但是如果服务器用的是多台机器，这些请求会被负载均衡到不同的机器，由于synchronized只能作用于当前的JVM，所以对于其他JVM就锁不住了，这样对于资源的访问也就乱套了（当然不同JVM上方的source也是只在当前JVM生效，source只是一种资源的象征，实际可能是DB中某条数据的值）。如下图所示：

synchronized锁1

  所以为了解决这个问题，分布式锁就这样诞生了。分布式锁这名字听起来很大气，但是仔细想想我们现在的问题只是不同机器不能访问同一个锁，那么如果我们将这个锁放到第三方（如redis）中，所有机器在访问的时候去这个第三方拿，由于第三方的锁只有一个，这样又能保证锁住了。 分布式锁2

Top
2. redis如何实现分布式锁#
  那来看下使用redis如何实现分布式锁。

2.1 setnx+expire存在的问题以及更好的实现#
  旧一点的版本（2.6之前）使用的是setnx+expire的组合来实现。

　 setnx：当key不存在的时候设置成功，返回1，若存在的话返回0表示失败。但是这样的组合存在一个问题，先来看一段伪代码。

复制代码
try {
        if (redisclient. setnx(key 1) == 1) { //1
            redisClient.expire(key， 1000);//2
        }
    } finally {
        redisClient.del(key);
    }
复制代码
  如上代码，看上去没什么问题，但是极端情况下如果在1处执行完毕2处还没执行这时候这台机器宕机了，由于命令已经在redis执行了，那么这个锁将是无期限的，且不会被删除，也就是说设置setnx和expire是两个命令，不具备原子性。 针对这个问题，可以使用 redis2.6版本之后的命令

set key value NX EX timeOut(过期秒数)

来解决，这个命令跟 setnx一样，但是多了过期时间，可以很好的解决这个问题。

  如果没有代码的redisClient没有set这五个参数的命令，也可以采用lua脚本的方式来保证原子性，如下。

    String luascript = "if redis.call('setnx',KEYS[1],ARGV[1])==1 then return redis.call('expire',KEYS[1],ARGV[2]) else return 0 end";
    redisClient.eval(luaScript, Collections.singletonList(key), Arrays.asList(uuid.toString(),"过期秒数"));
2.2 如何正确的释放分布式锁  #
  解决原子性的问题之后，还存在着一个问题：如果在过期时间内程序代码没执行完，那么其他其他机器线程获得这个锁，这样会造成同时有两个线程执行一段代码，并且A机器(过期还没执行完)中finally会删除key，导致误删到B机器锁（当前获得锁的机器）的情况。

  这个问题这样解决：

我们可以在相同的机器上开一个守护线程(如上面例子就在A机器再开一个守护线程)，这个线程主要作用是在key快过期的时候进行续命操作，保证代码执行完毕。

关于误删，我们可以把value设成当前线程独一无二的ID（可以使用uuid），删除前判断一下是否是自己的ID，是的话再执行删除，如下面代码：

复制代码
　try {
     ...
 } finally {
     if (uuid.equals(redisClient.get(key)) {//1
         redisClient.del(key);//2
     }
 }
复制代码
  这时一般情况都没问题，但是这里的1和2又跟前面的问题类似---不具备原子性，所以还是有出错的可能，但是 redis中没有支持获取删除的原子性命令，该怎么解决呢？ 我们可以通过Lua脚本来解决，例如本例中可以像下面这么写

　　　String luascript = "if redis.call('get',KEYS[1])==ARGV[l] then return redis.call('del',KEYS[1]) else return 0 end";
     redisClient.eval(luaScript, Collections.singletonList(key), Collections.singletonList(uuid));
  在redis中，执行lua脚本的命令一般是这样：

eval 脚本 key的数量n key1 key2 ... key_n ARGV的数量(这个没有规定多少，可以不跟key的数量保持一致，只要知道key结束后面的都是argv)

  那么在上面代码的脚本放在redis中就变成下面这样：

　　eval "if redis.call('get',KEYS[1])==ARGV[l] then return redis.call('del',KEYS[1]) else return 0 end" 1 'key' 'uuid'
  到这里，基本就没什么问题了，最终的代码如下

复制代码
　　try {
        String luascript = "if redis.call('get',KEYS[1])==ARGV[l] then return redis.call('del',KEYS[1]) else return 0 end";
        String uuid = UUID.randomUUID().toString();
      
        while (!"OK".equals(redisClient.set(key,uuid,"NX","EX",100))) {
            // 没获取到锁的处理，可以睡眠一段时间再请求，也可以直接返回请求告诉用户有其他人在操作（后者是最好的，可以减少线程资源的浪费）
        }
      
        // 获取到锁之后的事情
        doBizThings();
    } finally {
        redisClient.eval(luaScript， Collections.singletonList(key)， Collections.singletonList(uuid));
    }
复制代码
  以上就是redis实现分布式锁的内容了，另外还可以使用zookeeper实现分布式锁，大致原理就是在一个锁下面创建"临时顺序节点"，如果是第一个节点的话，获取锁，执行完操作后删除，这个删除操作会通知下个节点（第二个节点），告诉它锁已经释放了，它现在是第一个节点了可以获取锁了。大致就是这样的一个过程，相比redis的好处是多了一个通知的机制，有兴趣的话可以自己去了解下。xxxxxxxxxx Jedis jedis = new Jedis("127.0.0.1", 6379);Pipeline pipelined = jedis.pipelined();for (String key : keys) {    pipelined.del(key);}pipelined.sync();jedis.close();// pipelined 实际是封装过一层的指令集 ->  实际应用的还是单条指令，但是节省了网络传输开销（服务端到Redis环境的网络
```