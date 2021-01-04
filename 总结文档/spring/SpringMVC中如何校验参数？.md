**Java校验API**

今天和大家分享一下如何在SpringMVC中校验参数。首先大家要知道的就是java校验API，即java Validation API，又称为JSR-303。从Spring3.0版本开始，SpringMVC就提供了对java校验API的支持，要在SpringMVC中使用java校验API的话只需要在类路径下包含java校验API的实现就好了，比如Hibernate Validator。

java校验API定义了多个注解，这些注解直接在所需要校验的属性上使用就可以了，这些注解都在javax.validation.constraints包中，我们一起来看一下这些注解。

![img](https://pics0.baidu.com/feed/bd315c6034a85edfe59bf7147b7ece26dd5475a5.jpeg?token=653cbe18d33b08d68ad3c2e6d1dc6bcd&s=7922CC5802F4D07E48C5050A0200E0D2)校验注解

我们今天使用SpringBoot的2.2.1.RELEASE进行测试。

**如何开启校验**

要开启校验仅仅需要2步：1.在需要校验的字段上添加上注解；2.在SpringMVC的路径方法的需要校验的参数上添加@Valid注解，如图：

![img](https://pics6.baidu.com/feed/9e3df8dcd100baa1c2fece8b753a7e17c9fc2edb.jpeg?token=c6e531baf7aae712a4ec0b70f066caee&s=A0C2B7435AA4B76C0C4D440F000070C3)@NotNull注解

![img](https://pics2.baidu.com/feed/48540923dd54564e73871ba882f45b87d0584f75.jpeg?token=dd0289fdc124a515c630dd053867dbaa&s=E0D237C11BB4B6494AD559060000E0C3)@Valid添加校验

**获取校验的错误**

获取校验的错误需要在Valid注解的后面添加Errors参数就可以了，记得Errors参数要添加在校验参数的后面才可以。如图：

![img](https://pics2.baidu.com/feed/a2cc7cd98d1001e9ba6021cd8924bce955e79747.jpeg?token=40553da268085cd30969147c90ccc1fa&s=F0D237C3CDE4AF705AE0A1030000A0C3)Errors

图中通过hasErrors判断是否存在参数错误，通过getFieldErrors返回错误的信息。

**校验注解**

@AssertFalse：

所注解的元素必须是Boolean类型，并且值为false

@AssertTrue：

所注解的元素必须是Boolean类型，并且值为true

@DecimalMax：

所注解的元素必须是数字，并且值要小于或等于给定的BigDecimalString值

@DecimalMin：

所注解的元素必须是数字，并且值要小于或等于给定的BigDecimalString值

@Digits：

所注解的元素必须是数字，并且它的值必须有指定的位数

@Email：

所注解的元素要匹配指定的正则表达式

@Max：

所注解的元素必须是数字，并且值要小于或等于给定的值。注意如果@Max所注解的元素是null，则@Max注解会返回true，所以应该把@Max注解和@NotNull注解结合使用

@Min：

所注解的元素必须是数字，并且值要大于或等于给定的值。注意如果@Min所注解的元素是null，则@Min注解会返回true，即也会通过校验，所以应该把@Min注解和@NotNull注解结合使用。

@NotBlank：

所注解的元素不能为null且不能为空白，用于校验CharSequence(含String、StringBuilder和StringBuffer)

@NotEmpty：

所注解的元素不能为null且长度大于0，可以是空白，用于校验CharSequence、数组、Collection和Map

@NotNull：

所注解的元素不能为null

@Null：

所注解的元素必须为null

@Pattern：

所注解的元素必须匹配指定的正则表达式。注意如果@Pattern所注解的元素是null，则@Pattern注解会返回true，即也会通过校验，所以应该把@Pattern注解和@NotNull注解结合使用

@Size：

所注解的元素必须符合指定的大小,该注解可用于数组，CharSequence(含String、StringBuilder和StringBuffer)，Collection和Map。注意如果@Size所注解的元素是null，则@Size注解会返回true，即也会通过校验，所以应该把@Size注解和@NotNull注解结合使用

**ConstraintValidator实现类**

最后和大家提一下，hibernate-validator的校验实现位于org.hibernate.validator.internal.constraintvalidators包下，校验的实现类都实现了ConstraintValidator接口，具体如下图所示。感兴趣的小伙伴可以通过源码看看hibernate-validator的具体校验逻辑。

![img](https://pics2.baidu.com/feed/500fd9f9d72a60591263f4c31a1ef39e023bbaa3.jpeg?token=c2215775656bff79d0b208e5856d4054&s=3BA2C84D92B6866D5869310A0000E0C2)ConstraintValidator的实现类

举几个例子：

@NotBlank的校验源码：

![img](https://pics5.baidu.com/feed/11385343fbf2b21122830baafbaaa23d0dd78e51.jpeg?token=300837a5fbbe3eb7e5c6b6704ce8fd13&s=A2DA77CB8FA099685655C00B0000E0C3)NotBlankValidator

@Size对于数组的校验源码：

![img](https://pics2.baidu.com/feed/a1ec08fa513d2697ecc445076bd175fe4316d801.jpeg?token=502bd314b700c1f381c67f9f33af7910)SizeValidatorForArray

@NotEmpty对于Collection的校验源码：

![img](https://pics3.baidu.com/feed/b58f8c5494eef01f78267618d1d45e20bd317de8.jpeg?token=ba777b3c70aa6d476b424e5ec43e5b16&s=A0DA37CB8BA08D605655E4030000E0C3)NotEmptyValidatorForCollection

**结束**

今天简单和大家介绍了如何在SpringMVC中校验参数，可以说SpringMVC大大简化了我们在参数检验上的工作量，这也正是框架带来的好处。

好啦，希望今天的文章能帮助到大家，小伙伴们如果有什么疑问可以在评论区留言哦。