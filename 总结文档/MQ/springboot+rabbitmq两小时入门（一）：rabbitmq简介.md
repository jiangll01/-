springboot+rabbitmq两小时入门（一）：rabbitmq简介

https://blog.csdn.net/qq_32880973/article/details/98949593

### **作用：**

1、异步处理提高系统性能（生产者只管把消息发出去，消费者什么时候消费，生产者不用管）。

2、降低系统耦合性。

3、流量削峰，高并发下，mq作为临时容器将消息存起来，消费者根据数据库的能力采取拉模式拉取所有消息然后分页执行。

4、消息分发，通过扇型交换机（Fanout exchange）或者多重绑定，可以将消息发给多个队列。

5、延时任务，比如超时未支付等通过延时交换机（Delayed message exchange）实现。

 

### **缺点：**

1、降低系统的可用性，mq挂了整个系统都挂了。

2、增加系统复杂度。

3、一致性问题，生产者消息发出去了就提示前端成功，消费者可能偏偏就失败了。

4、生成者可能发送失败，消费者可能消费失败，消息可能重复投递/消费。

 

### 名词解析：

**发布者**（publisher）：发送消息的服务，类似于分布式框架中的生产者。

**rabbitmq**：类似分布式框架中的注册中心，专门存储发布者（publisher）发过来的消息。

**消费者**（consumer）：处理消息的服务，类似于分布式框架中的消费者。

**虚拟主机**(vhost)：相当于MySQL中的用户，每个vhost之间相互独立。默认vhost：”/” ,默认用户”guest” 密码“guest”。

**连接**(Connection):是RabbitMQ的socket的长链接，它封装了socket协议相关部分逻辑

**信道**(Channel): 由于TCP连接的创建和销毁开销较大，且并发数受系统资源限制，会造成性能瓶颈。RabbitMQ使用信道的方式来传输数据。信道是建立在真实的TCP连接内的虚拟连接，且每条TCP连接上的信道数量没有限制。

**交换机**（exchange）：默认是持久化（durable）的，重启之后依旧在。rabbitmq默认有4中交换机，

​    1、Direct exchange（直连交换机）：rabbitmq默认交换机类型，以路由键（routing key）精确匹配队列（queue）。

​    2、Fanout exchange（扇型交换机）：忽略路由键（routing key），路由到所有与当前交换机绑定的队列中去。

​    3、Topic exchange（主题交换机）:所有符合的routingkey都可以匹配。这种模式下的routingkey必须是由点分开的一串单词。 可以由多个单词，但是有最大限制。最大限制是：255bytes。

​        匹配规则：

​            *：表示匹配任意一个单词

​            \#：表示匹配任意一个或多个单词。

​    4、Headers exchange（头交换机）:通过消息头中的属性来匹配。（不常用）

​    5、Dead letter exchange（死信交换机）：通过给队列（queue）配置x-dead-letter-exchange和x-dead-letter-routing-key属性，将另一个交换机关联为这个队列（queue）的死信交换机（Dead letter exchange）；该队列所有Nack、Reject、消息过期、队列超载的消息都会自动投递到死信交换机。

​    6、Delayed message exchange（延时交换机）：可以指定延时时间，延时消费消息。

**队列**（queue）：专门用来存放消息的，先进先出。默认是持久化（durable）的，重启之后依旧在。

**绑定**（Binding）：Binding是一种操作，RabbitMQ中通过绑定（Binding），以路由键（Routing Key）作为桥梁将交换机（Exchange）与队列（queue）关联起来(Exchange—>Routing Key—>Queue)，这样RabbitMQ就知道如何正确地将消息路由到指定的队列了。

