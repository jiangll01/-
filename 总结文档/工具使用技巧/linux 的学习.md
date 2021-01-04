####  linux 的学习

![image-20200702203300360](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702203300360.png)

![image-20200702203401084](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200702203401084.png)

【常见目录说明】

| 目录        |                                                              |
| ----------- | ------------------------------------------------------------ |
| /bin        | 存放二进制可执行文件(ls,cat,mkdir等)，常用命令一般都在这里。 |
| /etc        | 存放系统管理和配置文件                                       |
| /home       | 存放所有用户文件的根目录，是用户主目录的基点，比如用户user的主目录就是/home/user，可以用~user表示 |
| /usr        | 用于存放系统应用程序，比较重要的目录/usr/local 本地系统管理员软件安装目录（安装系统级的应用）。这是最庞大的目录，要用到的应用程序和文件几乎都在这个目录。/usr/x11r6 存放x window的目录/usr/bin 众多的应用程序 /usr/sbin 超级用户的一些管理程序 /usr/doc linux文档 /usr/include linux下开发和编译应用程序所需要的头文件 /usr/lib 常用的动态链接库和软件包的配置文件 /usr/man 帮助文档 /usr/src 源代码，linux内核的源代码就放在/usr/src/linux里 /usr/local/bin 本地增加的命令 /usr/local/lib 本地增加的库 |
| /opt        | 额外安装的可选应用程序包所放置的位置。一般情况下，我们可以把tomcat等都安装到这里。 |
| /proc       | 虚拟文件系统目录，是系统内存的映射。可直接访问这个目录来获取系统信息。 |
| /root       | 超级用户（系统管理员）的主目录（特权阶级^o^）                |
| /sbin       | 存放二进制可执行文件，只有root才能访问。这里存放的是系统管理员使用的系统级别的管理命令和程序。如ifconfig等。 |
| /dev        | 用于存放设备文件。                                           |
| /mnt        | 系统管理员安装临时文件系统的安装点，系统提供这个目录是让用户临时挂载其他的文件系统。 |
| /boot       | 存放用于系统引导时使用的各种文件                             |
| /lib        | 存放跟文件系统中的程序运行所需要的共享库及内核模块。共享库又叫动态链接共享库，作用类似windows里的.dll文件，存放了根文件系统程序运行所需的共享文件。 |
| /tmp        | 用于存放各种临时文件，是公用的临时文件存储点。               |
| /var        | 用于存放运行时需要改变数据的文件，也是某些大文件的溢出区，比方说各种服务的日志文件（系统启动日志等。）等。 |
| /lost+found | 这个目录平时是空的，系统非正常关机而留下“无家可归”的文件（windows下叫什么.chk）就在这里 |



![image-20200703144843597](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200703144843597.png)

![image-20200703144817819](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200703144817819.png)

**Linux 文件与目录管理**

我们知道Linux的目录结构为树状结构，最顶级的目录为根目录 /。

其他目录通过挂载可以将它们添加到树中，通过解除挂载可以移除它们。

在开始本教程前我们需要先知道什么是绝对路径与相对路径。

- **绝对路径：**
  路径的写法，由根目录 / 写起，例如： /usr/share/doc 这个目录。
- **相对路径：**
  路径的写法，不是由 / 写起，例如由 /usr/share/doc 要到 /usr/share/man 底下时，可以写成： cd ../man 这就是相对路径的写法啦！

#####  1、vim的使用

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704142605719.png" alt="image-20200704142605719" style="zoom: 50%;" />

#####  2、关机

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704143039430.png" alt="image-20200704143039430" style="zoom: 67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704143244087.png" alt="image-20200704143244087" style="zoom:67%;" />

#####  3、用户和组的管理

