####  docker的安装学习

docker安装

（1） 首先登陆docker官网找到centos进行安装

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200705172706859.png" alt="image-20200705172706859" style="zoom:25%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200705172734126.png" alt="image-20200705172734126" style="zoom:25%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200705172756185.png" alt="image-20200705172756185" style="zoom:25%;" />![image-20200705172846266](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200705172846266.png)

![image-20200705172846266](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200705172846266.png)



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200705172815411.png" alt="image-20200705172815411" style="zoom:25%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200705172902784.png" alt="image-20200705172902784" style="zoom:25%;" />

设置docker开机自启动如下：

systemctl enable docker



（2）安装完之后需要配置下载镜像 配置为阿里云的地址

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200705172638146.png" alt="image-20200705172638146" style="zoom: 25%;" />

（3）去镜像仓库下载想要下载的软件

https://hub.docker.com/

![image-20200705173232950](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200705173232950.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200705173846682.png" alt="image-20200705173846682" style="zoom:33%;" />

docker运行mysql命令：
docker run -p 3306:3306 --name mysql \
-v /mydata/mysql/log:/var/log/mysql \
-v /mydata/mysql/data:/var/lib/mysql \
-v /mydata/mysql/conf:/etc/mysql \
-e MYSQL_ROOT_PASSWORD=root \
-d mysql:5.7

默认登陆的时候是    用户名root   密码 root

**进入容器**

docker exec -it + 容器id 或名字  /bin/bash    进入到linux 控制台  

exit 推出容器

 **挂载到了/mysqldata中了**

**docker下mysql配置**
【client】
default-character-set=utf8

【mysql】
default-character-set=utf8
【mysqld】

character-set-server=utf8



**docker logs -f --tail 10 mysql**   查看日志



**安装redis**

docker pull redis 

首先创建要挂载的目录

mkdir -p /mydata/redis/conf

touch redis.conf

**在执行**

docker run -p 6379:6379 --name redis -v /mydata/redis/data:/data \
-v/mydata/redis/conf/redis.conf:/etc/redis/redis.conf \
-d redis redis-server /etc/redis/redis.conf