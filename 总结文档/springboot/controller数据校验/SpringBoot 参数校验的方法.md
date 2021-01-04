## Introduction

有参数传递的地方都少不了参数校验。在web开发中，前端的参数校验是为了用户体验，后端的参数校验是为了安全。试想一下，如果在controller层中没有经过任何校验的参数通过service层、dao层一路来到了数据库就可能导致严重的后果，最好的结果是查不出数据，严重一点就是报错，如果这些没有被校验的参数中包含了恶意代码，那就可能导致更严重的后果。

这里我们主要介绍在springboot中的几种参数校验方式。常用的用于参数校验的注解如下：

- @AssertFalse 所注解的元素必须是Boolean类型，且值为false
- @AssertTrue 所注解的元素必须是Boolean类型，且值为true
- @DecimalMax 所注解的元素必须是数字，且值小于等于给定的值
- @DecimalMin 所注解的元素必须是数字，且值大于等于给定的值
- @Digits 所注解的元素必须是数字，且值必须是指定的位数
- @Future 所注解的元素必须是将来某个日期
- @Max 所注解的元素必须是数字，且值小于等于给定的值
- @Min 所注解的元素必须是数字，且值小于等于给定的值
- @Range 所注解的元素需在指定范围区间内
- @NotNull 所注解的元素值不能为null
- @NotBlank 所注解的元素值有内容
- @Null 所注解的元素值为null
- @Past 所注解的元素必须是某个过去的日期
- @PastOrPresent 所注解的元素必须是过去某个或现在日期
- @Pattern 所注解的元素必须满足给定的正则表达式
- @Size 所注解的元素必须是String、集合或数组，且长度大小需保证在给定范围之内
- @Email 所注解的元素需满足Email格式

## controller层参数校验

在controller层的参数校验可以分为两种场景：

1. 单个参数校验
2. 实体类参数校验

## 单个参数校验

```java
@RestController
@Validated
public class PingController {

    @GetMapping("/getUser")
    public String getUserStr(@NotNull(message = "name 不能为空") String name,
                             @Max(value = 99, message = "不能大于99岁") Integer age) {
        return "name: " + name + " ,age:" + age;
    }
}
```

当处理`GET`请求时或只传入少量参数的时候，我们可能不会建一个bean来接收这些参数，就可以像上面这样直接在`controller`方法的参数中进行校验。

> 注意：这里一定要在方法所在的controller类上加入`@Validated`注解，不然没有任何效果。

这时候在`postman`输入请求：

```
http://localhost:8080/getUser?name=Allan&age=101
```

调用方会收到springboot默认的格式报错：

```json
{
    "timestamp": "2019-06-01T04:30:26.882+0000",
    "status": 500,
    "error": "Internal Server Error",
    "message": "getUserStr.age: 不能大于99岁",
    "path": "/getUser"
}
```

后台会打印如下错误：

```java
javax.validation.ConstraintViolationException: getUserStr.age: 不能大于99岁
   at org.springframework.validation.beanvalidation.MethodValidationInterceptor.invoke(MethodValidationInterceptor.java:116)
   at org.springframework.aop.framework.ReflectiveMethodInvocation.proceed(ReflectiveMethodInvocation.java:185)
   at org.springframework.aop.framework.CglibAopProxy$DynamicAdvisedInterceptor.intercept(CglibAopProxy.java:688)
   at io.shopee.bigdata.penalty.server.controller.PingController$$EnhancerBySpringCGLIB$$232cfd51.getUserStr(<generated>)
   ...
```

如果有很多使用这种参数验证的controller方法，我们希望在一个地方对`ConstraintViolationException`异常进行统一处理，可以使用**统一异常捕获**，这需要借助`@ControllerAdvice`注解来实现，当然在springboot中我们就用`@RestControllerAdvice`（内部包含@ControllerAdvice和@ResponseBody的特性）

```java
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import javax.validation.ValidationException;
import java.util.Set;

/**
 * @author pengchengbai
 * @date 2019-06-01 14:09
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ValidationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String handle(ValidationException exception) {
        if(exception instanceof ConstraintViolationException){
            ConstraintViolationException exs = (ConstraintViolationException) exception;

            Set<ConstraintViolation<?>> violations = exs.getConstraintViolations();
            for (ConstraintViolation<?> item : violations) {
                //打印验证不通过的信息
                System.out.println(item.getMessage());
            }
        }
        return "bad request" ;
    }
}
```

当参数校验异常的时候，该统一异常处理类在控制台打印信息的同时把*bad request*的字符串和`HttpStatus.BAD_REQUEST`所表示的状态码`400`返回给调用方（用`@ResponseBody`注解实现，表示该方法的返回结果直接写入HTTP response body 中）。其中：

- `@ControllerAdvice`：控制器增强，使@ExceptionHandler、@InitBinder、@ModelAttribute注解的方法应用到所有的 @RequestMapping注解的方法。
- `@ExceptionHandler`：异常处理器，此注解的作用是当出现其定义的异常时进行处理的方法，此例中处理`ValidationException`异常。

## 实体类参数校验