![image-20200704143746363](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704143746363.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704143856694.png" alt="image-20200704143856694" style="zoom:67%;" />![image-20200704144522217](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704144522217.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704144628019.png" alt="image-20200704144628019" style="zoom:50%;" />

**userdel -r 会删除家目录 ，生产中不要删除家目录**

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704145709558.png" alt="image-20200704145709558" style="zoom:50%;" />

**切换用户**

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704145847418.png" alt="image-20200704145847418" style="zoom:67%;" />![image-20200704150146195](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704150146195.png)

![image-20200704150225302](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704150225302.png)

**who i am**  :查看目前登陆的时候是那个用户

**where is +查看的文件**  ： 查看这个文件都在什么目录

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704150419807.png" alt="image-20200704150419807" style="zoom: 50%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704150608370.png" alt="image-20200704150608370" style="zoom:50%;" />

组的切换

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704151044790.png" alt="image-20200704151044790" style="zoom:50%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704151120387.png" alt="image-20200704151120387" style="zoom:67%;" />![image-20200704151400925](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704151400925.png)

![image-20200704151400925](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704151400925.png)



![image-20200704151408484](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704151408484.png)

**运行级别**

![](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704151928034.png)

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704152306789.png" alt="image-20200704152306789" style="zoom:67%;" />

#####  4、常用命令



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704153902126.png" alt="image-20200704153902126" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704154351221.png" alt="image-20200704154351221" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704155115337.png" alt="image-20200704155115337" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704155156871.png" alt="image-20200704155156871" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704155302435.png" alt="image-20200704155302435" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704155402473.png" alt="image-20200704155402473" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704155626425.png" alt="image-20200704155626425" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704155647813.png" alt="image-20200704155647813" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704155744771.png" alt="image-20200704155744771" style="zoom:50%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704155838585.png" alt="image-20200704155838585" style="zoom:50%;" />



![image-20200704160024409](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704160024409.png)



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704160041246.png" alt="image-20200704160041246" style="zoom:50%;" />



![image-20200704160227291](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704160227291.png)



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704160432884.png" alt="image-20200704160432884" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704161327464.png" alt="image-20200704161327464" style="zoom: 67%;" />

![image-20200704161401213](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704161401213.png)



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704161618274.png" alt="image-20200704161618274" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704161813242.png" alt="image-20200704161813242" style="zoom:67%;" />![image-20200704162314849](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704162314849.png)



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704162332132.png" alt="image-20200704162332132" style="zoom:67%;" />



![image-20200704162516936](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704162516936.png)



#####  5、时间日期



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704162544065.png" alt="image-20200704162544065" style="zoom:50%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704162714522.png" alt="image-20200704162714522" style="zoom:50%;" />

#####  6、搜素查找命令

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704162943014.png" alt="image-20200704162943014" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704163107686.png" alt="image-20200704163107686" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704163257975.png" alt="image-20200704163257975" style="zoom:50%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704163459510.png" alt="image-20200704163459510" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704163515519.png" alt="image-20200704163515519" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704163542456.png" alt="image-20200704163542456" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704163701085.png" alt="image-20200704163701085" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704183841588.png" alt="image-20200704183841588" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704184513554.png" alt="image-20200704184513554" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704184532128.png" alt="image-20200704184532128" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704185602489.png" alt="image-20200704185602489" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704185714533.png" alt="image-20200704185714533" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704185948724.png" alt="image-20200704185948724" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704192728691.png" alt="image-20200704192728691" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704193102399.png" alt="image-20200704193102399" style="zoom:50%;" />

**文件管理**

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704193141257.png" alt="image-20200704193141257" style="zoom: 50%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704193404397.png" alt="image-20200704193404397" style="zoom:50%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704193716020.png" alt="image-20200704193716020" style="zoom:50%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704193914149.png" alt="image-20200704193914149" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704194001469.png" alt="image-20200704194001469" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704194532169.png" alt="image-20200704194532169" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704194556985.png" alt="image-20200704194556985" style="zoom:50%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704194705033.png" alt="image-20200704194705033" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704195108231.png" alt="image-20200704195108231" style="zoom:50%;" />

##### 7、 任务调度

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704195844592.png" alt="image-20200704195844592" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704195904719.png" alt="image-20200704195904719" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704195947140.png" alt="image-20200704195947140" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704200243769.png" alt="image-20200704200243769" style="zoom: 67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704200351725.png" alt="image-20200704200351725" style="zoom:67%;" />

#####  8、分区和磁盘挂载



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704200858983.png" alt="image-20200704200858983" style="zoom:67%;" />

#####  9、网络配置

**Linux端口操作常见命令**

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704214320440.png" alt="image-20200704214320440" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704214411082.png" alt="image-20200704214411082" style="zoom:50%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704214459664.png" alt="image-20200704214459664" style="zoom: 50%;" />







1.查看防火墙状态
     查看防火墙状态 systemctl status firewalld
     开启防火墙 systemctl start firewalld  
     关闭防火墙 systemctl stop firewalld
     开启防火墙 service firewalld start 
     若遇到无法开启
     先用：systemctl unmask firewalld.service 
     然后：systemctl start firewalld.service

一、查看哪些端口被打开 netstat -anp

二、关闭端口号:iptables -A INPUT -p tcp --drop 端口号-j DROP

iptables -A OUTPUT -p tcp --dport 端口号-j DROP

三、打开端口号：iptables -I INPUT -ptcp --dport 端口号 -j ACCEPT

四、以下是linux打开端口命令的使用方法。

nc -lp 23 &(打开23端口，即telnet)

netstat -an | grep 23 (查看是否打开23端口)



firewall：

systemctl start firewalld.service#启动firewall

systemctl stop firewalld.service#停止firewall

systemctl disable firewalld.service#禁止firewall开机启动

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704201555270.png" alt="image-20200704201555270" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704201911779.png" alt="image-20200704201911779" style="zoom: 67%;" />

#####  10、进程讲解

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704202039612.png" alt="image-20200704202039612" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704202151493.png" alt="image-20200704202151493" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704202526005.png" alt="image-20200704202526005" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704202559790.png" alt="image-20200704202559790" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704202724913.png" alt="image-20200704202724913" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704202750551.png" alt="image-20200704202750551" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704202815664.png" alt="image-20200704202815664" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704202949786.png" alt="image-20200704202949786" style="zoom:50%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704203118327.png" alt="image-20200704203118327" style="zoom:67%;" />



#####  11、服务

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704203212338.png" alt="image-20200704203212338" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704203319936.png" alt="image-20200704203319936" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704203412451.png" alt="image-20200704203412451" style="zoom:67%;" />





<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704204213326.png" alt="image-20200704204213326" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704204629185.png" alt="image-20200704204629185" style="zoom:67%;" />



#####  12、rpm和yum包管理

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704204819201.png" alt="image-20200704204819201" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704204859237.png" alt="image-20200704204859237" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704204950941.png" alt="image-20200704204950941" style="zoom:67%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704205038401.png" alt="image-20200704205038401" style="zoom:50%;" />

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704205104038.png" alt="image-20200704205104038" style="zoom:67%;" />



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200704205152213.png" alt="image-20200704205152213" style="zoom:67%;" />

















#####  、linux 安装mysql





 https://blog.csdn.net/qq_37598011/article/details/93489404

安装教程按照这个就可以安装mysql

http://www.mamicode.com/info-detail-2548002.html

linux中MySQL本地可以连接，远程连接不上问题

这是遇到防火墙了，

1.网络或防火墙问题

（1）检查网络直接ping你的远程服务器，ping 182.61.22.107，可以ping通说明网络没问题

（2）看端口号3306是不是被防火墙挡住了，telnet 182.61.22.107 3306

下图这样就是防火墙挡住了3306端口不允许访问

![技术分享图片](http://image.mamicode.com/info/201812/20181210133119073259.png)

配置防火墙，开启3306端口

https://blog.csdn.net/sinat_29821865/article/details/80982250?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase

centos7启动iptables时报Job for iptables.service failed because the control process exited with error cod

启动iptables：

```sql
 service iptables start
```

报错如下：

```vbscript
Job for iptables.service failed because the control process exited with error code. See "systemctl status iptables.service" and "journalctl -xe" for details.
```

查看异常信息：

```undefined
journalctl -xe
```

错误如下：

```vbscript
Failed to start IPv4 firewall with iptables.
```

**解决办法**

因为centos7默认的防火墙是firewalld防火墙，不是使用iptables，因此需要先关闭firewalld服务，或者干脆使用默认的firewalld防火墙。

因为这次报错的服务器是一台刚刚购买的阿里云服务器，所以在操作上忘记关闭默认防火墙的步骤了才导致浪费了些时间在这件事情上。

关闭firewalld：

```
systemctl stop firewalld  
systemctl mask firewalld
```

使用iptables服务:

```
#开放443端口(HTTPS)
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
#保存上述规则
service iptables save
#开启服务
systemctl restart iptables.service
```

正常启动！！！！