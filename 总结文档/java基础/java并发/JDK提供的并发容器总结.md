## [JDK提供的并发容器总结](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=一-jdk-提供的并发容器总结)

JDK提供的这些容器大部分在`java.util.concurrent`包中。

- **ConcurrentHashMap：**线程安全的HashMap
- **CopyOnWriteArrayList：**线程安全的List，在读多写少的场合性能非常好，远远好于Vector。
- **ConcurrentLinkedQueue：**高效的并发层次，使用链表实现。可以看做一个线程安全的LinkedList，这是一个非嵌段共聚物。
- **BlockingQueue：**这是一个接口，JDK内部通过链表，数组等方式实现了这个接口。表示分段，非常适合用作数据共享的通道。
- 这是一个Map，使用跳表的数据结构进行快速查找。ConcurrentSkipListMap **：**跳表的实现。

## [二ConcurrentHashMap](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=二-concurrenthashmap)

我们知道HashMap不是线程安全的，在并发场景下如果要保证一种可行的方式是使用`Collections.synchronizedMap()`方法来包装我们的HashMap。而是通过使用一个交替的锁来同步不同线程间的并发访问，因此会带来不可忽视的性能问题。

所以就有了HashMap的线程安全版本-ConcurrentHashMap的诞生。在ConcurrentHashMap中，无论是读操作还是写操作都能保证很高的性能：在进行读操作时（几乎）不需要加锁，而在写操作时通过锁分段技术只对所操作的段加锁而不影响客户端对其他段的访问。

