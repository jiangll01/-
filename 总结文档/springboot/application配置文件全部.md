| 附录A.常见的应用程序属性                                     |              |                                                              |
| ------------------------------------------------------------ | ------------ | ------------------------------------------------------------ |
| [上一个](https://docs.spring.io/spring-boot/docs/2.1.3.RELEASE/reference/html/appendix.html) | 第十部分附录 | [下一个](https://docs.spring.io/spring-boot/docs/2.1.3.RELEASE/reference/html/configuration-metadata.html) |

------

## 附录A.常见的应用程序属性

可以在`application.properties`文件内部`application.yml`，文件内部或命令行开关中指定各种属性。该附录提供了常见的Spring Boot属性列表以及对使用它们的基础类的引用。

| ![[小费]](https://docs.spring.io/spring-boot/docs/2.1.3.RELEASE/reference/html/images/tip.png) |
| ------------------------------------------------------------ |
| Spring Boot提供了各种具有高级值格式的转换机制，请务必查看[属性转换部分](https://docs.spring.io/spring-boot/docs/2.1.3.RELEASE/reference/html/boot-features-external-config.html#boot-features-external-config-conversion)。 |

| ![[注意]](https://docs.spring.io/spring-boot/docs/2.1.3.RELEASE/reference/html/images/note.png) |
| ------------------------------------------------------------ |
| 属性贡献可能来自类路径上的其他jar文件，因此您不应将其视为详尽的列表。另外，您可以定义自己的属性。 |

| ![[警告]](https://docs.spring.io/spring-boot/docs/2.1.3.RELEASE/reference/html/images/warning.png) |
| ------------------------------------------------------------ |
| 此样本文件仅供参考。千万**不能**复制和粘贴的全部内容到应用程序中。而是仅选择所需的属性。 |

```
＃================================================= ================= 
＃普通弹簧启动特性
＃＃
本示例文件仅供参考。请勿将其
全部
复制到您自己的应用程序中。^^^ ＃============================================== =====================


＃---------------------------------------- 
＃核心属性
＃----- ----------------------------------- 
debug = false ＃启用调试日志。
trace = false ＃启用跟踪日志。

＃LOGGING 
logging.config = ＃日志记录配置文件的位置。例如，用于logback的`classpath：logback.xml`。
logging.exception-conversion-word =％wEx ＃记录异常时使用的转换字。
logging.file = ＃日志文件名（例如，“ myapp.log”）。名称可以是确切的位置，也可以相对于当前目录。
logging.file.max-history = 0 ＃要保留的归档日志文件的最大值。仅默认登录设置支持。
logging.file.max-size = 10MB ＃最大日志文件大小。仅默认登录设置支持。
logging.group。* =＃日志组可快速快速地同时更改多个记录器。例如，`logging.level.db = org.hibernate，org.springframework.jdbc`。
logging.level。* = ＃日志级别严重性映射。例如，`logging.level.org.springframework = DEBUG`。
logging.path = ＃日志文件的位置。例如，`/ var / log`。
logging.pattern.console = ＃输出到控制台的附加模式。仅默认的Logback设置受支持。
logging.pattern.dateformat = yyyy-MM-dd HH：mm：ss.SSS ＃日志日期格式的
附加模式。仅默认的Logback设置受支持。logging.pattern.file =＃输出到文件的附加模式。仅默认的Logback设置受支持。
logging.pattern.level =％5p ＃日志级别的附加模式。仅默认的Logback设置受支持。
logging.register-shutdown-hook = false ＃初始化日志系统时注册一个关闭钩子。

＃AOP 
spring.aop.auto =真＃添加@EnableAspectJAutoProxy。
spring.aop.proxy-target-class = true ＃与基于标准Java接口的代理（false）相对，是否要创建基于子类的代理（true）。

＃IDENTITY （ContextIdApplicationContextInitializer）
 spring.application.name = ＃应用程序名称。

＃ADMIN （SpringApplicationAdminJmxAutoConfiguration）
 spring.application.admin.enabled = false ＃是否为应用程序启用管理功能。
spring.application.admin.jmx-name = org.springframework.boot：type = Admin，name = SpringApplication ＃应用程序管理MBean的JMX名称。

＃AUTO-CONFIGURATION 
spring.autoconfigure.exclude = ＃要排除的自动配置类。

＃BANNER 
spring.banner.charset = UTF-8 ＃横幅文件编码。
spring.banner.location = classpath：banner.txt ＃
标语文字资源位置。spring.banner.image.location = classpath：banner.gif ＃横幅图像文件的位置（也可以使用jpg或png）。
spring.banner.image.width = 76 ＃横幅图像的宽度（以字符为单位）。
spring.banner.image.height = ＃横幅图像的高度（以字符为单位）（默认基于图像高度）。
spring.banner.image.margin = 2 ＃左手图像边距（以字符为单位）。
spring.banner.image.invert = false ＃是否应针对深色终端主题反转图像。


＃SPRING CORE spring.beaninfo.ignore = true ＃是否跳过对BeanInfo类的搜索。

＃SPRING CACHE（CacheProperties）
 spring.cache.cache-names = ＃如果基础缓存管理器支持，
则以逗号分隔的要创建的缓存名称列表。spring.cache.caffeine.spec = ＃用于创建缓存的规范。有关规范格式的更多详细信息，请参见CaffeineSpec。
spring.cache.couchbase.expiration = ＃条目到期。默认情况下，条目永不过期。请注意，此值最终会转换为秒。
spring.cache.ehcache.config = ＃用于初始化EhCache的配置文件的位置。
spring.cache.infinispan.config = ＃用于初始化Infinispan的配置文件的位置。
spring.cache.jcache.config = ＃用于初始化缓存管理器的配置文件的位置。
spring.cache.jcache.provider = ＃CachingProvider实现的完全限定名称，用于检索符合JSR-107的缓存管理器。仅在类路径上有多个JSR-107实现可用时才需要。
spring.cache.redis.cache-null-values = true ＃允许缓存空值。
spring.cache.redis.key-prefix = ＃密钥前缀。
spring.cache.redis.live-to-live = ＃条目到期。默认情况下，条目永不过期。
spring.cache.redis.use-key-prefix =真＃写入Redis时是否使用密钥前缀。
spring.cache.type = ＃缓存类型。默认情况下，根据环境自动检测。

＃SPRING CONFIG-仅使用环境属性（ConfigFileApplicationListener）
 spring.config.additional-location = ＃除了默认值以外，还使用了配置文件的位置。
spring.config.location = ＃替换默认配置文件的位置。
spring.config.name =应用程序＃配置文件名。

＃HAZELCAST（HazelcastProperties）
 spring.hazelcast.config = ＃用于初始化Hazelcast的配置文件的位置。

＃项目信息（ProjectInfoProperties）
 spring.info.build.encoding = UTF-8 ＃文件编码。
spring.info.build.location = classpath：META-INF / build-info.properties ＃生成的build-info.properties文件的位置。
spring.info.git.encoding = UTF-8 ＃文件编码。
spring.info.git.location =类路径：git.properties生成的git.properties文件＃所在。

＃JMX 
spring.jmx.default域= ＃JMX域名。
spring.jmx.enabled = true ＃将管理bean公开到JMX域。
spring.jmx.server = mbeanServer ＃MBeanServer Bean名称。
spring.jmx.unique-names = false ＃是否应确保唯一的运行时对象名称。

＃电子邮件（MailProperties）
 spring.mail.default-encoding = UTF-8 ＃默认的MimeMessage编码。
spring.mail.host = ＃SMTP服务器主机。例如，“ smtp.example.com”。
spring.mail.jndi-name = ＃会话JNDI名称。设置后，优先于其他会话设置。
spring.mail.password = ＃SMTP服务器的登录密码。
spring.mail.port = ＃SMTP服务器端口。
spring.mail.properties。* = ＃其他JavaMail会话属性。
spring.mail.protocol = smtp ＃SMTP服务器使用的协议。
spring.mail.test-connection = false＃是否测试启动时邮件服务器是否可用。
spring.mail.username = ＃SMTP服务器的登录用户。

＃应用程序设置（SpringApplication）
 spring.main.allow-bean-definition-overriding = false ＃是否允许通过注册与现有定义同名的定义来覆盖Bean定义。
spring.main.banner-mode =控制台＃用于在应用程序运行时显示横幅的模式。
spring.main.sources = ＃包含在ApplicationContext中的源（类名，包名或XML资源位置）。
spring.main.web-application-type = ＃明确请求特定类型的Web应用程序的标志。如果未设置，则基于类路径自动检测。

＃FILE ENCODING（FileEncodingApplicationListener）
 spring.mandatory-file-encoding = ＃应用程序必须使用的预期字符编码。

＃INTERNATIONALIZATION （MessageSourceProperties）
 spring.messages.always-use-message-format = false ＃是否始终应用MessageFormat规则，甚至解析不带参数的消息。
spring.messages.basename = messages ＃逗号分隔的基名列表（本质上是完全合格的类路径位置），每个都遵循ResourceBundle约定，并轻松支持基于斜杠的位置。
spring.messages.cache-duration = ＃加载的资源包文件缓存持续时间。如果未设置，则捆绑包将永久缓存。如果未指定持续时间后缀，则将使用秒。
spring.messages.encoding = UTF-8 ＃消息束编码。
spring.messages.fallback-to-system-locale = true ＃如果未找到特定语言环境的文件，是否回退到系统语言环境。
spring.messages.use-code-as-default-message = false ＃是否使用消息代码作为默认消息，而不是抛出“ NoSuchMessageException”。仅在开发期间推荐。

＃OUTPUT 
spring.output.ansi.enabled =检测＃配置ANSI输出。

＃PID FILE（ApplicationPidFileWriter）
 spring.pid.fail-on-write-error = ＃如果使用了ApplicationPidFileWriter，则失败，但无法写入PID文件。
spring.pid.file = ＃要写入的PID文件的位置（如果使用ApplicationPidFileWriter）。

＃
配置文件spring.profiles.active = ＃逗号分隔的活动配置文件列表。可以被命令行开关覆盖。
spring.profiles.include = ＃无条件激活指定的逗号分隔的配置文件列表（如果使用YAML，则激活配置文件列表）。

＃Quartz调度器（QuartzProperties）
 spring.quartz.auto-启动=真＃是否自动启动初始化后的调度。
spring.quartz.jdbc.comment-prefix =- ＃SQL初始化脚本中单行注释的前缀。
spring.quartz.jdbc.initialize-schema =嵌入式＃数据库模式初始化模式。
spring.quartz.jdbc.schema = classpath：org / quartz / impl / jdbcjobstore / tables_ @ @ platform @ @ .sql ＃用于初始化数据库模式的SQL文件的路径。
spring.quartz.job-store-type =内存＃石英作业存储类型。
spring.quartz.overwrite-existing-jobs = false ＃配置的作业是否应该覆盖现有的作业定义。
spring.quartz.properties。* = ＃其他Quartz Scheduler属性。
spring.quartz.scheduler-name = quartzScheduler ＃调度程序的名称。
spring.quartz.startup-delay = 0s ＃初始化完成后启动调度程序的延迟时间。
spring.quartz.wait-for-jobs-to-shutdown时= false ＃是否等待正在运行的作业在关闭时完成。

＃REACTOR （ReactorCoreProperties）
 spring.reactor.stacktrace -mode.enabled = false ＃Reactor是否应在运行时收集堆栈跟踪信息。

＃SENDGRID（SendGridAutoConfiguration）
 spring.sendgrid.api-key = ＃SendGrid API密钥。
spring.sendgrid.proxy.host = ＃SendGrid代理主机。
spring.sendgrid.proxy.port = ＃SendGrid代理端口。

＃任务执行（TaskExecutionProperties）
 spring.task.execution.pool.allow-core-thread-timeout = true ＃是否允许核心线程超时。这样可以动态增加和缩小池。
spring.task.execution.pool.core-size = 8 ＃核心线程数。
spring.task.execution.pool.keep-alive = 60s ＃线程在终止之前可能保持空闲的时间限制。
spring.task.execution.pool.max-size = ＃允许的最大线程数。如果任务填满队列，则池可以扩展到该大小以容纳负载。忽略队列是否无界。
spring.task.execution.pool.queue-capacity =＃队列容量。无限制的容量不会增加池，因此会忽略“最大大小”属性。
spring.task.execution.thread-name-prefix = task- ＃前缀，用于新创建的线程的名称。

＃任务调度（TaskSchedulingProperties）
 spring.task.scheduling.pool.size = 1 ＃允许的最大线程数。
spring.task.scheduling.thread-name-prefix = scheduling- ＃用于新创建线程名称的前缀。

＃---------------------------------------- 
＃Web属性
＃----- -----------------------------------

＃嵌入式服务器配置（ServerProperties）
 server.address = ＃服务器应绑定到的网络地址。
server.compression.enabled = false ＃是否启用响应压缩。
server.compression.excluded-user-agents = ＃逗号分隔的用户代理列表，不应压缩其响应。
server.compression.mime-types = text / html，text / xml，text / plain，text / css，text / javascript，application / javascript，application / json，application / xml ＃逗号分隔的MIME类型列表压缩。
server.compression.min-response-size = 2KB＃执行压缩所需的最小“ Content-Length”值。
server.connection-timeout = ＃连接器在关闭连接之前等待另一个HTTP请求的时间。如果未设置，则使用连接器的特定于容器的默认值。使用值-1表示没有（即无限）超时。
server.error.include-exception = false ＃包含“ exception”属性。
server.error.include-stacktrace = never ＃何时包括“ stacktrace”属性。
server.error.path = / error ＃错误控制器的路径。
server.error.whitelabel.enabled = true＃如果服务器发生错误，是否启用浏览器中显示的默认错误页面。
server.http2.enabled = false ＃如果当前环境支持，则是否启用HTTP / 2支持。
server.jetty.acceptors = -1 ＃要使用的接收器线程数。当值是-1（默认值）时，接受者的数量是从操作环境派生的。
server.jetty.accesslog.append = false ＃追加到日志。
server.jetty.accesslog.date-format = dd / MMM / yyyy：HH：mm：ss Z ＃请求日志的时间戳格式。
server.jetty.accesslog.enabled = false ＃启用访问日志。
server.jetty.accesslog.extended-format = false＃启用扩展的NCSA格式。
server.jetty.accesslog.file-date-format = ＃放置在日志文件名中的日期格式。
server.jetty.accesslog.filename = ＃日志文件名。如果未指定，则日志重定向到“ System.err”。
server.jetty.accesslog.locale = ＃请求日志的语言环境。
server.jetty.accesslog.log-cookies = false ＃启用请求cookie的日志记录。
server.jetty.accesslog.log-latency = false ＃启用记录请求处理时间。
server.jetty.accesslog.log-server = false ＃启用请求主机名的日志记录。
server.jetty.accesslog.retention-period = 31＃删除轮换日志文件的天数。
server.jetty.accesslog.time-zone = GMT ＃请求日志的时区。
server.jetty.max-http-post-size = 200000B ＃HTTP发布或放置内容的最大大小。
server.jetty.selectors = -1 ＃要使用的选择器线程数。当值是-1（默认值）时，选择器的数量是从操作环境派生的。
server.max-http-header-size = 8KB ＃HTTP消息头的最大大小。
server.port = 8080 ＃服务器HTTP端口。
server.server-header = ＃用于服务器响应头的值（如果为空，则不发送头）。
server.use-forward-headers = ＃是否应将X-Forwarded- *标头应用于HttpRequest。
server.servlet.context-parameters。* = ＃Servlet上下文初始化参数。
server.servlet.context-path = ＃应用程序的上下文路径。
server.servlet.application-display-name =应用程序＃
应用程序的显示名称。server.servlet.jsp.class-name = org.apache.jasper.servlet.JspServlet ＃用于JSP的servlet的类名。
server.servlet.jsp.init-parameters。* = ＃用于配置JSP servlet的初始化参数。
server.servlet.jsp.registered = true＃是否已注册JSP Servlet。
server.servlet.session.cookie.comment = ＃会话cookie的注释。
server.servlet.session.cookie.domain = ＃会话cookie的域。
server.servlet.session.cookie.http-only = ＃是否对会话cookie使用“ HttpOnly” cookie。
server.servlet.session.cookie.max-age = ＃会话cookie的最大
期限。如果未指定持续时间后缀，则将使用秒。server.servlet.session.cookie.name = ＃会话cookie名称。
server.servlet.session.cookie.path = ＃会话cookie的路径。
server.servlet.session.cookie.secure =＃是否始终将会话cookie标记为安全。
server.servlet.session.persistent = false ＃是否在
两次重启之间保留会话数据。server.servlet.session.store-dir = ＃用于存储会话数据的目录。
server.servlet.session.timeout = 30m ＃会话超时。如果未指定持续时间后缀，则将使用秒。
server.servlet.session.tracking-modes = ＃会话跟踪模式。
server.ssl.ciphers = ＃支持的SSL密码。
server.ssl.client-auth = ＃客户端身份验证模式。
server.ssl.enabled = true ＃是否启用SSL支持。
server.ssl.enabled-protocols = ＃启用的SSL协议。
server.ssl.key-alias = ＃别名，用于标识密钥库中的密钥。
server.ssl.key-password = ＃用于访问密钥库中密钥的密码。
server.ssl.key-store = ＃存放SSL证书（通常是jks文件）的密钥存储的路径。
server.ssl.key-store-password = ＃用于访问密钥库的密码。
server.ssl.key-store-provider = ＃密钥库的提供程序。
server.ssl.key-store-type = ＃密钥库的类型。
server.ssl.protocol = TLS ＃要使用的SSL协议。
server.ssl.trust-store = ＃持有SSL证书的信任库。
server.ssl.trust-store-password = ＃用于访问信任库的密码。
server.ssl.trust-store-provider = ＃信任库的提供者。
server.ssl.trust-store-type = ＃信任库的类型。
server.tomcat.accept-count = 100 ＃使用所有可能的请求处理线程时，传入连接请求的最大队列长度。
server.tomcat.accesslog.buffered = true ＃是否缓冲输出，使其仅定期刷新。
server.tomcat.accesslog.directory =日志＃创建日志文件的目录。可以是绝对值，也可以相对于Tomcat基本目录。
server.tomcat.accesslog.enabled = false ＃启用访问日志。
server.tomcat.accesslog.file-date-format = .yyyy-MM-dd ＃放置在日志文件名中的日期格式。
server.tomcat.accesslog.pattern = common ＃访问日志的格式模式。
server.tomcat.accesslog.prefix = access_log ＃日志文件名前缀。
server.tomcat.accesslog.rename-on-rotate = false ＃是否推迟在文件名中包含日期戳，直到旋转时间。
server.tomcat.accesslog.request-attributes-enabled = false＃设置请求的IP地址，主机名，协议和端口的请求属性。
server.tomcat.accesslog.rotate = true ＃是否启用访问日志循环。
server.tomcat.accesslog.suffix = .log ＃日志文件名后缀。
server.tomcat.additional-tld-skip-patterns = ＃逗号分隔的其他模式列表，这些模式与jars匹配，以供TLD扫描忽略。
server.tomcat.background-processor-delay = 10s ＃调用backgroundProcess方法之间的延迟。如果未指定持续时间后缀，则将使用秒。
server.tomcat.basedir = ＃Tomcat基本目录。如果未指定，则使用一个临时目录。
server.tomcat.internal-proxies = 10 \\。\\ d {1,3} \\。\\ d {1,3} \\。\\ d {1,3} | \\
		192 \\。168 \\。\\ d {1,3} \\。\\ d {1,3} | \\
		169 \\。254 \\ .. \\ d {1,3} \\。\\ d {1,3} | \\
		127 \\。\\ d {1,3} \\。\\ d {1,3} \\。\\ d {1,3} | \\
		172 \\。1 [6-9] {1} \\。\\ d {1,3} \\。\\ d {1,3} | \\
		172 \\。2 [0-9] {1} \\。\\ d {1,3} \\。\\ d {1,3} | \\
		172 \\。3 [0-1] {1} \\。\\ d {1,3} \\。\\ d {1,3} \\
		0：0：0：0：0：0：0：1 \\
 		:: 1 ＃匹配要信任的代理的正则表达式。
server.tomcat.max-connections = 10000 ＃服务器在任何给定时间接受和处理的最大连接数。
server.tomcat.max-http-post-size = 2MB ＃HTTP帖子内容的最大大小。
server.tomcat.max-swallow-size = 2MB ＃可吞咽的请求正文的最大数量。
server.tomcat.max-threads = 200 ＃工作线程的最大数量。
server.tomcat.min-spare-threads = 10 ＃辅助线程的最小数量。
server.tomcat.port-header = X转发端口＃用于覆盖原始端口值的HTTP标头的名称。
server.tomcat.protocol-header = ＃包含传入协议的标头，通常命名为“ X-Forwarded-Proto”。
server.tomcat.protocol-header-https-value = https ＃协议头的值，指示传入的请求是否使用SSL。
server.tomcat.redirect-context-root = true ＃是否应通过在路径后附加/来重定向对上下文根的请求。
server.tomcat.remote-ip-header = ＃从中提取远程IP的HTTP标头的名称。例如，“ X-FORWARDED-FOR”。
server.tomcat.resource.allow-caching = true＃此Web应用程序是否允许静态资源缓存。
server.tomcat.resource.cache-ttl = ＃静态资源缓存的生存时间。
server.tomcat.uri-encoding = UTF-8 ＃用于解码URI的字符编码。
server.tomcat.use-relative-redirects = ＃通过sendRedirect调用生成的HTTP 1.1和更高版本的位置标头将使用相对还是绝对重定向。
server.undertow.accesslog.dir = ＃Undertow访问日志目录。
server.undertow.accesslog.enabled = false ＃是否启用访问日志。
server.undertow.accesslog.pattern = common ＃访问日志的格式模式。
server.undertow.accesslog.prefix = access_log。＃日志文件名前缀。
server.undertow.accesslog.rotate = true ＃是否启用访问日志
循环。server.undertow.accesslog.suffix = log ＃日志文件名后缀。
server.undertow.buffer-size = ＃每个缓冲区的大小。
server.undertow.direct-buffers = ＃是否在Java堆之外分配缓冲区。缺省值是从JVM可用的最大内存量得出的。
server.undertow.eager-filter-init = true ＃是否在启动时初始化servlet过滤器。
server.undertow.io-threads =＃为工作线程创建的I / O线程数。默认值是根据可用处理器的数量得出的。
server.undertow.max-http-post-size = -1B ＃HTTP帖子内容的最大大小。当值是-1（默认值）时，大小是无限的。
server.undertow.worker-threads = ＃工作线程数。默认值为I / O线程数的8倍。

＃FREEMARKER（FreeMarkerProperties）
 spring.freemarker.allow-request-override = false ＃是否允许HttpServletRequest属性覆盖（隐藏）控制器生成的同名模型属性。
spring.freemarker.allow-session-override = false ＃是否允许HttpSession属性覆盖（隐藏）控制器生成的同名模型属性。
spring.freemarker.cache = false ＃是否启用模板缓存。
spring.freemarker.charset = UTF-8 ＃模板编码。
spring.freemarker.check-template-location = true ＃是否检查模板位置是否存在。
spring.freemarker.content-type =文本/ html ＃Content-Type值。
spring.freemarker.enabled = true ＃是否为此技术启用MVC视图解析。
spring.freemarker.expose-request-attributes = false ＃在与模板合并之前是否应将所有请求属性添加到模型中。
spring.freemarker.expose-session-attributes = false ＃在与模板合并之前是否应将所有HttpSession属性添加到模型中。
spring.freemarker.expose-spring-macro-helpers = true ＃是否以“ springMacroRequestContext”的名义公开供Spring的宏库使用的RequestContext。
spring.freemarker.prefer-file-system-access = true ＃是否更喜欢文件系统访问进行模板加载。通过文件系统访问，可以热检测模板更改。
spring.freemarker.prefix = ＃前缀，用于在构建URL时查看名称。
spring.freemarker.request-context-attribute = ＃所有视图的
RequestContext属性的名称。spring.freemarker.settings。* = ＃众所周知的FreeMarker密钥，这些密钥将传递到FreeMarker的配置中。
spring.freemarker.suffix = .ftl ＃在构建URL时添加到视图名称的后缀。
spring.freemarker.template-loader-path = classpath：/模板/＃逗号分隔的模板路径列表。
spring.freemarker.view-names = ＃可以解析的视图名称的白名单。

＃GROOVY TEMPLATES（GroovyTemplateProperties）
 spring.groovy.template.allow-request-override = false ＃是否允许HttpServletRequest属性覆盖（隐藏）控制器生成的同名模型属性。
spring.groovy.template.allow-session-override = false ＃是否允许HttpSession属性覆盖（隐藏）控制器生成的同名模型属性。
spring.groovy.template.cache = false ＃是否启用模板缓存。
spring.groovy.template.charset = UTF-8 ＃模板编码。
spring.groovy.template.check-template-location = true＃是否检查模板位置。
spring.groovy.template.configuration。* = ＃参见GroovyMarkupConfigurer 
spring.groovy.template.content-type = text / html ＃Content-Type值。
spring.groovy.template.enabled = true ＃是否为此技术启用MVC视图解析。
spring.groovy.template.expose-request-attributes = false ＃在与模板合并之前是否应将所有请求属性添加到模型中。
spring.groovy.template.expose-session-attributes = false ＃在与模板合并之前是否应将所有HttpSession属性添加到模型中。
spring.groovy.template.expose-spring-macro-helpers = true ＃是否公开一个RequestContext供Spring的宏库使用，名称为“ springMacroRequestContext”。
spring.groovy.template.prefix = ＃在构建URL时会被前缀为查看名称的前缀。
spring.groovy.template.request-context-attribute = ＃所有视图的
RequestContext属性的名称。spring.groovy.template.resource-loader-path = classpath：/ templates / ＃模板路径。
spring.groovy.template.suffix = .tpl ＃在构建URL时添加到视图名称的后缀。
spring.groovy.template.view-names =＃可以解析的视图名称的白名单。

＃SPRING HATEOAS（HateoasProperties）
 spring.hateoas.use-hal-as-default-json-media-type = true ＃是否应将application / hal + json响应发送给接受application / json的请求。

＃HTTP （HttpProperties）
 spring.http.converters.preferred-json-mapper = ＃用于HTTP消息转换的首选JSON映射器。默认情况下，根据环境自动检测。
spring.http.encoding.charset = UTF-8 ＃HTTP请求和响应的字符集。如果未明确设置，则添加到“ Content-Type”标题中。
spring.http.encoding.enabled = true ＃是否启用HTTP编码支持。
spring.http.encoding.force = ＃是否在HTTP请求和响应上强制对配置的字符集进行编码。
spring.http.encoding.force-request =＃是否在HTTP请求中强制对配置的字符集进行编码。如果未指定“力”，则默认为true。
spring.http.encoding.force-response = ＃是否在HTTP响应上强制对配置的字符集进行编码。
spring.http.encoding.mapping = ＃编码映射的语言环境。
spring.http.log-request-details = false ＃是否允许在DEBUG和TRACE级别记录（可能敏感的）请求详细信息。

＃MULTIPART （MultipartProperties）
 spring.servlet.multipart.enabled = true ＃是否启用对分段上传的支持。
spring.servlet.multipart.file-size-threshold = 0B ＃阈值，之后将文件写入磁盘。
spring.servlet.multipart.location = ＃上传文件的中间位置。
spring.servlet.multipart.max-file-size = 1MB ＃最大文件大小。
spring.servlet.multipart.max-request-size = 10MB ＃最大请求大小。
spring.servlet.multipart.resolve-lazily = false ＃是否在文件或参数访问时延迟解决多部分请求。

＃JACKSON （JacksonProperties）
 spring.jackson.date-format = ＃日期格式字符串或标准日期格式类名称。例如，`yyyy-MM-dd HH：mm：ss`。
spring.jackson.default-property-inclusion = ＃控制序列化过程中属性的包含。使用Jackson的JsonInclude.Include枚举中的值之一进行配置。
spring.jackson.deserialization。* = ＃影响Java对象反序列化方式的Jackson开关功能。
spring.jackson.generator。* = ＃发电机的Jackson开/关功能。
spring.jackson.joda-date-time-format =＃Joda日期时间格式字符串。如果未配置，则“ date-format”如果配置了格式字符串，则用作后备。
spring.jackson.locale = ＃用于格式化的语言环境。
spring.jackson.mapper。* = ＃Jackson通用开/关功能。
spring.jackson.parser。* = ＃解析器的Jackson开/关功能。
spring.jackson.property-naming-strategy = ＃杰克逊的PropertyNamingStrategy的常量之一。也可以是PropertyNamingStrategy子类的标准类名。
spring.jackson.serialization。* = ＃影响Java对象序列化方式的Jackson开关功能。
spring.jackson.time-zone =＃格式化日期时使用的时区。例如，“ America / Los_Angeles”或“ GMT + 10”。
spring.jackson.visibility。* = ＃杰克逊可见性阈值，可用于限制自动检测哪些方法（和字段）。

＃GSON（GsonProperties）
 spring.gson.date-format = ＃序列化Date对象时使用的格式。
spring.gson.disable-html-escaping = ＃是否禁用转义HTML字符，例如'<'，'>'等
。spring.gson.disable-inner-class-serialization = ＃是否在执行过程中排除内部类序列化。
spring.gson.enable-complex-map-key-serialization = ＃是否启用序列化复杂映射键（即非原始）。
spring.gson.exclude-fields-without-expose-annotation = ＃是否将所有不包含“ Expose”注释的字段从序列化或反序列化考虑中排除。
spring.gson.field-naming-policy = ＃在序列化和反序列化期间应应用于对象字段的命名策略。
spring.gson.generate-non-executable-json = ＃是否通过在输出前添加一些特殊文本来生成不可执行的JSON。
spring.gson.lenient = ＃是否宽容解析不符合RFC 4627的
JSON。spring.gson.long-serialization-policy = ＃Long和long类型的序列化策略。
spring.gson.pretty-printing = ＃是否输出适合页面进行漂亮打印的序列化JSON。
spring.gson.serialize-nulls = ＃是否对空字段进行序列化。

＃JERSEY （JerseyProperties）
 spring.jersey.application-path = ＃用作应用程序基本URI的路径。如果指定，将覆盖“ @ApplicationPath”的值。
spring.jersey.filter.order = 0 ＃球衣过滤链的顺序。
spring.jersey.init。* = ＃初始化参数通过servlet或过滤器传递给Jersey。
spring.jersey.servlet.load-on-startup = -1 ＃加载Jersey servlet的启动优先级。
spring.jersey.type = servlet ＃球衣集成类型。

＃SPRING LDAP（LdapProperties）
 spring.ldap.anonymous-read-only = false ＃只读操作是否应使用匿名环境。
spring.ldap.base = ＃所有操作应从其开始的基本后缀。
spring.ldap.base-environment。* = ＃LDAP规范设置。
spring.ldap.password = ＃服务器的登录密码。
spring.ldap.urls = ＃服务器的LDAP URL。
spring.ldap.username = ＃服务器的登录用户名。

＃EMBEDDED LDAP（EmbeddedLdapProperties）
 spring.ldap.embedded.base-dn = ＃基本DN的列表。
spring.ldap.embedded.credential.username = ＃嵌入式LDAP用户名。
spring.ldap.embedded.credential.password = ＃嵌入式LDAP密码。
spring.ldap.embedded.ldif = classpath：schema.ldif ＃架构（LDIF）脚本资源参考。
spring.ldap.embedded.port = 0 ＃嵌入式LDAP端口。
spring.ldap.embedded.validation.enabled = true ＃是否启用LDAP模式验证。
spring.ldap.embedded.validation.schema = ＃定制模式的路径。

＃MUSTACHE TEMPLATES（MustacheAutoConfiguration）
 spring.mustache.allow-request-override = false ＃是否允许HttpServletRequest属性覆盖（隐藏）控制器生成的同名模型属性。
spring.mustache.allow-session-override = false ＃是否允许HttpSession属性覆盖（隐藏）控制器生成的同名模型属性。
spring.mustache.cache = false ＃是否启用模板缓存。
spring.mustache.charset = UTF-8 ＃模板编码。
spring.mustache.check-template-location = true ＃是否检查模板位置是否存在。
spring.mustache.content-type =文本/ html ＃Content-Type值。
spring.mustache.enabled = true ＃是否为此技术启用MVC视图解析。
spring.mustache.expose-request-attributes = false ＃在与模板合并之前是否应将所有请求属性添加到模型中。
spring.mustache.expose-session-attributes = false ＃在与模板合并之前是否应将所有HttpSession属性添加到模型中。
spring.mustache.expose-spring-macro-helpers = true ＃是否以“ springMacroRequestContext”的名义公开供Spring的宏库使用的RequestContext。
spring.mustache.prefix= classpath：/ templates / ＃适用于模板名称的前缀。
spring.mustache.request-context-attribute = ＃所有视图的
RequestContext属性的名称。spring.mustache.suffix = .mustache ＃后缀应用于模板名称。
spring.mustache.view-names = ＃可以解析的视图名称的白名单。

＃SPRING MVC（WebMvcProperties）
 spring.mvc.async.request-timeout = ＃异步请求处理
超时之前的时间。spring.mvc.contentnegotiation.favor-parameter = false ＃是否应使用请求参数（默认为“格式”）来确定请求的媒体类型。
spring.mvc.contentnegotiation.favor-path-extension = false ＃是否应使用URL路径中的路径扩展来确定请求的媒体类型。
spring.mvc.contentnegotiation.media-types。* = ＃将文件扩展名映射到用于内容协商的媒体类型。例如，将yml转换为text / yaml。
spring.mvc.contentnegotiation.parameter-name =＃查询启用“收藏参数”时使用的参数名称。
spring.mvc.date-format = ＃要使用的日期格式。例如，“ dd / MM / yyyy”。
spring.mvc.dispatch-trace-request = false ＃是否将TRACE请求分派到FrameworkServlet doService方法。
spring.mvc.dispatch-options-request = true ＃是否将OPTIONS请求分派到FrameworkServlet doService方法。
spring.mvc.favicon.enabled = true ＃是否启用favicon.ico的解析。
spring.mvc.formcontent.filter.enabled = true ＃是否启用Spring的FormContentFilter。
spring.mvc.hiddenmethod.filter.enabled = true＃是否启用Spring的HiddenHttpMethodFilter。
spring.mvc.ignore-default-model-on-redirect = true ＃在重定向方案中是否应忽略“默认”模型的内容。
spring.mvc.locale = ＃要使用的语言环境。默认情况下，此语言环境被“ Accept-Language”标头覆盖。
spring.mvc.locale-resolver = accept-header ＃定义如何解析语言环境。
spring.mvc.log-resolved-exception = false ＃是否启用警告记录由“ HandlerExceptionResolver”解决的异常，“ DefaultHandlerExceptionResolver”除外。
spring.mvc.message-codes-resolver-format =＃消息代码的格式化策略。例如，`PREFIX_ERROR_CODE`。
spring.mvc.pathmatch.use-registered-suffix-pattern = false ＃后缀模式匹配是否仅对“ spring.mvc.contentnegotiation.media-types。*”注册的扩展名有效。
spring.mvc.pathmatch.use-suffix-pattern = false ＃将模式匹配到请求时是否使用后缀模式匹配（“。*”）。
spring.mvc.servlet.load-on-startup = -1 ＃加载调度程序servlet的启动优先级。
spring.mvc.servlet.path = / ＃调度程序servlet的路径。
spring.mvc.static-path-pattern = / ** ＃用于静态资源的路径模式。
spring.mvc.throw-exception-if-no-handler-found = false ＃如果未找到任何处理请求
的处理程序，是否应该抛出“ NoHandlerFoundException”。spring.mvc.view.prefix = ＃Spring MVC视图前缀。
spring.mvc.view.suffix = ＃Spring MVC视图后缀。

＃春季资源处理（ResourceProperties）
 spring.resources.add-mappings = true ＃是否启用默认资源处理。
spring.resources.cache.cachecontrol.cache-private = ＃表示响应消息是针对单个用户的，不能由共享缓存存储。
spring.resources.cache.cachecontrol.cache-public = ＃表示任何缓存都可以存储响应。
spring.resources.cache.cachecontrol.max-age = ＃应该缓存响应的最长时间，如果未指定持续时间后缀，则以秒为单位。
spring.resources.cache.cachecontrol.must-revalidate =＃表示一旦过时，缓存必须在未与服务器重新验证响应的情况下使用响应。
spring.resources.cache.cachecontrol.no-cache = ＃表示只有在与服务器重新验证后，缓存的响应才可以重用。
spring.resources.cache.cachecontrol.no-store = ＃表示在任何情况下都不缓存响应。
spring.resources.cache.cachecontrol.no-transform = ＃指示中介（缓存和其他）不应转换响应内容。
spring.resources.cache.cachecontrol.proxy-revalidate = ＃与“必须重新验证”指令含义相同，不同之处在于它不适用于专用缓存。
spring.resources.cache.cachecontrol.s-max-age = ＃共享缓存应将响应缓存的最长时间，如果未指定持续时间后缀，则以秒为单位。
spring.resources.cache.cachecontrol.stale-if-error = ＃遇到错误时可以使用响应的最长时间，如果未指定持续时间后缀，则以秒为单位。
spring.resources.cache.cachecontrol.stale-while-revalidate = ＃响应过期后可以提供服务的最长时间，如果未指定持续时间后缀，
则以秒为单位。spring.resources.cache.period = ＃资源处理程序服务的资源的缓存周期。如果未指定持续时间后缀，则将使用秒。
spring.resources.chain.cache= true ＃是否在资源链中启用缓存。
spring.resources.chain.compressed = false ＃是否启用已压缩资源（gzip，brotli）的解析。
spring.resources.chain.enabled = ＃是否启用Spring资源处理链。默认情况下，除非已启用至少一种策略，否则禁用。
spring.resources.chain.html-application-cache = false ＃是否启用HTML5应用程序缓存清单重写。
spring.resources.chain.strategy.content.enabled = false ＃是否启用内容版本策略。
spring.resources.chain.strategy.content.paths = / **＃逗号分隔的模式列表，以应用于内容版本策略。
spring.resources.chain.strategy.fixed.enabled = false ＃是否启用固定版本策略。
spring.resources.chain.strategy.fixed.paths = / ** ＃逗号分隔的模式列表，以应用于固定的版本策略。
spring.resources.chain.strategy.fixed.version = ＃用于固定版本策略的版本字符串。
spring.resources.static-locations = classpath：/ META-INF / resources /，classpath：/ resources /，classpath：/ static /，classpath：/ public / ＃静态资源的位置。

＃SPRING SESSION（SessionProperties）
 spring.session.store-type = ＃会话存储类型。
spring.session.timeout = ＃会话超时。如果未指定持续时间后缀，则将使用秒。
spring.session.servlet.filter-order = -2147483598 ＃会话存储库过滤器顺序。
spring.session.servlet.filter-dispatcher-types = async，error，request ＃会话存储库过滤器分派器类型。

＃SPRING SESSION HAZELCAST（HazelcastSessionProperties）
 spring.session.hazelcast.flush-mode = on-save ＃会话刷新模式。
spring.session.hazelcast.map-name = spring：session：sessions ＃用于存储会话的地图名称。

＃SPRING SESSION JDBC（JdbcSessionProperties）
 spring.session.jdbc.cleanup-cron = 0 * * * * * ＃过期会话清除作业的Cron表达式。
spring.session.jdbc.initialize-schema = embedded ＃数据库模式初始化模式。
spring.session.jdbc.schema = classpath：org / springframework / session / jdbc / schema- @ @ platform @ @ .sql ＃用于初始化数据库架构的SQL文件的路径。
spring.session.jdbc.table-name = SPRING_SESSION ＃用于存储会话的数据库表的名称。

＃SPRING SESSION MONGODB（MongoSessionProperties）
 spring.session.mongodb.collection-name = sessions ＃用于存储会话的集合名称。

＃SPRING SESSION REDIS（RedisSessionProperties）
 spring.session.redis.cleanup-cron = 0 * * * * * ＃过期会话清除作业的Cron表达式。
spring.session.redis.flush-mode = on-save ＃会话刷新模式。
spring.session.redis.namespace = spring：session ＃用于存储会话的键的命名空间。

＃THYMELEAF（ThymeleafAutoConfiguration）
 spring.thymeleaf.cache = true ＃是否启用模板缓存。
spring.thymeleaf.check-template = true ＃渲染前是否检查模板是否存在。
spring.thymeleaf.check-template-location = true ＃是否检查模板位置是否存在。
spring.thymeleaf.enabled = true ＃是否为Web框架启用Thymeleaf视图解析。
spring.thymeleaf.enable-spring-el-compiler = false ＃在SpringEL表达式中启用SpringEL编译器。
spring.thymeleaf.encoding = UTF-8 ＃模板文件编码。
spring.thymeleaf.excluded-view-names = ＃逗号分隔的视图名称列表（允许的模式），应从分辨率中排除。
spring.thymeleaf.mode = HTML ＃应用于模板的模板模式。另请参见Thymeleaf的TemplateMode枚举。
spring.thymeleaf.prefix = classpath：/ templates / ＃前缀，用于在构建URL时查看名称。
spring.thymeleaf.reactive.chunked-mode-view-names = ＃以逗号分隔的视图名称列表（允许的模式），当设置最大块大小时，该列表应该是在CHUNKED模式下唯一执行的视图名称。
spring.thymeleaf.reactive.full-mode-view-names =＃即使设置了最大块大小，也应以FULL模式执行的视图名称的逗号分隔列表（允许的模式）。
spring.thymeleaf.reactive.max-chunk-size = 0B ＃用于写入响应的数据缓冲区的最大大小。
spring.thymeleaf.reactive.media-types = ＃视图技术支持的媒体类型。
spring.thymeleaf.render-hidden-markers-before-checkboxes = false ＃是否应在复选框元素本身之前呈现用作复选框标记的隐藏表单输入。
spring.thymeleaf.servlet.content-type = text / html ＃写入HTTP响应的Content-Type值。
spring.thymeleaf.servlet.produce-partial-output-while-processing = true＃Thymeleaf是应该尽快开始写入部分输出还是缓冲直到模板处理完成。
spring.thymeleaf.suffix = .html ＃构建URL时后缀添加到视图名称。
spring.thymeleaf.template-resolver-order = ＃模板解析器在链中的顺序。
spring.thymeleaf.view-names = ＃可以解决的视图名称列表（以逗号分隔）。

＃SPRING WEBFLUX（WebFluxProperties）
 spring.webflux.date-format = ＃要使用的日期格式。例如，“ dd / MM / yyyy”。
spring.webflux.hiddenmethod.filter.enabled = true ＃是否启用Spring的HiddenHttpMethodFilter。
spring.webflux.static-path-pattern = / ** ＃用于静态资源的路径模式。

＃春季Web服务（WebServicesProperties）
 spring.webservices.path = / services ＃用作服务基本URI的路径。
spring.webservices.servlet.init = ＃Servlet初始化参数传递给Spring Web Services。
spring.webservices.servlet.load-on-startup = -1 ＃加载Spring Web Services servlet的启动优先级。
spring.webservices.wsdl-locations = ＃逗号分隔的WSDL和随附的XSD位置列表，将其公开为bean。


＃---------------------------------------- 
＃安全属性
＃----- ----------------------------------- 
＃安全（SecurityProperties）
 spring.security.filter.order = -100 ＃安全过滤器链顺序。
spring.security.filter.dispatcher-types = async，error，request ＃安全过滤器链调度程序类型。
spring.security.user.name =用户＃默认用户名。
spring.security.user.password = ＃默认用户名的密码。
spring.security.user.roles = ＃授予默认用户名角色。

＃安全OAUTH2客户（OAuth2ClientProperties）
 spring.security.oauth2.client.provider。* = ＃OAuth提供者详细信息。
spring.security.oauth2.client.registration。* = ＃OAuth客户端注册。

＃安全OAUTH2资源服务器（OAuth2ResourceServerProperties）
 spring.security.oauth2.resourceserver.jwt.jwk-set-uri = ＃用于验证JWT令牌的JSON Web密钥URI。
   spring.security.oauth2.resourceserver.jwt.issuer-uri = ＃OpenID Connect提供程序断言为其发布者标识符的URI。

＃---------------------------------------- 
＃数据属性
＃----- -----------------------------------

＃FLYWAY （FlywayProperties）
 spring.flyway.baseline-description = << Flyway Baseline >> ＃应用基线时用于标记现有模式的描述。
spring.flyway.baseline-on-migrate = false ＃迁移非空模式时是否自动调用基线。
spring.flyway.baseline-version = 1 ＃执行基线时用来标记现有模式的版本。
spring.flyway.check-location = true ＃是否检查迁移脚本的位置。
spring.flyway.clean-disabled = false ＃是否禁用数据库清理。
spring.flyway.clean-validation-error = false＃发生验证错误时是否自动调用clean。
spring.flyway.connect-retries = 0 ＃尝试连接数据库时的最大重试次数。
spring.flyway.enabled = true ＃是否启用飞行。
spring.flyway.encoding = UTF-8 ＃SQL迁移的编码。
spring.flyway.group = false ＃应用时是否在同一事务中将所有未完成的迁移分组在一起。
spring.flyway.ignore-future-migrations = true ＃阅读架构历史记录表时是否忽略将来的迁移。
spring.flyway.ignore-ignored-migrations = false＃在读取架构历史记录表时是否忽略忽略的迁移。
spring.flyway.ignore-missing-migrations = false ＃阅读架构历史记录表时是否忽略丢失的迁移。
spring.flyway.ignore-pending-migrations = false ＃阅读架构历史记录表时是否忽略挂起的迁移。
spring.flyway.init-sqls = ＃获取连接后立即执行以初始化连接的SQL语句。
spring.flyway.installed-by = ＃记录在架构历史记录表中的用户名已应用了迁移。
spring.flyway.locations = classpath：db / migration＃迁移脚本的位置。可以包含特殊的“ {vendor}”占位符以使用特定于供应商的位置。
spring.flyway.mixed = false ＃是否允许在同一迁移中混合使用事务性和非事务性语句。
spring.flyway.out-of-order = false ＃是否允许迁移
顺序混乱。spring.flyway.password = ＃要迁移的数据库的登录密码。
spring.flyway.placeholder-prefix = $ { ＃迁移脚本中占位符的前缀。
spring.flyway.placeholder-replacement = true ＃在迁移脚本中执行占位符替换。
spring.flyway.placeholder-suffix =}＃迁移脚本中占位符的后缀。
spring.flyway.placeholders = ＃用于SQL迁移脚本的占位符及其替换。
spring.flyway.repeatable-sql-migration-prefix = R ＃可重复SQL迁移的文件名前缀。
spring.flyway.schemas = ＃由
Flyway管理的方案名称（区分大小写）。spring.flyway.skip-default-callbacks = false ＃是否跳过默认回调。如果为true，则仅使用自定义回调。
spring.flyway.skip-default-resolvers = false ＃是否跳过默认解析器。如果为true，则仅使用自定义解析器。
spring.flyway.sql-migration-prefix = V＃SQL迁移的文件名前缀。
spring.flyway.sql-migration-separator = __ ＃SQL迁移的文件名分隔符。
spring.flyway.sql-migration-suffixes = .sql ＃SQL迁移的文件名后缀。
spring.flyway.table = flyway_schema_history ＃
 Flyway将使用的架构架构历史记录表的名称。spring.flyway.target = ＃应该考虑移植的目标版本。
spring.flyway.url = ＃要迁移的数据库的JDBC URL。如果未设置，则使用主要配置的数据源。
spring.flyway.user = ＃要迁移的数据库登录用户。
spring.flyway.validate-on-migrate = true ＃执行迁移时是否自动调用validate。

＃LIQUIBASE（LiquibaseProperties）
 spring.liquibase.change-log = classpath：/db/changelog/db.changelog-master.yaml＃更改日志配置路径。
spring.liquibase.check-change-log-location = true ＃是否检查变更日志位置。
spring.liquibase.contexts = ＃要使用的运行时上下文列表，以逗号分隔。
spring.liquibase.database-change-log-lock-table = DATABASECHANGELOGLOCK ＃用于跟踪并发Liquibase使用情况的表的名称。
spring.liquibase.database-change-log-table = DATABASECHANGELOG ＃用于跟踪变更历史
记录的表的名称。spring.liquibase.default模式= ＃默认数据库架构。
spring.liquibase.drop-first = false ＃是否首先删除数据库模式。
spring.liquibase.enabled = true ＃是否启用Liquibase支持。
spring.liquibase.labels = ＃要使用的运行时标签列表，以逗号分隔。
spring.liquibase.liquibase-schema = ＃用于Liquibase对象的模式。
spring.liquibase.liquibase-tablespace = ＃用于Liquibase对象的表空间。
spring.liquibase.parameters。* = ＃更改日志参数。
spring.liquibase.password = ＃要迁移的数据库的登录密码。
spring.liquibase.rollback-file = ＃执行更新时写入回滚SQL的文件。
spring.liquibase.test-rollback-on-update = false ＃在执行更新之前是否应测试回滚。
spring.liquibase.url = ＃要迁移的数据库的JDBC URL。如果未设置，则使用主要配置的数据源。
spring.liquibase.user = ＃要迁移的数据库登录用户。

＃COUCHBASE（CouchbaseProperties）
 spring.couchbase.bootstrap-hosts = ＃要引导的Couchbase节点（主机或IP地址）。
spring.couchbase.bucket.name = default ＃要连接的桶的名称。
spring.couchbase.bucket.password =   ＃存储桶的密码。
spring.couchbase.env.endpoints.key-value = 1 ＃每个键/值服务对应的套接字数。
spring.couchbase.env.endpoints.queryservice.min-endpoints = 1 ＃每个节点的最小套接字数。
spring.couchbase.env.endpoints.queryservice.max-endpoints = 1 ＃每个节点的最大套接字数。
spring.couchbase.env.endpoints.viewservice.min-endpoints = 1 ＃每个节点的最小套接字数。
spring.couchbase.env.endpoints.viewservice.max-endpoints = 1 ＃每个节点的最大套接字数。
spring.couchbase.env.ssl.enabled = ＃是否启用SSL支持。除非另有说明，否则如果提供了“ keyStore”，则自动启用。
spring.couchbase.env.ssl.key-store = ＃持有证书的JVM密钥库的路径。
spring.couchbase.env.ssl.key-store-password = ＃用于访问密钥库的密码。
spring.couchbase.env.timeouts.connect = 5000ms ＃存储桶连接超时。
spring.couchbase.env.timeouts.key-value = 2500ms ＃阻止对特定键超时执行的操作。
spring.couchbase.env.timeouts.query = 7500ms ＃N1QL查询操作超时。
spring.couchbase.env.timeouts.socket-connect = 1000ms ＃套接字连接超时。
spring.couchbase.env.timeouts.view = 7500ms ＃常规和地理空间视图操作超时。

＃DAO （PersistenceExceptionTranslationAutoConfiguration）
 spring.dao.exceptiontranslation.enabled = true ＃是否启用PersistenceExceptionTranslationPostProcessor。

＃CASSANDRA （CassandraProperties）
 spring.data.cassandra.cluster-name = ＃Cassandra集群的名称。
spring.data.cassandra.compression = none ＃Cassandra二进制协议支持的压缩。
spring.data.cassandra.connect-timeout = ＃套接字选项：连接超时。
spring.data.cassandra.consistency-level = ＃查询一致性级别。
spring.data.cassandra.contact-points = localhost ＃集群节点地址。
spring.data.cassandra.fetch-size = ＃查询默认提取大小。
spring.data.cassandra.jmx-enabled = false＃是否启用JMX报告。
spring.data.cassandra.keyspace-name = ＃要使用的键空间名称。
spring.data.cassandra.port = ＃Cassandra服务器的端口。
spring.data.cassandra.password = ＃服务器的登录密码。
spring.data.cassandra.pool.heartbeat-interval = 30s ＃心跳间隔，在此间隔之后，将在空闲连接上发送一条消息，以确保消息仍然有效。如果未指定持续时间后缀，则将使用秒。
spring.data.cassandra.pool.idle-timeout = 120s ＃删除空闲连接之前的空闲超时。如果未指定持续时间后缀，则将使用秒。
spring.data.cassandra.pool.max-queue-size= 256 ＃如果没有可用的连接，排队的最大请求数。
spring.data.cassandra.pool.pool-timeout = 5000ms ＃尝试从主机池中获取连接时，池超时。
spring.data.cassandra.read-timeout = ＃套接字选项：读取超时。
spring.data.cassandra.repositories.type = auto ＃要启用的Cassandra仓库的类型。
spring.data.cassandra.serial-consistency-level = ＃查询序列一致性级别。
spring.data.cassandra.schema-action = none ＃启动时采取的模式操作。
spring.data.cassandra.ssl = false ＃启用SSL支持。
spring.data.cassandra.username = ＃服务器的登录用户。

＃DATA COUCHBASE（CouchbaseDataProperties）
 spring.data.couchbase.auto-index = false ＃自动创建视图和索引。
spring.data.couchbase.consistency = read-your-own-writes ＃一致性，默认情况下应用于生成的查询。
spring.data.couchbase.repositories.type = auto ＃要启用的Couchbase存储库的类型。

＃ELASTICSEARCH（ElasticsearchProperties）
 spring.data.elasticsearch.cluster-name = elasticsearch ＃Elasticsearch集群名称。
spring.data.elasticsearch.cluster-nodes = ＃集群节点地址的逗号分隔列表。
spring.data.elasticsearch.properties。* = ＃用于配置客户端的其他属性。
spring.data.elasticsearch.repositories.enabled = true ＃是否启用Elasticsearch存储库。


＃DATA JDBC spring.data.jdbc.repositories.enabled = true ＃是否启用JDBC存储库。


＃DATA LDAP spring.data.ldap.repositories.enabled = true ＃是否启用LDAP存储库。

＃MONGODB（MongoProperties）
 spring.data.mongodb.authentication-database = ＃认证数据库名称。
spring.data.mongodb.database = ＃数据库名称。
spring.data.mongodb.field-naming-strategy = ＃要使用的FieldNamingStrategy的全限定名称。
spring.data.mongodb.grid-fs-database = ＃GridFS数据库名称。
spring.data.mongodb.host = ＃Mongo服务器主机。无法使用URI设置。
spring.data.mongodb.password = ＃mongo服务器的登录密码。无法使用URI设置。
spring.data.mongodb.port = ＃Mongo服务器端口。无法使用URI设置。
spring.data.mongodb.repositories.type = auto ＃要启用的Mongo仓库的类型。
spring.data.mongodb.uri = mongodb：// localhost / test ＃Mongo数据库URI。无法使用主机，端口和凭据进行设置。
spring.data.mongodb.username = ＃mongo服务器的登录用户。无法使用URI设置。

＃DATA REDIS 
spring.data.redis.repositories.enabled = true ＃是否启用Redis存储库。

＃NEO4J（Neo4jProperties）
 spring.data.neo4j.auto-index = none ＃自动索引模式。
spring.data.neo4j.embedded.enabled = true ＃如果嵌入式驱动程序可用，是否启用嵌入式模式。
spring.data.neo4j.open-in-view = true ＃注册OpenSessionInViewInterceptor 将Neo4j会话绑定到线程以完成请求的整个处理。
spring.data.neo4j.password = ＃服务器的登录密码。
spring.data.neo4j.repositories.enabled = true ＃是否启用Neo4j仓库。
spring.data.neo4j.uri = ＃驱动程序使用的URI。默认情况下自动检测。
spring.data.neo4j.username = ＃服务器的登录用户。

＃DATA REST（RepositoryRestProperties）
 spring.data.rest.base-path = ＃Spring Data REST用于公开存储库资源的基本路径。
spring.data.rest.default-media-type = ＃内容类型，当未指定内容类型时用作默认值。
spring.data.rest.default-page-size = ＃
页面的默认大小。spring.data.rest.detection-strategy = default ＃用于确定公开哪些存储库的策略。
spring.data.rest.enable-enum-translation = ＃是否通过Spring Data REST默认资源包启用枚举值转换。
spring.data.rest.limit-param-name =＃URL查询字符串参数的名称，该参数指示一次返回多少结果。
spring.data.rest.max-page-size = ＃
页面的最大大小。spring.data.rest.page-param-name = ＃URL查询字符串参数的名称，该参数指示要返回的页面。
spring.data.rest.return-body-on-create = ＃创建实体后是否返回响应主体。
spring.data.rest.return-body-on-update = ＃更新实体后是否返回响应主体。
spring.data.rest.sort-param-name = ＃URL查询字符串参数的名称，该参数指示对结果进行排序的方向。

＃SOLR （SolrProperties）
 spring.data.solr.host = http：//127.0.0.1：8983 / solr ＃Solr主机。忽略是否设置了“ zk-host”。
spring.data.solr.repositories.enabled = true ＃是否启用Solr仓库。
spring.data.solr.zk-host = ＃ZooKeeper主机地址，格式为HOST：PORT。

＃DATA WEB（SpringDataWebProperties）
 spring.data.web.pageable.default页大小= 20 ＃缺省页大小。
spring.data.web.pageable.max-page-size = 2000 ＃接受的最大页面大小。
spring.data.web.pageable.one-indexed-parameters = false ＃是否公开并假设基于1的页码索引。
spring.data.web.pageable.page-parameter = page ＃页面索引参数名称。
spring.data.web.pageable.prefix = ＃在页码和页面大小参数之前的通用前缀。
spring.data.web.pageable.qualifier-delimiter = _＃在限定符与实际页码和大小属性之间使用的定界符。
spring.data.web.pageable.size-parameter = size ＃页面大小参数名称。
spring.data.web.sort.sort-parameter = sort ＃排序参数名称。

＃DATASOURCE （DataSourceAutoConfiguration＆DataSourceProperties）
 spring.datasource.continue-on-error = false ＃如果初始化数据库时发生错误，是否停止。
spring.datasource.data = ＃数据（DML）脚本资源引用。
spring.datasource.data-username = ＃执行DML脚本的数据库
用户名（如果不同）。spring.datasource.data-password = ＃执行DML脚本的数据库密码（如果不同）。
spring.datasource.dbcp2。* = ＃公用DBCP2特定设置
spring.datasource.driver-class-name =＃JDBC驱动程序的全限定名称。默认情况下根据URL自动检测。
spring.datasource.generate-unique-name = false ＃是否生成随机数据源名称。
spring.datasource.hikari。* = ＃Hikari特定设置
spring.datasource.initialization-mode = embedded ＃使用可用的DDL和DML脚本初始化数据源。
spring.datasource.jmx-enabled = false ＃是否启用JMX支持（如果由基础池提供）。
spring.datasource.jndi-name = ＃数据源的JNDI位置。设置时将忽略类，URL，用户名和密码。
spring.datasource.name =＃数据源的名称。使用嵌入式数据库时，默认为“ testdb”。
spring.datasource.password = ＃数据库的登录密码。
spring.datasource.platform = all ＃在DDL或DML脚本中使用的平台（例如
schema- $ {platform} .sql或data- $ {platform} .sql）。spring.datasource.schema = ＃架构（DDL）脚本资源引用。
spring.datasource.schema-username = ＃执行DDL脚本的数据库
用户名（如果不同）。spring.datasource.schema-password = ＃执行DDL脚本的数据库密码（如果不同）。
spring.datasource.separator =;＃SQL初始化脚本中的语句分隔符。
spring.datasource.sql-script-encoding = ＃SQL脚本编码。
spring.datasource.tomcat。* = ＃Tomcat数据源特定设置
spring.datasource.type = ＃要使用的连接池实现的全限定名称。默认情况下，它是从类路径中自动检测到的。
spring.datasource.url = ＃数据库的JDBC URL。
spring.datasource.username = ＃数据库的登录用户名。
spring.datasource.xa.data-source-class-name = ＃XA数据源全限定名。
spring.datasource.xa.properties =＃传递给XA数据源的属性。

＃JEST （Elasticsearch HTTP客户端）（JestProperties）
 spring.elasticsearch.jest.connection-timeout = 3s ＃连接超时。
spring.elasticsearch.jest.multi-threaded = true ＃是否启用来自多个执行线程的连接请求。
spring.elasticsearch.jest.password = ＃登录密码。
spring.elasticsearch.jest.proxy.host = ＃HTTP客户端应使用的代理主机。
spring.elasticsearch.jest.proxy.port = ＃HTTP客户端应使用的代理端口。
spring.elasticsearch.jest.read-timeout = 3s ＃读取超时。
spring.elasticsearch.jest.uris = http：// localhost：9200＃要使用的Elasticsearch实例的逗号分隔列表。
spring.elasticsearch.jest.username = ＃登录用户名。

＃Elasticsearch REST客户端（RestClientProperties）
 spring.elasticsearch.rest.password = ＃凭证密码。
   spring.elasticsearch.rest.uris = http：// localhost：9200 ＃要使用的Elasticsearch实例的逗号分隔列表。
   spring.elasticsearch.rest.username = ＃凭证用户名。

＃H2 Web控制台（H2ConsoleProperties）
 spring.h2.console.enabled = false ＃是否启用控制台。
spring.h2.console.path = / h2-console ＃控制台可用的路径。
spring.h2.console.settings.trace = false ＃是否启用跟踪输出。
spring.h2.console.settings.web-allow-others = false ＃是否启用远程访问。

＃InfluxDB（InfluxDbProperties）
 spring.influx.password = ＃登录密码。
spring.influx.url = ＃要连接的InfluxDB实例的URL。
spring.influx.user = ＃登录用户。

＃JOOQ （JooqProperties）
 spring.jooq.sql-dialect = ＃使用的SQL方言。默认情况下自动检测。

＃JDBC （JdbcProperties）
 spring.jdbc.template.fetch-size = -1 ＃需要更多行时应从数据库中获取的行数。
spring.jdbc.template.max-rows = -1 ＃最大行数。
spring.jdbc.template.query-timeout = ＃查询超时。默认是使用JDBC驱动程序的默认配置。如果未指定持续时间后缀，则将使用秒。

＃JPA （JpaBaseConfiguration，HibernateJpaAutoConfiguration）
 spring.data.jpa.repositories.bootstrap-mode = default ＃JPA存储库的引导模式。
spring.data.jpa.repositories.enabled = true ＃是否启用JPA存储库。
spring.jpa.database = ＃要运行的目标数据库，默认情况下会自动检测到。也可以使用“ databasePlatform”属性来设置。
spring.jpa.database-platform = ＃要操作的目标数据库的名称，默认情况下会自动检测到。可以使用“数据库”枚举来替代设置。
spring.jpa.generate-ddl = false ＃是否在启动时初始化架构。
spring.jpa.hibernate.ddl-auto = ＃DDL模式 这实际上是“ hibernate.hbm2ddl.auto”属性的快捷方式。使用嵌入式数据库且未检测到任何模式管理器时，默认值为“ create-drop”。否则，默认为“无”。
spring.jpa.hibernate.naming.implicit-strategy = ＃隐式命名策略的全限定名称。
spring.jpa.hibernate.naming.physical-strategy = ＃物理命名策略的全限定名称。
spring.jpa.hibernate.use-new-id-generator-mappings = ＃是否对AUTO，TABLE和SEQUENCE使用Hibernate更新的IdentifierGenerator。
spring.jpa.mapping-resources =＃映射资源（相当于persistence.xml中的“映射文件”条目）。
spring.jpa.open-in-view = true ＃注册OpenEntityManagerInViewInterceptor。将JPA EntityManager绑定到线程以完成请求的整个处理。
spring.jpa.properties。* = ＃要在JPA提供程序上设置的其他本机属性。
spring.jpa.show-sql = false ＃是否启用日志记录。

＃JTA （JtaAutoConfiguration）
 spring.jta.enabled = true ＃是否启用JTA支持。
spring.jta.log-dir = ＃事务日志目录。
spring.jta.transaction-manager-id = ＃交易管理器的唯一标识符。

＃ATOMIKOS（AtomikosProperties）
 spring.jta.atomikos.connectionfactory.borrow-connection-timeout = 30 ＃超时，以秒为单位，用于从池中借用连接。
spring.jta.atomikos.connectionfactory.ignore-session-transacted-flag = true ＃创建会话时是否忽略交易标志。
spring.jta.atomikos.connectionfactory.local-transaction-mode = false ＃是否需要本地交易。
spring.jta.atomikos.connectionfactory.maintenance-interval = 60 ＃两次运行池维护线程之间的时间（以秒为单位）。
spring.jta.atomikos.connectionfactory。最大空闲时间= 60＃从池中清除连接的时间（以秒为单位）。
spring.jta.atomikos.connectionfactory.max-lifetime = 0 ＃破坏连接之前可以汇集的时间（以秒为单位）。0表示没有限制。
spring.jta.atomikos.connectionfactory.max-pool-size = 1 ＃池的最大大小。
spring.jta.atomikos.connectionfactory.min-pool-size = 1 ＃池的最小大小。
spring.jta.atomikos.connectionfactory.reap-timeout = 0 = ＃借用连接的接收超时（以秒为单位）。0表示没有限制。
spring.jta.atomikos.connectionfactory.unique-resource-name = jmsConnectionFactory＃在恢复过程中用于标识资源的唯一名称。
spring.jta.atomikos.connectionfactory.xa-connection-factory-class-name = ＃XAConnectionFactory的特定于供应商的实现。
spring.jta.atomikos.connectionfactory.xa-properties = ＃供应商特定的XA属性。
spring.jta.atomikos.datasource.borrow-connection-timeout = 30 ＃超时（以秒为单位），用于从池中借用连接。
spring.jta.atomikos.datasource.concurrent-connection-validation = ＃是否使用并发连接验证。
spring.jta.atomikos.datasource.default-isolation-level = ＃池提供的连接的默认隔离级别。
spring.jta.atomikos.datasource.login-timeout = ＃建立数据库连接
的超时时间（以秒为单位）。spring.jta.atomikos.datasource.maintenance-interval = 60 ＃两次运行池维护线程之间的时间（以秒为单位）。
spring.jta.atomikos.datasource.max-idle-time = 60 ＃从池中清除连接之后的时间（以秒为单位）。
spring.jta.atomikos.datasource.max-lifetime = 0 ＃破坏连接之前可以汇集的时间（以秒为单位）。0表示没有限制。
spring.jta.atomikos.datasource.max-pool-size = 1 ＃池的最大大小。
spring.jta.atomikos.datasource.min-pool-size = 1＃池的最小大小。
spring.jta.atomikos.datasource.reap-timeout = 0 ＃借用连接的接收超时（以秒为单位）。0表示没有限制。
spring.jta.atomikos.datasource.test-query = ＃用于在返回连接之前验证连接的SQL查询或语句。
spring.jta.atomikos.datasource.unique-resource-name = dataSource ＃用于在恢复期间标识资源的唯一名称。
spring.jta.atomikos.datasource.xa-data-source-class-name = ＃XAConnectionFactory的特定于供应商的实现。
spring.jta.atomikos.datasource.xa-properties = ＃供应商特定的XA属性。
spring.jta.atomikos.properties.allow-sub-transactions = true ＃指定是否允许子交易。
spring.jta.atomikos.properties.checkpoint-interval = 500 ＃检查点之间的间隔，表示为两个检查点之间的日志写入数。
spring.jta.atomikos.properties.default-jta-timeout = 10000ms ＃JTA事务的默认超时。
spring.jta.atomikos.properties.default-max-wait-time-on-shutdown = 9223372036854775807 ＃正常关闭（无强制）应等待多长时间才能完成事务。
spring.jta.atomikos.properties.enable-logging = true ＃是否启用磁盘日志记录。
spring.jta.atomikos.properties.force-shutdown-on-vm-exit = false ＃VM关闭是否应该触发事务核心的强制关闭。
spring.jta.atomikos.properties.log-base-dir = ＃应该在其中存储日志文件的目录。
spring.jta.atomikos.properties.log-base-name = tmlog ＃事务日志文件的基本名称。
spring.jta.atomikos.properties.max-actives = 50 ＃最大活动交易数。
spring.jta.atomikos.properties.max-timeout = 300000ms ＃交易允许的最大超时时间。
spring.jta.atomikos.properties.recovery.delay = 10000ms ＃两次恢复扫描之间的延迟。
spring.jta.atomikos.properties.recovery.forget- orphaned -log-entries-delay = 86400000ms ＃延迟之后，恢复才能清除挂起的（“孤立的”）日志条目。
spring.jta.atomikos.properties.recovery.max-retries = 5 ＃引发异常之前提交事务的重试次数。
spring.jta.atomikos.properties.recovery.retry-interval = 10000ms ＃重试尝试之间的延迟。
spring.jta.atomikos.properties.serial-jta-transactions = true ＃是否应尽可能
合并子事务。spring.jta.atomikos.properties.service = ＃应该启动的事务管理器实现。
spring.jta.atomikos.properties.threaded-two-phase-commit = false ＃是否对参与的资源使用不同（并发）线程进行两阶段提交。
spring.jta.atomikos.properties.transaction-manager-unique-name = ＃事务管理器的唯一名称。

＃BITRONIX 
spring.jta.bitronix.connectionfactory.acquire-increment = 1 = ＃增加池时要创建的连接数。
spring.jta.bitronix.connectionfactory.acquisition-interval = 1 ＃等待时间（以秒为单位），该时间是在获取无效连接后尝试再次获取连接之前的等待时间。
spring.jta.bitronix.connectionfactory.acquisition-timeout = 30 ＃用于从池中获取连接的超时（以秒为单位）。
spring.jta.bitronix.connectionfactory.allow-local-transactions = true ＃事务管理器是否应允许混合XA和非XA事务。
spring.jta.bitronix.connectionfactory.apply-transaction-timeout = false＃申请XAResource时是否应设置事务超时。
spring.jta.bitronix.connectionfactory.automatic-enlisting-enabled = true ＃是否应自动征募和除名资源。
spring.jta.bitronix.connectionfactory.cache-producers-consumers = true ＃是否应该缓存生产者和使用者。
spring.jta.bitronix.connectionfactory.class-name = ＃XA资源的基础实现类名称。
spring.jta.bitronix.connectionfactory.defer-connection-release = true ＃提供者是否可以在同一连接上运行许多事务并支持事务交织。
spring.jta.bitronix.connectionfactory.disabled= ＃此资源是否已禁用，这意味着暂时禁止从其资源池获取连接。
spring.jta.bitronix.connectionfactory.driver-properties = ＃应该在基础实现上设置的属性。
spring.jta.bitronix.connectionfactory.failed = ＃将此资源生产者标记为失败。
spring.jta.bitronix.connectionfactory.ignore-recovery-failures = false ＃是否应忽略恢复失败。
spring.jta.bitronix.connectionfactory.max-idle-time = 60 ＃从池中清除连接之后的时间（以秒为单位）。
spring.jta.bitronix.connectionfactory.max-pool-size = 10＃池的最大大小。0表示没有限制。
spring.jta.bitronix.connectionfactory.min-pool-size = 0 ＃池的最小大小。
spring.jta.bitronix.connectionfactory.password = ＃用于连接到JMS提供程序的密码。
spring.jta.bitronix.connectionfactory.share-transaction-connections = false ＃是否可以在事务上下文中共享ACCESSIBLE状态的连接。
spring.jta.bitronix.connectionfactory.test-connections = true ＃从池中获取连接时是否应该测试连接。
spring.jta.bitronix.connectionfactory.two-pc-ordering-position = 1＃此资源在两阶段提交期间应占据的位置（始终首先是Integer.MIN_VALUE，始终最后是Integer.MAX_VALUE）。
spring.jta.bitronix.connectionfactory.unique-name = jmsConnectionFactory ＃用于在恢复期间标识资源的唯一名称。
spring.jta.bitronix.connectionfactory.use-tm-join = true ＃启动XAResources时是否应使用TMJOIN。
spring.jta.bitronix.connectionfactory.user = ＃用于连接到JMS提供程序的用户。
spring.jta.bitronix.datasource.acquire-increment = 1 = ＃增加池时要创建的连接数。
spring.jta.bitronix.datasource.acquisition-interval = 1＃获取无效连接后等待再次尝试获取连接之前等待的时间（以秒为单位）。
spring.jta.bitronix.datasource.acquisition-timeout = 30 ＃超时（以秒为单位），用于从池中获取连接。
spring.jta.bitronix.datasource.allow-local-transactions = true ＃事务管理器是否应允许混合XA和非XA事务。
spring.jta.bitronix.datasource.apply-transaction-timeout = false ＃征用XAResource时是否应在XAResource上设置事务超时。
spring.jta.bitronix.datasource.automatic-enlisting-enabled = true ＃是否应自动征募和除名资源。
spring.jta.bitronix.datasource.class-name = ＃XA资源的基础实现类名称。
spring.jta.bitronix.datasource.cursor-holdability = ＃连接的默认光标可保留性。
spring.jta.bitronix.datasource.defer-connection-release = true ＃数据库是否可以在同一连接上运行许多事务并支持事务交织。
spring.jta.bitronix.datasource.disabled = ＃此资源是否已禁用，这意味着暂时禁止从其资源池中获取连接。
spring.jta.bitronix.datasource.driver-properties = ＃应该在基础实现上设置的属性。
spring.jta.bitronix.datasource.enable-jdbc4-connection-test = ＃从池中获取连接时是否调用Connection.isValid（）。
spring.jta.bitronix.datasource.failed = ＃将此资源生产者标记为失败。
spring.jta.bitronix.datasource.ignore-recovery-failures = false ＃是否应忽略恢复失败。
spring.jta.bitronix.datasource.isolation-level = ＃连接的默认隔离级别。
spring.jta.bitronix.datasource.local-auto-commit = ＃本地事务的默认自动提交模式。
spring.jta.bitronix.datasource.login-timeout =＃建立数据库连接的超时时间（以秒为单位）。
spring.jta.bitronix.datasource.max-idle-time = 60 ＃从池中清除连接之后的时间（以秒为单位）。
spring.jta.bitronix.datasource.max-pool-size = 10 ＃池的最大大小。0表示没有限制。
spring.jta.bitronix.datasource.min-pool-size = 0 ＃池的最小大小。
spring.jta.bitronix.datasource.prepared-statement-cache-size = 0 ＃准备好的语句缓存的目标大小。0禁用缓存。
spring.jta.bitronix.datasource.share-transaction-connections = false＃是否可以在事务上下文中共享处于ACCESSIBLE状态的连接。
spring.jta.bitronix.datasource.test-query = ＃返回连接前用于验证连接的SQL查询或语句。
spring.jta.bitronix.datasource.two-pc-ordering-position = 1 ＃此资源在两阶段提交期间应占据的位置（始终第一个是Integer.MIN_VALUE，始终最后是Integer.MAX_VALUE）。
spring.jta.bitronix.datasource.unique-name =数据源＃恢复期间用于标识资源的唯一名称。
spring.jta.bitronix.datasource.use-tm-join = true ＃启动XAResources时是否应使用TMJOIN。
spring.jta.bitronix.properties.allow-multiple-lrc = false ＃是否允许多个LRC资源加入同一事务。
spring.jta.bitronix.properties.asynchronous2-pc = false ＃是否启用异步执行两阶段提交。
spring.jta.bitronix.properties.background-recovery-interval-seconds = 60 ＃在后台运行恢复过程的时间间隔（以秒为单位）。
spring.jta.bitronix.properties.current-node-only-recovery = true ＃是否只恢复当前节点。
spring.jta.bitronix.properties.debug-zero-resource-transaction = false＃是否记录在没有单个登记资源的情况下执行的事务的创建和提交调用堆栈。
spring.jta.bitronix.properties.default-transaction-timeout = 60 ＃默认事务超时，以秒为单位。
spring.jta.bitronix.properties.disable-jmx = false ＃是否启用JMX支持。
spring.jta.bitronix.properties.exception-analyzer = ＃设置要使用的异常分析器实现的标准名称。
spring.jta.bitronix.properties.filter-log-status = false ＃是否启用日志过滤，以便仅写入强制性日志。
spring.jta.bitronix.properties.force-batching-enabled = true＃磁盘力是否批量处理。
spring.jta.bitronix.properties.forced-write-enabled = true ＃是否将日志强制写入磁盘。
spring.jta.bitronix.properties.graceful-shutdown-interval = 60 ＃TM等待关闭事务之前等待事务完成的最大秒数。
spring.jta.bitronix.properties.jndi-transaction-synchronization-registry-name = ＃TransactionSynchronizationRegistry的JNDI名称。
spring.jta.bitronix.properties.jndi-user-transaction-name = ＃UserTransaction的JNDI名称。
spring.jta.bitronix.properties.journal = disk ＃日志名称。可以是“ disk”，“ null”或类名。
spring.jta.bitronix.properties.log-part1-filename = btm1.tlog ＃日志的第一个片段的名称。
spring.jta.bitronix.properties.log-part2-filename = btm2.tlog ＃日志的第二个片段的名称。
spring.jta.bitronix.properties.max-log-size-in-mb = 2 ＃日志片段的最大大小（以兆字节为单位）。
spring.jta.bitronix.properties.resource-configuration-filename = ＃ResourceLoader配置文件名。
spring.jta.bitronix.properties.server-id = ＃必须唯一标识此TM实例的ASCII ID。默认为机器的IP地址。
spring.jta.bitronix.properties.skip-corrupted-logs = false＃跳过损坏的事务日志条目。
spring.jta.bitronix.properties.warn-about-zero-resource-transaction = true ＃是否为没有单个登记资源而执行的事务记录警告。

＃EMBEDDED MONGODB（EmbeddedMongoProperties）
 spring.mongodb.embedded.features = sync_delay ＃逗号分隔的功能列表。
spring.mongodb.embedded.storage.database-dir = ＃用于数据存储的目录。
spring.mongodb.embedded.storage.oplog-size = ＃操作
日志的最大大小。spring.mongodb.embedded.storage.repl-set-name = ＃副本集的名称。
spring.mongodb.embedded.version = 3.5.5 ＃要使用的Mongo版本。

＃REDIS（RedisProperties）
 spring.redis.cluster.max -redirects = ＃跨集群执行命令时要遵循的最大重定向数。
spring.redis.cluster.nodes = ＃逗号分隔的“ host：port”对列表，用于引导。
spring.redis.database = 0 ＃连接工厂使用的数据库索引。
spring.redis.url = ＃连接URL。覆盖主机，端口和密码。用户被忽略。示例：redis：//用户：password@example.com ：6379 
spring.redis.host = localhost ＃Redis服务器主机。
spring.redis.jedis.pool.max-active = 8＃在给定时间池可以分配的最大连接数。使用负值表示没有限制。
spring.redis.jedis.pool.max-idle = 8 ＃池中“空闲”连接的最大数量。使用负值表示无限数量的空闲连接。
spring.redis.jedis.pool.max -wait = -1ms ＃当池耗尽时，在抛出异常之前连接分配应该阻塞的最长时间。使用负值无限期阻止。
spring.redis.jedis.pool.min-idle = 0 ＃目标是要在池中维护的最小空闲连接数。此设置只有在为正时才有效。
spring.redis.lettuce.pool.max-active = 8＃在给定时间池可以分配的最大连接数。使用负值表示没有限制。
spring.redis.lettuce.pool.max-idle = 8 ＃池中“空闲”连接的最大数量。使用负值表示无限数量的空闲连接。
spring.redis.lettuce.pool.max -wait = -1ms ＃当池耗尽时，在抛出异常之前连接分配应该阻塞的最长时间。使用负值无限期阻止。
spring.redis.lettuce.pool.min-idle = 0 ＃目标是要在池中维护的最小空闲连接数。此设置只有在为正时才有效。
spring.redis.lettuce.shutdown-timeout = 100ms＃关闭超时。
spring.redis.password = ＃Redis服务器的登录密码。
spring.redis.port = 6379 ＃Redis服务器端口。
spring.redis.sentinel.master = ＃Redis服务器的名称。
spring.redis.sentinel.nodes = ＃逗号分隔的“主机：端口”对列表。
spring.redis.ssl = false ＃是否启用SSL支持。
spring.redis.timeout = ＃连接超时。

＃TRANSACTION （TransactionProperties）
 spring.transaction.default-timeout = ＃默认交易超时。如果未指定持续时间后缀，则将使用秒。
spring.transaction.rollback-on-commit-failure = ＃是否在提交失败时回滚。



＃---------------------------------------- 
＃集成属性
＃----- -----------------------------------

＃ACTIVEMQ（ActiveMQProperties）
 spring.activemq.broker-url = ＃ActiveMQ代理的URL。默认情况下自动生成。
spring.activemq.close-timeout = 15s ＃在考虑关闭完成之前需要等待的时间。
spring.activemq.in-memory = true ＃默认代理URL是否应在内存中。忽略是否已指定显式代理。
spring.activemq.non-blocking-redelivery = false ＃在从回滚的事务重新传递消息之前是否停止消息传递。这意味着启用此功能后不会保留消息顺序。
spring.activemq.password = ＃经纪人的登录密码。
spring.activemq.send-timeout = 0ms ＃等待消息发送响应的时间。将其设置为0永远等待。
spring.activemq.user = ＃经纪人的登录用户。
spring.activemq.packages.trust-all = ＃是否信任所有软件包。
spring.activemq.packages.trusted = ＃要信任的特定软件包的列表，以逗号分隔（当不信任所有软件包时）。
spring.activemq.pool.block-if-full = true ＃是否在请求连接且池已满时阻塞。将其设置为false可以引发“ JMSException”。
spring.activemq.pool.block-if-full-timeout = -1ms＃如果池仍然满，则在引发异常之前的阻塞时间。
spring.activemq.pool.enabled = false ＃是否应创建JmsPoolConnectionFactory而不是常规ConnectionFactory。
spring.activemq.pool.idle-timeout = 30s ＃连接空闲超时。
spring.activemq.pool.max-connections = 1 ＃池连接的最大数量。
spring.activemq.pool.max-sessions-per-connection = 500 ＃池中每个连接的最大池会话数。
spring.activemq.pool.time-between-expiration-check = -1ms ＃空闲连接逐出线程运行之间的睡眠时间。如果为负，则不运行空闲的连接收回线程。
spring.activemq.pool.use-anonymous-producers = true ＃是否仅使用一个匿名“ MessageProducer”实例。将其设置为false可以在每次需要一个“ MessageProducer”时创建一个。

＃ARTEMIS （ArtemisProperties）
 spring.artemis.embedded.cluster-password = ＃集群密码。默认情况下在启动时随机生成。
spring.artemis.embedded.data-directory = ＃日志文件目录。如果关闭了持久性，则没有必要。
spring.artemis.embedded.enabled = true ＃如果Artemis服务器API可用，是否启用嵌入式模式。
spring.artemis.embedded.persistent = false ＃是否启用持久存储。
spring.artemis.embedded.queues = ＃在启动时创建的以逗号分隔的队列列表。
spring.artemis.embedded.server-id =＃服务器ID。默认情况下，使用自动递增计数器。
spring.artemis.embedded.topics = ＃在启动时创建的主题列表，以逗号分隔。
spring.artemis.host = localhost ＃Artemis经纪人主机。
spring.artemis.mode = ＃Artemis部署模式，默认情况下自动检测。
spring.artemis.password = ＃经纪人的登录密码。
spring.artemis.pool.block-if-full = true ＃是否在请求连接且池已满时阻塞。将其设置为false可以引发“ JMSException”。
spring.artemis.pool.block-if-full-timeout = -1ms ＃如果池仍然满，则在引发异常之前的阻塞时间。
spring.artemis.pool.enabled = false ＃是否应创建JmsPoolConnectionFactory而不是常规ConnectionFactory。
spring.artemis.pool.idle-timeout = 30s ＃连接空闲超时。
spring.artemis.pool.max-connections = 1 ＃池连接的最大数量。
spring.artemis.pool.max-sessions-per-connection = 500 ＃池中每个连接的最大池会话数。
spring.artemis.pool.time-between-expiration-check = -1ms ＃空闲连接逐出线程两次运行之间的睡眠时间。如果为负，则不运行空闲的连接收回线程。
spring.artemis.pool.use-anonymous-producers = true＃是否仅使用一个匿名“ MessageProducer”实例。将其设置为false可以在每次需要一个“ MessageProducer”时创建一个。
spring.artemis.port = 61616 ＃Artemis经纪人港口。
spring.artemis.user = ＃经纪人的登录用户。

＃SPRING BATCH（BatchProperties）
 spring.batch.initialize-schema =嵌入式＃数据库模式初始化模式。
spring.batch.job.enabled = true ＃在启动时在上下文中执行所有Spring Batch作业。
spring.batch.job.names = ＃要在启动时执行的作业名称的列表，以逗号分隔（例如，“ job1，job2”）。默认情况下，将执行在上下文中找到的所有作业。
spring.batch.schema = classpath：org / springframework / batch / core / schema- @ @ platform @ @ .sql ＃用于初始化数据库模式的SQL文件的路径。
spring.batch.table-prefix =＃所有批处理元数据表的表前缀。

＃SPRING INTEGRATION（IntegrationProperties）
 spring.integration.jdbc.initialize-schema =嵌入式＃数据库模式初始化模式。
spring.integration.jdbc.schema = classpath：org / springframework / integration / jdbc / schema- @ @ platform @ @ .sql ＃用于初始化数据库模式的SQL文件的路径。

＃JMS （JmsProperties）
 spring.jms.cache.consumers = false ＃是否缓存消息使用者。
spring.jms.cache.enabled = true ＃是否缓存会话。
spring.jms.cache.producers = true ＃是否缓存消息生产者。
spring.jms.cache.session-cache-size = 1 ＃会话缓存的大小（每个JMS会话类型）。
spring.jms.jndi-name = ＃连接工厂JNDI名称。设置后，优先于其他连接工厂自动配置。
spring.jms.listener.acknowledge-mode = ＃容器的确认模式。默认情况下，将使用自动确认来处理侦听器。
spring.jms.listener.auto-startup = true ＃启动时自动启动容器。
spring.jms.listener.concurrency = ＃最小并发使用者数。
spring.jms.listener.max-concurrency = ＃最大并发使用者数。
spring.jms.pub-sub-domain = false ＃默认目标类型是否为topic。
spring.jms.template.default-destination = ＃在没有目标参数的发送和接收操作中使用的默认目标。
spring.jms.template.delivery-delay = ＃用于发送呼叫的传递延迟。
spring.jms.template.delivery-mode =＃投放模式。设置时启用QoS（服务质量）。
spring.jms.template.priority = ＃发送消息时的优先级。设置时启用QoS（服务质量）。
spring.jms.template.qos-enabled = ＃发送消息时是否启用显式QoS（服务质量）。
spring.jms.template.receive-timeout = ＃用于接收呼叫的超时。
spring.jms.template.time-to-live = ＃发送消息时的生存时间。设置时启用QoS（服务质量）。

＃APACHE KAFKA（KafkaProperties）
 spring.kafka.admin.client-id = ＃发出请求时传递给服务器的ID。用于服务器端日志记录。
spring.kafka.admin.fail-fast = false ＃如果代理在启动时不可用，是否快速失败。
spring.kafka.admin.properties。* = ＃用于配置客户端的其他特定于管理员的属性。
spring.kafka.admin.ssl.key-password = ＃密钥存储文件中私钥的密码。
spring.kafka.admin.ssl.key-store-location = ＃密钥存储文件的位置。
spring.kafka.admin.ssl.key-store-password =＃存储密钥存储文件的密码。
spring.kafka.admin.ssl.key-store-type = ＃密钥库的类型。
spring.kafka.admin.ssl.protocol = ＃要使用的SSL协议。
spring.kafka.admin.ssl.trust-store-location = ＃信任库文件的位置。
spring.kafka.admin.ssl.trust-store-password = ＃信任存储文件的存储密码。
spring.kafka.admin.ssl.trust-store-type = ＃信任库的类型。
spring.kafka.bootstrap-servers = ＃用逗号分隔的host：port对列表，用于建立与Kafka集群的初始连接。适用于所有组件，除非被覆盖。
spring.kafka.client-id = ＃发出请求时传递给服务器的ID。用于服务器端日志记录。
spring.kafka.consumer.auto-commit-interval = ＃如果将“ enable.auto.commit”设置为true，则将消费者偏移量自动提交给Kafka的频率。
spring.kafka.consumer.auto-offset-reset = ＃当Kafka中没有初始偏移量或服务器上不再存在当前偏移量时该怎么办。
spring.kafka.consumer.bootstrap-servers = ＃用逗号分隔的host：port对列表，用于建立与Kafka集群的初始连接。为消费者覆盖全球财产。
spring.kafka.consumer.client-id =＃发出请求时传递给服务器的ID。用于服务器端日志记录。
spring.kafka.consumer.enable-auto-commit = ＃消费者的偏移量是否在后台定期提交。
spring.kafka.consumer.fetch-max-wait = ＃如果没有足够的数据立即满足“ fetch-min-size”给出的要求，则服务器在响应提取请求之前阻塞的最长时间。
spring.kafka.consumer.fetch-min-size = ＃服务器为获取请求应返回的最小数据量。
spring.kafka.consumer.group-id = ＃唯一字符串，用于标识此使用者所属的使用者组。
spring.kafka.consumer.heartbeat-interval= ＃预期到消费者协调员的心跳之间的时间。
spring.kafka.consumer.key-deserializer = ＃密钥
的反序列化器类。spring.kafka.consumer.max-poll-records = ＃一次调用poll（）时返回的最大记录数。
spring.kafka.consumer.properties。* = ＃用于配置客户端的其他特定于用户的属性。
spring.kafka.consumer.ssl.key-password = ＃密钥存储文件中私钥的密码。
spring.kafka.consumer.ssl.key-store-location = ＃密钥存储文件的位置。
spring.kafka.consumer.ssl.key-store-password =＃存储密钥存储文件的密码。
spring.kafka.consumer.ssl.key-store-type = ＃密钥库的类型。
spring.kafka.consumer.ssl.protocol = ＃要使用的SSL协议。
spring.kafka.consumer.ssl.trust-store-location = ＃信任库文件的位置。
spring.kafka.consumer.ssl.trust-store-password = ＃信任存储文件的存储密码。
spring.kafka.consumer.ssl.trust-store-type = ＃信任库的类型。
spring.kafka.consumer.value-deserializer = ＃值
的反序列化器类。spring.kafka.jaas.control-flag =必需＃登录配置的控制标志。
spring.kafka.jaas.enabled = false ＃是否启用JAAS配置。
spring.kafka.jaas.login-module = com.sun.security.auth.module.Krb5LoginModule ＃登录模块 
spring.kafka.jaas.options = ＃其他JAAS选项。
spring.kafka.listener.ack-count = ＃当ackMode为“ COUNT”或“ COUNT_TIME”时，两次偏移提交之间的记录数。
spring.kafka.listener.ack-mode = ＃侦听器AckMode。请参阅spring-kafka文档。
spring.kafka.listener.ack-time = ＃当ackMode为“ TIME”或“ COUNT_TIME”时，两次偏移提交之间的时间。
spring.kafka.listener.client-id =＃侦听器的使用者的client.id属性的前缀。
spring.kafka.listener.concurrency = ＃在侦听器容器中运行的线程数。
spring.kafka.listener.idle-event-interval = ＃发布空闲消费者事件之间的时间（未接收到数据）。
spring.kafka.listener.log-container-config = ＃是否在初始化期间记录容器配置（INFO级别）。
spring.kafka.listener.monitor-interval = ＃
两次检查无响应的使用者之间的时间。如果未指定持续时间后缀，则将使用秒。spring.kafka.listener.no-poll-threshold =＃乘数应用于“ pollTimeout”，以确定使用者是否无响应。
spring.kafka.listener.poll-timeout = ＃轮询使用者时使用的超时。
spring.kafka.listener.type = single ＃侦听器类型。
spring.kafka.producer.acks = ＃生产者要求领导者在确认请求完成之前已收到的确认数。
spring.kafka.producer.batch-size = ＃默认批次大小。
spring.kafka.producer.bootstrap-servers = ＃用逗号分隔的host：port对列表，用于建立与Kafka集群的初始连接。为生产者覆盖全球财产。
spring.kafka.producer.buffer-memory = ＃生产者可以用来缓冲等待发送到服务器的记录的总内存大小。
spring.kafka.producer.client-id = ＃发出请求时传递给服务器的ID。用于服务器端日志记录。
spring.kafka.producer.compression-type = ＃生产者生成的所有数据的压缩类型。
spring.kafka.producer.key-serializer = ＃密钥的序列化程序类。
spring.kafka.producer.properties。* = ＃用于配置客户端的其他特定于生产者的属性。
spring.kafka.producer.retries = ＃大于零时，启用重试失败的发送。
spring.kafka.producer.ssl.key-password = ＃密钥存储文件中私钥的密码。
spring.kafka.producer.ssl.key-store-location = ＃密钥存储文件的位置。
spring.kafka.producer.ssl.key-store-password = ＃密钥存储文件的存储密码。
spring.kafka.producer.ssl.key-store-type = ＃密钥库的类型。
spring.kafka.producer.ssl.protocol = ＃要使用的SSL协议。
spring.kafka.producer.ssl.trust-store-location = ＃信任库文件的位置。
spring.kafka.producer.ssl.trust-store-password = ＃信任存储文件的存储密码。
spring.kafka.producer.ssl.trust-store-type = ＃信任库的类型。
spring.kafka.producer.transaction-id-prefix = ＃不为空时，为生产者启用事务支持。
spring.kafka.producer.value-serializer = ＃值的序列化程序类。
spring.kafka.properties。* = ＃生产者和消费者
共有的其他属性，用于配置客户端。spring.kafka.ssl.key-password = ＃密钥存储文件中私钥的密码。
spring.kafka.ssl.key-store-location = ＃密钥存储文件的位置。
spring.kafka.ssl.key-store-password =＃存储密钥存储文件的密码。
spring.kafka.ssl.key-store-type = ＃密钥库的类型。
spring.kafka.ssl.protocol = ＃要使用的SSL协议。
spring.kafka.ssl.trust-store-location = ＃信任库文件的位置。
spring.kafka.ssl.trust-store-password = ＃信任存储文件的存储密码。
spring.kafka.ssl.trust-store-type = ＃信任库的类型。
spring.kafka.streams.application-id = ＃Kafka流的application.id属性; 默认的spring.application.name 
spring.kafka.streams.auto-startup = true ＃是否自动启动流工厂bean。
spring.kafka.streams.bootstrap-servers = ＃用逗号分隔的host：port对列表，用于建立与Kafka集群的初始连接。覆盖流的全局属性。
spring.kafka.streams.cache-max-size-buffering = ＃用于在所有线程之间进行缓冲的最大内存大小。
spring.kafka.streams.client-id = ＃发出请求时传递给服务器的ID。用于服务器端日志记录。
spring.kafka.streams.properties。* = ＃用于配置流的其他Kafka属性。
spring.kafka.streams.replication-factor =＃流处理应用程序创建的更改日志主题和重新分区主题的复制因子。
spring.kafka.streams.ssl.key-password = ＃密钥存储文件中私钥的密码。
spring.kafka.streams.ssl.key-store-location = ＃密钥存储文件的位置。
spring.kafka.streams.ssl.key-store-password = ＃密钥存储文件的存储密码。
spring.kafka.streams.ssl.key-store-type = ＃密钥库的类型。
spring.kafka.streams.ssl.protocol = ＃要使用的SSL协议。
spring.kafka.streams.ssl.trust-store-location = ＃信任库文件的位置。
spring.kafka.streams.ssl.trust-store-password = ＃信任存储文件的存储密码。
spring.kafka.streams.ssl.trust-store-type = ＃信任库的类型。
spring.kafka.streams.state-dir = ＃状态存储的目录位置。
spring.kafka.template.default-topic = ＃要将消息发送到的默认主题。

＃RABBIT（RabbitProperties）
 spring.rabbitmq.addresses = ＃客户端应连接到的地址的逗号分隔列表。
spring.rabbitmq.cache.channel.checkout-timeout = ＃如果达到缓存大小，等待获取通道的持续时间。
spring.rabbitmq.cache.channel.size = ＃要保留在缓存中的通道数。
spring.rabbitmq.cache.connection.mode = channel ＃连接工厂缓存模式。
spring.rabbitmq.cache.connection.size = ＃缓存连接数。
spring.rabbitmq.connection-timeout = ＃连接超时。将其设置为零以永远等待。
spring.rabbitmq.dynamic = true ＃是否创建一个AmqpAdmin bean。
spring.rabbitmq.host = localhost ＃RabbitMQ主机。
spring.rabbitmq.listener.direct.acknowledge-mode = ＃容器的确认模式。
spring.rabbitmq.listener.direct.auto-startup = true ＃是否在启动时自动启动容器。
spring.rabbitmq.listener.direct.consumers-per-queue = ＃每个队列的使用者数。
spring.rabbitmq.listener.direct.default-requeue-rejected = ＃默认情况下是否重新排队拒绝的交货。
spring.rabbitmq.listener.direct.idle-event-interval =＃空闲容器事件应多久发布一次。
spring.rabbitmq.listener.direct.missing-queues-fatal = false ＃如果容器声明的队列在代理上不可用，是否失败。
spring.rabbitmq.listener.direct.prefetch = ＃每个使用方未解决的最大未确认消息数。
spring.rabbitmq.listener.direct.retry.enabled = false ＃是否启用发布重试。
spring.rabbitmq.listener.direct.retry.initial-interval = 1000ms ＃第一次和第二次尝试传递消息之间的持续时间。
spring.rabbitmq.listener.direct.retry.max-attempts = 3＃尝试发送邮件的最大次数。
spring.rabbitmq.listener.direct.retry.max -interval = 10000ms ＃
两次尝试之间的最大持续时间。spring.rabbitmq.listener.direct.retry.multiplier = 1 ＃应用于上一个重试间隔的乘数。
spring.rabbitmq.listener.direct.retry.stateless = true ＃重试是无状态还是有状态。
spring.rabbitmq.listener.simple.acknowledge-mode = ＃容器的确认模式。
spring.rabbitmq.listener.simple.auto-startup = true ＃是否在启动时自动启动容器。
spring.rabbitmq.listener.simple.concurrency =＃侦听器调用者线程的最小数量。
spring.rabbitmq.listener.simple.default-requeue-rejected = ＃默认情况下是否重新排队拒绝的交货。
spring.rabbitmq.listener.simple.idle-event-interval = ＃空闲容器事件应多久发布一次。
spring.rabbitmq.listener.simple.max-concurrency = ＃侦听器调用者线程的最大数量。
spring.rabbitmq.listener.simple.missing-queues-fatal = true ＃如果容器声明的队列在代理上不可用，是否失败；和/或如果在运行时删除一个或多个队列，是否停止容器？
spring.rabbitmq.listener.simple.prefetch =＃每个使用者可以处理的未确认消息的最大数量。
spring.rabbitmq.listener.simple.retry.enabled = false ＃是否启用发布重试。
spring.rabbitmq.listener.simple.retry.initial-interval = 1000ms ＃第一次和第二次尝试传递消息之间的持续时间。
spring.rabbitmq.listener.simple.retry.max-attempts = 3 ＃尝试传递消息的最大次数。
spring.rabbitmq.listener.simple.retry.max -interval = 10000ms ＃
两次尝试之间的最大持续时间。spring.rabbitmq.listener.simple.retry.multiplier = 1 ＃应用于上一个重试间隔的乘数。
spring.rabbitmq.listener.simple.retry.stateless = true ＃重试是无状态还是有状态。
spring.rabbitmq.listener.simple.transaction-size = ＃确认模式为AUTO时，两次确认之间要处理的消息数。如果大于预取，则预取将增加到该值。
spring.rabbitmq.listener.type =简单＃侦听器容器类型。
spring.rabbitmq.password = guest ＃登录以针对代理进行身份验证。
spring.rabbitmq.port = 5672 ＃RabbitMQ端口。
spring.rabbitmq.publisher-confirms = false ＃是否启用发布者确认。
spring.rabbitmq.publisher-returns = false＃是否启用发布者退货。
spring.rabbitmq.requested-heartbeat = ＃请求的心跳超时；零为零。如果未指定持续时间后缀，则将使用秒。
spring.rabbitmq.ssl.algorithm = ＃要使用的SSL算法。默认情况下，由Rabbit客户端库配置。
spring.rabbitmq.ssl.enabled = false ＃是否启用SSL支持。
spring.rabbitmq.ssl.key-store = ＃存放SSL证书的密钥存储的路径。
spring.rabbitmq.ssl.key-store-password = ＃用于访问密钥库的密码。
spring.rabbitmq.ssl.key-store-type = PKCS12 ＃密钥库类型。
spring.rabbitmq.ssl.trust-store = ＃持有SSL证书的信任库。
spring.rabbitmq.ssl.trust-store-password = ＃用于访问信任库的密码。
spring.rabbitmq.ssl.trust-store-type = JKS ＃信任库类型。
spring.rabbitmq.ssl.validate-server-certificate = true ＃是否启用服务器端证书验证。
spring.rabbitmq.ssl.verify-hostname = true ＃是否启用主机名验证。
spring.rabbitmq.template.default-receive-queue = ＃显式指定没有接收消息的默认队列的名称。
spring.rabbitmq.template.exchange =＃用于发送操作的默认交换的名称。
spring.rabbitmq.template.mandatory = ＃是否启用强制性消息。
spring.rabbitmq.template.receive-timeout = ＃`receive（）`操作的超时。
spring.rabbitmq.template.reply-timeout = ＃“ sendAndReceive（）”操作超时。
spring.rabbitmq.template.retry.enabled = false ＃是否启用发布重试。
spring.rabbitmq.template.retry.initial-interval = 1000ms ＃第一次和第二次尝试传递消息之间的持续时间。
spring.rabbitmq.template.retry.max-attempts = 3 ＃尝试传递消息的最大次数。
spring.rabbitmq.template.retry.max -interval = 10000ms ＃
两次尝试之间的最大持续时间。spring.rabbitmq.template.retry.multiplier = 1 ＃应用于上一个重试间隔的乘数。
spring.rabbitmq.template.routing-key = ＃用于发送操作的默认路由键的值。
spring.rabbitmq.username = guest ＃登录用户以对代理进行身份验证。
spring.rabbitmq.virtual-host = ＃连接到代理时要使用的虚拟主机。


＃---------------------------------------- 
＃执行器属性
＃----- -----------------------------------

＃管理HTTP服务器（ManagementServerProperties）
 management.server.add-application-context-header = false ＃在每个响应中添加“ X-Application-Context” HTTP标头。
management.server.address = ＃管理端点应绑定到的网络地址。需要自定义的management.server.port。
management.server.port = ＃管理端点HTTP端口（默认情况下使用与应用程序相同的端口）。配置其他端口以使用特定于管理的SSL。
management.server.servlet.context-path = ＃管理端点上下文路径（例如，“ / management”）。需要自定义的management.server.port。
management.server.ssl.ciphers= ＃支持的SSL密码。
management.server.ssl.client-auth = ＃客户端身份验证模式。
management.server.ssl.enabled = true ＃是否启用SSL支持。
management.server.ssl.enabled-protocols = ＃启用的SSL协议。
management.server.ssl.key-alias = ＃标识密钥库中密钥的别名。
management.server.ssl.key-password = ＃用于访问密钥库中密钥的密码。
management.server.ssl.key-store = ＃存放SSL证书（通常是jks文件）的密钥存储的路径。
management.server.ssl.key-store-password =＃用于访问密钥库的密码。
management.server.ssl.key-store-provider = ＃密钥库的提供程序。
management.server.ssl.key-store-type = ＃密钥库的类型。
management.server.ssl.protocol = TLS ＃要使用的SSL协议。
management.server.ssl.trust-store = ＃持有SSL证书的信任库。
management.server.ssl.trust-store-password = ＃用于访问信任库的密码。
management.server.ssl.trust-store-provider = ＃信任库的提供者。
management.server.ssl.trust-store-type = ＃信任库的类型。

＃CLOUDFOUNDRY 
management.cloudfoundry.enabled = true ＃是否启用扩展的Cloud Foundry执行器端点。
management.cloudfoundry.skip-ssl-validation = false ＃是否为Cloud Foundry执行器端点安全性调用跳过SSL验证。

＃ENDPOINTS GENERAL CONFIGURATION 
management.endpoints.enabled-by-default = ＃默认情况下是启用还是禁用所有端点。

＃端点JMX配置（JmxEndpointProperties）
 management.endpoints.jmx.domain = org.springframework.boot ＃端点JMX域名。如果设置，则回退到“ spring.jmx.default-domain”。
management.endpoints.jmx.exposure.include = * ＃应该包含的端点ID，或者所有端点都为'*'。
management.endpoints.jmx.exposure.exclude = ＃应当排除的端点ID，或者所有端点ID均为'*'。
management.endpoints.jmx.static-names = ＃附加到表示端点的MBean的所有ObjectName的附加静态属性。

＃端点Web配置（WebEndpointProperties）
 management.endpoints.web.exposure.include = health，info ＃应该包含的端点ID或全部为“ *”。
management.endpoints.web.exposure.exclude = ＃应当排除的端点ID，或者所有端点ID均为'*'。
management.endpoints.web.base-path = / actuator ＃Web端点的基本路径。如果已配置management.server.port，则相对于server.servlet.context-path或management.server.servlet.context-path。
management.endpoints.web.path-mapping = ＃端点ID与应公开它们的路径之间的映射。

＃ENDPOINTS CORS配置（CorsEndpointProperties）
 management.endpoints.web.cors.allow-credentials = ＃是否支持凭据。如果未设置，则不支持凭据。
management.endpoints.web.cors.allowed-headers = ＃以逗号分隔的请求列表。'*'允许所有标题。
management.endpoints.web.cors.allowed-methods = ＃逗号分隔的方法列表。'*'允许所有方法。未设置时，默认为GET。
management.endpoints.web.cors.allowed-origins = ＃允许使用逗号分隔的来源列表。'*'允许所有来源。如果未设置，则会禁用CORS支持。
management.endpoints.web.cors.exposed-headers = ＃包含在响应中的标头逗号分隔列表。
management.endpoints.web.cors.max-age = 1800s ＃客户端可以将飞行前请求的响应缓存多长时间。如果未指定持续时间后缀，则将使用秒。

＃审核事件ENDPOINT（AuditEventsEndpoint）
 management.endpoint.auditevents.cache。生存时间
= 0ms ＃可以缓存响应的最长时间。management.endpoint.auditevents.enabled = true ＃是否启用审计事件端点。

＃BEANS ENDPOINT（BeansEndpoint）
 management.endpoint.beans.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.beans.enabled = true ＃是否启用bean端点。

＃CACHES ENDPOINT（CachesEndpoint）
 management.endpoint.caches.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.caches.enabled = true ＃是否启用缓存端点。

＃条件报告端点（ConditionsReportEndpoint）
 management.endpoint.conditions.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.conditions.enabled = true ＃是否启用条件端点。

＃配置属性报告端点（ConfigurationPropertiesReportEndpoint，ConfigurationPropertiesReportEndpointProperties）
 management.endpoint.configprops.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.configprops.enabled = true ＃是否启用configprops端点。
management.endpoint.config.propprops.keys-to-sanitize =密码，秘密，密钥，令牌，。*凭据。*，vcap_services，sun.java.command ＃应该清除的密钥。键可以是属性结尾的简单字符串，也可以是正则表达式。

＃环境端点（EnvironmentEndpoint，EnvironmentEndpointProperties）
 management.endpoint.env.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.env.enabled = true ＃是否启用环境端点。
management.endpoint.env。要消毒的密钥=密码，秘密，密钥，令牌，*凭证。*，vcap_services，sun.java.command ＃应该清理的密钥。键可以是属性结尾的简单字符串，也可以是正则表达式。

＃FLYWAY ENDPOINT（FlywayEndpoint）
 management.endpoint.flyway.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.flyway.enabled = true ＃是否启用飞行路线端点。

＃HEALTH ENDPOINT（HealthEndpoint，HealthEndpointProperties）
 management.endpoint.health.cache。生存时间
= 0ms ＃可以缓存响应的最长时间。management.endpoint.health.enabled = true ＃是否启用健康端点。
management.endpoint.health.roles = ＃用于确定是否有权向用户显示详细信息的角色。如果为空，则对所有经过身份验证的用户进行授权。
management.endpoint.health.show-details = never ＃何时显示完整的运行状况详细信息。

＃HEAP DUMP ENDPOINT（HeapDumpWebEndpoint）
 management.endpoint.heapdump.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.heapdump.enabled = true ＃是否启用堆转储端点。

＃HTTP TRACE ENDPOINT（HttpTraceEndpoint）
 management.endpoint.httptrace.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.httptrace.enabled = true ＃是否启用httptrace端点。

＃INFO ENDPOINT（InfoEndpoint）
 info = ＃要添加到info端点的任意属性。
management.endpoint.info.cache。生存时间
= 0ms ＃可以缓存响应的最长时间。management.endpoint.info.enabled = true ＃是否启用信息端点。

＃积分图端点（IntegrationGraphEndpoint）
 management.endpoint.integrationgraph.cache。生存时间
= 0ms ＃可以缓存响应的最长时间。management.endpoint.integrationgraph.enabled = true ＃是否启用积分图端点。

＃JOLOKIA ENDPOINT（JolokiaProperties）
 management.endpoint.jolokia.config。* = ＃Jolokia设置。有关更多详细信息，请参阅Jolokia的文档。
management.endpoint.jolokia.enabled = true ＃是否启用jolokia端点。

＃LIQUIBASE ENDPOINT（LiquibaseEndpoint）
 management.endpoint.liquibase.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.liquibase.enabled = true ＃是否启用liquibase端点。

＃日志文件端点（LogFileWebEndpoint，LogFileWebEndpointProperties）
 management.endpoint.logfile.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.logfile.enabled = true ＃是否启用日志文件端点。
management.endpoint.logfile.external-file = ＃要访问的外部日志文件。如果日志文件是通过输出重定向而不是日志系统本身编写的，则可以使用。

＃LOGGERS ENDPOINT（LoggersEndpoint）
 management.endpoint.loggers.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.loggers.enabled = true ＃是否启用记录器端点。

＃REQUEST MAPPING ENDPOINT（MappingsEndpoint）
 management.endpoint.mappings.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.mappings.enabled = true ＃是否启用映射端点。

＃METRICS ENDPOINT（MetricsEndpoint）
 management.endpoint.metrics.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.metrics.enabled = true ＃是否启用指标端点。

＃PROMETHEUS ENDPOINT（PrometheusScrapeEndpoint）
 management.endpoint.prometheus.cache。生存时间
= 0ms ＃可以缓存响应的最长时间。management.endpoint.prometheus.enabled = true ＃是否启用Prometheus端点。

＃计划的任务端点（ScheduledTasksEndpoint）
 management.endpoint.scheduledtasks.cache。生存时间
= 0ms ＃可以缓存响应的最长时间。management.endpoint.scheduledtasks.enabled = true ＃是否启用ScheduledTasks端点。

＃SESSIONS ENDPOINT（SessionsEndpoint）
 management.endpoint.sessions.enabled = true ＃是否启用会话端点。

＃SHUTDOWN ENDPOINT（ShutdownEndpoint）
 management.endpoint.shutdown.enabled = false ＃是否启用关机端点。

＃线程转储端点（ThreadDumpEndpoint）
 management.endpoint.threaddump.cache.time-to-live = 0ms ＃可以缓存响应的最长时间。
management.endpoint.threaddump.enabled = true ＃是否启用线程转储端点。

＃HEALTH INDICATORS 
management.health.db.enabled = true ＃是否启用数据库健康检查。
management.health.cassandra.enabled = true ＃是否启用Cassandra健康检查。
management.health.couchbase.enabled = true ＃是否启用Couchbase健康检查。
management.health.defaults.enabled = true ＃是否启用默认运行状况指示器。
management.health.diskspace.enabled = true ＃是否启用磁盘空间健康检查。
management.health.diskspace.path = ＃用于计算可用磁盘空间的路径。
management.health.diskspace.threshold = 10MB＃最小可用磁盘空间。
management.health.elasticsearch.enabled = true ＃是否启用Elasticsearch健康检查。
management.health.elasticsearch.indices = ＃逗号分隔的索引名称。
management.health.elasticsearch.response-timeout = 100ms ＃等待集群响应的时间。
management.health.influxdb.enabled = true ＃是否启用InfluxDB健康检查。
management.health.jms.enabled = true ＃是否启用JMS健康检查。
management.health.ldap.enabled = true ＃是否启用LDAP健康检查。
management.health.mail.enabled = true＃是否启用邮件健康检查。
management.health.mongo.enabled = true ＃是否启用MongoDB健康检查。
management.health.neo4j.enabled = true ＃是否启用Neo4j健康检查。
management.health.rabbit.enabled = true ＃是否启用RabbitMQ健康检查。
management.health.redis.enabled = true ＃是否启用Redis运行状况检查。
management.health.solr.enabled = true ＃是否启用Solr健康检查。
management.health.status.http-mapping = ＃健康状态到HTTP状态代码的映射。默认情况下，已注册的健康状态会映射为合理的默认值（例如，UP映射为200）。
management.health.status.order = DOWN，OUT_OF_SERVICE，UP，未知＃以严重性顺序用逗号分隔的健康状态列表。

＃HTTP跟踪（HttpTraceProperties）
 management.trace.http.enabled = true ＃是否启用HTTP请求-响应跟踪。
management.trace.http.include =请求标头，响应标头，cookie，错误＃要包含在跟踪中的项目。

＃INFO CONTRIBUTORS（InfoContributorProperties）
 management.info.build.enabled = true ＃是否启用构建信息。
management.info.defaults.enabled = true ＃是否启用默认信息提供者。
management.info.env.enabled = true ＃是否启用环境信息。
management.info.git.enabled = true ＃是否启用git info。
management.info.git.mode =简单＃用于公开git信息的模式。

＃METRICS 
management.metrics.distribution.maximum-expected-value。* = ＃预期以指定名称开头的计量表ID所
遵循的最大值。management.metrics.distribution.minimum-expected-value。* = ＃预期以指定名称开头的计量器ID必须遵守的最小值。
management.metrics.distribution.percentiles。* = ＃将从指定名称开始的特定计算的不可凝结的百分位数发送到仪表ID的后端。
management.metrics.distribution.percentiles-histogram。* = ＃以指定名称开头的仪表ID是否应发布百分位直方图。
management.metrics.distribution.sla。* =＃以指定名称开头的仪表ID的特定SLA边界。最长的比赛获胜。
management.metrics.enable。* = ＃是否应启用以指定名称开头的仪表ID。最长的比赛获胜，键“ all”也可用于配置所有仪表。
management.metrics.export.appoptics.api-token = ＃AppOptics API令牌。
management.metrics.export.appoptics.batch-size = 500 ＃用于此后端的每个请求的度量数量。如果找到更多测量值，则将发出多个请求。
management.metrics.export.appoptics.connect-timeout = 5s ＃此后端请求的连接超时。
management.metrics.export.appoptics.enabled= true ＃是否已启用将度量导出到此后端。
management.metrics.export.appoptics.host-tag = instance ＃将度量标准传送到AppOptics时将映射到“ @host”的标记。
management.metrics.export.appoptics.num-threads = 2 ＃与度量标准发布调度程序一起使用的线程数。
management.metrics.export.appoptics.read-timeout = 10s ＃读取对此后端的请求的超时。
management.metrics.export.appoptics.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.appoptics.uri = https：//api.appoptics.com/v1/measurements＃要将度量标准发送到的URI。
management.metrics.export.atlas.batch-size = 10000 ＃用于此后端的每个请求的度量数量。如果找到更多测量值，则将发出多个请求。
management.metrics.export.atlas.config-refresh-frequency = 10s ＃从LWC服务刷新配置设置的频率。
management.metrics.export.atlas.config-生存时间
= 150s ＃LWC服务中的订阅生存时间。management.metrics.export.atlas.config-uri = http：// localhost：7101 / lwc / api / v1 / expressions / local-dev ＃Atlas LWC端点检索当前订阅的URI。
management.metrics.export.atlas.connect-timeout = 1秒＃与此后端的请求的连接超时。
management.metrics.export.atlas.enabled = true ＃是否启用将度量导出到此后端。
management.metrics.export.atlas.eval-uri = http：// localhost：7101 / lwc / api / v1 / evaluate ＃用于Atlas LWC端点的URI，以评估订阅数据。
management.metrics.export.atlas.lwc-enabled = false ＃是否启用流向Atlas LWC的流。
management.metrics.export.atlas.meter-live-time-to-live = 15m ＃没有任何活动的仪表的生存时间。在此期间之后，仪表将被视为已过期，并且不会得到报告。
management.metrics.export.atlas.num-threads = 2＃与指标发布调度程序一起使用的线程数。
management.metrics.export.atlas.read-timeout = 10s ＃读取对此后端的请求的超时。
management.metrics.export.atlas.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.atlas.uri = http：// localhost：7101 / api / v1 / publish ＃Atlas服务器的URI。
management.metrics.export.datadog.api-key = ＃Datadog API密钥。
management.metrics.export.datadog.application-key = ＃Datadog应用程序密钥。并非严格要求，但可以通过将仪表描述，类型和基本单位发送到Datadog来改善Datadog的体验。
management.metrics.export.datadog.batch-size = 10000 ＃用于此后端的每个请求的度量数量。如果找到更多测量值，则将发出多个请求。
management.metrics.export.datadog.connect-timeout = 1s ＃此后端的请求连接超时。
management.metrics.export.datadog.descriptions = true ＃是否将描述元数据发布到Datadog。关闭此功能可最大程度地减少发送的元数据量。
management.metrics.export.datadog.enabled = true ＃是否已启用将度量标准导出到此后端。
management.metrics.export.datadog.host-tag =实例＃将指标发送到Datadog时将映射到“主机”的标签。
management.metrics.export.datadog.num-threads = 2 ＃与度量标准发布调度程序一起使用的线程数。
management.metrics.export.datadog.read-timeout = 10s ＃读取对此后端的请求的超时。
management.metrics.export.datadog.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.datadog.uri = https：//app.datadoghq.com＃要将度量标准发送到的URI。如果需要在到Datadog的内部代理中发布度量标准，则可以使用此方法定义代理的位置。
management.metrics.export.dynatrace.api-token =＃Dynatrace身份验证令牌。
management.metrics.export.dynatrace.batch-size = 10000 ＃用于此后端的每个请求的度量数量。如果找到更多测量值，则将发出多个请求。
management.metrics.export.dynatrace.connect-timeout = 1s ＃此后端请求的连接超时。
management.metrics.export.dynatrace.device-id = ＃将度量标准导出到Dynatrace的自定义设备的ID。
management.metrics.export.dynatrace.enabled = true ＃是否已启用将度量标准导出到此后端。
management.metrics.export.dynatrace.num-threads = 2＃与指标发布调度程序一起使用的线程数。
management.metrics.export.dynatrace.read-timeout = 10s ＃读取对此后端的请求的超时。
management.metrics.export.dynatrace.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.dynatrace.technology-type = java ＃导出指标的技术类型。用于在Dynatrace UI中以逻辑技术名称将指标分组。
management.metrics.export.dynatrace.uri = ＃要将度量标准发送到的URI。应该用于SaaS，自我管理的实例或通过内部代理进行路由。
management.metrics.export.elastic.auto-create-index = true＃如果索引不存在，是否自动创建。
management.metrics.export.elastic.batch-size = 10000 ＃用于此后端的每个请求的测量数量。如果找到更多测量值，则将发出多个请求。
management.metrics.export.elastic.connect-timeout = 1s ＃此后端请求的连接超时。
management.metrics.export.elastic.enabled = true ＃是否已启用将度量标准导出到此后端。
management.metrics.export.elastic.host = http：// localhost：9200 ＃要将度量导出到的主机。
management.metrics.export.elastic.index = metrics ＃指标导出到的索引。
management.metrics.export.elastic.index-date-format = yyyy-MM ＃用于滚动索引的索引日期格式。追加到索引名称后，以“-”开头。
management.metrics.export.elastic.num-threads = 2 ＃与度量标准发布调度程序一起使用的线程数。
management.metrics.export.elastic.password = ＃Elastic服务器的登录密码。
management.metrics.export.elastic.read-timeout = 10s ＃读取对此后端的请求的超时。
management.metrics.export.elastic.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.elastic.timestamp-field-name = @ timestamp ＃时间戳记字段的名称。 
management.metrics.export.elastic.user-name = ＃Elastic服务器的登录用户。
management.metrics.export.ganglia.addressing-mode =多播＃UDP寻址模式，单播或多播。
management.metrics.export.ganglia.duration-units =毫秒＃用于报告持续时间的基准时间单位。
management.metrics.export.ganglia.enabled = true ＃是否已启用将度量标准导出到Ganglia。
management.metrics.export.ganglia.host = localhost ＃Ganglia服务器的主机，用于接收导出的指标。
management.metrics.export.ganglia.port = 8649 ＃Ganglia服务器的端口，用于接收导出的度量。
management.metrics.export.ganglia.protocol-version = 3.1 ＃Ganglia协议版本。必须为3.1或3.0。
management.metrics.export.ganglia.rate-units = seconds ＃用于报告费率的基准时间单位。
management.metrics.export.ganglia.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.ganglia.time-to-live = 1 ＃在Ganglia上衡量指标的生存时间。将多播生存时间设置为比主机之间的跳数（路由器）大一。
management.metrics.export.graphite.duration-units =毫秒＃用于报告持续时间的基准时间单位。
management.metrics.export.graphite.enabled = true＃是否启用将度量导出到Graphite。
management.metrics.export.graphite.host = localhost ＃Graphite服务器的主机，用于接收导出的指标。
management.metrics.export.graphite.port = 2004 ＃Graphite服务器的端口，用于接收导出的度量。
management.metrics.export.graphite.protocol = pickled ＃将数据传送到Graphite时使用的协议。
management.metrics.export.graphite.rate-units = seconds ＃用于报告费率的基准时间单位。
management.metrics.export.graphite.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.graphite.tags-as-prefix =＃对于默认的命名约定，请将指定的标记键转换为度量标准前缀的一部分。
management.metrics.export.humio.api-token = ＃Humio API令牌。
management.metrics.export.humio.batch-size = 10000 ＃用于此后端的每个请求的度量数量。如果找到更多测量值，则将发出多个请求。
management.metrics.export.humio.connect-timeout = 5s ＃到此后端的请求的连接超时。
management.metrics.export.humio.enabled = true ＃是否已启用将度量标准导出到此后端。
management.metrics.export.humio.num-threads = 2 ＃与指标发布调度程序一起使用的线程数。
management.metrics.export.humio.read-timeout = 10s ＃读取对此后端的请求的超时。
management.metrics.export.humio.repository = sandbox ＃要将度量发布到的存储库的名称。
management.metrics.export.humio.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.humio.tags。* = ＃Humio标签，用于描述将在其中存储指标的数据源。Humio标签是与Micrometer标签不同的概念。千分尺的标签用于沿尺寸边界划分指标。
management.metrics.export.humio.uri = https：//cloud.humio.com＃指标发送到的URI。如果您需要在到Humio的内部代理中发布度量标准，则可以使用此方法定义代理的位置。
management.metrics.export.influx.auto-create-db = true ＃在尝试向其发布指标之前是否创建Influx数据库（如果不存在）。
management.metrics.export.influx.batch-size = 10000 ＃用于此后端的每个请求的度量数量。如果找到更多测量值，则将发出多个请求。
management.metrics.export.influx.compressed = true ＃是否启用发布到Influx的度量标准批次的GZIP压缩。
management.metrics.export.influx.connect-timeout = 1s＃与此后端的请求的连接超时。
management.metrics.export.influx.consistency =一个＃为每个点写入一致性。
management.metrics.export.influx.db = mydb ＃在将度量标准发送到Influx时将映射到“主机”的标记。
management.metrics.export.influx.enabled = true ＃是否启用将度量导出到此后端。
management.metrics.export.influx.num-threads = 2 ＃与指标发布调度程序一起使用的线程数。
management.metrics.export.influx.password = ＃Influx服务器的登录密码。
management.metrics.export.influx.read-timeout = 10s＃读取超时请求。
management.metrics.export.influx.retention-duration = ＃Influx应该在当前数据库中保留数据的时间段。
management.metrics.export.influx.retention-shard-duration = ＃碎片组覆盖的时间范围。
management.metrics.export.influx.retention-policy = ＃要使用的保留策略（如果未指定，Influx将写入DEFAULT保留策略）。
management.metrics.export.influx.retention-replication-factor = ＃集群中存储了多少数据副本。
management.metrics.export.influx.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.influx.uri = http：// localhost：8086 ＃Influx服务器的URI。
management.metrics.export.influx.user-name = ＃Influx服务器的登录用户。
management.metrics.export.jmx.domain = metrics ＃指标JMX域名。
management.metrics.export.jmx.enabled = true ＃是否已启用将度量标准导出到JMX。
management.metrics.export.jmx.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.kairos.batch-size = 10000 ＃用于此后端的每个请求的度量数量。如果找到更多测量值，则将发出多个请求。
management.metrics.export.kairos.connect-timeout = 1s ＃此后端的请求连接超时。
management.metrics.export.kairos.enabled = true ＃是否已启用将度量标准导出到此后端。
management.metrics.export.kairos.num-threads = 2 ＃与度量标准发布调度程序一起使用的线程数。
management.metrics.export.kairos.password = ＃KairosDB服务器的登录密码。
management.metrics.export.kairos.read-timeout = 10s ＃读取对此后端的请求的超时。
management.metrics.export.kairos.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.kairos.uri = localhost：8080 / api / v1 /  datapoints＃KairosDB服务器的URI。
management.metrics.export.kairos.user-name = ＃KairosDB服务器的登录用户。
management.metrics.export.newrelic.account-id = ＃新的Relic帐户ID。
management.metrics.export.newrelic.api-key = ＃新的Relic API密钥。
management.metrics.export.newrelic.batch-size = 10000 ＃用于此后端的每个请求的度量数量。如果找到更多测量值，则将发出多个请求。
management.metrics.export.newrelic.connect-timeout = 1s ＃此后端的请求连接超时。
management.metrics.export.newrelic.enabled = true ＃是否已启用将度量标准导出到此后端。
management.metrics.export.newrelic.num-threads = 2 ＃与度量标准发布调度程序一起使用的线程数。
management.metrics.export.newrelic.read-timeout = 10s ＃读取对此后端的请求的超时。
management.metrics.export.newrelic.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.newrelic.uri = https：//insights-collector.newrelic.com＃要将度量标准运送到的URI。
management.metrics.export.prometheus.descriptions = true＃是否启用发布描述作为对Prometheus的有效内容的一部分。关闭此选项可最大程度地减少每个刮板上发送的数据量。
management.metrics.export.prometheus.enabled = true ＃是否已启用将度量标准导出到Prometheus。
management.metrics.export.prometheus.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.prometheus.pushgateway.base-url = localhost：9091 ＃Pushgateway的基本URL。
management.metrics.export.prometheus.pushgateway.enabled = false ＃启用通过Prometheus Pushgateway发布。
management.metrics.export.prometheus.pushgateway.grouping-key =＃推送指标的分组键。
management.metrics.export.prometheus.pushgateway.job = ＃此应用程序实例的作业标识符。
management.metrics.export.prometheus.pushgateway.push-rate = 1m ＃推送指标的频率。
management.metrics.export.prometheus.pushgateway.shutdown-operation = ＃关机时应执行的操作。
management.metrics.export.signalfx.access-token = ＃SignalFX访问令牌。
management.metrics.export.signalfx.batch-size = 10000 ＃用于此后端的每个请求的度量数量。如果找到更多测量值，则将发出多个请求。
management.metrics.export.signalfx.connect-timeout = 1s ＃此后端的请求连接超时。
management.metrics.export.signalfx.enabled = true ＃是否已启用将度量导出到此后端。
management.metrics.export.signalfx.num-threads = 2 ＃与指标发布调度程序一起使用的线程数。
management.metrics.export.signalfx.read-timeout = 10s ＃读取对此后端的请求的超时。
management.metrics.export.signalfx.source = ＃唯一标识正在将指标发布到SignalFx的应用程序实例。默认为本地主机名。
management.metrics.export.signalfx.step = 10s＃要使用的步长（即报告频率）。
management.metrics.export.signalfx.uri = https：//ingest.signalfx.com＃要将度量标准发送到的URI。
management.metrics.export.simple.enabled = true ＃在没有其他任何导出器的情况下，是否启用将度量导出到内存后端的功能。
management.metrics.export.simple.mode =累积＃计数模式。
management.metrics.export.simple.step = 1m ＃要使用的步长（即报告频率）。
management.metrics.export.statsd.enabled = true ＃是否启用将度量导出到StatsD。
management.metrics.export.statsd.flavor =数据狗＃要使用的StatsD线路协议。
management.metrics.export.statsd.host = localhost ＃StatsD服务器的主机，用于接收导出的指标。
management.metrics.export.statsd.max-packet-length = 1400 ＃单个有效负载的总长度应保留在网络的MTU中。
management.metrics.export.statsd.polling-frequency = 10s ＃将多久轮询一次仪表。轮询量规时，将重新计算其值，并且如果该值已更改（或publishUnchangedMeters为true），则将其发送到StatsD服务器。
management.metrics.export.statsd.port = 8125 ＃StatsD服务器的端口，用于接收导出的度量。
management.metrics.export.statsd.publish-unchanged-meters= true ＃是否将未更改的计量表发送到StatsD服务器。
management.metrics.export.wavefront.api-token = ＃直接将指标发布到Wavefront API主机时使用的API令牌。
management.metrics.export.wavefront.batch-size = 10000 ＃用于此后端的每个请求的度量数量。如果找到更多测量值，则将发出多个请求。
management.metrics.export.wavefront.connect-timeout = 1s ＃此后端的请求连接超时。
management.metrics.export.wavefront.enabled = true ＃是否已启用将度量标准导出到此后端。
management.metrics.export.wavefront.global-prefix =＃全局前缀，用于在Wavefront UI中查看时，将源自此应用程序白盒检测的指标与源自其他Wavefront集成的指标分开。
management.metrics.export.wavefront.num-threads = 2 ＃与度量标准发布调度程序一起使用的线程数。
management.metrics.export.wavefront.read-timeout = 10s ＃读取对此后端的请求的超时。
management.metrics.export.wavefront.source = ＃应用实例的唯一标识符，该标识符是发布到Wavefront的指标的来源。默认为本地主机名。
management.metrics.export.wavefront.step = 10s ＃要使用的步长（即报告频率）。
management.metrics.export.wavefront.uri = https：//longboard.wavefront.com＃要将度量标准发送到的URI。
management.metrics.use-global-registry = true ＃自动配置的MeterRegistry实现是否应绑定到Metrics上的全局静态注册表。
management.metrics.tags。* = ＃应用于每个仪表的通用标签。
management.metrics.web.client.max-uri-tags = 100 ＃允许的唯一URI标签值的最大数量。达到标签值的最大数量后，过滤器会拒绝带有其他标签值的指标。
management.metrics.web.client.requests-metric-name = http.client.requests ＃发送请求的度量标准名称。
management.metrics.web.server.auto-time-requests = true ＃是否应自动计时由Spring MVC，WebFlux或Jersey处理的请求。
management.metrics.web.server.max-uri-tags = 100 ＃允许的唯一URI标签值的最大数量。达到标签值的最大数量后，过滤器会拒绝带有其他标签值的指标。
management.metrics.web.server.requests-metric-name = http.server.requests ＃接收到的请求的度量标准名称。


＃---------------------------------------- 
＃开发人员属性
＃----- -----------------------------------

＃DEVTOOLS（DevToolsProperties）
 spring.devtools.add-properties = true ＃是否启用开发属性默认值。
spring.devtools.livereload.enabled = true ＃是否启用与livereload.com兼容的服务器。
spring.devtools.livereload.port = 35729 ＃服务器端口。
spring.devtools.restart.additional-exclude = ＃应当从触发完全重启中排除的其他模式。
spring.devtools.restart.additional-paths = ＃监视更改的其他路径。
spring.devtools.restart.enabled = true ＃是否启用自动重启。
spring.devtools.restart.exclude= META-INF / maven / **，META-INF /资源/ **，资源/ **，静态/ **，公共/ **，模板/**、**/*Test.class、**/ * Tests.class，git.properties，META-INF / build-info.properties ＃应该从触发完全重启的模式中排除。
spring.devtools.restart.log-condition-evaluation-delta = true ＃是否在重新启动时记录条件评估增量。
spring.devtools.restart.poll-interval = 1s ＃等待两次轮询类路径更改之间的时间。
spring.devtools.restart.quiet-period = 400ms ＃触发重新启动之前，无需对类路径进行任何更改所需的安静时间。
spring.devtools.restart.trigger-file =# Name of a specific file that, when changed, triggers the restart check. If not specified, any classpath file change triggers the restart.

＃REMOTE DEVTOOLS（RemoteDevToolsProperties）
 spring.devtools.remote.context-path = /。~~ spring-boot！〜＃用于处理远程连接的上下文路径。
spring.devtools.remote.proxy.host = ＃用于连接到远程应用程序的代理主机。
spring.devtools.remote.proxy.port = ＃用于连接到远程应用程序的代理的端口。
spring.devtools.remote.restart.enabled = true ＃是否启用远程重启。
spring.devtools.remote.secret = ＃建立连接所需的共享机密（启用远程支持所必需）。
spring.devtools.remote.secret-header-name= X-AUTH-TOKEN ＃用于传输共享机密的HTTP标头。


＃---------------------------------------- 
＃测试属性
＃----- -----------------------------------

spring.test.database.replace = any ＃要替换的现有数据源的类型。
spring.test.mockmvc.print = default ＃MVC打印选项。
```

------

| [上一个](https://docs.spring.io/spring-boot/docs/2.1.3.RELEASE/reference/html/appendix.html) | [向上](https://docs.spring.io/spring-boot/docs/2.1.3.RELEASE/reference/html/appendix.html) | [下一个](https://docs.spring.io/spring-boot/docs/2.1.3.RELEASE/reference/html/configuration-metadata.html) |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 第十部分附录                                                 | [家](https://docs.spring.io/spring-boot/docs/2.1.3.RELEASE/reference/html/index.html) | 附录B.配置元数据                                             |