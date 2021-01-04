# SpringBoot 单元测试详解（Mockito、MockBean）

[![img](https://upload.jianshu.io/users/upload_avatars/5114528/3c67dd2b-1f2b-47ee-8baf-bcc801189150.jpeg?imageMogr2/auto-orient/strip|imageView2/1/w/96/h/96/format/webp)](https://www.jianshu.com/u/6fb3be4add8d)

[PC_Repair](https://www.jianshu.com/u/6fb3be4add8d)关注

12019.05.31 20:50:17字数 1,561阅读 29,618

一个测试方法主要包括三部分：

1）setup

2）执行操作

3）验证结果



```java
public class CalculatorTest {
    Calculator mCalculator;

    @Before // setup
    public void setup() {
        mCalculator = new Calculator();
    }

    @Test //assert 部分可以帮助我们验证一个结果
    public void testAdd() throws Exception {
        int sum = mCalculator.add(1, 2);
        assertEquals(3, sum);  //为了简洁，往往会static import Assert里面的所有方法。
    }

    @Test
    @Ignore("not implemented yet") // 测试时忽略该方法
    public void testMultiply() throws Exception {
    }

    // 表示验证这个测试方法将抛出 IllegalArgumentException 异常，若没抛出，则测试失败
    @Test(expected = IllegalArgumentException.class)
    public void test() {
        mCalculator.divide(4, 0);
    }
}
```

### Junit 基本注解介绍

- `@BeforeClass` 在所有测试方法执行前执行一次，一般在其中写上整体初始化的代码。
- `@AfterClass` 在所有测试方法后执行一次，一般在其中写上销毁和释放资源的代码。



```java
// 注意这两个都是静态方法
@BeforeClass
public static void test(){
    
}
@AfterClass
public static void test(){
}
```

- `@Before` 在每个方法测试前执行，一般用来初始化方法（比如我们在测试别的方法时，类中与其他测试方法共享的值已经被改变，为了保证测试结果的有效性，我们会在@Before注解的方法中重置数据）
- `@After` 在每个测试方法执行后，在方法执行完成后要做的事情。
- `@Test(timeout = 1000)` 测试方法执行超过1000毫秒后算超时，测试将失败。
- `@Test(expected = Exception.class)` 测试方法期望得到的异常类，如果方法执行没有抛出指定的异常，则测试失败。
- `@Ignore("not ready yet")` 执行测试时将忽略掉此方法，如果用于修饰类，则忽略整个类。
- `@Test` 编写一般测试用例用。
- `@RunWith` 在 Junit 中有很多个 Runner，他们负责调用你的测试代码，每一个 Runner 都有各自的特殊功能，你根据需要选择不同的 Runner 来运行你的测试代码。

如果我们只是简单的做普通 Java 测试，不涉及 Spring Web 项目，你可以省略 `@RunWith` 注解，你要根据需要选择不同的 Runner 来运行你的测试代码。

### 测试方法执行顺序

按照设计，Junit不指定test方法的执行顺序。

- `@FixMethodOrder(MethodSorters.JVM)`:保留测试方法的执行顺序为JVM返回的顺序。每次测试的执行顺序有可能会所不同。
- `@FixMethodOrder(MethodSorters.NAME_ASCENDING`) :根据测试方法的方法名排序,按照词典排序规则(ASC,从小到大,递增)。

Failure 是测试失败，Error 是程序出错。

### 测试方法命名约定

Maven本身并不是一个单元测试框架，它只是在构建执行到特定生命周期阶段的时候，通过插件来执行JUnit或者TestNG的测试用例。这个插件就是maven-surefire-plugin，也可以称为测试运行器(Test Runner)，它能兼容JUnit 3、JUnit 4以及TestNG。

在默认情况下，maven-surefire-plugin的test目标会自动执行测试源码路径（默认为src/test/java/）下所有符合一组命名模式的测试类。这组模式为：

- **/Test*.java：任何子目录下所有命名以Test开关的Java类。
- **/*Test.java：任何子目录下所有命名以Test结尾的Java类。
- **/*TestCase.java：任何子目录下所有命名以TestCase结尾的Java类。

### 基于 Spring 的单元测试编写

首先我们项目一般都是 MVC 分层的，而单元测试主要是在 Dao 层和 Service 层上进行编写。从项目结构上来说，Service 层是依赖 Dao 层的，但是从单元测试角度，对某个 Service 进行单元的时候，他所有依赖的类都应该进行Mock。而 Dao 层单元测试就比较简单了，只依赖数据库中的数据。

### Mockito

Mockito是mocking框架，它让你用简洁的API做测试。而且Mockito简单易学，它可读性强和验证语法简洁。
Mockito 是一个针对 Java 的单元测试模拟框架，它与 EasyMock 和 jMock 很相似，都是为了简化单元测试过程中测试上下文 ( 或者称之为测试驱动函数以及桩函数 ) 的搭建而开发的工具

相对于 EasyMock 和 jMock，Mockito 的优点是通过在执行后校验哪些函数已经被调用，消除了对期望行为（expectations）的需要。其它的 mocking 库需要在执行前记录期望行为（expectations），而这导致了丑陋的初始化代码。

SpringBoot 中的 `pom.xml` 文件需要添加的依赖：



```xml
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
```

进入 `spring-boot-starter-test-2.1.3.RELEASE.pom` 可以看到该依赖中已经有单元测试所需的大部分依赖，如：

- junit
- mockito
- hamcrest

若为其他 spring 项目，需要自己添加 Junit 和 mockito 项目。

#### 常用的 Mockito 方法：

| **方法名**                                                   | **描述**                                  |
| ------------------------------------------------------------ | ----------------------------------------- |
| Mockito.mock(classToMock)                                    | 模拟对象                                  |
| Mockito.verify(mock)                                         | 验证行为是否发生                          |
| Mockito.when(methodCall).thenReturn(value1).thenReturn(value2) | 触发时第一次返回value1，第n次都返回value2 |
| Mockito.doThrow(toBeThrown).when(mock).[method]              | 模拟抛出异常。                            |
| Mockito.mock(classToMock,defaultAnswer)                      | 使用默认Answer模拟对象                    |
| Mockito.when(methodCall).thenReturn(value)                   | 参数匹配                                  |
| Mockito.doReturn(toBeReturned).when(mock).[method]           | 参数匹配（直接执行不判断）                |
| Mockito.when(methodCall).thenAnswer(answer))                 | 预期回调接口生成期望值                    |
| Mockito.doAnswer(answer).when(methodCall).[method]           | 预期回调接口生成期望值（直接执行不判断）  |
| Mockito.spy(Object)                                          | 用spy监控真实对象,设置真实对象行为        |
| Mockito.doNothing().when(mock).[method]                      | 不做任何返回                              |
| Mockito.doCallRealMethod().when(mock).[method] //等价于Mockito.when(mock.[method]).thenCallRealMethod(); | 调用真实的方法                            |
| reset(mock)                                                  | 重置mock                                  |

#### 示例：

- 验证行为是否发生



```java
//模拟创建一个List对象
List<Integer> mock =  Mockito.mock(List.class);
//调用mock对象的方法
mock.add(1);
mock.clear();
//验证方法是否执行
Mockito.verify(mock).add(1);
Mockito.verify(mock).clear();
```

- 多次触发返回不同值



```java
//mock一个Iterator类
Iterator iterator = mock(Iterator.class);
//预设当iterator调用next()时第一次返回hello，第n次都返回world
Mockito.when(iterator.next()).thenReturn("hello").thenReturn("world");
//使用mock的对象
String result = iterator.next() + " " + iterator.next() + " " + iterator.next();
//验证结果
Assert.assertEquals("hello world world",result);
```

- 模拟抛出异常



```java
@Test(expected = IOException.class)//期望报IO异常
public void when_thenThrow() throws IOException{
      OutputStream mock = Mockito.mock(OutputStream.class);
      //预设当流关闭时抛出异常
      Mockito.doThrow(new IOException()).when(mock).close();
      mock.close();
  }
```

- 使用默认Answer模拟对象

RETURNS_DEEP_STUBS 是创建mock对象时的备选参数之一
`以下方法deepstubsTest和deepstubsTest2是等价的`



```java
  @Test
  public void deepstubsTest(){
      A a=Mockito.mock(A.class,Mockito.RETURNS_DEEP_STUBS);
      Mockito.when(a.getB().getName()).thenReturn("Beijing");
      Assert.assertEquals("Beijing",a.getB().getName());
  }

  @Test
  public void deepstubsTest2(){
      A a=Mockito.mock(A.class);
      B b=Mockito.mock(B.class);
      Mockito.when(a.getB()).thenReturn(b);
      Mockito.when(b.getName()).thenReturn("Beijing");
      Assert.assertEquals("Beijing",a.getB().getName());
  }
  class A{
      private B b;
      public B getB(){
          return b;
      }
      public void setB(B b){
          this.b=b;
      }
  }
  class B{
      private String name;
      public String getName(){
          return name;
      }
      public void setName(String name){
          this.name = name;
      }
      public String getSex(Integer sex){
          if(sex==1){
              return "man";
          }else{
              return "woman";
          }
      }
  }
```

- 参数匹配



```java
@Test
public void with_arguments(){
    B b = Mockito.mock(B.class);
    //预设根据不同的参数返回不同的结果
    Mockito.when(b.getSex(1)).thenReturn("男");
    Mockito.when(b.getSex(2)).thenReturn("女");
    Assert.assertEquals("男", b.getSex(1));
    Assert.assertEquals("女", b.getSex(2));
    //对于没有预设的情况会返回默认值
    Assert.assertEquals(null, b.getSex(0));
}
class B{
    private String name;
    public String getName(){
        return name;
    }
    public void setName(String name){
        this.name = name;
    }
    public String getSex(Integer sex){
        if(sex==1){
            return "man";
        }else{
            return "woman";
        }
    }
}
```

- 匹配任意参数

`Mockito.anyInt()` 任何 int 值 ；
`Mockito.anyLong()` 任何 long 值 ；
`Mockito.anyString()` 任何 String 值 ；

`Mockito.any(XXX.class)` 任何 XXX 类型的值 等等。



```java
@Test
public void with_unspecified_arguments(){
    List list = Mockito.mock(List.class);
    //匹配任意参数
    Mockito.when(list.get(Mockito.anyInt())).thenReturn(1);
    Mockito.when(list.contains(Mockito.argThat(new IsValid()))).thenReturn(true);
    Assert.assertEquals(1,list.get(1));
    Assert.assertEquals(1,list.get(999));
    Assert.assertTrue(list.contains(1));
    Assert.assertTrue(!list.contains(3));
}
class IsValid extends ArgumentMatcher<List>{
    @Override
    public boolean matches(Object obj) {
        return obj.equals(1) || obj.equals(2);
    }
}
```

*注意：使用了参数匹配，那么所有的参数都必须通过matchers来匹配*
Mockito继承Matchers，anyInt()等均为Matchers方法
当传入两个参数，其中一个参数采用任意参数时，指定参数需要matchers来对比



```java
Comparator comparator = mock(Comparator.class);
comparator.compare("nihao","hello");
//如果你使用了参数匹配，那么所有的参数都必须通过matchers来匹配
Mockito.verify(comparator).compare(Mockito.anyString(),Mockito.eq("hello"));
//下面的为无效的参数匹配使用
//verify(comparator).compare(anyString(),"hello");
```

- 自定义参数匹配



```java
@Test
public void argumentMatchersTest(){
   //创建mock对象
   List<String> mock = mock(List.class);
   //argThat(Matches<T> matcher)方法用来应用自定义的规则，可以传入任何实现Matcher接口的实现类。
   Mockito.when(mock.addAll(Mockito.argThat(new IsListofTwoElements()))).thenReturn(true);
   Assert.assertTrue(mock.addAll(Arrays.asList("one","two","three")));
}

class IsListofTwoElements extends ArgumentMatcher<List>
{
   public boolean matches(Object list)
   {
       return((List)list).size()==3;
   }
}
```

- 预期回调接口生成期望值



```java
@Test
public void answerTest(){
      List mockList = Mockito.mock(List.class);
      //使用方法预期回调接口生成期望值（Answer结构）
      Mockito.when(mockList.get(Mockito.anyInt())).thenAnswer(new CustomAnswer());
      Assert.assertEquals("hello world:0",mockList.get(0));
      Assert.assertEquals("hello world:999",mockList.get(999));
  }
  private class CustomAnswer implements Answer<String> {
      @Override
      public String answer(InvocationOnMock invocation) throws Throwable {
          Object[] args = invocation.getArguments();
          return "hello world:"+args[0];
      }
  }
等价于：(也可使用匿名内部类实现)
@Test
 public void answer_with_callback(){
      //使用Answer来生成我们我们期望的返回
      Mockito.when(mockList.get(Mockito.anyInt())).thenAnswer(new Answer<Object>() {
          @Override
          public Object answer(InvocationOnMock invocation) throws Throwable {
              Object[] args = invocation.getArguments();
              return "hello world:"+args[0];
          }
      });
      Assert.assertEquals("hello world:0",mockList.get(0));
     Assert. assertEquals("hello world:999",mockList.get(999));
  }
```

- 预期回调接口生成期望值（直接执行）



```java
@Test
public void testAnswer1(){
List<String> mock = Mockito.mock(List.class);  
      Mockito.doAnswer(new CustomAnswer()).when(mock).get(Mockito.anyInt());  
      Assert.assertEquals("大于三", mock.get(4));
      Assert.assertEquals("小于三", mock.get(2));
}
public class CustomAnswer implements Answer<String> {  
  public String answer(InvocationOnMock invocation) throws Throwable {  
      Object[] args = invocation.getArguments();  
      Integer num = (Integer)args[0];  
      if( num>3 ){  
          return "大于三";  
      } else {  
          return "小于三";   
      }  
  }
}
```

- 修改对未预设的调用返回默认期望（指定返回值）



```java
//mock对象使用Answer来对未预设的调用返回默认期望值
List mock = Mockito.mock(List.class,new Answer() {
     @Override
     public Object answer(InvocationOnMock invocation) throws Throwable {
         return 999;
     }
 });
 //下面的get(1)没有预设，通常情况下会返回NULL，但是使用了Answer改变了默认期望值
 Assert.assertEquals(999, mock.get(1));
 //下面的size()没有预设，通常情况下会返回0，但是使用了Answer改变了默认期望值
 Assert.assertEquals(999,mock.size());
```

- 用spy监控真实对象,设置真实对象行为



```java
    @Test(expected = IndexOutOfBoundsException.class)
    public void spy_on_real_objects(){
        List list = new LinkedList();
        List spy = Mockito.spy(list);
        //下面预设的spy.get(0)会报错，因为会调用真实对象的get(0)，所以会抛出越界异常
        //Mockito.when(spy.get(0)).thenReturn(3);

        //使用doReturn-when可以避免when-thenReturn调用真实对象api
        Mockito.doReturn(999).when(spy).get(999);
        //预设size()期望值
        Mockito.when(spy.size()).thenReturn(100);
        //调用真实对象的api
        spy.add(1);
        spy.add(2);
        Assert.assertEquals(100,spy.size());
        Assert.assertEquals(1,spy.get(0));
        Assert.assertEquals(2,spy.get(1));
        Assert.assertEquals(999,spy.get(999));
    }
```

- 不做任何返回



```java
@Test
public void Test() {
    A a = Mockito.mock(A.class);
    //void 方法才能调用doNothing()
    Mockito.doNothing().when(a).setName(Mockito.anyString());
    a.setName("bb");
    Assert.assertEquals("bb",a.getName());
}
class A {
    private String name;
    private void setName(String name){
        this.name = name;
    }
    private String getName(){
        return name;
    }
}
```

- 调用真实的方法



```java
@Test
public void Test() {
    A a = Mockito.mock(A.class);
    //void 方法才能调用doNothing()
    Mockito.when(a.getName()).thenReturn("bb");
    Assert.assertEquals("bb",a.getName());
    //等价于Mockito.when(a.getName()).thenCallRealMethod();
    Mockito.doCallRealMethod().when(a).getName();
    Assert.assertEquals("zhangsan",a.getName());
}
class A {
    public String getName(){
        return "zhangsan";
    }
}
```

- 重置 mock



```java
    @Test
    public void reset_mock(){
        List list = mock(List.class);
        Mockito. when(list.size()).thenReturn(10);
        list.add(1);
        Assert.assertEquals(10,list.size());
        //重置mock，清除所有的互动和预设
        Mockito.reset(list);
        Assert.assertEquals(0,list.size());
    }
```

- `@Mock` 注解



```java
public class MockitoTest {
    @Mock
    private List mockList;
    //必须在基类中添加初始化mock的代码，否则报错mock的对象为NULL
    public MockitoTest(){
        MockitoAnnotations.initMocks(this);
    }
    @Test
    public void AnnoTest() {
            mockList.add(1);
        Mockito.verify(mockList).add(1);
    }
}
```

- 指定测试类使用运行器：MockitoJUnitRunner



```java
@RunWith(MockitoJUnitRunner.class)
public class MockitoTest2 {
    @Mock
    private List mockList;

    @Test
    public void shorthand(){
        mockList.add(1);
        Mockito.verify(mockList).add(1);
    }
}
```

### @MockBean

使用 `@MockBean` 可以解决单元测试中的一些依赖问题，示例如下：



```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class ServiceWithMockBeanTest {
    @MockBean
    SampleDependencyA dependencyA;
    @Autowired
    SampleService sampleService;

    @Test
    public void testDependency() {
        when(dependencyA.getExternalValue(anyString())).thenReturn("mock val: A");
        assertEquals("mock val: A", sampleService.foo());
    }
}
```

`@MockBean` 只能 mock 本地的代码——或者说是自己写的代码，对于储存在库中而且又是以 Bean 的形式装配到代码中的类无能为力。

`@SpyBean` 解决了 SpringBoot 的单元测试中 `@MockBean` 不能 mock 库中自动装配的 Bean 的局限（目前还没需求，有需要的自己查阅资料）。