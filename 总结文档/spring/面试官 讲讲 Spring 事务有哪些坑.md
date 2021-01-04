![img](https://mmbiz.qpic.cn/mmbiz_jpg/ow6przZuPIENb0m5iawutIf90N2Ub3dcPuP2KXHJvaR1Fv2FnicTuOy3KcHuIEJbd9lUyOibeXqW8tEhoJGL98qOw/640?wx_fmt=jpeg&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## **引言**



今天，我们来讲 Spring 中和事务有关的考题。


因为事务这块，面试的出现几率很高。而大家工作中 CRUD 的比较多，没有好好总结过这块的知识，因此面试容易支支吾吾答不出来。于是乎接下来你就会接到一张好人卡，如"你很优秀，不适合我们公司！"



主要内容如下：



- Spring 事务的原理；
- Spring 什么情况下进行事务回滚；
- Spring 事务什么时候失效；
- Spring 事务和数据库事务隔离是不是同一个概念；
- Spring 事务控制放在 Service 层，在 Service 方法中一个方法调用 Service 中的另一个方法，默认开启几个事务；
- 怎么保证 Spring 事务内的连接唯一性。



**1. Spring 事务的原理**



首先，我们先明白 Spring 事务的本质其实就是数据库对事务的支持。没有数据库的事务支持，Spring 是无法提供事务功能的。



那么，我们一般使用 JDBC 操作事务的代码如下：



1. 获取连接 Connection con = DriverManager.getConnection()；
2. 开启事务 con.setAutoCommit(true/false)；
3. 执行 CRUD；
4. 提交事务、回滚事务：con.commit() ，con.rollback()；
5. 关闭连接 conn.close()。



使用 Spring 事务管理后，我们可以省略步骤 2 和步骤 4，让 AOP 帮你去做这些工作，关键类在 TransactionAspectSupport 这个切面里。大家有兴趣自己去翻，我就不列举了。因为公众号类型的文章，实在不适合写一些源码解析！



**2. Spring 什么情况下进行事务回滚**



首先我们要明白， Spring 事务回滚机制是这样的：当所拦截的方法有指定异常抛出，事务才会自动进行回滚！



因此，如果你默默的吞掉异常，像下面这样：



- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
- 

```
@Servicepublic class UserService{    @Transactional    public void updateUser(User user) {        try {            System.out.println("孤独烟真帅");            //do something        } catch {          //do something        }    }}
```



那切面捕捉不到异常，肯定是不会回滚的。



还有就是，默认配置下，事务只会对 Error 与 RuntimeException 及其子类这些异常做出回滚。一般的 Exception 这些 Checked 异常不会发生回滚。如果一般的 Exception 想回滚，要做出如下配置：



- 

```
@Transactional(rollbackFor = Exception.class)
```



但是在实际开发中，我们会遇到这么一种情况：就是并没有异常发生，但是由于事务结果未满足具体业务需求，所以我们需要手动回滚事务。于是乎方法也很简单：



- 自己在代码里抛出一个自定义异常（常用）；
- 通过编程用代码回滚（不常用）。



- 
- 

```
TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
```



**3. Spring 事务什么时候失效**



**注意：这是一道经典题**。4年前我毕业那会在问，我都工作4年了，现在还问这道。其出现频率，不亚于 HashMap 的出现频率！



该问题有很多问法，例如 Spring 事务有哪些坑？你用 Spring 事务的时候，有遇到过什么问题么？其实答案都一样的。OK，不罗嗦了，开始答案！



我们知道 Spring 事务的原理是 AOP，进行了切面增强，那么失效的根本原因是这个 AOP 不起作用了。



常见情况有以下几种：



**3.1 发生自调用**



示例代码如下：



- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
- 

```
@Servicepublic class UserService{   public void update(User user) {        updateUser(user);    }
    @Transactional    public void updateUser(User user) {        System.out.println("孤独烟真帅");        //do something    }}
```



此时是无效的。因此上面的代码等同于：



- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
- 
- 

```
@Servicepublic class UserService{   public void update(User user) {        this.updateUser(user);    }
    @Transactional    public void updateUser(User user) {        System.out.println("孤独烟真帅");        //do something    }}
```



此时，这个 this 对象不是代理类，而是 UserService 对象本身。



解决方法很简单，让那个 this 变成 UserService 的代理类即可，就不展开说明了。



**3.2 方法修饰符不是 public**



OK，我这里不想举源码。大家想一个逻辑就行：



@Transactional 注解的方法都是被外部其他类调用才有效，那么如果方法修饰符是 private 的，这个方法能被外部其他类调到么？



既然调不到，事务生效有意义吗？想通这套逻辑就行了。



**记住**：@Transactional 注解只能应用到 public 方法上。如果你在 protected、private 或者 package-visible 的方法上使用 @Transactional 注解，它也不会报错， 但是这个被注解的方法将不会加入事务之行。



先这么理解就好了，因为真的去翻原因就要贴代码了，这文章可读性就很差了。



**3.3 发生了错误的异常**



这个问题在第二问讲过了，因为默认回滚的是：RuntimeException。如果是其他异常想要回滚，需要在 @Transactional 注解上加 rollbackFor 属性。



又或者是异常被吞了，事务也会失效，这里不再赘述。



**3.4 数据库不支持事务**



毕竟 Spring 事务用的是数据库的事务，如果数据库不支持事务，那 Spring 事务肯定是无法生效滴。



OK，答到这里就够了。



可能有的读者会说：



烟哥啊，其他文章里说什么数据源没有配置事务管理器也会导致事务失效，你怎么没提？



OK，我为什么不提，因为这种情况属于你配置的不对。随便少一个配置都会导致事务不生效，例如我们在 Spring Boot 中的 Application 类上不加@EnableTransactionManagement 注解也会使事务不生效，难道您能将每种情况下的配置背下来？这种配置的东西，用到的时候临时查询即可。



再比如，你把隔离级别配置成：



- 

```
@Transactional(propagation = Propagation.NOT_SUPPORTED)
```



该隔离级别表示不以事务运行，当前若存在事务则挂起，事务肯定不生效啊！这种属于自己配错的情况，如果真要举例，面试官也不爱听的！在面试中，一句"配置错误也会导致事务不生效，例如 xxx 配置，举一两个即可！"



**4. Spring 事务隔离和数据库事务隔离是不是一个概念**



OK，是一回事！



我们先明确一点，数据库一般有四种隔离级别，分别为：



- Read Uncommitted：未提交读；
- Read Committed：提交读、不可重复读；
- Repeatable Read：可重复读；
- Serializable：可串行化。



而 Spring 只是在此基础上抽象出一种隔离级别 default，表示以数据库默认配置的为主。例如，MySQL 默认的事务隔离级别为 Repeatable Read，而 Oracle 默认隔离级别为Read Committed。



于是乎，有一个经典问题是这么问的：



我数据库的配置隔离级别是Read Commited,而Spring配置的隔离级别是Repeatable Read，请问这时隔离级别是以哪一个为准？



答案是以 Spring 配置的为准。JDBC 有一个接口是这样的：



![img](https://mmbiz.qpic.cn/mmbiz_png/eZzl4LXykQxJSYOoEgsXDqS10GEMr4IegqV5anQny4IYGjKVskjtTYkxUc12ZbFdyKFicBf3kGicc3VibY1uYVnbw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



意思就是，如果 Spring 定义的隔离级别和数据库的不一样，则以 Spring 定义的为准。
另外，如果 Spring 设置的隔离级别数据库不支持，设置的效果取决于数据库。



**5. Spring 事务控制放在 Service 层，在 Service 方法中一个方法调用 Service 中的另一个方法，默认开启几个事务**



此题考查的是 Spring 的事务传播行为。



我们都知道，默认的传播行为是 PROPAGATION_REQUIRED。如果外层有事务，则当前事务加入到外层事务，一起提交并一起回滚；如果外层没有事务，新建一个事务执行。也就是说，**默认情况下只有一个事务**。



当然这种时候如果面试官继续追问其他传播行为的情形，该如何回答？



那我们应该把每种传播机制都拿出来讲一遍？没必要，这种时候直接掀桌子走人。因为你就算背下来了过几天还是会忘记，用到的时候再去查询即可。



**6. 怎么保证 Spring 事务内的连接唯一性**



这道题很多种问法，例如 Spring 是如何保证事务获取的是同一个 Connection?



OK，开始我们的讲解。其实答案只有一句话，因为那个 Connection 在事务开始时封装在了 ThreadLocal 里，后面事务执行过程中，都是从 ThreadLocal中 取的。肯定能保证唯一，因为都是在一个线程中执行。



至于代码，以J DBCTemplate的execute 方法为例，看看下面那张图就懂了。



![img](https://mmbiz.qpic.cn/mmbiz_png/eZzl4LXykQxJSYOoEgsXDqS10GEMr4IeXVEcQhFwGRjnDEqXNXwLFoNUjiajWjich4ia2yiaKFQjcHmSOEzjgHTLbA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



## **7. 总结**



本文探讨了 Spring 事务中常见面试题，希望大家有所收获。