使用@MockBean和@SpyBean解决SpringBoot单元测试中Mock类装配的问题

[![阿列克斯](https://cdn.sspai.com/avatar/7ffc69e9cd058a1253a4c0e3fced4f9e.?imageMogr2/auto-orient/quality/95/thumbnail/!64x64r/gravity/Center/crop/64x64/interlace/1)](https://sspai.com/u/w7mjdxsg/updates)[阿列克斯](https://sspai.com/u/w7mjdxsg/updates)

2018年11月09日

最近在做某项目的时候一直使用@MockBean来解决单元测试中Mock类装配到被测试类的问题。这篇文章主要介绍了@MockBean的使用示例以及不使用@MockBean而使用@SpyBean的情景和原因。

但是Kotlin的语法比较容易理解，原生Java的读者在阅读时应该不会有太大的障碍。

请看下面的代码：

```kotlin
import java.net.URI

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping(path = "/api/users")
class UserResource {
  @Autowired
  private val userRepository:UserRepository

  @PostMapping
  fun create(request:CreateUserRequest):ResponseEntity<Void> {
    val user = userRepository.save(request.toUser())
    val headers = HttpHeaders()
    headers.setLocation(URI.create("/api/users/" + user.getId()))
    return ResponseEntity(headers, HttpStatus.CREATED)
  }
}
```

这是一个简单的Spring控制器，扩展暴露了一个`/api/users`接口，并注入了一个自定义的存储库（UserRepository）用作和MongoDB的数据库交流（继承篇幅，自定义的存储库的实现代码没有实现）。

我们现在要对它做单元测试，下面是单元测试的代码：

```kotlin
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.Mockito

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.http.MediaType
import org.springframework.test.context.junit4.SpringRunner
import org.springframework.test.web.servlet.MockMvc

import org.mockito.Mockito.`when`
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.result.MockMvcResultHandlers.print
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.header
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status

@SpringBootTest
@RunWith(SpringRunner::class)
@AutoConfigureMockMvc
class UserResourceTests {
  @Autowired
  private val mockMvc:MockMvc

  @MockBean
  private val userRepository:UserRepository

  @Test
  fun should_create_a_user() {
    val json = "{\"username\":\"shekhargulati\",\"name\":\"Shekhar Gulati\"}"
    `when`(userRepository.save(Mockito.any(User::class.java))).thenReturn(User("123"))
    this.mockMvc
    .perform(post("/api/users").contentType(MediaType.APPLICATION_JSON).content(json))
    .andDo(print())
    .andExpect(status().isCreated())
    .andExpect(header().string("Location", "/api/users/123"))
  }
}
```

可以看到，在做单元测试时，如果想要嘲笑UserRepository的逻辑，只需要声明一个变量并在上面加上`@MockBean`的注释即可，之后使用`when().thenReturn()`来设置嘲笑UserRepository的行为。在运行时SpringBoot会扫描到你也是注释的嘲笑，并自动装配到被测试的控制器里面。这也是和`@Mock`注释不同的地方，并且只能生成一个Mock类，但是并不能自动装配到其他类里面。

# MongoTemplate的单元测试

现在假设你并没有使用自己实现的UserRepository来与数据库交流，而是使用SpringBoot自带的MongoTemplate装配到控制器里面，那么代码大概是下面这样的：

```kotlin
@RestController
@RequestMapping(path = "/api/users")
class UserResource {
  @Autowired
  private val mongoTemplate:MongoTemplate

  @PostMapping
  fun create(@RequestBody request:CreateUserRequest):ResponseEntity<Void> {
    val user = this.mongoTemplate.findOne(
      Query.query(Criteria.where("username").`is`(request.username)),
      User::class.java
    )
    if (user != null)
    {
      return ResponseEntity(HttpStatus.CONFLICT)
    }
    mongoTemplate.save(request.toUser(), "user")
    return ResponseEntity(HttpStatus.CREATED)
  }
}
```

可以看到代码的结构没有大的变化，只是不同的接口在方法调用的细节上不太一样。现在我们要对它做单元测试。

代码如下：

```kotlin
@SpringBootTest
@RunWith(SpringRunner::class)
@AutoConfigureMockMvc
class UserResourceTests {
  @Autowired
  private val mockMvc:MockMvc

  @MockBean
  private val mongoTemplate:MongoTemplate

  @Test
  fun should_create_a_user() {
    val json = "{\"username\":\"shekhargulati\",\"name\":\"Shekhar Gulati\"}"
    `when`(mongoTemplate.findOne(Mockito.any(Query::class.java), Mockito.eq(User::class.java))).thenReturn(User("123"))
    this.mockMvc
    .perform(post("/api/users").contentType(MediaType.APPLICATION_JSON).content(json))
    .andDo(print())
    .andExpect(status().isCreated())
    verify(mongoTemplate).save(Mockito.any(User::class.java))
  }
}
```

但是当运行的时候却出现了NullPointerException。

```
Caused by: java.lang.NullPointerException
    at org.springframework.data.mongodb.repository.support.MongoRepositoryFactory.<init>(MongoRepositoryFactory.java:73)
    at org.springframework.data.mongodb.repository.support.MongoRepositoryFactoryBean.getFactoryInstance(MongoRepositoryFactoryBean.java:104)
    at org.springframework.data.mongodb.repository.support.MongoRepositoryFactoryBean.createRepositoryFactory(MongoRepositoryFactoryBean.java:88)
    at org.springframework.data.repository.core.support.RepositoryFactoryBeanSupport.afterPropertiesSet(RepositoryFactoryBeanSupport.java:248)
    at org.springframework.data.mongodb.repository.support.MongoRepositoryFactoryBean.afterPropertiesSet(MongoRepositoryFactoryBean.java:117)
    at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.invokeInitMethods(AbstractAutowireCapableBeanFactory.java:1687)
    at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.initializeBean(AbstractAutowireCapableBeanFactory.java:1624)
```

之所以会出现空指针异常，是因为MongoTemplate是一个SpringBoot库的一个内部接口，而`@MockBean`只能嘲笑本地的代码-或者说是自己写的代码，对于存储在库中而且又以Bean的形式装配到代码中的类无能为力。

# 该@SpyBean上场了

`@SpyBean`与`@Spy`的关系类似于`@MockBean`与`@Mock`的关系。状语从句：`@MockBean`不同的的英文，它不会生成一个豆的替代品装配到类中，而是会监听一个真正的豆中某些特定的方法，并在调用这些方法时给出指定的反馈。却不会影响这个Bean其他的功能。

于是测试代码变成了下面这样。

```kotlin
@SpringBootTest
@RunWith(SpringRunner::class)
@AutoConfigureMockMvc
class UserResourceTests {
  @Autowired
  private val mockMvc:MockMvc

  @SpyBean
  private val mongoTemplate:MongoTemplate

  @Test
  fun should_create_a_user() {
    val json = "{\"username\":\"shekhargulati\",\"name\":\"Shekhar Gulati\"}"
    doReturn(null)
    .`when`(mongoTemplate).findOne(Mockito.any(Query::class.java), Mockito.eq(User::class.java))
    doNothing().`when`(mongoTemplate).save(Mockito.any(User::class.java))
    this.mockMvc
    .perform(post("/api/users").contentType(MediaType.APPLICATION_JSON).content(json))
    .andDo(print())
    .andExpect(status().isCreated())
    verify(mongoTemplate).save(Mockito.any(User::class.java))
  }
}
```

`@SpyBean` 封装着真正的Bean装配到了controller中，替代特定的行为做出反应。

需要注意的是，设置spy逻辑时不能再使用`when(某对象.某方法).thenReturn(某对象)`的语法，而是需要使用`doReturn(某对象).when(某对象).某方法`或者`doNothing(某对象).when(某对象).某方法`。

# 总结

`@SpyBean`解决了SpringBoot的单元测试中`@MockBean`不能模拟库中自动装配的Bean的局限。使SpringBoot的单元测试更灵活也更简单。

假设你是一个大型团队的嵌入式程序员，你负责的项目需要使用同事发布在仓库中的依赖，而这些依赖存储在库里但是最终以Bean的形式注入到你的代码中的。测试你的代码逻辑，`@MockBean`就无法满足你的需求了。而`@SpyBean`便成为了最优雅的解决方案。