在开发SpringBoot项目的时候，验证的使用是必不可少的。代码中我们不使用框架，也能实现对某个对象逐个字段进行验证，但很多重复的验证判断使得开发并不那么高效。如何能够高效的验证，项目中我们使用SpringBoot框架提供的Valid和Validated来实现验证，大大的提高了验证的开发效率。

 

# 项目实战

SpringBoot框架中已经内置了Valid和Validated所在的包，所以不用引入外部包。

示例中我们主要定义了一个用户类UserModel和一个地址类AddressModel，类的代码如下，用到了validator内置的校验注解、@Valid嵌套校验注解以及@Validated的group分组校验，文章后面会做详细的描述：

```
public class UserModel {



 



    @NotNull(message = "用户ID不能退为空", groups = ValidationGroups.UpdateEntityValidate.class)



    private Long id;



 



    @NotEmpty(message = "用户名不能为空")



    private String userName;



 



    @NotEmpty(message = "邮箱不能为空")



    @Email(message = "邮箱格式未通过验证")



    private String email;



 



    @NotEmpty(message = "手机号不能为空")



    @Pattern(regexp = "1[3|4|5|6|7|8|9][0-9]{9}", message = "手机号未通过验证")



    private String phoneNumber;



 



    @NotEmpty(message = "密码不能为空", groups = ValidationGroups.AddEntityValidate.class)



    @Size(min = 6, message = "密码最少需要6位", groups = ValidationGroups.AddEntityValidate.class)



    private String password;



 



    private String realName;



 



    private String nickName;



 



    private String avatar;



 



    @Valid



    @NotNull(message = "地址信息不能为空")



    private AddressModel address;



 



    // getter setter ...



}
public class AddressModel {



 



    @NotNull(message = "地址ID不能退为空", groups = ValidationGroups.UpdateEntityValidate.class)



    private Long id;



 



    @NotEmpty(message = "姓名不能为空")



    private String name;



 



    @NotEmpty(message = "省市不能为空")



    private String province;



 



    @NotEmpty(message = "市区不能为空")



    private String city;



 



    @NotEmpty(message = "详细地址不能为空")



    private String address;



 



    @NotEmpty(message = "手机号不能为空")



    @Pattern(regexp = "1[3|4|5|6|7|8|9][0-9]{9}", message = "手机号未通过验证")



    private String phoneNumber;



 



    // getter setter...



 



}
```

示例中我们主要定义了在控制器UserController中对各接口方法的参数和对象进行验证，文章后面会做详细的描述：

```
@RestController



@RequestMapping("user")



@Validated



public class UserController {



 



    @Resource



    private UserService userService;



 



 



    @Autowired



    private Validator validator;



 



 



    @GetMapping



    @ApiOperation("获取用户列表")



    @PreAuthorize("permitAll()")



    public ApiResult<List<User>> list(@Validated UserModel userModel) {



        //TODO 业务逻辑



 



        return ApiResult.success();



    }



 



    @GetMapping("check")



    @ApiOperation("检查用户")



    @PreAuthorize("permitAll()")



    public ApiResult<Boolean> check(@Valid UserModel model) {



        //TODO 业务逻辑



 



        return ApiResult.success(true);



    }



 



    @GetMapping("phoneNumber")



    @ApiOperation("获取用户信息")



    @PreAuthorize("permitAll()")



    public ApiResult<User> getByEmail(@Pattern(regexp = "1[3|4|5|6|7|8|9][0-9]{9}", message = "手机号未通过验证") @RequestParam String phoneNumber) {



        //TODO 业务逻辑



 



        return ApiResult.success();



    }



 



    @PostMapping



    @ApiOperation("添加用户")



    @PreAuthorize("permitAll()")



    public ApiResult<Boolean> add(@Validated(ValidationGroups.AddEntityValidate.class) @RequestBody UserModel model) {



        //TODO 业务逻辑



 



        return ApiResult.success(true);



    }



 



    @PutMapping



    @ApiOperation("更新用户")



    @PreAuthorize("permitAll()")



    public ApiResult<Boolean> update(@Validated(ValidationGroups.UpdateEntityValidate.class) @RequestBody UserModel model) {



        //TODO 业务逻辑



 



        return ApiResult.success(true);



    }



 



    @PostMapping("list")



    @ApiOperation("批量添加用户")



    @PreAuthorize("permitAll()")



    public ApiResult<Boolean> addBatch(@Valid @Size(min = 1, message = "用户信息未传递") @RequestBody List<UserModel> list) {



        //TODO 业务逻辑



 



        return ApiResult.success(true);



    }



 



    @PutMapping("list")



    @ApiOperation("批量修改用户")



    @PreAuthorize("permitAll()")



    public ApiResult<Boolean> updateBatch(@Size(min = 1, message = "用户信息未传递") @RequestBody List<UserModel> list) {



 



        for (UserModel item : list) {



            Set<ConstraintViolation<UserModel>> violations = validator.validate(item, ValidationGroups.UpdateEntityValidate.class);



            if (violations.size() > 0) {



                Map<String, String> errorMap = new HashMap<>();



 



                for (ConstraintViolation<UserModel> violation : violations) {



                    errorMap.put(violation.getPropertyPath().toString(), violation.getMessage());



                }



                ApiResult apiResult = ApiResult.failed("参数未通过验证");



                apiResult.setData(errorMap);



                return apiResult;



            }



        }



 



        //TODO 业务逻辑



 



        return ApiResult.success(true);



    }



}
```

