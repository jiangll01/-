# [Spring Boot配置线程池使用多线程插入数据](https://segmentfault.com/a/1190000016345113)

[![img](https://avatar-static.segmentfault.com/949/844/9498447-54cb56e325a72_small) mysql](https://segmentfault.com/t/mysql)[![img](https://avatar-static.segmentfault.com/868/271/868271510-54cb382abb7a1_small) java](https://segmentfault.com/t/java)

发布于 2018-09-11

![img](https://sponsor.segmentfault.com/lg.php?bannerid=0&campaignid=0&zoneid=25&loc=https%3A%2F%2Fsegmentfault.com%2Fa%2F1190000016345113&referer=https%3A%2F%2Fwww.baidu.com%2Flink%3Furl%3Dka6VdNb742F48rdTMbJ2tTkjYZxgo7HFPYrBAUxCJvzWcUywT4neQ9tzCX201h3BhDj3xPispLBP8fJBSILVDa%26wd%3D%26eqid%3D9179dda00004b089000000025f90e045&cb=609096cd5d)

## 前言：

最近在工作中需要将一大批数据导入到数据库中，因为种种原因这些数据不能使用同步数据的方式来进行复制，而是提供了一批文本，文本里面有很多行url地址，需要的字段都包含在这些url中。最开始是使用的正常的普通方式去写入，但是量太大了，所以就尝试使用多线程来写入。下面我们就来介绍一下怎么使用多线程进行导入。

## 1.文本格式

格式就是类似于这种格式的url，当然这里只是举个例子，大概有300多个文本，每个文本里面有大概25000条url，而每条url要插入两个表，这个量还是有点大的，单线程跑的非常慢。

- `https://www.test.com/?type=1&code=123456&goodsId=321`

## 2.springboot配置线程池

我们需要创建一个`ExecutorConfig`类来设置线程池的各种配置。

```
@Configuration
@EnableAsync
public class ExecutorConfig {
    private static Logger logger = LogManager.getLogger(ExecutorConfig.class.getName());

    @Bean
    public Executor asyncServiceExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        //配置核心线程数
        executor.setCorePoolSize(5);
        //配置最大线程数
        executor.setMaxPoolSize(10);
        //配置队列大小
        executor.setQueueCapacity(400);
        //配置线程池中的线程的名称前缀
        executor.setThreadNamePrefix("thread-");
        // rejection-policy：当pool已经达到max size的时候，如何处理新任务
        // CALLER_RUNS：不在新线程中执行任务，而是有调用者所在的线程来执行
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        //执行初始化
        executor.initialize();
        return executor;
    }
}
```

## 3.创建异步任务接口

我们需要创建一个接口，再这个接口里面声明了我们需要调用的异步方法

```
public interface AsyncService {

    /**
     *  执行异步任务
     */
    void writeTxt();
}
```

## 4.创建异步实现类

再创建一个异步类实现上面的异步接口，重写接口里面的方法，最重要的是我们需要在方法上加`@Async("asyncServiceExecutor")`注解，它是刚刚我们在线程池配置类的里的那个配制方法的名字，加上这个后每次执行这个方法都会开启一个线程放入线程池中。我下面这个方法是开启多线程遍历文件夹中的文件然后为每个文件都复制一个副本出来。

```
@Service
public class AsyncServiceImpl implements AsyncService {
    private static Logger logger = LogManager.getLogger(AsyncServiceImpl.class.getName());

    @Async("asyncServiceExecutor")
    public void writeTxt(String fileName){
        logger.info("线程-" + Thread.currentThread().getId() + "在执行写入");
        try {
            File file = new File(fileName);

            List<String> lines = FileUtils.readLines(file);

            File copyFile = new File(fileName + "_copy.txt");
            lines.stream().forEach(string->{
                try {
                    FileUtils.writeStringToFile(copyFile,string,"utf8",true);
                    FileUtils.writeStringToFile(copyFile,"\r\n","utf8",true);
                } catch (IOException e) {
                    logger.info(e.getMessage());
                }
            });
        }catch (Exception e) {
            logger.info(e.getMessage());
        }
    }
}
@RunWith(SpringRunner.class)
@SpringBootTest
public class BootApplicationTests {

@Autowired
private AsyncService asyncService;

@Test
public void write() {
    File file = new File("F://ac_code_1//test.txt");
    try {
        FileUtils.writeStringToFile(file, "ceshi", "utf8");
        FileUtils.writeStringToFile(file, "\r\n", "utf8");
        FileUtils.writeStringToFile(file, "ceshi2", "utf8");
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

## 5.修改为阻塞式

上面的步骤已经基本实现了多线程的操作，但是当我真的开始导入数据的时候又发现一个问题，就是每次运行后才刚开始导入就自动停止了，原因是我在Junit中运行了代码后它虽然开始导入了，但是因为数据很多时间很长，而Juint跑完主线程的逻辑后就把整个JVM都关掉了，所以导入了一点点就停止了，上面的测试方法之所以没问题是因为几个文件的复制速度很快，在主线程跑完之前就跑完了，所以看上去没问题。最开始我用了一个最笨的方法，直接在主线程最后调用`Thread.sleep()`方法，虽然有效果但是这也太low了，而且你也没法判断到底数据导完没有。所以我又换了一个方式。

## 6.使用countDownLatch阻塞主线程

CountDownLatch是一个同步工具类，它允许一个或多个线程一直等待，直到其他线程执行完后再执行。它可以使主线程一直等到所有的子线程执行完之后再执行。我们修改下代码，创建一个CountDownLatch实例，大小是所有运行线程的数量，然后在异步类的方法中的finally里面对它进行减1，在主线程最后调用`await()`方法，这样就能确保所有的子线程运行完后主线程才会继续执行。

```
@RunWith(SpringRunner.class)
@SpringBootTest
public class BootApplicationTests {

    private final CountDownLatch countDownLatch = new CountDownLatch(10);

    @Autowired
    private AsyncService asyncService;

    @Test
    public void mainWait() {
        try {
            for (int i = 0; i < 10; i++) {
                asyncService.mainWait(countDownLatch);
            }
            countDownLatch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
@Service
public class AsyncServiceImpl implements AsyncService {
    private static Logger logger = LogManager.getLogger(AsyncServiceImpl.class.getName());

    @Override
    @Async("asyncServiceExecutor")
    public void mainWait(CountDownLatch countDownLatch) {
        try {
            System.out.println("线程" + Thread.currentThread().getId() + "开始执行");
            for (int i=1;i<1000000000;i++){
                Integer integer = new Integer(i);
                int l = integer.intValue();
                for (int x=1;x<10;x++){
                    Integer integerx = new Integer(x);
                    int j = integerx.intValue();
                }
            }
            System.out.println("线程" + Thread.currentThread().getId() + "执行结束");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            countDownLatch.countDown();
        }
    }
}
```

## 7.导入代码

虽然上面的多线程是重点，不过还是把导入数据的代码展示出来给大家参考一下，当然这是简化版，真实的要比这个多了很多判断，不过那都是基于业务需求做的判断。

```
@RunWith(value = SpringRunner.class)
@SpringBootTest
public class ApplicationTests {
    private static Log logger = LogFactory.getLog(ApplicationTests.class);
    
    private final CountDownLatch countDownLatch;

    @Autowired
    AsyncService asyncService;

    @Test
    public void writeCode() {
        try {
            File file = new File("F:\\ac_code_1");
            File[] files = file.listFiles();
            //计数器数量就等于文件数量,因为每个文件会开一个线程
            countDownLatch = new CountDownLatch(files.length);

            Arrays.stream(files).forEach(file1 -> {
                File child = new File(file1.getAbsolutePath());
                String fileName = child.getAbsolutePath();
                logger.info(asyncService.writeCode(fileName,countDownLatch));
            });
            countDownLatch.await();
        catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
@Service
public class AsyncServiceImpl implements AsyncService {
    private static Log logger = LogFactory.getLog(AsyncServiceImpl.class);

    @Autowired
    IExampleService exampleService;

    @Override
    @Async("asyncServiceExecutor")
    public String writeCode(String fileName,CountDownLatch countDownLatch) {
        logger.info("线程-" + Thread.currentThread().getId() + "在导入-" + fileName);
        try {
            File file = new File(fileName);
            List<String> list = FileUtils.readLines(file);
            for (String string : list) {
                String[] parmas = string.split(",");
                ExampleVo vo = new ExampleVo();
                vo.setParam1(parmas[0]);
                vo.setParam1(parmas[1]);
                vo.setParam1(parmas[2]);
                exampleService.save(vo);
            }
            return "导入完成-" + fileName;
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }finally {
            //导入完后减1
            countDownLatch.countDown();
        }
    }
}
```

## 总结：

到这里就已经讲完了多线程插入数据的方法，目前这个方法还很简陋。因为是每个文件都开一个线程性能消耗比较大，而且如果线程池的线程配置太多了，频繁切换反而会变得很慢，大家如果有更好的办法都可以留言讨论。