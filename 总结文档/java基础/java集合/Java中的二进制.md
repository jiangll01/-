作者：清浅池塘
链接：https://zhuanlan.zhihu.com/p/29187389
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



> 在put放入元素时，HashMap又自己写了一个hash方法来计算hash值，大家想想看，为什么不用key本身的hashCode方法，而是又处理了一下

为了让大家深入理解这段代码的含义，准备写三篇文章来拓展一下基础知识，然后再回归到HashMap中去，这三篇文章分别是**Java中的二进制**，**移位运算符**（左移运算符：<< ，右移运算符：>>，无符号右移运算符：>>>），和**位运算符**（与：&，或：| ，非：~，异或：^），我们再看一下DEFAULT_INITIAL_CAPACITY这个常量赋值和hash方法的源码，这段源码中就用到了移位运算符和位运算符（^）：

```java
static final int DEFAULT_INITIAL_CAPACITY = 1 << 4;
static final int hash(Object key) {
     int h;
     return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
}
```

计算机看似能干很多活，其实也很苯，只认识0和1。因为电路的逻辑只有0和1两个状态，这里的0和1并不是数字的0和1，0和1是表示两种不同的状态，0表示低电平，1表示高电平。计算机是由无数个逻辑电路组成的，通过0和1的无限位数和组合来表达信息。也就是说，计算机是采用二进制来表示数据的。为了说清楚二进制，先说一下我们生活中常用的十进制，十进制看起来很简单，那是因为我们从小接受的就是十进制的教育：

