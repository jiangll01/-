####  java各种锁

#####  1、 synchronized

[https://www.cnblogs.com/flyuz/p/11378491.html#%E7%9C%8B%E8%BF%87hashmap%E6%BA%90%E7%A0%81%E5%90%97%E7%9F%A5%E9%81%93%E5%8E%9F%E7%90%86%E5%90%97](https://www.cnblogs.com/flyuz/p/11378491.html#看过hashmap源码吗知道原理吗)

https://www.cnblogs.com/jyroy/p/11365935.html

https://msd.misuland.com/pd/3181438578597041480

http://www.mamicode.com/info-detail-2670950.html

https://www.jb51.net/article/160827.htm



## 自旋锁 VS 适应性自旋锁[#](https://www.cnblogs.com/jyroy/p/11365935.html#idx_1)

在介绍自旋锁前，我们需要介绍一些前提知识来帮助大家明白自旋锁的概念。

阻塞或唤醒一个Java线程需要操作系统切换CPU状态来完成，这种状态转换需要耗费处理器时间。如果同步代码块中的内容过于简单，状态转换消耗的时间有可能比用户代码执行的时间还要长。

在许多场景中，同步资源的锁定时间很短，为了这一小段时间去切换线程，线程挂起和恢复现场的花费可能会让系统得不偿失。如果物理机器有多个处理器，能够让两个或以上的线程同时并行执行，我们就可以让后面那个请求锁的线程不放弃CPU的执行时间，看看持有锁的线程是否很快就会释放锁。

![img](https://img-blog.csdnimg.cn/2018112210212894.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2F4aWFvYm9nZQ==,size_16,color_FFFFFF,t_70)

自旋锁本身是有缺点的，它不能代替阻塞。自旋等待虽然避免了线程切换的开销，但它要占用处理器时间。如果锁被占用的时间很短，自旋等待的效果就会非常好。反之，如果锁被占用的时间很长，那么自旋的线程只会白浪费处理器资源。所以，自旋等待的时间必须要有一定的限度，如果自旋超过了限定次数（默认是10次，可以使用-XX:PreBlockSpin来更改）没有成功获得锁，就应当挂起线程。

synchronized 同步锁一共包含四种状态：无锁、偏向锁、轻量级锁、重量级锁，它会随着竞争情况逐渐升级。synchronized 同步锁可以升级但是不可以降级，目的是为了提高获取锁和释放锁的效率。

对象锁：使用 synchronized 修饰非静态的方法以及 synchronized(this) 同步代码块使用的锁是对象锁。

类锁：使用 synchronized 修饰静态的方法以及 synchronized(class) 同步代码块使用的锁是类锁。

私有锁：在类内部声明一个私有属性如private Object lock，在需要加锁的同步块使用 synchronized(lock）

它们的特性：

- 对象锁具有可重入性。

- 当一个线程获得了某个对象的对象锁，则该线程仍然可以调用其他任何需要该对象锁的 synchronized 方法或 synchronized(this) 同步代码块。

- 当一个线程访问某个对象的一个 synchronized(this) 同步代码块时，其他线程对该对象中所有其它 synchronized(this) 同步代码块的访问将被阻塞，因为访问的是同一个对象锁。

- 每个类只有一个类锁，但是类可以实例化成对象，因此每一个对象对应一个对象锁。

- 类锁和对象锁不会产生竞争。

- 私有锁和对象锁也不会产生竞争。

- 使用私有锁可以减小锁的细粒度，减少由锁产生的开销。

  

ReentrantLock 是一个独占/排他锁。相对于 synchronized，它更加灵活。但是需要自己写出加锁和解锁的过程。它的灵活性在于它拥有很多特性。

ReentrantLock 需要显示地进行释放锁。特别是在程序异常时，synchronized 会自动释放锁，而 ReentrantLock 并不会自动释放锁，所以必须在 finally 中进行释放锁。 它的特性：

- 公平性：支持公平锁和非公平锁。默认使用了非公平锁。
- 可重入
- 可中断：相对于 synchronized，它是可中断的锁，能够对中断作出响应。
- 超时机制：超时后不能获得锁，因此不会造成死锁。

ReentrantLock 是很多类的基础，例如 ConcurrentHashMap 内部使用的 Segment 就是继承 ReentrantLock，CopyOnWriteArrayList 也使用了 ReentrantLock。



**ReentrantReadWriteLock**拥有读锁(ReadLock)和写锁(WriteLock)，读锁是一个共享锁，写锁是一个排他锁。

它的特性：

- 公平性：支持公平锁和非公平锁。默认使用了非公平锁。
- 可重入：读线程在获取读锁之后能够再次获取读锁。写线程在获取写锁之后能够再次获取写锁，同时也可以获取读锁（锁降级）。
- 锁降级：先获取写锁，再获取读锁，然后再释放写锁的过程。锁降级是为了保证数据的可见性。

上面提到的 ReentrantLock、ReentrantReadWriteLock 都是基于 AbstractQueuedSynchronizer (AQS)，而 AQS 又是基于 CAS。CAS 的全称是 Compare And Swap（比较与交换），它是一种无锁[算法](http://msd.misuland.com/pd/3181438578597041290)。 synchronized、Lock 都采用了悲观锁的机制，而 CAS 是一种乐观锁的实现。

CAS 的特性：

- 通过调用 JNI 的代码实现
- 非阻塞算法
- 非独占锁

CAS 存在的问题：

- ABA

- 循环时间长开销大

- 只能保证一个共享变量的原子操作

  

Condition 用于替代传统的 Object 的 wait()、notify() 实现线程间的协作。

在 Condition 对象中，与 wait、notify、notifyAll 方法对应的分别是 await、signal 和 signalAll。

Condition 必须要配合 Lock 一起使用，一个 Condition 的实例必须与一个 Lock 绑定。

它的特性：

- 一个 Lock 对象可以创建多个 Condition 实例，所以可以支持多个等待队列。
- Condition 在使用 await、signal 或 signalAll 方法时，必须先获得 Lock 的 lock()
- 支持响应中断
- 支持的定时唤醒功能

Semaphore、CountDownLatch、CyclicBarrier 都是并发工具类。 Semaphore 可以指定多个线程同时访问某个资源，而 synchronized 和 ReentrantLock 都是一次只允许一个线程访问某个资源。由于 Semaphore 适用于限制访问某些资源的线程数目，因此可以使用它来做限流。

Semaphore 并不会实现数据的同步，数据的同步还是需要使用 synchronized、Lock 等实现。

它的特性：

- 基于 AQS 的共享模式
- 公平性：支持公平模式和非公平模式。默认使用了非公平模式。

CountDownLatch 可以看成是一个倒计数器，它允许一个或多个线程等待其他线程完成操作。因此，CountDownLatch 是共享锁。 CountDownLatch 的 countDown() 方法将计数器减1，await() 方法会阻塞当前线程直到计数器变为0。