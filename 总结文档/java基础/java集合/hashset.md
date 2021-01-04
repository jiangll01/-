

这篇文章我们先轻松一下，不讲HashMap，来说说HashSet。如果有点Java基础的童鞋，应该都知道List和Set都实现自Collection，List保证元素的添加顺序，元素可重复。而Set不保证元素的添加顺序，元素不可重复

![img](https://pic3.zhimg.com/v2-71834e8f9e9581987087113a3ba10abe_b.png)![img](https://pic3.zhimg.com/80/v2-71834e8f9e9581987087113a3ba10abe_1440w.png)

先来看看Set家族在Collection中的位置，红框里的内容就是Set的大家族了，Set接口继承自Collection。有两个很重要的实现HashSet和TreeSet。其中黄色部分前面已经说过了是要重点了解的，老规矩，上代码，大家可以先想一想以下代码的执行结果。

```java
public static void main(String[] args){
	Set<String> strSet = new HashSet<>();//new了一个HashSet
	strSet.add("张三");
	strSet.add("李四");
	strSet.add("王五");
	strSet.add("赵六");
		
	System.out.println("strSet : " + strSet);
	System.out.println("strSet.size() : " + strSet.size());
	System.out.println("strSet里是否为空 : " + strSet.isEmpty());
		
	System.out.println("删除王五。。。。");
	boolean delFlag = strSet.remove("王五");
	System.out.println("删除王五是否成功" + delFlag);
	System.out.println("删除王五后的strSet : " + strSet);
	System.out.println("strSet中是否包含王五：" + strSet.contains("王五"));
	System.out.println("strSet中是否包含张三：" + strSet.contains("张三"));
		
	System.out.println("clear清除元素...");
	strSet.clear();
	System.out.println("clear清除元素后的strSet : " + strSet);
	System.out.println("strSet长度 : " + strSet.size());
	System.out.println("strSet里是否为空 : " + strSet.isEmpty());
		
}
```

先来看第一行代码：

```java
Set<String> strSet = new HashSet<>();//new了一个HashSet
```

new了一个HashSet，前面的文章已经说过很多次了，只要是看到new，这货肯定在堆内存里开辟了一块空间，先找到HashSet的构造函数看看，看到如下代码：

![img](https://pic3.zhimg.com/v2-be2a9850a450a589de4266b109505e5e_b.png)![img](https://pic3.zhimg.com/80/v2-be2a9850a450a589de4266b109505e5e_1440w.png)

等等，怎么出现了HashMap，这个HashMap到底是什么鬼？再看一下map，追踪一下

![img](https://pic4.zhimg.com/v2-cb835a76a4c6ccae48e38a4ba163be93_b.png)![img](https://pic4.zhimg.com/80/v2-cb835a76a4c6ccae48e38a4ba163be93_1440w.png)

就是一个HashMap，老规矩画图吧

![img](https://pic1.zhimg.com/v2-de878a321bb7b493db636b650c481ebc_b.png)![img](https://pic1.zhimg.com/80/v2-de878a321bb7b493db636b650c481ebc_1440w.png)

HashMap的初始化在[HashMap底层实现原理（上）](https://zhuanlan.zhihu.com/p/28501879)一文中已经说过了，这里就不再详解了，需要了解的朋友请自行回顾。继续执行以下代码，往strSet添加元素"张三"

```java
strSet.add("张三");	
```

再看add方法

![img](https://pic4.zhimg.com/v2-1ce1986255b958d60c4c62cf7c49edab_b.png)![img](https://pic4.zhimg.com/80/v2-1ce1986255b958d60c4c62cf7c49edab_1440w.png)

上面红框里的这行代码和等同于

```java
boolean putFlag = map.put(e,PRESENT);
return putFlag;
```

原来就是调用底层HashMap的put方法，把"张三"作为key，PRESENT作为value放在hashMap里，讲HashMap的时候讲过了，如果put时key重了，会返回被覆盖的value值（oldValue），否则返回null，这儿的HashSet又给包装了一下，如果key没有重（oldValue == null），就返回true，否则返回false。继续看这个PRESENT是什么鬼

![img](https://pic3.zhimg.com/v2-5d0c711e51209c97caf531af8e3cbe7a_b.png)![img](https://pic3.zhimg.com/80/v2-5d0c711e51209c97caf531af8e3cbe7a_1440w.png)

很简单就是new了一个Object，继续画图

![img](https://pic4.zhimg.com/v2-3606ff8051091f671369614f16eec973_b.png)![img](https://pic4.zhimg.com/80/v2-3606ff8051091f671369614f16eec973_1440w.png)

调用底层HashMap的时候，key是传进去的“张三”，value是PRESENT，也就是一个Object对象，继续往里添加“李四”，“王五”，“赵六”

```java
strSet.add("李四");
strSet.add("王五");
strSet.add("赵六");	
```

依次放入“李四”，“王五”，“赵六”，value都是一样的，为PRESENT，继续画图

![img](https://pic3.zhimg.com/v2-dfc47fe7f4ead4f33c8e1e4add16904a_b.png)![img](https://pic3.zhimg.com/80/v2-dfc47fe7f4ead4f33c8e1e4add16904a_1440w.png)

所有元素的value都指向Object对象，HashSet虽然底层是用HashMap来实现的，但由于用不到HashMap的value，所以不会为底层HashMap的每个value分配一个内存空间，因此并不会过多的占用内存，请放心使用。

再来看看示例代码里的size()、isEmpty()、remove()、contains()、clear()等方法的实现

![img](https://pic4.zhimg.com/v2-821f51facf107f11be0c3993a7a6ba53_b.png)![img](https://pic4.zhimg.com/80/v2-821f51facf107f11be0c3993a7a6ba53_1440w.png)

调用的是底层HashMap的size方法

![img](https://pic1.zhimg.com/v2-b2cfa61787b95c40dc073737e90327dc_b.png)![img](https://pic1.zhimg.com/80/v2-b2cfa61787b95c40dc073737e90327dc_1440w.png)

调用的是底层HashMap的isEmpty方法

![img](https://pic2.zhimg.com/v2-82194115a67155caf60a8a2377077339_b.png)![img](https://pic2.zhimg.com/80/v2-82194115a67155caf60a8a2377077339_1440w.png)

调用的是底层HashMap的remove方法

![img](https://pic3.zhimg.com/v2-c110699bfe9464dba0cf027706d6ea3e_b.png)![img](https://pic3.zhimg.com/80/v2-c110699bfe9464dba0cf027706d6ea3e_1440w.png)

调用的是底层HashMap的contains方法

![img](https://pic3.zhimg.com/v2-93dffd4fd69c67e1d2a71aedf3724f86_b.png)![img](https://pic3.zhimg.com/80/v2-93dffd4fd69c67e1d2a71aedf3724f86_1440w.png)

调用的是HashMap的clear方法。

这些方法基本上没什么逻辑代码，就是复用了HashMap里的方法而已。**HashSet就是利用HashMap来实现的。这时候我们大胆的猜测一下，TreeSet是不是也是用TreeMap来实现的呢？**迫不及待打开TreeSet的源码

![img](https://pic3.zhimg.com/v2-980181946a542c11bacbede8ab37bf6e_b.png)![img](https://pic3.zhimg.com/80/v2-980181946a542c11bacbede8ab37bf6e_1440w.png)

构造函数this调了另一个构造函数

![img](https://pic3.zhimg.com/v2-3bbe17dc9e1e13a7d6c2cee2fffec1ce_b.png)![img](https://pic3.zhimg.com/80/v2-3bbe17dc9e1e13a7d6c2cee2fffec1ce_1440w.png)

再来看m

![img](https://pic1.zhimg.com/v2-3a305981191748de5dc309cde783e870_b.png)![img](https://pic1.zhimg.com/80/v2-3a305981191748de5dc309cde783e870_1440w.png)

这个m是NavigableMap类型的，NavigableMap只是一个接口而已

![img](https://pic1.zhimg.com/v2-41d6cf5fb96628e482c199250e2ef7e0_b.png)![img](https://pic1.zhimg.com/80/v2-41d6cf5fb96628e482c199250e2ef7e0_1440w.png)

再来看TreeMap，实现了NavigableMap这个接口

![img](https://pic2.zhimg.com/v2-6f4d3cb4ed1474e0ad56fb2d50d8505d_b.png)![img](https://pic2.zhimg.com/80/v2-6f4d3cb4ed1474e0ad56fb2d50d8505d_1440w.png)

绕了好大一个圈，其实就是相当于

```java
NavigableMap m = new TreeMap<>();
```

**也就是说，TreeSet底层实现也是利用TreeMap来实现的，**再来看看TreeSet的其它方法

![img](https://pic1.zhimg.com/v2-ee415fdf5124011c0157bfb90d60b8f8_b.png)![img](https://pic1.zhimg.com/80/v2-ee415fdf5124011c0157bfb90d60b8f8_1440w.png)

调用的是底层TreeMap的size方法

![img](https://pic1.zhimg.com/v2-a24eeefe0a5d26b83d5c97bd86e7fff8_b.png)![img](https://pic1.zhimg.com/80/v2-a24eeefe0a5d26b83d5c97bd86e7fff8_1440w.png)

调用的是底层TreeMap的isEmpty方法

![img](https://pic1.zhimg.com/v2-e0de2f611aff66bbbad3a3ce243b5bc8_b.png)![img](https://pic1.zhimg.com/80/v2-e0de2f611aff66bbbad3a3ce243b5bc8_1440w.png)

TreeMap的add方法是调用底层TreeMap的put方法，只是改了个名字而已

其它方法大致上也是如此，就不一一举例说明了，感兴趣的朋友请自行阅读源码。

最后，执行一下本文开始那段示例代码的执行结果

![img](https://pic4.zhimg.com/v2-9a2e3f5f91bae045da599aed754ad233_b.png)![img](https://pic4.zhimg.com/80/v2-9a2e3f5f91bae045da599aed754ad233_1440w.png)

> **注：本文示例代码，已上传至公众号：saysayJava，需要练习的朋友请自行下载。**



**小结：HashSet底层声明了一个HashMap，HashSet做了一层包装，操作HashSet里的元素时其实是在操作HashMap里的元素。TreeSet底层也是声明了一个TreeMap，操作TreeSet里的元素其实是操作TreeMap里的元素。**

本文刚一上线就收到了大量评论，**评论区里有人说TreeSet和LinkedHashSet是有序**的，这里强调一下，我们指的**Set不保证插入有序是指Set这个接口的规范，实现类只要遵循这个规范即可**，当然也可以写有序的版本出来，比如**LinkedHashSet**。**而TreeSet是里面的内容有序（按照一定规则排序），但不是指元素的添加顺序**。

> 注意：大家在写TreeSet测试本文代码的时候，可能刚好得到张三，李四，王五、赵六这样的顺序，这是碰巧，请大家打乱顺序测试。