![img](https://pic4.zhimg.com/v2-e2ba0ab19db8dd60b91c50108c6b310f_b.png)![img](https://pic4.zhimg.com/80/v2-e2ba0ab19db8dd60b91c50108c6b310f_1440w.png)

这是一个普通的十进制数，八十三万七千零五十六，这个数字可以表示如下：

![img](https://pic1.zhimg.com/v2-e13239ff22b61531d09ad8ffdcb5ea64_b.png)![img](https://pic1.zhimg.com/80/v2-e13239ff22b61531d09ad8ffdcb5ea64_1440w.png)

再来看看二进制

![img](https://pic2.zhimg.com/v2-babd53111e5b0c86eb8c1a131fedd931_b.png)![img](https://pic2.zhimg.com/80/v2-babd53111e5b0c86eb8c1a131fedd931_1440w.png)

这是一个二进制数101011，这个数字可以表示如下：

![img](https://pic3.zhimg.com/v2-6e34dc5fd34b1c20bc360ca8d81e858a_b.png)![img](https://pic3.zhimg.com/80/v2-6e34dc5fd34b1c20bc360ca8d81e858a_1440w.png)

和十进制一样，只不过把底数（幂）从10变成了2，用十进制表示二进制里的101011就是43。有一点Java基础的人，都知道**int类型在Java中是占4个字节的，1个字节8位**，43表示如下：

![img](https://pic2.zhimg.com/v2-2a097d43bcea9d4fd55f453af56ee55d_b.png)![img](https://pic2.zhimg.com/80/v2-2a097d43bcea9d4fd55f453af56ee55d_1440w.png)

其中每段为1个字节，一个字节是8位，首位表示符号位。在Java中，**负数是用补码来表示的，也就是其绝对值取反加1得到的**，并用首位来标识符号位为负数，看一下-43是怎么表示的：

1、先取反，取反其实很简单，就是0变1，1变0

![img](https://pic1.zhimg.com/v2-8c89cc460c982e6468e84c8b0df656a0_b.png)![img](https://pic1.zhimg.com/80/v2-8c89cc460c982e6468e84c8b0df656a0_1440w.png)

2、加1

![img](https://pic1.zhimg.com/v2-f8f321785b795d4c2614f10164042bd8_b.png)![img](https://pic1.zhimg.com/80/v2-f8f321785b795d4c2614f10164042bd8_1440w.png)



相信看到这里，大家就知道为什么int能表示的最大数和最小数分别是2147483647和-2147483648了。先看int的最大值2147483647，二进制是这样表示的，原来并不是定义的，只是说实在装不下了

![img](https://pic1.zhimg.com/v2-54beec654df89e7d18b67f93379f36e4_b.png)![img](https://pic1.zhimg.com/80/v2-54beec654df89e7d18b67f93379f36e4_1440w.png)

再看看int里的最小值-2147483648，二进制是这样表示的

![img](https://pic2.zhimg.com/v2-5966dbdca37db02b8e54683a73e5ce5d_b.png)![img](https://pic2.zhimg.com/80/v2-5966dbdca37db02b8e54683a73e5ce5d_1440w.png)

写到这儿了，再扩展一下知识点吧，来看一下32位的int类型转换成16位的short类型时，系统是怎么转换的，随手写了一个二进制数，相当于十进制的20080557

![img](https://pic2.zhimg.com/v2-fef3e07d2750858f10df32b38b297641_b.png)![img](https://pic2.zhimg.com/80/v2-fef3e07d2750858f10df32b38b297641_1440w.png)

准备转换，截掉前面的16位

![img](https://pic3.zhimg.com/v2-b3e5f9b642bef447fda5344f2b09f68a_b.png)![img](https://pic3.zhimg.com/80/v2-b3e5f9b642bef447fda5344f2b09f68a_1440w.png)

取后面的16位，并把第1位变为符号位

![img](https://pic3.zhimg.com/v2-c2402c24eea59af6db0e49e13a266736_b.png)![img](https://pic3.zhimg.com/80/v2-c2402c24eea59af6db0e49e13a266736_1440w.png)

强制转换以后，十进制的20080557变成了十进制的26541，怎么样，简单吧。

有人说，好麻烦，每次都要这么算吗？不用担心，Java提供了丰富的API来供我们使用，我们写一段代码来测试一下

```java
public static void main(String[] args) {
	System.out.println("int最大正数：" + Integer.MAX_VALUE);
	System.out.println("int最大正数二进制表示：" + Integer.toBinaryString(Integer.MAX_VALUE));
	System.out.println("int最小负数：" + Integer.MIN_VALUE);
	System.out.println("int最小负数二进制表示：" + Integer.toBinaryString(Integer.MIN_VALUE));
		
	System.out.println("二进制定义打印int能表示的最大数：" + 0b01111111_11111111_11111111_11111111);
	System.out.println("二进制定义打印int能表示的最小数：" + 0b10000000_00000000_00000000_00000000);
		
	System.out.println("43的二进制表现：" + Integer.toBinaryString(43));//结果省略了前面的0
	System.out.println("-43的二进制表现：" + Integer.toBinaryString(-43));

	//下划线无意义，只是为了方便看，可以随意写
	int a = 0b00000000_00000000_00000000_00000000_00101011;//0b表示为二进制，a相当于十进制的43
	int a1 = 0b101011;//这也是十进制的43，只不过省略了上面的0
	System.out.println("打印a的值：" + a);
	System.out.println("打印a1的值：" + a1);
	int b = 0b11111111_11111111_111111111_1010101;//二进制43取反加1，变成-43，下划线无意义
	System.out.println("打印b的值：" + b);
		
	int i = 0b00000001_00110010_01100111_10101101;//随手写了个十进制的24274861
	System.out.println("打印10进制的i：" + i);
	System.out.println("打印强制转换为short的i：" + (short)i);
	System.out.println("打印short的二进制表示：" + Integer.toBinaryString((short)i));
}
```

最后我们来看一下结果

![img](https://pic2.zhimg.com/v2-e0914cb343500122ea06b52aa1522ae9_b.png)![img](https://pic2.zhimg.com/80/v2-e0914cb343500122ea06b52aa1522ae9_1440w.png)

整理了一个表格，帮大家回顾一下Java中的四种整形，byte，short，long这三种类型本文就不详细解说了，其中API的调用都是一样的

![img](https://pic2.zhimg.com/v2-ee85edfb8935d0ec210f0e1999cff191_b.png)![img](https://pic2.zhimg.com/80/v2-ee85edfb8935d0ec210f0e1999cff191_1440w.png)

思考以下代码执行结果，结合本文中的图片一起看

```java
System.out.println(Integer.MAX_VALUE + 1);
System.out.println(Integer.MIN_VALUE - 1);
```