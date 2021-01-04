###  springBoot基础学习

##### 一 、application.yaml的使用

​		application.yaml支持多种数据类型方式，譬如基本的字面量数据，支持对象、map和list等多种格式。

```java
server:
  port: 8090
person:
  name: zhangsan
  age: 18
  sex: 男
  map:
    classs: 5
    love: liuyujiao
  # 表示列表，可以给对象注入属性值      
  annimals:
    - cat
    - dog
    - ping

```

``` java
@Data
@Component
@ConfigurationProperties(prefix = "person")
public class Person {
    private String name;
    private Integer age;
    private String sex;
    private Map<String,Object> map;
    private List<String> annimals;
}
```

通过@ConfigurationProperties注解可以把yaml文件的数据注入到对象中。需要添加前缀prefix=“还必须要注入到spring容器进行管理。@value()注解可以把yaml文件中指定的数据导入到对象中。

​	@value()注解可以用${}从环境变量和配置文件中获取中，还可以支持#{}支持（spEL表达式）

``` java
    @Value("${person.name.}")
    private String name;
    @Value("#{10*20}")
    private Integer age;
	//可以支持从全局变量和配置文件中获取指定的值
```

对比两者之间的区别

------

| 区别           | @Value | @ConfigurationProperties      |
| -------------- | ------ | ----------------------------- |
| spEL表达式     | 支持   | 不支持                        |
| 松散绑定       | 不支持 | 支持（就是驼峰模式last-name） |
| jsR303数据校验 | 不支持 | 支持                          |

``` ja
@Data
@Component
@ConfigurationProperties(prefix = "person")
@Validated //开启注解
public class Person {
    @NotBlank
    private String name;
    private Integer age;
    private String sex;
    private Map<String,Object> map;
    private List<String> annimals;
}

```

#####  二、@propertySource&@importResource

**@propertySource：加载指定的配置文件，@configurationProperties是默认从全局配置文件获取值**，假如把一些配置放在其他的配置文件中时，可以通过@propertySource注解。



![image-20200714150420800](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200714150420800.png)

默认加载不了，写在其他地方的配置文件，springboot默认加载的是application.yml，想要加载person.yml中的数据，需要注解@propertySource.

![image-20200714152133456](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200714152133456.png)



**@importResoure:导入spring定义的bean等。springboot默认采取@configuration注解进行注入。**

![image-20200714161257528](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200714161257528.png)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">
        <bean id="helloService" class="com.dream.order.manage.service.HelloService"></bean>
</beans>
```

```java
@ImportResource(locations = {"classpath:beans.xml"})
@SpringBootApplication
public class SpringbootDemo {
    public static void main(String[] args) {
        SpringApplication.run(SpringbootDemo.class,args);
    }
}
```

**默认的情况下，springBoot通过@Configuration和@Bean来实现将bean加载到容器中。**

```
@Configuration
public class MyAppConfig {
    @Bean
    public HelloService helloService(){
        return new HelloService();
    }
}
```

**配置文件占位符** ${}通过占位符来实现变量

```
server:
  port: 8090
person:
  name: jiangll${random.uuid}
  age: 18${random.int}
  sex: 男
  map:
    classs: 5
    love: ${person.sex}liuyujiao
  annimals:
    - ${person.name}cat
    - dog
    - ping
producter:
  real:
    false
```

**三、profile**

spring进行多环境支持。

1、yml的文档块进行

```
server:
  port: 8081
spring:
  profiles:
    active: prod
---
server:
  port: 8082
spring:
  profiles: dev
---
server:
  port: 8083
spring:
  profiles: prod
```

2、修改idel的参数配置

![image-20200714164147081](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200714164147081.png)

3、修改jvm的配置，打包启动的时候添加参数

-Dspring.profiles.active=prod

![image-20200714164416441](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200714164416441.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200714164904111.png" alt="image-20200714164904111" style="zoom:50%;" />

![image-20200714165745032](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200714165745032.png)

![image-20200714165943328](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200714165943328.png)

**通过这种方式，我们可以在项目已经启动了部署了，我们需要让项目重新启动时，加载我们新修改的配置文件。**

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200714170127730.png" alt="image-20200714170127730" style="zoom:67%;" />

**自动装配**

![image-20200714173830438](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200714173830438.png)