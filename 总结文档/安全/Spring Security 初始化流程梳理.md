## Spring Security 初始化流程梳理

原创 江南一点雨 [江南一点雨](javascript:void(0);) *今天*

来自专辑

SpringSecurity系列

松哥原创的 Spring Boot 视频教程已经杀青，感兴趣的小伙伴戳这里-->[Spring Boot+Vue+微人事视频教程](https://mp.weixin.qq.com/s?__biz=MzI1NDY0MTkzNQ==&mid=2247488799&idx=1&sn=cdfd5315ff18c979b6f5d390ab4d9059&scene=21#wechat_redirect)

------

前面我们对 Spring Security 源码的讲解都比较零散，今天松哥试着来和大家捋一遍 Spring Security 的初始化流程，顺便将前面的源码解析文章串起来。

Spring Security 启动流程并不难，但是由于涉及到的知识点非常庞杂，所以松哥在之前已经连载过好几篇源码解读的文章了，大家把这些源码解读的文章搞懂了，今天这篇文章就好理解了。

在 Spring Boot 中，Spring Security 的初始化，我们就从自动化配置开始分析吧！

## 1.SecurityAutoConfiguration

Spring Security 的自动化配置类是 SecurityAutoConfiguration，我们就从这个配置类开始分析。

```
@Configuration(proxyBeanMethods = false)
@ConditionalOnClass(DefaultAuthenticationEventPublisher.class)
@EnableConfigurationProperties(SecurityProperties.class)
@Import({ SpringBootWebSecurityConfiguration.class, WebSecurityEnablerConfiguration.class,
  SecurityDataConfiguration.class })
public class SecurityAutoConfiguration {

 @Bean
 @ConditionalOnMissingBean(AuthenticationEventPublisher.class)
 public DefaultAuthenticationEventPublisher authenticationEventPublisher(ApplicationEventPublisher publisher) {
  return new DefaultAuthenticationEventPublisher(publisher);
 }

}
```

这个 Bean 中，定义了一个事件发布器。另外导入了三个配置：

1. SpringBootWebSecurityConfiguration：这个配置的作用是在如果开发者没有自定义 WebSecurityConfigurerAdapter 的话，这里提供一个默认的实现。
2. WebSecurityEnablerConfiguration：这个配置是 Spring Security 的核心配置，也将是我们分析的重点。
3. SecurityDataConfiguration：提供了 Spring Security 整合 Spring Data 的支持，由于国内使用 MyBatis 较多，所以这个配置发光发热的场景有限。

## 2.WebSecurityEnablerConfiguration

接着来看上面出现的 WebSecurityEnablerConfiguration：

```
@Configuration(proxyBeanMethods = false)
@ConditionalOnBean(WebSecurityConfigurerAdapter.class)
@ConditionalOnMissingBean(name = BeanIds.SPRING_SECURITY_FILTER_CHAIN)
@ConditionalOnWebApplication(type = ConditionalOnWebApplication.Type.SERVLET)
@EnableWebSecurity
public class WebSecurityEnablerConfiguration {

}
```

这个配置倒没啥可说的，给了一堆生效条件，最终给出了一个 @EnableWebSecurity 注解，看来初始化重任落在 @EnableWebSecurity 注解身上了。

## 3.@EnableWebSecurity

```
@Retention(value = java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value = { java.lang.annotation.ElementType.TYPE })
@Documented
@Import({ WebSecurityConfiguration.class,
  SpringWebMvcImportSelector.class,
  OAuth2ImportSelector.class })
@EnableGlobalAuthentication
@Configuration
public @interface EnableWebSecurity {

 /**
  * Controls debugging support for Spring Security. Default is false.
  * @return if true, enables debug support with Spring Security
  */
 boolean debug() default false;
}
```

@EnableWebSecurity 所做的事情，有两件比较重要：

1. 导入 WebSecurityConfiguration 配置。
2. 通过 @EnableGlobalAuthentication 注解引入全局配置。

### 3.1 WebSecurityConfiguration

WebSecurityConfiguration 类实现了两个接口，我们来分别看下：

```
public class WebSecurityConfiguration implements ImportAware, BeanClassLoaderAware {
}
```

ImportAware 接口和 @Import 注解一起使用的。实现了 ImportAware 接口的配置类可以方便的通过 setImportMetadata 方法获取到导入类中的数据配置。

可能有点绕，我再梳理下，就是 WebSecurityConfiguration 实现了 ImportAware 接口，使用 @Import 注解在 @EnableWebSecurity 上导入 WebSecurityConfiguration 之后，在 WebSecurityConfiguration 的 setImportMetadata 方法中可以方便的获取到 @EnableWebSecurity 中的属性值，这里主要是 debug 属性。

我们来看下 WebSecurityConfiguration#setImportMetadata 方法：

```
public void setImportMetadata(AnnotationMetadata importMetadata) {
 Map<String, Object> enableWebSecurityAttrMap = importMetadata
   .getAnnotationAttributes(EnableWebSecurity.class.getName());
 AnnotationAttributes enableWebSecurityAttrs = AnnotationAttributes
   .fromMap(enableWebSecurityAttrMap);
 debugEnabled = enableWebSecurityAttrs.getBoolean("debug");
 if (webSecurity != null) {
  webSecurity.debug(debugEnabled);
 }
}
```

获取到 debug 属性赋值给 WebSecurity。

实现 BeanClassLoaderAware 接口则是为了方便的获取 ClassLoader。

这是 WebSecurityConfiguration 实现的两个接口。

在 WebSecurityConfiguration 内部定义的 Bean 中，最为重要的是两个方法：

1. springSecurityFilterChain 该方法目的是为了获取过滤器链。
2. setFilterChainProxySecurityConfigurer 这个方法是为了收集配置类并创建 WebSecurity。

这两个方法是核心，我们来逐一分析，先来看 setFilterChainProxySecurityConfigurer：

```
@Autowired(required = false)
public void setFilterChainProxySecurityConfigurer(
  ObjectPostProcessor<Object> objectPostProcessor,
  @Value("#{@autowiredWebSecurityConfigurersIgnoreParents.getWebSecurityConfigurers()}") List<SecurityConfigurer<Filter, WebSecurity>> webSecurityConfigurers)
  throws Exception {
 webSecurity = objectPostProcessor
   .postProcess(new WebSecurity(objectPostProcessor));
 if (debugEnabled != null) {
  webSecurity.debug(debugEnabled);
 }
 webSecurityConfigurers.sort(AnnotationAwareOrderComparator.INSTANCE);
 Integer previousOrder = null;
 Object previousConfig = null;
 for (SecurityConfigurer<Filter, WebSecurity> config : webSecurityConfigurers) {
  Integer order = AnnotationAwareOrderComparator.lookupOrder(config);
  if (previousOrder != null && previousOrder.equals(order)) {
   throw new IllegalStateException(
     "@Order on WebSecurityConfigurers must be unique. Order of "
       + order + " was already used on " + previousConfig + ", so it cannot be used on "
       + config + " too.");
  }
  previousOrder = order;
  previousConfig = config;
 }
 for (SecurityConfigurer<Filter, WebSecurity> webSecurityConfigurer : webSecurityConfigurers) {
  webSecurity.apply(webSecurityConfigurer);
 }
 this.webSecurityConfigurers = webSecurityConfigurers;
}
```

首先这个方法有两个参数，两个参数都会自动进行注入，第一个参数 ObjectPostProcessor 是一个后置处理器，默认的实现是 AutowireBeanFactoryObjectPostProcessor，主要是为了将 new 出来的对象注入到 Spring 容器中（参见[深入理解 SecurityConfigurer 【源码篇】](https://mp.weixin.qq.com/s?__biz=MzI1NDY0MTkzNQ==&mid=2247489399&idx=1&sn=a450a7e432cdd0a4e2ee279604984f3a&scene=21#wechat_redirect)）。

第二个参数 webSecurityConfigurers 是一个集合，这个集合里存放的都是 SecurityConfigurer，我们前面分析的过滤器链中过滤器的配置器，包括 WebSecurityConfigurerAdapter 的子类，都是 SecurityConfigurer 的实现类。根据 @Value 注解中的描述，我们可以知道，这个集合中的数据来自 autowiredWebSecurityConfigurersIgnoreParents.getWebSecurityConfigurers() 方法。

在 WebSecurityConfiguration 中定义了该实例：

```
@Bean
public static AutowiredWebSecurityConfigurersIgnoreParents autowiredWebSecurityConfigurersIgnoreParents(
  ConfigurableListableBeanFactory beanFactory) {
 return new AutowiredWebSecurityConfigurersIgnoreParents(beanFactory);
}
```

它的 getWebSecurityConfigurers 方法我们来看下：

```
public List<SecurityConfigurer<Filter, WebSecurity>> getWebSecurityConfigurers() {
 List<SecurityConfigurer<Filter, WebSecurity>> webSecurityConfigurers = new ArrayList<>();
 Map<String, WebSecurityConfigurer> beansOfType = beanFactory
   .getBeansOfType(WebSecurityConfigurer.class);
 for (Entry<String, WebSecurityConfigurer> entry : beansOfType.entrySet()) {
  webSecurityConfigurers.add(entry.getValue());
 }
 return webSecurityConfigurers;
}
```

可以看到，其实就是从 beanFactory 工厂中查询到 WebSecurityConfigurer 的实例返回。

WebSecurityConfigurer 的实例其实就是 WebSecurityConfigurerAdapter，如果我们没有自定义 WebSecurityConfigurerAdapter，那么默认使用的是 SpringBootWebSecurityConfiguration 中自定义的 WebSecurityConfigurerAdapter。

当然我们也可能自定义了 WebSecurityConfigurerAdapter，而且如果我们配置了多个过滤器链（多个 HttpSecurity 配置），那么 WebSecurityConfigurerAdapter 的实例也将有多个。所以这里返回的是 List 集合。

至此，我们搞明白了了 setFilterChainProxySecurityConfigurer 方法的两个参数。回到该方法我们继续分析。

接下来创建了 webSecurity 对象，并且放到 ObjectPostProcessor 中处理了一下，也就是把 new 出来的对象存入 Spring 容器中。

调用 webSecurityConfigurers.sort 方法对 WebSecurityConfigurerAdapter 进行排序，如果我们配置了多个 WebSecurityConfigurerAdapter 实例（多个过滤器链，参见：[Spring Security 竟然可以同时存在多个过滤器链？](https://mp.weixin.qq.com/s?__biz=MzI1NDY0MTkzNQ==&mid=2247489302&idx=2&sn=032f8ccc6a9955799702d6c2766ca6eb&scene=21#wechat_redirect)），那么我们肯定要通过 @Order 注解对其进行排序，以便分出一个优先级出来，而且这个优先级还不能相同。

所以接下来的 for 循环中就是判断这个优先级是否有相同的，要是有，直接抛出异常。

最后，遍历 webSecurityConfigurers，并将其数据挨个配置到 webSecurity 中。webSecurity.apply 方法会将这些配置存入 AbstractConfiguredSecurityBuilder.configurers 属性中（参见：[深入理解 HttpSecurity【源码篇】](https://mp.weixin.qq.com/s?__biz=MzI1NDY0MTkzNQ==&mid=2247489405&idx=2&sn=b7790a660b787eec6d7604409aec41c3&scene=21#wechat_redirect)）。

这就是 setFilterChainProxySecurityConfigurer 方法的工作逻辑，大家看到，它主要是在构造 WebSecurity 对象。

WebSecurityConfiguration 中第二个比较关键的方法是 springSecurityFilterChain，该方法是在上个方法执行之后执行，方法的目的是构建过滤器链，我们来看下：

```
@Bean(name = AbstractSecurityWebApplicationInitializer.DEFAULT_FILTER_NAME)
public Filter springSecurityFilterChain() throws Exception {
 boolean hasConfigurers = webSecurityConfigurers != null
   && !webSecurityConfigurers.isEmpty();
 if (!hasConfigurers) {
  WebSecurityConfigurerAdapter adapter = objectObjectPostProcessor
    .postProcess(new WebSecurityConfigurerAdapter() {
    });
  webSecurity.apply(adapter);
 }
 return webSecurity.build();
}
```

这里首先会判断有没有 webSecurityConfigurers 存在，一般来说都是有的，即使你没有配置，还有一个默认的。当然，如果不存在的话，这里会现场 new 一个出来，然后调用 apply 方法。

最最关键的就是最后的 webSecurity.build() 方法了，这个方法的调用就是去构建过滤器链了。

根据 [深入理解 HttpSecurity【源码篇】](https://mp.weixin.qq.com/s?__biz=MzI1NDY0MTkzNQ==&mid=2247489405&idx=2&sn=b7790a660b787eec6d7604409aec41c3&scene=21#wechat_redirect) 一文的介绍，这个 build 方法最终是在 AbstractConfiguredSecurityBuilder#doBuild 方法中执行的：

```
@Override
protected final O doBuild() throws Exception {
 synchronized (configurers) {
  buildState = BuildState.INITIALIZING;
  beforeInit();
  init();
  buildState = BuildState.CONFIGURING;
  beforeConfigure();
  configure();
  buildState = BuildState.BUILDING;
  O result = performBuild();
  buildState = BuildState.BUILT;
  return result;
 }
}
```

这里会记录下来整个项目的构建状态。三个比较关键的方法，一个是 init、一个 configure 还有一个 performBuild。

init 方法会遍历所有的 WebSecurityConfigurerAdapter ，并执行其 init 方法。WebSecurityConfigurerAdapter#init 方法主要是做 HttpSecurity 的初始化工作，具体参考：深入理解 WebSecurityConfigurerAdapter【源码篇】。init 方法在执行时，会涉及到 HttpSecurity 的初始化，而 HttpSecurity 的初始化，需要配置 AuthenticationManager，所以这里最终还会涉及到一些全局的 AuthenticationManagerBuilder 及相关属性的初始化，具体参见：[深入理解 AuthenticationManagerBuilder 【源码篇】](https://mp.weixin.qq.com/s?__biz=MzI1NDY0MTkzNQ==&mid=2247489418&idx=1&sn=e41628d258fcd0b2d00fb291fa0cfdef&scene=21#wechat_redirect)，需要注意的是，AuthenticationManager 在初始化的过程中，也会来到这个 doBuild 方法中，具体参考松哥前面文章，这里就不再赘述。

configure 方法会遍历所有的 WebSecurityConfigurerAdapter ，并执行其 configure 方法。WebSecurityConfigurerAdapter#configure 方法默认是一个空方法，开发者可以自己重写该方法去定义自己的 WebSecurity，具体参考：深入理解 WebSecurityConfigurerAdapter【源码篇】。

最后调用 performBuild 方法进行构建，这个最终执行的是 WebSecurity#performBuild 方法，该方法执行流程，参考松哥前面文章深入理解 WebSecurityConfigurerAdapter【源码篇】。

performBuild 方法执行的过程，也是过滤器链构建的过程。里边会调用到过滤器链的构建方法，也就是默认的十多个过滤器会挨个构建，这个构建过程也会调用到这个 doBuild 方法。

performBuild 方法中将成功构建 FilterChainProxy，最终形成我们需要的过滤器链。

### 3.2 @EnableGlobalAuthentication

@EnableWebSecurity 注解除了过滤器链的构建，还有一个注解就是 @EnableGlobalAuthentication。我们也顺便来看下：

```
@Retention(value = java.lang.annotation.RetentionPolicy.RUNTIME)
@Target(value = { java.lang.annotation.ElementType.TYPE })
@Documented
@Import(AuthenticationConfiguration.class)
@Configuration
public @interface EnableGlobalAuthentication {
}
```

可以看到，该注解的作用主要是导入 AuthenticationConfiguration 配置，该配置前面已经介绍过了，参考：[深入理解 AuthenticationManagerBuilder 【源码篇】](https://mp.weixin.qq.com/s?__biz=MzI1NDY0MTkzNQ==&mid=2247489418&idx=1&sn=e41628d258fcd0b2d00fb291fa0cfdef&scene=21#wechat_redirect)一文。

## 4.小结

这便是 Spring Security 的一个大致的初始化流程。大部分的源码在前面的文章中都讲过了，本文主要是是一个梳理，如果小伙伴们还没看前面的文章，建议看过了再来学习本文哦。

[Spring Security 系列历史文章合集](https://mp.weixin.qq.com/mp/appmsgalbum?__biz=MzI1NDY0MTkzNQ==&action=getalbum&album_id=1319828555819286528&subscene=38&scenenote=https%3A%2F%2Fmp.weixin.qq.com%2Fs%3F__biz%3DMzI1NDY0MTkzNQ%3D%3D%26mid%3D2247489179%26idx%3D1%26sn%3D01aae04306638e68d9ea483e508d56ac%26chksm%3De9c344fbdeb4cded021f3e125f39cb4f5fb25ca5e903a621dbb5bd76264c76a1b90bbc7e6756%26scene%3D38%26key%3Dd7cd6cebe5b965e753315b8fba3c3785b8b3ed8da8440543110c60ab3a01fc0291bab2006360738c9faf88e3a0a5e2e2747427d90eaa778919bcd3c12bd32d84bacd1b7b197b7c133449c13e60589b5f%26ascene%3D0%26uin%3DMTQ5NzA1MzQwMw%3D%3D%26devicetype%3DiMac%2BMacBookPro15%2C1%2BOSX%2BOSX%2B10.13.6%2Bbuild(17G2208)%26version%3D12031f10%26nettype%3DWIFI%26lang%3Den%26fontScale%3D100%26exportkey%3DA3Wiahk84DJaxlesHRkR9Lo%3D%26pass_ticket%3DTw4Lf%2FDXMBnX6b1zckIiLAXh%2FIXYTPiEPUroWij5MLEcC%2BvlNTmlIjOKDAln3v39%26winzoom%3D1.000000&uin=&key=&devicetype=iMac+MacBookPro15%2C1+OSX+OSX+10.13.6+build(17G2208)&version=12031f10&lang=en&nettype=WIFI&ascene=0&fontScale=100&winzoom=1.000000)。