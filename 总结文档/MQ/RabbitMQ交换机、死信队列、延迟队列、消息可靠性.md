## [RabbitMQ交换机、死信队列、延迟队列、消息可靠性](https://www.cnblogs.com/lcmlyj/p/12742979.html)

## RabbitMQ的四种交换机

交换机的作用是接收消息，并转发到绑定的队列，四种类型：Direct, Topic, Headers and Fanout

### Direct

Direct类型的Exchange交换机，在生产者发送消息时，会去严格匹配生产者所绑定的队列queue名称

### Topic（最为灵活）

给队列绑定routing_key(路由key)，发送消息时，就根据发送消息传回的参数去匹配这个routing_key，然后根据匹配情况把消息分配到对应的消息队列中；

举个例子：

与交换机绑定的queue是 #.abc，生产者发消息当routing_key设置为 any.abc时（这里any可以为任何值），那么这个最终生产者所发的消息都会发送给绑定到 #.abc的队列中去

### Headers

生产者发出消息时，无论routing_key设置成什么，这个消息都是根据生产者与队列的headers参数比对结果来判断是否发送消息。

比对的方式，通过在绑定队列时设置头，有两种设置方式：

x-match:all --------------> 表示要头全部匹配上才发送到队列中

x-match:any --------------> 表示要头只要有一个匹配上就发送到队列中

### Fanout

生产者发出消息时，无论routing_key设置成什么，这个消息都会被等量复制发送给所有绑定到Fanout类型Exchange的队列queue中去

 

------

 

## RabbitMQ死信队列

### 死信定义

dead-letter，死信，以下几种情况会发生死信并让死信进入死信队列：

1.消费方调用channel.basicNack或者channel.basicReject时，并且requeue参数设置为false

2.消息在队列中存在时间超过TTL(time-to-live)

3.消息超过了队列允许的最大长度；

死信队列需要在配置队列queue时，设置死信队列信息

### 如何处理死信

1.配置死信队列交换机，死信队列queue，死信队列其实和普通的队列本质上一样，只是可以专门来处理死信而已；

2.为正常队列设置死信队列信息，需要用map设置以下参数：

x-dead-letter-exchange:死信队列交换机

x-dead-letter-routing-key:死信队列routing-key，注意：如果配置了这个参数，那么死信进来之后其routing-key也会替换成这个参数，否则就保留其本身的routing-key

 

------

 

## RabbitMQ延迟队列

### 延迟队列是什么

　　延迟队列指的是，队列需要在**指定时间**之后才被消费。

　　在特有的场景下可以使用延迟队列，例如一些定时通知的业务，可以通过延迟队列实现。

### TTL实现延迟队列

　　首先，  **TTL** 是什么。TTL是英文 **time to live** 的缩写，就是最大存活时间。在上一节有说到消息队列在队列中存活超过TTL设置的时间之后，会进入死信队列。而延迟队列则正是通过给队列设置TTL过期时间，然后在这个时间过期之后，这个消息成为死信并进入到 **死信队列** 中。这样就实现了死信队列。

　　但是，TTL实现延迟队列有以下几个问题：

　　1.在队列上配置TTL，有不可扩展性，每有一个业务需要不同的TTL就需要一个新的队列来配置，这样不合理。于是，可以在消息本身设置TTL。

　　2.队列有先入先出的特性，在第一条消息被处理成死信之前，第二条消息无法被处理。例如，队列A先进来，设置了TTL 10秒，随后立刻让队列B进来，设置了TTL 1秒。这个时候会发生这种情况，A队列在被处理成死信之前（需要10秒时间），B队列设置TTL是1秒，理论上来说B队列在1秒之后会被处理成死信，但是，实际上RabbitMQ在处理的时候会先处理A，后面的队列依次等待。于是呢，需要RabbitMQ的延迟队列插件来实现，具体可以看下面的链接和方法。

### 插件实现延迟队列

　　首先，在官网下载插件： rabbitmq_delayed_message_exchange ，https://www.rabbitmq.com/community-plugins.html，然后放到其插件目录中再重启即可。

　　安装成功之后，就可以像上面第2条所说的那样，后入队的B队列1秒之后就被处理成了死信，先入队的A队列在10秒之后被处理成死信，就不存在处理顺序的问题了。

 

------

 

## RabbitMQ消息可靠性

### 什么是消息可靠性

　　咱们的系统在实际工作中难免会遇到各种各样的问题，比如宕机、网络波动等等。那么在遇到这些问题的时候，RabbitMQ如果不做消息可靠性的处理的话，那么会丢失消息，一些不重要的业务还好，要是遇到涉及到钱或者核心业务的时候，消息可靠性就很重要了。

　　RabbitMQ的消息可靠性问题可能会出现在哪些地方呢？