当处理post请求或者请求参数较多的时候我们一般会选择使用一个bean来接收参数，然后在每个需要校验的属性上使用参数校验注解：

```java
@Data
public class UserInfo {
    @NotNull(message = "username cannot be null")
    private String name;

    @NotNull(message = "sex cannot be null")
    private String sex;

    @Max(value = 99L)
    private Integer age;
}
```

然后在controller方法中用`@RequestBody`表示这个参数接收的类：

```java
@RestController
public class PingController {
    @Autowired
    private Validator validator;

    @GetMapping("metrics/ping")
    public Response<String> ping() {
        return new Response<>(ResponseCode.SUCCESS, null,"pang");
    }

    @PostMapping("/getUser")
    public String getUserStr(@RequestBody @Validated({GroupA.class, Default.class}) UserInfo user, BindingResult bindingResult) {
        validData(bindingResult);

        return "name: " + user.getName() + ", age:" + user.getAge();
    }

    private void validData(BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            StringBuffer sb = new StringBuffer();
            for (ObjectError error : bindingResult.getAllErrors()) {
                sb.append(error.getDefaultMessage());
            }
            throw new ValidationException(sb.toString());
        }
    }
}
```

需要注意的是，如果想让`UserInfo`中的参数注解生效，还必须在Controller参数中使用`@Validated`注解。这种参数校验方式的校验结果会被放到`BindingResult`中，我们这里写了一个统一的方法来处理这些结果，通过抛出异常的方式得到`GlobalExceptionHandler`的统一处理。

### 校验模式

在上面的例子中，我们使用`BindingResult`验证不通过的结果集合，但是通常按顺序验证到第一个字段不符合验证要求时，就可以直接拒绝请求了。这就涉及到两种**校验模式**的配置：

1. 普通模式（默认是这个模式）: 会校验完所有的属性，然后返回所有的验证失败信息
2. 快速失败模式: 只要有一个验证失败，则返回
   如果想要配置第二种模式，需要添加如下配置类：

```java
import org.hibernate.validator.HibernateValidator;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import javax.validation.Validation;
import javax.validation.Validator;
import javax.validation.ValidatorFactory;

@Configuration
public class ValidatorConf {
    @Bean
    public Validator validator() {
        ValidatorFactory validatorFactory = Validation.byProvider( HibernateValidator.class )
                .configure()
                .failFast( true )
                .buildValidatorFactory();
        Validator validator = validatorFactory.getValidator();

        return validator;
    }
}
```

### 参数校验分组

在实际开发中经常会遇到这种情况：想要用一个实体类去接收多个controller的参数，但是不同controller所需要的参数又有些许不同，而你又不想为这点不同去建个新的类接收参数。比如有一个`/setUser`接口不需要`id`参数，而`/getUser`接口又需要该参数，这种时候就可以使用**参数分组**来实现。

1. 定义表示组别的`interface`；

```java
public interface GroupA {
}
```

1. 在`@Validated`中指定使用哪个组；

```java
@RestController
public class PingController {
    @PostMapping("/getUser")
    public String getUserStr(@RequestBody @Validated({GroupA.class, Default.class}) UserInfo user, BindingResult bindingResult) {
        validData(bindingResult);
        return "name: " + user.getName() + ", age:" + user.getAge();
    }

    @PostMapping("/setUser")
    public String setUser(@RequestBody @Validated UserInfo user, BindingResult bindingResult) {
        validData(bindingResult);
        return "name: " + user.getName() + ", age:" + user.getAge();
    }
```

其中`Default`为`javax.validation.groups`中的类，表示参数类中其他没有分组的参数，如果没有，`/getUser`接口的参数校验就只会有标记了`GroupA`的参数校验生效。

1. 在实体类的注解中标记这个哪个组所使用的参数；

```java
@Data
public class UserInfo {
    @NotNull( groups = {GroupA.class}, message = "id cannot be null")
    private Integer id;

    @NotNull(message = "username cannot be null")
    private String name;

    @NotNull(message = "sex cannot be null")
    private String sex;

    @Max(value = 99L)
    private Integer age;
}
```

### 级联参数校验

当参数bean中的属性又是一个复杂数据类型或者是一个集合的时候，如果需要对其进行进一步的校验需要考虑哪些情况呢？

```java
@Data
public class UserInfo {
    @NotNull( groups = {GroupA.class}, message = "id cannot be null")
    private Integer id;

    @NotNull(message = "username cannot be null")
    private String name;

    @NotNull(message = "sex cannot be null")
    private String sex;

    @Max(value = 99L)
    private Integer age;
   
    @NotEmpty
    private List<Parent> parents;
}
```

比如对于`parents`参数，`@NotEmpty`只能保证list不为空，但是list中的元素是否为空、User对象中的属性是否合格，还需要进一步的校验。这个时候我们可以这样写:

```java
    @NotEmpty
    private List<@NotNull @Valid UserInfo> parents;
```

然后再继续在`UserInfo`类中使用注解对每个参数进行校验。

