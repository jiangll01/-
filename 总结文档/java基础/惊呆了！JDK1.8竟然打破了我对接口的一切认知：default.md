## 惊呆了！JDK1.8竟然打破了我对接口的一切认知：default

[Java高效学习](javascript:void(0);) *今天*

> 来源：cnblogs.com/AlanWilliamWalker/p/11156455.html

###  **简介**

我们通常所说的接口的作用是用于定义一套标准、约束、规范等，接口中的方法只声明方法的签名，不提供相应的方法体，方法体由对应的实现类去实现。

在JDK1.8中打破了这样的认识，接口中的方法可以有方法体，但需要关键字static或者default来修饰，使用static来修饰的称之为静态方法，静态方法通过接口名来调用，使用default来修饰的称之为默认方法，默认方法通过实例对象来调用。

#### **静态方法和默认方法的作用：**

静态方法和默认方法都有自己的方法体，用于提供一套默认的实现，这样子类对于该方法就不需要强制来实现，可以选择使用默认的实现，也可以重写自己的实现。当为接口扩展方法时，只需要提供该方法的默认实现即可，至于对应的实现类可以重写也可以使用默认的实现，这样所有的实现类不会报语法错误：Xxx不是抽象的, 并且未覆盖Yxx中的抽象方法。

###  **示例**

IHello接口

```
public interface IHello {

// 使用abstract修饰不修饰都行
void sayHi();

static void sayHello(){
System.out.println("static method: say hello");
}

default void sayByebye(){
System.out.println("default mehtod: say byebye");
}
}
```

HelloImpl实现类

```
public class HelloImpl implements IHello {
@Override
public void sayHi() {
System.out.println("normal method: say hi");
}
}
```

Main

```
public class Main {
public static void main(String[] args) {
HelloImpl helloImpl = new HelloImpl();
// 对于abstract抽象方法通过实例对象来调用
helloImpl.sayHi();
// default方法只能通过实例对象来调用
helloImpl.sayByebye();

// 静态方法通过 接口名.方法名() 来调用
IHello.sayHello();


// 接口是不允许new的，如果使用new后面必须跟上一对花括号用于实现抽象方法， 这种方式被称为匿名实现类，匿名实现类是一种没有名称的实现类
// 匿名实现类的好处：不用再单独声明一个类，缺点：由于没有名字，不能重复使用，只能使用一次
new IHello() {
@Override
public void sayHi() {
System.out.println("normal method: say hi");
}
}.sayHi();
}
}
```

#### 执行结果：

```
normal method: say hi
default mehtod: say byebye
static method: say hello
normal method: say hi
```

这篇文章虽然简单，但是我觉得还是有必要分享一下，毕竟与1.7相比，发生了不少的变化，希望本文能对你有所