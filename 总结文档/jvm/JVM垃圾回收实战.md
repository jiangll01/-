####  JVM垃圾回收实战

 java -XX:+PrintCommandLineFlags -version

查看当前版本下jvm的情况，使用的是堆内存是多大，用的那种垃圾回收器

![image-20200708163200987](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200708163200987.png)

多线程命令

偏向锁在 JDK 6 及之后版本的 JVM 里是默认启用的。可以通过 JVM 参数关闭偏向锁：-XX:-UseBiasedLocking=false，关闭之后程序默认会进入轻量级锁状态。



#####  内存溢出 的定位和分析

![image-20200702083749641](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702083749641.png)

![image-20200702083817402](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702083817402.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702084005089.png" alt="image-20200702084005089" style="zoom: 67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702084157420.png" alt="image-20200702084157420" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702084447150.png" alt="image-20200702084447150" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702084552890.png" alt="image-20200702084552890" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702085303857.png" alt="image-20200702085303857" style="zoom: 67%;" />![image-20200702085515083](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702085515083.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702085303857.png" alt="image-20200702085303857" style="zoom: 67%;" />![image-20200702085515083](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702085515083.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702094526528.png" alt="image-20200702094526528" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702094901836.png" alt="image-20200702094901836" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702095145514.png" alt="image-20200702095145514" style="zoom:67%;" />

![image-20200702095649100](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702095649100.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702095811044.png" alt="image-20200702095811044" style="zoom:67%;" />

![image-20200702095851108](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702095851108.png)

![image-20200702095909289](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702095909289.png)

![image-20200702095956375](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702095956375.png)

![image-20200702100030558](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702100030558.png)

![image-20200702100454014](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702100454014.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702100606807.png" alt="image-20200702100606807" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702100606807.png" alt="image-20200702100606807" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702101204370.png" alt="image-20200702101204370" style="zoom:67%;" />

![image-20200702100916264](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702100916264.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702101244503.png" alt="image-20200702101244503" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702101244503.png" alt="image-20200702101244503" style="zoom:67%;" />![image-20200702101519119](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702101519119.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702101537286.png" alt="image-20200702101537286" style="zoom:67%;" />

![image-20200702102041144](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702102041144.png)

![image-20200702102133870](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702102133870.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702102424439.png" alt="image-20200702102424439" style="zoom: 67%;" />

![image-20200702102450725](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702102450725.png)

**串行化垃圾回收器没办法无法对web进行很好的应用，所以我们可以进行优化。**

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702102704563.png" alt="image-20200702102704563" style="zoom:67%;" />![image-20200702104040508](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702104040508.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702102704563.png" alt="image-20200702102704563" style="zoom:67%;" />![image-20200702104040508](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702104040508.png)

**大部分使用这个**

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702104245872.png" alt="image-20200702104245872" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702104942006.png" alt="image-20200702104942006" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702105043386.png" alt="image-20200702105043386" style="zoom:67%;" />

![image-20200702105250653](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702105250653.png)

![image-20200702105431292](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702105431292.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702105607446.png" alt="image-20200702105607446" style="zoom:67%;" />

![image-20200702105650181](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702105650181.png)

![image-20200702105812865](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702105812865.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702105913949.png" alt="image-20200702105913949" style="zoom:67%;" />![image-20200702110032659](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702110032659.png)



**通过esayGC进行日志查看**

![image-20200702110552745](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702110552745.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702110830709.png" alt="image-20200702110830709" style="zoom:50%;" />

![image-20200702110851297](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702110851297.png)

![image-20200702110919792](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702110919792.png)

![image-20200702111154689](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702111154689.png)

![image-20200702111253597](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702111253597.png)

![image-20200702111400810](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702111400810.png)

![image-20200702111438736](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702111438736.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702111621867.png" alt="image-20200702111621867" style="zoom:67%;" />

![image-20200702111934050](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702111934050.png)

![image-20200702112038294](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702112038294.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702112237594.png" alt="image-20200702112237594" style="zoom:80%;" />

![image-20200702112728398](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702112728398.png)