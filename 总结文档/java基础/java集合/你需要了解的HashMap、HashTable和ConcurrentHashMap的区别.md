面试中经常被问到的一个问题，HashMap和ConcurrentHashMap区别是什么，今天把这个问题好好整理一下。HashMap是线程不安全的，当出现多线程操作时，会出现安全隐患，我们可能会想到HashTable，是的，这个是线程安全的，但是HashTable用的是方法锁，把整个put方法都上锁了，这就导致了效率很低，如果把put方法比作是一个有很多房间的院子，那么HathTable的锁就相当于是把院子的大门锁上了。而ConcurrentHashMap是用的块锁，相当于是把院子里的有安全隐患的房间锁上了，这样一来，就不会让去其他房间办事的人等待了。

HashMap

HashMap是线程不安全的，在原码中对put方法没有做锁的处理，当放生多线程时，会有线程安全问题，下面通过一个简单的例子进行演示，创建三个线程，并且启动，在run方法里通过for循环给map存100个值，然后输出map的大小按正常来说，该map的大小应该是100，而这里输出了176。

class Demo implements Runnable{ static Map<String,String> map = new HashMap<>(); @Override public void run() { for (int i = 0; i < 100; i ++) { map.put(i + "","value"); } } public static void main(String[] args) { new Thread(new Demo()).start(); new Thread(new Demo()).start(); new Thread(new Demo()).start(); // 获取当前线程 Thread currentThread = Thread.currentThread(); // 当前线程睡眠2秒，让上面的三个线程先执行 try { currentThread.sleep(2000); } catch (Exception e) { e.getMessage(); } // 上面的线程执行完毕后输出map的大小 System.out.println(map.size()); }}

![img](https://pics3.baidu.com/feed/30adcbef76094b3623be57794907ffdf8c109d4c.jpeg?token=e9ee74ff40c4d8072e4fe57b7b998cd4)

HashTable

HashTable用到了锁，而且是直接给put方法加的锁，线程肯定是安全的了，这里我们在测试线程安全的同时，看一下执行时间，这里通过put10000个数据进行测试，通过结果可以看到，map的大小确实是10000，而时间用了16ms左右。

![img](https://pics5.baidu.com/feed/08f790529822720ef5fe0f9d90008940f31fabfc.jpeg?token=5877330e6df887c09fb43034372b4dde)

class Demo implements Runnable{ static Map<String,String> map = new Hashtable<>(); @Override public void run() { long startTime = System.currentTimeMillis(); //获取开始时间 for (int i = 0; i < 10000; i ++) { map.put(i + "","value"); } long endTime = System.currentTimeMillis(); //获取结束时间 System.out.println((endTime - startTime) + "ms"); } public static void main(String[] args) { new Thread(new Demo()).start(); new Thread(new Demo()).start(); new Thread(new Demo()).start(); // 获取当前线程 Thread currentThread = Thread.currentThread(); // 当前线程睡眠2秒，让上面的三个线程先执行 try { currentThread.sleep(2000); } catch (Exception e) { e.getMessage(); } // 上面的线程执行完毕后输出map的大小 System.out.println(map.size()); }}

![img](https://pics6.baidu.com/feed/d31b0ef41bd5ad6ee1e27dbc6a00baddb7fd3c9a.jpeg?token=ce4f7ec8a23cb2ca147e0443f0a26ced)

ConcurrentHashMap

ConcurrentHashMap用的是块锁，哪块不安全就锁哪块，不能不锁，不能全锁，那我就块锁！看看这个块锁相对于方法锁是快了，还是慢了。

![img](https://pics5.baidu.com/feed/023b5bb5c9ea15ce87e9efcb5ccbb9f53b87b23b.jpeg?token=cc2811866636f48d5c7afb73ec8831d8)

class Demo implements Runnable{ static Map<String,String> map = new ConcurrentHashMap<>(); @Override public void run() { long startTime = System.currentTimeMillis(); //获取开始时间 for (int i = 0; i < 10000; i ++) { map.put(i + "","value"); } long endTime = System.currentTimeMillis(); //获取结束时间 System.out.println((endTime - startTime) + "ms"); } public static void main(String[] args) { new Thread(new Demo()).start(); new Thread(new Demo()).start(); new Thread(new Demo()).start(); // 获取当前线程 Thread currentThread = Thread.currentThread(); // 当前线程睡眠2秒，让上面的三个线程先执行 try { currentThread.sleep(2000); } catch (Exception e) { e.getMessage(); } // 上面的线程执行完毕后输出map的大小 System.out.println(map.size()); }}

![img](https://pics0.baidu.com/feed/a044ad345982b2b7ff71ddfcdd6648e977099b6a.jpeg?token=e0cc7d017cfd5f059d487bd17aa1f790)

**从结果中看到，从之前的20ms和22ms提高到了现在的17ms和18ms**