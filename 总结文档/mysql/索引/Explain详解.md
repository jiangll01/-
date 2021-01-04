#####   explain共有十个属性参数

https://segmentfault.com/a/1190000021458117?utm_source=tag-newest



<img src="C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200805151802627.png" alt="image-20200805151802627" style="zoom:150%;" />

**EXPLAIN列的解释：**

**1.id **选定的执行计划中查询的序列号。表示查询中执行select子句或操作表的顺序，id值越大优先级越高，越先被执行。id相同，执行顺序由上至下。

**我的理解是SQL执行的顺序的标识，SQL从大到小的执行**

1. id相同时，执行顺序由上至下

2. 如果是子查询，id的序号会递增，id值越大优先级越高，越先被执行

3. id如果相同，可以认为是一组，从上往下顺序执行；在所有组中，id值越大，优先级越高，越先执行

```
-- 查看在研发部并且名字以Jef开头的员工，经典查询
explain select e.no, e.name from emp e left join dept d on e.dept_no = d.no where e.name like 'Jef%' and d.name = '研发部';
```

![img](https://images2018.cnblogs.com/blog/512541/201808/512541-20180803143413064-173136748.png) 

**2.select_type**  查询类型，说明：

![img](https://img-blog.csdn.net/20161115220345523?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

3**.table**：显示这一行的数据是关于哪张表的

**4.type**：这是重要的列，显示连接使用了何种类型。

**从最好到最差的连接类型为const、eq_reg、ref、range、index和ALL**

![img](https://img-blog.csdn.net/20161114194012528?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)







**5.possible_keys**：显示可能应用在这张表中的索引。如果为空，没有可能的索引。可以为相关的域从WHERE语句中选择一个合适的语句

**6.key**：实际使用的索引。如果为NULL，则没有使用索引。很少的情况下，MYSQL会选择优化不足的索引。这种情况下，可以在SELECT语句中使用USEINDEX（indexname）来强制使用一个索引或者用IGNORE INDEX（indexname）来强制MYSQL忽略索引

**7.key_len**：使用的索引的长度。在不损失精确性的情况下，长度越短越好

**8.ref**：显示索引的哪一列被使用了，如果可能的话，是一个常数

**9.rows**：MYSQL认为必须检查的用来返回请求数据的行数

**10.Extra：**关于MYSQL如何解析查询的额外信息。这里可以看到的坏的例子是Using temporary和Using filesort，意思MYSQL根本不能使用索引，结果是检索会很慢,应该避免。

![img](https://img-blog.csdn.net/20161114194015653?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQv/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

很显然，当type是ALL，即最坏的情况。Extra里还出现了Using filesort，也是最坏的情况，优化是必须的。 