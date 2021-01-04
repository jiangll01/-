## 背景介绍：

因项目需求，有PC端 APP端和小程序端，但登陆接口是同一个，然而微服务也无法使用传统的session解决用户登录问题（注意这里是传统的session不是spring session），使用户信息在其他服务共享。

如此一来就想到了token安全认证，而JWT生成token可以包含用户信息，也就果断选择了JWT作为SpringCloud gateway网关的token校验工具，这样，我们便可以直接解析token获取用户信息了。

## 具体实现思路：

1. 让JWT在其他所有服务可以共同使用，父工程需要引入JWT jar。避免在其他服务重复引入。
2. 如何使用JWT生成token。
3. 如何解析token。
4. 如何让网关拦截用户请求校验token。
5. 如何避免首次登录被网关拦截。

## 代码实现：

### **1.创建SpringCloud项目**

SpringCloud子项目包含 eureka，gateway，auth三个工程，父工程maven依赖如下。

```
<dependency>
    <groupId>com.nimbusds</groupId>
    <artifactId>nimbus-jose-jwt</artifactId>
    <version>6.0</version>
</dependency>
```

### ** **

### **2.Auth和gateway编写TOKEN工具类**

**
**

```
 public class Token {
    private static final Logger log = LoggerFactory.getLogger(Token.class);
    /**
     * 1.创建一个32-byte的密匙JWT生成TOKEN
     */
    private static final byte[] secret = "geiwodiangasfdjsikolkjikolkijswe".getBytes();
    //生成一个token
    public static String creatToken(Map<String,Object> payloadMap) throws JOSEException {
        //3.先建立一个头部Header
        /**
         * JWSHeader参数：1.加密算法法则,2.类型，3.。。。。。。。
         * 一般只需要传入加密算法法则就可以。
         * 这里则采用HS256
         * JWSAlgorithm类里面有所有的加密算法法则，直接调用。
         */
        JWSHeader jwsHeader = new JWSHeader(JWSAlgorithm.HS256);
        //建立一个载荷Payload
        Payload payload = new Payload(new JSONObject(payloadMap));
        //将头部和载荷结合在一起
        JWSObject jwsObject = new JWSObject(jwsHeader, payload);
        //建立一个密匙
        JWSSigner jwsSigner = new MACSigner(secret);
        //签名
        jwsObject.sign(jwsSigner);
        //生成token
        return jwsObject.serialize();
    }
    /**
     * 解析一个token
     * @param token
     * @return
     * @throws ParseException
     * @throws JOSEException
     */
    public static Map<String,Object> valid(String token) throws ParseException, JOSEException {
       //解析token
        JWSObject jwsObject = JWSObject.parse(token);
        //获取到载荷
        Payload payload=jwsObject.getPayload();
        //建立一个解锁密匙
        JWSVerifier jwsVerifier = new MACVerifier(secret);
        Map<String, Object> resultMap = new HashMap<>();
        //判断token
        if (jwsObject.verify(jwsVerifier)) {
            resultMap.put("Result", 0);
            //载荷的数据解析成json对象。
            JSONObject jsonObject = payload.toJSONObject();
            resultMap.put("data", jsonObject);
            //判断token是否过期
            if (jsonObject.containsKey("exp")) {
                Long expTime = Long.valueOf(jsonObject.get("exp").toString());
                Long nowTime = new Date().getTime();
                //判断是否过期
                if (nowTime > expTime) {
                    //已经过期
                    resultMap.clear();
                    resultMap.put("Result", 2);
                }
            }
        }else {
            resultMap.put("Result", 1);
        }
        return resultMap;
    }
  /**
   * 生成token的业务逻辑 登录接口调用次业务
   * @param uid
   * @return
   */
    public static String TokenTest(Long uid,Long deptId,String userType,int companyId) {
        //获取生成token
        Map<String, Object> map = new HashMap<>();
        //建立载荷，这些数据根据业务，自己定义。
        map.put("uid", uid);
        map.put("deptId", deptId);
        map.put("userType", userType);
        map.put("companyId", companyId);
        //生成时间
        map.put("sta", new Date().getTime());
        //过期时间
        map.put("exp", new Date().getTime()+1000*3600*24*15);
        try {
            String token = Token.creatToken(map);
            System.out.println("token="+token);
            return token;
        } catch (JOSEException e) {
            System.out.println("生成token失败");
            e.printStackTrace();
        }
        return null;

    }

    /**
     * 处理解析的业务逻辑 gateway JWT认证过滤器解析
     * @param token
     */
    public static Map<String,Object> ValidToken(String token) {
        Map<String, Object> userMsg = new HashMap<String, Object>();
        //解析token
        try {
            if (token != null) {
                Map<String, Object> validMap = Token.valid(token);
                int i = (int) validMap.get("Result");
                if (i == 0) {
                    log.info("token解析成功");
                    JSONObject jsonObject = (JSONObject) validMap.get("data");
                    log.info("uid是：" + jsonObject.get("uid"));
                    log.info("deptId是：" + jsonObject.get("deptId"));
                    log.info("userType是：" + jsonObject.get("userType"));
                    log.info("companyId是：" + jsonObject.get("companyId"));
                    log.info("生成时间是："+jsonObject.get("sta"));
                    log.info("过期时间是："+jsonObject.get("exp"));
                    userMsg.put("token",token);
                    userMsg.put("uid",jsonObject.get("uid"));
                    userMsg.put("deptId",jsonObject.get("deptId"));
                    userMsg.put("companyId",jsonObject.get("companyId"));
                    userMsg.put("userType",jsonObject.get("userType"));
                    return userMsg;
                } else if (i == 2) {
                    log.info("token已经过期");
                    return userMsg;
                }
            }
        } catch (ParseException e) {
            e.printStackTrace();
        } catch (JOSEException e) {
            e.printStackTrace();
        }
        return userMsg;
    }

    public static void main(String[] ages) {
        //获取token
        Long uid = 1L;
        Long deptId = 2L;
        String userType = "3";
        int companyId = 4;
        String token = TokenTest(uid,deptId,userType,companyId);
        //解析token
        log.info(ValidToken(token).toString());
    }
}
```

