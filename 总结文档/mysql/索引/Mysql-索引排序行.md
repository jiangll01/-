# Mysql-索引排序行

```
该表有4个字段(id,a,b,c)，共27行数据
```

![img](https://img-blog.csdn.net/20161208234418991?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdHlfaGY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

**创建索引 a**

```
如下图，当创建索引a以后，在该索引结构中，从原来的按照主键ID排序，变成了新的规则，我们说索引其实就是一个数据结构。则建立索引a，就是新另建立一个结构，排序按照字段a规则排序，第一条为主键ID为1代表的数据行，第二条ID=3的数据行,第三条ID=5代表的数据行。。。
```

![img](https://img-blog.csdn.net/20161208234423517?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdHlfaGY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

```
新排序主键ID(以ID代表他们这行的数据)：1 3 5 6 9 16 18 23 26 2 10 11 12 13 14 15 20 25 4 7 8 17 19 21 22 24 27
不难发现，当字段a相同时，他们的排列 前后主键ID来排，比如同样是a=1.1的值，但是他们的排序是ID值为1，3，5，6。。对应的行，和主键ID排序顺序相近。(即相同值时的排序，ID小的在前边)
```

**创建索引 (a,b)**

```
如下图，当创建联合索引(a,b)以后，在该索引结构中，从原来的按照主键ID排序，变成了新的规则，排序规则先按照字段a排序，在a的基础上在按照字段b排序。即在索引a的基础上，对字段b也进行了排序。

```

![img](https://img-blog.csdn.net/20161208234427163?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdHlfaGY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)

```
新排序主键ID(以ID代表他们这行的数据)：6 18 23 10 15 20 7 22 27 1 3 26 2 11 25 4 8 24 5 9 16 12 13 14 17 19 21
不难发现，当字段a,b值都相同时，他们的排列前后，也是由主键ID决定的，比如同样是a=1.1,b=2.1的行(18,6,23)，但是他们的排序是6,18,23。
字段(a,b)索引，先按a索引排序，然后在a的基础上，按照b排序
6 18 23 10 15 20 7 22 27 1 3 26 2 11 25 4 8 24 5 9 16 12 13 14 17 19 21
```

**创建索引 (a,b,c)**

字段(a,b,c)索引，先按a,b索引排序，然后在（a，b）的基础上，按照c排序

![img](https://img-blog.csdn.net/20161208234430189?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdHlfaGY=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)