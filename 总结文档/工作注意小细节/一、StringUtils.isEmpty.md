####  工作遇到得问题

#####  1、mybatis中查询结果为空时不同返回类型对应返回值

今天在别人的代码基础上实现新需求，看到对于mybatis查询结果的判断不是很正确，如果查询结果为空就会异常，不知道大家有没有这样的疑惑：mybatis中resultType有多种返回类型，对于每种不同类型，查询结果为空时dao接口的返回值是一样的吗？接下来我就总结一下常见的几种情况。

**第一种：resultType为基本类型，如string（在此暂且把string归纳为基本类型）**

　　如果select的结果为空，则dao接口返回结果为null

**第二种，resultType为基本类型，如int**

后台报异常：
org.apache.ibatis.binding.BindingException: Mapper method 'com.fkit.dao.xxDao.getUserById attempted to return null from a method with a primitive return type (int).
解释：查询结果为null，试图返回null但是方法定义的返回值是int，null转为int时报错
解决办法：修改select的返回值为String

**第三种 resultType为类为map ，如map、hashmap**

　　dao层接口返回值为null

**第四种 resultType 为list ，如list**

　　dao层接口返回值为[]，即空集合。

注意：此时判断查询是否为空就不能用null做判断

**第五种 resultType 为类 ，如com.fkit.pojo.User**

　　dao层接口返回值null

**集合为空还是null?**

**集合为空**：集合内没有元素，即为空

- isEmpty：boolean isEmpty() : 如果此列表不包含元素，则返回 `true` 。

**null**：没有对 List 集合分配空间，即未实例化

1. **isEmpty()** : 用于判断List中元素是否为空，必须在已经分配内存空间的前提下，否则报出异常
2. **== null** : 用于判断 List 集合是否已经被分配内存空间
3. **list.size() == 0** : 与 isEmpty() 方法效果一致，但更推荐使用 isEmpty()

ArrayList<Student> list = null; System.out.println(null == list);//返回 true System.out.println(list.isEmpty());// 空指针异常

#####  2、判空用StringUtils.isBlank还是StringUtils.isEmpty？

在我们日常开发中，判空应该是最常用的一个操作了。因此项目中总是少不了依赖commons-lang3包。这个包为我们提供了两个判空的方法，分别是StringUtils.isEmpty(CharSequence cs)和StringUtils.isBlank(CharSequence cs)。我们分别来看看这两个方法有什么区别。

## 一、StringUtils.isEmpty

isEmpty的源码如下：

![img](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1ibicHpuqdSfIHaAKH714EyRbIbvqqPfhfuPHe30y4narIibmJicP7YQHp0iaeVAa08HhmXhA0kyzof2g/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

这个方法判断的是字符串是否为null或者其长度是否为零。

**「测试效果」**

![img](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1ibicHpuqdSfIHaAKH714EyROwEwooqjgl8QCtDQhDnojHXYYZEmZXEzmdC5cRibfYQJtK1UH4kxryA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## 二、StringUtils.isBlank

isBlank的源码如下：

![img](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1ibicHpuqdSfIHaAKH714EyRFEry5Qts9Mq3iaibzOhE3uB6dwTpU3V3GEibYXm0McByRFmEms3ibKAgdQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

length(cs)的方法如下

![img](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1ibicHpuqdSfIHaAKH714EyRibtOO5Zz6TP2USdtgvgqWiaZhsJFuTp9wxLbezPvqA41AZ6qzia0cl3lg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

这个方法除了判断字符串是否为null和长度是否为零，还判断了是否为空格，如果是空格也返回true。

**「测试效果」**

![img](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1ibicHpuqdSfIHaAKH714EyRGnROia6DrCdDAgyPdPmGIZcPAVUZdsxO6MPicLlwY7KtFyCdc5djnJvQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

## 三、总结

- isEmpty：如果是null或者“”则返回true。
- isBlank：如果是null或者“”或者空格或者制表符则返回true。**「isBlank判空更加准确」**。

## 四、扩展

1. 在实际开发中，除了isBlank判空的几种情况之外，其实“null”字符串我们也会当作空字符串处理。
2. 我们需要判断几个字段同时不能为空，如果还用isBlank就显得有点累赘了。我们可以使用String的可变参数提供如下工具类。
3. ![img](https://mmbiz.qpic.cn/sz_mmbiz_png/2BGWl1qPxib1ibicHpuqdSfIHaAKH714EyRcbdMX2ibIAtiaoWBNmYWc3fibqFBOdmCmkYA2NwdjojbF25SlRXGd7a1A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

这个工具类的优点很明显，一方面判断了字符串“null”，另一方面对参数个数无限制，只要有一个参数是空则返回true。



