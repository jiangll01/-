
   在java应用中，对于访问频率比较高，又不怎么变化的数据，常用的解决方案是把这些数据加入缓存。相比DB,缓存的读取效率快好不少。java应用缓存一般分两种，一是进程内缓存，就是使用java应用虚拟机内存的缓存；另一个是进程外缓存，现在我们常用的各种分布式缓存。相比较而言，进程内缓存比进程外缓存快很多，而且编码也简单；但是，进程内缓存的存储量有限，使用的是java应用虚拟机的内存，而且每个应用都要存储一份，有一定的资源浪费。进程外缓存相比进程内缓存，会慢些，但是，存储空间可以横向扩展，不受限制。

 

   这里是几中场景的访问时间

 

\-------------------------------------------------------------------

|     从数据库中读取一条数据（有索引）     |  十几毫秒  |

|     从远程分布式缓存读取一条数据        |  0.5毫秒   |

|     从内存中读取1MB数据             |  十几微妙  |

\-------------------------------------------------------------------

 

   进程内缓存和进程外缓存，各有优缺点，针对不同场景，可以分别采用不同的缓存方案。对于数据量不大的，我们可以采用进程内缓存。或者只要内存足够富裕，都可以采用，但是不要盲目以为自己富裕，不然可能会导致系统内存不够。

 

   下面要分享的是一个代码级别的，对进程内缓存的经验总结。面向jdk1.8版本。

 

  在有效时间内缓存单个对象

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
public class LiveCache<T> {
    // 缓存时间
    private final int cacheMillis;
    // 缓存对象
    private final T element;
    // 缓存对象创建时间
    private final long createTime;
 
    public LiveCache(int cacheMillis, T element) {
        this.cacheMillis = cacheMillis;
        this.element = element;
        this.createTime = System.currentTimeMillis();
    }
 
    // 获取缓存对象
    public T getElement() {
        long currentTime = System.currentTimeMillis();
        if(cacheMillis > 0 && currentTime - createTime > cacheMillis) {
            return null;
        } else {
            return element;
        }
    }
 
    // 获取缓存对象，忽略缓存时间有效性
    public T getElementIfNecessary() {
        return element;
    }
}
 
public static void main(String[] args) {
    int cacheMilis = 1000 ;
    LiveCache<Object> liveCache = new LiveCache<>(cacheMilis, new Object()) ;
 
    liveCache.getElement() ;
    liveCache.getElementIfNecessary() ;
 
}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

  有效时间内，缓存单个对象，可异步刷新

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
@FunctionalInterface
public interface LiveFetch<T> {
    // 刷新缓存接口
    T fetch() ;
}
 
public class LiveManager<T> {
    // 缓存时间
    private int cacheMillis;
    // 缓存对象
    private LiveCache<T> liveCache;
    // 刷新缓存的对象
    private LiveFetch<T> liveFetch ;
 
    private Logger logger = LoggerFactory.getLogger(LiveManager.class) ;
 
    // 刷新缓存开关
    private boolean refresh = false ;
 
    public LiveManager(int cacheMillis, LiveFetch<T> liveFetch) {
        this.cacheMillis = cacheMillis ;
        this.liveFetch = liveFetch ;
    }
 
    /**
     * fetch cache ; if cache expired , synchronous fetch
     * @return
     */
    public T getCache() {
 
        initLiveCache();
 
        if(liveCache != null) {
            T t  ;
            if((t= liveCache.getElement()) != null) {
                return t ;
            } else {
                t = liveFetch.fetch() ;
                if(t != null) {
                    liveCache = new LiveCache<T>(cacheMillis, t) ;
                    return t ;
                }
            }
        }
 
        return null ;
    }
 
    /**
     * fetch cache ; if cache expired , return old cache and asynchronous fetch
     * @return
     */
    public T getCacheIfNecessary() {
 
        initLiveCache();
 
        if(liveCache != null) {
            T t  ;
            if((t= liveCache.getElement()) != null) {
                return t ;
            } else {
                refreshCache() ;
                return liveCache.getElementIfNecessary() ;
            }
        }
 
        return null ;
    }
 
    /**
     * init liveCache
     */
    private void initLiveCache() {
        if(liveCache == null) {
            T t = liveFetch.fetch() ;
            if(t != null) {
                liveCache = new LiveCache<T>(cacheMillis, t) ;
            }
        }
    }
 
