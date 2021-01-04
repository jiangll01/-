# SpringBoot系列记录（十七）——SpringBoot事务Transaction 你真的懂了么？

![img](https://csdnimg.cn/release/blogv2/dist/pc/img/original.png)

[年少一梦I](https://me.csdn.net/QingXu1234) 2020-05-23 11:30:49 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/articleReadEyes.png) 764 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/tobarCollect.png) 收藏 5 ![img](https://csdnimg.cn/release/blogv2/dist/pc/img/planImg.png) 原力计划

文章标签： [事务](https://www.csdn.net/gather_26/MtTaEg0sNDI4ODUtYmxvZwO0O0OO0O0O.html) [springboot](https://www.csdn.net/gather_2c/MtTaEg0sMDg2NDYtYmxvZwO0O0OO0O0O.html) [spring](https://www.csdn.net/gather_22/MtTaEg0sMDg2NTAtYmxvZwO0O0OO0O0O.html)

版权

## 一、为什么要加事务

工作中我发现很多人其实是不用事务的，那这个肯定会存在隐藏风险。凡是和钱挂钩的项目一旦出现问题，后果就不堪设想了。

而普通项目中我们也需要确保数据的一致性等问题。你是否也觉得在方法上加上**@Transactional**不就可以了么，来看完这篇博文吧。

## 二、什么是事务

我在大学的《数据库原理》中也是学过的，后来毕业面试也遇到过。

**事务：是数据库操作的最小工作单元，是作为单个逻辑工作单元执行的一系列操作；这些操作作为一个整体一起向系统提交，要么都执行、要么都不执行；**

事务的四大特性：

1. 原子性 事务是数据库的逻辑工作单位，事务中包含的各操作要么都做，要么都不做 。
2. 一致性 事务执行的结果必须是使数据库从一个一致性状态变到另一个一致性状态。因此当数据库只包含成功事务提交的结果时，就说数据库处于一致性状态。如果数据库系统 运行中发生故障，有些事务尚未完成就被迫中断，这些未完成事务对数据库所做的修改有一部分已写入物理数据库，这时数据库就处于一种不正确的状态，或者说是 不一致的状态。 
3. 隔离性 一个事务的执行不能其它事务干扰。即一个事务内部的操作及使用的数据对其它并发事务是隔离的，并发执行的各个事务之间不能互相干扰。 
4. 持续性 也称永久性，指一个事务一旦提交，它对数据库中的数据的改变就应该是永久性的。接下来的其它操作或故障不应该对其执行结果有任何影响。 

而Spring框架提供了很好事务管理机制，主要分为**`编程式事务`**和**`声明式事务`**两种。

**编程式事务**：是指在代码中手动的管理事务的提交、回滚等操作，代码侵入性比较强，如下示例

```java
try {



    //TODO something



     transactionManager.commit(status);



} catch (Exception e) {



   er transactionManager.rollback(status);



    thrownew InvoiceApplyException("异常失败");



}
```

**声明式事务**：基于**`AOP`**面向切面的，它将具体业务与事务处理部分解耦，代码侵入性很低，所以在实际开发中声明式事务用的比较多。声明式事务也有两种实现方式，一是基于`TX`和`AOP`的xml配置文件方式，二种就是基于**`@Transactional`** 注解了。

```java
   @Transactional



    public int addStudent(Student student) {



        int result = studentMapper.addStudent(student);



        return result;



    }
```

## 三、@Transactional详解

**3.1 @Transactional注解可以作用于哪些地方？**

- **作用于类**：当把`**@Transactional** 注解放在类上时，表示所有该类的 `public 方法 都配置相同的事务属性信息。
- **作用于方法**：当类配置了**`@Transactional`**，方法也配置了**`@Transactional`**，方法的事务会 覆盖 类的事务配置信息。
- **作用于接口**：不推荐这种使用方法，因为一旦标注在Interface上并且配置了Spring AOP 使用CGLib动态代理，将会导致**`@Transactional`**注解失效

**3.2 @Transactional注解有哪些属性?**

下图可以看到相关的属性以及默认值

![img](https://img-blog.csdnimg.cn/20200522163941102.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FpbmdYdTEyMzQ=,size_16,color_FFFFFF,t_70)

按顺序来说：

**事务传播行为 propagation** 默认值为 **`Propagation.REQUIRED`**

- **`Propagation.REQUIRED`**：如果当前存在事务，则加入该事务，**如果当前不存在事务，则创建一个新的事务**。**(** 也就是说如果A方法和B方法都添加了注解，在默认传播模式下，A方法内部调用B方法，会把两个方法的事务合并为一个事务 **）**
- **`Propagation.SUPPORTS`**：如果当前存在事务，则加入该事务；如果当前不存在事务，则以非事务的方式继续运行。
- **`Propagation.MANDATORY`**：如果当前存在事务，则加入该事务；如果当前不存在事务，则抛出异常。
- **`Propagation.REQUIRES_NEW`**：重新创建一个新的事务，如果当前存在事务，暂停当前的事务。**(** 当类A中的 a 方法用默认`Propagation.REQUIRED`模式，类B中的 b方法加上采用 `Propagation.REQUIRES_NEW`模式，然后在 a 方法中调用 b方法操作数据库，然而 a方法抛出异常后，b方法并没有进行回滚，因为`Propagation.REQUIRES_NEW`会暂停 a方法的事务 **)**
- **`Propagation.NOT_SUPPORTED`**：以非事务的方式运行，如果当前存在事务，暂停当前的事务。
- **`Propagation.NEVER`**：以非事务的方式运行，如果当前存在事务，则抛出异常。
- **`Propagation.NESTED`** ：和 Propagation.REQUIRED 效果一样。

**事务隔离级别isolation 默认值为 \**`Isolation.DEFAULT`\****

- **TransactionDefinition.ISOLATION_DEFAULT:** 使用后端数据库默认的隔离级别，Mysql 默认采用的 **REPEATABLE_READ**隔离级别 Oracle 默认采用的 READ_COMMITTED隔离级别.
- **TransactionDefinition.ISOLATION_READ_UNCOMMITTED:** 最低的隔离级别，允许读取尚未提交的数据变更，**可能会导致脏读、幻读或不可重复读**
- **TransactionDefinition.ISOLATION_READ_COMMITTED:** 允许读取并发事务已经提交的数据，**可以阻止脏读，但是幻读或不可重复读仍有可能发生**
- **TransactionDefinition.ISOLATION_REPEATABLE_READ:** 对同一字段的多次读取结果都是一致的，除非数据是被本身事务自己所修改，**可以阻止脏读和不可重复读，但幻读仍有可能发生。**
- **TransactionDefinition.ISOLATION_SERIALIZABLE:** 最高的隔离级别，完全服从ACID的隔离级别。所有的事务依次逐个执行，这样事务之间就完全不可能产生干扰，也就是说，**该级别可以防止脏读、不可重复读以及幻读**。但是这将严重影响程序的性能。通常情况下也不会用到该级别

**timeout 事务的超时时间，默认值为 -1。如果超过该时间限制但事务还没有完成，则自动回滚事务。**

**readOnly 指定事务是否为只读事务，默认值为 false；为了忽略那些不需要事务的方法，比如读取数据，可以设置 read-only 为 true。**

**rollbackFor 用于指定能够触发事务回滚的异常类型，可以指定多个异常类型。**

**noRollbackFor 抛出指定的异常类型，不回滚事务，也可以指定多个异常类型。**

## 四、举例

在service中写一个除零异常的方法，和一个添加数据的方法，但是不加事务注解

```java
    @Override



    public int addStudent(Student student) {



        int result = studentMapper.addStudent(student);



        test();



        return result;



    }



 



    @Override



    public int test() {



        int a = 10/0;



        return a;



    }
```

结果就是报了异常，但是数据还是插入表中了

![img](https://img-blog.csdnimg.cn/20200522165342750.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1FpbmdYdTEyMzQ=,size_16,color_FFFFFF,t_70)

**加上@Transactional注解之后，会进行回滚**

## **五、@Transactional失效场景**

这也是面试喜欢问的点

**5.1 @Transactional 应用在非 public 修饰的方法上**

如果`Transactional`注解应用在非`public` 修饰的方法上，Transactional将会失效。之所以会失效是因为在Spring AOP 代理时，如上图所示 `TransactionInterceptor` （事务拦截器）在目标方法执行前后进行拦截，`DynamicAdvisedInterceptor`（CglibAopProxy 的内部类）的 intercept 方法或 `JdkDynamicAopProxy` 的 invoke 方法会间接调用 `AbstractFallbackTransactionAttributeSource`的 `computeTransactionAttribute` 方法，获取Transactional 注解的事务配置信息。 看一下源码：**很明显它会检查目标方法的修饰符是否为 public，不是 public则不会获取`@Transactional` 的属性配置信息**。

```java
protected TransactionAttribute computeTransactionAttribute(Method method,



    Class<?> targetClass) {



        // Don't allow no-public methods as required.



        if (allowPublicMethodsOnly() && !Modifier.isPublic(method.getModifiers())) {



        return null;



}
```

**5.2 @Transactional  注解属性 rollbackFor 设置错误**

**`rollbackFor`** 可以指定**能够触发事务回滚**的异常类型。Spring**默认**抛出了未检查**`unchecked`**异常（**继承自** **`RuntimeException`** 的异常）或者 `Error`才回滚事务；其他异常不会触发回滚事务。**如果在事务中抛出其他类型的异常，但却期望 Spring 能够回滚事务，就需要指定 rollbackFor 属性，如果未指定 rollbackFor 属性则事务不会回滚。**

```
//自定义异常回滚



@Transactional(propagation= Propagation.REQUIRED,rollbackFor= CustomException.class)
```

**5.3 同一个类中方法调用，导致 @Transactional 失效**

开发中避免不了会对同一个类里面的方法调用，比如有一个类Test，它的一个方法A，A再调用本类的方法B（不论方法B是用public还是private修饰），但方法A没有声明注解事务，而B方法有。则**外部调用方法A**之后，方法B的事务是不会起作用的。这也是经常犯错误的一个地方。那为啥会出现这种情况？其实这还是由于使用 `Spring AOP `代理造成的，因为 **只有当事务方法被 当前类以外的代码 调用时，才会由`Spring`生成的代理对象来管理。**

**5.4 异常被catch,导致@Transactional失效**

`spring`的事务是在调用业务方法之前开始的，业务方法执行完毕之后才执行`commit` or `rollback`，事务是否执行取决于是否抛出`runtime异常`。**如果抛出`runtime exception` 并在你的业务方法中没有catch到的话，事务会回滚**。在业务方法中一般不需要catch异常，如果**非要catch一定要抛出`throw new RuntimeException()`**，或者注解中指定抛异常类型**`@Transactional(rollbackFor=Exception.class)`**，否则会导致事务失效，数据commit造成数据不一致