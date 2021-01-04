# 1.Nginx知识网结构图

![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I60GLFTz6nX8fy0vKEYfKNhzn6Uvm5PUOorgntibF1icjvWrogINeCQ4JA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)Nginx是一个高性能的HTTP和反向代理服务器，特点是占用内存少，并发能力强，事实上nginx的并发能力确实在同类型的网页服务器中表现较好

nginx专为性能优化而开发，性能是其最重要的要求，十分注重效率，有报告nginx能支持高达50000个并发连接数

## 1.1反向代理

**正向代理**正向代理：局域网中的电脑用户想要直接访问网络是不可行的，只能通过代理服务器来访问，这种代理服务就被称为正向代理。![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6QY5q8UFUOVPF3G2n1Pl2TibFtJ8cPdLGWcDd81B45f2xia76caqJlO8Q/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**反向代理**反向代理：客户端无法感知代理，因为客户端访问网络不需要配置，只要把请求发送到反向代理服务器，由反向代理服务器去选择目标服务器获取数据，然后再返回到客户端，此时反向代理服务器和目标服务器对外就是一个服务器，暴露的是代理服务器地址，隐藏了真实服务器IP地址![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I63zlibqrnRSezzZJZJcltFcBRdneUIfQEzibMdHgx178icgHiaicUgrGVN0g/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## 1.2负载均衡

客户端发送多个请求到服务器，服务器处理请求，有一些可能要与数据库进行狡猾，服务器处理完毕之后，再将结果返回给客户端

普通请求和响应过程![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6d53sXkOV6V9TSqVRz7de6StOpvw0MWv0uBDRWrYVicOA6QKChXNv7wQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)但是随着信息数量增长，访问量和数据量飞速增长，普通架构无法满足现在的需求

我们首先想到的是升级服务器配置，可以由于摩尔定律的日益失效，单纯从硬件提升性能已经逐渐不可取了，怎么解决这种需求呢？

我们可以增加服务器的数量，构建集群，将请求分发到各个服务器上，将原来请求集中到单个服务器的情况改为请求分发到多个服务器，也就是我们说的负载均衡

**图解负载均衡**![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I68hAjos6upHUFsrFhibXSticA8Jt5sNnfoD5hIVRczUX4lIQ881uGfI8g/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)假设有15个请求发送到代理服务器，那么由代理服务器根据服务器数量，平均分配，每个服务器处理5个请求，这个过程就叫做负载均衡

## 1.3动静分离

为了加快网站的解析速度，可以把动态页面和静态页面交给不同的服务器来解析，加快解析的速度，降低由单个服务器的压力

动静分离之前的状态![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I64XaHwfVeI2am4z2OEo6ZmP1JYpCc5YHAiazBSaQw3M5GuWfe1aE0jsg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)动静分离之后![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6K5K1jnibicxZ7e8x785ib15oicFHIuzPm7PGydTfRulOxV83icI47eAA9YA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

# 2. nginx如何在linux安装

参考这篇：https://blog.csdn.net/yujing1314/article/details/97267369

# 3. nginx常用命令

查看版本

```
./nginx -v
```

启动

```
./nginx
```

关闭（有两种方式，推荐使用 ./nginx -s quit）

```
 ./nginx -s stop
 ./nginx -s quit
```

重新加载nginx配置

```
./nginx -s reload
```

# 4.nginx的配置文件

配置文件分三部分组成

全局块 从配置文件开始到events块之间，主要是设置一些影响nginx服务器整体运行的配置指令

并发处理服务的配置，值越大，可以支持的并发处理量越多，但是会受到硬件、软件等设备的制约![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6xGxFoLRom6uc2wvANGhXjib6X8EYtPCBNx9jqKAQGKtUK9ianOfMAMgg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

events块 影响nginx服务器与用户的网络连接，常用的设置包括是否开启对多workprocess下的网络连接进行序列化，是否允许同时接收多个网络连接等等

支持的最大连接数![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6p7PUrWEU7AWU0VxNcicFibmuiaqPEeSJVkNMnNjjuEOqrkrbDaNZhKUpg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)http块 诸如反向代理和负载均衡都在此配置

**location指令说明**

- 该语法用来匹配url，语法如下

```
location[ = | ~ | ~* | ^~] url{

}
123
```

1. =:用于不含正则表达式的url前，要求字符串与url严格匹配，匹配成功就停止向下搜索并处理请求
2. ~：用于表示url包含正则表达式，并且区分大小写。
3. ~*：用于表示url包含正则表达式，并且不区分大瞎写
4. ^~：用于不含正则表达式的url前，要求ngin服务器找到表示url和字符串匹配度最高的location后，立即使用此location处理请求，而不再匹配
5. 如果有url包含正则表达式，不需要有~开头标识

## 4.1 反向代理实战

**配置反向代理**目的：在浏览器地址栏输入地址www.123.com跳转linux系统tomcat主页面

具体实现 先配置tomcat：因为比较简单，此处不再赘叙 并在windows访问![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6xicWN03sRHeiaPXkLGAUS29oywicFM5ia3AOFFtKTCJOeeJR08k6P6XOCA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)具体流程![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6V7KAvmU206J2Of3PvvXPZTrZiaLsGD86oMcHicwTf35X454NIQPSrib5Q/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)修改之前![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6y0V5UoyNNFicBlV56yu61SEwPkPeepRyibOHV7ibXOV0ZHYzwQOweuJSg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

配置![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6zr6are2q5Go8uq7B2KRIvgUaz98JVibnEhBictTPic28UZUTiczZWNemkA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)再次访问![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6lIsIlFETCjtOuibFDrJ6jM135GIxnWBAmV5lOKibEJrFSBwOJMEdPlXg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)**反向代理2**

1.目标 访问http://192.168.25.132:9001/edu/ 直接跳转到192.168.25.132:8080 访问http://192.168.25.132:9001/vod/ 直接跳转到192.168.25.132:8081

2.准备 配置两个tomcat，端口分别为8080和8081，都可以访问，端口修改配置文件即可。![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6SqQGGKuATQEttIbJAgsaicKo9aWCCQgtx7cIPMW6pfgQQftOzlqW5ibA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6xZ2fUzgX4Jw1qj4hd5ibiblF1vpKibMUl2Ncxk0M4OgzQx4nYwpKx33gQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

新建文件内容分别添加8080！！！和8081！！！![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6G9l8eXucf9S8JRpE3Xvy0iaaQRm0oDbwMsIQ4rWcaMfhMicBMrBG4Kxw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6dfXdMFFzADQIcJibRicXezgmtemTFcyMj3lkTBMOSVibHcIDq7nbjYEFw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)响应如下![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6bVwyvFyJI1q3gxnIflFaUYD8HgW3f6AZClm3encMsAQ7s6VP4ZVaqg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6ibfoicAicZpq5iaKJsUcTCjribsTLrtk8PAyUxibwYszX8q5BwRxz0AMggkQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)3.具体配置![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6xTXONXDWA8T26Ufj6vgFEOGnBIyq7EWReKP2pLDdDFxo8icLpbatE5Q/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)重新加载nginx

```
./nginx -s reload
1
```

访问![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I60l3qOiaI2JJW6SOIqJsicaXlunb5Km8icJD5PtEyckW87VQtUPFjGoZKA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I60l3qOiaI2JJW6SOIqJsicaXlunb5Km8icJD5PtEyckW87VQtUPFjGoZKA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)实现了同一个端口代理，通过edu和vod路径的切换显示不同的页面

## 4.2 反向代理小结

第一个例子：浏览器访问www.123.com，由host文件解析 出服务器ip地址

192.168.25.132 www.123.com 然后默认访问80端口，而通过nginx监听80端口代理到本地的8080端口上，从而实现了访问www.123.com，最终转发到tomcat 8080上去

第二个例子：访问http://192.168.25.132:9001/edu/ 直接跳转到192.168.25.132:8080 访问http://192.168.25.132:9001/vod/ 直接跳转到192.168.25.132:8081

实际上就是通过nginx监听9001端口，然后通过正则表达式选择转发到8080还是8081的tomcat上去

## 4.3 负载均衡实战

1.修改nginx.conf![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6Y0AiajuYMUlhxGztRryIZcRsRCxqKtKibc9JqC9vv1g8dNPGRFKzYCxA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6pUSh63GVJwkfeUBURu5RhAaLNNmVesFSDjWq0xs1ib3oVcj85oPLwTA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)2.重启nginx

```
./nginx -s reload
1
```

3.在8081的tomcat的webapps文件夹下新建edu文件夹和a.html文件，填写内容为8081！！！！

4.在地址栏回车，就会分发到不同的tomcat服务器上![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6DZHAvicjJtfbbmakXATfrgicHHTXlSuibz1IGkncNTZKW0eqXsQVscmrQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6fKEExt2PL7xYYgrchODh8MIflicqPzaibDWOm22Z3CgDTrQY37BwlJag/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)3.负载均衡方式

- 轮询（默认）
- weight，代表权，权越高优先级越高![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6onyEwaFFbeUFyialp6HFUfAcKTSBhh7tC9Mdy5wr2piaQG5HzwCPRV0A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)
- fair，按后端服务器的响应时间来分配请求，相应时间短的优先分配![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6fJ4l25vsJzqphcMfH4N41Dkwd6X4nPUabyV5TwiaiaSLTbCDiaea9HZtg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)
- ip_hash,每个请求按照访问ip的hash结果分配，这样每一个访客固定的访问一个后端服务器，可以解决session 的问题![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6dQz0trGGmPXWXLa2RQnswBT7iaINA32QRIia6iagcKuLgWIZbX78yeT5w/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## 4.4 动静分离实战

**什么是动静分离**把动态请求和静态请求分开，不是讲动态页面和静态页面物理分离，可以理解为nginx处理静态页面，tomcat处理动态页面

动静分离大致分为两种：一、纯粹将静态文件独立成单独域名放在独立的服务器上，也是目前主流方案；二、将动态跟静态文件混合在一起发布，通过nginx分开

**动静分离图析**![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I60FDEaCf0zZa9xAibP9icJb9Xt4Gx0NjibWdjWnSL8ndKRSYtwuAhNBTow/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)**实战准备**准备静态文件

![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6oDJC2PppIyQzmdxOH1kvJZS2GPvCmibbYNJA2BCLPk4ibichGtCr9SDEw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6NH6pHTiaOumMDlozgTSIU3tFWSMUzJWSJfxbRsvuZdkbiaFIeMNDUUzA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)配置nginx![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6PpRdI6P9JJc6j4OyVWtTPwf2d3lonicicIWibQLoygD1ouicibicHz59YPjg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

# 5.nginx高可用

如果nginx出现问题![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6iaRswxaZSQjMbkPyex7icdjxr5YheyHhaHqXZ8LlGkYOE8EyFlC9LX1A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)解决办法![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6ASfPssA1XQsL0k0lVIgmiaQBibCVtMG6dVD9HXP6FIsATNibSiap9Ptq1g/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)前期准备

1. 两台nginx服务器
2. 安装keepalived
3. 虚拟ip

## 5.1安装keepalived

```
[root@192 usr]# yum install keepalived -y
[root@192 usr]# rpm -q -a keepalived
keepalived-1.3.5-16.el7.x86_64
```

修改配置文件

```
[root@192 keepalived]# cd /etc/keepalived
[root@192 keepalived]# vi keepalived.conf
```

分别将如下配置文件复制粘贴，覆盖掉keepalived.conf 虚拟ip为192.168.25.50

> 对应主机ip需要修改的是 smtp_server 192.168.25.147（主）smtp_server 192.168.25.147（备） state MASTER（主） state BACKUP（备）

```
global_defs {
   notification_email {
     acassen@firewall.loc
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   notification_email_from Alexandre.Cassen@firewall.loc
   smtp_server 192.168.25.147
   smtp_connect_timeout 30
   router_id LVS_DEVEL # 访问的主机地址
}

vrrp_script chk_nginx {
  script "/usr/local/src/nginx_check.sh"  # 检测文件的地址
  interval 2   # 检测脚本执行的间隔
  weight 2   # 权重
}

vrrp_instance VI_1 {
    state BACKUP    # 主机MASTER、备机BACKUP
    interface ens33   # 网卡
    virtual_router_id 51 # 同一组需一致
    priority 90  # 访问优先级，主机值较大，备机较小
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.25.50  # 虚拟ip
    }
}
```

启动

```
[root@192 sbin]# systemctl start keepalived.service
```

![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6w8lcjricL2sotJ6KwTZy2fhnLGh0wLGgHpZEO3m5mzzbua8TJSGOYkQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)访问虚拟ip成功![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6Cs37zLzP0ukYRbL6xjGd25GEPG8dFTygI7cKfInY3tnRktMFoHOZJQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)关闭主机147的nginx和keepalived，发现仍然可以访问

# 6.原理解析

![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6MEibYz3HOYDLUfFhBgv3JngWsfkgJ8TNOO3WJQfxmldH19L8ryYsNibw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)如下图，就是启动了一个master，一个worker，master是管理员，worker是具体工作的进程![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6jMNxz2icuO6ayDMmA7mtAqA3Fib0awh3MHuGl3lFqtrDLW2HxlEvtmOw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)worker如何工作![img](https://mmbiz.qpic.cn/mmbiz_png/6mychickmupWsrVW3QvHBKs0KOH5Y06I6zzRF5icm0Jyrib7rZ2OWlRZQ0BSHsdm0ZKVliclibjK22Hbc2uKaeoK1IA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)