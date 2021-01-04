#####  mysql执行过程

#####  1、mysql的执行过程

![img](https://img2018.cnblogs.com/blog/1446270/201910/1446270-20191006025827107-243871764.png)

大体上，MySQL 分为 Server 层和存储引擎层两部分。

Server 层包括连接器、查询缓存、分析器、执行器等，以及所有的内置函数（如日期、时间、数学和加密函数等）和跨存储引擎的功能（如存储过程、触发器、视图）。

存储引擎层负责数据的存储和提取，支持 InnoDB、MyISAM、Memory 等多个存储引擎。MySQL 5.5.5 版本后默认存储存储引擎是 InnoDB。一般用的是InnoDB，这些数据存储在磁盘。

**连接器（**Connector）

在查询 SQL 语句前，肯定要先建立与 MySQL 的连接，这就是由连接器来完成的。连接器负责跟客户端建立连接、获取权限、维持和管理连接。连接命令为：

Mysql -h$ip -p$port -u$user -p

输入密码，验证通过后，连接器会到权限表里面查出你拥有的权限，之后这个连接里面的权限判断逻辑，都将依赖于此时读到的权限，一个用户成功建立连接后，即使管理员对这个用户的权限做了修改，也不会影响已经存在连接的权限，修改完后，只有再新建的连接才会使用新的权限设置。

连接完成后，如果你没有后续的动作，这个连接就处于空闲状态，你可以在 `show processlist` 命令中看到它。结果如下：

![image-20200805093422571](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200805093422571.png)

客户端如果太长时间没动静，连接器就会自动将它断开；这个时间是由参数 wait_timeout 控制的，默认值是8小时。如果在连接被断开之后，客户端再次发送请求的话，就会收到一个错误提醒：`Lost connection to MySQL server during query`。

**长连接和短连接**

- 数据库里面，长连接是指连接成功后，如果客户端持续有请求，则一直使用同一个连接。
- 短连接则是指每次执行完很少的几次查询就断开连接，下次查询再重新建立一个。

建立连接的过程通常是比较复杂的，建议在使用中要尽量减少建立连接的动作，尽量使用长连接。但是全部使用长连接后，有时候 MySQL 占用内存涨得特别快，这是因为 MySQL 在执行过程中临时使用的内存是管理在连接对象里面的。这些资源会在连接断
开的时候才释放。所以如果长连接累积下来，可能导致内存占用太大，被系统强行杀掉（OOM），从现象看就是 MySQL 异常重启了。

怎么解决这个问题呢？可以考虑以下两种方案：

1. 定期断开长连接。使用一段时间，或者程序里面判断执行过一个占用内存的大查询后，断开连接，之后要查询再重连。
2. MySQL 5.7 以上版本，可以在每次执行一个比较大的操作后，通过执行 mysql_reset_connection 来重新初始化连接资源。这个过程不需要重连和重新做权限验证，但是会将连接恢复到刚刚创建完时的状态。

#####  2、查询缓存（Query Cache）

在建立连接后，就开始执行 select 语句了，执行前首先会查询缓存。

MySQL 拿到查询请求后，会先查询缓存，看是不是执行过这条语句。执行过的语句及其结果会以 key-value 对的形式保存在一定的内存区域中。key 是查询的语句，value 是查询的结果。如果你的查询能够直接在这个缓存中找到 key，那么这个value 就会被直接返回给客户端。

如果语句不在查询缓存中，就会继续后面的执行阶段。执行完成后，执行结果会被存入查询缓存中。如果查询命中缓存，MySQL 不需要执行后面的复杂操作，就可以直接返回结果，会提升效率。

1.配置查询缓存
修改配置文件，修改[mysqld]下的query_cache_size和query_cache_type（如果没有则添加）。其中query_cache_size表示缓存的大小，而query_cache_type有3个值，表示缓存那种类 型的select结果集，query_cache_type各个值如下：

0或off关闭缓存
1或on开启缓存，但是不保存使用sql_no_cache的select语句,如不缓存select sql_no_cache name from wei where id=2
2或demand开启有条件缓存，只缓存带sql_cache的select语句，缓存select sql_cache name from wei where id=4，配置完成重启Mysql服务器即可

```
query_cache_size=10M
query_cache_type=1
```

可以用如下命令查看是否开启，其中`have_query_cache`为是否开启，`query_cache_limit` 指定单个查询能够使用的缓冲区大小，缺省为1M；`query_cache_min_res_unit`为系统分配的最小缓存块大小，默认是4KB，设置值大对大数据查询有好处，但如果你的查询都是小数据 查询，就容易造成内存碎片和浪费；`query_cache_size`和query_cache_type就是上面我们的配置；query_cache_wlock_invalidate表示当有其他客户端正在对MyISAM表进行写操作时，如果查询在query cache中，是否返回cache结果还是等写操作完成再读表获取结果。

```
SHOW VARIABLES LIKE '%query_cache%'//查看缓存变量的值
```

![image-20200805094746924](C:\Users\jiangll01\AppData\Roaming\Typora\typora-user-images\image-20200805094746924.png)

```
 show status like 'qcache%';//查看现在缓存的情况
```

```
mysql> show status like 'qcache%';
+-------------------------+----------+
| Variable_name           | Value    |
+-------------------------+----------+
| Qcache_free_blocks      | 1        |
| Qcache_free_memory      | 10475424 |
| Qcache_hits             | 1        |
| Qcache_inserts          | 1        |
| Qcache_lowmem_prunes    | 0        |
| Qcache_not_cached       | 0        |
| Qcache_queries_in_cache | 1        |
| Qcache_total_blocks     | 4        |
+-------------------------+----------+
8 rows in set (0.00 sec)

其中各个参数的意义如下：
Qcache_free_blocks：缓存中相邻内存块的个数。数目大说明可能有碎片。FLUSH QUERY CACHE会对缓存中的碎片进行整理，从而得到一个空闲块。
Qcache_free_memory：缓存中的空闲内存。
Qcache_hits：每次查询在缓存中命中时就增大
Qcache_inserts：每次插入一个查询时就增大。命中次数除以插入次数就是不中比率。
Qcache_lowmem_prunes：缓存出现内存不足并且必须要进行清理以便为更多查询提供空间的次数。这个数字最好长时间来看;如果这个 数字在不断增长，就表示可能碎片非常严重，或者内存很少。(上面的 free_blocks和free_memory可以告诉您属于哪种情况)
Qcache_not_cached：不适合进行缓存的查询的数量，通常是由于这些查询不是 SELECT 语句或者用了now()之类的函数。
Qcache_queries_in_cache：当前缓存的查询(和响应)的数量。
Qcache_total_blocks：缓存中块的数量。
```

但是查询缓存的失效非常频繁，只要有对一个表的更新，这个表上所有的查询缓存都会被清空。对于更新压力大的数据库来说，查询缓存的命中率会非常低。如果业务中需要有一张静态表，很长时间才会更新一次。比如，一个系统配置表，那这张表上的查询才适合使用查询缓存。MySQL 提供了这种按需使用的方式。可以将参数 query_cache_type 设置成 DEMAND，对于默认的 SQL 语句都将不使用查询缓存。而对于你确定要使用查询缓存的语句，可以用 SQL_CACHE 显式指定，如下：

```
Mysql> select SQL_CACHE * from user_info where id = 1;

//MySQL 8.0版本将查询缓存的功能删除了
```

#####     3、分析器（Analyzer）

如果查询缓存未命中，就要开始执行语句了。首先，MySQL 需要对 SQL 语句进行解析。

分析器先会做词法分析。SQL 语句是由多个字符串和空格组成的，MySQL 需要识别出里面的字符串分别是什么，代表什么。MySQL 从你输入的 select 这个关键字识别出来，这是查询语句。它也要把字符串 user_info 识别成表名，把字符串 id 识别成列名。之后就要做语法分析。根据词法分析的结果，语法分析器会根据语法规则，判断输入的 SQL 语句是否满足 MySQL 语法。

如果你 SQL 语句不对，就会收到 `You have an error in your SQL syntax` 的错误提醒，比如下面这个语句 from 写成了 form。

```
mysql> select * form user_info  where id = 1;

- You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'form user_info  where id = 1' at line 
```

#####   4、**优化器（**Optimizer）

经过分析器的词法分析和语法分析后，还要经过优化器的处理。

优化器是在表里面有多个索引的时候，决定使用哪个索引；或者在一个语句有多表关联（join）的时候，决定各个表的连接顺序。比如你执行下面这样的语句，这个语句是执行两个表的 join：

```
SELECT * FROM order_master JOIN order_detail USING (order_id) WHERE order_master.pay_status = 0 AND order_detail.detail_id = 1558963262141624521;
```

既可以先从表 order_master 里面取出 pay_status = 0 的记录的 order_id 值，再根据 order_id 值关联到表 order_detail，再判断 order_detail 里面 detail_id 的值是否等于 1558963262141624521。

也可以先从表 order_detail 里面取出 detail_id = 1558963262141624521 的记录的 order_id 值，再根据 order_id 值关联到 order_master，再判断 order_master 里面 pay_status 的值是否等于 0。

这两种执行方法的逻辑结果是一样的，但是执行的效率会有不同，而优化器的作用就是决定选择使用哪一个方案。优化器阶段完成后，这个语句的执行方案就确定下来了，然后进入执行器阶段。

#####  5、执行器（Actuator）

MySQL 通过分析器知道了要做什么，通过优化器知道了该怎么做，于是就进入了执行器阶段，开始执行语句。

开始执行的时候，要先判断一下你对这个表 user_info 有没有执行查询的权限，如果没有，就会返回没有权限的错误，如下所示 (如果命中查询缓存，会在查询缓存返回结果的时候，做权限验证。查询也会在优化器之前调用 precheck 验证权限)。

```
mysql> select * from user_info where id = 1;

ERROR 1142 (42000): SELECT command denied to user 'wupx'@'localhost' for table 'user_info'
```

如果有权限，就打开表继续执行。打开表的时候，执行器就会根据表的引擎定义，去使用这个引擎提供的接口。比如我们这个例子中的表 user_info 中，id 字段没有索引，那么执行器的执行流程是这样的：

1. 调用 InnoDB 引擎接口取这个表的第一行，判断 id 值是不是 1，如果不是则跳过，如果是则将这行存在结果集中；
2. 调用引擎接口取下一行，重复相同的判断逻辑，直到取到这个表的最后一行。
3. 执行器将上述遍历过程中所有满足条件的行组成的记录集作为结果集返回给客户端。

对于有索引的表，第一次调用的是取满足条件的第一行这个接口，之后循环取满足条件的下一行这个接口。

数据库的慢查询日志中有 **rows_examined** 字段，表示这个语句执行过程中扫描了多少行。这个值就是在执行器每次调用引擎获取数据行的时候累加的。在有些场景下，执行器调用一次，在引擎内部则扫描了多行，因此引擎扫描行数跟 **rows_examined** 并不是完全相同的。