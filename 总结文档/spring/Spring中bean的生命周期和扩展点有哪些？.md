今天和大家分享一下Spring中Bean的生命周期的一些知识。先来说一下什么是生命周期吧，生命周期从其语义上理解就是一个对象从产生到销毁的整个过程，之所以把这个过程称为生命周期是因为其就像一个生命一样包含了出生、死亡等等过程。

普通的java对象也有其生命周期，不过非常简单，可以归纳为：创建->使用->垃圾回收。Spring中的Bean本质上来说也是一个对象，但是因为bean是被容器管理的，所以其生命周期就复杂了很多。

理解Spring的生命周期是非常重要的，因为这除了能加深对Spring的理解之外还能帮助我们利用其生命周期中的扩展点来自定义Bean的创建过程。这在实际的开发中可能是非常实用的。

**Spring中bean的生命周期**

Spring中的bean在创建过程中大概分为以下几个步骤:

实例化->填充属性->执行Aware接口->初始化->可用状态->销毁

实例化就是调用类的构造器进行对象创建的过程，比如：new Object();就实例化了一个Obejct对象；填充属性是指注入bean的依赖或者给属性赋值；Aware接口是Spring中的“觉醒”接口，是Spring容器通过回调向bean注入相关对象的接口；初始化是指完成bean的创建和依赖注入后进行的一个回调，可以利用这个回调进行一些自定义的工作,实现初始化的方式有三种，分别是实现InitializingBean接口、使用@PostConstruct注解和xml中通过init-method属性指定初始化方法;可用状态是指bean已经准备就绪、可以被应用程序使用了，此时bean会一直存在于Spring容器中；销毁是指这个bean从Spring容器中消除，这个操作往往伴随着Spring容器的销毁。实现销毁方法的方式有3中，分别为实现DisposableBean接口、使用@PreDestroy注解和xml中通过destroy-method属性指定。**Spring中的Aware接口**

Spring中的Aware接口是一个标记接口，其本身没有定义任何方法，具体的方法都在其实现类中定义。Aware在英文当中是“意识到”的意思，我更喜欢把它成为“觉醒”接口，这样更能有力地表达“这个bean知道了一些它不该知道的东西”的意思。

Aware接口如下：

![img](https://pics2.baidu.com/feed/dc54564e9258d10926b6001661d908ba6d814d40.jpeg?token=35a07df74f9f82fd67a4b1eec8f11dfc&s=A2AAF74A1BAC896E40E545030300E0C2)Aware接口

我们最常用的aware接口有以下几个：

意识到bean名称的接口，实现这个接口Spring容器会向bean注入BeanName：

org.springframework.beans.factory.BeanNameAware

意识到bean工厂的接口，实现这个接口Spring容器会向bean注入BeanFactory：

org.springframework.beans.factory.BeanFactoryAware

意识到ApplicationContext的接口，实现这个接口Spring容器会向bean注入ApplicationContext：

org.springframework.context.ApplicationContextAware

具体用法如下图：

![img](https://pics7.baidu.com/feed/3bf33a87e950352a74d22902e3c23ff7b3118b94.jpeg?token=a6845844170c0d47571303f5414606ba&s=A0D217CB8FE4BD601CF981060000E0C3)Spring中的Aware接口

当然没我们也可以定义属性进行接收：

![img](https://pics6.baidu.com/feed/bba1cd11728b4710fb8ad95f734f07f8fd032306.jpeg?token=d505621c20410576031c9d5772489294&s=E0C297451BE495681E51E4070000E0C3)

然后我们就可以把这些注入进来的属性当做普通的属性进行访问和操作了。其中aware接口的执行顺序是这样的：

BeanNameAware->BeanFactoryAware->ApplicationContextAware

**Bean生命周期中的扩展点**

在这些过程当中有很多的扩展点，这里我们介绍一些常用的，我们用EP（extension point）来进行标识，如下：

EP1->实例化->EP2->填充属性->执行Aware接口->EP3->初始化->EP4->可用状态->销毁

从上述过程中我们可以看出实例化前后的扩展点分别为EP1和EP2,初始化前后的扩展点分别为EP3和EP4。

实现这几个扩展点通常的做法是继承这样一个适配器：

InstantiationAwareBeanPostProcessorAdapter

这个适配器是后置处理器接口BeanPostProcessor的子类，有很多方法，这里只需实现以下几个就可以了：

![img](https://pics2.baidu.com/feed/0d338744ebf81a4c8ce3222967aba45c272da681.jpeg?token=1bbf6a1535bfdbd4a928fc9a97037164&s=A0D237CB13ACB56E4C59F4060000E0C3)扩展点方法

扩展点和对应的方法如下：

实例化前的扩展点EP1 => postProcessBeforeInstantiation实例化后的扩展点EP2 => postProcessAfterInstantiation初始化前的扩展点EP3 => postProcessBeforeInitialization初始化后的扩展点EP4 => postProcessAfterInitialization对于这几个方法需要注意一下几点：

这四个方法是后置处理器中的方法，会对所有的bean进行处理，如果需要对特定的bean进行处理的话，需要通过方法中的参数beanName进行针对性的处理；后置处理器BeanPostProcessor可以指定多个，当初始化一个bean时所有的后置处理器都会进行处理。初始化前后的两个扩展点方法postProcessBeforeInitialization和postProcessAfterInitialization方法不能返回null，返回null的话后面的BeanPostProcessor就不会执行了，而且这个bean也会从Spring容器中剔除。实例化之后的扩展点EP2方法postProcessAfterInstantiation一般都是需要返回true的，如果返回false的话就不会对该bean进行属性注入了，这通常并不是我们想要的。