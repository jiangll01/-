## [springboot 校验机制 @Validated @Valid](https://www.cnblogs.com/baizhuang/p/13695361.html)

## 一、探究原因

在开发的过程中一直迷惑 @Validated 与 @Valid 的用法，有时候是@Validated ，有时候是@Valid 。虽然能够实现校验，但是还是不够明确何时能够生效，不了解他生效的情况

首先定位2个注解所属的包：

@Validated 在 spring-context 包下属于spring 提供的核心包

![img](https://img2020.cnblogs.com/blog/1437966/202009/1437966-20200919103836239-1652139618.png)

@Valid 在 validation-api 包下 2.0.2 版本

![img](https://img2020.cnblogs.com/blog/1437966/202009/1437966-20200919104023515-1718996847.png)

@Validated 是spring 核心包，是每个项目都有的，那么 api 是如何引入的? 查看maven 依赖

![img](https://img2020.cnblogs.com/blog/1437966/202009/1437966-20200919104358197-1644441433.png)

 原来是在引入 Spring-boot-start-web 的时候，就引入了该依赖

两个注解存在不同的包，而@NotNull ,@Null ,@Size ，@Max 等校验注解是哪里的呢？

![img](https://img2020.cnblogs.com/blog/1437966/202009/1437966-20200919104604828-1276792807.png)

 这些注解都是在 api 包下

## 二、使用@Validated 实现校验机制

情景一： 查询参数是一个实体，Get 请求，在不添加任何注解的情况下，查询是正常的，实体参数字段都为null 

 现在需求 id 字段不能为空，在实体id 字段标记 @NotNull ,继续查询，发现注解没有生效

**经过测试，只有请求实体参数列表前加@Validated 才会生效，即使@Validated 加在类上也无法生效**

 

情景二： 查询参数是基本或者引用类型字段，参数列表中加入 @NutNull 修改该字段。发现无法生效

**经过测试：只有全局类上加@Validated 才会生效，即使参数列表中加入 @Validated 也无法生效**

 

产生异常也有所不同：在校验生效的情况下，实体类校验产生的异常是：BindException , 而参数列表产生的异常是: ConstraintViolationException

## 三、使用@Valid 实现校验机制

场景一：与上述一致，只有@Valid 作用在参数列表前才会生效

场景二：@Valida 不管是左右在参数列表还是类上，都无法生效。只能使用@Validated 全局设置

结论：暂不清楚@Valid 设计出现的原因，所以的校验@Validate 均可以实现

附加全局异常捕获：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
 1 @RestControllerAdvice
 2 public class GlobalException {
 3 
 4 
 5     @ExceptionHandler({BindException.class})
 6     public RespResult validationException(BindException exception){
 7         List<ObjectError> errors =  exception.getAllErrors();
 8         if(!CollectionUtils.isEmpty(errors)){
 9             StringBuilder sb = new StringBuilder();
10             errors.forEach(e->sb.append(e.getDefaultMessage()).append(","));
11             return new RespResult(400, sb.toString());
12         }
13         return new RespResult(500, exception.getLocalizedMessage());
14     }
15 
16     @ExceptionHandler({ConstraintViolationException.class})
17     public RespResult constraintViolationException(ConstraintViolationException exception){
18         Set<ConstraintViolation<?>> constraintViolations = exception.getConstraintViolations();
19         if(!CollectionUtils.isEmpty(constraintViolations)){
20             StringBuilder sb = new StringBuilder();
21             constraintViolations.forEach(e->sb.append(e.getMessage()).append(","));
22             return new RespResult(400, sb.toString());
23         }
24         return new RespResult(500, exception.getLocalizedMessage());
25     }
26 
27 }
```