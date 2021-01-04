####   idea 使用总结

1、添加javap、javac等一些列java的额外命令

如果将javap命令添加到编译器中查看字节码文件会方便很多，下面介绍如何在idea中添加javap命令：

（1）打开setting菜单，

<img src="https://img-blog.csdn.net/20180323135031544?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L25ldzExMTExMTE=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70" alt="img" style="zoom: 50%;" />



（2）找到工具中的扩展工具点击打开，

<img src="https://img-blog.csdn.net/20180323135151389?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L25ldzExMTExMTE=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70" alt="img" style="zoom:50%;" />



（3）点击左侧区域左上角的绿色加号按钮会弹出如下图这样的一个编辑框，按提示输入，

<img src="https://img-blog.csdn.net/20180323140005292?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L25ldzExMTExMTE=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70" alt="img" style="zoom:50%;" />

（4）完成后点击ok,点击setting窗口的apply然后ok，到这里就已经完成了javap命令的添加，

（5）查看已添加的命令并运行：在代码编辑区右键external tool的扩展选项里可以看到刚才添加的命令，点击执行即可。

<img src="https://img-blog.csdn.net/20180323140425959?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L25ldzExMTExMTE=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70" alt="img" style="zoom: 50%;" />