示例中我们需要自定义分组验证的类或接口ValidationGroups，定义如下：

```
public class ValidationGroups {



 



    public interface BaseEntityValidate extends Default {}



 



    public interface AddEntityValidate extends BaseEntityValidate {}



 



    public interface UpdateEntityValidate extends BaseEntityValidate {}



}
```

*注意这个地方最好继承自Default (javax.validation.groups.Default)，这样我们在调用验证的时候才会验证未设置校验注解groups设置的字段。*

示例中使用的统一返回类ApiResult：

```
public class ApiResult<T> {



 



    private int code;



 



    private String message;



 



    private boolean success;



 



    private T data;



 



    private ApiResult() {



    }



 



    private ApiResult(int code, String message, boolean success, T data) {



        this.code = code;



        this.message = message;



        this.success = success;



        this.data = data;



    }



 



    public static ApiResult success() {



        ApiResult result = new ApiResult(0, null, true, null);



        return result;



    }



 



    public static <T> ApiResult success(T data) {



        ApiResult result = new ApiResult(0, null, true, data);



        return result;



    }



 



    public static ApiResult failed(String message) {



        ApiResult result = new ApiResult(400, message, false, null);



        return result;



    }



 



    public static <T> ApiResult failed(T data) {



        ApiResult result = new ApiResult(400, null, false, data);



        return result;



    }



 



    // getter setter...



}
```

 

## 常规验证

项目中最常用的校验方式，在类中需要验证的字段上使用validator内置的校验注解即可，常用的validator内置的校验注解见文章最后一节。在用户类UserModel和地址类AddressModel中我们大量用到了这些校验注解，用户类UserModel中部分样例：

```
    @NotNull(message = "用户ID不能退为空")



    private Long id;



 



    @NotEmpty(message = "用户名不能为空")



    private String userName;



 



    @NotEmpty(message = "手机号不能为空")



    @Pattern(regexp = "1[3|4|5|6|7|8|9][0-9]{9}", message = "手机号未通过验证")



    private String phoneNumber;
```

## 嵌套验证

在一个类中如果需要验证属性类对象中的字段，那么我们需要在该字段上面使用@Valid校验注解，在用户类UserModel中我们在地址属性字段上使用了@Valid注解来验证地址类中的字段：

```
    @Valid



    @NotNull(message = "地址信息不能为空")



    private AddressModel address;
```

## 分组验证

项目中我们会遇到这样的场景，新增和更新某个对象时，要求某些字段区别验证。比如新增用户时不需要传递用户ID并且需要密码必填，而更新用户时需要传递用户ID不需要传递密码。这时我们就可以使用Validated的groups分组验证来实现。用户类UserModel中在内置的校验注解中增加groups指定分类验证的类型，如下所示：

