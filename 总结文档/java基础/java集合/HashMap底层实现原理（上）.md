# HashMap底层实现原理（上）

[![清浅池塘](https://pic1.zhimg.com/v2-a257d95d1e2985412e71ad98b0dddb6d_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/13641283343)

[清浅池塘](https://www.zhihu.com/people/13641283343)

知乎专栏《Java那些事儿》唯一作者，咨询前请先点详细资料

467 人赞同了该文章

修改记录：

2017年8月17日 12：00 调整了本文顺序，新增小结。



本来想先在专栏里简单的说一下**二叉树，红黑树**的内容后再说HashMap的，但看到评论区里不断的出现HashMap这个词，怕大家等得着急，本篇文章就先说说HashMap吧，前面讲ArrayList和LinkedList时把源码说得很细，只要理解了这两块内容，本篇内容也很好理解，先来看看HashMap在Map这个大家族中的位置。

![img](https://pic3.zhimg.com/80/v2-370407863f0bd9920d5f4354c14e10f2_1440w.png)

上图中，白色部分是接口，黄色部分是要重点了解的，最好是看一遍源码，绿色部分已经过时，不常用了，但是面试中可能会问到。这里先简单的说一下这几个Map，TreeMap是基于树的实现，HashMap，HashTable，ConcurrentHashMap是基于hash表的实现，下文我们会介绍hash表。HashTable和HashMap在代码实现上，基本上是一样的，和Vector与Arraylist的区别大体上差不多，一个是线程安全的，一个非线程安全，忘记了的朋友可以去看这篇文章，传送门：[Arraylist与Vector的区别](https://zhuanlan.zhihu.com/p/28241176)。ConcurrentHashMap也是线程安全的，但性能比HashTable好很多，HashTable是锁整个Map对象，而ConcurrentHashMap是锁Map的部分结构，LinkedHashMap后续会单独开文讲解。

![img](https://pic4.zhimg.com/80/v2-86fb98ad5b581207c7edfe7df2d56803_1440w.png)

Map其实很简单，就是一个key，对应一个value。本章我们重点了解HashMap，话不多说，上代码：

![img](https://pic4.zhimg.com/80/v2-79b9396d11047f9149cff4db29b1942f_1440w.png)

执行构造函数，当我们看到这个new，第一反应应该是这货又在堆内存里开辟了一块空间。

![img](https://pic2.zhimg.com/80/v2-d3002458d2aa7eae488b1eac859b457d_1440w.png)

构造函数如下：

![img](https://pic4.zhimg.com/80/v2-072866d4228c2baedbd7f0990deadeb7_1440w.png)

似乎简单，就是初始化了一个负载因子

![img](https://pic4.zhimg.com/80/v2-b62895e0e2848c2ce3bf644983cc8467_1440w.png)

负载因子默认为0.75f，这个负载因子后续会详说。

![img](https://pic1.zhimg.com/80/v2-28b066b8234baeb6049ed8dc5fb77178_1440w.png)

嘿嘿，又看到了传说中的数组，数组里原对象是Node，来看一下Node是什么鬼

![img](https://pic1.zhimg.com/80/v2-bdd2a7185dd34a792a22a7ed5f2a00a4_1440w.png)

其实很简单，一些属性，一个key，一个value，用来保存我们往Map里放入的数据，next用来标记Node节点的下一个元素。目前还没有任何代码用到Node，我们只能从成员变量入手了

![img](https://pic3.zhimg.com/80/v2-dfe2c93543f867d5991f9d2538503fc6_1440w.png)

这两个就不多说了吧，一个是逻辑长度，一个是修改次数，ArrayList，LinkedList也有这两个属性，老规矩，我们来画一画

![img](https://pic1.zhimg.com/80/v2-ccf84355bf67d0056d39c02c3c9feaa8_1440w.png)

HashMap我们就初始化好了，成员变量table数组默认为null，size默认为0，负载因子为0.75f，初始化完成，往里添加元素，来看一下put的源码

![img](https://pic2.zhimg.com/80/v2-32c5cf237260ffdbbcb530b2c35f76e9_1440w.png)

就一行代码，调用了putVal方法，其中key是传进来的“张三”这个字符串对象，value是“张三”这个Person对象，调用了一个方法hash()，再看一下

![img](https://pic4.zhimg.com/80/v2-cca84d1e4e485231187aa1a05ce0c21f_1440w.png)

看到了熟悉的hashCode，我们在前面的文章里已经强调过很多次了，**重写equals方法的时候，一定要重写hashCode方法，**因为key是基于hashCode来处理的。继续看putVal方法

![img](https://pic3.zhimg.com/80/v2-f9b024a4ab98249434f34b3da47b5c7e_1440w.png)

resize方法比较复杂，这儿就不完全贴出来了，**当放入第一个元素时，会触发resize方法的以下关键代码**

![img](https://pic4.zhimg.com/80/v2-b8477960fffdd25bcee45ff8b376dbc7_1440w.png)

再看这个DEFAULT_INITIAL_CAPACITY是什么东东

![img](https://pic2.zhimg.com/80/v2-6f3c427a805f2bdbe33c48c1ab2482f9_1440w.png)

又是传说中的移位运算符，1 << 4 其实就是相当于16。

![img](https://pic3.zhimg.com/80/v2-b8dcf45c7061e55e7c7057794af9102e_1440w.png)

恩，这句是关键，当我们放入第一个元素时，如果底层数组还是null，系统会初始化一个长度为16的Node数组，像极了ArrayList的初始化。

![img](https://pic4.zhimg.com/80/v2-e2226e9be747e12869fef4ce065ef307_1440w.png)

最后返回new出来的数组，继续画图，由于篇幅有限，下图中省略了部分数组内容，注意，虽然数组长度为16，但逻辑长度size依然是0

![img](https://pic4.zhimg.com/80/v2-a5bc058ef6e122b7085f5833b789b847_1440w.png)

继续执行下图中putVal方法里的红框内容

![img](https://pic1.zhimg.com/80/v2-0a576b8567148274bafc09171bb7d924_1440w.png)

```java
if ((p = tab[i = (n - 1) & hash]) == null)
    tab[i] = newNode(hash, key, value, null);
```

这段代码初学者可能看起来比较费劲，我们重写一下以便初学者能更好的理解，这两段代码等同，下面是重写后的代码，清晰了很多

```java
i = (n - 1) & hash;//hash是传过来的，其中n是底层数组的长度，用&运算符计算出i的值 
p = tab[i];//用计算出来的i的值作为下标从数组中元素
if(p == null){//如果这个元素为null，用key,value构造一个Node对象放入数组下标为i的位置
     tab[i] = newNode(hash, key, value, null);
}
```

这个hash值是字符串“张三”这个对象的hashCode方法与hashMap提供hash()方法共同计算出来的结果，其中n是数组的长度，目前数组长度为16，不管这个hash的值是多少，经过(n - 1) & hash计算出来的i 的值一定在n-1之间。刚好是底层数组的合法下标，用i这个下标值去底层数组里去取值，如果为null，创建一个Node放到数组下标为i的位置。这里的“张三”计算出来的i的值为2，继续画图

![img](https://pic3.zhimg.com/80/v2-615057d80fb2735f7438d28b008d186a_1440w.png)

继续添加元素“李四”，“王五”，“赵六”，一切正常，key：“李四”经过(n - 1) & hash算出来在数组下标位置为1，“王五”为7，“赵六”为9，添加完成后如下图

![img](https://pic2.zhimg.com/80/v2-7e153fed3f38e5ecae1695e4e3dcc43d_1440w.png)

上图更趋近于堆内存中的样子，但看起来比较复杂，我们简化一下

![img](https://pic1.zhimg.com/80/v2-547dc3be6f255a7d187149029f707470_1440w.png)

上图是简化后的堆内存图。继续往里添加“孙七”，**通过(n - 1) & hash计算“孙七”这个key时计算出来的下标值是1，而数组下标1这个位置目前已经被“李四”给占了，产生了冲突**。相信大家在看本文的过程中也有这样的疑惑，万一计算出来的下标值i重了怎么办？我们来看一看HashMap是怎么解决冲突的。

![img](https://pic4.zhimg.com/80/v2-179a642ad79b2f838c2ef96b96d4b597_1440w.png)

上图中红框里就是冲突的处理，这一句是关键

```java
p.next = newNode(hash, key, value, null);
```

也就是说new一个新的Node对象并把当前Node的next引用指向该对象，也就是说原来该位置上只有一个元素对象，现在**转成了单向链表，**继续画图

![img](https://pic4.zhimg.com/80/v2-6cc8d894314633d7d8a6d5b3f630338b_1440w.png)

继续添加其它元素，添加完成后如下

![img](https://pic4.zhimg.com/80/v2-53b0495f2a6c5590ad576e7838bceac7_1440w.png)

到这里，我们的元素就添加完了。我们debug看一下

![img](https://pic4.zhimg.com/80/v2-0565f2606334b1f138061f9933fbf5d3_1440w.png)

大框里的内容是链表的体现，小框里的内容是单元素的体现。

红框中还有两行比较重要的代码

```java
if (binCount >= TREEIFY_THRESHOLD - 1) //当binCount>=TREEIFY_THRESHOLD-1
      treeifyBin(tab, hash);//把链表转化为红黑树
```

再看看TREEIFY_THRESHOLD的值

![img](https://pic1.zhimg.com/80/v2-8d91e6d53192ae04c1f7088f74b7ffd0_1440w.png)

当**链表长度到8时，将链表转化为红黑树来处理，**由于**树**相关的内容本专栏还未讲解，红黑树的内容这里就不深入了。树在内存中的样子我们还是画个图简单的了解一下

![img](https://pic4.zhimg.com/80/v2-d3033bb70561cbfb1209a3bc02196243_1440w.png)

在JDK1.7及以前的版本中，HashMap里是没有红黑树的实现的，在JDK1.8中加入了红黑树是为了防止**哈希表碰撞攻击，当链表链长度为8时，及时转成红黑树，提高map的效率。**在面试过程中，能说出这一点，面试官会对你加分不少。

> 注：本章所讲的**移位运算符**（如：“<<”）、**位运算符**（如：“&”），**红黑树**、**哈希表碰撞攻击等，**这里不做详解，大家有兴趣的话请在评论区留言，响应的人多的话，会单独开文讲解。

思考下面代码：

![img](https://pic3.zhimg.com/80/v2-121960095d7008759e0d0c60707f1b1a_1440w.png)

hash方法的实现：

![img](https://pic4.zhimg.com/80/v2-b9f185fd4c560687a15d3ceed5d8e443_1440w.png)

在put放入元素时，HashMap又自己写了一个hash方法来计算hash值，大家想想看，为什么不用key本身的hashCode方法，而是又处理了一下？

本文到这里先告一个段落，先做一个**小结**。

**HashMap**的最底层是**数组**来实现的，数组里的元素可能为**null**，也有可能是**单个对象**，还有可能是**单向链表**或是**红黑树**。

**文中的resize在底层数组为null的时候会初始化一个数组，不为null的情况下会去扩容底层数组，并会重排底层数组里的元素。**



如果喜欢本系列文章，请为我点赞或顺手分享，您的支持是我继续下去的动力，您也可以在评论区留言想了解的内容，有机会本专栏会做讲解，最后别忘了关注一下我。

上一篇：[动手写一个简单的Map - 知乎专栏](https://zhuanlan.zhihu.com/p/28525770)

下一篇：[HashMap底层实现原理（下） - 知乎专栏](https://zhuanlan.zhihu.com/p/28587782)

## [HashMap底层实现原理（下）](https://zhuanlan.zhihu.com/p/28587782)

作者：清浅池塘
链接：https://zhuanlan.zhihu.com/p/28587782
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



上一篇文章我们介绍了HashMap的底层实现，但还遗留了一点内容，我们再回顾一下上一篇文章里说的内容

![img](https://pic3.zhimg.com/v2-a3ded9921f8c1685af84511dc4312826_b.png)![img](https://pic3.zhimg.com/80/v2-a3ded9921f8c1685af84511dc4312826_1440w.png)

执行完红框里的代码，personMap里放入了8个元素，放置完成后在堆内存表现如下图

![img](https://pic2.zhimg.com/v2-6b3b689dc578ad3d222f30f4e7a947e5_b.png)![img](https://pic2.zhimg.com/80/v2-6b3b689dc578ad3d222f30f4e7a947e5_1440w.png)

如果忽略底层实现细节，是这样的

![img](https://pic3.zhimg.com/v2-b27dbb0f2427c508452c927ef88f263e_b.png)![img](https://pic3.zhimg.com/80/v2-b27dbb0f2427c508452c927ef88f263e_1440w.png)

在Map中，一个key，对应了一个value，如果key的值已经存在，Map会直接替换value的内容，来看一下源码中是怎么实现的，来看以下代码

```java
Person oldPerson1 = personMap.put("张三", new Person("新张三", 21));
Person oldPerson2 = personMap.put("孙七", new Person("新孙七", 32));

System.out.println("oldPerson1.getName() ：" + oldPerson1.getName());
System.out.println("oldPerson2.getName() : " + oldPerson2.getName());
System.out.println("personMap.size() : " + personMap.size());
```

new了一个Person“新张三”，注意，key依然是张三，看一下源码

![img](https://pic4.zhimg.com/v2-8ef51193ddf22f3e3e04b2467dfc4c47_b.png)![img](https://pic4.zhimg.com/80/v2-8ef51193ddf22f3e3e04b2467dfc4c47_1440w.png)

放入“新张三”时，会执行以上代码1、2、5

```java
if ((p = tab[i = (n - 1) & hash]) == null)
    tab[i] = newNode(hash, key, value, null);
```

上面这段代码在上一篇文章已经改写过了，改写后的代码如下：

```java
i = (n - 1) & hash;//hash是传过来的，其中n是底层数组的长度，用&运算符计算出i的值 
p = tab[i];//用计算出来的i的值作为下标从数组中元素
if(p == null){//这儿P不为null，所以下面这行代码不会执行。
     tab[i] = newNode(hash, key, value, null);//这行代码不会执行
}
```

很简单，直接在底层数组里取值赋值给p，由于p不为null，执行else里的逻辑

```java
Node<K,V> e; K k;
if (p.hash == hash &&  //如果hash值相等，key也相等，或者equals相等，赋值给e
     ((k = p.key) == key || (key != null && key.equals(k))))
      e = p;//赋值给e
```

又看到了**熟悉的equals方法，**这里我们hash值相等，key的值也相等，条件成立，把值赋值给e。（如果key的值不相等，就比较equals方法，**也就是说，就算key是一个新new出来的对象，只要满足equals，也视为key相同**）

```java
if (e != null) { // existing mapping for key
     V oldValue = e.value;//定义一个变量来存旧值
     if (!onlyIfAbsent || oldValue == null)
     e.value = value;//把value的值赋值为新的值
     afterNodeAccess(e);
     return oldValue;//返回的值
}
```

这段代码就比较简单了，用新的value替换旧value并返回旧的value。画一下图

![img](https://pic2.zhimg.com/v2-7e21361bde2d80d7627cdc5c2b92f779_b.png)![img](https://pic2.zhimg.com/80/v2-7e21361bde2d80d7627cdc5c2b92f779_1440w.png)

再new一个Person“新孙七”并put到personMap中，注意，key依然是“孙七”，会执行图17-2里的1、2、3、4、5，由于2、3不满足条件，实际执行的是1、4、5，1这一步已经说过了，重点说一下4这一步

```java
for (int binCount = 0; ; ++binCount) {//循环
    if ((e = p.next) == null) {//如果循环到最后也没找到，把元素放到最后
        p.next = newNode(hash, key, value, null);//把元素放到最后
        if (binCount >= TREEIFY_THRESHOLD - 1) //如果长度超>=8，转换成红黑树
            treeifyBin(tab, hash);//转换成红黑树
            break;
        }
        if (e.hash == hash && //这段代码和第2步一样
            ((k = e.key) == key || (key != null && key.equals(k))))
            break;
            p = e;//如果hash值相等，key也相等或者equals相等，赋值给e
        }
    }
}
```

其实就是循环链表的节点，直到找到"孙七"这个key，然后执行图17-2里的第5步，如果找不到，就添加到最后，这里我们key是“孙七”，在链表中找到元素替换value即可，再画一下图

![img](https://pic2.zhimg.com/v2-e47934696f1c1906c5e71e18ffcb7d5d_b.png)![img](https://pic2.zhimg.com/80/v2-e47934696f1c1906c5e71e18ffcb7d5d_1440w.png)

最后来看看放到树里的方法putTreeVal，由于树的内容我们还没涉及到，下面只标注出了关键代码

![img](https://pic1.zhimg.com/v2-fdb42cc9817f67d538d3bc0042345c3c_b.png)![img](https://pic1.zhimg.com/80/v2-fdb42cc9817f67d538d3bc0042345c3c_1440w.png)

和链表类似，循环（遍历）树的节点，如果找到节点，返回节点，执行图17-2里的第5步更新value。如果循环完整颗数都找不到相应的key，添加新节点。

最后我们看一下本文初那段示例代码的执行结果：

![img](https://pic1.zhimg.com/v2-adf205600811b1ea4d10c26c9262da44_b.png)![img](https://pic1.zhimg.com/80/v2-adf205600811b1ea4d10c26c9262da44_1440w.png)

虽然元素已经替换成新的值，但示例中打印的是替换前的值，元素个数还是8不变，debug看一下，是不是value更新成功了

![img](https://pic1.zhimg.com/v2-282fd1d565c83b0e65a31516a92cf44c_b.png)![img](https://pic1.zhimg.com/80/v2-282fd1d565c83b0e65a31516a92cf44c_1440w.png)

更新已经成功。



结合上一篇内容，做一个总结，在hashMap中放入（put）元素，有以下重要步骤：

1、计算key的hash值，算出元素在底层数组中的下标位置。

2、通过下标位置定位到底层数组里的元素（也有可能是链表也有可能是树）。

3、取到元素，判断放入元素的key是否==或equals当前位置的key，成立则替换value值，返回旧值。

4、如果是树，循环树中的节点，判断放入元素的key是否==或equals节点的key，成立则替换树里的value，并返回旧值，不成立就添加到树里。

5、否则就顺着元素的链表结构循环节点，判断放入元素的key是否==或equals节点的key，成立则替换链表里value，并返回旧值，找不到就添加到链表的最后。

精简一下，判断放入HashMap中的元素要不要替换当前节点的元素，key满足以下两个条件即可替换：

**1、hash值相等。**

**2、==或equals的结果为true。**



由于hash算法依赖于对象本身的hashCode方法，所以对于HashMap里的元素来说，**hashCode方法与equals方法非常的重要，**这也是在[说说Java里的equals（中）](https://zhuanlan.zhihu.com/p/27741179)一文中强调重写对象的equals方法一定要重写hashCode方法的原因，不重写的话，放到HashMap中可能会得不到你想要的结果！本示例中放入的key是String类型的，String这个类已经重写了hashCode方法，有兴趣的朋友可以自行查看源码。

如果喜欢本系列文章，请为我点赞或顺手分享，您的支持是我继续下去的动力，您也可以在评论区留言想了解的内容，有机会本专栏会做讲解，最后别忘了关注一下我。



# 浅谈Java8的HashMap的扩容策略

**PS：本文基于JDK8的源码进行分析**

进行扩容，会伴随着一次重新hash分配，并且会遍历hash表中所有的元素，是非常耗时的。在编写程序中，要尽量避免resize。

**JDK1.8以后在解决哈希冲突时有了较大的变化，当链表长度大于阈值（默认为8）（将链表转换成红黑树前会判断，如果当前数组的长度小于 64，那么会选择先进行数组扩容，而不是转换为红黑树）时，将链表转化为红黑树，以减少搜索时间**

前几天看到一个问题HashMap是先扩容后插入还是先插入后扩容？这样选取的优势是什么？，恰好自己最近在看了一下HashMap源码，答案是：先插入后扩容。

对后面一个问题感觉有点懵我刚开始想的是，如果先增加数据总量，万一数据还没有完全写入，就被读取那就就是读取到脏数据(多线程并发读取写入)。又一想，HashMap本来就是线程不安全的，并发用HashMap的简直就是给自己挖坑的，我前面也有文章分析过[浅谈Java8的HashMap为什么线程不安全](https://blog.csdn.net/lovepluto/article/details/79712473)，如果单线程好像先扩容还是后扩容没有区别吧，反正都会顺序执行的。带着疑问我又仔细研究了一下HashMap的实现。
先上一段源码。

```
    public V put(K key, V value) {
        return putVal(hash(key), key, value, false, true);
    }123
    final V putVal(int hash, K key, V value, boolean onlyIfAbsent,
                   boolean evict) {
        Node<K,V>[] tab; Node<K,V> p; int n, i;
        if ((tab = table) == null || (n = tab.length) == 0)
            n = (tab = resize()).length;
        if ((p = tab[i = (n - 1) & hash]) == null)
            tab[i] = newNode(hash, key, value, null);
        else {
            Node<K,V> e; K k;
            if (p.hash == hash &&
                ((k = p.key) == key || (key != null && key.equals(k))))
                e = p;
            else if (p instanceof TreeNode)
                e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
            else {
                for (int binCount = 0; ; ++binCount) {
                    if ((e = p.next) == null) {
                        p.next = newNode(hash, key, value, null);
                        if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
                            treeifyBin(tab, hash);
                        break;
                    }
                    if (e.hash == hash &&
                        ((k = e.key) == key || (key != null && key.equals(k))))
                        break;
                    p = e;
                }
            }
            if (e != null) { // existing mapping for key
                V oldValue = e.value;
                if (!onlyIfAbsent || oldValue == null)
                    e.value = value;
                afterNodeAccess(e);
                return oldValue;
            }
        }
        ++modCount;
        if (++size > threshold)
            resize();
        afterNodeInsertion(evict);
        return null;
    }123456789101112131415161718192021222324252627282930313233343536373839404142
```

**为什么是先增加后扩容？**

有这么一段源码

```
            if (e != null) { // existing mapping for key
                V oldValue = e.value;
                if (!onlyIfAbsent || oldValue == null)
                    e.value = value;
                afterNodeAccess(e);
                return oldValue;
            }1234567
```

源码已经很清楚的表达的扩容原因，调用put不一定是新增数据，还可能是覆盖掉原来的数据，这里就存在了一个key的比较问题。以先扩容为例，先比较是否是新增的数据，在比较是否需要增加数据后扩容，这样比较会浪费时间，而后扩容，就在中途直接通过return返回了，根本执行不到是否扩容，这样可以提高效率的。肯定有人说，像堆栈之类的特殊数据结构一般都是先判断是否存满的，万一数组存满越界了怎么办？

我们来看看扩容条件

```
        if (++size > threshold)
            resize();12
```

是size和threshold比较，估计很多都会好奇threshold变量是什么的？

```
    /**
     * The next size value at which to resize (capacity * load factor).
     *
     * @serial
     */
    // (The javadoc description is true upon serialization.
    // Additionally, if the table array has not been allocated, this
    // field holds the initial array capacity, or zero signifying
    // DEFAULT_INITIAL_CAPACITY.)
    int threshold;12345678910
```

简单的说就是一个容积数，用来调控是否扩张容器的。这个数据是怎么计算来的？

```
    final Node<K,V>[] resize() {
        Node<K,V>[] oldTab = table;
        int oldCap = (oldTab == null) ? 0 : oldTab.length;
        int oldThr = threshold;
        int newCap, newThr = 0;
        if (oldCap > 0) {
            if (oldCap >= MAXIMUM_CAPACITY) {
                threshold = Integer.MAX_VALUE;
                return oldTab;
            }
            else if ((newCap = oldCap << 1) < MAXIMUM_CAPACITY &&
                     oldCap >= DEFAULT_INITIAL_CAPACITY)
                newThr = oldThr << 1; // double threshold
        }
        else if (oldThr > 0) // initial capacity was placed in threshold
            newCap = oldThr;
        else {               // zero initial threshold signifies using defaults
            newCap = DEFAULT_INITIAL_CAPACITY;
            newThr = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);
        }
        if (newThr == 0) {
            float ft = (float)newCap * loadFactor;
            newThr = (newCap < MAXIMUM_CAPACITY && ft < (float)MAXIMUM_CAPACITY ?
                      (int)ft : Integer.MAX_VALUE);
        }
        threshold = newThr;
        @SuppressWarnings({"rawtypes","unchecked"})
            Node<K,V>[] newTab = (Node<K,V>[])new Node[newCap];
        table = newTab;
        //省略了部分容器数据拷贝代码
        return newTab;
    }1234567891011121314151617181920212223242526272829303132
```

resize()方法是用来扩大容器，每次都是在原来的基础上翻一倍。这不是重点，重点是threshold的赋值，可以明显看出如果是默认赋值大概是12的，如果不是那么就是在原来的基础上面左移一位，也就是翻倍的。

```
  newThr = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);1
  newThr = oldThr << 1; // double threshold1
  threshold = newThr;1
```

看看两个常量吧

```
    static final int DEFAULT_INITIAL_CAPACITY = 1 << 4; // aka 16
    static final float DEFAULT_LOAD_FACTOR = 0.75f;12
```

这是默认大小，这两个参数可以通过构造方法直接设置的。

```
    public HashMap(int initialCapacity, float loadFactor) {
        if (initialCapacity < 0)
            throw new IllegalArgumentException("Illegal initial capacity: " +
                                               initialCapacity);
        if (initialCapacity > MAXIMUM_CAPACITY)
            initialCapacity = MAXIMUM_CAPACITY;
        if (loadFactor <= 0 || Float.isNaN(loadFactor))
            throw new IllegalArgumentException("Illegal load factor: " +
                                               loadFactor);
        this.loadFactor = loadFactor;
        this.threshold = tableSizeFor(initialCapacity);
    }
    public HashMap(int initialCapacity) {
        this(initialCapacity, DEFAULT_LOAD_FACTOR);
    }123456789101112131415
```

HashMap这种数据结构对数据量比较小的时候处理很容易的，一旦数据量大了，在这个扩容策略之下，对内容的消耗是非常恐怖的，而且默认会又1/4的空间会被浪费掉，说浪费好像也不太准确的，因为hash算法需要足够的容量来处理hash冲突的。

总结：看源码确实是一种享受，好多可能出现的问题全部都给你想好了，并且附带了一些优秀的实现。

```java
final Node<K,V>[] resize() {
    Node<K,V>[] oldTab = table;
    int oldCap = (oldTab == null) ? 0 : oldTab.length;
    int oldThr = threshold;
    int newCap, newThr = 0;
    if (oldCap > 0) {
        // 超过最大值就不再扩充了，就只好随你碰撞去吧
        if (oldCap >= MAXIMUM_CAPACITY) {
            threshold = Integer.MAX_VALUE;
            return oldTab;
        }
        // 没超过最大值，就扩充为原来的2倍
        else if ((newCap = oldCap << 1) < MAXIMUM_CAPACITY && oldCap >= DEFAULT_INITIAL_CAPACITY)
            newThr = oldThr << 1; // double threshold
    }
    else if (oldThr > 0) // initial capacity was placed in threshold
        newCap = oldThr;
    else { 
        // signifies using defaults
        newCap = DEFAULT_INITIAL_CAPACITY;
        newThr = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);
    }
    // 计算新的resize上限
    if (newThr == 0) {
        float ft = (float)newCap * loadFactor;
        newThr = (newCap < MAXIMUM_CAPACITY && ft < (float)MAXIMUM_CAPACITY ? (int)ft : Integer.MAX_VALUE);
    }
    threshold = newThr;
    @SuppressWarnings({"rawtypes","unchecked"})
        Node<K,V>[] newTab = (Node<K,V>[])new Node[newCap];
    table = newTab;
    if (oldTab != null) {
        // 把每个bucket都移动到新的buckets中
        for (int j = 0; j < oldCap; ++j) {
            Node<K,V> e;
            if ((e = oldTab[j]) != null) {
                oldTab[j] = null;
                if (e.next == null)
                    newTab[e.hash & (newCap - 1)] = e;
                else if (e instanceof TreeNode)
                    ((TreeNode<K,V>)e).split(this, newTab, j, oldCap);
                else { 
                    Node<K,V> loHead = null, loTail = null;
                    Node<K,V> hiHead = null, hiTail = null;
                    Node<K,V> next;
                    do {
                        next = e.next;
                        // 原索引
                        if ((e.hash & oldCap) == 0) {
                            if (loTail == null)
                                loHead = e;
                            else
                                loTail.next = e;
                            loTail = e;
                        }
                        // 原索引+oldCap
                        else {
                            if (hiTail == null)
                                hiHead = e;
                            else
                                hiTail.next = e;
                            hiTail = e;
                        }
                    } while ((e = next) != null);
                    // 原索引放到bucket里
                    if (loTail != null) {
                        loTail.next = null;
                        newTab[j] = loHead;
                    }
                    // 原索引+oldCap放到bucket里
                    if (hiTail != null) {
                        hiTail.next = null;
                        newTab[j + oldCap] = hiHead;
                    }
                }
            }
        }
    }
    return newTab;
}
```