但是我们再回过头来看看，在controller中对实体类进行校验的时候使用的`@Validated`，在这里只能使用`@Valid`，否则会报错。关于这两个注解的具体区别可以参考[@Valid 和@Validated的关系](https://blog.csdn.net/gaojp008/article/details/80583301)，但是在这里我想说的是使用`@Valid`就没办法对`UserInfo`进行分组校验。这种时候我们就会想，如果能够定义自己的validator就好了，最好能支持分组，像函数一样调用对目标参数进行校验，就像下面的`validObject`方法一样：

```java
import javax.validation.Validator;

@RestController
public class PingController {
    @Autowired
    private Validator validator;

    @PostMapping("/setUser")
    public String setUser(@RequestBody @Validated UserInfo user, BindingResult bindingResult) {
        validData(bindingResult);
        Parent parent = user.getParent();
        validObject(parent, validator, GroupB.class, Default.class);
        return "name: " + user.getName() + ", age:" + user.getAge();
    }

    private void validData(BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            StringBuffer sb = new StringBuffer();
            for (ObjectError error : bindingResult.getAllErrors()) {
                sb.append(error.getDefaultMessage());
            }
            throw new ValidationException(sb.toString());
        }
    }

    /**
     * 实体类参数有效性验证
     * @param bean 验证的实体对象
     * @param groups 验证组
     * @return 验证成功：返回true；验证失败：将错误信息添加到message中
     */
    public void validObject(Object bean, Validator validator, Class<?> ...groups) {
        Set<ConstraintViolation<Object>> constraintViolationSet = validator.validate(bean, groups);
        if (!constraintViolationSet.isEmpty()) {
            StringBuilder sb = new StringBuilder();
            for (ConstraintViolation violation: constraintViolationSet) {
                sb.append(violation.getMessage());
            }

            throw new ValidationException(sb.toString());
        }
    }
}


@Data
public class Parent {
    @NotEmpty(message = "parent name cannot be empty", groups = {GroupB.class})
    private String name;

    @Email(message = "should be email format")
    private String email;
}
```

### 自定义参数校验

虽然JSR303和Hibernate Validtor 已经提供了很多校验注解，但是当面对复杂参数校验时，还是不能满足我们的要求，这时候我们就需要自定义校验注解。这里我们再回到上面的例子介绍一下自定义参数校验的步骤。`private List<@NotNull @Valid UserInfo> parents`这种在容器中进行参数校验是`Bean Validation2.0`的新特性，假如没有这个特性，我们来试着自定义一个**List数组中不能含有null元素**的注解。这个过程大概可以分为两步：

1. 自定义一个用于参数校验的注解，并为该注解指定校验规则的实现类
2. 实现校验规则的实现类

#### 自定义注解

定义`@ListNotHasNull`注解， 用于校验 List 集合中是否有null 元素

```java
@Target({ElementType.ANNOTATION_TYPE, ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Documented
//此处指定了注解的实现类为ListNotHasNullValidatorImpl
@Constraint(validatedBy = ListNotHasNullValidatorImpl.class)
public @interface ListNotHasNull {

    /**
     * 添加value属性，可以作为校验时的条件,若不需要，可去掉此处定义
     */
    int value() default 0;

    String message() default "List集合中不能含有null元素";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    /**
     * 定义List，为了让Bean的一个属性上可以添加多套规则
     */
    @Target({METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER})
    @Retention(RUNTIME)
    @Documented
    @interface List {
        ListNotHasNull[] value();
    }
}
```

> 注意：message、groups、payload属性都需要定义在参数校验注解中不能缺省

#### 注解实现类

该类需要实现`ConstraintValidator`

```java
import org.springframework.stereotype.Service;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.List;

public class ListNotHasNullValidatorImpl implements ConstraintValidator<ListNotHasNull, List> {

    private int value;

    @Override
    public void initialize(ListNotHasNull constraintAnnotation) {
        //传入value 值，可以在校验中使用
        this.value = constraintAnnotation.value();
    }

    public boolean isValid(List list, ConstraintValidatorContext constraintValidatorContext) {
        for (Object object : list) {
            if (object == null) {
                //如果List集合中含有Null元素，校验失败
                return false;
            }
        }
        return true;
    }
}
```

然后我们就能在之前的例子中使用该注解了：

```java
@NotEmpty
@ListNotHasNull
private List<@Valid UserInfo> parents;
```

# 其他

## Difference Between @NotNull, @NotEmpty, and @NotBlank

### @NotNull

不能为`null`，但是可以为空字符串`""`

### @NotEmpty

不能为`null`，不能为空字符串`""`，其本质是CharSequence, Collection, Map, or Array的size或者length不能为0

### @NotBlank

a constrained String is valid as long as it’s not null and the trimmed length is greater than zero

## @NonNull

@NotNull 是 JSR303（Bean的校验框架）的注解，用于运行时检查一个属性是否为空，如果为空则不合法。
@NonNull 是JSR 305（缺陷检查框架）的注解，是告诉编译器这个域不可能为空，当代码检查有空值时会给出一个风险警告，目前这个注解只有IDEA支持。

## @Valid 注解和描述