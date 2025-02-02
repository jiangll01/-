假设有两个事务A，B，有一个资源值（一条记录）是V；另外一个资源值（多条记录的集合） VVV。

1.丢失修改：A 修改 V 为 v1， B 修改 V 为 v2。那么最后 V 是v1 还是 v2 呢？无论结果是什么，一定只有一个结果，那么另外一个修改就丢失了，因此叫做丢失修改。

2.脏读：A 修改 V 为 v1， 但是修改不成功，事务会回滚。 在事务 A 回滚的时候，B去读取 V 的值，读到的值是什么？ 是 v1。 我们的 B 事务想期望的值是 V， 但是却读到了 v1，v1是一个脏数据，因此我们简称脏读。

3.不可重复读：这个场景下，A 事务要读两次 V 的值。 第一次直接读取，然后停下，这个时候 B 事务去修改 V 的值为 v1，然后 A 事务再执行它的第二次读取。第一次读到的是 V， 第二次读到的是 v1，一个事务不同时间读到的值不一样，这个就是不可重复读。

4.幻读：这个场景的资源值不再是一个记录了，而是很多记录的一个集合，我们叫它 VVV(假设有三条记录，分别为 v1，v2，v3)。A 事务读到了 VVV 集合，再使用它之前，B 事务把集合中的 v3 值删除了，这个时候我们去使用这个集合中的 v3， 但是发现值不在这里了，我们所读到的集合就是一个不真实的集合。幻读的资源一定要是一个集合，修改（删除也被认为是一种修改）会导致集合变化。

针对这四种问题，MySQL有四种不同的隔离级别，不同的隔离级别解决的问题不一样。

**1.读未提交**：解决丢失修改的问题。由上面可知，两个事务同时修改一个资源值的时候，会发生修改丢失的问题。这个时候我们对资源加一个排他锁，加锁以后，资源只能由一个事务所拥有，修改完毕以后另外一个事务才可以拿到资源。这就解决了丢失修改的问题。（资源值加 X 锁，事务结束释放）。

**2.读提交**：解决脏读问题。在 1 的基础上（给资源加 X 锁，直到事务结束），增加一个 S 锁。 读数据的时候给数据加一个 S 锁， 资源在有 X 锁的时候，S 锁是加不上去的，因此直到事务结束， S 锁才可以加上去， 事务都结束了，自然不会读到脏数据。（写数据加 X 锁，事务结束释放，读数据加 S 锁，读完数据立即释放）

**3.可重复读**：上一个隔离级别中，读的时候加 S 锁。 在不可重复读的问题里面：

   a.第一次读，加 S 锁，得到 V，释放 S 锁；

   b. 然后 B 事务修改 V 为 v1，加了 X 锁，事务结束后释放；

   c.第二次读，加 S 锁，得到 v1，释放 S 锁。 

是不是不可重复的问题还是存在？怎么解决呢？ 将我们的 S 锁设定为，一个事务结束后才释放。 加了这个限定条件以后， B 事务就无法修改 V， 因为 V 现在加了 S 锁，只能被读，无法被修改。（写数据加 X 锁，事务结束释放，读数据加 S 锁，事务结束释放）

**4.串行化**，串行化是事务完全按照 ACID 的四个原则来执行，这种情况效率比较低，很少用。

这样一说了，你觉得共享锁还是多余的吗？

再针对具体问题做一个解释。

```
select *from table_name for update; // 加 X 锁
select *from table_name for share; // 加 S 锁，MySQL 版本 8.0 以后。
select *from table_name lock in share mode;  加 S 锁， MySQL 版本 8.0 以前。
```

示例： 1. 首先开始一个事务A，并且关闭自动提交。

```
START TRANSACTION;
set autocommit = 0;
```

2. 然后在查询条件下加一把 X 锁

```
SELECT	*FROM person for UPDATE;
```

3. 接下来你再开一个查询窗口，开不开事务都没关系，给查询加一把 S 锁

```
SELECT *FROM person LOCK IN SHARE MODE; // 我的版本是 MySQL 5.6
```

执行这条查询 SQL 的时候，就会被堵塞。原因是你在 事务A 中给表加了 X 锁，再给表加 S 锁的时候就会堵塞。

当然，你可以先加 S 锁，再去加 X 锁的时候同样会被堵塞。