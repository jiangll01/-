mysql只支持一种join算法：Nested-Loop Join（嵌套循环连接），但Nested-Loop Join有三种变种：Simple Nested-Loop Join，Index Nested-Loop Join，Block Nested-Loop Join

（1）Simple Nested-Loop Join（图片为InsideMySQL取来）

这个算法相对来说就是很简单了，从驱动表中取出R1匹配S表所有列，然后R2，R3,直到将R表中的所有数据匹配完，然后合并数据，可以看到这种算法要对S表进行RN次访问，虽然简单，但是相对来说开销还是太大了

![img](https://upload-images.jianshu.io/upload_images/1005338-c2aa7f350a3e6f08.png?imageMogr2/auto-orient/strip|imageView2/2/w/1062/format/webp)

（2）Index Nested-Loop Join，实现方式如下图：

索引嵌套联系由于非驱动表上有索引，所以比较的时候不再需要一条条记录进行比较，而可以通过索引来减少比较，从而加速查询。这**也就是平时我们在做关联查询的时候必须要求关联字段有索引的一个主要原因。**

1. 这种算法在链接查询的时候，**驱动表会根据关联字段的索引进行查找，当在索引上找到了符合的值，再回表进行查询，也就是只有当匹配到索引以后才会进行回表。至于驱动表的选择，MySQL优化器一般情况下是会选择记录数少的作为驱动表，但是当SQL特别复杂的时候不排除会出现错误选择。**

**在索引嵌套链接的方式下，如果非驱动表的关联键是主键的话，这样来说性能就会非常的高**，如果不是主键的话，关联起来如果返回的行数很多的话，效率就会特别的低，因为要多次的回表操作。先关联索引，然后根据二级索引的主键ID进行回表的操作。这样来说的话性能相对就会很差。

![img](https://images2015.cnblogs.com/blog/695151/201707/695151-20170705185523503-834605858.png)

（3）Block Nested-Loop Join，实现如下：

在有索引的情况下，MySQL会尝试去使用Index Nested-Loop Join算法，在有些情况下，可能Join的列就是没有索引，那么这时MySQL的选择绝对不会是最先介绍的Simple Nested-Loop Join算法，而是会优先使用Block Nested-Loop Join的算法。

Block Nested-Loop Join对比Simple Nested-Loop Join多了一个中间处理的过程，也就是join buffer，使用join buffer将驱动表的查询JOIN相关列都给缓冲到了JOIN BUFFER当中，然后批量与非驱动表进行比较，这也来实现的话，可以将多次比较合并到一次，降低了非驱动表的访问频率。也就是只需要访问一次S表。这样来说的话，就不会出现多次访问非驱动表的情况了，也只有这种情况下才会访问join buffer。

在MySQL当中，我们可以通过参数join_buffer_size来设置join buffer的值，然后再进行操作。默认情况下join_buffer_size=256K，在查找的时候MySQL会将所有的需要的列缓存到join buffer当中，包括select的列，而不是仅仅只缓存关联列。在一个有N个JOIN关联的SQL当中会在执行时候分配N-1个join buffer。

![img](https://images2015.cnblogs.com/blog/695151/201707/695151-20170705185545050-534103959.png)

**实例：**

假设两张表a 和 b：

```
a结构：
comments_id        bigInt(20)    P
for_comments_if    mediumint(9)
product_id         int(11)
order_id           int(11)
...
```

```
b结构：
id            int(11)       p
comments_id   bigInt(20)
product_id    int(11)
...
```

其中b的关联有comments_id，所以有索引。

**join:**

```
SELECT * FROM a 
JOIN b  ON a.comments_id=b.comments_id
WHERE a.comments_id =2056
```

使用的是Index Nested-Loop Join，先对驱动表a的主键筛选，得到一条，然后对非驱动表b的索引进行seek匹配，预计得到一条数据。

下面这种情况没用到索引:

```
SELECT * FROM a 
JOIN b  ON a.order_id=b.product_id
```

使用Block Nested-Loop Join，如果b表数据少，作为驱动表，将b的需要的数据缓存到join buffer中，批量对a表扫描

**left join：**

```
SELECT * FROM a gc
LEFT JOIN b gcf ON gc.comments_id=gcf.comments_id
```

这里用到了索引，所以会采用Index Nested-Loop Join，因为没有筛选条件，会选择一张表作为驱动表去进行join，去关联非驱动表的索引。

```
SELECT * FROM b gcf
LEFT JOIN a gc ON gc.comments_id=gcf.comments_id
WHERE gcf.comments_id =2056
```

如果加了条件:就会从驱动表筛选出一条来进行对非驱动表的匹配。





#####   实例

（1）全表JOIN

```
EXPLAIN SELECT * FROM comments gc
JOIN comments_for gcf ON gc.comments_id=gcf.comments_id;
```

 

看一下输出信息：

![img](https://images2015.cnblogs.com/blog/695151/201707/695151-20170705185626206-669877625.png)

可以看到在全表扫描的时候comments_for 作为了驱动表，此事因为关联字段是有索引的，所以对索引idx_commentsid进行了一个全索引扫描去匹配非驱动表comments ，每次能够匹配到一行。此时使用的就是Index Nested-Loop Join，通过索引进行了全表的匹配，我们可以看到因为comments_for 表的量级远小于comments ，所以说MySQL优先选择了小表comments_for 作为了驱动表。

（2）全表JOIN+筛选条件

```
SELECT * FROM comments gc
JOIN comments_for gcf ON gc.comments_id=gcf.comments_id
WHERE gc.comments_id =2056
```

![img](https://images2015.cnblogs.com/blog/695151/201707/695151-20170705185647737-1416819513.png)

此时使用的是Index Nested-Loop Join，先对驱动表comments 的主键进行筛选，符合一条，对非驱动表comments_for 的索引idx_commentsid进行seek匹配，最终匹配结果预计为影响一条，这样就是仅仅对非驱动表的idx_commentsid索引进行了一次访问操作，效率相对来说还是非常高的。

（3）看一下关联字段是没有索引的情况：

```
EXPLAIN SELECT * FROM comments gc
JOIN comments_for gcf ON gc.order_id=gcf.product_id
```

我们看一下执行计划：

![img](https://images2015.cnblogs.com/blog/695151/201707/695151-20170705191540128-1695689441.png)

从执行计划我们就可以看出，这个表JOIN就是使用了Block Nested-Loop Join来进行表关联，先把comments_for （只有57行）这个小表作为驱动表，然后将comments_for 的需要的数据缓存到JOIN buffer当中，批量对comments 表进行扫描，也就是只进行一次匹配，前提是join buffer足够大能够存下comments_for的缓存数据。

而且我们看到执行计划当中已经很明确的提示：**Using where; Using join buffer (Block Nested Loop)**

**一般情况出现这种情况就证明我们的SQL需要优化了。**

要注意的是这种情况下，MySQL也会选择Simple Nested-Loop Join这种暴力的方法，我还没搞懂他这个优化器是怎么选择的，但是一般是使用Block Nested-Loop Join，因为CBO是基于开销的，Block Nested-Loop Join的性能相对于Simple Nested-Loop Join是要好很多的。

（4）看一下left join

```
EXPLAIN SELECT * FROM comments gc
LEFT JOIN comments_for gcf ON gc.comments_id=gcf.comments_id 
```

看一下执行计划：

![img](https://images2015.cnblogs.com/blog/695151/201707/695151-20170705192117644-1197812054.png)

这种情况，由于我们的关联字段是有索引的，所以说Index Nested-Loop Join，只不过当没有筛选条件的时候会选择第一张表作为驱动表去进行JOIN，去关联非驱动表的索引进行Index Nested-Loop Join。

如果加上筛选条件gc.comments_id =2056的话，这样就会筛选出一条对非驱动表进行Index Nested-Loop Join，这样效率是很高的。

如果是下面这种：

```
EXPLAIN SELECT * FROM comments_for gcf
LEFT JOIN comments gc ON gc.comments_id=gcf.comments_id
WHERE gcf.comments_id =2056
```

通过gcf表进行筛选的话，就会默认选择gcf表作为驱动表，因为很明显他进行过了筛选，匹配的条件会很少，具体可以看下执行计划：

![img](https://images2015.cnblogs.com/blog/695151/201707/695151-20170705190717284-1851651503.png)