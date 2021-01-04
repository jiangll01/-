一条消费成功被消费经历了生产者->MQ->消费者，因此在这三个步骤中都有可能造成消息丢失。

## 一 消息生产者没有把消息成功发送到MQ

### 1.1 事务机制

`AMQP`协议提供了事务机制，在投递消息时开启事务支持，如果消息投递失败，则回滚事务。

**自定义事务管理器**

```
@Configuration
public class RabbitTranscation {

    @Bean
    public RabbitTransactionManager rabbitTransactionManager(ConnectionFactory connectionFactory){
        return new RabbitTransactionManager(connectionFactory);
    }

    @Bean
    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory){
        return new RabbitTemplate(connectionFactory);
    }
}
```

**修改yml**

```
spring:
  rabbitmq:
    # 消息在未被队列收到的情况下返回
    publisher-returns: true
```

**开启事务支持**

```
rabbitTemplate.setChannelTransacted(true);
```

**消息未接收时调用ReturnCallback**

```
rabbitTemplate.setMandatory(true);
```

**生产者投递消息**

```
@Service
public class ProviderTranscation implements RabbitTemplate.ReturnCallback {

    @Autowired
    RabbitTemplate rabbitTemplate;

    @PostConstruct
    public void init(){
        // 设置channel开启事务
        rabbitTemplate.setChannelTransacted(true);
        rabbitTemplate.setReturnCallback(this);
    }

    @Override
    public void returnedMessage(Message message, int replyCode, String replyText, String exchange, String routingKey) {
        System.out.println("这条消息发送失败了"+message+",请处理");
    }

    @Transactional(rollbackFor = Exception.class,transactionManager = "rabbitTransactionManager")
    public void publishMessage(String message) throws Exception {
        rabbitTemplate.setMandatory(true);
        rabbitTemplate.convertAndSend("javatrip",message);
    }
}
```

但是，很少有人这么干，因为这是同步操作，一条消息发送之后会使发送端阻塞，以等待RabbitMQ-Server的回应，之后才能继续发送下一条消息，生产者生产消息的吞吐量和性能都会大大降低。

### 1.2 发送方确认机制

发送消息时将信道设置为`confirm`模式，消息进入该信道后，都会被指派给一个唯一ID，一旦消息被投递到所匹配的队列后，`RabbitMQ`就会发送给生产者一个确认。

**开启消息确认机制**

```
spring:
  rabbitmq:
    # 消息在未被队列收到的情况下返回
    publisher-returns: true
    # 开启消息确认机制
    publisher-confirm-type: correlated
```

**消息未接收时调用ReturnCallback**

```
rabbitTemplate.setMandatory(true);
```

**生产者投递消息**

```
@Service
public class ConfirmProvider implements RabbitTemplate.ConfirmCallback,RabbitTemplate.ReturnCallback {

    @Autowired
    RabbitTemplate rabbitTemplate;

    @PostConstruct
    public void init() {
        rabbitTemplate.setReturnCallback(this);
        rabbitTemplate.setConfirmCallback(this);
    }

    @Override
    public void confirm(CorrelationData correlationData, boolean ack, String cause) {
        if(ack){
            System.out.println("确认了这条消息："+correlationData);
        }else{
            System.out.println("确认失败了："+correlationData+"；出现异常："+cause);
        }
    }

    @Override
    public void returnedMessage(Message message, int replyCode, String replyText, String exchange, String routingKey) {
        System.out.println("这条消息发送失败了"+message+",请处理");
    }

    public void publisMessage(String message){
        rabbitTemplate.setMandatory(true);
        rabbitTemplate.convertAndSend("javatrip",message);
    }
}
```

如果消息确认失败后，我们可以进行消息补偿，也就是消息的重试机制。当未收到确认信息时进行消息的重新投递。设置如下配置即可完成。