```
    @NotNull(message = "用户ID不能退为空", groups = ValidationGroups.UpdateEntityValidate.class)



    private Long id;



 



    @NotEmpty(message = "密码不能为空", groups = ValidationGroups.AddEntityValidate.class)



    @Size(min = 6, message = "密码最少需要6位", groups = ValidationGroups.AddEntityValidate.class)



    private String password;
```

 

## 验证生效

### 常规生效方式（含内嵌对象验证）

项目中我们要让类中定义了校验注解的字段验证生效，一般情况下在控制器中的方法上直接使用@Valid或@Validated可以直接验证生效。如示例中UserController中list和check方法，使用@Valid和@Validated都可以对UserModel对象参数进行验证：

```
    @GetMapping



    @ApiOperation("获取用户列表")



    @PreAuthorize("permitAll()")



    public ApiResult<List<User>> list(@Validated UserModel userModel) {



        //TODO 业务逻辑



 



        return ApiResult.success();



    }



 



    @GetMapping("check")



    @ApiOperation("检查用户")



    @PreAuthorize("permitAll()")



    public ApiResult<Boolean> check(@Valid UserModel model) {



        //TODO 业务逻辑



 



        return ApiResult.success(true);



    }
```

list和check方法的参数验证会验证我们定义的validator的校验注解字段和@Valid注解的嵌套字段。但是不会验证validator的校验注解中带groups的字段。

### 分组生效

要让我们定义的分组校验生效，在需要验证的方法中使用@Validated(Class)。如示例中UserController中add和update方法，使用@Validated(Class)可以对UserModel对象参数进行分组验证（*我们自定义的分组接口是继承自Default的，所以会验证注解中没有定义groups的字段*）：

```
    @PostMapping



    @ApiOperation("添加用户")



    @PreAuthorize("permitAll()")



    public ApiResult<Boolean> add(@Validated(ValidationGroups.AddEntityValidate.class) @RequestBody UserModel model) {



        //TODO 业务逻辑



 



        return ApiResult.success(true);



    }



 



    @PutMapping



    @ApiOperation("更新用户")



    @PreAuthorize("permitAll()")



    public ApiResult<Boolean> update(@Validated(ValidationGroups.UpdateEntityValidate.class) @RequestBody UserModel model) {



        //TODO 业务逻辑



 



        return ApiResult.success(true);



    }
```

### 参数生效

对于接口方法中简单参数的验证，需要在控制器类上面加上@Validated注解，然后直接在接口参数上加validator内置的校验注解即可。例如UserController类上面加上@Validated注解，然后getByEmail接口方法上直接在phoneNumber参数上加上@Pattern注解：

```
@RestController



@RequestMapping("user")



@Validated



public class UserController {



 



    // 其他代码...



 



    @GetMapping("phoneNumber")



    @ApiOperation("获取用户信息")



    @PreAuthorize("permitAll()")



    public ApiResult<User> getByEmail(@Pattern(regexp = "1[3|4|5|6|7|8|9][0-9]{9}", message = "手机号未通过验证") @RequestParam String phoneNumber) {



        //TODO 业务逻辑



 



        return ApiResult.success();



    }



 



    // 其他代码...



 



}
```

### List参数生效

对于接口方法中List参数的验证，如果我们需要验证List中的对象，那么需要在控制器类上面加上@Validated注解，然后直接在接口参数List加上@Valid注解来验证List中的对象，同时也可以结合validator内置的校验注解一起使用验证List的长度等。例如UserController类上面加上@Validated注解，然后addBatch接口方法的list参数加上@Valid和@Size注解来验证list至少需要传递一个UserModel对象并且传递的UserModel对象的所有字段必须通过验证：

```
@RestController



@RequestMapping("user")



@Validated



public class UserController {



 



    // 其他代码...



 



    @PostMapping("list")



    @ApiOperation("批量添加用户")



    @PreAuthorize("permitAll()")



    public ApiResult<Boolean> addBatch(@Valid @Size(min = 1, message = "用户信息未传递") @RequestBody List<UserModel> list) {



        //TODO 业务逻辑



 



        return ApiResult.success(true);



    }



 



    // 其他代码...



 



}
```

