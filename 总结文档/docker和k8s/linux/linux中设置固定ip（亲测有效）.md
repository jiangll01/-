首先打开虚拟机

 

![img](https://img-blog.csdn.net/20180710105738844?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4MTM4MDY5/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

 

打开xshell5连接虚拟机（比较方便，这里默认设置过Linux的ip，只是不固定）

输入ifconfig，可以查看网管相关配置信息：

![img](https://img-blog.csdn.net/20180710112758359?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4MTM4MDY5/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

然后输入   vi /etc/sysconfig/network-scripts/ifcfg-ens33命令。修改网卡配置文件

按 i 键进行编辑。修改入下，原有的配置不要删，只要按下面修改就好。没有的配置项新增上去就好

打开以后可以看到默认的配置就是dhcp，然后onboot=no，表示不会随着系统的启动而启动。我们需要修改这个配置

![img](https://img-blog.csdn.net/20180827142947991?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4MTM4MDY5/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)

 

 

然后在下面创建两个值ip和子网掩码加在上图任何位置就ok了

IPADDR=192.168.0.116（填你的ip）          #IP地址

NETMASK=255.255.255.0  （填你的掩码值）      #掩码值

GATEWAY=192.168.0.1     (默认网关)

DNS1=8.8.8.8             （采用谷歌的默认DNS服务器）

以上这4项没有就加上，有就修改一下（配置如上图，其他参数就删掉就好了，没什么用）

 Esc 推出编辑，:wq  保存推出，reboot重启

重启后，输入ifconfig 查看是ip修改否成功。

 

![img](https://img-blog.csdn.net/20180710115937845?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzM4MTM4MDY5/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)