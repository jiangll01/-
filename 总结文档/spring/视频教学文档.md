####  spring注解学习

#####  1、bean的作用域、@Scope注解与proxyMode属性

对于Spring而言，在默认情况下其所有的bean都是以单例的形式创建的。即无论给定的一个bean被注入到其他bean多少次，每次所注入的都是同一个实例。

bean的作用域
首先，我们需要了解下Spring定义了多种作用域:
1.单例（Singleton）：在整个应用中，只创建bean的一个实例。
2.原型（Prototype）：每次注入或者通过spring应用上下文获取的时候，都会创建一个新的bean实例。
3.会话（Session）：在web应用中，为每个会话创建一个bean实例。
4.请求（Request）：在Web应用中，为每个请求创建一个bean实例。
@Scope注解
单例是默认的作用域，但有些时候并不符合我们的实际运用场景，因此我们可以使用@Scope注解来选择其他的作用域。该注解可以配合@Component和@Bean一起使用

例如，如果你使用组件扫描来发现和声明bean，那么你可以在bean的类上使用@Scope配合@Component，将其声明为原型bean:

  @Component
  @Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
  public class Notepad {
  	//todo: dosomething
  }
1
2
3
4
5
这里使用的是ConfigurableBeanFactory类的SCOPE_PROTOTYPE常量设置了原型作用域。当然你也可以使用@Scope(value = "prototype")，相对而言笔者更喜欢使用SCOPE_PROTOTYPE常量，因为这样使用不易出现拼写错误以及便于代码的维护。

如果你想在Java配置中将Notepad声明为原型bean，那么可以组合使用@Scope和@Bean来指定所需的作用域：

	@Bean
	@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
	public Notepad notepad() {
	    return new Notepad();
	}

如果你使用xml来配置bean的话，可以使用<bean>元素的scope属性来设置作用域：

 <bean id="notepad" class="com.lixiang.Notepad" scope="prototype"/>
1
作用域代理——proxyMode属性
对于bean的作用域，有一个典型的电子商务应用：需要有一个bean代表用户的购物车。

如果购物车是单例，那么将会导致所有的用户都往一个购物车中添加商品。
如果购物车是原型作用域的，那么在应用中某个地方往购物车中添加商品，然后到应用中的另外一个地方可能就没法使用了，因为在这里被注入了另外一个原型作用域的的购物车。
就购物车bean而言，会话作用域是最合适的，因为他与给定用户的关联性最大。

 	@Component
    @Scope(value = WebApplicationContext.SCOPE_SESSION, 
    	proxyMode =ScopedProxyMode.INTERFACES)
    public class ShippingCart {
    	//todo: dosomething
    }
这里我们将value设置成了WebApplicationContext.SCOPE_SESSION常量。这会告诉Spring 为Web应用的每个会话创建一个ShippingCart。这会创建多个ShippingCart bean的实例。但是对于给定的会话只会创建一个实例，在当前会话各种操作中，这个bean实际上相当于单例的。

要注意的是，@Scope中使用了proxyMode属性，被设置成了ScopedProxyMode.INTERFACES。这个属性是用于解决将会话或请求作用域的bean注入到单例bean中所遇到的问题。
假设我们将ShippingCart bean注入到单例StoreService bean的setter方法中：

 @Component
    public class StoreService {
    
        private ShippingCart shippingCart;
        
        public void setShoppingCart(ShippingCart shoppingCart) {
            this.shippingCart = shoppingCart;
        }
        //todo: dosomething
    }
    因为StoreService 是个单例bean，会在Spring应用上下文加载的时候创建。当它创建的时候，Spring会试图将ShippingCart bean注入到setShoppingCart()方法中。但是ShippingCart bean是会话作用域，此时并不存在。直到用户进入系统创建会话后才会出现ShippingCart实例。
另外，系统中会有多个ShippingCart 实例，每个用户一个。我们并不希望注入固定的ShippingCart实例，而是希望当StoreService 处理购物车时，它所使用的是当前会话的ShippingCart实例。

Spring并不会将实际的ShippingCart bean注入到StoreService，Spring会注入一个ShippingCart bean的代理。这个代理会暴露与ShippingCart相同的方法，所以StoreService会认为它就是一个购物车。但是，当StoreService调用ShippingCart的方法时，代理会对其进行懒解析并将调用委任给会话作用域内真正的ShippingCart bean。

在上面的配置中，proxyMode属性，被设置成了ScopedProxyMode.INTERFACES，这表明这个代理要实现ShippingCart接口，并将调用委托给实现bean。
但如果ShippingCart是一个具体的类而不是接口的话，Spring就没法创建基于接口的代理了。此时，它必须使用CGLib来生成基于类的代理。所以，如果bean类型是具体类的话我们必须要将proxyMode属性，设置成ScopedProxyMode.TARGET_CLASS，以此来表明要以生成目标类扩展的方式创建代理。
请求作用域的bean应该也以作用域代理的方式进行注入。

如果你需要使用xml来声明会话或请求作用域的bean，那么就需要使用<aop:scoped-proxy />元素来指定代理模式。

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop-3.2.xsd
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">
        
  <bean id="cart" class="com.lixiang.bean.ShoppingCart" scope="session"/>
  <aop:scoped-proxy />

</beans>
<aop:scoped-proxy />是与@Scope注解的proxyMode属性相同的xml元素。它会告诉Spring为bean创建一个作用域代理。默认情况下，它会使用CGLib创建目标类的代理，如果要生成基于接口的代理可以将proxy-target-class属性设置成false,如下：

<bean id="cart" class="com.lixiang.bean.ShoppingCart" scope="session"/>
<aop:scoped-proxy proxy-target-class="false"/>





![image-20200814143638971](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200814143638971.png)