#####  百万级数据量下，mysql执行limit时，怎么不让其卡的要命呀

1、百万计数据量下进行LIMIT操作时，我们查询

```
SELECT * FROM ddos_defense_config limit 5000000,5      //查询500万数据后5条数据
导致的原因的话，这样不走索引的话，直接全表扫描的话，很慢的
```

```
SELECT * FROM ddos_defense_config  WHERE target_type ='site' limit 5000000,5
百万数据量下，查询某个条件下的500完数据得话，这样通过添加 target_type 索引的话，还是需要进行 500万数据量的回表，导致效率还是很低的
```

**优化下哈**

```
SELECT * FROM ddos_defense_config WHERE id  IN  (SELECT id FROM  ddos_defense_config WHERE target_type ='site' LIMIT 5000000,5)

大数据量下，首先走普通索引查出5条id，这样我们回表走聚簇索引的时候，直接通过5个id，去叶子节点查找全部数据
```

```
mysql 在5.7版本下，不支持limit这种，需要进行稍微的调整
SELECT * FROM ddos_defense_config WHERE id  IN 
( SELECT t.id FROM 
(SELECT id FROM  ddos_defense_config WHERE target_type ='site' LIMIT 5) AS t
)

```

**什么会导致全表扫描呦**

​	全表扫描是数据库搜寻表的每一条记录的过程，直到所有符合给定条件的记录返回为止。通常在数据库中，对无索引的表进行查询一般称为全表扫描；然而有时候我们即便添加了索引，但当我们的SQL语句写的不合理的时候也会造成全表扫描。

​	全表扫描就是百万级数据量的话，就是一行一行的查找，那小速度可想而知，酸爽的不要不要的，所以我们对于大数据量还是多考虑走索引吧。要不然，用户查一个数据，我尼玛数据库直接给你干个几秒钟。客户一看，这是卡住了，挂了吗？老子再刷新下，哈哈，直接心态给干崩。

​	下面的大家可要注意了呀，尽量避免啊

​	1. 使用null做为判断条件 

```
select account from member where nickname = null; 
```

​    2. 左模糊查询Like %XXX% 

```
select account from member where nickname like ‘%XXX%’ 或者 select account from member where nickname like ‘%XXX’ 

建议使用select account from member where nickname like ‘XXX%’，如果必须要用到做查询，需要评估对当前表全表扫描造成的后果
```

​	3.使用or做为连接条件 

```
select account from member where id = 1 or id = 2; 
建议使用union all,改为 select account from member where id = 1 union all select account from member where id = 2; 
```

​	4.使用in时(not in) 

```
select account from member where id in (1,2,3) 
如果是连续数据，可以改为select account where id between 1 and 3;
当数据较少时也可以参考union用法； 

select account from member where id in (select accountid from department where id = 3 )
可以改为
select account from member where id exsits (select accountid from department where id = 3) 
not in 可以对应 not exists; 
```

​	5.使用not in时 

```
select account where id not in (1,2,3) 
```

​	6、使用！=或<>时 

```
建议使用 <,<=,=,>,>=,between等； 
```

​	7.使用count(*)时 

```
如select count(*) from member； 
建议使用select count(1) from member; 

https://www.cnblogs.com/hider/p/11726690.html 主要内容
```

​	8.使用参数做为查询条件时

```
如select account from member where nickname = @name 
由于SQL语句在编译执行时并不确定参数，这将无法通过索引进行数据查询，所以尽量避免
```

