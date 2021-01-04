####  java线程池的知识学习总结

##### 一、困惑自己的问题

``` java
@RestController
    public class InstanceController {
        @Autowired
        instanceService instanceService;
        @GetMapping("/hello")
        public String Hello(){
            School school = new School();
            System.out.println(school.hashCode());
            System.out.println(instanceService.hashCode());
            return "呵呵";
        }
}
(tomcat的请求进来后，new出来的线程池是属于进入的线程的？)
通过查看hashcode的值发现，new出来的对象的hash值不一致，说明每个请求进来内存中创建了一个对象，如果线程太多，线程池一直不销毁的话，最后导致oom。spring管理的bean的hash值是一致的，内存中只存在一个spring管理的对象。
```

#####  二、线程池的学习总结

​	阿里规范中要求线程资源必须通过线程池提供，不允许在应用中自行显式创建线程，阿里规范中规定，线程池不允许使用Executors创建，而是通过ThreadPoolExecutor的方式创建，这样的处理方式能让编写代码的攻城狮更加明确线程池的运行规则，规避资源耗尽（OOM）的风险.之所以会出现这样的规范，是因为jdk已经封装好的线程池存在潜在风险：

- FixedThreadPool 和 SingleThreadPool：
   允许的请求队列长度为 Integer.MAX_VALUE ，会堆积大量请求OOM
- CachedThreadPool 和 ScheduledThreadPool：
   允许的创建线程数量为 Integer.MAX_VALUE，可能会创建大量线程OOM

所以从系统安全角度出发，原则上都应该自己手动创建线程池

``` java
public ThreadPoolExecutor(int corePoolSize,//核心线程数
                              int maximumPoolSize, //最大线程数
                              long keepAliveTime,// 当线程数大于核心时，多于的空闲线程最多存活
                              TimeUnit unit,
                              BlockingQueue<Runnable> workQueue,
                              ThreadFactory threadFactory,
                              RejectedExecutionHandler handler) {
} //线程池的参数列表
```

***corePoolSize\***- 核心池大小，既然如前原理部分所述。需要注意的是在初创建线程池时线程不会立即启动，直到有任务提交才开始启动线程并逐渐时线程数目达到corePoolSize。若想一开始就创建所有核心线程需调用prestartAllCoreThreads方法。

***maximumPoolSize\***-池中允许的最大线程数。需要注意的是当核心线程满且阻塞队列也满时才会判断当前线程数是否小于最大线程数，并决定是否创建新线程。

***keepAliveTime\*** - 当线程数大于核心时，多于的空闲线程最多存活时间

***unit\*** - keepAliveTime 参数的时间单位。

***workQueue\*** - 当线程数目超过核心线程数时用于保存任务的队列。主要有3种类型的BlockingQueue可供选择：无界队列，有界队列和同步移交。从参数中可以看到，此队列仅保存实现Runnable接口的任务。 别看这个参数位置很靠后，但是真的很重要

***threadFactory*** - 执行程序创建新线程时使用的工厂。

***handler*** - 阻塞队列已满且线程数达到最大值时所采取的饱和策略。java默认提供了4种饱和策略的实现方式：中止、抛弃、抛弃最旧的、调用者运行。



**在重复一下新任务进入时线程池的执行策略：** 
**如果运行的线程少于corePoolSize，则 Executor始终首选添加新的线程，而不进行排队。（如果当前运行的线程小于corePoolSize，则任务根本不会存入queue中，而是直接运行）** 

**如果运行的线程大于等于 corePoolSize，则 Executor始终首选将请求加入队列，而不添加新的线程。** 
**如果无法将请求加入队列，则创建新的线程，除非创建此线程超出 maximumPoolSize，在这种情况下，任务将被拒绝**。

##### 三、阻塞队列

