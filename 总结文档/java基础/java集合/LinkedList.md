在前面的文章里，我们讲了数组和ArrayList，在现实中，不管什么系统，如果不考虑性能的话，用其中的一个就可以完成所有工作，那为什么不用它们来进行所有的数据存储呢？

在数组/ArrayList中**读取和存储**(get/set)的性能非常高，为O(1)，但**插入**(add(int index, E element))和**删除**(remove(int index))却花费了O(N)时间，效率并不高。

今天我们来看Java中的另一种List即LinkedList，LinkedList是基于**双向链表**来实现的，关于链表的知识我们[Java数据结构之线性表 - 知乎专栏](https://zhuanlan.zhihu.com/p/28346365)一文中有过介绍，HashMap和链表也有关系，所以我们要先讲它，话不多说，上代码。

![img](https://pic1.zhimg.com/v2-dd882f9596c2f578d740c34c422d4f5c_b.png)![img](https://pic1.zhimg.com/80/v2-dd882f9596c2f578d740c34c422d4f5c_1440w.png)

这段代码和我们之前的往ArrayList添加元素的代码基本上是一模一样的，只是修改了红框的内容为LinkedList，这时候再往里添加元素，调用的就是LinkedList里面的add方法了。在之前的 [面向对象](https://zhuanlan.zhihu.com/p/27681007) 一文中我们已经说过了，这是**多态**的体现，利用好多态，在编码过程中，我们可以少修改很多东西，忘记了的朋友可以回过头去看一下。一看到new这个关键字，我们脑海里应该是，这货在堆内存中开辟了一块空间，我们先从构造函数入手吧。

![img](https://pic2.zhimg.com/v2-e389bcfa9b1d93c00da6daa32e0f1b1d_b.png)![img](https://pic2.zhimg.com/80/v2-e389bcfa9b1d93c00da6daa32e0f1b1d_1440w.png)

满怀希望的打开构造函数，好伤心，里面没有任何逻辑，只能从成员变量入手。

![img](https://pic4.zhimg.com/v2-52fcf459f29176f450c28cb2ff127587_b.png)![img](https://pic4.zhimg.com/80/v2-52fcf459f29176f450c28cb2ff127587_1440w.png)

发现三个成员变量，size就不多说了，大家猜一下就知道是LinkedList的逻辑长度，初始化为0，并持有两个Node引用，first看名字一猜就是第一个，last看名字就是最后一个，我们先来画一画

![img](https://pic4.zhimg.com/v2-383f405b2da901ec2a15bb41b2f515ef_b.png)![img](https://pic4.zhimg.com/80/v2-383f405b2da901ec2a15bb41b2f515ef_1440w.png)

初始化完了，在堆内存中就是这个样子，size为0。引用类型的成员变量初始化为null，再来看一看这个Node是什么东东

![img](https://pic3.zhimg.com/v2-c5e31c6e2aeb187e0b07532d41e6012e_b.png)![img](https://pic3.zhimg.com/80/v2-c5e31c6e2aeb187e0b07532d41e6012e_1440w.png)

这是一个内部静态私有类，该类只能在LinkedList中访问，先记住它，debug看一下

![img](https://pic4.zhimg.com/v2-c2ccac91c4032bf14e3fb9f5a5d6f883_b.png)![img](https://pic4.zhimg.com/80/v2-c2ccac91c4032bf14e3fb9f5a5d6f883_1440w.png)

和我们图中一致，我们继续执行码里的add方法，看源码

![img](https://pic4.zhimg.com/v2-d2d16c32c3c3c9595b715c9318fa7eab_b.png)![img](https://pic4.zhimg.com/80/v2-d2d16c32c3c3c9595b715c9318fa7eab_1440w.png)

很普通，e是我们往里添加的Person对象“张三”，继续跟踪linkLast方法：

![img](https://pic4.zhimg.com/v2-ff2efb640c70064ba35161a2a8f9645b_b.png)![img](https://pic4.zhimg.com/80/v2-ff2efb640c70064ba35161a2a8f9645b_1440w.png)

第一次往LinkedList里添加元素，我们看上图11-1就知道，first为null，last也为null，把我们的Person对象“张三”传给了Node的构造函数，再看Node的构造函数：

![img](https://pic1.zhimg.com/v2-af25ff1aefe4d25368b931ae8117bf98_b.png)![img](https://pic1.zhimg.com/80/v2-af25ff1aefe4d25368b931ae8117bf98_1440w.png)

用Person张三为入参构造了一个Node对象，好了，又到了画图的时候

![img](https://pic3.zhimg.com/v2-f6d529d8a762e691baa542cc7628b2ba_b.png)![img](https://pic3.zhimg.com/80/v2-f6d529d8a762e691baa542cc7628b2ba_1440w.png)

老规矩，debug一下：

![img](https://pic3.zhimg.com/v2-840e0adf5de8d4cd64075e0f980f6c5a_b.png)![img](https://pic3.zhimg.com/80/v2-840e0adf5de8d4cd64075e0f980f6c5a_1440w.png)

和我们图中所画的一致，我们继续添加“李四”这个Person对象，再打开源码分析一下。

![img](https://pic1.zhimg.com/v2-f3c1008c491de465d3e2e473d1d6e51c_b.png)![img](https://pic1.zhimg.com/80/v2-f3c1008c491de465d3e2e473d1d6e51c_1440w.png)

张三这个Node指向新new出来的Node对象，再看Node是怎么创建的

![img](https://pic3.zhimg.com/v2-e59ea80468be5280e388a4eac3b76962_b.png)![img](https://pic3.zhimg.com/80/v2-e59ea80468be5280e388a4eac3b76962_1440w.png)

创建Node对象，新new出来的Node对象的prev引用指向包含Person张三的Node对象。item引用指向Person李四对象，继续画图：

![img](https://pic4.zhimg.com/v2-90031819bb499f45a1f2057fe9342aaf_b.png)![img](https://pic4.zhimg.com/80/v2-90031819bb499f45a1f2057fe9342aaf_1440w.png)

看上图，原来的next引用指向新new出来的Node，同时新new出来的Node的prev引用指向原来的Node对象，item指向新new出来的Person李四这个对象，同时perList这个LinkedList对象的last引用指向新new出来的这个Node，再debug看一下

![img](https://pic3.zhimg.com/v2-b2bc6f9c5d93f0720daef7b70ba4da1e_b.png)![img](https://pic3.zhimg.com/80/v2-b2bc6f9c5d93f0720daef7b70ba4da1e_1440w.png)

好的，继续添加“王五”，“赵六”

![img](https://pic4.zhimg.com/v2-4d1b775031e67974a4b2bf4c361d7cbb_b.png)![img](https://pic4.zhimg.com/80/v2-4d1b775031e67974a4b2bf4c361d7cbb_1440w.png)

很简单，没有了底层数组，新增加了一个Node对象，记录了Person的内容，每个Node对象都持有next引用(下一个)和prev引用(上一个)，其实就是之前 [Java数据结构之线性表 - 知乎专栏](https://zhuanlan.zhihu.com/p/28346365) 一文里介绍的**双向链表**，这个图看起来有点乱，多年前我在读这段代码的时候，差点晕过去了，又是next，prew，first，last，容易乱，因此大家在学习源码的过程中，有不明白的地方，找张纸和笔画一画，就清晰了。放张简化版的图，方便大家理解。

![img](https://pic3.zhimg.com/v2-133cbc952f16dccbde926dd8b21e290e_b.png)![img](https://pic3.zhimg.com/80/v2-133cbc952f16dccbde926dd8b21e290e_1440w.png)



夜深了，先休息了，大家有什么看不明白的地方，可以在评论区留言，本文在写作过程中如果有什么勘误，还希望细心的读者提出来，下一篇我们研究LinkedList的查找、插入与删除，并引入时间复杂度来分析。





## [LinkedList元素的删除原理](https://zhuanlan.zhihu.com/p/28373321)

作者：清浅池塘
链接：https://zhuanlan.zhihu.com/p/28373321
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



上一篇文章我们说了LinkedList，并说了往里添加了元素。这篇文章我们来说说LinkedList元素的删除，话不多说，上代码，还是那个Person类

![img](https://pic1.zhimg.com/v2-55de64bfcae2e4b48e78647811da63a0_b.png)![img](https://pic1.zhimg.com/80/v2-55de64bfcae2e4b48e78647811da63a0_1440w.png)

还是那两个属性，name，age，提供了一些简单的get与set方法。写我们的main方法

![img](https://pic1.zhimg.com/v2-8b1b4eba061f2a51daed02d8057f4eb4_b.png)![img](https://pic1.zhimg.com/80/v2-8b1b4eba061f2a51daed02d8057f4eb4_1440w.png)

和前文一样，new了一个LinkedList，并往里添加了四个元素，看过前文的朋友都知道现在LinkedList目前在堆内存中的样子如下图：

![img](https://pic2.zhimg.com/v2-99e579b1d1f02664d09aa97189550b6d_b.png)![img](https://pic2.zhimg.com/80/v2-99e579b1d1f02664d09aa97189550b6d_1440w.png)

现在我们来删除王五这个用户，运行一下

![img](https://pic2.zhimg.com/v2-4426844c94688e1258f677d9df641c19_b.png)![img](https://pic2.zhimg.com/80/v2-4426844c94688e1258f677d9df641c19_1440w.png)

看一下结果

![img](https://pic2.zhimg.com/v2-e50f83c1c0cf5791170a39850e03f969_b.png)![img](https://pic2.zhimg.com/80/v2-e50f83c1c0cf5791170a39850e03f969_1440w.png)

好奇怪，打印返回的删除状态居然是**false**，代码中明明删掉王五了，为什么打印的结果还是4？如果经常看本专栏文章的人，大概已经猜到了原因，这个王五是新new出来的，并不是perList里的王五，**Person这个类没有重写equals方法，删除元素依赖于equals方法，**到底是不是呢，我们来看一下源码：

![img](https://pic4.zhimg.com/v2-f771fb8a1a0ab71607fb78d4f3000767_b.png)![img](https://pic4.zhimg.com/80/v2-f771fb8a1a0ab71607fb78d4f3000767_1440w.png)

不出所料，又看到了熟悉的**equals**，真是无处不在，这段代码其实是从第一个Node节点（first节点）开始对比item的值，如果equals成功就执行unlink()方法，并返回删除成功的布尔值true。我们画一画查找王五的这个过程。

![img](https://pic3.zhimg.com/v2-f835263857700c413290a32d8f91820e_b.png)![img](https://pic3.zhimg.com/80/v2-f835263857700c413290a32d8f91820e_1440w.png)

大致就是这个样子，就大家仔细看图里的文字描述，现在我们来看看unlink()方法都做了啥

![img](https://pic2.zhimg.com/v2-6b3305913fcb32bf1e11b3d0a482a6d9_b.png)![img](https://pic2.zhimg.com/80/v2-6b3305913fcb32bf1e11b3d0a482a6d9_1440w.png)

**注意，在本示例中，上图的黑色字体注释部分不会执行**。好吧，我承认，多年前我看这段代码被绕晕了，prev.next，next.prev都是些什么鬼啊！苍天啊！大地啊！

别怕，上面代码看似烧脑但是逻辑相当简单，就是把包含王五的这个Node从双向链表中移出来，然后把王五相邻的两个Node的next和prev重新指向一下，我们画一下图：

![img](https://pic2.zhimg.com/v2-578f58033cf890d66a179a23a207f019_b.png)![img](https://pic2.zhimg.com/80/v2-578f58033cf890d66a179a23a207f019_1440w.png)

简单吧，debug一下看是不是和图中画的一致，测试代码前别忘了在Person里重写equals方法

![img](https://pic2.zhimg.com/v2-a8328976e97db9e39a69c571b540d82d_b.png)![img](https://pic2.zhimg.com/80/v2-a8328976e97db9e39a69c571b540d82d_1440w.png)

debug看一下，已经删除了王五，size也更新成了3。

![img](https://pic1.zhimg.com/v2-2b09cd9614d77594a34b4b906cfea67c_b.png)![img](https://pic1.zhimg.com/80/v2-2b09cd9614d77594a34b4b906cfea67c_1440w.png)

打印结果也和期待中一样，打印删除状态也为**true**了。

![img](https://pic4.zhimg.com/v2-1a4b741bcf7ce18ffee6d9c4f7f14503_b.png)![img](https://pic4.zhimg.com/80/v2-1a4b741bcf7ce18ffee6d9c4f7f14503_1440w.png)

说到这儿，我们再来看一下**ArrayList**以对象方式删除元素的源码，来和**LinkedList**比较一下

![img](https://pic3.zhimg.com/v2-c8f5db21923aa529886675ecb0e019f6_b.png)![img](https://pic3.zhimg.com/80/v2-c8f5db21923aa529886675ecb0e019f6_1440w.png)

再看fastRemove()方法

![img](https://pic1.zhimg.com/v2-206a4aad1a838a49654a9a6672133454_b.png)![img](https://pic1.zhimg.com/80/v2-206a4aad1a838a49654a9a6672133454_1440w.png)

大体上一致，两者都在元素中循环查找，LinkedList是把Node（包含Person）从链表的移出（通过修改上下节点的引用来实现），ArrayList删除底层数组元素后又把底层数组都往前复制了一格内容（忘记了的朋友可以复习一下，传送门：[ArrayList的元素删除](https://zhuanlan.zhihu.com/p/27938717)），现在我们来比较一下这两者间的时间复杂度。

假设要删除的元素都在这两个List中的第n位置，由于两者都循环查找了n次，**省略循环查找这个步骤**，说以我们直接看删除，前面的一系列文章中我们已经讲过了，由于ArrayList删除元素后，底层数组要往前复制一格，**ArrayList底层数组删除元素时间复杂度为Ｏ(n)。**再来看LinkedList，**LinkedList底层链表删除元素只是简单的修改了一下引用地址，时间复杂度为O(1)。**

由以上推断看来，LinkedList的删除效率似乎要好很多，实际真的如此吗？答案是不一定。下一篇文章我们将写一段代码来分析一下，LinkedList和ArrayList在删除元素时的真实效率。

以上我们说的删除用的是List的如下API

```java
public boolean remove(Object o);
```

LinkedList还有一种删除方式，用下标方式删除，如下

```java
public E remove(int index);
```

下一篇文章一起讲解。

> 注：示例中，用对象的方式来删除元素，只是想告诉大家，这种删除方式是用equals方法来查找元素进而删除的，实际工作中很少遇到需要new一个对象去删除的情况。**不建议一上来就重写equals方法，除非你有特殊的需求。如果重写了equals方法，请一并重写hashCode方法，这个问题在**[说说Java里的equals（中）](https://zhuanlan.zhihu.com/p/27741179)一文中已经说过了。