特别提示：以上工具类可以在用户登录授权接口中调用，用以生成token，示例代码如下（可以借鉴不可复制哦，请根据自己业务逻辑在合适的地方调用TOKEN工具）

```
@RestController
@RequestMapping("/currency")
public class CurrencyLoginController {
    //密钥 (需要前端和后端保持一致)
    private static final String KEY = "abcdefgabcdefg12";
    //redis初始KEY值
    private static final String LOGIN_USER = "login_user";
    @Autowired
    private RedisUtil ru;
    @PostMapping("/login")
    public Map<String, Object> ajaxLogin(String username, String password, Boolean rememberMe) throws Exception{
        password = AESUtil.aesDecrypt(password,KEY);//双向加密规则
        UsernamePasswordToken token = new UsernamePasswordToken(username, password, rememberMe);
        Subject subject = SecurityUtils.getSubject();
        try{
            subject.login(token);
            User user = ShiroUtils.getUser();
            String access_token = Token.generateToken(user.getUserId(), user.getDeptId(),user.getLoginUserType(), user.getCompanyId());
            UserMsg resultUser = new UserMsg();
            resultUser.setCompanyId(user.getCompanyId());
            resultUser.setUserType(user.getLoginUserType());
            resultUser.setDeptId(user.getDeptId());
            resultUser.setUid(user.getUserId());
            resultUser.setToken(access_token);
            ru.set(LOGIN_USER+user.getUserId(), resultUser, 3600*24*15);
            return ResultMap.ok("登录成功", resultUser);//改造——》》获取用户信息保存到redis中实现用户信息在微服务中共享，生成token
        }catch (AuthenticationException e){
            String msg = "用户或密码错误";
            if (StringUtils.isNotEmpty(e.getMessage())){
                msg = e.getMessage();
            }
            return ResultMap.error(msg);
        }
    }
}
```

