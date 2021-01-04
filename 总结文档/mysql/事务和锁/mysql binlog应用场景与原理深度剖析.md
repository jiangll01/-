https://mp.weixin.qq.com/s?__biz=MzA5MDA5Njk0NQ==&mid=2456618823&idx=1&sn=a3fb36652c6c22ac8730d576503cbcd6&chksm=87897319b0fefa0f3c3c28c8545535a0b989914204c3b0ff75c00fa3903f26af5f0c6043e9eb&scene=21#wechat_redirect

本文深入介绍Mysql Binlog的应用场景，以及如何与MQ、elasticsearch、redis等组件的保持数据最终一致。最后通过案例深入分析binlog中几乎所有event是如何产生的，作用是什么。

**1 基于binlog的主从复制**

Mysql 5.0以后，支持通过binary log(二进制日志)以支持主从复制。复制允许将来自一个MySQL数据库服务器（master) 的数据复制到一个或多个其他MySQL数据库服务器（slave)，以实现灾难恢复、水平扩展、统计分析、远程数据分发等功能。

**二进制日志中存储的内容称之为事件，每一个数据库更新操作(Insert、Update、Delete，不包括Select)等都对应一个事件。**

**注意：本文不是讲解mysql主从复制，而是讲解binlog的应用场景，binlog中包含哪些类型的event，这些event的作用是什么。你可以理解为，是对主从复制中关于binlog解析的细节进行深度剖析。****而讲解主从复制主要是为了理解binlog的工作流程****。**

下面以mysql主从复制为例，讲解一个从库是如何从主库拉取binlog，并回放其中的event的完整流程。mysql主从复制的流程如下图所示：

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqv6zDH62IgeTrIUE9CGtxO44QWuX17sklgaUzU3xZAmkCG7uvHGe8Yg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



主要分为3个步骤：

- **第一步：**master在每次准备提交事务完成数据更新前，将改变记录到二进制日志(binary log)中（这些记录叫做二进制日志事件，binary log event，简称event)

- **第二步：**slave启动一个I/O线程来读取主库上binary log中的事件，并记录到slave自己的中继日志(relay log)中。 

- **第三步：**slave还会起动一个SQL线程，该线程从relay log中读取事件并在备库执行，从而实现备库数据的更新。

**2 binlog的应用场景**

binlog本身就像一个螺丝刀，它能发挥什么样的作用，完全取决你怎么使用。就像你可以使用螺丝刀来修电器，也可以用其来固定家具。

**2.1 读写分离**

最典型的场景就是通过Mysql主从之间通过binlog复制来实现横向扩展，来实现读写分离。如下图所示：