### Validator方法生效

方法中我们如果想手动的验证某个对象，可以通过Validator的validate方法来实现。在控制器中注入Validator（SpringBoot框架默认注册，这里未做进一步的研究），然后在需要验证的地方调用validate方法，然后手动返回验证结果。例如UserController中的updateBatch方法，在接口方法参数层面未使用@Valid注解则不会对List中的UserModel对象进行验证，我们在方法中通过手动调用Validator的validate方法来实现：

```
@RestController



@RequestMapping("user")



@Validated



public class UserController {



 



    // 其他代码...



 



    @Autowired



    private Validator validator;



 



    // 其他代码...



 



    @PutMapping("list")



    @ApiOperation("批量修改用户")



    @PreAuthorize("permitAll()")



    public ApiResult<Boolean> updateBatch(@Size(min = 1, message = "用户信息未传递") @RequestBody List<UserModel> list) {



 



        for (UserModel item : list) {



            Set<ConstraintViolation<UserModel>> violations = validator.validate(item, ValidationGroups.UpdateEntityValidate.class);



            if (violations.size() > 0) {



                Map<String, String> errorMap = new HashMap<>();



 



                for (ConstraintViolation<UserModel> violation : violations) {



                    errorMap.put(violation.getPropertyPath().toString(), violation.getMessage());



                }



                ApiResult apiResult = ApiResult.failed("参数未通过验证");



                apiResult.setData(errorMap);



                return apiResult;



            }



        }



 



        //TODO 业务逻辑



 



        return ApiResult.success(true);



    }



 



    // 其他代码...



}
```

 

## 验证信息返回

在使用@Valid和Validated注解做参数验证的时候，如果验证未通过，方法参数中传递了BindingResult对象会将验证信息传递给BindingResult对象，如果为传递BindingResult对象则会抛出异常。示例中接口方法都不传递BindingResult对象，统一走验证异常的流程。

自定义GlobalExceptionHandler类进行全局统一的验证异常处理，需要在类上加上@RestControllerAdvice注解，然后对BindException，MethodArgumentNotValidException和ConstraintViolationException验证异常进行拦截处理，其中BindException是对Get请求中使用@Validated或者@Valid验证的参数对象异常处理，MethodArgumentNotValidException是对Post请求中使用@Validated或者@Valid验证的参数对象异常处理，ConstraintViolationException是对Get和Post请求中使用validator内置的参数对象异常处理（上面介绍的参数生效和List生效会通过这种方式捕获异常）：

```
@RestControllerAdvice



public class GlobalExceptionHandler {



 



   /**



     * 处理Get请求的验证异常



     *



     * @param [result]



     * @return com.flyduck.cms.vo.ApiResult



    */



    @ExceptionHandler(BindException.class)



    public ApiResult bindExceptionHandle(BindingResult result) {



        ApiResult response = ApiResult.failed("参数未通过验证");



 



        if (result.hasErrors()) {



            List<ObjectError> errors = result.getAllErrors();



            HashMap<String, String> errorMap = new HashMap<>();



 



            errors.forEach(p ->{



 



                FieldError fieldError = (FieldError) p;



                errorMap.put(fieldError.getField(), fieldError.getDefaultMessage());



            });



            response.setData(errorMap);



        }



 



        return response;



    }



 



    /**



     * 处理Post请求的验证异常



     *



     * @param [exception]



     * @return com.flyduck.cms.vo.ApiResult



    */



    @ExceptionHandler(MethodArgumentNotValidException.class)



    public ApiResult methodArgumentNotValidHandler(MethodArgumentNotValidException exception) {



        ApiResult response = ApiResult.failed("参数未通过验证");



 



        BindingResult result = exception.getBindingResult();



        if (result != null && result.hasErrors()) {



            List<ObjectError> errors = result.getAllErrors();



            HashMap<String, String> errorMap = new HashMap<>();



 



            errors.forEach(p ->{



 



                FieldError fieldError = (FieldError) p;



                errorMap.put(fieldError.getField(), fieldError.getDefaultMessage());



            });



            response.setData(errorMap);



        }



 



        return response;



    }



 



    /**



     * 处理请求参数格式的验证异常



     *



     * @param [exception]



     * @return com.flyduck.cms.vo.ApiResult



    */



    @ExceptionHandler(ConstraintViolationException.class)



    public ApiResult constraintViolationHandler(ConstraintViolationException exception) {



        ApiResult response = ApiResult.failed("参数未通过验证");



 



        Set<ConstraintViolation<?>> violations = exception.getConstraintViolations();



        if (violations.size() > 0) {



            Map<String, String> errorMap = new HashMap<>();



 



            for (ConstraintViolation<?> violation : violations) {



                String fieldName = null;



                Iterator<Path.Node> iterator = violation.getPropertyPath().iterator();



                while (iterator.hasNext()) {



                    fieldName = iterator.next().getName();



                }



 



                if (!StringUtils.isEmpty(fieldName)) {



                    errorMap.put(fieldName, violation.getMessage());



                }



            }



            response.setData(errorMap);



        }



 



        return response;



    }



}
```

 