　　RabbitMQ分为生产者和消费者，生产者出问题就不会发消息了，这个没有问题。大部分问题就出在生产者发出消息之后的流程中。

　　 生产者发消息 ---> 路由 -> 队列 -> 消费者监听队列 -> 消费者消费 

　　这里面每个环节都可能出问题，比如路由错了，队列错了，消费者挂了，等等。于是就需要多种方法去解决这个问题来保证消息的可靠性。

### 处理消息可靠性的几种方式

　　首先，消费者成功消费之后，有两种方式让生产者知道成功消费了，从而保证了消息的可靠性，这两种方式分别是**RabbitMQ事务机制**和**RabbitMQ回调机制。**待会在下文详说怎么配置。

　　其次，还有就是消息从**生产者**到**路由**还没到**消费者**的时候出问题。这种情况可以通过两种方式解决：消息发送失败**强制回调**和**备份路由**的机制。当备份路由与强制回调同时开启的情况，优先使用备份路由。

### RabbitMQ事务机制

　　要实现RabbitMQ事务机制，首先需要注入 RabbitTransactionManager 

```
@Bean
public RabbitTransactionManager rabbitTransactionManager(ConnectionFactory connectionFactory) {
    return new RabbitTransactionManager(connectionFactory);
}
```

　　还需要给RabbitTemplate设置channelTransactional的值

```
@PostConstruct
private void init() {
    rabbitTemplate.setChannelTransacted(true);
}
```

　　最后，给对应的方法上加上注解 @Transactional ，这样就实现了RabbitMQ的事务。

　　就我个人的理解的话，这个事务仅仅是在消息发送方（生产者）的一个事务，只要消息发送到了队列并提交事务成功之后，这个事务就算是成功了，不管消费者有没有消费。而事务的开销非常大，开事务比不开事务要多很多网络等开销，所以效率低下。于是有了下面的RabbitMQ消费成功的回调机制。

### RabbitMQ回调机制

　　RabbitMQ在消费者消费成功并确认消息时，可以回调RabbitMQ设置开启的回调函数，来确认消费了。回调函数是通过一个唯一id来判断是回调的哪一个队列。

　　首先，开启配置publisher-confirms: true　　

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
spring:
  rabbitmq:
    host: 192.168.1.1
    port: 5672
    username: root
    password: 123456
    listener:
      type: simple
      simple:
        default-requeue-rejected: false
        acknowledge-mode: manual
    publisher-confirms: true
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

　　然后，实现**RabbitTemplate.ConfirmCallback**接口，实现对应的confirm()方法，并将其赋值给RabbitTemplate的成员变量

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
@Autowired
private RabbitTemplate rabbitTemplate;

@PostConstruct
private void init() {
    rabbitTemplate.setConfirmCallback(new RabbitTemplate.ConfirmCallback() {
        @Override
        public void confirm(CorrelationData correlationData, boolean ack, String cause) {
            //CorrelationData包含唯一id信息，生产者发消息的时候需要生成唯一id，并将id信息和消息一起发送
            log.info("唯一id:{}", correlationData.getId());
        }
    });
}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

　　还要注意，在发消息的时候，需要生成唯一id，用于回调时根据id判断是哪个队列。

```
CorrelationData correlationData = new CorrelationData(UUID.randomUUID().toString());
rabbitTemplate.convertAndSend(RabbitMQConfig.DIRECT_EXCHANGE, "direct", msg, correlationData);
```

### 路由失败强制回调

　　首先，配置文件开启**强制回调**，注意，也可以通过调用RabbitTemplate方法**setMandatory(true)**来设置。

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
spring:
  rabbitmq:
    host: 192.168.99.100
    port: 5672
    username: root
    password: Tykj@Rabbit
    listener:
      type: simple
      simple:
        default-requeue-rejected: false
        acknowledge-mode: manual
    publisher-confirms: true
    template:
      mandatory: true
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

　　然后，给RabbitTemplate设置RabbitTemplate.ReturnCallBack的实现类，就可以实现当**路由寻找队列失败**时，回调returnedMessage()方法

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
rabbitTemplate.setReturnCallback(new RabbitTemplate.ReturnCallback() {
    @Override
    public void returnedMessage(Message message, int replyCode, String replyText, String exchange, String routingKey) {
        log.info("消息路由失败");
    }
});
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

### 备份路由

　　在配置路由的时候，通过配置备份路由参数。备份路由也需要像其他正常路由一样，进行注入配置。关键是配置 alternate-exchange 参数

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
@Bean("directExchange")
public DirectExchange directExchange(){
    Map<String, Object> args = new HashMap<>();
    args.put("alternate-exchange", "backup.exchange");
    return new DirectExchange(DIRECT_EXCHANGE,true, false, args);
}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 