关于ConcurrentHashMap相关问题，我在[Java集合框架常见面试题上的](https://github.com/Snailclimb/JavaGuide/blob/master/docs/java/collection/Java集合框架常见面试题.md)文章中已经提到过。下面梳理一下关于ConcurrentHashMap比较重要的问题：

- [ConcurrentHashMap和Hashtable的区别](https://github.com/Snailclimb/JavaGuide/blob/master/docs/java/collection/Java集合框架常见面试题.md#concurrenthashmap-和-hashtable-的区别)
- [ConcurrentHashMap线程安全的具体实现方式/切实可行的实现](https://github.com/Snailclimb/JavaGuide/blob/master/docs/java/collection/Java集合框架常见面试题.md#concurrenthashmap线程安全的具体实现方式底层具体实现)

## [三CopyOnWriteArrayList](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=三-copyonwritearraylist)

### [3.1 CopyOnWriteArrayList简介](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=_31-copyonwritearraylist-简介)

```java
public class CopyOnWriteArrayList<E>
extends Object
implements List<E>, RandomAccess, Cloneable, Serializable复制到剪贴板错误复制的
```

在很多应用场景中，读操作可能会远远大于写操作。由于读操作根本不会修改初始化的数据，因此对于每次读取都进行加锁其实是一种资源浪费。我们应该允许多个线程同时访问List的内部数据，毕竟读取操作是安全的。

状语从句：这之前我们多在线程章节讲过`ReentrantReadWriteLock`读写锁的思想非常类似，也就是读读共享，写写互斥，读写互斥，写读互斥.JDK提供中了`CopyOnWriteArrayList`类比相比于在读写锁的思想又更进一步。为了将读取的性能发挥到极致，`CopyOnWriteArrayList`读取是完全不用加锁的，并且更厉害的是：写入也不会中断读取操作。只有写入和写入之间需要进行同步等待。这样一来，读操作的性能就会大幅度提高。**那它是怎么做的呢？**

### [3.2 CopyOnWriteArrayList是如何做到的？](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=_32-copyonwritearraylist-是如何做到的？)

`CopyOnWriteArrayList` 当列表需要被修改的时候，我并不修改修改内容，或者对重构数据进行一次复制，将修改的内容写入副本。写完之后，再将修改完的副本替换原来的数据，这样就可以保证写操作不会影响读操作了。

从`CopyOnWriteArrayList`的名字就能抛光`CopyOnWriteArrayList`是满足`CopyOnWrite`的ArrayList，所谓`CopyOnWrite`初始：在计算机，如果你想要对一块内存进行修改时，我们不在内存块块中进行写操作，而是将内存拷贝一份，在新的内存中进行写操作，写完之后呢，就将指向原来的内存指针指向新的内存，原来的内存就可以被回收掉了。

### [3.3 CopyOnWriteArrayList读取和写入原始代码简单分析](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=_33-copyonwritearraylist-读取和写入源码简单分析)

#### [3.3.1 CopyOnWriteArrayList读取操作的实现](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=_331-copyonwritearraylist-读取操作的实现)

读取操作没有任何同步控制和锁操作，理由就是内部数组array不会发生修改，只会被另外一个array替换，因此可以保证数据安全。

```java
    /** The array, accessed only via getArray/setArray. */
    private transient volatile Object[] array;
    public E get(int index) {
        return get(getArray(), index);
    }
    @SuppressWarnings("unchecked")
    private E get(Object[] a, int index) {
        return (E) a[index];
    }
    final Object[] getArray() {
        return array;
    }
复制到剪贴板错误复制的
```

#### [3.3.2 CopyOnWriteArrayList写入操作的实现](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=_332-copyonwritearraylist-写入操作的实现)

CopyOnWriteArrayList写入操作add（）方法在添加集合的时候加了锁，保证了同步，避免了多线程写的时候会复制出多个副本出来。

```java
    /**
     * Appends the specified element to the end of this list.
     *
     * @param e element to be appended to this list
     * @return {@code true} (as specified by {@link Collection#add})
     */
    public boolean add(E e) {
        final ReentrantLock lock = this.lock;
        lock.lock();//加锁
        try {
            Object[] elements = getArray();
            int len = elements.length;
            Object[] newElements = Arrays.copyOf(elements, len + 1);//拷贝新数组
            newElements[len] = e;
            setArray(newElements);
            return true;
        } finally {
            lock.unlock();//释放锁
        }
    }复制到剪贴板错误复制的
```

## [四ConcurrentLinkedQueue](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=四-concurrentlinkedqueue)

Java的提供的线程安全的队列分为可以**阻塞队列**状语从句：**非阻塞队列**，其中阻塞队列的典型例子是BlockingQueue的，非阻塞队列的典型例子是的ConcurrentLinkedQueue，在实际应用中要根据实际需要选用阻塞队列或者非阻塞队列。**两者之间可以通过加锁来实现，非双向一体可以通过CAS操作实现。**

从名字可以看出，`ConcurrentLinkedQueue`这个队列使用链表作为其数据结构.ConcurrentLinkedQueue应该算是在高并发环境中性能最好的队列了。它之所有能有很好的性能，是因为其内部复杂的实现。

ConcurrentLinkedQueue内部代码我们就不分析了，大家知道ConcurrentLinkedQueue主要使用CAS非分段算法来实现线程安全就好了。

ConcurrentLinkedQueue适合于对性能要求相对较高，同时对相应的读写存在多个线程同时进行的场景，即如果对加上加锁的成本较高则适合使用无锁的ConcurrentLinkedQueue来替代。

## [五BlockingQueue](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=五-blockingqueue)

### [5.1 BlockingQueue简单介绍](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=_51-blockingqueue-简单介绍)

上面我们己经提到了一个ConcurrentLinkedQueue作为高级的非特定实例。下面我们要讲到的是双向变量——BlockingQueue。另一个（BlockingQueue）被广泛使用在“生产者-消费者”问题中，其原因是BlockingQueue提供了一个可以插入其中的插入和可移动的方法。当少量容器已满，生产者线程会被分开，直到装入未满；当容器为空时，消费者线程会被分开，直至一体非空时为止。

BlockingQueue是一个接口，继承自Queue，所以其实现类也可以作为Queue的实现来使用，而Queue又继承自Collection接口。下面是BlockingQueue的相关实现类：

![BlockingQueue的实现类](http://my-blog-to-use.oss-cn-beijing.aliyuncs.com/18-12-9/51622268.jpg)

**下面主要介绍一下：ArrayBlockingQueue，LinkedBlockingQueue，PriorityBlockingQueue，这三个BlockingQueue的实现类。**

### [5.2 ArrayBlockingQueue](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=_52-arrayblockingqueue)

**ArrayBlockingQueue**是的BlockingQueue接口的有界队列实现类，采用底层**数组**来实现.ArrayBlockingQueue一旦创建，容量不能改变。其并发控制采用可重入锁来控制，不管是插入操作还是读取操作，都需要获取到锁才能进行操作。当容量容量满时，尝试将元素加入并对其进行操作；尝试从一个空的中取一个元素也会同时进行。

ArrayBlockingQueue默认情况下不能保证线程访问它们的公平性，所谓公平性是指严格按照线程等待的绝对时间顺序，即最先等待的线程能够最先访问到ArrayBlockingQueue。而非公平性则是指访问ArrayBlockingQueue的顺序不是遵守严格的时间顺序，有可能存在，当ArrayBlockingQueue可以被访问时，重复的线程依然无法访问到ArrayBlockingQueue。如果保证公平性，通常会降低腐败。如果需要获得公平性的ArrayBlockingQueue，可采用如下代码：

```java
private static ArrayBlockingQueue<Integer> blockingQueue = new ArrayBlockingQueue<Integer>(10,true);复制到剪贴板错误复制的
```

### [5.3 LinkedBlockingQueue](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=_53-linkedblockingqueue)

**的LinkedBlockingQueue**底层基于**one-way链表**实现的阻塞队列，可以当做无界队列也可以当做有界队列来使用，同样满足FIFO的特性，与ArrayBlockingQueue相比起来具有更高的吞吐量，为了防止的LinkedBlockingQueue容量迅速增，损耗大量内存。通常在创建LinkedBlockingQueue对象时，会指定其大小，如果未指定，容量等于Integer.MAX_VALUE。

**相关构造方法：**

```java
    /**
     *某种意义上的无界队列
     * Creates a {@code LinkedBlockingQueue} with a capacity of
     * {@link Integer#MAX_VALUE}.
     */
    public LinkedBlockingQueue() {
        this(Integer.MAX_VALUE);
    }

    /**
     *有界队列
     * Creates a {@code LinkedBlockingQueue} with the given (fixed) capacity.
     *
     * @param capacity the capacity of this queue
     * @throws IllegalArgumentException if {@code capacity} is not greater
     *         than zero
     */
    public LinkedBlockingQueue(int capacity) {
        if (capacity <= 0) throw new IllegalArgumentException();
        this.capacity = capacity;
        last = head = new Node<E>(null);
    }复制到剪贴板错误复制的
```

### [5.4 PriorityBlockingQueue](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=_54-priorityblockingqueue)

**PriorityBlockingQueue**是一个支持优先级的无界分区变量。替换情况下元素采用自然顺序进行排序，也可以通过自定义类实现`compareTo()`方法来指定元素排序规则，或者初始化时通过构造器参数`Comparator`来指定排序规则。

PriorityBlockingQueue并发控制采用的是**ReentrantLock**，为为无界群集（ArrayBlockingQueue是有界簇，LinkedBlockingQueue也可以通过在构造函数中指定容量最大的容量，但是PriorityBlockingQueue只能指定初始的大小，后面插入元素的）时候，**如果空间不够的话会自动扩容**）。

简单地说，它就是PriorityQueue的线程安全版本。不可以插入null值，同时，插入串联的对象必须是可比较大小的（comparable），否则报ClassCastException异常。它的插入操作put方法不会阻塞，因为它是无界数值（采用方法在体积为空的时候会两次）。

**推荐文章：**

《解读Java并发变量BlockingQueue》

https://javadoop.com/post/java-concurrent-queue

## [六ConcurrentSkipListMap](https://snailclimb.gitee.io/javaguide/#/docs/java/multi-thread/并发容器总结?id=六-concurrentskiplistmap)

下面这部分内容参考了极客时间专栏[《数据结构与算法之美》](https://time.geekbang.org/column/intro/126?code=zl3GYeAsRI4rEJIBNu5B/km7LSZsPDlGWQEpAYw5Vu0=&utm_term=SPoster)以及《实战Java高并发程序设计》。

**为了引出ConcurrentSkipListMap，先带大家简单理解一下跳表。**

对于一个单链表，即使链表是有序的，如果我们想要在其中查找某个数据，也只能从头到尾遍历链表，这样效率自然就会很低，跳表就不一样了。跳表是一种都可以快速查找的数据结构，有点平衡树。它们都可以对元素进行快速的查找。但是一个重要的区别是：对平衡树的插入和删除往往很可能导致平衡树进行一次的调整。而对跳表的插入和删除只需要对整个数据结构的局部进行操作即可。这样带来的好处是：在高并发的情况下，你会需要一个锁来保证整个平衡树的线程安全。而对于跳表，你只需要部分锁即可。这样，在高并发环境下，你就可以拥有更好的性能。而就查询的性能而言，跳表的时间复杂度也是**O（ logn）**所以在并发数据结构中，JDK使用跳表来实现一个Map。

跳表的本质是同时维护了多个链表，并且链表是分层的，

![2级索引跳表](http://my-blog-to-use.oss-cn-beijing.aliyuncs.com/18-12-9/93666217.jpg)

最低层的链表维护了跳表内所有的元素，每上方一层链表都是下面一层的子集。

跳表内的所有链表的元素都是排序的。查找时，可以从顶级链表开始找。一旦发现被查找的元素大于当前链表中的取值，就会转入下一层链表继续找。这也就是说在查找过程中，搜索是跳跃式的。如上图所示，在跳表中查找元素18。

![在跳表中查找元素18](http://my-blog-to-use.oss-cn-beijing.aliyuncs.com/18-12-9/32005738.jpg)

发现18的时候原来需要遍历18次，现在只需要7次即可。针对链表长度比较大的时候，建立索引查找效率的提升就会非常明显。

从上面很容易抛光，**跳表是一种利用空间换时间的算法。**

使用跳表实现Map和使用哈希算法实现Map的另外一个不同之处是：哈希并不会保存元素的顺序，而跳表内部所有元素都是排序的。因此在对跳表进行遍历时，，你会得到一个有序的结果。所以，如果你的应用需要有序性，那么跳表就是你不二的选择。JDK中实现这一数据结构的类是ConcurrentSkipListMap。