```
spring:
  rabbitmq:
    # 支持消息发送失败后重返队列
    publisher-returns: true
    # 开启消息确认机制
    publisher-confirm-type: correlated
    listener:
      simple:
        retry:
          # 开启重试
          enabled: true
          # 最大重试次数
          max-attempts: 5
          # 重试时间间隔
          initial-interval: 3000
```

## 二 消息发送到MQ后，MQ宕机导致内存中的消息丢失

消息在MQ中有可能发生丢失，这时候我们就需要将队列和消息都进行持久化。

@Queue注解为我们提供了队列相关的一些属性，具体如下：

1. name: 队列的名称；

2. durable: 是否持久化；

3. exclusive: 是否独享、排外的；

4. autoDelete: 是否自动删除；

5. arguments：队列的其他属性参数，有如下可选项，可参看图2的arguments：

6. - x-message-ttl：消息的过期时间，单位：毫秒；
   - x-expires：队列过期时间，队列在多长时间未被访问将被删除，单位：毫秒；
   - x-max-length：队列最大长度，超过该最大值，则将从队列头部开始删除消息；
   - x-max-length-bytes：队列消息内容占用最大空间，受限于内存大小，超过该阈值则从队列头部开始删除消息；
   - x-overflow：设置队列溢出行为。这决定了当达到队列的最大长度时消息会发生什么。有效值是drop-head、reject-publish或reject-publish-dlx。仲裁队列类型仅支持drop-head；
   - x-dead-letter-exchange：死信交换器名称，过期或被删除（因队列长度超长或因空间超出阈值）的消息可指定发送到该交换器中；
   - x-dead-letter-routing-key：死信消息路由键，在消息发送到死信交换器时会使用该路由键，如果不设置，则使用消息的原来的路由键值
   - x-single-active-consumer：表示队列是否是单一活动消费者，true时，注册的消费组内只有一个消费者消费消息，其他被忽略，false时消息循环分发给所有消费者(默认false)
   - x-max-priority：队列要支持的最大优先级数;如果未设置，队列将不支持消息优先级；
   - x-queue-mode（Lazy mode）：将队列设置为延迟模式，在磁盘上保留尽可能多的消息，以减少RAM的使用;如果未设置，队列将保留内存缓存以尽可能快地传递消息；
   - x-queue-master-locator：在集群模式下设置镜像队列的主节点信息。

**持久化队列**

创建队列的时候将持久化属性durable设置为true，同时要将autoDelete设置为false

```
@Queue(value = "javatrip",durable = "true",autoDelete = "false")
```

**持久化消息**

发送消息的时候将消息的deliveryMode设置为2，在Spring Boot中消息默认就是持久化的。

## 三 消费者消费消息的时候，未消费完毕就出现了异常

消费者刚消费了消息，还没有处理业务，结果发生异常。这时候就需要关闭自动确认，改为手动确认消息。

**修改yml为手动签收模式**

```
spring:
  rabbitmq:
    listener:
      simple:
        # 手动签收模式
        acknowledge-mode: manual
        # 每次签收一条消息
        prefetch: 1
```

**消费者手动签收**

```
@Component
@RabbitListener(queuesToDeclare = @Queue(value = "javatrip", durable = "true"))
public class Consumer {

    @RabbitHandler
    public void receive(String message, @Headers Map<String,Object> headers, Channel channel) throws Exception{

        System.out.println(message);
        // 唯一的消息ID
        Long deliverTag = (Long) headers.get(AmqpHeaders.DELIVERY_TAG);
        // 确认该条消息
        if(...){
            channel.basicAck(deliverTag,false);
        }else{
            // 消费失败，消息重返队列
            channel.basicNack(deliverTag,false,true);
        }

    }
}
```

## 四 总结

#### 消息丢失的原因？

生产者、MQ、消费者都有可能造成消息丢失

#### 如何保证消息的可靠性？

- 发送方采取发送者确认模式
- MQ进行队列及消息的持久化
- 消费者消费成功后手动确认消息