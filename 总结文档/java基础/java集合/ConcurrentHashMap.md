ConcurrentHashMap取消了Segment分段锁，采用CAS和synchronized来保证并发安全。CAS是主要进行数组的并发处理，数据结构跟HashMap1.8的结构类似，数组+链表/红黑二叉树。Java 8在链表长度超过一定阈值（8）时将链表（寻址时间复杂度为O(N)）转换为红黑树（寻址时间复杂度为O(log(N))）

**synchronized只锁定当前链表或红黑二叉树的首节点，这样只要hash不冲突，就不会产生并发，效率又提升N倍。**

。

# Java基础之ConcurrentHashMap

## HashMap存在的问题：

### HashMap线程不安全

因为多线程环境下，使用Hashmap进行put操作可能会引起死循环，导致CPU利用率接近100%，所以在并发情况下不能使用HashMap。例如如下代码：



```dart
final HashMap<String, String> map = new HashMap<String, String>(2);
for (int i = 0; i < 10000; i++) {
    new Thread(new Runnable() {
        @Override
        public void run() {
            map.put(UUID.randomUUID().toString(), "");
        }
    }).start();
}
```

### Hashtable线程安全但效率低下

Hashtable容器使用synchronized来保证线程安全，但在线程竞争激烈的情况下Hashtable的效率非常低下。因为当一个线程访问Hashtable的同步方法时，其他线程访问Hashtable的同步方法时，可能会进入阻塞或轮询状态。如线程1使用put进行添加元素，线程2不但不能使用put方法添加元素，并且也不能使用get方法来获取元素，所以竞争越激烈效率越低。

## 解决

### 分段锁

HashTable容器在竞争激烈的并发环境下表现出效率低下的原因，是因为所有访问HashTable的线程都必须竞争同一把锁，那假如容器里有多把锁，每一把锁用于锁容器其中一部分数据，那么当多线程访问容器里不同数据段的数据时，线程间就不会存在锁竞争，从而可以有效的提高并发访问效率，这就是ConcurrentHashMap所使用的锁分段技术，首先将数据分成一段一段的存储，然后给每一段数据配一把锁，当一个线程占用锁访问其中一个段数据的时候，其他段的数据也能被其他线程访问。有些方法需要跨段，比如size()和containsValue()，它们可能需要锁定整个表而而不仅仅是某个段，这需要**按顺序**锁定所有段，操作完毕后，又**按顺序**释放所有段的锁。这里“按顺序”是很重要的，否则极有可能出现死锁，在ConcurrentHashMap内部，段数组是final的，并且其成员变量实际上也是final的，但是，仅仅是将数组声明为final的并不保证数组成员也是final的，这需要实现上的保证。这可以确保不会出现死锁，因为获得锁的顺序是固定的。
ConcurrentHashMap是由Segment数组结构和HashEntry数组结构组成。Segment是一种可重入锁ReentrantLock，在ConcurrentHashMap里扮演锁的角色，HashEntry则用于存储键值对数据。一个ConcurrentHashMap里包含一个Segment数组，Segment的结构和HashMap类似，是一种数组和链表结构， 一个Segment里包含一个HashEntry数组，每个HashEntry是一个链表结构的元素， 每个Segment守护者一个HashEntry数组里的元素,当对HashEntry数组的数据进行修改时，必须首先获得它对应的Segment锁。