阻塞队列，顾名思义，首先它是一个队列，而一个队列在数据结构中所起的作用大致如下图所示：
![img](https://pic002.cnblogs.com/images/2010/161940/2010112414472791.jpg)
　　从上图我们可以很清楚看到，通过一个共享的队列，可以使得数据由队列的一端输入，从另外一端输出；

　　常用的队列主要有以下两种：（当然通过不同的实现方式，还可以延伸出很多不同类型的队列，DelayQueue就是其中的一种）

　　　　先进先出（FIFO）：先插入的队列的元素也最先出队列，类似于排队的功能。从某种程度上来说这种队列也体现了一种公平性。

　　　　后进先出（LIFO）：后插入队列的元素最先出队列，这种队列优先处理最近发生的事件。

队列比较好理解，数据结构中我们都接触过，先进先出的一种数据结构，那什么是阻塞队列呢？从名字可以看出阻塞队列其实也就是队列的一种特殊情况。举个例子来说明一下吧，我们去餐馆吃饭，一个接一个的下单，这时候就是一个普通的队列，万一这家店生意好，餐馆挤满了人，这时候肯定不能把顾客赶出去，于是餐馆就在旁边设置了一个休息等待区。这就是一个阻塞队列了。我们使用一张图来演示一下：

![img](https://pics0.baidu.com/feed/a50f4bfbfbedab647481069a4117e6c578311ea4.jpeg?token=93c32c3e1efa5276f2514a80df0c1c4a&s=CE702ED69EE85F0142D96C5703008062)

（1）当阻塞队列为空时，从队列中获取元素的操作将会被阻塞，就好比餐馆休息区没人了，此时不能接纳新的顾客了。换句话，肚子为空的时候也没东西吃。

（2）当阻塞队列满了，往队列添加元素的操作将会被阻塞，好比餐馆的休息区也挤满了，后来的顾客只能走了。

 阻塞队列应用最广泛的是生产者和消费者模式

**在多线程中，阻塞的意思是，在某些情况下会挂起线程，一旦条件成熟，被阻塞的线程就会被自动唤醒。**

也就是说，之前线程的wait和notify我们程序员需要自己控制，但有了这个阻塞队列之后我们程序员就不用担心了，阻塞队列会自动管理。

**主要有3种类型的BlockingQueue：**

**无界队列**

队列大小无限制，常用的为无界的LinkedBlockingQueue，使用该队列做为阻塞队列时要尤其当心，当任务耗时较长时可能会导致大量新任务在队列中堆积最终导致OOM。Executors.newFixedThreadPool 采用就是 LinkedBlockingQueue，当QPS很高，发送数据很大，大量的任务被添加到这个无界LinkedBlockingQueue 中，导致cpu和内存飙升服务器挂掉。

**有界队列**

常用的有两类，一类是遵循FIFO原则的队列如ArrayBlockingQueue，另一类是优先级队列如PriorityBlockingQueue。PriorityBlockingQueue中的优先级由任务的Comparator决定。 
使用有界队列时队列大小需和线程池大小互相配合，线程池较小有界队列较大时可减少内存消耗，降低cpu使用率和上下文切换，但是可能会限制系统吞吐量。

在我们的修复方案中，选择的就是这个类型的队列，虽然会有部分任务被丢失，但是我们线上是排序日志搜集任务，所以对部分对丢失是可以容忍的。

**同步移交队列**

如果不希望任务在队列中等待而是希望将任务直接移交给工作线程，可使用SynchronousQueue作为等待队列。SynchronousQueue不是一个真正的队列，而是一种线程之间移交的机制。要将一个元素放入SynchronousQueue中，必须有另一个线程正在等待接收这个元素。只有在使用无界线程池或者有饱和策略时才建议使用该队列。

BlockQueue接口继承自collection接口，根据插入和取出两种类型的操作

![img](https://pics5.baidu.com/feed/f703738da977391226b3c41e4e38cf1e377ae2e4.jpeg?token=63e53319c65f14b263cea6401cbec018&s=6010E433C5364C230255A4CB0000C0B1)

实现了BlockQueue接口的队列有很多，常见的没有几种，我们使用表格的形式给列出来，对比着分析一下：![img](https://pics7.baidu.com/feed/3801213fb80e7bec61a67d72990ff03e9a506bc8.jpeg?token=ad4351f88fe96382bb9eb7d5f7c98bb7&s=0132EC321DDE41CA1854E1CF0000C0B2)

常见的几种已经加粗了。

ArrayBlockingQueue和LinkedBlockingQueue是最为常用的阻塞队列，前者使用一个有边界的数组来作为存储介质，而后者使用了一个没有边界的链表来存储数据。

PriorityBlockingQueue是一个优先阻塞队列。所谓优先队列，就是每次从队队列里面获取到的都是队列中优先级最高的，对于优先级，PriorityBlockingQueue需要你为插入其中的元素类型提供一个Comparator，PriorityBlockingQueue使用这个Comparator来确定元素之间的优先级关系。底层的数据结构是堆，也就是我们数据结构中的那个堆。

DelayQueue是一个延时队列，所谓延时队列就是消费线程将会延时一段时间来消费元素。

SynchronousQueue是最为复杂的阻塞队列。SynchronousQueue和前面分析的阻塞队列都不同，因为SynchronousQueue不存在容量的说法，任何插入操作都需要等待其他线程来消费，否则就会阻塞等待，看到这种队列心里面估计就立马能联想到生产者消费者的这种模式了，没错，就可以使用这个队列来实现。

现在，我们已经把阻塞队列的一些基本知识点介绍了，完全带细节的介绍费时又费力，下面我们针对某个阻塞队列来看一下原理，其实就是看看源码是如何实现的。

##### 四、拒绝策略

所有的拒绝策略都实现这个接口

``` java
public interface RejectedExecutionHandler {

    /**
     * @param r the runnable task requested to be executed
     * @param executor the executor attempting to execute this task
     * @throws RejectedExecutionException if there is no remedy
     */
    void rejectedExecution(Runnable r, ThreadPoolExecutor executor);
}
```

这个接口只有一个 rejectedExecution 方法。

r 为待执行任务；executor 为线程池；方法可能会抛出拒绝异常。

**ThreadPoolExecutor.AbortPolicy**:丢弃任务并抛出RejectedExecutionException异常。 （这是线程池默认的拒绝策略，在任务不能再提交的时候，抛出异常，及时反馈程序运行状态。如果是比较关键的业务，推荐使用此拒绝策略，这样子在系统不能承载更大的并发量的时候，能够及时的通过异常发现）**ThreadPoolExecutor.DiscardPolicy**：丢弃任务，但是不抛出异常。 如果线程队列已满，则后续提交的任务都会被丢弃，且是静默丢弃。使用此策略，可能会使我们无法发现系统的异常状态。建议是一些无关紧要的业务采用此策略。例如，本人的博客网站统计阅读量就是采用的这种拒绝策略

**ThreadPoolExecutor.DiscardOldestPolicy**：丢弃队列最前面的任务， 当触发拒绝策略，只要线程池没有关闭的话，丢弃阻塞队列 workQueue 中最老的一个任务，并将新任务加入，喜新厌旧

**ThreadPoolExecutor.CallerRunsPolicy**：当触发拒绝策略，只要线程池没有关闭的话，则使用调用线程直接运行任务。一般并发比较小，性能要求不高，不允许失败。但是，由于调用者自己运行任务，如果任务提交速度过快，可能导致程序阻塞，性能效率上必然的损失较大

