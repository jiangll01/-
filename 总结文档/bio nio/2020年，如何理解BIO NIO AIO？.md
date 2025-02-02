# 2020年，如何理解BIO NIO AIO？

[![Tachibana Kanade](https://pic3.zhimg.com/v2-4431ef451cd64028199f74dbc4049ca7_xs.jpg?source=172ae18b)](https://www.zhihu.com/people/zlh-15)

[Tachibana Kanade](https://www.zhihu.com/people/zlh-15)

为了自由

关注他

4 人赞同了该文章

## 先说结论

今天阅读了很多关于BIO NIO AIO的文章，举了各种奇怪的例子，都没把问题讲清楚，简单问题复杂化。我**先下结论**，最后再把那些博客的例子来品一品。

这里只考虑**两个实体**（客户端、服务端），**一个事件**（客户端向服务端请求数据）

**同步、异步**描述的是：**客户端在请求数据的过程中，能否做其他事情。**

**阻塞、非阻塞**描述的是：**客户端与服务端是否从头到尾始终都有一个持续连接，以至于占用了通道，不让其他客户端成功连接。**

那么BIO NIO AIO就可以简单的理解为：

- BIO（同步阻塞）：客户端在请求数据的过程中，**保持一个连接**，**不能做其他事情**。
- NIO（同步非阻塞）：客户端在请求数据的过程中，**不用保持一个连接**，不能做其他事情。（不用保持一个连接，而是用许多个小连接，也就是轮询）
- AIO（异步非阻塞）：客户端在请求数据的过程中，不用保持一个连接，**可以做其他事情**。（客户端做其他事情，数据来了等服务端来通知。）

是不是逻辑清楚了？结论下完了，再说一下同步与阻塞的语义理解。

- 同步的意思是：客户端与服务端 相同步调[[1\]](https://zhuanlan.zhihu.com/p/111816019#ref_1)。就是说 服务端 没有把数据给 客户端 之前，客户端什么都不能做。它们做同样一件事情，就是说它们有相同步调，即同步。
- 阻塞的意思是：客户端与服务端之间是否始终有个东西占据着它们中间的通道。就是说 客户端与服务端中间，始终有一个连接。导致其他客户端不能继续建立新通道连接服务器。

## BIO NIO AIO在处理什么问题？

做科研讲究一个Motivation，做技术也是一样。为什么会出现NIO AIO？NIO比BIO好在哪？AIO比BIO好在哪？[[2\]](https://zhuanlan.zhihu.com/p/111816019#ref_2)

### BIO（同步阻塞）

定义：客户端在请求数据的过程中，**保持一个连接**，**不能做其他事情**。

那么BIO存在两个问题：

1. 由于**连接是双向**的，“始终保持一个连接”，则说明，对于客户端和服务端而言，都需要一个线程来维护这个连接，如果服务端没有数据给客户端，则客户端需要一直等待，该连接也需要一直维持。假设一个连接需要5MB的内存，不考虑多任务的情况下，客户端总是要花费固定的5MB。那么对服务端，1个客户端建立连接则需要花5MB，10个就要50MB，1000个就要5GB。显然，阻塞给服务器带来的性能负担极大。
2. 客户端不能做其他事情，只能等待该请求的完成，其本身的性能没有得到充分的释放，所以等待就是浪费时间。

### NIO（同步非阻塞）

定义：客户端在请求数据的过程中，**不用保持一个连接**，不能做其他事情。

上面提到BIO，当有很多个客户端同时向服务端请求数据时，其连接所花费的开销就极大。那么NIO就使用了“不用始终保持一个连接”的方式，解决该问题。其过程为：

客户端发送一个请求，并建立一个连接，服务端接收到了。如果服务端没有数据，就告知客户端“没有数据”；如果有数据，则返回数据。客户端接到了服务端回复的“没有数据”就断开连接，过了一段时间后，客户端重新问服务端是否有数据。服务器重复以上步骤。

客户端反复建立连接询问，如果没有数据则断开连接。这个过程称为“轮询”。**NIO用轮询代替了始终保持一个连接。**

那么这样具体会有什么收益呢？

我们考虑以下问题：假如一个轮询连接只持续1s，服务器需要4s来准备一个数据，客户端在接到“没有数据”的回复后，隔1s再轮询一次。

对于BIO，1000个连接就需要5GB，在4s内，服务器内存消耗都是5GB。

对于NIO，在第1s内，服务器接收1000个连接的请求并花费5GB；在第2s内，服务器没有接收任何请求；在第3s内，服务器再次花费5GB接收1000个连接；第4s内没有请求；第5s开始时，处理所有请求返回结果。

整个流程是：为了接收1000个连接的请求，第1和第3s花费5GB，第2和第4s花费0GB，平均下来则是2.5GB。换个角度实际上是，1000个连接需要花费2.5GB，则2000个请求需要花费5GB。

在该例子中，NIO的容纳量比BIO高了一倍（5GB的容纳量从1000变成2000）

所以NIO的收益就是，节约了“始终保持一个连接”的内存消耗。

### AIO（异步非阻塞）

定义：客户端在请求数据的过程中，不用保持一个连接，**可以做其他事情**。

AIO也不用始终保持一个连接，但是其处理方式和NIO是不同的。并且这个方式让客户端可以做其他事情。

AIO用了一个通知机制，其流程如下：

客户端向服务端请求数据。服务端若有，则返回数据；若无，则告诉客户端“没有数据”。客户端收到“没有数据”的回复后，就做自己的其他事情。服务端有了数据之后，就主动通知客户端，并把数据返回去。

如此一来，整个请求流程中，不仅维持连接的消耗没了，而且客户端可以做别的事情了，节约了客户端的时间。

需要提的是，这里解决了连接的消耗，但是也必然引入了**别的消耗**。这里让客户端能先做别的事情，也肯定会带来**新的麻烦**。

别的消耗是指，服务端需要主动通知客户端，关于“通知”的业务逻辑肯定是需要消耗资源的。新的麻烦是指，客户端本来在做别的事情，突然前面的事情又插过来要做了，必然引入了一个多线程的协调工作。

## NIO的三个实体

NIO有3个实体：Buffer（缓冲区），Channel（通道），Selector（多路复用器）。

Buffer是客户端存放服务端信息的一个**容器**，服务端如果把数据准备好了，就会通过Channel往Buffer里面传。Buffer有7个类型：**ByteBuffer**、**CharBuffer**、**DoubleBuffer**、**FloatBuffer**、**IntBuffer**、**LongBuffer**、**ShortBuffer**。

Channel是客户端与服务端之间的**双工连接通道**。所以在请求的过程中，客户端与服务端中间的Channel就在不停的执行“连接、询问、断开”的过程。直到数据准备好，再通过Channel传回来。Channel主要有**4个类型**：**FileChannel**（从文件读取数据）、**DatagramChannel**（读写UDP网络协议数据）、**SocketChannel**（读写TCP网络协议数据）、**ServerSocketChannel**（可以监听TCP连接）

Selector是服务端选择Channel的一个复用器。Seletor有两个核心任务：**监控数据是否准备好**，**应答Channel**。具体说来，多个Channel反复轮询时，Selector就看该Channel所需的数据是否准备好了；如果准备好了，则将数据通过Channel返回给该客户端的Buffer，该客户端再进行后续其他操作；如果没准备好，则告诉Channel还需要继续轮询；多个Channel反复询问Selector，Selector为这些Channel一一解答。

## NIO的实际应用

NIO主要用于分布式、即时通信和中间件Java系统中[[3\]](https://zhuanlan.zhihu.com/p/111816019#ref_3)。

阿里的分布式服务框架Dubbo就默认使用Netty作为基础通信组件，用于实现各进程节点之间的内部通信。

Jetty、Apach的Mina、Jboos的Netty、Zookeeper都是基于NIO实现

## 代码实现

对于IO技术的真正掌握，最终还是要落脚到程序代码上，而不是只停留在理论。

限于时间和能力问题，这里我只给出几个大神的文章，其中有一些代码案例可供参考。

[[4\]](https://zhuanlan.zhihu.com/p/111816019#ref_4)[[5\]](https://zhuanlan.zhihu.com/p/111816019#ref_5)[[6\]](https://zhuanlan.zhihu.com/p/111816019#ref_6)[[7\]](https://zhuanlan.zhihu.com/p/111816019#ref_7)[[8\]](https://zhuanlan.zhihu.com/p/111816019#ref_8)

## 理解具体化

文章最初提到了两个实体：客户端和服务端。但是全文实际上并未明确，实体到底是什么，实际物理表示是什么。在参考文献[[1\]](https://zhuanlan.zhihu.com/p/111816019#ref_1)中提到，“事物有很多种理解”。在这也将“实体”具体化。

在网络IO场景中，客户端可以理解为我们自己的Client（台式机、手机、平板），服务端可以理解为云上的Server（高性能工作站）。Client向Server请求各种数据（商品详情、游戏角色信息、音乐mp3文件等）

在本地IO场景中，客户端是一个需要数据的程序，服务端是操作系统。客户端向操作系统请求本地磁盘的数据。