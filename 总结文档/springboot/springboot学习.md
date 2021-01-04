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

​	通过@ConfigurationProperties注解可以把yaml文件的数据注入到对象中。需要添加前缀prefix=“还必须要注入到spring容器进行管理。@value()注解可以把yaml文件中指定的数据导入到对象中。

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
@Validated
public class Person {
    @NotBlank
    private String name;
    private Integer age;
    private String sex;
    private Map<String,Object> map;
    private List<String> annimals;
}
//通过@validated注解进行开启注解
```

