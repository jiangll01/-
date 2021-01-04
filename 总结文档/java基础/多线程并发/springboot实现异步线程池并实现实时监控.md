# springboot实现异步线程池并实现实时监控

![img](https://csdnimg.cn/release/blogv2/dist/pc/img/original.png)

置顶 [软件界小白](https://me.csdn.net/qq_37014611) 2019-07-03 11:37:10 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/articleReadEyes.png) 3013 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/tobarCollect.png) 收藏 8

文章标签： [springboot异步线程池](https://www.csdn.net/gather_23/MtTacg4sMDM4NjktYmxvZwO0O0OO0O0O.html) [并实现线程监控](https://so.csdn.net/so/search/s.do?q=并实现线程监控&t=blog&o=vip&s=&l=&f=&viparticle=)

版权

背景

：因为我要对接京东订单服务 拉取订单的时候需要100个商户同时拉取订单服务，必须是异步的。

首先要在springboot 启动处加入

![img](https://img-blog.csdnimg.cn/20190703112501387.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM3MDE0NjEx,size_16,color_FFFFFF,t_70)

 

```
@EnableAsync
@Configuration
class TaskPoolConfig {
    @Bean("taskExecutor")
    public Executor taskExecutor() {
        //注意这一行日志：2. do submit,taskCount [101], completedTaskCount [87], activeCount [5], queueSize [9]
        //这说明提交任务到线程池的时候，调用的是submit(Callable task)这个方法，当前已经提交了101个任务，完成了87个，当前有5个线程在处理任务，还剩9个任务在队列中等待，线程池的基本情况一路了然；
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        //核心线程数10：线程池创建时候初始化的线程数
        executor.setCorePoolSize(10);
         //最大线程数20：线程池最大的线程数，只有在缓冲队列满了之后才会申请超过核心线程数的线程
         //maxPoolSize 当系统负载大道最大值时,核心线程数已无法按时处理完所有任务,这是就需要增加线程.每秒200个任务需要20个线程,那么当每秒1000个任务时,则需要(1000-queueCapacity)*(20/200),即60个线程,可将maxPoolSize设置为60;
         executor.setMaxPoolSize(30);
        //缓冲队列200：用来缓冲执行任务的队列
        executor.setQueueCapacity(400);
        //允许线程的空闲时间60秒：当超过了核心线程出之外的线程在空闲时间到达之后会被销毁
        executor.setKeepAliveSeconds(60);
        //线程池名的前缀：设置好了之后可以方便我们定位处理任务所在的线程池
        executor.setThreadNamePrefix("taskExecutor");
        //理线程池对拒绝任务的处策略：这里采用了CallerRunsPolicy策略，当线程池没有处理能力的时候，该策略会直接在 execute 方法的调用线程中运行被拒绝的任务；如果执行程序已关闭，则会丢弃该任务
        /*CallerRunsPolicy：线程调用运行该任务的 execute 本身。此策略提供简单的反馈控制机制，能够减缓新任务的提交速度。
        这个策略显然不想放弃执行任务。但是由于池中已经没有任何资源了，那么就直接使用调用该execute的线程本身来执行。（开始我总不想丢弃任务的执行，但是对某些应用场景来讲，很有可能造成当前线程也被阻塞。如果所有线程都是不能执行的，很可能导致程序没法继续跑了。需要视业务情景而定吧。）
        AbortPolicy：处理程序遭到拒绝将抛出运行时 RejectedExecutionException
        这种策略直接抛出异常，丢弃任务。（jdk默认策略，队列满并线程满时直接拒绝添加新任务，并抛出异常，所以说有时候放弃也是一种勇气，为了保证后续任务的正常进行，丢弃一些也是可以接收的，记得做好记录）
        DiscardPolicy：不能执行的任务将被删除
        这种策略和AbortPolicy几乎一样，也是丢弃任务，只不过他不抛出异常。
        DiscardOldestPolicy：如果执行程序尚未关闭，则位于工作队列头部的任务将被删除，然后重试执行程序（如果再次失败，则重复此过程）
        该策略就稍微复杂一些，在pool没有关闭的前提下首先丢掉缓存在队列中的最早的任务，然后重新尝试运行该任务。这个策略需要适当小心*/
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.DiscardOldestPolicy());
        executor.setWaitForTasksToCompleteOnShutdown(true);
        executor.setAwaitTerminationSeconds(60);
        return executor;
    }
}
```

每个配置文件代表什么意思可以看一下

这个时候启动的时候我们异步线程池是已经创建好

我们创建一个task 类

```
public class Task {
    public static Random random = new Random();



    @Async("taskExecutor")
    public void doTask(Integer i) throws Exception {
        System.out.println("开始做任务");
        long start = System.currentTimeMillis();
        //这里写业务代码
        long end = System.currentTimeMillis();
        System.out.println("完成任务耗时：" + (end - start)/1000 + "秒");

    }
```

}

这个时候我们就可以使用了我们把task 注入到 controller 层

```
@RestController
@RequestMapping("test/")
public class TestController {

    @Autowired
    private TaskService taskService;

    @Autowired
    private Executor taskExecutor;


    private Logger logger = LogManager.getLogger(JDcontroller.class);

    @PostMapping("order")
    public String addOrder(@RequestBody RequestParameterDTO requestParameters){
            //这里会执行你开启的任务，都是异步的,调用这个接口会立马返回 OK  然后业务是在后台运行的
            taskService.doTask(requestParameters);
            return "OK"; 
    }
    //这里我们可以通过接口实时观看效果 具体效果如下图
    @GetMapping("order/asyncExceutor")
    public Map getThreadInfo() {
        Map map =new HashMap();
        Object[] myThread = {taskExecutor};
        for (Object thread : myThread) {
            ThreadPoolTaskExecutor threadTask = (ThreadPoolTaskExecutor) thread;
            ThreadPoolExecutor threadPoolExecutor =threadTask.getThreadPoolExecutor();
            System.out.println("提交任务数"+threadPoolExecutor.getTaskCount());
            System.out.println("完成任务数"+threadPoolExecutor.getCompletedTaskCount() );
            System.out.println("当前有"+threadPoolExecutor.getActiveCount()+"个线程正在处理任务");
            System.out.println("还剩"+threadPoolExecutor.getQueue().size()+"个任务");
            map.put("提交任务数-->",threadPoolExecutor.getTaskCount());
            map.put("完成任务数-->",threadPoolExecutor.getCompletedTaskCount());
            map.put("当前有多少线程正在处理任务-->",threadPoolExecutor.getActiveCount());
            map.put("还剩多少个任务未执行-->",threadPoolExecutor.getQueue().size());
            map.put("当前可用队列长度-->",threadPoolExecutor.getQueue().remainingCapacity());
            map.put("当前时间-->",DateFormatUtil.stringDate());
        }
        return map;
    }
}
```

![img](https://img-blog.csdnimg.cn/20190703113039469.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM3MDE0NjEx,size_16,color_FFFFFF,t_70)

 

![img](https://img-blog.csdnimg.cn/20190703113337377.png)

![img](https://img-blog.csdnimg.cn/20190703113422623.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM3MDE0NjEx,size_16,color_FFFFFF,t_70)

上图那个名字要和你在springboot启动处定义的名字要相同 这样spring 才能找到 才能监控你的线程池 ，当然这做的好处是你可以监控多个线程池 的线程，只需要在启动处 在加入 类似 的代码，名字不一样就行了