![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqdHVvAicEVCEmqKiaWfhcRj15RMDe8UHteX6M01K8iaxP2HTvB0ePtMXdg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



  在这种场景下：

- 有一个主库Master，所有的更新操作都在master上进行

- 同时会有多个Slave，每个Slave都连接到Master上，获取binlog在本地回放，实现数据复制。

- 在应用层面，需要对执行的sql进行判断。所有的更新操作都通过Master(Insert、Update、Delete等)，而查询操作(Select等)都在Slave上进行。由于存在多个slave，所以我们可以在slave之间做负载均衡。通常业务都会借助一些数据库中间件，如tddl、sharding-jdbc等来完成读写分离功能。

因为工作性质的原因，笔者见过最多的一个业务，一个master，后面挂了20多个slave。笔者之前写过一篇关于数据库中间件实现原理的文章，感兴趣的读者可以参考：[数据库中间件详解](http://mp.weixin.qq.com/s?__biz=MzA5MDA5Njk0NQ==&mid=2456618601&idx=1&sn=c10839f1797e7be1ea41f005b57432df&chksm=87897237b0fefb215dd74c28cf5b524984b8f50d2ef13293e37919774f1c51e36642e489ee38&scene=21#wechat_redirect)

**2.2 数据恢复**

一些同学可能有误删除数据库记录的经历，或者因为误操作导致数据库存在大量脏数据的情况。例如笔者，曾经因为误操作污染了业务方几十万数据记录。

如何将脏数据恢复成原来的样子？如果恢复已经被删除的记录？

这些都可以通过反解binlog来完成，笔者也是通过这个手段，来恢复业务方的记录。

**2.3 数据最终一致性**

在实际开发中，我们经常会遇到一些需求，在数据库操作成功后，需要进行一些其他操作，如：发送一条消息到MQ中、更新缓存或者更新搜索引擎中的索引等。

**如何保证数据库操作与这些行为的一致性，就成为一个难题**。以数据库与redis缓存的一致性为例：操作数据库成功了，可能会更新redis失败；反之亦然。很难保证二者的完全一致。

**遇到这种看似无解的问题，最好的办法是换一种思路去解决它：**不要同时去更新数据库和其他组件，只是简单的更新数据库即可。

如果数据库操作成功，必然会产生binlog。之后，我们通过一个组件，来模拟的mysql的slave，拉取并解析binlog中的信息。**通过解析binlog的信息，去异步的更新缓存、索引或者发送MQ消息，保证数据库与其他组件中数据的最终一致。**

在这里，我们将模拟slave的组件，统一称之为**binlog同步组件**。你并不需要自己编写这样的一个组件，已经有很多开源的实现，例如linkedin的databus，阿里巴巴的canal，美团点评的puma等。

当我们通过binlog同步组件完成数据一致性时，此时架构可能如下图所示：



![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqGPu5vO7zJVeFmnWP6pUpQUa89gFhXydS8PJLHXvAwJ0E5k3s3DTE3A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



**增量索引**

通常索引分为全量索引和增量索引。对于增量索引的部分，可以通过监听binlog变化，根据binlog中包含的信息，转换成es语法，进行实时索引更新。当然，你可能并没有使用es，而是solr，这里只是以es举例。

**可靠消息**

可靠消息是指的是：保证本地事务与发送消息到MQ行为的一致性。一些业务使用**本地事务表**或者**独立消息服务**，来保证二者的最终一致。Apache RocketMQ在4.3版本开源了**事务消息**，也是用于完成此功能。事实上，这两种方案，都有一定侵入性，对业务不透明。通过订阅binlog来发送可靠消息，则是一种解耦、无侵入的方案。关于可靠消息，笔者最近写了一篇文章， 感兴趣的读者可以参考：[可靠消息一致性的奇淫技巧](http://mp.weixin.qq.com/s?__biz=MzA5MDA5Njk0NQ==&mid=2456618733&idx=1&sn=2ffda081c7ba696f45d3bb392d4285b7&chksm=878972b3b0fefba5ddad677032e5b2250df5ade97baed09d19a05de08500a284c9135dcfe1ea&scene=21#wechat_redirect)。

**缓存一致性**

业务经常遇到的一个问题是，如何保证数据库中记录和缓存中数据的一致性。不妨换一种思路，只更新数据库，数据库更新成功后，通过拉取binlog来异步的更新缓存(通常是删除，让业务回源到数据库)。如果数据库更新失败，没有对应binlog，那么也不会去更新缓存，从而实现最终一致性。

**可以看到，binlog是一把利器，可以保证数据库与与其他任何组件(es、mq、redis等)的最终一致。这是一种优雅的、通用的、无业务入侵的、彻底的解决方案。****我们没有必要再单独的研究某一种其他组件如何与数据库保持最终一致，可以通过binlog来实现统一的解决方案****。**

在实际开发中，你可以简单的像上图那样，每个应用场景都模拟一个slave，各自连接到Mysql上去拉取binlog，master会给每个连接上来的slave一份完整的binlog拷贝，业务拿到各自的binlog之后进行消费，彼此之间互不影响。但是这样，有一些弊端，多个slave会给master带来一些额外管理上的开销，网卡流量也将翻倍的增长。

**我们可以进行一些优化，之所以不同场景模拟多个slave来连接master获取同一份binlog，****本质上要满足的是：一份binlog数据，同时提供给多个不同业务场景使用，彼此之间互不影响。**

显然，消息中间件是一个很好的解决方案。现在很多主流的消息中间件，都支持**consumer group**的概念，如kafka、rocketmq等。同一个topic中的数据，可以由多个不同consumer group来消费，且不同的consumer group之间是相互隔离的，例如：当前消费到的位置(offset)。

因此，我们完全可以将binlog，统一都发送到MQ中，不同的应用场景使用不同的consumer group来消费，彼此之间互不影响。此时架构如下图所示：



![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqqskCxbKLAun1L6vGxVWZ0LPg00ZwrDriafvdnRvzGstEEo3TxPlYKYQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



通过这样方式，我们巧妙的达到了一份数据多个应用场景来使用。一般，一个Mysql实例中可能会创建多个库(Database)，通常我们会将一个库的binlog放到一个对应的MQ中的Topic中。

当将binlog发送到MQ中后，我们就可以利用MQ的一些高级特性了。例如binlog发送到MQ过快，消费方来不及消费，可以利用MQ的消息堆积能力进行流量削峰。还可以利用MQ的消息回溯功能，例如一个业务需要消费历史的binlog，此时MQ中如果还有保存，那么就可以直接进行回溯。

当然，有一些binlog同步组件可能实现了类似于MQ的功能，此时你就无序再单独的使用MQ。

**2.4 异地多活**

一个更大的应用场景，异地多活场景下，跨数据中心之间的数据同步。这种场景的下，多个数据中心都需要写入数据，并且往对方同步。以下是一个简化的示意图：



![img](data:image/gif;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQImWNgYGBgAAAABQABh6FO1AAAAABJRU5ErkJggg==)



这里有一些特殊的问题需要处理。典型的包括：

- **数据冲突：**双方同时插入了一个相同主键的值，那么往对方同步时，就会出现主键冲突的错误。

- **数据回环：**一个库A中插入的数据，通过binlog同步到另外一个库B中，依然会产生binlog。此时库B的数据再次同步回库A，如此反复，就形成了一个死循环。

如何解决数据冲突、数据回环，就变成了binlog同步组件要解决的问题。同样，业界也有了成熟的实现，比较知名的有阿里开源的otter，以及摩拜(已经属于美团)的DRC等。

笔者之前写过一篇文章，介绍如何在多机房进行数据同步，感兴趣的读者可以参考以下文章：[异地多活场景下的数据同步之道](http://mp.weixin.qq.com/s?__biz=MzA5MDA5Njk0NQ==&mid=2456618627&idx=1&sn=fce8115fd8f125cd7f2402c19b57c20a&chksm=878972ddb0fefbcb2895570a5c8f5a4d73f6b79681f96ebb2c303810b06d6887963c07204459&scene=21#wechat_redirect)

**2.5 小结**

如前所属，binlog的作用如此强大。因此，你可能想知道binlog文件中到底包含了哪些内容，为什么具有如此的魔力？在进行一些数据库操作时，例如：Insert、Update、Delete等，到底会对binlog产生什么样的影响？这正是本文要下来要讲解的内容。

**3 Binlog事件详解**

Mysql已经经历了多个版本的发布，最新已经到8.x，然而目前企业中主流使用的还是Mysql 5.6或5.7。不同版本的Mysql中，binlog的格式和事件类型可能会有些细微的变化，不过暂时我们并不讨论这些细节。

总的来说，binlog文件中存储的内容称之为二进制事件，简称事件。我们的每一个数据库更新操作(Insert、Update、Delete等)，都会对应的一个事件。

从大的方面来说，binlog主要分为2种格式：

- **Statement模式：**binlog中记录的就是我们执行的SQL；

- **Row模式：**binlog记录的是每一行记录的每个字段变化前后得到值。

熟悉主从复制的同学，应该知道，还有第三种模式**Mixed**(即混合模式)，从严格意义上来说，这并不是一种新的binlog格式，只是结合了Statement和Row两种模式而已。

当我们选择不同的binlog模式时，在binlog文件包含的事件类型也不相同，如: **1)**在Statement模式下，我们就看不到Row模式下独有的事件类型。**2)**有一些类型的event，必须在我们开启某些特定配置的情况下，才会出现；**3)**当然也会有一些公共的event类型，在任何模式下都会出现。

Mysql中定义了30多个event类型，这里并不打算将所有的事件类型提前列出，这样没有意义，只会让读者茫然不知所措。笔者将会在必要的地方，介绍遇到的每一种event类型的作用。

目前我们先从宏观的角度对binlog有一个感性的认知。

**3.1 多文件存储**

mysql 将数据库更新操作对应的event记录到本地的binlog文件中，显然在一个文件中记录所有的event是不可能的，过大的文件会给我们的运维带来麻烦，如删除一个大文件，在I/O调度方面会给我们带来不可忽视的资源开销。

因此，目前基本上所有支持本地文件存储的组件，如MQ、Mysql等，都会控制一个文件的大小。在数据量较多的情况下，就分配到多个文件进行存储。

在mysql中，我们可以通过"show binary logs"语句，来查看当前有多少个binlog文件，以及每个binlog文件的大小，如下：

![img](data:image/gif;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQImWNgYGBgAAAABQABh6FO1AAAAABJRU5ErkJggg==)

另外，mysql提供了：

- **max_binlog_size**配置项，用于控制一个binlog文件的大小，默认是1G

- **expire_logs_days**配置项，可以控制binlog文件保留天数，默认是0，也就是永久保留。

在实际生产环境中，一般无法保留所有的历史binlog。因为一条记录可能会变更多次，记录依然是一条，但是对应的binlog事件就会有多个。在数据变更比较频繁的情况下，就会产生大量的binlog文件。此时，则无法保留所有的历史binlog文件。

在mysql的percona分支上，还提供了**max_binlog_files**配置项，用于设置可以保留的binlog文件数量，以便我们更精确的控制binlog文件占用的磁盘空间。这是一个非常有用的配置，笔者曾经遇到一个库，大约10分钟就会产生一个binlog文件，也就是1G，按照这种增长速度，1天下来产生的binlog文件，就会占用大概144G左右的空间，磁盘空间可能很快就会被使用完。通过此配置，我们可以显示的控制binlog文件的数量，例如指定50，binlog文件最多只会占用50G左右的磁盘空间。

在更高版本的mysql中，支持按照秒级精度，来控制binlog文件的保留时间。下面我们将对binlog文件中的内容进行详细的讲解。

**3.2 Binlog管理事件**

所谓binlog管理事件，官方称之为binlog managent events，你可以认为是一些在任何模式下都有可能会出现的事件，不管你的配置binlog_format是Row、Statement还是Mixed。

以下通过**"show binlog events"**语法进行查看一个空的binlog文件，也就是只包含(部分)管理事件，没有其他数据更新操作对应的事件。如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXq3uxnya6EdSgnYFvyDdZXRtz6jlt7gpolfs259zCBbXOHU8JA8hDQ2w/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

在当前binlog v4版本中，每个binlog文件总是以**Format Description Event**作为开始，以**Rotate Event**结束作为结束。如果你使用的是很古老的Mysql版本中，开始事件也有可能是**START EVENT V3，**而结束事件是**Stop Event****。**在开始和结束之间，穿插着其他各种事件。

在Event_Type列中，我们看到了三个事件类型：

- **Format_desc：**也就是我们所说的Format Description Event，是binlog文件的第一个事件。在Info列，我们可以看到，其标明了Mysql Server的版本是5.7.10，Binlog版本是4。

- **Previous_gtids：**该事件完整名称为，PREVIOUS_GTIDS_LOG_EVENT。熟悉Mysql 基于GTID复制的同学应该知道，这是表示之前的binlog文件中，已经执行过的GTID。需要我们开启GTID选项，这个事件才会有值，在后文中，将会详细的进行介绍。

- **Rotate：**Rotate Event是每个binlog文件的结束事件。在Info列中，我们看到了其指定了下一个binlog文件的名称是mysql-bin.000004。



关于**"show binlog events"**语法显示的每一列的作用说明如下：

- Log_name：当前事件所在的binlog文件名称

- Pos：当前事件的开始位置，每个事件都占用固定的字节大小，结束位置(End_log_position)减去Pos，就是这个事件占用的字节数。细心的读者可以看到了，第一个事件位置并不是从0开始，而是从4。Mysql通过文件中的前4个字节，来判断这是不是一个binlog文件。这种方式很常见，很多格式的文件，如pdf、doc、jpg等，都会通常前几个特定字符判断是否是合法文件。

- Event_type：表示事件的类型

- Server_id：表示产生这个事件的mysql server_id，通过设置my.cnf中的**server-id**选项进行配置。

- End_log_position：下一个事件的开始位置

- Info：当前事件的描述信息

**3.3 Statement模式下的事件**

mysql5.0及之前的版本只支持基于语句的复制，也称之为逻辑复制，也就是binary log文件中，直接记录的就是数据更新对应的sql。

假设有名为test库中有一张user表，如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqnMwpEhQhRjHr5fxiaqbmTEVn2yLLnA7291NdGT6292uAZ9W3iaG5lsjQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

现在，我们往user表中插入一条数据

- 

```
insert into user(name) values("tianbowen");
```

之后，可以使用"**show binlog events**" 语法查看binary log中的内容，如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqwyDgD8EDUpE6t6pibgHamxYUwAf7AE98phjewxaTXA20D7aAunhkn6Q/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

​    红色框架中Event，是我们执行上面Insert语句产生的4个Event。下面进行详细的说明：

**(划重点)首先，需要说明的是，每个事务都是以****Query Event****作为开始，其INFO列内容为"BEGIN"，以****Xid Event****表示结束，其INFO列内容为COMMIT。即使对于单条更新SQL我们没有开启事务，Mysql也会默认的帮我们开启事务**。因此在上面的红色框中，尽管我们只是执行了一个INSERT语句，没有开启事务，但是Mysql 默认帮我们开启了事务，所以第一个Event是Query Event，最后一个是Xid Event。

接着，是一个**Intvar Event**，因为我们的Insert语句插入的表中，主键是自增的(AUTO_INCREMENT)列，Mysql首先会自增一个值，这就是Intvar Event的作用，这里我们看到INFO列的值为INSERT_ID=1，也就是说，这次的自增主键id为1。需要注意的是，这个事件，只会在Statement模式下出现。

然后，还是一个Query Event，这里记录的就是我们插入的SQL。这也体现了Statement模式的作用，就是记录我们执行的SQL。

Statement模式下还有一些不常用的Event，如**USER_VAR_EVENT**，这是用于记录用户设置的变量，仅仅在Statement模式起作用。如：

执行以下SQL：

- 
- 

```
set @name = 'tianshouzhi';insert into user(name) values(@name);
```

这里，我们插入sql的时候，通过引用一个变量。此时查看binlog变化，这里为了易于观察，在执行show binlog events时，指定了binlog文件和from的位置，即只查看指定binlog文件中从指定位置开始的event。如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqwqgczOz25da2VbRNxiayuZOnDhEwbOUiaU9xXicw78OAJhu40G1RyRgwA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

可以看到，依然符合我们所说的，对于这个插入语句，依然默认开启了事务。主键自曾值INSERT_ID=2。

当然，我们也看到了User var这个事件，其记录了我们的设置的变量值，只不过以16进制显示。

**3.4 Row模式下的事件**

mysql5.1开始支持基于行的复制，这种方式记录的某条sql影响的所有行记录**变更前**和**变更后**的值。Row模式下主要有以下10个事件：

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXq4LjicGGtxiamticbqt1Vomg2YEH0jT3GCACbiaNPMB2Gy9XXm19AYJMIBg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

很直观的，我们看到了INSERT、DELETE、UPDATE操作都有3个版本(v0、v1、v2)，v0和v1已经过时，我们只需要关注V2版本。

此外，还有一个**TABLE_MAP_EVENT**，这个event我们需要特别关注，可以理解其作用就是记录了INSERT、DELETE、UPDATE操作的表结构。

下面，我们通过案例演示，ROW模式是如何记录变更前后记录的值，而不是记录SQL。这里只演示UPDATE，INSERT和DELETE也是类似。

在前面的操作步骤中，我们已经插入了2条记录，如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqB0LajwNnE6YREeHz32Bias4AetY8EzuhYQpUWV0vRicANGxfeGNVTx0A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

现在需要从Statement模式切换到Row模式，重启Mysql之后，执行以下SQL更新这两条记录：

- 

```
update user set name='wangxiaoxiao';
```

在binary log中，会把这2条记录变更前后的值都记录下来，以下是一个逻辑示意图：

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXquvD5pG69dj6PQPjZGeWEJK3xT776F9dr1FDq7hlG166KuVxEK56Hpg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



该逻辑示意图显示了，在默认情况下，受到影响的记录行，每个字段变更前的和变更后的值，都会被记录下来，即使这个字段的值没有发生变化**。**

接着，我们还是通过"show binlog events"语法来验证：

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqhficolAMiaZ7TIibdeaYLiasDuiaHjt9bLz45ibautS6HX0vevU59CFHCXJA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

首先我们可以看到的是，在Row模式下，单条SQL依然会默认开启事务，通过Query Event(值为BEGIN)开始，以Xid Event结束。

接着，我们看到了一个Table_map 事件，就是前面提到的TABLE_MAP_EVENT，在INFO列，我们可以看到其记录table_id为108，操作的是test库中user表。

最后，是一个**Update_rows**事件，然而其INFO，并没有像Statement模式那样，显示一条SQL，我们无法直接看到其变更前后的值是什么。

由于存储的都是二进制内容，直接vim无法查看，我们需要借助另外一个工具**mysqlbinlog**来查看其内容。如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqGWt7Sws3KTGECjlMVbKbqY1SVa4iaic36HnNnF3OKhy8X9khBFW5icc3w/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

截图中显示了2个event，第一个红色框就是Table_map事件，第二个是Update_rows事件。

在第二个红色框架中，显示了两个Update sql，这是只是mysqlbinlog工具为了方便我们查看，反解成SQL而已。我们看到了WHERE以及SET子句中，并没有直接列出字段名，而是以**@1**、**@2**这样的表示字段位于数据库表中的顺序。**事实上，这里显示的内容，WHERE部分就是每个字段修改前的值，而SET部分，则是每个字段修改后的值，**也就是变更前后的值都会记录。

这里我们思考以下mysqlbinlog工具的工作原理，其可以将二进制数据反解成SQL进行展示。那么，**如果我们可以自己解析binlog，就可以做数据恢复，这并非是什么难事**。例如用户误删除的数据，执行的是DETELE语句，由于Row模式下会记录变更之前的字段的值，我们可以将其反解成一个INSERT语句，重新插入，从而实现数据恢复。

**3.4.1 binlog_row_image参数**

我们经常会看到一些Row模式和Statement模式的比较。ROW模式下，即使我们只更新了一条记录的其中某个字段，也会记录每个字段变更前后的值，binlog日志就会变大，带来磁盘IO上的开销，以及网络开销。

事实上，这个行为可以通过**binlog_row_image**控制其有3个值，默认为FULL： 

- FULL : 记录列的所有修改，即使字段没有发生变更也会记录。 

- MINIMAL ：只记录修改的列。 

- NOBLOB :如果是text类型或clob字段，不记录这些日志。 



![img](data:image/gif;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQImWNgYGBgAAAABQABh6FO1AAAAABJRU5ErkJggg==)

我们可以将其修改为MINIMAL，则可以只记录修改的列的值。

**3.4.2 binlog_rows_query_log_events参数**

在Statement模式下，直接记录SQL比较直观，事实上，在Row模式下，也可以记录。mysql提供了一个**binlog_rows_query_log_events**参数，默认为值为FALSE，如果为true的情况下，会通过**Rows Query Event**来记录SQL。



![img](data:image/gif;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQImWNgYGBgAAAABQABh6FO1AAAAABJRU5ErkJggg==)

 可以在my.cnf中添加以下配置，来开启row模式下的原始sql记录(需要重启)：

```
binlog-rows-query-log_events=1
```

之后，再插入数据数据时

```
insert into user(name) values("maoxinyi");
```

在binlog文件中，我们将看到**Rows Query Event**

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqGJEl5shF6YxHE6qvY6ibH6sweM744nHwdYsb6Ph0oSL0hHicsYZ9QPfA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**3.5 GTID相关事件**

从MySQL 5.6开始支持GTID复制。要开启GTID，修改my.cnf文件，添加以下配置

```
gtid-mode=onenforce-gtid-consistency=true
```

在这种情况下，每当我们执行一个事务之前，都会记录一个**GTID Event**

```
insert into user("name") values("zhuyihan");
```

此时binlog内容如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqk7fiaTnjibXuLXX04L0myib2QQztQp3zV6C0av3RicrMdyVQUf2yicicJKjw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

而当我们切换到下一个binlog文件时，会记录之前的已经执行过的GTID。这里我们通过执行以下sql手工切换到一个新的binlog文件。

```
mysql> flush logs;Query OK, 0 rows affected (0.00 sec)
```

之后在新的binlog文件中，我们看到之前执行过的GTID在下一个文件中出现了。

![img](https://mmbiz.qpic.cn/mmbiz_png/xmvcWIfCQiaDG8tQLcgHod1sibcYIBwMXqlW8rYyIIFsrAgYPVqk3QvU9qVia7LW4SmJ07fvITgQ9icicHXWqQZyAIA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

本文不是专门讲解GTID的文章，感兴趣的读者，可以自行查看相关资料。

**4 总结**

本文对mysql binlog的应用场景进行了深入的讲解，并介绍了mysql中大部分binlog event的作用。

如果读者想更加深入的去学习，例如如何模拟mysql的slave去解析binlog，可以参考一些开源的实现，不过这些生产级别的组件，因此通常代码比较复杂。笔者自己也造过类似的轮子，仅仅模拟slave去拉取mysql的binlog，并对事件进行解析，对于理解binlog解析的核心原理应该有一些帮助。

感兴趣的读者可以关注公众号，加我好友。另外，笔者最近建立了一个技术交流群，大家可以一起交流。