![img](https://upload-images.jianshu.io/upload_images/17755742-0aeb208cbf2192f9.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/502/format/webp)

ConcurrentHashMap

JDK1.8的实现已经抛弃了Segment分段锁机制，利用CAS+Synchronized来保证并发更新的安全。数据结构采用：数组+链表+红黑树。



![img](https://upload-images.jianshu.io/upload_images/17755742-84349c0ca1005c43.png?imageMogr2/auto-orient/strip|imageView2/2/w/446/format/webp)

ConcurrentHashMap in JDK1.8

话不多说，还是看源码吧：

### 构造：



```java
    //构造方法
    public ConcurrentHashMap(int initialCapacity) {
        if (initialCapacity < 0)//判断参数是否合法
            throw new IllegalArgumentException();
        int cap = ((initialCapacity >= (MAXIMUM_CAPACITY >>> 1)) ?
                   MAXIMUM_CAPACITY ://最大为2^30
                   tableSizeFor(initialCapacity + (initialCapacity >>> 1) + 1));//根据参数调整table的大小
        this.sizeCtl = cap;//获取容量
        //ConcurrentHashMap在构造函数中只会初始化sizeCtl值，并不会直接初始化table
    }
    //调整table的大小
    private static final int tableSizeFor(int c) {//返回一个大于输入参数且最小的为2的n次幂的数。
        int n = c - 1;
        n |= n >>> 1;
        n |= n >>> 2;
        n |= n >>> 4;
        n |= n >>> 8;
        n |= n >>> 16;
        return (n < 0) ? 1 : (n >= MAXIMUM_CAPACITY) ? MAXIMUM_CAPACITY : n + 1;
    }
```

tableSizeFor(int c)的原理：将c最高位以下通过|=运算全部变成1，最后返回的时候，返回n+1；
eg:当输入为25的时候，n等于24，转成二进制为1100，右移1位为0110，将1100与0110进行或("|")操作，得到1110。接下来右移两位得11，再进行或操作得1111，接下来操作n的值就不会变化了。最后返回的时候，返回n+1，也就是10000，十进制为32。按照这种逻辑得到2的n次幂的数。
那么为什么要先-1再+1呢？输入若是为0，那么不论怎么操作，n还是0，但是HashMap的容量只有大于0时才有意义。

### table初始化：

table初始化操作会延缓到第一次put行为。但是put是可以并发执行的，那么是如何实现table只初始化一次的？接着上源码：



```csharp
    final V putVal(K key, V value, boolean onlyIfAbsent) {
        if (key == null || value == null) throw new NullPointerException();
        int hash = spread(key.hashCode());
        int binCount = 0;
        for (Node<K,V>[] tab = table;;) {
            Node<K,V> f; int n, i, fh; K fk; V fv;
            if (tab == null || (n = tab.length) == 0)//判断table还未初始化
                tab = initTable();//初始化table
            else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {
                if (casTabAt(tab, i, null, new Node<K,V>(hash, key, value)))
                    break;                   // no lock when adding to empty bin
            }
           ...省略一部分源码
        }
    } 
    
    private final Node<K,V>[] initTable() {
        Node<K,V>[] tab; int sc;
        while ((tab = table) == null || tab.length == 0) {
        //如果一个线程发现sizeCtl<0，意味着另外的线程执行CAS操作成功，当前线程只需要让出cpu时间片，
        //由于sizeCtl是volatile的，保证了顺序性和可见性
            if ((sc = sizeCtl) < 0)//sc保存了sizeCtl的值
                Thread.yield(); // lost initialization race; just spin
            else if (U.compareAndSetInt(this, SIZECTL, sc, -1)) {//cas操作判断并置为-1
                try {
                    if ((tab = table) == null || tab.length == 0) {
                        int n = (sc > 0) ? sc : DEFAULT_CAPACITY;//DEFAULT_CAPACITY = 16，若没有参数则大小默认为16
                        @SuppressWarnings("unchecked")
                        Node<K,V>[] nt = (Node<K,V>[])new Node<?,?>[n];
                        table = tab = nt;
                        sc = n - (n >>> 2);
                    }
                } finally {
                    sizeCtl = sc;
                }
                break;
            }
        }
        return tab;
    }  
```

### put操作



```csharp
    final V putVal(K key, V value, boolean onlyIfAbsent) {
        if (key == null || value == null) throw new NullPointerException();
        int hash = spread(key.hashCode());//哈希算法
        int binCount = 0;
        for (Node<K,V>[] tab = table;;) {//无限循环，确保插入成功
            Node<K,V> f; int n, i, fh; K fk; V fv;
            if (tab == null || (n = tab.length) == 0)//表为空或表长度为0
                tab = initTable();//初始化表
            else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {//i = (n - 1) & hash为索引值，查找该元素，
            //如果为null,说明第一次插入
                if (casTabAt(tab, i, null, new Node<K,V>(hash, key, value)))
                    break;                   // no lock when adding to empty bin
            }
            else if ((fh = f.hash) == MOVED)//MOVED=-1;当前正在扩容，一起进行扩容操作
                tab = helpTransfer(tab, f);
            else if (onlyIfAbsent && fh == hash &&  // check first node
                     ((fk = f.key) == key || fk != null && key.equals(fk)) &&
                     (fv = f.val) != null)
                return fv;
            else {
                V oldVal = null;
                synchronized (f) {//其他情况加锁同步
                    if (tabAt(tab, i) == f) {
                        if (fh >= 0) {
                            binCount = 1;
                            for (Node<K,V> e = f;; ++binCount) {
                                K ek;
                                if (e.hash == hash &&
                                    ((ek = e.key) == key ||
                                     (ek != null && key.equals(ek)))) {
                                    oldVal = e.val;
                                    if (!onlyIfAbsent)
                                        e.val = value;
                                    break;
                                }
                                Node<K,V> pred = e;
                                if ((e = e.next) == null) {
                                    pred.next = new Node<K,V>(hash, key, value);
                                    break;
                                }
                            }
                        }
                        else if (f instanceof TreeBin) {
                            Node<K,V> p;
                            binCount = 2;
                            if ((p = ((TreeBin<K,V>)f).putTreeVal(hash, key,
                                                           value)) != null) {
                                oldVal = p.val;
                                if (!onlyIfAbsent)
                                    p.val = value;
                            }
                        }
                        else if (f instanceof ReservationNode)
                            throw new IllegalStateException("Recursive update");
                    }
                }
                if (binCount != 0) {
                    if (binCount >= TREEIFY_THRESHOLD)
                        treeifyBin(tab, i);
                    if (oldVal != null)
                        return oldVal;
                    break;
                }
            }
        }
        addCount(1L, binCount);
        return null;
    }
    //哈希算法
    static final int spread(int h) {
        return (h ^ (h >>> 16)) & HASH_BITS;
    }
    //保证拿到最新的数据
    static final <K,V> Node<K,V> tabAt(Node<K,V>[] tab, int i) {
        return (Node<K,V>)U.getObjectAcquire(tab, ((long)i << ASHIFT) + ABASE);
    }
    //CAS操作插入节点，比较数组下标为i的节点是否为c，若是，用v交换，否则不操作。
    //如果CAS成功，表示插入成功，结束循环进行addCount(1L, binCount)看是否需要扩容
    static final <K,V> boolean casTabAt(Node<K,V>[] tab, int i,
                                        Node<K,V> c, Node<K,V> v) {
        return U.compareAndSetObject(tab, ((long)i << ASHIFT) + ABASE, c, v);
    }
```

## table扩容

当table容量不足的时候，即table的元素数量达到容量阈值sizeCtl，需要对table进行扩容。 整个扩容分为两部分：

1. 构建一个nextTable，大小为table的两倍。
2. 把table的数据复制到nextTable中。
   这两个过程在单线程下实现很简单，但是ConcurrentHashMap是支持并发插入的，扩容操作自然也会有并发的出现，这种情况下，第二步可以支持节点的并发复制，这样性能自然提升不少，但实现的复杂度也上升了一个台阶。
   继续上源码：
   第一步，构建nextTable，毫无疑问，这个过程只能只有单个线程进行nextTable的初始化.



```java
private final void addCount(long x, int check) {
    ... 省略部分代码
    if (check >= 0) {
        Node<K,V>[] tab, nt; int n, sc;
        while (s >= (long)(sc = sizeCtl) && (tab = table) != null &&
               (n = tab.length) < MAXIMUM_CAPACITY) {
            int rs = resizeStamp(n);
            if (sc < 0) {// sc < 0 表明此时有别的线程正在进行扩容
                if ((sc >>> RESIZE_STAMP_SHIFT) != rs || sc == rs + 1 ||
                    sc == rs + MAX_RESIZERS || (nt = nextTable) == null ||
                    transferIndex <= 0)
                    break;
                if (U.compareAndSwapInt(this, SIZECTL, sc, sc + 1))
                // 不满足前面5个条件时，尝试参与此次扩容，把正在执行transfer任务的线程数加1，+2代表有1个，+1代表有0个
                    transfer(tab, nt);
            }
            //试着让自己成为第一个执行transfer任务的线程
            else if (U.compareAndSwapInt(this, SIZECTL, sc,
                                         (rs << RESIZE_STAMP_SHIFT) + 2))
                transfer(tab, null);// 去执行transfer任务
            s = sumCount();// 重新计数，判断是否需要开启下一轮扩容
        }
    }
}
```

节点从table移动到nextTable，大体思想是遍历、复制的过程。遍历过所有的节点以后就完成了复制工作，把table指向nextTable，并更新sizeCtl为新数组大小的0.75倍 ，扩容完成。

## get操作

1. 判断table是否为空，如果为空，直接返回null。
2. 计算key的hash值，并获取指定table中指定位置的Node节点，通过遍历链表或则树结构找到对应的节点，返回value值。

源码：



```kotlin
public V get(Object key) {
    Node<K,V>[] tab; Node<K,V> e, p; int n, eh; K ek;
    int h = spread(key.hashCode());
    if ((tab = table) != null && (n = tab.length) > 0 &&
        (e = tabAt(tab, (n - 1) & h)) != null) {
        if ((eh = e.hash) == h) {
            if ((ek = e.key) == key || (ek != null && key.equals(ek)))
                return e.val;
        }
        else if (eh < 0)
            return (p = e.find(h, key)) != null ? p.val : null;
        while ((e = e.next) != null) {
            if (e.hash == h &&
                ((ek = e.key) == key || (ek != null && key.equals(ek))))
                return e.val;
        }
    }
    return null;
}
```

## 和HashTable的区别：

> ConcurrentHashMap 是一个并发散列映射表，它允许完全并发的读取，并且支持给定数量的并发更新。
> 而HashTable和同步包装器包装的 HashMap，使用一个全局的锁来同步不同线程间的并发访问，同一时间点，只能有一个线程持有锁，也就是说在同一时间点，只能有一个线程能访问容器，这虽然保证多线程间的安全并发访问，但同时也导致对容器的访问变成串行化的了。

## 总结：

> Hashtable的任何操作都会把整个表锁住，是阻塞的。好处是总能获取最实时的更新，比如说线程A调用putAll写入大量数据，期间线程B调用get，线程B就会被阻塞，直到线程A完成putAll，因此线程B肯定能获取到线程A写入的完整数据。坏处是所有调用都要排队，效率较低。
> ConcurrentHashMap 是设计为非阻塞的。在更新时会局部锁住某部分数据，但不会把整个表都锁住。同步读取操作则是完全非阻塞的。好处是在保证合理的同步前提下，效率很高。坏处是严格来说读取操作不能保证反映最近的更新。例如线程A调用putAll写入大量数据，期间线程B调用get，则只能get到目前为止已经顺利插入的部分数据。
> 应该根据具体的应用场景选择合适的HashMap。



# [concurrentHashMap原理分析和总结（JDK1.8）](https://www.cnblogs.com/ylspace/p/12726672.html)

HashMap的线程安全版本，可以用来替换HashTable。在hash碰撞过多的情况下会将链表转化成红黑树。1.8版本的ConcurrentHashMap的实现与1.7版本有很大的差别，放弃了段锁的概念，借鉴了HashMap的数据结构：数组＋链表＋红黑树。ConcurrentHashMap不接受nullkey和nullvalue。

**数据结构：**
数组＋链表＋红黑树

**并发原理：**
cas乐观锁+synchronized锁

**加锁对象:**
数组每个位置的头节点

**方法分析：**
**put方法:**
先根据key的hash值定位桶位置，然后cas操作获取该位置头节点，接着使用synchronized锁锁住头节点，遍历该位置的链表或者红黑树进行插入操作。

稍微具体一点：

1.根据key的hash值定位到桶位置

2.判断if(table==null)，先初始化table。

3.判断if(table[i]==null),cas添加元素。成功则跳出循环，失败则进入下一轮for循环。

4.判断是否有其他线程在扩容table，有则帮忙扩容，扩容完成再添加元素。进入真正的put步骤

5.真正的put步骤。桶的位置不为空，遍历该桶的链表或者红黑树，若key已存在，则覆盖；不存在则将key插入到链表或红黑树的尾部。

并发问题：假如put操作时正好有别的线程正在对table数组(map)扩容怎么办？

   答：暂停put操作，先帮助其他线程对map扩容。

源码：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
final V putVal(K key, V value, boolean onlyIfAbsent) {
    if (key == null || value == null) throw new NullPointerException();
    //分散Hash
    int hash = spread(key.hashCode());
    int binCount = 0;
    //这里是一个死循环，可能的出口如下
    for (Node<K,V>[] tab = table;;) {
        Node<K,V> f; int n, i, fh;
        if (tab == null || (n = tab.length) == 0)
        //上面已经分析了初始化过程，初始化完成后继续执行死循环
            tab = initTable();
        //数组的第一个元素为空，则赋值
        else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {
        //这里使用了CAS，避免使用锁。如果CAS失败，说明该节点已经发生改变，
        //可能被其他线程插入了，那么继续执行死循环，在链尾插入。
            if (casTabAt(tab, i, null,
                         new Node<K,V>(hash, key, value, null)))
                //可能的出口一         
                break;                   // no lock when adding to empty bin
        }
        //如果tab正在resize，则帮忙一起执行resize
        //这里监测到的的条件是目标桶被设置成了FORWORD。如果桶没有设置为
        //FORWORD节点，即使正在扩容，该线程也无感知。
        else if ((fh = f.hash) == MOVED)
            tab = helpTransfer(tab, f);
        //执行put操作
        else {
            V oldVal = null;
            //这里请求了synchronized锁。这里要注意，不会出现
            //桶正在resize的过程中执行插入，因为桶resize的时候
            //也请求了synchronized锁。即如果该桶正在resize，这里会发生锁等待
            synchronized (f) {
                    //如果是链表的首个节点
                if (tabAt(tab, i) == f) {
                        //并且是一个用户节点，非Forwarding等节点
                    if (fh >= 0) {
                        binCount = 1;
                        for (Node<K,V> e = f;; ++binCount) {
                            K ek;
                            //找到相等的元素更新其value
                            if (e.hash == hash &&
                                ((ek = e.key) == key ||
                                 (ek != null && key.equals(ek)))) {
                                oldVal = e.val;
                                if (!onlyIfAbsent)
                                    e.val = value;
                                //可能的出口二
                                break;
                            }
                            //否则添加到链表尾部
                            Node<K,V> pred = e;
                            if ((e = e.next) == null) {
                                pred.next = new Node<K,V>(hash, key,
                                                          value, null);
                                //可能的出口三
                                break;
                            }
                        }
                    }
                    else if (f instanceof TreeBin) {
                        Node<K,V> p;
                        binCount = 2;
                        if ((p = ((TreeBin<K,V>)f).putTreeVal(hash, key,
                                                       value)) != null) {
                            oldVal = p.val;
                            if (!onlyIfAbsent)
                                p.val = value;
                        }
                    }
                }
            }
            if (binCount != 0) {
            //如果链表长度（碰撞次数）超过8，将链表转化为红黑树
                if (binCount >= TREEIFY_THRESHOLD)
                    treeifyBin(tab, i);
                if (oldVal != null)
                    return oldVal;
                break;
            }
        }
    }
    //见下面的分析
    addCount(1L, binCount);
    return null;
}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

**get方法:**
根据key的hash值定位，遍历链表或者红黑树，获取节点。

具体一点：

1.根据key的hash值定位到桶位置。

2.map是否初始化，没有初始化则返回null。否则进入3

3.定位到的桶位置是否有头结点，没有返回nul,否则进入4

4.是否有其他线程在扩容，有的话调用find方法查找。所以这里可以看出，扩容操作和get操作不冲突，扩容map的同时可以get操作。

5.若没有其他线程在扩容，则遍历桶对应的链表或者红黑树，使用equals方法进行比较。key相同则返回value,不存在则返回null.

并发问题：假如此时正好有别的线程正在对数组扩容怎么办？

   答：没关系，扩容的时候不会破坏原来的table，遍历任然可以继续，不需要加锁。

源码：

//不用担心get的过程中发生resize，get可能遇到两种情况
//1.桶未resize（无论是没达到阈值还是resize已经开始但是还未处理该桶），遍历链表
//2.在桶的链表遍历的过程中resize，上面的resize分析可以看出并未破坏原tab的桶的节点关系，遍历仍可以继续

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
//不用担心get的过程中发生resize，get可能遇到两种情况
//1.桶未resize（无论是没达到阈值还是resize已经开始但是还未处理该桶），遍历链表
//2.在桶的链表遍历的过程中resize，上面的resize分析可以看出并未破坏原tab的桶的节点关系，遍历仍可以继续
public V get(Object key) {
    Node<K,V>[] tab; Node<K,V> e, p; int n, eh; K ek;
    int h = spread(key.hashCode());
    if ((tab = table) != null && (n = tab.length) > 0 &&
        (e = tabAt(tab, (n - 1) & h)) != null) {
        if ((eh = e.hash) == h) {
            if ((ek = e.key) == key || (ek != null && key.equals(ek)))
                return e.val;
        }
        else if (eh < 0)
            return (p = e.find(h, key)) != null ? p.val : null;
        while ((e = e.next) != null) {
            if (e.hash == h &&
                ((ek = e.key) == key || (ek != null && key.equals(ek))))
                return e.val;
        }
    }
    return null;
}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

**扩容方法:**
什么情况会导致扩容？

   1.链表转换为红黑树时(链表节点个数达到8个可能会转换为红黑树)。如果转换时map长度小于64则直接扩容一倍，不转化为红黑树。如果此时map长度大于64，则不会扩容，直接进行链表转红黑树的操作。

   2.map中总节点数大于阈值(即大于map长度的0.75倍)时会进行扩容。

如何扩容？

   1.创建一个新的map，是原先map的两倍。注意此过程是单线程创建的

   2.复制旧的map到新的map中。注意此过程是多线程并发完成。（将map按照线程数量平均划分成多个相等区域，每个线程负责一块区域的复制任务）

扩容的具体过程：

   答：

   注：扩容操作是hashmap最复杂难懂的地方，博主也是看了很久才看懂个大概。一两句话真的很难说清楚，建议有时间还是看源码比较好。网上很少有人使用通俗易懂语言来描述扩容的机制。所以这里我尝试用自己的语言做一个简要的概括，描述一下大体的流程，供大家参考，如果觉得不错，可以点个赞，表示对博主的支持，谢谢。

   整体思路：扩容是并发扩容，也就是多个线程共同协作，把旧table中的链表一个个复制到新table中。

   1.给多个线程划分各自负责的区域。分配时是从后向前分配。假设table原先长度是64，有四个线程，则第一个到达的线程负责48-63这块内容的复制，第二个线程负责32-47，第三个负责16-31，第四个负责0-15。

   2.每个线程负责各自区域，复制时是一个个从后向前复制的。如第一个线程先复制下标为63的桶的复制。63复制完了接下来复制62，一直向前，直到完成自己负责区域的所有复制。

   3.完成自己区域的任务之后，还没有结束，这时还会判断一下其他线程负责区域有没有完成所有复制任务，如果没有完成，则可能还会去帮助其它线程复制。比如线程1先完成了，这时它看到线程2才做了一半，这时它会帮助线程2去做剩下一半任务。

   4.那么复制到底是怎么完成的呢？线程之间相互帮忙会导致混乱吗？

   5.首先回答上面第一个问题，我们知道，每个数组的每个桶存放的是一个链表（红黑树也可能，这里只讨论是链表情况）。复制的时候，先将链表拆分成两个链表。拆分的依据是链表中的每个节点的hash值和未扩容前数组长度n进行与运算。运算结果可能为0和1，所以结果为0的组成一个新链表，结果为1的组成一个新链表。为0的链表放在新table的 i 位置，为1的链表放在 新table的 i+n处。扩容后新table是原先table的两倍，即长度是2n。

   6.接着回答上面第二个问题，线程之间相互帮忙不会造成混乱。因为线程已完成复制的位置会标记该位置已完成，其他线程看到标记则会直接跳过。而对于正在执行的复制任务的位置，则会直接锁住该桶，表示这个桶我来负责，其他线程不要插手。这样，就不会有并发问题了。

   7.什么时候结束呢？每个线程参加复制前会将标记位sizeCtl加1，同样退出时会将sizeCtl减1，这样每个线程退出时，只要检查一下sizeCtl是否等于进入前的状态就知道是否全都退出了。最后一个退出的线程，则将就table的地址更新指向新table的地址，这样后面的操作就是新table的操作了。

总结：上面的一字一句都是自己看完源码手敲出来的，为了简单易懂，可能会将一些细节忽略，但是其中最重要的思想都还包含在上面。如果有疑问或者有错误的地方，欢迎在评论区留言。

扩容源码：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
final Node<K,V>[] helpTransfer(Node<K,V>[] tab, Node<K,V> f) {
    Node<K,V>[] nextTab; int sc;
    //nextTab为空时，则说明扩容已经完成
    if (tab != null && (f instanceof ForwardingNode) &&
        (nextTab = ((ForwardingNode<K,V>)f).nextTable) != null) {
        int rs = resizeStamp(tab.length);
        while (nextTab == nextTable && table == tab &&
               (sc = sizeCtl) < 0) {
            if ((sc >>> RESIZE_STAMP_SHIFT) != rs || sc == rs + 1 ||
                sc == rs + MAX_RESIZERS || transferIndex <= 0)
                break;
            if (U.compareAndSwapInt(this, SIZECTL, sc, sc + 1)) {
                transfer(tab, nextTab);
                break;
            }
        }
        return nextTab;
    }
    return table;
}
//复制元素到nextTab
transfer(Node<K,V>[] tab, Node<K,V>[] nextTab) {
    int n = tab.length, stride;
    //NCPU为CPU核心数，每个核心均分复制任务，如果均分小于16个
    //那么以16为步长分给处理器：例如0-15号给处理器1，16-32号分给处理器2。处理器3就不用接任务了。
    if ((stride = (NCPU > 1) ? (n >>> 3) / NCPU : n) < MIN_TRANSFER_STRIDE)
        stride = MIN_TRANSFER_STRIDE; // subdivide range
     //如果nextTab为空则初始化为原tab的两倍，这里只会时单线程进得来，因为这初始化了nextTab，
     //addcount里面判断了nextTab为空则不执行扩容任务
    if (nextTab == null) {            // initiating
        try {
            @SuppressWarnings("unchecked")
            Node<K,V>[] nt = (Node<K,V>[])new Node<?,?>[n << 1];
            nextTab = nt;
        } catch (Throwable ex) {      // try to cope with OOME
            sizeCtl = Integer.MAX_VALUE;
            return;
        }
        nextTable = nextTab;
        transferIndex = n;
    }
    int nextn = nextTab.length;
    //构造一个forword节点
    ForwardingNode<K,V> fwd = new ForwardingNode<K,V>(nextTab);
    boolean advance = true;
    boolean finishing = false; // to ensure sweep before committing nextTab
    for (int i = 0, bound = 0;;) {
        Node<K,V> f; int fh;
        while (advance) {
            int nextIndex, nextBound;
            if (--i >= bound || finishing)
                advance = false;
            else if ((nextIndex = transferIndex) <= 0) {
                i = -1;
                advance = false;
            }
            else if (U.compareAndSwapInt
                     (this, TRANSFERINDEX, nextIndex,
                      nextBound = (nextIndex > stride ?
                                   nextIndex - stride : 0))) {
                bound = nextBound;
                i = nextIndex - 1;
                advance = false;
            }
        }
        if (i < 0 || i >= n || i + n >= nextn) {
            int sc;
            if (finishing) {
                nextTable = null;
                table = nextTab;
                // sizeCtl＝nextTab.length*0.75=2*tab.length*0.75=tab.length*1.5!!!
                sizeCtl = (n << 1) - (n >>> 1);
                return;
            }
            //sc - 1表示当前线程完成了扩容任务，sizeCtl的线程数要－1
            if (U.compareAndSwapInt(this, SIZECTL, sc = sizeCtl, sc - 1)) {
                    //还有线程在扩容,就不能设置finish为true
                if ((sc - 2) != resizeStamp(n) << RESIZE_STAMP_SHIFT)
                    return;
                finishing = advance = true;
                i = n; // recheck before commit
            }
        }
        else if ((f = tabAt(tab, i)) == null)
            advance = casTabAt(tab, i, null, fwd);
        else if ((fh = f.hash) == MOVED)
            advance = true; // already processed
        else {
        //这保证了不会出现该桶正在resize又执行put操作的情况
            synchronized (f) {
                if (tabAt(tab, i) == f) {
                    Node<K,V> ln, hn;
                    if (fh >= 0) {
                        int runBit = fh & n;
                        Node<K,V> lastRun = f;
                        for (Node<K,V> p = f.next; p != null; p = p.next) {
                            int b = p.hash & n;
                            //这里尽量少的复制链表节点，从lastrun到链尾的这段链表段，无需复制节点，直接复用
                            if (b != runBit) {
                                runBit = b;
                                lastRun = p;
                            }
                        }
                        if (runBit == 0) {
                            ln = lastRun;
                            hn = null;
                        }
                        else {
                            hn = lastRun;
                            ln = null;
                        }
                        //其他节点执行复制
                        for (Node<K,V> p = f; p != lastRun; p = p.next) {
                            int ph = p.hash; K pk = p.key; V pv = p.val;
                            if ((ph & n) == 0)
                                ln = new Node<K,V>(ph, pk, pv, ln);
                            else
                                hn = new Node<K,V>(ph, pk, pv, hn);
                        }
                        setTabAt(nextTab, i, ln);
                        setTabAt(nextTab, i + n, hn);
                        setTabAt(tab, i, fwd);
                        advance = true;
                    }
                    else if (f instanceof TreeBin) {
                        TreeBin<K,V> t = (TreeBin<K,V>)f;
                        TreeNode<K,V> lo = null, loTail = null;
                        TreeNode<K,V> hi = null, hiTail = null;
                        int lc = 0, hc = 0;
                        for (Node<K,V> e = t.first; e != null; e = e.next) {
                            int h = e.hash;
                            TreeNode<K,V> p = new TreeNode<K,V>
                                (h, e.key, e.val, null, null);
                            if ((h & n) == 0) {
                                if ((p.prev = loTail) == null)
                                    lo = p;
                                else
                                    loTail.next = p;
                                loTail = p;
                                ++lc;
                            }
                            else {
                                if ((p.prev = hiTail) == null)
                                    hi = p;
                                else
                                    hiTail.next = p;
                                hiTail = p;
                                ++hc;
                            }
                        }
                        ln = (lc <= UNTREEIFY_THRESHOLD) ? untreeify(lo) :
                            (hc != 0) ? new TreeBin<K,V>(lo) : t;
                        hn = (hc <= UNTREEIFY_THRESHOLD) ? untreeify(hi) :
                            (lc != 0) ? new TreeBin<K,V>(hi) : t;
                        setTabAt(nextTab, i, ln);
                        setTabAt(nextTab, i + n, hn);
                        setTabAt(tab, i, fwd);
                        advance = true;
                    }
                }
            }
        }
    }
}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

**initTable方法：**

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
private final Node<K,V>[] initTable() {
    Node<K,V>[] tab; int sc;
    //如果table为null或者长度为0， //则一直循环试图初始化table(如果某一时刻别的线程将table初始化好了，那table不为null，
该//线程就结束while循环)。
    while ((tab = table) == null || tab.length == 0) {
        //如果sizeCtl小于0，
        //即有其他线程正在初始化或者扩容，执行Thread.yield()将当前线程挂起，让出CPU时间，
        //该线程从运行态转成就绪态。
        //如果该线程从就绪态转成运行态了，此时table可能已被别的线程初始化完成，table不为
        //null，该线程结束while循环。
        if ((sc = sizeCtl) < 0)
            Thread.yield(); // lost initialization race; just spin
        //如果此时sizeCtl不小于0，即没有别的线程在做table初始化和扩容操作，
        //那么该线程就会调用Unsafe的CAS操作compareAndSwapInt尝试将sizeCtl的值修改成
        //-1(sizeCtl=-1表示table正在初始化，别的线程如果也进入了initTable方法则会执行
        //Thread.yield()将它的线程挂起 让出CPU时间)，
        //如果compareAndSwapInt将sizeCtl=-1设置成功 则进入if里面，否则继续while循环。
        else if (U.compareAndSwapInt(this, SIZECTL, sc, -1)) {
            try {
                //再次确认当前table为null即还未初始化，这个判断不能少。
                if ((tab = table) == null || tab.length == 0) {
                    //如果sc(sizeCtl)大于0，则n=sc，否则n=默认的容量大
                    小16，
                    //这里的sc=sizeCtl=0，即如果在构造函数没有指定容量
                    大小，
                    //否则使用了有参数的构造函数，sc=sizeCtl=指定的容量大小。
                    int n = (sc > 0) ? sc : DEFAULT_CAPACITY;
                    @SuppressWarnings("unchecked")
                    //创建指定容量的Node数组(table)。
                    Node<K,V>[] nt = (Node<K,V>[])new Node<?,?>[n];
                    table = tab = nt;
                    //计算阈值，n - (n >>> 2) = 0.75n当ConcurrentHashMap储存的键值对数量
                    //大于这个阈值，就会发生扩容。
                    //这里的0.75相当于HashMap的默认负载因子，可以发现HashMap、Hashtable如果
                    //使用传入了负载因子的构造函数初始化的话，那么每次扩容，新阈值都是=新容
                    //量 * 负载因子，而ConcurrentHashMap不管使用的哪一种构造函数初始化，
                    //新阈值都是=新容量 * 0.75。
                    sc = n - (n >>> 2);
                }
            } finally {
                sizeCtl = sc;
            }
            break;
        }
    }
    return tab;
}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

![img](https://img2020.cnblogs.com/blog/929388/202004/929388-20200418164459611-558009030.png)

 

 

简单来说就是：

1.多线程使用cas乐观锁竞争tab数组初始化的权力。

2.线程竞争成功，则初始化tab数组。

3.竞争失败的线程则让出cpu（从运行态到就绪态）。等再次得到cpu时，发现tab！=null，即已经有线程初始化tab数组了，则退出即可。

**remove方法：**

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
public V remove(Object key) {
    return replaceNode(key, null, null);
}
    
final V replaceNode(Object key, V value, Object cv) {
    //计算需要移除的键key的哈希地址。
    int hash = spread(key.hashCode());
    //遍历table。
    for (Node<K,V>[] tab = table;;) {
        Node<K,V> f; int n, i, fh;
        //table为空，或者键key所在的bucket为空，则跳出循环返回。
        if (tab == null || (n = tab.length) == 0 ||
            (f = tabAt(tab, i = (n - 1) & hash)) == null)
            break;
        //如果当前table正在扩容，则调用helpTransfer方法，去协助扩容。
        else if ((fh = f.hash) == MOVED)
            tab = helpTransfer(tab, f);
        else {
            V oldVal = null;
            boolean validated = false;
            //将键key所在的bucket加锁。
            synchronized (f) {
                if (tabAt(tab, i) == f) {
                    //bucket头节点的哈希地址大于等于0，为链表。
                    if (fh >= 0) {
                        validated = true;
                        //遍历链表。
                        for (Node<K,V> e = f, pred = null;;) {
                            K ek;
                            //找到哈希地址、键key相同的节点，进行移除。
                            if (e.hash == hash &&
                                ((ek = e.key) == key ||
                                 (ek != null && key.equals(ek)))) {
                                V ev = e.val;
                                if (cv == null || cv == ev ||
                                    (ev != null && cv.equals(ev))) {
                                    oldVal = ev;
                                    if (value != null)
                                        e.val = value;
                                    else if (pred != null)
                                        pred.next = e.next;
                                    else
                                        setTabAt(tab, i, e.next);
                                }
                                break;
                            }
                            pred = e;
                            if ((e = e.next) == null)
                                break;
                        }
                    }
                    //如果bucket的头节点小于0，即为红黑树。
                    else if (f instanceof TreeBin) {
                        validated = true;
                        TreeBin<K,V> t = (TreeBin<K,V>)f;
                        TreeNode<K,V> r, p;
                        //找到节点，并且移除。
                        if ((r = t.root) != null &&
                            (p = r.findTreeNode(hash, key, null)) != null) {
                            V pv = p.val;
                            if (cv == null || cv == pv ||
                                (pv != null && cv.equals(pv))) {
                                oldVal = pv;
                                if (value != null)
                                    p.val = value;
                                else if (t.removeTreeNode(p))
                                    setTabAt(tab, i, untreeify(t.first));
                            }
                        }
                    }
                }
            }
            //调用addCount方法，将当前ConcurrentHashMap存储的键值对数量-1。
            if (validated) {
                if (oldVal != null) {
                    if (value == null)
                        addCount(-1L, -1);
                    return oldVal;
                }
                break;
            }
        }
    }
    return null;
}
 
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

![img](https://img2020.cnblogs.com/blog/929388/202004/929388-20200418164617182-1467191747.png)

 

 

**总结：**
**1.扩容完成后做了什么？**
nextTable=null  //新数组的引用置为null

tab=nextTab   //旧数组的引用指向新数组

sizeCtl=0.75n  //扩容阈值重新设置，数组元素个数超过这个阈值就会触发扩容

**2.concurrentHashMap中设置为volatile的变量有哪些？**
Node,nextTable,baseCount,sizeCtl

**3.单线程初始化，多线程扩容**
**4.什么时候触发扩容？**
   1.链表转换为红黑树时(链表节点个数达到8个可能会转换为红黑树)，table数组长度小于64。

   2.数组中总节点数大于阈值(数组长度的0.75倍)

**5.如何保证初始化nextTable时是单线程的？**
所有调用transfer的方法（例如helperTransfer、addCount)几乎都预先判断了nextTab!=null,而nextTab只会在transfer方法中初始化，保证了第一个进来的线程初始化之后其他线程才能进入。

**6.get操作时扩容怎么办？**
**7.put操作扩容时怎么办？**
**8.如何hash定位？**
答：h^(h>>>16)&0x7fffffff，即先将hashCode的高16位和低16位异或运算，这个做目的是为了让hash值更加随机。和0x7fffffff相与运算是为了得到正数，因为负数的hash有特殊用途，如-1表示forwardingNode(上面说的表示该位置正在扩容)，-2表示是一颗红黑树。

**9.forwardingNode有什么内容？**
nextTable  //扩容时执向新table的引用

hash=moved //moved是常量-1，正在扩容的标记

**10.扩容前链表和扩容后链表顺序问题**

![img](https://img2020.cnblogs.com/blog/929388/202004/929388-20200418164752323-1664929911.png)

 

 


语言描述很难解释，直接看图，hn指向最后同一类的第一个节点，hn->6->7,此时ln->null,接着从头开始遍历链表；

第一个节点：由于1的hash&n==1，所以应该放到hn指向的链表，采用头插法。hn->1->6->7

第二个节点：同样,hn->2->1->6->7

第三个节点：hash&n==0,所以应该插入到ln链表，采用头插法，ln->3

.....

最后：

ln->5->3 //复制到新table的i位置处

hn->2->1->6->7  //复制到新table的i+n位置处

可以看到ln中所有元素都是后来一个个插入进来的，所以都是逆序

而hn中6->7是初始赋予的所以顺序，而其1，2是后来插入的，所以逆序。

总结：有部分顺序，有部分逆序。看情况