## 测试验证

对于list接口方法的测试结果如下：

![img](https://img-blog.csdnimg.cn/20200808225809367.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZseV9kdWNr,size_16,color_FFFFFF,t_70)

 对于add接口方法的测试结果如下：

![img](https://img-blog.csdnimg.cn/20200808225930278.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZseV9kdWNr,size_16,color_FFFFFF,t_70)

对于addBatch接口方法的测试结果如下：

![img](https://img-blog.csdnimg.cn/20200808230108234.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZseV9kdWNr,size_16,color_FFFFFF,t_70)

 

# @Valid和@Validated相同点与区别

|              | **@Valid**           | **@Validated**                 |
| ------------ | -------------------- | ------------------------------ |
| 标准         | 标准JSR-303规范      | 增强JSR-303规范                |
| 包           | javax.validation     | org.springframework.validation |
| 验证结果     | BindingResult result | BindingResult result           |
| 分组支持     | 不支持               | 支持                           |
| 分组序列     | 不支持               | 支持                           |
| 类型注解     | ？                   | 支持                           |
| 方法注解     | 支持                 | 支持                           |
| 方法参数注解 | 支持                 | 支持                           |
| 构造函数注解 | 支持                 | ？                             |
| 成员属性注解 | 支持                 | 不支持                         |
| 嵌套验证     | 支持                 | 不支持                         |

 

# 常用validator内置的校验注解

| Constraint                  | 含义                                                         |
| :-------------------------- | :----------------------------------------------------------- |
| @Null                       | 只能为null                                                   |
| @NotNull                    | 不能为null                                                   |
| @AssertTrue                 | 必须为 true                                                  |
| @AssertFalse                | 必须为 false                                                 |
| @Min(value)                 | 不小于value的数字                                            |
| @Max(value)                 | 不大于value的数字                                            |
| @DecimalMin(value)          | 不小于value的数字                                            |
| @DecimalMax(value)          | 不大于value的数字                                            |
| @Digits (integer, fraction) | 必须为数字，整数部分位数不超过integer，小数部分长度不超过fraction |
| @Future                     | 必须是一个将来的日期                                         |
| @Past                       | 必须是一个过去的日期                                         |
| @Size(max, min)             | 大小在min和max之间                                           |
| @Pattern(value)             | 必须符合指定的正则表达式value                                |

 

# 总结

本篇博客主要是对SpringBoot项目上常用的验证使用方法进行一个总结，并结合示例进行讲解，侧重于使用方面，暂时未做进一步的深入分析以及源码解读。想当初自己项目上做验证的时候，查看了多个博客才最终实现了项目中所有验证的场景，希望这篇博客中介绍的验证方法可以帮助到其他同学，而不用再做其他查找了。文中如有描述不准确的地方，还望博友及时反馈指正。