好了，此时呢，我们已经通过auth工程完成了用户登录授权，并且生成了token。那么如何在gateway网关中进行token认证呢？

### **3.gateway网关中编写JwtCheckGatewayFilterFactory过滤器。**

此类需要继承gateway的AbstractGatewayFilterFactory。

代码实现如下：

首先gateway网关yml文件中需要代理auth路由。

```
spring:
cloud:
    gateway:
      routes:
      - id: neo_route
        uri: lb://YUNXI-AUTH
        predicates:
        - Path=/auth/**
        filters:
        - StripPrefix=1
        - JwtCheck
```

自定义 JwtCheckGatewayFilterFactory 继承 AbstractGatewayFilterFactory 抽象类，代码如下：

```
public class JwtCheckGatewayFilterFactory extends AbstractGatewayFilterFactory<JwtCheckGatewayFilterFactory.Config> {
    private static final Logger log = LoggerFactory.getLogger(JwtCheckGatewayFilterFactory .class);
//定义用户认证登录接口
    private static final String CURRENCY_URL="/currency/login";
    //redis初始KEY值
    private static final String LOGIN_USER = "login_user";
    @Autowired
    private RedisUtil ru;
    public JwtCheckGatewayFilterFactory() {
        super(Config.class);
    }
    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            String jwtToken = exchange.getRequest().getHeaders().getFirst("Authorization");
            log.info(exchange.getRequest().getURI().toString());
            //校验jwtToken的合法性,如果当前请求url和认证url相同跳过认证，表示用户首次登录认证
            if(exchange.getRequest().getURI().toString().contains(CURRENCY_URL)){
                return chain.filter(exchange);
            }
            if(jwtToken != null){
                log.info(Token.ValidToken(jwtToken).toString());
                //解析TOKEN
                Map<String, Object> userMsg = Token.ValidToken(jwtToken);
                Long uid = (Long) userMsg.get("uid");
                if(ru.hasKey(LOGIN_USER+uid)){
                    Object obj = ru.get(LOGIN_USER+uid);
                    UserMsg userModel = (UserMsg) obj;
                    //解析客户端传过来的TOKEN是否和缓存中的TOKEN相同，并且判断TOKEN过期时间是否大于当前时间
                    if(userModel.getToken().equals(jwtToken)){
                        return chain.filter(exchange);
                    }else{
                        ServerHttpResponse response = exchange.getResponse();
                        String warningStr = "不合法的请求";
                        DataBuffer bodyDataBuffer = response.bufferFactory().wrap(warningStr.getBytes());
                        return response.writeWith(Mono.just(bodyDataBuffer));
                    }
                 }else{
                     ServerHttpResponse response = exchange.getResponse();
                    String warningStr = "登录超时";
                    DataBuffer bodyDataBuffer = response.bufferFactory().wrap(warningStr.getBytes());
                    return response.writeWith(Mono.just(bodyDataBuffer));
                 }
            }
            //不合法(响应未登录的异常)
            ServerHttpResponse response = exchange.getResponse();
            //设置headers
            HttpHeaders httpHeaders = response.getHeaders();
            httpHeaders.add("Content-Type", "application/json; charset=UTF-8");
            httpHeaders.add("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
            //设置body
            String warningStr = "未授权的请求，请登录";
            DataBuffer bodyDataBuffer = response.bufferFactory().wrap(warningStr.getBytes());
            return response.writeWith(Mono.just(bodyDataBuffer));
        };
    }

    public static class Config {
        //Put the configuration properties for your filter here
    }
}
```

编写config文件将JWT认证过滤器添加到Spring bean中。

