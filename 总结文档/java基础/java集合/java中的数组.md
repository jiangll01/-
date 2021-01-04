String底层是char数组来实现的，好多人当年上学时被二维数组，三维数组吓哭了吧。我们今天来讲讲数组，数组非常的重要，很多常用类，比如String等底层都是用数组来实现的，后续我们会一一讲到，多少人很久没用数组了？是否都在用ArrayList呀？这儿先卖个关子，ArrayList底层也是数组实现的。

**所谓数组，是相同数据类型的元素按一定顺序排列的集合**。现在我们来看一看数组在内存中的样子，话不多说，上代码：

![img](https://pic4.zhimg.com/v2-35105f000b2343a3cb8053abdb0c6233_b.png)![img](https://pic4.zhimg.com/80/v2-35105f000b2343a3cb8053abdb0c6233_1440w.png)

这是一段教科书级别的代码，让我想起了中学时候学过的文章，孔乙己问：茴香豆的茴字有几种写法？先编译一下，我们打开编译好的class文件，反编译一下看看：

![img](https://pic3.zhimg.com/v2-ff2927f3ff98cd43cbbc3e18e6336ab2_b.png)![img](https://pic3.zhimg.com/80/v2-ff2927f3ff98cd43cbbc3e18e6336ab2_1440w.png)

三种数组的声明方式编译后，最后创建的方式都是一样的，都给我们加了new关键字，顺手还把charArr3的声明与赋值一体化了，编译器你管得也太多了吧。评论区里有人说反编译后和我反编译后的代码不一样，**本专栏所有文章是基于JDK1.8讲解的，反编译工具是idea自带的反编译工具，不一样的原因可能是各位的JDK版本或反编译工具和我不一致**。用IDE的代码联想功能看一下：

![img](https://pic2.zhimg.com/v2-892060ceb35b218c1e7b8c9372a86881_b.png)![img](https://pic2.zhimg.com/80/v2-892060ceb35b218c1e7b8c9372a86881_1440w.png)

恩，没错，Object类有的方法它都有，它还多了一个length属性（注意不是方法）。个人认为，在Java层面，我们完全可以把数组当成对象来看待，下图我们模拟一下数组在堆内存中的大致的样子，每一个数组都是按顺序排列在堆内存中，正因为如此，我们可以通过数组+[下标]的方式来直接访问数组里的元素。

![img](https://pic3.zhimg.com/v2-448447e3343294329275aff468b805b2_b.png)![img](https://pic3.zhimg.com/80/v2-448447e3343294329275aff468b805b2_1440w.png)

我们再来看看二维数组：

![img](https://pic4.zhimg.com/v2-8e1892a0c57b3a3d1ac11707c7356113_b.png)![img](https://pic4.zhimg.com/80/v2-8e1892a0c57b3a3d1ac11707c7356113_1440w.png)

这里还是用了三种方式去声明，还是反编译class文件看一下，虽然有点差别，但还是大同小异，都给我们加了new关键字（这次没有把我们的z数组和赋值一体化）。

![img](https://pic2.zhimg.com/v2-a44b7c61d53417c5b1fb62f9f5384eed_b.png)![img](https://pic2.zhimg.com/80/v2-a44b7c61d53417c5b1fb62f9f5384eed_1440w.png)

老规矩，我们画一画。

嘿嘿，不就是数组里面套数组嘛，不要被二维这两个字给吓到了，哪有什么二维数组，其实就是二级数组而已。上图中只画出了数组x，有兴趣的朋友可以自行画一下y和z。

![img](https://pic2.zhimg.com/v2-5ad580bf5b5b89b780fa67fe0dcca09d_b.png)![img](https://pic2.zhimg.com/80/v2-5ad580bf5b5b89b780fa67fe0dcca09d_1440w.png)

思考以下代码的执行结果：

![img](https://pic3.zhimg.com/v2-2bdb208a144ec486fd024419d6d48b9e_b.png)![img](https://pic3.zhimg.com/80/v2-2bdb208a144ec486fd024419d6d48b9e_1440w.png)





作者：清浅池塘
链接：https://zhuanlan.zhihu.com/p/27626724
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



String这个类是我们在写Java代码中用得最多的一个类，没有之一，今天我们就讲讲它，我们打开String这个类的源码：

![img](https://pic2.zhimg.com/v2-9f6d15319a32332c0820f7a408ef435d_b.png)![img](https://pic2.zhimg.com/80/v2-9f6d15319a32332c0820f7a408ef435d_1440w.png)

声明了一个char[]数组，变量名value，声明了一个int类型的变量hash(hash的作用我们后续会讲)，话不多说，上代码：

![img](https://pic2.zhimg.com/v2-4a2ef9fd85a3f73e7764f1a671e960f9_b.png)![img](https://pic2.zhimg.com/80/v2-4a2ef9fd85a3f73e7764f1a671e960f9_1440w.png)

我们点开构造函数看一下：

![img](https://pic1.zhimg.com/v2-5c9898d60ed3cc041859ff8b8116be24_b.png)![img](https://pic1.zhimg.com/80/v2-5c9898d60ed3cc041859ff8b8116be24_1440w.png)

多年以前，我看到这段代码时我是懵逼的，没错，我现正在准备构造一个String的对象，那original这个对象又是从何而来？是什么时候构造的呢？

在Java中，当值被双引号引起来(如本示例中的"abc")，JVM会去先检查看一看常量池里有没有abc这个对象，如果没有，把abc初始化为对象放入常量池，如果有，直接返回常量池内容。下图是预先处理String str = new String("abc")的参数"abc"

![img](https://pic4.zhimg.com/v2-cd776d08c1147df346332d42c3ce0427_b.png)![img](https://pic4.zhimg.com/80/v2-cd776d08c1147df346332d42c3ce0427_1440w.png)

接下来处理new关键字，在堆内存中开辟空间，由于hash这个字段是int类型的，成员变量初始化默认值为0。

![img](https://pic4.zhimg.com/v2-c797e99bee769b6755937b98155f51ef_b.png)![img](https://pic4.zhimg.com/80/v2-c797e99bee769b6755937b98155f51ef_1440w.png)

处理构造函数逻辑，hash是值类型，直接赋值，数组为引用类型，直接指向地址。

![img](https://pic1.zhimg.com/v2-5c9898d60ed3cc041859ff8b8116be24_b.png)![img](https://pic1.zhimg.com/80/v2-5c9898d60ed3cc041859ff8b8116be24_1440w.png)

继续上图

![img](https://pic3.zhimg.com/v2-4cfe138fb2af4f7d9fc701f72133f26e_b.png)![img](https://pic3.zhimg.com/80/v2-4cfe138fb2af4f7d9fc701f72133f26e_1440w.png)

最后执行String str2 = new String("abc")，结果如下图：

![img](https://pic2.zhimg.com/v2-c8a323166922869a17334431d50da4c5_b.png)![img](https://pic2.zhimg.com/80/v2-c8a323166922869a17334431d50da4c5_1440w.png)

利用IDE的debug功能看一下，char数组里已经有了'a','b','c'这些值。

![img](https://pic4.zhimg.com/v2-2fbd808468798c4c55877aac63cc4bdf_b.png)![img](https://pic4.zhimg.com/80/v2-2fbd808468798c4c55877aac63cc4bdf_1440w.png)

下面我们来看一下String这个类下面这些常用的API是如何实现的：

![img](https://pic2.zhimg.com/v2-1497b776b7177ad6e07fd3cc2b92147d_b.png)![img](https://pic2.zhimg.com/80/v2-1497b776b7177ad6e07fd3cc2b92147d_1440w.png)

![img](https://pic4.zhimg.com/v2-e759478158b74811451c4379dbb94877_b.png)![img](https://pic4.zhimg.com/80/v2-e759478158b74811451c4379dbb94877_1440w.png)

![img](https://pic1.zhimg.com/v2-f186fb86275daed9335449cd52cc0540_b.png)![img](https://pic1.zhimg.com/80/v2-f186fb86275daed9335449cd52cc0540_1440w.png)

![img](https://pic1.zhimg.com/v2-4d5425ac433c509fab149d9c3c29a6d4_b.png)![img](https://pic1.zhimg.com/80/v2-4d5425ac433c509fab149d9c3c29a6d4_1440w.png)

![img](https://pic2.zhimg.com/v2-d0bedc4bb52276ccc07f85d704729b3d_b.png)![img](https://pic2.zhimg.com/80/v2-d0bedc4bb52276ccc07f85d704729b3d_1440w.png)

![img](https://pic2.zhimg.com/v2-e4fd21d2c03d69910ee3b4e69f0b74c5_b.png)![img](https://pic2.zhimg.com/80/v2-e4fd21d2c03d69910ee3b4e69f0b74c5_1440w.png)

![img](https://pic4.zhimg.com/v2-330cbd581df8d308946da6aabba0667f_b.png)![img](https://pic4.zhimg.com/80/v2-330cbd581df8d308946da6aabba0667f_1440w.png)

很简单对吧，可怕的不是源码难读，而是不想，害怕去读源码的心。如果文章得到了你的认可，请为我的文章点赞，你的赞同是我继续下去的动力。