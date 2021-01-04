有时候需要对数据缓存。用Map缓存数据比较合适。但是由于对吞吐量，一致性，计算性能的要求，对数据进行缓存的设计还是需要慎重考虑的。

## 一、利用HashMap加同步

（1）说明

把HashMap当作缓存容器。每缓存一个key的时候，都进行同步。

（2）代码

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 package memory;
 2 
 3 import java.util.HashMap;
 4 import java.util.Map;
 5 
 6 /**
 7  * Created by adrian.wu on 2018/12/12.
 8  */
 9 public class MemoryFirst<K, V> implements Computable<K, V> {
10     private final Map<K, V> cache = new HashMap<>();
11     private final Computable<K, V> c;
12 
13     public MemoryFirst(Computable<K, V> c) {
14         this.c = c;
15     }
16 
17     @Override
18     public synchronized V compute(K arg) throws InterruptedException {
19         V result = cache.get(arg);
20 
21         if (result == null) {
22             result = c.compute(arg);
23             cache.put(arg, result);
24         }
25 
26         return result;
27     }
28 }
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

（3）缺点

由于HashMap并非线程安全，因此每一次计算都使用同步机制确保线程安全。很明显，这种方式伸缩性比较差。因为一个线程正在计算结果，其它所有线程都在等待，即使对应的arg是不同的。

 

## 二、用ConcurrentHashMap代替HashMap

（1）说明

ConcurrentHashMap是线程安全的，并且同步并非对整个Map进行同步而是对每一个分段进行同步，所以并发性也可以大大提升。

（2）代码

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 package memory;
 2 
 3 import java.util.Map;
 4 import java.util.concurrent.ConcurrentHashMap;
 5 
 6 /**
 7  * Created by adrian.wu on 2018/12/12.
 8  */
 9 public class MemorySecond<K, V> implements Computable<K, V> {
10     private final Map<K, V> cache = new ConcurrentHashMap<>();
11     private final Computable<K, V> c;
12 
13     public MemorySecond(Computable<K, V> c) {
14         this.c = c;
15     }
16 
17     @Override
18     public V compute(K arg) throws InterruptedException {
19         V result = cache.get(arg);
20 
21         if (result == null) {
22             result = c.compute(arg);
23             cache.put(arg, result);
24         }
25 
26         return result;
27     }
28 }
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

（3）缺点

相比第一个设计方案。这种方案已经有很大的提升了。但是如果一个compute的计算开销很大，恰巧有另一个同一个arg的线程同时请求compute，则会造成重复计算，重复put的情况。所以我们希望如果有一个线程正在计算的时候另一个线程正在等待而不是重复计算。

 

## 三、利用FutureTask解决第二个设计的问题

（1）说明

利用FutrueTask, 如果get到结果则返回，如果正在计算则利用FutureTask的特性阻塞。否则计算。

（2）代码

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 package memory;
 2 
 3 import org.slf4j.Logger;
 4 
 5 import java.util.Map;
 6 import java.util.concurrent.*;
 7 
 8 import static memory.ErrorHandler.launderThrowable;
 9 
10 /**
11  * Created by adrian.wu on 2018/12/12.
12  */
13 public class MemoryThird<K, V> implements Computable<K, V> {
14     private final Map<K, Future<V>> cache = new ConcurrentHashMap<>();
15     private final Computable<K, V> c;
16 
17     public MemoryThird(Computable<K, V> c) {
18         this.c = c;
19     }
20 
21     @Override
22     public V compute(final K arg) throws InterruptedException {
23         Future<V> f = cache.get(arg);
24         if (f == null) {
25             Callable<V> eval = new Callable<V>() {
26                 @Override
27                 public V call() throws Exception {
28                     return c.compute(arg);
29                 }
30             };
31 
32             FutureTask<V> ft = new FutureTask<>(eval);
33             f = ft;
34             cache.put(arg, ft);
35             ft.run(); // start compute
36         }
37         try {
38             return f.get();
39         } catch (ExecutionException e) {
40             throw launderThrowable(e.getCause());
41         }
42     }
43 }
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

（3）缺点

只有一个缺陷，仍然存在两个线程计算出相同值的漏洞。就是由于compute方法中的if代码块仍然是非原子的“先检查，再执行”，因此仍然有可能两个线程在同一时间计算一个不存在的arg。原因是第23行的get方法和34行的put方法是对底层的Map操作，所以无法保证原子性。由于cache里面的是future而不是真正的值，所以将有可能导致缓存污染（cache pollution）问题，即如果某个计算过程被取消或者失败，那么缓存存入的Future是有缺陷的。

 

## 四、最终设计方案

（1）说明

使用putIfAbsent代替put，以保证原子性。如果发现Future计算被取消或失败则删除，从而缓存不会消耗过多内存。

（2）代码

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 package memory;
 2 
 3 import java.util.Map;
 4 import java.util.concurrent.*;
 5 
 6 import static memory.ErrorHandler.launderThrowable;
 7 
 8 /**
 9  * Created by adrian.wu on 2018/12/12.
10  */
11 public class Memory<K, V> implements Computable<K, V> {
12     private Map<K, Future<V>> cache = new ConcurrentHashMap<>();
13     private Computable<K, V> c;
14 
15     public Memory(Computable<K, V> c) {
16         this.c = c;
17     }
18 
19     @Override
20     public V compute(K arg) throws InterruptedException {
21         while (true) {
22             Future<V> f = cache.get(arg);
23 
24             if (f == null) {
25                 Callable<V> eval = new Callable<V>() {
26                     @Override
27                     public V call() throws Exception {
28                         return c.compute(arg);
29                     }
30                 };
31 
32                 FutureTask<V> ft = new FutureTask<>(eval);
33                 
34                 f = cache.putIfAbsent(arg, ft); //double check
35                 if (f == null) {
36                     f = ft;
37                     ft.run(); //start compute
38                 }
39             }
40             try {
41                 return f.get();
42             } catch (CancellationException e) {
43                 cache.remove(arg);
44             } catch (ExecutionException e) {
45                 throw launderThrowable(e.getCause());
46             }
47         }
48     }
49 }
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

谢谢！