    /**
     * asynchronous refresh cache
     */
    private void refreshCache() {
 
        if(refresh)
            return ;
        refresh = true ;
        try {
            Thread thread = new Thread(() -> {
                try {
                    T t = liveFetch.fetch();
                    if (t != null) {
                        liveCache = new LiveCache<>(cacheMillis, t);
                    }
                } catch (Exception e){
                    logger.error("LiveManager.refreshCache thread error.", e);
                } finally {
                    refresh = false ;
                }
            }) ;
            thread.start();
        } catch (Exception e) {
            logger.error("LiveManager.refreshCache error.", e);
        }
    }
}
 
public class Test {
 
    public static void main(String[] args) {
        int cacheMilis = 1000 ;
        LiveManager<Object> liveManager = new LiveManager<>(cacheMilis,() -> new Test().t1()) ;
 
        liveManager.getCache() ;
        liveManager.getCacheIfNecessary() ;
    }
 
    public Object t1(){
 
        return new Object() ;
    }
}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 

  有效缓存内，缓存多个对象，map结构存储，可异步刷新

![img](https://images.cnblogs.com/OutliningIndicators/ExpandedBlockStart.gif)

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```
@FunctionalInterface
public interface LiveMapFetch<T> {
    // 异步刷新数据
    T fetch(String key) ;
}
 
public class LiveMapManager<T> {
 
    private int cacheMillis;
    private Map<String,LiveCache<T>> liveCacheMap;
    private LiveMapFetch<T> liveMapFetch;
 
    private Logger logger = LoggerFactory.getLogger(LiveMapManager.class) ;
 
 
    private boolean refresh = false ;
 
    public LiveMapManager(int cacheMillis, LiveMapFetch<T> liveMapFetch) {
        this.cacheMillis = cacheMillis ;
        this.liveMapFetch = liveMapFetch ;
    }
 
    /**
     * fetch cache ; if cache expired , synchronous fetch
     * @return
     */
    public T getCache(String key) {
 
        initLiveCache();
 
        T t ;
        if(liveCacheMap.containsKey(key) && (t = liveCacheMap.get(key).getElement()) != null) {
            return t ;
        } else {
            t = liveMapFetch.fetch(key) ;
            if(t != null) {
                LiveCache<T> liveAccess = new LiveCache<T>(cacheMillis, t) ;
                liveCacheMap.put(key, liveAccess) ;
                return t ;
            }
        }
 
        return null ;
    }
 
    /**
     * fetch cache ; if cache expired , return old cache and asynchronous fetch
     * @return
     */
    public T getCacheIfNecessary(String key) {
 
        initLiveCache();
 
        T t ;
        if(liveCacheMap.containsKey(key) && (t = liveCacheMap.get(key).getElement()) != null) {
            return t ;
        } else {
            if(liveCacheMap.containsKey(key)) {
                refreshCache(key) ;
                return liveCacheMap.get(key).getElementIfNecessary() ;
            } else {
                t = liveMapFetch.fetch(key) ;
                if(t != null) {
                    LiveCache<T> liveAccess = new LiveCache<T>(cacheMillis, t) ;
                    liveCacheMap.put(key, liveAccess) ;
                    return t ;
                }
            }
        }
        return t ;
    }
 
    /**
     * init liveCache
     */
    private void initLiveCache() {
        if(liveCacheMap == null) {
            liveCacheMap = new HashMap<>() ;
        }
    }
 
    /**
     * asynchronous refresh cache
     */
    private void refreshCache(String key) {
 
        if(refresh)
            return ;
        refresh = true ;
        try {
            Thread thread = new Thread(() -> {
                try {
                    T t = liveMapFetch.fetch(key);
                    if (t != null) {
                        LiveCache<T> liveAccess = new LiveCache<>(cacheMillis, t);
                        liveCacheMap.put(key, liveAccess);
                    }
                } catch (Exception e) {
                    logger.error("LiveMapManager.refreshCache thread error.key:",e);
                } finally {
                    refresh = false ;
                }
            }) ;
            thread.start();
        } catch (Exception e) {
            logger.error("LiveMapManager.refreshCache error.key:" + key, e);
        }
    }
 
}
 
public class Test {
 
    public static void main(String[] args) {
        int cacheMilis = 1000 ;
        LiveMapManager<Object> liveManager = new LiveMapManager<>(cacheMilis,(String key) -> new Test().t1(key)) ;
 
        liveManager.getCache("key") ;
        liveManager.getCacheIfNecessary("key") ;
    }
 
    public Object t1(String key){
 
        return new Object() ;
    }
}
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

 