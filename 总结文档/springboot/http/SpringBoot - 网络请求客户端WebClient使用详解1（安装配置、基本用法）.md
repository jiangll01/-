在 **Spring 5** 之前，如果我们想要调用其他系统提供的 **HTTP** 服务，通常可以使用 **Spring** 提供的 **RestTemplate** 来访问，具体可以查看我之前写的相关文章（[点击查看](https://www.hangge.com/blog/cache/detail_2511.html)）。不过由于 **RestTemplate** 是 **Spring 3** 中引入的同步阻塞式 **HTTP** 客户端，因此存在一定性能瓶颈。根据 **Spring** 官方文档介绍，在将来的版本中它可能会被弃用。

  作为替代，**Spring** 官方已在 **Spring 5** 中引入了 **WebClient** 作为非阻塞式 **Reactive HTTP** 客户端。下面通过样例演示如何使用 **WebClient**。

## 一、基本介绍

### 1，什么是 WebClient

- 从 **Spring 5** 开始，**Spring** 中全面引入了 **Reactive** 响应式编程。而 **WebClient** 则是 **Spring WebFlux** 模块提供的一个非阻塞的基于响应式编程的进行 **Http** 请求的客户端工具。
- 由于 **WebClient** 的请求模式属于异步非阻塞，能够以少量固定的线程处理高并发的 **HTTP** 请求。因此，从 **Spring 5** 开始，**HTTP** 服务之间的通信我们就可以考虑使用 **WebClient** 来取代之前的 **RestTemplate**。

### 2，WebClient 的优势

（1）与 **RestTemplate** 相比，**WebClient** 有如下优势：

- 非阻塞，**Reactive** 的，并支持更高的并发性和更少的硬件资源。
- 提供利用 **Java 8 lambdas** 的函数 **API**。
- 支持同步和异步方案。
- 支持从服务器向上或向下流式传输。

（2）**RestTemplate** 不适合在非阻塞应用程序中使用，因此 **Spring WebFlux** 应用程序应始终使用 **WebClient**。在大多数高并发场景中，**WebClient** 也应该是 **Spring MVC** 中的首选，并且用于编写一系列远程，相互依赖的调用。

### 3，安装配置

编辑 **pom.xml** 文件，添加 **Spring WebFlux** 依赖，从而可以使用 **WebClient**。

```
<``dependency``>``  ``<``groupId``>org.springframework.boot</``groupId``>``  ``<``artifactId``>spring-boot-starter-webflux</``artifactId``>``</``dependency``>
```



## 二、创建 WebClient 实例

  从 **WebClient** 的源码中可以看出，**WebClient** 接口提供了三个不同的静态方法来创建 **WebClient** 实例：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解1（安装配置、基本用法）](https://www.hangge.com/blog_uploads/201910/2019102810185966084.png)](https://www.hangge.com/blog/cache/detail_2640.html#)



### 1，利用 create() 创建

（1）下面利用 **create()** 方法创建一个 **WebClient** 对象，并利用该对象请求一个网络接口，最后将结果以字符串的形式打印出来。

**注意**：由于利用 **create()** 创建的 **WebClient** 对象没有设定 **baseURL**，所以这里的 **uri()** 方法相当于重写 **baseURL**。



```
WebClient webClient = WebClient.create();` `Mono<String> mono = webClient``    ``.get() ``// GET 请求``    ``.uri(``"http://jsonplaceholder.typicode.com/posts/1"``) // 请求路径``    ``.retrieve() ``// 获取响应体``    ``.bodyToMono(String.``class``); ``//响应数据类型转换` `System.out.println(mono.block());
```


（2）控制台输出结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解1（安装配置、基本用法）](https://www.hangge.com/blog_uploads/201910/2019102810471135514.png)](https://www.hangge.com/blog/cache/detail_2640.html#)



### 2，利用 create(String baseUrl) 创建

（1）下面利用 **create(String baseUrl)** 方法创建一个 **WebClient** 对象，并利用该对象请求一个网络接口，最后将结果以字符串的形式打印出来。

**注意**：由于利用 **create(String baseUrl)** 创建的 **WebClient** 对象时已经设定了 **baseURL**，所以 **uri()** 方法会将返回的结果和 **baseUrl** 进行拼接组成最终需要远程请求的资源 **URL**。



```
WebClient webClient = WebClient.create(``"http://jsonplaceholder.typicode.com"``);` `Mono<String> mono = webClient``    ``.get() ``// GET 请求``    ``.uri(``"/posts/1"``) ``// 请求路径``    ``.retrieve() ``// 获取响应体``    ``.bodyToMono(String.``class``); ``//响应数据类型转换` `System.out.println(mono.block());
```


（2）控制台输出结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解1（安装配置、基本用法）](https://www.hangge.com/blog_uploads/201910/2019102810471135514.png)](https://www.hangge.com/blog/cache/detail_2640.html#)



### 3，利用 builder 创建（推荐） 

（1）下面使用 **builder()** 返回一个 **WebClient****.Builder**，然后再调用 **build** 就可以返回 **WebClient** 对象。并利用该对象请求一个网络接口，最后将结果以字符串的形式打印出来。

**注意**：由于返回的不是 **WebClient** 类型而是 **WebClient****.Builder**，我们可以通过返回的 **WebClient****.Builder** 设置一些配置参数（例如：**baseUrl**、**header**、**cookie** 等），然后再调用 **build** 就可以返回 **WebClient** 对象了

```
WebClient webClient = WebClient.builder()``    ``.baseUrl(``"http://jsonplaceholder.typicode.com"``)``    ``.defaultHeader(HttpHeaders.USER_AGENT,``"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko)"``)``    ``.defaultCookie(``"ACCESS_TOKEN"``, ``"test_token"``)``    ``.build();` `Mono<String> mono = webClient``    ``.get() ``// GET 请求``    ``.uri(``"/posts/1"``) ``// 请求路径``    ``.retrieve() ``// 获取响应体``    ``.bodyToMono(String.``class``); ``//响应数据类型转换``    ` `System.out.println(mono.block());
```


（2）控制台输出结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解1（安装配置、基本用法）](https://www.hangge.com/blog_uploads/201910/2019102810471135514.png)](https://www.hangge.com/blog/cache/detail_2640.html#)

## 三、GET 请求

### 1，获取 String 结果数据

下面代码将响应结果映射为一个 **String** 字符串，并打印出来。

```
@RestController``public` `class` `HelloController {` `  ``// 创建 WebClient 对象``  ``private` `WebClient webClient = WebClient.builder()``      ``.baseUrl(``"http://jsonplaceholder.typicode.com"``)``      ``.build();` `  ``@GetMapping``(``"/test"``)``  ``public` `void` `test() {``    ``Mono<String> mono = webClient``        ``.get() ``// GET 请求``        ``.uri(``"/posts/1"``) ``// 请求路径``        ``.retrieve() ``// 获取响应体``        ``.bodyToMono(String.``class``); ``//响应数据类型转换``    ``System.out.println(mono.block());``    ``return``;``  ``}``}
```

[![原文:SpringBoot - 网络请求客户端WebClient使用详解2（GET请求）](https://www.hangge.com/blog_uploads/201910/2019102810471135514.png)](https://www.hangge.com/blog/cache/detail_2641.html#)



### 2，将结果转换为对象

（1）当响应的结果是 **JSON** 时，也可以直接指定为一个 **Object**，**WebClient** 将接收到响应后把 **JSON** 字符串转换为对应的对象。

```
@RestController``public` `class` `HelloController {` `  ``// 创建 WebClient 对象``  ``private` `WebClient webClient = WebClient.builder()``      ``.baseUrl(``"http://jsonplaceholder.typicode.com"``)``      ``.build();` `  ``@GetMapping``(``"/test"``)``  ``public` `void` `test() {``    ``Mono<PostBean> mono = webClient``        ``.get() ``// GET 请求``        ``.uri(``"/posts/1"``) ``// 请求路径``        ``.retrieve() ``// 获取响应体``        ``.bodyToMono(PostBean.``class``); ``//响应数据类型转换``    ``System.out.println(mono.block());``    ``return``;``  ``}``}
```

[![原文:SpringBoot - 网络请求客户端WebClient使用详解2（GET请求）](https://www.hangge.com/blog_uploads/201907/2019071717125787891.png)](https://www.hangge.com/blog/cache/detail_2641.html#)


（2）其中定义的实体 **Bean** 代码如下：

```
@Getter``@Setter``@ToString``public` `class` `PostBean {``  ``private` `int` `userId;``  ``private` `int` `id;``  ``private` `String title;``  ``private` `String body;``}
```



### 3，将结果转成集合

（1）假设接口返回的是一个 **json** 数组，内容如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解2（GET请求）](https://www.hangge.com/blog_uploads/201907/201907171719231900.png)](https://www.hangge.com/blog/cache/detail_2641.html#)


（2）我们也可以将其转成对应的 **Bean** 集合：

```
@RestController``public` `class` `HelloController {` `  ``// 创建 WebClient 对象``  ``private` `WebClient webClient = WebClient.builder()``      ``.baseUrl(``"http://jsonplaceholder.typicode.com"``)``      ``.build();` `  ``@GetMapping``(``"/test"``)``  ``public` `void` `test() {``    ``Flux<PostBean> flux = webClient``        ``.get() ``// GET 请求``        ``.uri(``"/posts"``) ``// 请求路径``        ``.retrieve() ``// 获取响应体``        ``.bodyToFlux(PostBean.``class``); ``//响应数据类型转换``    ``List<PostBean> posts = flux.collectList().block();``    ``System.out.println(``"结果数："` `+ posts.size());``    ``return``;``  ``}``}
```

[![原文:SpringBoot - 网络请求客户端WebClient使用详解2（GET请求）](https://www.hangge.com/blog_uploads/201907/2019071717235328635.png)](https://www.hangge.com/blog/cache/detail_2641.html#)



### 4，参数传递的几种方式

下面 **3** 种方式的结果都是一样的。

（1）使用占位符的形式传递参数：

```
Mono<String> mono = webClient``    ``.get() ``// GET 请求``    ``.uri(``"/{1}/{2}"``, ``"posts"``, ``"1"``) ``// 请求路径``    ``.retrieve() ``// 获取响应体``    ``.bodyToMono(String.``class``); ``//响应数据类型转换
```


（2）另一种使用占位符的形式：

```
String type = ``"posts"``;``int` `id = ``1``;` `Mono<String> mono = webClient``    ``.get() ``// GET 请求``    ``.uri(``"/{type}/{id}"``, type, id) ``// 请求路径``    ``.retrieve() ``// 获取响应体``    ``.bodyToMono(String.``class``); ``//响应数据类型转换``    ``System.out.println(mono.block());
```


（3）我们也可以使用 **map** 装载参数：

```
Map<String,Object> map = ``new` `HashMap<>();``map.put(``"type"``, ``"posts"``);``map.put(``"id"``, ``1``);` `Mono<String> mono = webClient``    ``.get() ``// GET 请求``    ``.uri(``"/{type}/{id}"``, map) ``// 请求路径``    ``.retrieve() ``// 获取响应体``    ``.bodyToMono(String.``class``); ``//响应数据类型转换
```



### 5，subscribe 订阅（非阻塞式调用）

（1）前面的样例我们都是人为地使用 **block** 方法来阻塞当前程序。其实 **WebClient** 是异步的，也就是说等待响应的同时不会阻塞正在执行的线程。只有在响应结果准备就绪时，才会发起通知。

```
@RestController``public` `class` `HelloController {` `  ``// 创建 WebClient 对象``  ``private` `WebClient webClient = WebClient.builder()``      ``.baseUrl(``"http://jsonplaceholder.typicode.com"``)``      ``.build();` `  ``@GetMapping``(``"/test"``)``  ``public` `void` `test() {``    ``System.out.println(``"--- begin ---"``);` `    ``Mono<String> mono = webClient``        ``.get() ``// GET 请求``        ``.uri(``"/posts/1"``) ``// 请求路径``        ``.retrieve() ``// 获取响应体``        ``.bodyToMono(String.``class``); ``//响应数据类型转换` `    ``// 订阅（异步处理结果）``    ``mono.subscribe(result -> {``      ``System.out.println(result);``    ``});` `    ``System.out.println(``"--- end ---"``);``    ``return``;``  ``}``}
```


（2）运行结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解2（GET请求）](https://www.hangge.com/blog_uploads/201910/2019102910532984169.png)](https://www.hangge.com/blog/cache/detail_2641.html#)



## 附：使用 exchange() 方法获取完整的响应内容

### 1，方法介绍

（1）前面我们都是使用 **retrieve()** 方法直接获取到了响应的内容，如果我们想获取到响应的头信息、**Cookie** 等，可以在通过 **WebClient** 请求时把调用 **retrieve()** 改为调用 **exchange()**。
（2）通过 **exchange()** 方法可以访问到代表响应结果的对象，通过该对象我们可以获取响应码、**contentType**、**contentLength**、响应消息体等。

### 2，使用样例 

下面代码请求一个网络接口，并将响应体、响应头、响应码打印出来。其中响应体的类型设置为 **String**。

```
@RestController``public` `class` `HelloController {` `  ``// 创建 WebClient 对象``  ``private` `WebClient webClient = WebClient.builder()``      ``.baseUrl(``"http://jsonplaceholder.typicode.com"``)``      ``.build();` `  ``@GetMapping``(``"/test"``)``  ``public` `void` `test() {``    ``Mono<ClientResponse> mono = webClient``        ``.get() ``// GET 请求``        ``.uri(``"/posts/1"``) ``// 请求路径``        ``.exchange();` `    ``// 获取完整的响应对象``    ``ClientResponse response = mono.block();` `    ``HttpStatus statusCode = response.statusCode(); ``// 获取响应码``    ``int` `statusCodeValue = response.rawStatusCode(); ``// 获取响应码值``    ``Headers headers = response.headers(); ``// 获取响应头` `    ``// 获取响应体``    ``Mono<String> resultMono = response.bodyToMono(String.``class``);``    ``String body = resultMono.block();` `    ``// 输出结果``    ``System.out.println(``"statusCode："` `+ statusCode);``    ``System.out.println(``"statusCodeValue："` `+ statusCodeValue);``    ``System.out.println(``"headers："` `+ headers.asHttpHeaders());``    ``System.out.println(``"body："` `+ body);``    ``return``;``  ``}``}
```

[![原文:SpringBoot - 网络请求客户端WebClient使用详解2（GET请求）](https://www.hangge.com/blog_uploads/201910/2019102816581448219.png)](https://www.hangge.com/blog/cache/detail_2641.html#)


原文出自：[www.hangge.com](https://www.hangge.com/) 转载请保留原文链接：https://www.hangge.com/blog/cache/detail_2641.html

## 四、POST 请求

### 1，发送一个 JSON 格式数据（使用 json 字符串）

（1）下面代码使用 **post** 方式发送一个 **json** 格式的字符串，并将结果打印出来（以字符串的形式）。

```
@RestController``public` `class` `HelloController {` `  ``// 创建 WebClient 对象``  ``private` `WebClient webClient = WebClient.builder()``      ``.baseUrl(``"http://jsonplaceholder.typicode.com"``)``      ``.build();` `  ``@GetMapping``(``"/test"``)``  ``public` `void` `test() {``    ``// 需要提交的 json 字符串``    ``String jsonStr = ``"{\"userId\": 222,\"title\": \"abc\",\"body\": \"航歌\"}"``;` `    ``// 发送请求``    ``Mono<String> mono = webClient``        ``.post() ``// POST 请求``        ``.uri(``"/posts"``) ``// 请求路径``        ``.contentType(MediaType.APPLICATION_JSON_UTF8)``        ``.body(BodyInserters.fromObject(jsonStr))``        ``.retrieve() ``// 获取响应体``        ``.bodyToMono(String.``class``); ``//响应数据类型转换` `    ``// 输出结果``    ``System.out.println(mono.block());``    ``return``;``  ``}``}
```


（2）运行结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解3（POST请求）](https://www.hangge.com/blog_uploads/201907/2019071814451486148.png)](https://www.hangge.com/blog/cache/detail_2643.html#)

### 2，发送一个 JSON 格式数据（使用 Java Bean）

（1）下面代码使用 **post** 方式发送一个 **Bean** 对象，并将结果打印出来（以字符串的形式）。结果同上面是一样的：

```
@RestController``public` `class` `HelloController {` `  ``// 创建 WebClient 对象``  ``private` `WebClient webClient = WebClient.builder()``      ``.baseUrl(``"http://jsonplaceholder.typicode.com"``)``      ``.build();` `  ``@GetMapping``(``"/test"``)``  ``public` `void` `test() {``    ``// 要发送的数据对象``    ``PostBean postBean = ``new` `PostBean();``    ``postBean.setUserId(``222``);``    ``postBean.setTitle(``"abc"``);``    ``postBean.setBody(``"航歌"``);` `    ``// 发送请求``    ``Mono<String> mono = webClient``        ``.post() ``// POST 请求``        ``.uri(``"/posts"``) ``// 请求路径``        ``.contentType(MediaType.APPLICATION_JSON_UTF8)``        ``.syncBody(postBean)``        ``.retrieve() ``// 获取响应体``        ``.bodyToMono(String.``class``); ``//响应数据类型转换` `    ``// 输出结果``    ``System.out.println(mono.block());``    ``return``;``  ``}``}
```


（2）上面发送的 **Bean** 对象实际上会转成如下格式的 **JSON** 数据提交：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解3（POST请求）](https://www.hangge.com/blog_uploads/201907/2019071810574064618.png)](https://www.hangge.com/blog/cache/detail_2643.html#)

### 3，使用 Form 表单的形式提交数据

（1）下面样例使用 **POST** 方式发送 **multipart/form-data** 格式的数据：

```
@RestController``public` `class` `HelloController {` `  ``// 创建 WebClient 对象``  ``private` `WebClient webClient = WebClient.builder()``      ``.baseUrl(``"http://jsonplaceholder.typicode.com"``)``      ``.build();` `  ``@GetMapping``(``"/test"``)``  ``public` `void` `test() {``    ``//提交参数设置``    ``MultiValueMap<String, String> map = ``new` `LinkedMultiValueMap<>();``    ``map.add(``"title"``, ``"abc"``);``    ``map.add(``"body"``, ``"航歌"``);` `    ``// 发送请求``    ``Mono<String> mono = webClient``        ``.post() ``// POST 请求``        ``.uri(``"/posts"``) ``// 请求路径``        ``.contentType(MediaType.APPLICATION_FORM_URLENCODED)``        ``.body(BodyInserters.fromFormData(map))``        ``.retrieve() ``// 获取响应体``        ``.bodyToMono(String.``class``); ``//响应数据类型转换` `    ``// 输出结果``    ``System.out.println(mono.block());``    ``return``;``  ``}``}
```

[![原文:SpringBoot - 网络请求客户端WebClient使用详解3（POST请求）](https://www.hangge.com/blog_uploads/201907/2019071811100413680.png)](https://www.hangge.com/blog/cache/detail_2643.html#)


（2）上面代码最终会通过如下这种 **form** 表单方式提交数据：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解3（POST请求）](https://www.hangge.com/blog_uploads/201907/2019071811115028421.png)](https://www.hangge.com/blog/cache/detail_2643.html#)

### 4，将结果转成自定义对象

  上面样例我们都是将响应结果以 **String** 形式接收，其实 **WebClient** 还可以自动将响应结果转成自定的对象或则数组。具体可以参考我前面写的文章：

- [SpringBoot - 网络请求客户端WebClient使用详解2（GET请求）](https://www.hangge.com/blog/cache/detail_2641.html)

### 5，设置 url 参数

（1）如果 **url** 地址上面需要传递一些参数，可以使用占位符的方式：

```
String url = ``"http://jsonplaceholder.typicode.com/{1}/{2}"``;``String url = ``"http://jsonplaceholder.typicode.com/{type}/{id}"``;
```


（2）具体的用法可以参考我前面写的文章：

- [SpringBoot - 网络请求客户端WebClient使用详解2（GET请求）](https://www.hangge.com/blog/cache/detail_2641.html)

### 6，subscribe 订阅（非阻塞式调用）

（1）前面的样例我们都是人为地使用 **block** 方法来阻塞当前程序。其实 **WebClient** 是异步的，也就是说等待响应的同时不会阻塞正在执行的线程。只有在响应结果准备就绪时，才会发起通知。

```
@RestController``public` `class` `HelloController {` `  ``// 创建 WebClient 对象``  ``private` `WebClient webClient = WebClient.builder()``      ``.baseUrl(``"http://jsonplaceholder.typicode.com"``)``      ``.build();` `  ``@GetMapping``(``"/test"``)``  ``public` `void` `test() {``    ``System.out.println(``"--- begin ---"``);` `    ``// 需要提交的 json 字符串``    ``String jsonStr = ``"{\"userId\": 222,\"title\": \"abc\",\"body\": \"航歌\"}"``;` `    ``Mono<String> mono = webClient``        ``.post() ``// POST 请求``        ``.uri(``"/posts"``) ``// 请求路径``        ``.contentType(MediaType.APPLICATION_JSON_UTF8)``        ``.body(BodyInserters.fromObject(jsonStr))``        ``.retrieve() ``// 获取响应体``        ``.bodyToMono(String.``class``); ``//响应数据类型转换` `    ``// 订阅（异步处理结果）``    ``mono.subscribe(result -> {``      ``System.out.println(result);``    ``});` `    ``System.out.println(``"--- end ---"``);``    ``return``;``  ``}``}
```


（2）运行结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解3（POST请求）](https://www.hangge.com/blog_uploads/201910/2019102910574441219.png)](https://www.hangge.com/blog/cache/detail_2643.html#)



## 附：使用 exchange() 方法获取完整的响应内容

### 1，方法介绍

（1）前面我们都是使用 **retrieve()** 方法直接获取到了响应的内容，如果我们想获取到响应的头信息、**Cookie** 等，可以在通过 **WebClient** 请求时把调用 **retrieve()** 改为调用 **exchange()**。

（2）通过 **exchange()** 方法可以访问到代表响应结果的对象，通过该对象我们可以获取响应码、**contentType**、**contentLength**、响应消息体等。

### 2，使用样例 

下面代码请求一个网络接口，并将响应体、响应头、响应码打印出来。其中响应体的类型设置为 **String**。



```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .baseUrl("http://jsonplaceholder.typicode.com")
            .build();
 
    @GetMapping("/test")
    public void test() {
        // 需要提交的 json 字符串
        String jsonStr = "{\"userId\": 222,\"title\": \"abc\",\"body\": \"航歌\"}";
 
        // 发送请求
        Mono<ClientResponse> mono = webClient
                .post() // POST 请求
                .uri("/posts")  // 请求路径
                .contentType(MediaType.APPLICATION_JSON_UTF8)
                .body(BodyInserters.fromObject(jsonStr))
                .exchange();
 
        // 获取完整的响应对象
        ClientResponse response = mono.block();
 
        HttpStatus statusCode = response.statusCode(); // 获取响应码
        int statusCodeValue = response.rawStatusCode(); // 获取响应码值
        Headers headers = response.headers(); // 获取响应头
 
        // 获取响应体
        Mono<String> resultMono = response.bodyToMono(String.class);
        String body = resultMono.block();
 
        // 输出结果
        System.out.println("statusCode：" + statusCode);
        System.out.println("statusCodeValue：" + statusCodeValue);
        System.out.println("headers：" + headers.asHttpHeaders());
        System.out.println("body：" + body);
        return;
    }
}
```

[![原文:SpringBoot - 网络请求客户端WebClient使用详解3（POST请求）](https://www.hangge.com/blog_uploads/201910/2019102910110846853.png)](https://www.hangge.com/blog/cache/detail_2643.html#)

## 五、文件下载

### 1，下载图片

（1）下面是一个图片下载的样例，下载一个网络上的图片并保存到本地。

```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .build();
 
    @GetMapping("/test")
    public void test() {
        // 记录下开始下载时的时间
        Instant now = Instant.now();
 
        Mono<Resource> mono = webClient
                .get() // GET 请求
                .uri("https://www.baidu.com/img/bd_logo1.png")  // 请求路径
                .accept(MediaType.IMAGE_PNG)
                .retrieve() // 获取响应体
                .bodyToMono(Resource.class); //响应数据类型转换
 
        Resource resource = mono.block();
 
        try {
            // 文件保存的本地路径
            String targetPath = "/Users/hangge/Desktop/logo.png";
            // 将下载下来的图片保存到本地
            BufferedImage bufferedImage = ImageIO.read(resource.getInputStream());
            ImageIO.write(bufferedImage, "png", new File(targetPath));
        } catch (IOException e) {
            System.out.println("文件写入失败：" + e.getMessage());
        }
 
        System.out.println("文件下载完成，耗时：" + ChronoUnit.MILLIS.between(now, Instant.now())
                + " 毫秒");
        return;
    }
}
```


（2）运行结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解4（下载文件）](https://www.hangge.com/blog_uploads/201910/201910291652154930.png)](https://www.hangge.com/blog/cache/detail_2644.html#)



### 2，下载文件

（1）下面代码下载一个 **zip** 文件并保存到本地，文件名不变（使用原始的文件名）

```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .build();
 
    @GetMapping("/test")
    public void test() {
        // 记录下开始下载时的时间
        Instant now = Instant.now();
 
        Mono<ClientResponse> mono = webClient
                .get() // GET 请求
                .uri("http://www.hangge.com/1.zip")  // 请求路径
                .accept(MediaType.APPLICATION_OCTET_STREAM)
                .exchange(); // 获取响应体
 
        ClientResponse response = mono.block();
 
        try {
            // 从header中获取原始文件名
            HttpHeaders httpHeaders = response.headers().asHttpHeaders();
            String contentLocation = httpHeaders.getFirst(HttpHeaders.LOCATION);
            String fileName = contentLocation.substring(contentLocation.lastIndexOf("/")+1);
 
            // 将文件保存到桌面（文件名不变）
            Resource resource = response.bodyToMono(Resource.class).block();
            File out = new File("/Users/hangge/Desktop/" + fileName);
            FileUtils.copyInputStreamToFile(resource.getInputStream(),out);
            System.out.println("文件保存成功：" + out.getAbsolutePath());
        } catch (IOException e) {
            System.out.println("文件写入失败：" + e.getMessage());
        }
 
        System.out.println("文件下载完成，耗时：" + ChronoUnit.MILLIS.between(now, Instant.now())
                + " 毫秒");
        return;
    }
}
```


（2）运行结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解4（下载文件）](https://www.hangge.com/blog_uploads/201910/2019102917554298571.png)](https://www.hangge.com/blog/cache/detail_2644.html#)

## 六、文件上传

### 1，效果图

（1）下面通过样例演示如何使用 **WebClient** 上传文件。这里使用 **Form** 表单的方式提交，上传时除了一个文件外还附带有两个自定义参数。

（2）接收方收到文件后会打印出相关参数、文件相关数据，并返回成功信息。

[![原文:SpringBoot - 网络请求客户端WebClient使用详解5（上传文件）](https://www.hangge.com/blog_uploads/201907/2019071910315068736.png)](https://www.hangge.com/blog/cache/detail_2645.html#)

（3）发送方收到反馈后将反馈信息打印出来：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解5（上传文件）](https://www.hangge.com/blog_uploads/201907/2019071910332739693.png)](https://www.hangge.com/blog/cache/detail_2645.html#)



### 2，样例代码

（1）文件发送端代码如下：

```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .build();
 
    @GetMapping("/test")
    public void test() {
        // 待上传的文件
        String filePath = "/Users/hangge/Desktop/test.txt";
        FileSystemResource resource = new FileSystemResource(new File(filePath));
 
        // 封装请求参数
        MultiValueMap<String, Object> param = new LinkedMultiValueMap<>();
        param.add("myFile", resource);
        param.add("param1", "12345");
        param.add("param2", "hangge");
 
        // 发送请求
        Mono<String> mono = webClient
                .post() // POST 请求
                .uri("http://localhost:8080/upload")  // 请求路径
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .body(BodyInserters.fromMultipartData(param))
                .retrieve() // 获取响应体
                .bodyToMono(String.class); //响应数据类型转换
 
        // 输出结果
        System.out.println(mono.block());
    }
}
```


（2）文件接收端代码如下：

  为方便演示，接收端这边的代码比较简单。如果想要进一步操作，比如：文件重命名、文件保存、相关上传参数的配置，可以参考我之前写的文章：

- [SpringBoot - 实现文件上传1（单文件上传、常用上传参数配置）](https://www.hangge.com/blog/cache/detail_2462.html)
- [SpringBoot - 实现文件上传2（多文件上传、常用上传参数配置）](https://www.hangge.com/blog/cache/detail_2463.html)

```
@RestController
public class HelloController {
 
    @PostMapping("/upload")
    public String upload(String param1, String param2, MultipartFile myFile) {
        System.out.println("--- 接收文件 ---");
        System.out.println("param1：" + param1);
        System.out.println("param2：" + param2);
        String originalFilename = myFile.getOriginalFilename();
        System.out.println("文件原始名称：" + originalFilename);
        try {
            String string = new String(myFile.getBytes(), "UTF-8");
            System.out.println("文件内容：" + string);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        // 处理文件内容...
        return "OK";
    }
}
```

## 七、请求异常处理

### 1，默认异常

（1）当我们使用 **WebClient** 发送请求时， 如果接口返回的不是 **200** 状态（而是 **4xx**、**5xx** 这样的异常状态），则会抛出 **WebClientResponseException** 异常。

```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .baseUrl("http://localhost:8080")
            .build();
     
    @GetMapping("/test")
    public void test() {
        Mono<String> mono = webClient
                .get() // GET 请求
                .uri("/xxxxx")  // 请求一个不存在的路径
                .retrieve() // 获取响应体
                .bodyToMono(String.class);
        System.out.println(mono.block());
    }}
```

[![原文:SpringBoot - 网络请求客户端WebClient使用详解6（异常处理、请求失败处理）](https://www.hangge.com/blog_uploads/201910/2019103015212484955.png)](https://www.hangge.com/blog/cache/detail_2646.html#)


（2）使用浏览器访问结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解6（异常处理、请求失败处理）](https://www.hangge.com/blog_uploads/201910/2019103015254350860.png)](https://www.hangge.com/blog/cache/detail_2646.html#)



（3）使用 **Postman** 访问结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解6（异常处理、请求失败处理）](https://www.hangge.com/blog_uploads/201910/2019103015264189160.png)](https://www.hangge.com/blog/cache/detail_2646.html#)



### 2，异常处理（适配所有异常）

（1）我们可以通过 **doOnError** 方法适配所有异常，比如下面代码在发生异常时将其转为一个自定义的异常抛出（这里假设使用 **RuntimeException**）：

```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .baseUrl("http://localhost:8080")
            .build();
 
    @GetMapping("/test")
    public void test() {
        Mono<String> mono = webClient
                .get() // GET 请求
                .uri("/xxxxx")  // 请求一个不存在的路径
                .retrieve() // 获取响应体
                .bodyToMono(String.class) //响应数据类型转换
                .doOnError(WebClientResponseException.class, err -> {
                    System.out.println("发生错误：" +err.getRawStatusCode() + " "
                            + err.getResponseBodyAsString());
                    throw new RuntimeException(err.getResponseBodyAsString());
                });
        System.out.println(mono.block());
    }
}
```

[![原文:SpringBoot - 网络请求客户端WebClient使用详解6（异常处理、请求失败处理）](https://www.hangge.com/blog_uploads/201910/2019103015384127315.png)](https://www.hangge.com/blog/cache/detail_2646.html#)


（2）使用浏览器访问结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解6（异常处理、请求失败处理）](https://www.hangge.com/blog_uploads/201910/2019103015395337723.png)](https://www.hangge.com/blog/cache/detail_2646.html#)



（3）使用 **Postman** 访问结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解6（异常处理、请求失败处理）](https://www.hangge.com/blog_uploads/201910/2019103015403281072.png)](https://www.hangge.com/blog/cache/detail_2646.html#)



### 3，异常处理（适配指定异常）

（1）我们也可以通过 **onStatus** 方法根据 **status code** 来适配指定异常。下面代码同样在发生异常时将其转为一个自定义的异常抛出（这里假设使用 **RuntimeException**）：

```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .baseUrl("http://localhost:8080")
            .build();
 
    @GetMapping("/test")
    public void test() {
        Mono<String> mono = webClient
                .get() // GET 请求
                .uri("/xxxxx")  // 请求一个不存在的路径
                .retrieve() // 获取响应体
                .onStatus(e -> e.is4xxClientError(), resp -> {
                    System.out.println("发生错误：" + resp.statusCode().value() + " "
                            + resp.statusCode().getReasonPhrase());
                    return Mono.error(new RuntimeException("请求失败"));
                })
                .onStatus(e -> e.is5xxServerError(), resp -> {
                    System.out.println("发生错误：" + resp.statusCode().value() + " "
                            + resp.statusCode().getReasonPhrase());
                    return Mono.error(new RuntimeException("服务器异常"));
                })
                .bodyToMono(String.class); //响应数据类型转换
 
        System.out.println(mono.block());
    }
}
```

[![原文:SpringBoot - 网络请求客户端WebClient使用详解6（异常处理、请求失败处理）](https://www.hangge.com/blog_uploads/201910/2019103015511633901.png)](https://www.hangge.com/blog/cache/detail_2646.html#)


（2）使用 **Postman** 访问结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解6（异常处理、请求失败处理）](https://www.hangge.com/blog_uploads/201910/2019103015531756941.png)](https://www.hangge.com/blog/cache/detail_2646.html#)



### 4，在发生异常时返回默认值

（1）我们可以使用 **onErrorReturn** 方法来设置个默认值，当请求发生异常是会使用该默认值作为响应结果。

```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .baseUrl("http://localhost:8080")
            .build();
 
    @GetMapping("/test")
    public String test() {
        Mono<String> mono = webClient
                .get() // GET 请求
                .uri("/xxxxx")  // 请求一个不存在的路径
                .retrieve() // 获取响应体
                .bodyToMono(String.class)
                .onErrorReturn("请求失败!!!"); // 失败时的默认值
 
        return mono.block();
    }
}
```


（2）使用浏览器访问结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解6（异常处理、请求失败处理）](https://www.hangge.com/blog_uploads/201910/2019103016013188931.png)](https://www.hangge.com/blog/cache/detail_2646.html#)

## 八、设置超时属性

（1）我们可以使用 **timeout** 方法设置一个超时时长。如果 **HTTP** 请求超时，便会发生 **TimeoutException** 异常。

```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .baseUrl("http://localhost:8080")
            .build();
 
    @GetMapping("/test")
    public String test() {
        Mono<String> mono = webClient
                .get() // GET 请求
                .uri("/data")  // 请求一个不存在的路径
                .retrieve() // 获取响应体
                .bodyToMono(String.class)
                .timeout(Duration.ofSeconds(3)); // 3秒超时
 
        return mono.block();
    }
 
    @GetMapping("/data")
    public String data() throws InterruptedException {
        //等待2分钟再返回
        Thread.sleep(120 * 1000);
        return "hangge.com";
    }
}
```

[![原文:SpringBoot - 网络请求客户端WebClient使用详解7（超时时长、自动重试）](https://www.hangge.com/blog_uploads/201910/2019103016390775504.png)](https://www.hangge.com/blog/cache/detail_2647.html#)


（2）使用 **Postman** 发起请求结果如下：

[![原文:SpringBoot - 网络请求客户端WebClient使用详解7（超时时长、自动重试）](https://www.hangge.com/blog_uploads/201910/2019103016401890916.png)](https://www.hangge.com/blog/cache/detail_2647.html#)



## 九、请求异常自动重试

### 1，设置重试次数

（1）使用 **retry()** 方法可以设置当请求异常时的最大重试次数，如果不带参数则表示无限重试，直至成功。

```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .baseUrl("http://localhost:8080")
            .build();
 
    @GetMapping("/test")
    public String test() {
        Mono<String> mono = webClient
                .get() // GET 请求
                .uri("/data")  // 请求一个不存在的路径
                .retrieve() // 获取响应体
                .bodyToMono(String.class)
                .timeout(Duration.ofSeconds(3)) // 3秒超时
                .retry(3); // 重试3次
 
        return mono.block();
    }
 
    @GetMapping("/data")
    public String data() throws InterruptedException {
        System.out.println("--- start ---");
        //等待2分钟再返回
        Thread.sleep(120 * 1000);
        return "hangge.com";
    }
}
```


（2）执行后控制台输出如下，可以看到最开始的 **1** 次请求加上 **3** 次重试，最终一共请求了 **4** 次。

[![原文:SpringBoot - 网络请求客户端WebClient使用详解7（超时时长、自动重试）](https://www.hangge.com/blog_uploads/201910/2019103017044722040.png)](https://www.hangge.com/blog/cache/detail_2647.html#)



### 2，设置重试时间间隔

（1）使用 **retry** 方法默认情况下请求失败后会立刻重新发起请求，如果希望在每次重试前加个时间间隔（等待），可以使用 **retryBackoff** 方法。

（2）下面代码同样是当发生请求失败后自动重试 **3** 次，只不过重试前会等待个 **10** 秒。

```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .baseUrl("http://localhost:8080")
            .build();
 
    @GetMapping("/test")
    public String test() {
        Mono<String> mono = webClient
                .get() // GET 请求
                .uri("/data")  // 请求一个不存在的路径
                .retrieve() // 获取响应体
                .bodyToMono(String.class)
                .timeout(Duration.ofSeconds(3)) // 3秒超时
                .retryBackoff(3, Duration.ofSeconds(10)); // 重试3次，间隔10秒
 
        return mono.block();
    }
 
    @GetMapping("/data")
    public String data() throws InterruptedException {
        System.out.println("--- start ---");
        //等待2分钟再返回
        Thread.sleep(120 * 1000);
        return "hangge.com";
    }
}

```



### 3，指定需要重试的异常

（1）不管是前面的 **retry** 方法还是 **retryBackoff** 方法，设置后无论发生何种异常都会进行重试。如果需要更加精细的控制，比如指定的异常才需要重试，则可以使用 **retryWhen** 方法。

（2）在使用 **retryWhen** 方法之前，我们项目中还需要先引入 **reactor-extra** 包，因为需要用到里面的 **Retry** 类。



```
<dependency>
    <groupId>io.projectreactor.addons</groupId>
    <artifactId>reactor-extra</artifactId>
</dependency>
```


（3）下面样例只有发生 **RuntimeException** 异常时才会进行重试：

**注意**：如果还需要设置对应的重试次数和间隔时间，需要分别通过 **Retry** 的 **retryMax** 和 **backoff** 方法进行设置。

```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .baseUrl("http://localhost:8080")
            .build();
 
    @GetMapping("/test")
    public String test() {
 
        // 定义重试条件
        Retry<?> retry = Retry.anyOf(RuntimeException.class) // 只有RuntimeException异常才重试
                .retryMax(3) // 重试3次
                .backoff(Backoff.fixed(Duration.ofSeconds(10))); // 每次重试间隔10秒
 
        Mono<String> mono = webClient
                .get() // GET 请求
                .uri("/data")  // 请求一个不存在的路径
                .retrieve() // 获取响应体
                .bodyToMono(String.class)
                .timeout(Duration.ofSeconds(3)) // 3秒超时
                .retryWhen(retry);
         
        return mono.block();
    }
 
    @GetMapping("/data")
    public String data() {
        System.out.println("--- start ---");
        throw new RuntimeException("发生错误");
    }
}
```


（4）下面样例除了 **RuntimeException** 异常外，发生其它一切异常都会进行重试：

```
@RestController
public class HelloController {
 
    // 创建 WebClient 对象
    private WebClient webClient = WebClient.builder()
            .baseUrl("http://localhost:8080")
            .build();
 
    @GetMapping("/test")
    public String test() {
 
        // 定义重试条件
        Retry<?> retry = Retry.allBut(RuntimeException.class) // 除了RuntimeException异常都重试
                .retryMax(3) // 重试3次
                .backoff(Backoff.fixed(Duration.ofSeconds(10))); // 每次重试间隔10秒
 
        Mono<String> mono = webClient
                .get() // GET 请求
                .uri("/data")  // 请求一个不存在的路径
                .retrieve() // 获取响应体
                .bodyToMono(String.class)
                .timeout(Duration.ofSeconds(3)) // 3秒超时
                .retryWhen(retry);
 
        return mono.block();
    }
 
    @GetMapping("/data")
    public String data() {
        System.out.println("--- start ---");
        throw new RuntimeException("发生错误");
    }
}

```


原文出自：[www.hangge.com](https://www.hangge.com/) 转载请保留原文链接：https://www.hangge.com/blog/cache/detail_2647.html