```
@Configuration
public class AppConfig {
    @Bean
    public JwtCheckGatewayFilterFactory jwtCheckGatewayFilterFactory(){
        return new JwtCheckGatewayFilterFactory();
    }
}
```

此时我们就完成了整个token认证过程，其实简单的来说就是：

- 第一步：Auth工程配合用户登录生成token，并将token和用户信息存储在redis中。
- 第二步：在gayeway中编写JWT认证过滤器，用以校验用户请求中携带的token。

有图有真相

![img](https://mmbiz.qpic.cn/mmbiz_png/eQPyBffYbufT87HDU7iaGyQpfPfmyqHyg7miaoa7AODp0ez1Y7HGyPvWUyC41zavGlY7eyTTexuajRfFsL5h2RWw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

特别提示：**我的auth工程端口是8766，登录认证接口路由是/currency/login。而此时我请求的认证接口是/main/currency/login,端口是8765，我们在文章开头就已说明，gateway网关在yml文件中配置auth代理为auth/**，和这里的main是同一个道理。

如果此时我们再去请求项目中其他端口携带过期的token试试看效果：

![img](https://mmbiz.qpic.cn/mmbiz_png/eQPyBffYbufT87HDU7iaGyQpfPfmyqHygrPvgP6c4zF4lSWKeV8yvopSUUMbkeBNXoqaPYw7GmjicBchedia3uY3A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

我们登陆认证返回的token是：

> eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOjEsInN0YSI6MTU1NjcxODU2Nzc3NCwiY29tcGFueUlkIjowLCJkZXB0SWQiOjEwMCwidXNlclR5cGUiOm51bGwsImV4cCI6MTU1ODAxNDU2Nzc3NH0.6oXx4Wk-eWHSWTHyJHmoiGowKnAmBdCHIRCzsMq5XlA；

携带的其他过期的token是：

> eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOjEsInN0YSI6MTU1NjQ1NjUwNzIwMiwiY29tcGFueUlkIjowLCJkZXB0SWQiOjEwMCwidXNlclR5cGUiOm51bGwsImV4cCI6MTU1Nzc1MjUwNzIwMn0._yF2TeaR4MTmF-Re9QciMZOeRKBOQmfvi3o4hWeGSMU

再携带错误的token试试看：

![img](https://mmbiz.qpic.cn/mmbiz_png/eQPyBffYbufT87HDU7iaGyQpfPfmyqHygtW1pkINLvjZJic842a4UfpbCakaxeVfNnzPK6OOdheJ3JOQl6gJOFzQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

登陆认证返回的token是：

> eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOjEsInN0YSI6MTU1NjcxODU2Nzc3NCwiY29tcGFueUlkIjowLCJkZXB0SWQiOjEwMCwidXNlclR5cGUiOm51bGwsImV4cCI6MTU1ODAxNDU2Nzc3NH0.6oXx4Wk-eWHSWTHyJHmoiGowKnAmBdCHIRCzsMq5XlA；

携带错误的token是：

> eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOjEsInN0YSI6MTU1NjcxODU2Nzc3NCwiY29tcGFueUlkIjowLCJkZXB0SWQiOjEwMCwidXNlclR5cGUiOm51bGwsImV4cCI6MTU1ODAxNDU2Nzc3NH0.6oXx4Wk-eWHSWTHyJHmoiGowKnAmBdCHIRCzsMq5XlD

携带正确的token:

![img](https://mmbiz.qpic.cn/mmbiz_png/eQPyBffYbufT87HDU7iaGyQpfPfmyqHyg6cbfDDdyH2eJKdiceSgGSN9ObY7aNibiaQ6FyluibGzvn8c0W3j7SKt39g/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

到这里我么你的整个SpringCloud gateway网关+JWT安全认证就结束啦，非常抱歉，由于项目保密性不能为大家提供项目源码。但是整个过程我已经写的非常详细，也不希望大家做伸手党，如果有各种疑问欢迎留言，我可以帮大家一一解决。