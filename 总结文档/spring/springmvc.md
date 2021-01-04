####  springmvc 

#####   1、springmvc 到前后端分离

https://www.cnblogs.com/-flq/p/9476407.html

https://www.cnblogs.com/zumengjie/p/11846953.html

https://blog.csdn.net/wuzhiwei549/article/details/106096807

https://blog.csdn.net/fanbaodan/article/details/84860969

https://www.cnblogs.com/wyq1995/p/10672457.html

由于REST是无状态的，后端应用发布的REST API可在用户未登录的情况下被任意调用，这显然是不安全的，如何解决这个问题呢？我们需要为REST请求提供安全机制。

**提供安全机制**

　　解决REST安全调用问题，可以做得很复杂，也可以做得特简单，可按照以下过程提供REST安全机制：

　　(1). 当用户登录成功后，在服务端生成一个token，并将其放入内存中（可放入JVM或Redis中），同时将该token返回到客户端；

　　(2). 在客户端中将返回的token写入cookie中，并且每次请求时都将token随请求头一起发送到服务端；

　　(3). 提供一个AOP切面，用于拦截所有的Controller方法，在切面中判断token的有效性；

　　(4). 当登出时，只需清理掉cookie中的token即可，服务端token可设置过期时间，使其自行移除。

![img](https://img-blog.csdnimg.cn/20181206165736317.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2ZhbmJhb2Rhbg==,size_16,color_FFFFFF,t_70)