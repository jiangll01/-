## 用了这么久，token和session的区别，你真的清楚了吗？

[后端技术精选](javascript:void(0);) *5天前*

![img](https://mmbiz.qpic.cn/mmbiz_png/JfTPiahTHJhokvOzF3PlHFs9ibTCpKFL8Nhz9gW6Vic7cnib82XYabo30xDdkc2WSFpTqoq6Gom5Hib0ASfbKJeDQmA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

*作者：\*刘彤彤**

*https://www.cnblogs.com/belongs-to-qinghua*

session和token都是用来保持会话，功能相同

## 一、session机制，原理

**![img](https://mmbiz.qpic.cn/mmbiz_png/JfTPiahTHJhoAzFRp9iauKF1VydtnhfeHW2h72wGfibib7ibMLicmMz9s9JphQKfSUAniayOehibDfMo34jhErZpicD8YaA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)**

**session是服务端存储的一个对象，主要用来存储所有访问过该服务端的客户端的用户信息（也可以存储其他信息），从而实现保持用户会话状态。但是服务器重启时，内存会被销毁，存储的用户信息也就消失了。**

不同的用户访问服务端的时候会在session对象中存储键值对，“键”用来存储开启这个用户信息的“钥匙”，在登录成功后，“钥匙”通过cookie返回给客户端，客户端存储为sessionId记录在cookie中。当客户端再次访问时，会默认携带cookie中的sessionId来实现会话机制。

**session是基于cookie的。**

- cookie的数据4k左右
- cookie存储数据的格式：字符串key=value
- cookie存储有效期：可以自行通过expires进行具体的日期设置，如果没设置，默认是关闭浏览器时失效。
- cookie有效范围：当前域名下有效。所以session这种会话存储方式方式只适用于客户端代码和服务端代码运行在同一台服务器上（前后端项目协议、域名、端口号都一致，即在一个项目下）

**session持久化**

用于解决重启服务器后session就消失的问题。在数据库中存储session，而不是存储在内存中。通过包：express-mysql-session

**其它**

当客户端存储的cookie失效后，服务端的session不会立即销毁，会有一个延时，服务端会定期清理无效session，不会造成无效数据占用存储空间的问题。

## 二、token机制，原理

![img](https://mmbiz.qpic.cn/mmbiz_png/JfTPiahTHJhoAzFRp9iauKF1VydtnhfeHW7U30Cf3etK6roofYCkvJ87Jdh0XYVGY3XsNibEL8lIicdd73dzZtsYaw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

适用于项目级的前后端分离（前后端代码运行在不同的服务器下）

请求登录时，token和sessionId原理相同，是对key和key对应的用户信息进行加密后的加密字符，登录成功后，会在响应主体中将{token：'字符串'}返回给客户端。客户端通过cookie、sessionStorage、localStorage都可以进行存储。再次请求时不会默认携带，需要在请求拦截器位置给请求头中添加认证字段Authorization携带token信息，服务器端就可以通过token信息查找用户登录状态。

```
精彩推荐一百期Java面试题汇总SpringBoot内容聚合IntelliJ IDEA内容聚合Mybatis内容聚合

欢迎长按下图关注公众号后端技术精选
```