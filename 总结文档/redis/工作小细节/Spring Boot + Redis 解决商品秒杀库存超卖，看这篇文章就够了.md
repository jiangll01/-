## Spring Boot + Redis 解决商品秒杀库存超卖，看这篇文章就够了

点击关注☞ [Java专栏](javascript:void(0);) *今天*

#### [![img](https://mmbiz.qpic.cn/sz_mmbiz_png/6D5fS3V8mLz0nKibbKwVprgOF5szzVjcUzIQAHGY3D0Yz40xwuiaSprN3bKbpTYFbjgvKtrKkTODW9anXLZibo5Pw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)](http://mp.weixin.qq.com/s?__biz=MzU1ODMxODE3OQ==&mid=2247483684&idx=1&sn=18d1c3a814f8d2335d6aa3f4d5ffa647&chksm=fc291628cb5e9f3e496611859f2a1df301688f45d981f72ffa295631609f7536f17452e68828&scene=21#wechat_redirect)

------

作者：涛哥谈篮球

来源：toutiao.com/i6836611989607809548

# 问题描述

在众多抢购活动中，在有限的商品数量的限制下如何保证抢购到商品的用户数不能大于商品数量，也就是不能出现超卖的问题；还有就是抢购时会出现大量用户的访问，如何提高用户体验效果也是一个问题，也就是要解决秒杀系统的性能问题。本文主要介绍基于redis 实现商品秒杀功能。先来跟大家讲下大概思路。

**总体思路就是要减少对数据库的访问，尽可能将数据缓存到Redis缓存中，从缓存中获取数据。**

在系统初始化时，将商品的库存数量加载到Redis缓存中；接收到秒杀请求时，在Redis中进行预减库存，当Redis中的库存不足时，直接返回秒杀失败，否则继续进行第3步；将请求放入异步队列中，返回正在排队中；服务端异步队列将请求出队，出队成功的请求可以生成秒杀订单，减少数据库库存，返回秒杀订单详情。当后台订单创建成功之后可以通过websocket 向用户发送一个秒杀成功通知。前端以此来判断是否秒杀成功，秒杀成功则进入秒杀订单详情，否则秒杀失败。

下面直接上代码系统初始化的时候将秒杀商品库存放入redis缓存

![img](https://mmbiz.qpic.cn/mmbiz_png/eukZ9J6BEiadicDxv7Xt32pBP1WLwUyIsyF4bEe5btLibRZiaHMAMTEMUR4cH88FeFDSIsNskeicH39xJgwBmUB7qfw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

第二创建消息队列（这里为了方便，我直接使用redis队列来进行模拟操作）

![img](data:image/gif;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQImWNgYGBgAAAABQABh6FO1AAAAABJRU5ErkJggg==)<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200803161433032.png" alt="image-20200803161433032" style="zoom:150%;" />

第三 配置RedisTemplate序列化

![image-20200803161448623](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200803161448623.png)

下面创建一个接口，在这个接口中创建10000个线程来模拟用户商品抢购场景

![img](data:image/gif;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQImWNgYGBgAAAABQABh6FO1AAAAABJRU5ErkJggg==)![image-20200803161500140](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200803161500140.png)

![image-20200803161520578](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200803161520578.png)

这里使用到了redis api中的decrement操作，预先减轻用户抢购的数量，同时判断redis中的库存是否大于用户抢购数量，如果小于0，直接提示用户秒杀失败，否则秒杀成功，进入redis消息队列执行数据库建库存操作。以上操作注意保证redis缓存与数据库库存数据保持一致性。

![image-20200803161532618](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200803161532618.png)

下面测试演示

![image-20200803161548777](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200803161548777.png)

初始化商品库存100，在测试一万并发量后，最终发现不会不会出现超卖问题。因为这里一万个并发，每个并发抢购10件商品。经过redis减库存之后，最后只会有10个线程去更新数据库。