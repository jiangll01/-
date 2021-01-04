###  集合框架总结面试

## 前言

这套Base Admin是一套简单通用的后台管理系统，主要功能有：权限管理、菜单管理、用户管理，系统设置、实时日志，实时监控，API加密，以及登录用户修改密码、配置个性菜单等

## 技术栈

### 前端：layui

java后端：SpringBoot + Thymeleaf + WebSocket + Spring Security + SpringData-Jpa + MySql

### 工程结构说明

java部分、html、js、css部分都是大目录下面按单表一个子目录存放

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3ITNwVnjGa3JicsCbRbdJak6AWeG8kCglicTsrJtUNjyxxnZAv6txR8xyg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3IkHOUmkAozc8ib0wianibO4z6fEFHgR7Toz0mWXVCueWLQOWAlJv5kAeCQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

### 运行预览 

效果先睹为快，具体介绍在下方，按功能点进行详情介绍

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3IAw2SWSt5CGytnGibkicZGqM3gq106EiakcOvIiaoict3vQfPnjAaP4UzaXQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## 功能演示

### 登录

（为了方便演示，密码输入框的类型改成text）

配置文件分支选择，dev环境无需输入验证码

![img](https://mmbiz.qpic.cn/mmbiz_gif/QCu849YTaIM40diaOx4wgYH4YibWibagC3Ixt5ia2JD9DUE4G0sHXmLtlZ69DgRgoZPyXmXiaokDhEAqmqlllZP13Og/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

![img](https://mmbiz.qpic.cn/mmbiz_gif/QCu849YTaIM40diaOx4wgYH4YibWibagC3I0qdfd2QxLP3jgKRNRwePzJfk4YbztP7m1M7Mia1lormfRZQIBlqhNdA/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

同时支持多种登录限制

### 允许/禁止账号多人在线

![img](https://mmbiz.qpic.cn/mmbiz_gif/QCu849YTaIM40diaOx4wgYH4YibWibagC3Ib3rjeWdRACLf4IFqL3xUp8y52vzjicTTnU067oVJCdBw8RC4FRpibQbA/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

软删除

![img](https://mmbiz.qpic.cn/mmbiz_gif/QCu849YTaIM40diaOx4wgYH4YibWibagC3IpCdFnEqaT3hdqMpdRick836xaJFCWiavicC4E3Nz3RVmfF9N6Haku3j4w/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

### 限制登录IP地址

![img](https://mmbiz.qpic.cn/mmbiz_gif/QCu849YTaIM40diaOx4wgYH4YibWibagC3I49f7AEdWF0cIusYIwVn0yYnU6LXIE0z5luBVXEukJRF2ZGTqHGPMFg/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

### 账号过期

![img](https://mmbiz.qpic.cn/mmbiz_gif/QCu849YTaIM40diaOx4wgYH4YibWibagC3Iiaibytv9pb1RcQkl7vQzwCSnRiam4m2gIvnTr31PibpJB7uJbkoyTbWjHQ/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

更多登录限制，还可以继续扩展

### 系统设置

一下简单的系统属性设置，想支持更多的配置可自行扩展（比如这里的：用户管理初始、重置密码）

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3I90L7RZpqZRMuOBXVGtCiacPLZVw9VEyoeGpDE6HSLoXegSP2qChWcIA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

系统设置新增部分功能，详见文末“补充更新”。

### 菜单管理

菜单管理是一棵layui的Tree

增删改

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3I69NibFbagrxJTTSyJ4b5ibBDWrJPzyYwFQGmQAVCM7SSLWo2ZkVLBib5A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

### 权限管理 

增删改查

![img](https://mmbiz.qpic.cn/mmbiz_gif/eQPyBffYbuf5zTwyTptUPmjc7s09V5lDF1ubW3bjRLchzdlrDHI7noTrIFgPcE0PpDt5GN9RPICcPsLoZ1rqXQ/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

### 动态权限加载

权限的加载并不是写死在代码，而是动态从数据库读取，每次调用save方法时更新权限集合

1、妲己是ROLE_USER权限，权限内容为空，无权访问/sys/下面的路径（http://localhost:8888/sys/sysUser/get/1）

2、使用sa超级管理员进行权限管理编辑，给ROLE_USER的权限内容添加 /sys/**，妲己立即有权限访问（http://localhost:8888/sys/sysUser/get/1）

![img](https://mmbiz.qpic.cn/mmbiz_gif/eQPyBffYbuf5zTwyTptUPmjc7s09V5lD8ibiapTrjO6285EwVaRbksGlBicIQeQ2sOe7SUYz3dyNhjMicKRJQuI0kw/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

### 用户管理

主要包括用户信息、登录限制的维护，菜单、权限的分配等

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3IVibY5NhswbuPOIshY6OjOQlco87LibG238H6Fb7Y4JVjulqqOjGxvhng/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

修改用户权限是下一次登录生效

![img](https://mmbiz.qpic.cn/mmbiz_gif/eQPyBffYbuf5zTwyTptUPmjc7s09V5lDI3N55icMNOBMIo1Q3wic89MqkyOMVHrHib1ftCgYcrANh3dEuslcTeTGQ/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

修改用户菜单是刷新系统即可生效

![img](https://mmbiz.qpic.cn/mmbiz_gif/eQPyBffYbuf5zTwyTptUPmjc7s09V5lDm0t5umldLZUMHfcPDEpug7mHDoUF2LBzCMpfLgyiaApoOFiakUxKz51w/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

用户管理新增“当前在线用户”管理，详见文末“补充更新”。



### 登录用户信息

**基本信息**

登录用户只能修改部分信息，例如名称、修改密码

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3InCO6AcrHQ4ODLiceaEZKduvtkTUFzdVias5hJ7CgniaSZKRMz4xXhWxvQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**修改密码**

密码使用的是MD5加密并转换为16进制字符串存储，用户除了能主动修改密码外，还能叫管理员重置密码

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3I0hSIJVDcrehEsZfFZFJ9hlhLY28Mm976hIQvwd6GK0awpicwpYZfLgg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_gif/eQPyBffYbuf5zTwyTptUPmjc7s09V5lDUnermj0qb89LSP2akwPt6DnBPspw4w0m5lfxUibXhw6zEDg9FX3qoMw/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

**个性菜单**

用户可以自行配置自己的个性化快捷菜单

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3I5TEg5QUcP4BceaI29hQ0rhwjP4Ph9IhTYu7Pv2CfRw6iavjVYEgvZ2A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

### 实时日志 

使用websocket，实时将日志输出到web页面，1秒刷新一次

> 注意：这里的日志配置只配置了dev环境，prod环境尚未为空，发布生产环境前记得先配置，否则生成的日志文件将不会输入日志内容！

### ![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3I8zlRSJpF6vlDI3souKG49uzBADcMnmNuvbbWDrYeFlALV4rDW9GSyg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3ILJZOO13FrVWy5wxMibIegBUHaia4R8cwCH8qLJsKJ5SG1sOdNt5f6unQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

### 实时监控

实时监控的是系统硬件环境、以及jvm运行时内存，注：因本人暂无Linux环境，所以只测试了windows环境，有问题请及时反馈，谢谢！

使用websocket，实时将数据输出到web页面，1秒刷新一次

![img](https://mmbiz.qpic.cn/mmbiz_gif/eQPyBffYbuf5zTwyTptUPmjc7s09V5lDjVkTB5GFWUROPdiaUyX3JsJcxeiaSHyOlxeUzR5LibssTA3OkUcKRVmlg/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

### API加密

请求参数加密

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3IDqYwqmcibreTdlaQnaViab3eT5tBdxoSYnxYzZp6CWr8bwSU9P7s1d7A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

响应数据加密

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3I70uNfI9XFeYdaG0eEMCXAMjWQ5gwzEUFRl8WWWxHYErJ4icumicsFUQg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**1、系统设置新增API加密开关，可一键关闭、开启API加密；**

开启API加密

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3Ism8c9FFrhZFYadcUdEFEuA5xWLoibRohHVExbZxic2z6Fw1Wb1U295rg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

关闭API加密

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3IlBaumEcxgWUSWakzgGvibBck65ZIGiciaslHbXqn4fYwCVeKbiauBqTNug/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## 关键点讲解

1、定制url访问权限，动态权限读取，需要自定义配置认证数据源、认证管理器、拦截器，详情步骤请参考：

> https://www.jianshu.com/p/0a06496e75ea；

2、API加密中，由于登录校验是Spring Security做的，因此我们要在UsernamePasswordAuthenticationFilter获取账号、密码之前完成解密操作，正好我们的校验验证码操作就是在它之前，同时要做响应数据的加密操作，所以登录部分的API加密光按照我们之前的博客来还是不够的，需要在CaptchaFilterConfig进行解密操作，解密后new一个自定义RequestWrapper设置Parameter，并将这个新对象传到doFilter交由下一步处理

3、还是API加密问题，我们是在程序启动的时候生成后端RSA秘钥对，正常来说我们在访问登录页面进行登录的时候前端获取一下就可以了，但在开发环境中，我们通常开启热部署功能，改完代码程序可能会自动重启，但登录用户信息仍然保持在本地线程，系统依旧处于登录状态没有跳转到登录页面，导致后端公钥已经改变，但前端依旧用的是旧的后端公钥，所有导致加解密失败；解决：在访问index首页时也获取一下后端公钥，这样在开发的时候idea热部署后刷新页面就可以了（已提交最新代码，解决热部署后刷新页面还是API加解密失败问题；现在热部署后刷新页面即可）

## 更新

1、新增百度富文本的使用，但还没配置上传接口：

> UEditor文档:http://fex.baidu.com/ueditor/#start-start

对应字段类型，mysql要改成longtext

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3IclEIUZgTjpFhAGLegmp4k514EVFUFzTgpIDQIrgmVQcs8AawiaPlTug/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

2、新增“”记住我“”功能，也就是rememberMe，原理以及源码探究请看这位大佬的博客：

> https://blog.csdn.net/qq_37142346/article/details/80114609

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3IkngxILTKUx2jYnKwelEh8Juo9cRaXWuwTa0a82rb87ib02ky9mMwVQQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3Ia3RzXqGHuSx2Fgp41GzuZjCHbsicQR2SvEzWxn0PKsBQXAj529bicERg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

3、系统设置新增系统颜色，头部、左侧菜单的颜色可按心情切换（SQL文件已同步更新）

![img](https://mmbiz.qpic.cn/mmbiz_png/QCu849YTaIM40diaOx4wgYH4YibWibagC3IHxGd5B9hoNibUZkqh9b7VBgHj50ruk1p8xfVlk3OL2DoL9TOHloG6iaw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

4、用户管理模块新增“当前在线用户”管理，可实时查看当前在线用户，以及对当前在线用户进行强制下线操作

![img](https://mmbiz.qpic.cn/mmbiz_gif/eQPyBffYbuf5zTwyTptUPmjc7s09V5lD4GibD4Flj4qFFLQJjrsdtSDsKqHlqbQN7ewqTjnAcERbDsDJ6XCwa5g/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

## 代码地址

> GitHub：https://github.com/huanzi-qch/base-admin

> 码云：https://gitee.com/huanzi-qch/base-admin