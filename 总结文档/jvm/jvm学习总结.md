####  jvm2学习总结

#####  1、什么是垃圾？

没有任何引用指向的对象或者多个对象（循环调用）  指的是在堆内存中的对象，栈中没有指向的对象

![image-20200701221308825](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200701221308825.png)

![image-20200701221350352](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200701221350352.png)

![image-20200701221408906](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200701221408906.png)

#####  2、如何定位垃圾？

**引用计数**：栈空间的数据指向堆内存中的数据的时候，给这个对象添加1，有几个引用添加1，减少了引用就减少1，但是存在循环引用，但是栈空间没有指向。内存会泄露。

**根可达性算法**：什么是根对象？线程栈变量 譬如main方法创建的变量   静态变量   常量池  JNI指针  这些根对象里面的成员变量都不是垃圾

这个算法的基本思路就是通过一系列的称谓“GC Roots”的对象作为起始点，从这些节点开始向下搜索，搜索所走过的路称为引用链，当一个对象到GC Roots没有任何引用链相连的时候，（用图论的话来说）即从GC Roots到这个对象不可达，则证明这个对象是不可用的。

举个例子：

<img src="https://img-blog.csdnimg.cn/20181212234700490.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1NlYXJjaGluX1I=,size_16,color_FFFFFF,t_70" alt="img" style="zoom:50%;" />

从上图我们可以看到，对象Object5、Object6、Object7、虽然相互间有关联，但是它们到GC Roots是不可达的，因此他们将会被判定为可回收的对象。在Java语言中，可以作为GC Roots的对象包括以下几种

- **虚拟机栈（栈帧中的本地变量表）中引用的对象。**
- **方法区中类静态属性引用的对象。**
- **方法区中常量引用的对象。**
- **本地方法栈中JNI（即一般说的Native方法）引用的对象。**

上文说到可达性分析算法中不可达的对象就是可回收，那么它一定会被回收吗？

其实，即使再可达性分析算法中不可达的对象，它们也并非是“非死不可”的。这种情形好比咱们在生活中经常见的情况：（假设本帅松是一名警察）在经过一系列的排查之后，我们在人海中抓住一个嫌疑犯，这个时候我们要把他抓回警局，但却不能立马将他定位犯罪者。虽然种种迹象都表明他与本案有关，但是他此时仍然是一个嫌疑犯，还没有下定论，等到断定此人就是此案的犯罪者的时候，这个时候才可以将它移送到相关机构接受审判并定罪。

对于可达性分析算法中不可达的对象，它们也不会立刻就被回收，这个时候它们暂时处于“嫌疑人”状态，到真正宣告一个对象死亡，至少要经历两次标记过程。

```
如果对象在进行可达性分析之后被发现没有与GC Roots相连的引用链，那么它将会被第一次标记，并且进行一次筛选，筛选的条件就是此对象是否有必要执行finalize()方法。
```

如果对象在进行可达性分析之后被发现没有与GC Roots相连的引用链，那么它将会被第一次标记，并且进行一次筛选，筛选的条件就是此对象是否有必要执行finalize()方法。
以下两种情况虚拟机将视为没有必要执行finalize()方法：

```
当对象没有覆盖finalize()方法
finalize()方法已经被虚拟机调用过
```

finalize()是Object中的方法，当垃圾回收器将要回收对象所占内存之前被调用，即当一个对象被虚拟机宣告死亡时会先调用它finalize()方法，让此对象处理它生前的最后事情（这个对象可以趁这个时机挣脱死亡的命运）。

最后的救赎
上面提到了判断死亡的依据，但被判断死亡后，还有生还的机会。
**如何自我救赎：**
1.对象覆写了finalize()方法（这样在被判死后才会调用此方法，才有机会做最后的救赎）；
2.在finalize()方法中重新引用到"GC  Roots"链上（如把当前对象的引用this赋值给某对象的类变量/成员变量，重新建立可达的引用）.




如果这个对象被判定为有必要执行finalize()方法，那么这个对象就会被放置在一个叫做F-Queue的队列中，并在稍后由一个由虚拟机自动建立的、低优先级的Finalizer线程去执行它。

这里所说的“执行”是指虚拟机会触发这个方法，但是并不承诺会等待它执行完毕。为什么呢？

你想，如果一个对象在finalize()方法中执行缓慢，或者发生了死循环（甚至其它更加极端的情况），将很可能会导致F-Queue队列中其他对象永久处于等待状态，甚至可能导致整个内存回收系统奔溃。

finalize()方法是对象逃脱死亡命运的最后一次机会。因为在执行了finalize()方法之后，GC将会对F-Queue队列中的对象进行第二次小规模的标记，如果对象能够在finalize()中成功地拯救自己，即只要重新与引用链上的任一对象建立关联即可，比如将自己（this关键字）赋值给某一个类变量或者对象的成员变量，那么在第二次标记的时候，它就会被移出“即将回收”的集合，即移出F-Queue队列。如果这个时候，对象还没有逃脱，那么它就基本上就要被回收了。


#####  3、常见的垃圾回收算法

**标记清楚** ： 位置不联系  产生碎片

**标记压缩** ：效率低  没有碎片 将垃圾的内存清除，把存活的对象copy到新内存中

**拷贝**：把内存划分两部分，一个部分使用，标记完垃圾之后，将垃圾copy到另一个区域，两个部分相互之间相互copy 。优点：没有碎片 但是浪费空间 

#####  4、jvm内存分代模型（用于分代垃圾回收）

![image-20200701221457717](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200701221457717.png)

1、新生到+老年代+永久代（1.7）/元空间（1.8）

永久带：Class

2、堆内存分区

新生代：1：3 老年代

新生代： eden  : survivor :survivor  = 8:1:1

**新生代**

new 对象的过程：

1、首先在eden区申请内存，如果比较搭，直接升级到老年代

2、YGC垃圾回收时，大部分对象会被回收，将近90%吧，活着的进s0

3、再次YGC垃圾回收时，活着的eden+s0 ->进入s1

4、再次YGC垃圾回收时，活着的eden+s1 ->进入s0

5、年龄足够进入老年代 （分代年龄15）

6、s区装不小的直接->老年代

**老年代**

1、顽固份子

2、老年代满了->Full GC(对整个堆内存进行垃圾回收)效率很慢，会产生卡顿现象 ，尽量降低full gc  **一个月一次 **

可以接受

**JVM调优就是调节full GC**

#####  5、圾回收器



![image-20200701221137702](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200701221137702.png)

**Serial**

![image-20200701221753054](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200701221753054.png)

当很多用户线程正在运行时，发生了YFullGC 的时候，线程全部stop，单线程执行垃圾回收。程序就会出现卡顿现象

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200707110749089.png" alt="image-20200707110749089" style="zoom:50%;" />

​	当很多用户线程正在运行时，发生了YFullGC 的时候，线程全部stop，多线程执行垃圾回收。程序就会出现卡顿现象

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200707110859589.png" alt="image-20200707110859589" style="zoom:67%;" />

​	当很多用户线程正在运行时，发生了YFullGC 的时候，线程不会停止，多线程执行垃圾回收。程序就会出现卡顿现象











![image-20200701222449732](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200701222449732.png)

具体调优前五种

<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200713102231626.png" alt="image-20200713102231626" style="zoom: 50%;" />![image-20200713102515423](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200713102515423.png)	