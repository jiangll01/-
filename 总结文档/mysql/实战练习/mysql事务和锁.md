####  mysql的事务

1、

```
SELECT @@tx_isolation  //查看事务的隔离级别
SHOW VARIABLES LIKE 'autocommit' //查看事务是否自动提交 （ON 自动提交 OFF不是自动提交 需要手动 commit;）
SET AUTOCOMMIT=0  //关闭事务自动提交

SHOW OPEN TABLES  //查看表的锁情况
SHOW STATUS LIKE 'table%' //查看表锁的情况 
LOCK TABLE 表名 READ //添加读锁  读锁只允许读操作，不允许写操作
LOCK TABLE 表名 write //添加写锁 不允许读写操作阻塞
UNLOCK TABLES  //解锁
```

​	