## 天天都会写接口(interface)，但它的用途和好处有多少人能说得清楚？

[Java知音](javascript:void(0);) *昨天*

![img](https://mmbiz.qpic.cn/mmbiz_gif/eQPyBffYbucGRda0rcJFUcQBDSTWOLQwIxh0BtyOOiaibYXRzCjz4ID20aW2ZLKn18KekUCib3d8yLVtfH1tmljUQ/640?wx_fmt=gif&tp=webp&wxfrom=5&wx_lazy=1)

*作者：\*nvd11**

*blog.csdn.net/nvd11/article/details/41129935*

## 一. 对接口的三个疑问

很多初学者都大概清楚interface是什么, 我们可以定义1个接口, 然后在里面定义一两个常量(static final) 或抽象方法.

然后以后写的类就可以实现这个接口, 重写里面的抽象方法.

很多人说接口通常跟多态性一起存在.

接口的用法跟抽象类有点类似.

**但是为何要这么做呢.**

1. 为什么不直接在类里面写对应的方法,  而要多写1个接口(或抽象类)?
2. 既然接口跟抽象类差不多, 什么情况下要用接口而不是抽象类.
3. 为什么interface叫做接口呢? 跟一般范畴的接口例如usb接口, 显卡接口有什么联系呢?

## 二. 接口引用可以指向实现该接口的对象

我们清楚接口是不可以被实例化, 但是接口引用可以指向1个实现该接口的对象.

也就是说.

假如类A impletments 了接口B

那么下面是合法的:

```
B b = new A();
```

也可以把A的对象强制转换为 接口B的对象

```
A a = new A90;
B b = (B)a;
```

这个特性是下面内容的前提.推荐：[一百期面试题汇总](http://mp.weixin.qq.com/s?__biz=MzIyNDU2ODA4OQ==&mid=2247484532&idx=1&sn=1c243934507d79db4f76de8ed0e5727f&chksm=e80db202df7a3b14fe7077b0fe5ec4de4088ce96a2cde16cbac21214956bd6f2e8f51193ee2b&scene=21#wechat_redirect)

## 三. 抽象类为了多态的实现.

第1个答案十分简单, 就是为了实现多态.

下面用详细代码举1个例子.

先定义几个类,

- 动物(Animal) 抽象类
- 爬行动物(Reptile) 抽象类  继承动物类
- 哺乳动物(Mammal) 抽象类 继承动物类
- 山羊(Goat) 继承哺乳动物类
- 老虎(Tiger)  继承哺乳动物类
- 兔子(Rabbit) 继承哺乳动物类
- 蛇(Snake)  继承爬行动物类
- 农夫(Farmer)  没有继承任何类 但是农夫可以给Animal喂水(依赖关系)

### 3.1 Animal类

这个是抽象类, 显示也没有"动物" 这种实体

类里面包含3个抽象方法.

**1.静态方法getName()**

**2.移动方法move()**, 因为动物都能移动.  但是各种动物有不同的移动方法, 例如老虎和山羊会跑着移动, 兔子跳着移动, 蛇会爬着移动.

作为抽象基类, 我们不关心继承的实体类是如何移动的, 所以移动方法move()是1个抽象方法.  这个就是多态的思想.

**3.喝水方法drink()**, 同样, 各种动物有各种饮水方法. 这个也是抽象方法.

代码:

```
abstract class Animal{
    public abstract String getName();
    public abstract void move(String destination);
    public abstract void drink();
}
```

### 3.2 Mammal类

这个是继承动物类的哺乳动物类, 后面的老虎山羊等都继承自这个类.

Mammal类自然继承了Animal类的3个抽象方法, 实体类不再用写其他代码.

```
abstract class Mammal extends Animal{

}
```

### 3.3 Reptile类

这个是代表爬行动物的抽象类, 同上, 都是继承自Animal类.

```
abstract class Reptile extends Animal{
 
}
```

### 3.4 Tiger类

老虎类就是1个实体类, 所以它必须重写所有继承自超类的抽象方法, 至于那些方法如何重写, 则取决于老虎类本身.

```
class Tiger extends Mammal{
    private static String name = "Tiger";
    public String getName(){
        return this.name;
    }
 
    public void move(String destination){
        System.out.println("Goat moved to " + destination + ".");
    }
 
    public void drink(){
        System.out.println("Goat lower it's head and drink.");
    }
}
```

如上, 老虎的移动方法很普通, 低头喝水.

### 3.5 Goat类 和 Rabbit类

这个两个类与Tiger类似, 它们都继承自Mammal这个类.

```
class Goat extends Mammal{
    private static String name = "Goat";
    public String getName(){
        return this.name;
    }
 
    public void move(String destination){
        System.out.println("Goat moved to " + destination + ".");
    }
 
    public void drink(){
        System.out.println("Goat lower it's head and drink.");
    }
}
```

兔子: 喝水方法有点区别

```
class Rabbit extends Mammal{
    private static String name = "Rabbit";
    public String getName(){
        return this.name;
    }
 
    public void move(String destination){
        System.out.println("Rabbit moved to " + destination + ".");
    }
 
    public void drink(){
        System.out.println("Rabbit put out it's tongue and drink.");
    }
}
```

### 3.6 Snake类

蛇类继承自Reptile(爬行动物)

移动方法和喝水方法都跟其他3动物有点区别.

```
class Snake extends Reptile{
    private static String name = "Snake";
    public String getName(){
        return this.name;
    }
 
    public void move(String destination){
        System.out.println("Snake crawled to " + destination + ".");
    } 
 
    public void drink(){
        System.out.println("Snake dived into water and drink.");
    }
}
```

### 3.7 Farmer 类

Farmer类不属于 Animal类族, 但是Farmer农夫可以给各种动物, 喂水.

Farmer类有2个关键方法, 分别是

```
bringWater(String destination)
```

把水带到某个地点

另1个就是`feedWater`了,

feedWater这个方法分为三步:

- 首先是农夫带水到饲养室,(bringWater())
- 接着被喂水动物走到饲养室,(move())
- 接着动物喝水(drink())

Farmer可以给老虎喂水, 可以给山羊喂水, 还可以给蛇喂水, 那么feedWater()里的参数类型到底是老虎,山羊还是蛇呢.

实际上因为老虎,山羊, 蛇都继承自Animal这个类, 所以feedWater里的参数类型设为Animal就可以了.

Farmer类首先叼用bringWater("饲养室"),至于这个动物是如何走到饲养室和如何喝水的, Farmer类则不用关心.

因为执行时, Animal超类会根据引用指向的对象类型不同 而 指向不同的被重写的方法.  这个就是多态的意义.

代码如下:

```
class Farmer{
    public void bringWater(String destination){
        System.out.println("Farmer bring water to " + destination + ".");
    }
 
    public void feedWater(Animal a){ // polymorphism
        this.bringWater("Feeding Room");
        a.move("Feeding Room");
        a.drink();
    }
 
}
```

### 3.7 执行农夫喂水的代码.

下面的代码是1个农夫依次喂水给一只老虎, 一只羊, 以及一条蛇

```
 public static void f(){
        Farmer fm = new Farmer();
        Snake sn = new Snake();
        Goat gt = new Goat();
        Tiger tg = new Tiger();
 
        fm.feedWater(sn);
        fm.feedWater(gt);
        fm.feedWater(tg);
    }
```

农夫只负责带水过去制定地点, 而不必关心老虎, 蛇, 山羊它们是如何过来的. 它们如何喝水. 这些农夫都不必关心.

只需要调用同1个方法feedWater.

执行结果:

```
     [java] Farmer bring water to Feeding Room.
     [java] Snake crawled to Feeding Room.
     [java] Snake dived into water and drink.
     [java] Farmer bring water to Feeding Room.
     [java] Goat moved to Feeding Room.
     [java] Goat lower it's head and drink.
     [java] Farmer bring water to Feeding Room.
     [java] Goat moved to Feeding Room.
     [java] Goat lower it's head and drink.
```

**不使用多态的后果?:**

而如果老虎, 蛇, 山羊的drink() 方法不是重写自同1个抽象方法的话, 多态就不能实现. 农夫类就可能要根据参数类型的不同而重载很多个  feedWater()方法了.

而且每增加1个类(例如 狮子Lion)

就需要在农夫类里增加1个feedWater的重载方法 feedWater(Lion l)...

而接口跟抽象类类似,

这个就回答了不本文第一个问题.

> 1.为什么不直接在类里面写对应的方法,  而要多写1个接口(或抽象类)?

## 四. 抽象类解决不了的问题.

既然抽象类很好地实现了多态性, 那么什么情况下用接口会更加好呢?

对于上面的例子, 我们加一点需求.

Farmer 农夫多了1个技能, 就是给另1个动物喂兔子(囧).

- BringAnimal(Animal a, String destination)   把兔子带到某个地点...
- feedAnimal(Animal ht, Animal a)       把动物a丢给动物ht

> 注意农夫并没有把兔子宰了, 而是把小动物(a)丢给另1个被喂食的动物(ht).

那么问题来了, 那个动物必须有捕猎这个技能.  也就是我们要给被喂食的动物加上1个方法(捕猎) hunt(Animal a).

但是现实上不是所有动物都有捕猎这个技能的, 所以我们不应该把hunt(Animal a)方法加在Goat类和Rabbit类里,  只加在Tiger类和Snake类里.

而且老虎跟蛇的捕猎方法也不一样, 则表明hunt()的方法体在Tiger类里和Snake类里是不一样的.

下面有3个方案.

1. 分别在Tiger类里和Snake类里加上Hunt() 方法.  其它类(例如Goat) 不加.
2. 在基类Animal里加上Hunt()抽象方法. 在Tiger里和Snake里重写这个Hunt() 方法.
3. 添加肉食性动物这个抽象类.

#### 先来说第1种方案.

这种情况下, Tiger里的Hunt(Animal a)方法与 Snake里的Hunt(Animal a)方法毫无关联. 也就是说不能利用多态性.

导致Farm类里的feedAnimal()方法需要分别为Tiger 与 Snake类重载. 否决.

#### 第2种方案:

如果在抽象类Animal里加上Hunt()方法, 则所有它的非抽象派生类都要重写实现这个方法, 包括 Goat类和 Rabbit类.

这是不合理的, 因为Goat类根本没必要用到Hunt()方法, 造成了资源(内存)浪费.

#### 第3种方案:

加入我们在哺乳类动物下做个分叉, 加上肉食性哺乳类动物, 非肉食性哺乳动物这两个抽象类?

首先,肉食性这种分叉并不准确, 例如很多腐蚀性动物不会捕猎, 但是它们是肉食性.

其次,这种方案会另类族图越来越复杂, 假如以后再需要辨别能否飞的动物呢, 增加飞翔 fly()这个方法呢? 是不是还要分叉?

再次,很现实的问题, 在项目中, 你很可能没机会修改上层的类代码, 因为它们是用Jar包发布的, 或者你没有修改权限.

这种情况下就需要用到接口了.

Java知音公众号内回复“后端面试”，送你一份Java面试题宝典

## 五.接口与多态 以及 多继承性.

上面的问题, 抽象类解决不了, 根本问题是Java的类不能多继承.

因为Tiger类继承了动物Animal类的特性(例如 move() 和 drink()) , 但是严格上来将 捕猎(hunt())并不算是动物的特性之一. 有些植物, 单细胞生物也会捕猎的.

所以Tiger要从别的地方来继承Hunt()这个方法.  接口就发挥作用了.

### 5.1 Huntable接口

我们增加了1个Huntable接口.

接口里有1个方法hunt(Animal a), 就是捕捉动物, 至于怎样捕捉则由实现接口的类自己决定.

代码:

```
interface Huntable{
    public void hunt(Animal a);
}
```

### 5.2 Tiger 类

既然定义了1个Huntable(可以捕猎的)接口.

Tiger类就要实现这个接口并重写接口里hunt()方法.

```
class Tiger extends Mammal implements Huntable{
    private static String name = "Tiger";
    public String getName(){
        return this.name;
    }
 
    public void move(String destination){
        System.out.println("Goat moved to " + destination + ".");
    }
 
    public void drink(){
        System.out.println("Goat lower it's head and drink.");
    }
 
    public void hunt(Animal a){
        System.out.println("Tiger catched " + a.getName() + " and eated it");
    }
 
}
```

### 5.3 Snake类

同样:

```
class Snake extends Reptile implements Huntable{
    private static String name = "Snake";
    public String getName(){
        return this.name;
    }
 
    public void move(String destination){
        System.out.println("Snake crawled to " + destination + ".");
    } 
 
    public void drink(){
        System.out.println("Snake dived into water and drink.");
    }
 
    public void hunt(Animal a){
        System.out.println("Snake coiled " + a.getName() + " and eated it");
    }
}
```

可见同样实现接口的hunt()方法, 但是蛇与老虎的捕猎方法是有区别的.

### 5.4 Farmer类

这样的话. Farmer类里的feedAnimal(Animal ht, Animal a)就可以实现多态了.

```
class Farmer{
    public void bringWater(String destination){
        System.out.println("Farmer bring water to " + destination + ".");
    }
    
    public void bringAnimal(Animal a,String destination){
        System.out.println("Farmer bring " + a.getName() + " to " + destination + ".");
    }
 
    public void feedWater(Animal a){
        this.bringWater("Feeding Room");
        a.move("Feeding Room");
        a.drink();
    }
 
    public void feedAnimal(Animal ht , Animal a){
        this.bringAnimal(a,"Feeding Room");
        ht.move("Feeding Room");
        Huntable hab = (Huntable)ht;
        hab.hunt(a);
    }
 
}
```

关键是这一句

```
Huntable hab = (Huntable)ht;
```

本文一开始讲过了, 接口的引用可以指向实现该接口的对象.

> 当然, 如果把Goat对象传入Farmer的feedAnimal()里就会有异常, 因为Goat类没有实现该接口. 上面那个代码执行失败.

如果要避免上面的问题.

可以修改feedAnimal方法:

```
    public void feedAnimal(Huntable hab, Animal a){
        this.bringAnimal(a,"Feeding Room");
        Animal ht = (Animal)hab;
        ht.move("Feeding Room");
        hab.hunt(a);
    }
```

这样的话, 传入的对象就必须是实现了Huntable的对象, 如果把Goat放入就回编译报错.

但是里面一样有一句强制转换

```
Animal ht = (Animal)hab
```

反而更加不安全, 因为实现的Huntable的接口的类不一定都是Animal的派生类. 相反, 接口的出现就是鼓励多种不同的类实现同样的功能(方法)

例如,假如一个机械类也可以实现这个接口, 那么那个机械就可以帮忙打猎了(囧)

1个植物类(例如捕蝇草),实现这个接口, 也可以捕猎苍蝇了.

> 也就是说, 接口不会限制实现接口的类的类型.

执行输出:

```
     [java] Farmer bring Rabbit to Feeding Room.
     [java] Snake crawled to Feeding Room.
     [java] Snake coiled Rabbit and eated it
     [java] Farmer bring Rabbit to Feeding Room.
     [java] Goat moved to Feeding Room.
     [java] Tiger catched Rabbit and eated it
```

这样, Tiger类与Snake类不但继承了Animal的方法, 还继承(实现)了接口Huntable的方法, 一定程度上弥补java的class不支持多继承的特点.

## 六.接口上应用泛型.

上面的Huntable里还是有点限制的,

就是它里面的hunt()方法的参数是 Animal a, 也就是说这个这个接口只能用于捕猎动物.

但是在java的世界里, 接口里的方法(行为)大多数是与类的类型无关的.

也就是说, Huntable接口里的hunt()方法里不单只可以捕猎动物, 还可以捕猎其他东西(例如 捕猎植物... 敌方机械等)

### 6.1 Huntable接口

首先要在Huntable接口上添加泛型标志:`<T>`

```
interface Huntable<T>{
    public void hunt(T o);
}
```

然后里面的hunt()的参数的类型就写成T, 表示hunt()方法可以接受多种参数, 取决于实现接口的类.

### 6.2 Tiger类(和Snake类)

同样, 定义tiger类时必须加上接口的泛型标志`<Animal>`, 表示要把接口应用在Animal这种类型.

```
class Tiger extends Mammal implements Huntable<Animal>{
    private static String name = "Tiger";
    public String getName(){
        return this.name;
    }
 
    public void move(String destination){
        System.out.println("Goat moved to " + destination + ".");
    }
 
    public void drink(){
        System.out.println("Goat lower it's head and drink.");
    }
 
    public void hunt(Animal a){
        System.out.println("Tiger catched " + a.getName() + " and eated it");
    }
 
}
```

这样, 在里面hunt()参数就可以指明类型Animal了,  表示老虎虽然有捕猎这个行为, 但是只能捕猎动物.Java知音公众号内回复“后端面试”，送你一份Java面试题宝典

## 七.什么情况下应该使用接口而不用抽象类.

好了, 回到本文最重要的一个问题.

做个总结

1. 需要实现多态
2. 要实现的方法(功能)不是当前类族的必要(属性).
3. 要为不同类族的多个类实现同样的方法(功能).

下面是分析:

### 7.1 需要实现多态

很明显, 接口其中一个存在意义就是为了实现多态. 这里不多说了.

而抽象类(继承) 也可以实现多态

### 7.2. 要实现的方法(功能)不是当前类族的必要(属性).

上面的例子就表明, 捕猎这个方法不是动物这个类必须的,在动物的派生类中, 有些类需要, 有些不需要.

如果把捕猎方法卸载动物超类里面是不合理的浪费资源.

所以把捕猎这个方法封装成1个接口, 让派生类自己去选择实现!

### 7.3. 要为不同类族的多个类实现同样的方法(功能).

上面说过了, 其实不是只有Animal类的派生类才可以实现Huntable接口.

如果Farmer实现了这个接口, 那么农夫自己就可以去捕猎动物了...

我们拿另个常用的接口Comparable来做例子.

这个接口是应用了泛型,

首先, 比较(CompareTo) 这种行为很难界定适用的类族, 实际上, 几乎所有的类都可以比较.

比如 数字类可以比较大小,  人类可以比较财富,  动物可以比较体重等.

所以各种类都可以实现这个比较接口.

一旦实现了这个比较接口. 就可以开启另1个隐藏技能:

就是可以利用Arrays.sort()来进行排序了.

就如实现了捕猎的动物,

可以被农夫Farmer喂兔子一样...

## 八.接口为什么会被叫做接口, 跟真正的接口例如usb接口有联系吗?

对啊, 为什么叫接口, 而不叫插件(plugin)呢,  貌似java接口的功能更类似1个插件啊.

插上某个插件, 就有某个功能啊.

实际上, 插件与接口是相辅相成的.

例如有1个外部存储插件(U盘), 也需要使用设备具有usb接口才能使用啊.

再举个具体的例子.

个人电脑是由大型机发展而来的

> 大型机->小型机->微机(PC)

而笔记本是继承自微机的.

那么问题来了.

对于, 计算机的CPU/内存/主板/独显/光驱/打印机 有很多功能(方法/行为), 那么到底哪些东西是继承, 哪些东西是接口呢.

首先,  cpu/内存/主板 是从大型机开始都必备的, 任何计算机都不能把它们去掉.

所以, 这三样东西是继承的, 也就说笔记本的cpu/内存/主板是继承自微机(PC)的

但是/光驱/呢,   现实上很多超薄笔记本不需要光驱的功能.

如果光驱做成继承, 那么笔记本就必须具有光驱, 然后屏蔽光驱功能, 那么这台笔记本还能做到超薄吗? 浪费了资源.

所以光驱,打印机这些东西就应该做成插件.

然后, 在笔记本上做1个可以插光驱和打印机的接口(usb接口).

也就是说, PC的派生类, 有些(笔记本)可以不实现这个接口, 有些(台式机)可以实现这个接口,只需要把光驱插到这个接口上.

至于光驱是如何实现的,

例如一些pc派生类选择实现蓝光光驱, 有些选择刻录机.  但是usb接口本身并不关心. 取决与实现接口的类.

这个就是现实意义上的多态性啊.