**路由键**(Routing Key）：一个String值，用于定义路由规则。在队列绑定交换机的时候需要指定路由键，在生产者发布消息的时候需要指定路由键。当消息的路由键和队列绑定的路由键匹配时，消息就会发送到该队列。

**消息**（message）：生产者参数做为消息发给mq，消费者把消息当做参数执行具体逻辑。默认是持久化（durable）的，重启之后依旧在。

![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly93d3cucmFiYml0bXEuY29tL2ltZy90dXRvcmlhbHMvaW50cm8vaGVsbG8td29ybGQtZXhhbXBsZS1yb3V0aW5nLnBuZw)

# springboot+rabbitmq两小时入门（七）：生产者发送失败和消费者消费失败处理

![img](https://csdnimg.cn/release/phoenix/template/new_img/original.png)

[我是一个写bug的程序员](https://me.csdn.net/qq_32880973) 2019-08-09 12:12:35 ![img](https://csdnimg.cn/release/phoenix/template/new_img/articleReadEyes.png) 2516 ![img](https://csdnimg.cn/release/phoenix/template/new_img/tobarCollect.png) 收藏 10

分类专栏： [springboot+rabbitmq2小时入门（纯注解）](https://blog.csdn.net/qq_32880973/category_9201078.html)

版权

### 消息队列经常会发送失败和消费失败，这两种问题在日常工作中式不可忽视的。

**消息发送失败情况：**

1、网络抖动导致生产者和mq之间的连接中断，导致消息都没发。

答：rabbitmq有自动重连机制，叫retry。具体到rabbitTemplate中叫retryTemplate，可以通过设置retryTemplate来设置重连次数。

​     1.1、到了重连次数了，还是没连上怎么办呢？造成这种情况通常是服务器宕机等环境问题，这时候会报AmqpException，      我们可以捕获这个异常，然后把消息存入缓存中。等环境正常后，做消息补发。

2、消息发了但是mq没收到，或者mq收到了但是进入到交换机之前（如果开启了消息持久化，那则是持久化之前。交换机、队列、消息默认都是持久化的）消息丢了。

答：rabbitmq有confirm机制，即mq收到消息后会发送一个叫ack的标识给生产者，ack为true表示收到了，ack为false表示没收到或丢了。rabbitTemplate中有confirmCallback，在这个callback里把ack为false的消息存到缓存，用另外线程重发。

3、消息到交换机了，但是找不到对应的queue。

答：rabbitmq有return机制，在rabbitTemplate中有returnCallback。找不到queue的消息都会进入到这个callback，在这个callback里把消息存到缓存，用另外线程重发。

 

**消费失败情况：**

消费失败也有ack机制，和生成者ack不同。我们根据处理结果返回ack（确认收到）、nack（确认未收到）、reject（拒绝）（需开启手动ack模式）。mq收到是ack的话会把消息从mq中剔除，不剔除的话mq会不断重试。

1、网络抖动、消费者代码异常、数据异常。

答：在消费者catch块里返回nack，返回nack之前还要做计数。达到规定的次数后将消息存到缓存并返回ack（因为消费者代码异常、数据异常导致的消费失败重试多少次都成功不了，不处理的话会死循环的）。

 

### `**application.properties配置：**`

```
spring.rabbitmq.host=localhost
# TCP/IP端口为5672，http端口为15672
spring.rabbitmq.port=5672
spring.rabbitmq.username=root
spring.rabbitmq.password=root
# 开启发送确认
spring.rabbitmq.publisher-confirms=true
# 开启发送失败退回
spring.rabbitmq.publisher-returns=true
# 消费者ack有3种模式：NONE、AUTO、MANUAL
# NONE: 不管消费是否成功mq都会把消息剔除，这是默认配置方式。
# MANUAL：手动应答
# AUTO：自动应答，除非MessageListener抛出异常。
spring.rabbitmq.listener.direct.acknowledge-mode=manual
spring.rabbitmq.listener.simple.acknowledge-mode=manual
```

### **生产者：**

```java

@RestController
public class RabbitMQController {
    // 这里用的是RabbitTemplate发消息，也可以用AmqpTemplate，推荐使用RabbitTemplate。
    @Autowired
    private RabbitTemplate rabbitTemplate;
    @GetMapping(value = "/helloRabbit5")
    public String sendMQ5(){
        String msg = "rabbitmq生成者发送失败和消费失败处理方案";
        try {
            // 针对网络原因导致连接断开，利用retryTemplate重连10次
            RetryTemplate retryTemplate = new RetryTemplate();
            retryTemplate.setRetryPolicy(new SimpleRetryPolicy(10));
            rabbitTemplate.setRetryTemplate(retryTemplate);
            // 确认是否发到交换机，若没有则存缓存，用另外的线程重发，直接在里面用rabbitTemplate重发会抛出循环依赖错误
            rabbitTemplate.setConfirmCallback((correlationData, ack, cause) -> {
                if (!ack) {
                    // 存缓存操作
                    System.out.println(msg + "发送失败:" + cause);
                }
            });
            // 确认是否发到队列，若没有则存缓存，然后检查exchange, routingKey配置，之后重发
            rabbitTemplate.setReturnCallback((message, replyCode, replyText, exchange, routingKey) -> {
                // 存缓存操作
                System.out.println(new String(message.getBody()) + "找不到队列，exchange为" + exchange + ",routingKey为" + routingKey);
            });
            rabbitTemplate.convertAndSend("myExchange1", "routingKey4", msg);
        } catch (AmqpException e) {
            // 存缓存操作
            System.out.println(msg + "发送失败:原因重连10次都没连上。");
        }
        return "success";
   }
}
```

### **消费者：**

```java

@Component
public class Receiver {

    /**
     * basicNack(long deliveryTag, boolean multiple, boolean requeue)
     * deliveryTag: 每条消息在mq内部的id,
     * multiple: 是否批量(true：将一次性拒绝所有小于deliveryTag的消息)；
     * requeue: 是否重新入队
     */
    @RabbitListener(
   		bindings = @QueueBinding(
    	value = @Queue(value = "myQueue6"),
        exchange = @Exchange(value = "myExchange1"),
        key = "routingKey4"
            ))

    public void process7(Message message, Channel channel) throws Exception {
        // 模拟消费者代码异常，这种情况必须在catch块设置重试次数（也可以在配置文件中全局设置重试次数，当然百度的方案都不行，所以我没成功过），防止死循环
        // catch块中重试可用redis的自增来做计数器，从而控制重试次数
        try {
            int i = 1/0;
        } catch (Exception e) {
            System.out.println("myQueue6:" +  new String(message.getBody()));
            channel.basicNack(message.getMessageProperties().getDeliveryTag(), false, true);
            // 达到重试次数后用这行代码返回ack，并将消息存缓存
            // channel.basicAck(message.getMessageProperties().getDeliveryTag(), false);
        }
    }
}
```

启动项目，访问http://localhost:8080/helloRabbit5，当返回nack时会不断打印“myQueue6:rabbitmq生成者发送失败和消费失败处理方案”（因为我这里没有设重试次数），当返回ack时，只打印一次。

# springboot+rabbitmq两小时入门（九）：如何保证消息按顺序执行

![img](https://csdnimg.cn/release/phoenix/template/new_img/original.png)

[我是一个写bug的程序员](https://me.csdn.net/qq_32880973) 2019-08-12 15:33:02 ![img](https://csdnimg.cn/release/phoenix/template/new_img/articleReadEyes.png) 2150 ![img](https://csdnimg.cn/release/phoenix/template/new_img/tobarCollect.png) 收藏 6

分类专栏： [springboot+rabbitmq2小时入门（纯注解）](https://blog.csdn.net/qq_32880973/category_9201078.html)

版权

下面1到3是摘自https://cloud.tencent.com/developer/article/1469388，红字是订正过后的，4是自己总结的。

### **1.为什么要保证顺序**

[消息队列](https://cloud.tencent.com/product/cmq?from=10680)中的若干消息如果是对同一个数据进行操作，这些操作具有前后的关系，必须要按前后的顺序执行，否则就会造成数据异常。举例： 比如通过mysql binlog进行两个数据库的数据同步，由于对数据库的数据操作是具有顺序性的，如果操作顺序搞反，就会造成不可估量的错误。比如数据库对一条数据依次进行了 插入->更新->删除操作，这个顺序必须是这样，如果在同步过程中，消息的顺序变成了 删除->插入->更新，那么原本应该被删除的数据，就没有被删除，造成数据的不一致问题。

 

### **2.出现顺序错乱的场景**

 ①一个queue，有多个consumer去消费。因为每个consumer的执行时间是不固定的，先读到消息的consumer不一定先完成操作。

![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hc2sucWNsb3VkaW1nLmNvbS9odHRwLXNhdmUveWVoZS00NzUyNzAyLzYzM2psaTQ0ZnIuanBlZz9pbWFnZVZpZXcyLzIvdy8xNjIw)

②一个queue对应一个consumer，但是consumer里面进行了多线程消费，这样也会造成消息消费顺序错误。

![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hc2sucWNsb3VkaW1nLmNvbS9odHRwLXNhdmUveWVoZS00NzUyNzAyL2owY3E0bXUzeDYuanBlZz9pbWFnZVZpZXcyLzIvdy8xNjIw)

 

### **3.保证消息的消费顺序**

①如图，把有关联的同一组消息1、2、3发到queue1中，然后消费者1消费，因为消息队列本来就是有序的，所以这样就有序。为了提高性能，搞多个queue，有关联的同一组消息发到同一队列，每个队列都有唯一的消费者。

![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hc2sucWNsb3VkaW1nLmNvbS9odHRwLXNhdmUveWVoZS00NzUyNzAyL2J0b3UweWk0ZWsuanBlZz9pbWFnZVZpZXcyLzIvdy8xNjIw)

一个queue对应一个consumer

②或者就一个queue但是对应一个consumer，然后这个consumer内部用内存队列做排队，然后分发给底层不同的worker来处理。原理和上面一样，都是保证同一组消息发给同一队列，然后被同一消费者消费。

![img](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9hc2sucWNsb3VkaW1nLmNvbS9odHRwLXNhdmUveWVoZS00NzUyNzAyL24xbXpiM2N5NzUuanBlZz9pbWFnZVZpZXcyLzIvdy8xNjIw)

 

4、有没有更好的办法

既然要求“同一组消息发给同一队列，然后被同一消费者消费”，那最好的办法是把同一组消息合并成一条。这样性能更好，无论多线程、还是多消费者都ok。

4.1有人可能说合并后会不会数据量太大？

答：a、大多数场景都不要求顺序执行。比如电商支付完后需要：App推送、短信推送、加积分、给仓库发发货的消息、修改购物推荐；比如支付宝抢红包，先抢到的不要求先到账。

​    b、极少数比如上面的通过mysql binlog进行数据库同步，虽然binlog数据量很大，但它是个文件，我们传的是文件名，多个文件名加起来也没多少。