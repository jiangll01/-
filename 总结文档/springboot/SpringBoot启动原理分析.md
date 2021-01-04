# SpringBoot启动原理分析

[![代码强](https://pic2.zhimg.com/v2-1097298a4a403c4d588382753c1b89c3_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/jessenqiang)

[代码强](https://www.zhihu.com/people/jessenqiang)

关注他

1 人赞同了该文章

**自动配置核心类SpringFactoriesLoader**

上面在说@EnableAutoConfiguration的时候有说META-INF下的spring.factories文件，那么这个文件是怎么被spring加载到的呢，其实就是SpringFactoriesLoader类。
SpringFactoriesLoader是一个供Spring内部使用的通用工厂装载器，SpringFactoriesLoader里有两个方法，

```java
// 加载工厂类并实例化
public static <T> List<T> loadFactories(Class<T> factoryClass, ClassLoader classLoader) {}
// 加载工厂类的类名
public static List<String> loadFactoryNames(Class<?> factoryClass, ClassLoader classLoader) {}
```

在这个SpringBoot应用启动过程中，SpringFactoriesLoader做了以下几件事：

1. 加载所有META-INF/spring.factories中的Initializer
2. 加载所有META-INF/spring.factories中的Listener
3. 加载EnvironmentPostProcessor（允许在Spring应用构建之前定制环境配置）
4. 接下来加载Properties和YAML的PropertySourceLoader（针对SpringBoot的两种配置文件的加载器）
5. 各种异常情况的FailureAnalyzer（异常解释器）
6. 加载SpringBoot内部实现的各种AutoConfiguration
7. 模板引擎TemplateAvailabilityProvider（如Freemarker、Thymeleaf、Jsp、Velocity等）

总得来说，SpringFactoriesLoader和@EnableAutoConfiguration配合起来，整体功能就是查找spring.factories文件，加载自动配置类。

### 整体启动流程

在我们执行入口类的main方法之后，运行SpringApplication.run，后面new了一个SpringApplication对象，然后执行它的run方法。

```java
public static ConfigurableApplicationContext run(Object[] sources, String[] args) {
    return new SpringApplication(sources).run(args);
}
```

### 初始化SpringApplication类

创建一个SpringApplication对象时，会调用它自己的initialize方法

```java
private void initialize(Object[] sources) {
    if (sources != null && sources.length > 0) {
        this.sources.addAll(Arrays.asList(sources));
    }
    // 根据标志类javax.servlet.Servlet,org.springframework.web.context.ConfigurableWebApplicationContext是否存在，判断是否是web环境
    this.webEnvironment = deduceWebEnvironment();
    // 通过SpringFactoriesLoader，获取到所有META-INF/spring.factories中的ApplicationContextInitializer，并实例化
    setInitializers((Collection) getSpringFactoriesInstances(
            ApplicationContextInitializer.class));
    // 通过SpringFactoriesLoader，获取到所有META-INF/spring.factories中的ApplicationListener，并实例化
    setListeners((Collection) getSpringFactoriesInstances(ApplicationListener.class));
    // 获取执行当前main方法的类，也就是启动类
    this.mainApplicationClass = deduceMainApplicationClass();
}
```

### 执行核心run方法

初始化initialize方法执行完之后，会调用run方法，开始启动SpringBoot。

```java
public ConfigurableApplicationContext run(String... args) {
    // 启动任务执行的时间监听器
    StopWatch stopWatch = new StopWatch();
    stopWatch.start();
    
    ConfigurableApplicationContext context = null;
    FailureAnalyzers analyzers = null;
    // 设置系统java.awt.headless属性，确定是否开启headless模式(默认开启headless模式)
    configureHeadlessProperty();
    // 通过SpringFactoriesLoader，获取到所有META-INF/spring.factories下的SpringApplicationRunListeners并实例化
    SpringApplicationRunListeners listeners = getRunListeners(args);
    // 开始广播启动
    listeners.started();
    try {
        // 创建SpringBoot默认启动参数对象
        ApplicationArguments applicationArguments = new DefaultApplicationArguments(args);
        // 根据启动参数创建并配置Environment(所有有效的配置，如Profile)，并遍历所有的listeners，广播启动环境已准备
        ConfigurableEnvironment environment = prepareEnvironment(listeners,applicationArguments);
        // 打印启动图案
        Banner printedBanner = printBanner(environment);
        // 根据标志类(上面有提到过)，创建对应类型的ApplicationContext
        context = createApplicationContext();
        // 创建异常解析器(当启动失败时，由此解析器处理失败结果)
        analyzers = new FailureAnalyzers(context);
        // 准备Spring上下文环境
        // 在这个方法中，主要完成了以下几件事：
        //  1、设置SpringBoot的环境配置(Environment)
        //  2、注册Spring Bean名称的序列化器BeanNameGenerator，并设置资源加载器ResourceLoader
        //  3、加载ApplicationContextInitializer初始化器，并进行初始化
        //  4、统一将上面的Environment、BeanNameGenerator、ResourceLoader使用默认的Bean注册器进行注册
        prepareContext(context, environment, listeners, applicationArguments,printedBanner);
        // 注册一个关闭Spring容器的钩子
        refreshContext(context);
        // 获取当前所有ApplicationRunner和CommandLineRunner接口的实现类，执行其run方法
        // ApplicationRunner和CommandLineRunner功能基本一样，在Spring容器启动完成时执行，唯一不同的是ApplicationRunner的run方法入参是ApplicationArguments，而CommandLineRunner是String数组
        afterRefresh(context, applicationArguments);
        // 通知所有listener，Spring容器启动完成
        listeners.finished(context, null);
        // 停止时间监听器
        stopWatch.stop();
        if (this.logStartupInfo) {
            new StartupInfoLogger(this.mainApplicationClass).logStarted(getApplicationLog(), stopWatch);
        }
        return context;
    } catch (Throwable ex) {
        // 启动有异常时，调用异常解析器解析异常信息，根据异常级别，判断是否退出Spring容器
        handleRunFailure(context, listeners, analyzers, ex);
        throw new IllegalStateException(ex);
    }
}
```

1. 首先遍历执行所有通过SpringFactoriesLoader，在当前classpath下的META-INF/spring.factories中查找所有可用的SpringApplicationRunListeners并实例化。调用它们的starting()方法，通知这些监听器SpringBoot应用启动。

   

2. 创建并配置当前SpringBoot应用将要使用的Environment，包括当前有效的PropertySource以及Profile。

   

3. 遍历调用所有的SpringApplicationRunListeners的environmentPrepared()的方法，通知这些监听器SpringBoot应用的Environment已经完成初始化。

   

4. 打印SpringBoot应用的banner，SpringApplication的showBanner属性为true时，如果classpath下存在banner.txt文件，则打印其内容，否则打印默认banner。

   

5. 根据启动时设置的applicationContextClass和在initialize方法设置的webEnvironment，创建对应的applicationContext。

   

6. 创建异常解析器，用在启动中发生异常的时候进行异常处理(包括记录日志、释放资源等)。

   

7. 设置SpringBoot的Environment，注册Spring Bean名称的序列化器BeanNameGenerator，并设置资源加载器ResourceLoader，通过SpringFactoriesLoader加载ApplicationContextInitializer初始化器，调用initialize方法，对创建的ApplicationContext进一步初始化。

   

8. 调用所有的SpringApplicationRunListeners的contextPrepared方法，通知这些Listener当前ApplicationContext已经创建完毕。

   

9. 最核心的一步，将之前通过@EnableAutoConfiguration获取的所有配置以及其他形式的IoC容器配置加载到已经准备完毕的ApplicationContext。

   

10. 调用所有的SpringApplicationRunListener的contextLoaded方法，加载准备完毕的ApplicationContext。

    

11. 调用refreshContext，注册一个关闭Spring容器的钩子ShutdownHook，当程序在停止的时候释放资源（包括：销毁Bean，关闭SpringBean的创建工厂等）
    **注：** 钩子可以在以下几种场景中被调用：
    1）程序正常退出
    2）使用System.exit()
    3）终端使用Ctrl+C触发的中断
    4）系统关闭
    5）使用Kill pid命令杀死进程

    获取当前所有ApplicationRunner和CommandLineRunner接口的实现类，执行其run方法
    遍历所有的SpringApplicationRunListener的finished()方法，完成SpringBoot的启动。