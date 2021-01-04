######  kafka入门

![img](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1fzJ5GDcNhdf30yoUqxGHS9bT7h8NPzznYhvibTpEdhDhxmI3gfkJP4xl6lquibCPeoPWGxEPAFr6w/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

- 使用消息队列不可能是单机的（必然是分布式or集群）
- 数据写到消息队列，可能会存在数据丢失问题，数据在消息队列需要**持久化**(磁盘？数据库？Redis？分布式文件系统？)
- 想要保证消息（数据）是有序的，怎么做？
- 为什么在消息队列中重复消费了数据

## 1.1 Kafka入门

众所周知，Kafka是一个消息队列，把消息放到队列里边的叫**生产者**，从队列里边消费的叫**消费者**。

![生产者和消费者](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1fzJ5GDcNhdf30yoUqxGHSCcPLLczkhtSJOjsKdrYTdXGzrh4m09FtjaHNQsEV9vbe8rOKhQTSOw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)生产者和消费者

一个消息中间件，队列不单单只有一个，我们往往会有多个队列，而我们生产者和消费者就得知道：把数据丢给哪个队列，从哪个队列消息。我们需要给队列取名字，叫做**topic**(相当于数据库里边**表**的概念)

![给队列取名字，专业名词叫topic](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1fzJ5GDcNhdf30yoUqxGHSAQlIDjwPwS22av55eB8wtGoTS00WwAzrBHiaoK0f5o1mGib9EsnLK5IA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)给队列取名字，专业名词叫topic

现在我们给队列取了名字以后，生产者就知道往哪个队列丢数据了，消费者也知道往哪个队列拿数据了。我们可以有多个生产者**往同一个队列(topic)**丢数据，多个消费者**往同一个队列(topic)**拿数据

![img](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1fzJ5GDcNhdf30yoUqxGHSKC8E9qbOX0CbfKE2zib77wzOicT6GWZxv4nushlFQrFUbv98P68o4TEg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

为了提高一个队列(topic)的**吞吐量**，Kafka会把topic进行分区(**Partition**)

![Kafka分区](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1fzJ5GDcNhdf30yoUqxGHSAPbaicgRorFWGg4DQBTmFJwlzbIiczsVAYBdtjvqDXAL5LiawocvmI98g/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)Kafka分区

所以，生产者实际上是往一个topic名为Java3y中的分区(**Partition**)丢数据，消费者实际上是往一个topic名为Java3y的分区(**Partition**)取数据

![生产者和消费者实际上操作的是分区](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1fzJ5GDcNhdf30yoUqxGHSoMDSug06DTcXR5vkBAZ0FKqg277rlw5sWRQqN6ejkceZhDHe3boJag/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)生产者和消费者实际上操作的是分区

一台Kafka服务器叫做**Broker**，Kafka集群就是多台Kafka服务器：


![Kafka集群](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1fzJ5GDcNhdf30yoUqxGHSiaWNEPEIq117QqjJJjROVZFFbkHchXgCuHxicVYKZrZcu8RzUPUSoWyA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)Kafka集群

一个topic会分为多个partition，实际上partition会**分布**在不同的broker中，举个例子：

![一个生产者丢数据给topic](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1fzJ5GDcNhdf30yoUqxGHSzFg8c2RMeOSllhV91sIibY9V9YXhGOYVqETSn1csLElrZRULjmjNfRw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)一个生产者丢数据给topic

由此得知：**Kafka是天然分布式的**。