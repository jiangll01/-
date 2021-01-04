# 为什么我们写的代码都是 if-else？

程序员想必都经历过这样的场景：刚开始自己写的代码很简洁，逻辑清晰，函数精简，没有一个 if-else，可随着代码逻辑不断完善和业务的瞬息万变:比如需要对入参进行类型和值进行判断；这里要判断下对象是否为 null；不同类型执行不同的流程。

落地到具体实现只能不停地加 if-else 来处理，渐渐地，代码变得越来越庞大，函数越来越长，文件行数也迅速突破上千行，维护难度也越来越大，到后期基本达到一种难以维护的状态。

虽然我们都很不情愿写出满屏 if-else 的代码，可逻辑上就是需要特殊判断，很绝望，可也没办法避免啊。

其实回头看看自己的代码，写 if-else 不外乎两种场景：异常逻辑处理和不同状态处理。

两者最主要的区别是：异常逻辑处理说明只能一个分支是正常流程，而不同状态处理都所有分支都是正常流程。

怎么理解？举个例子：

```
 1//举例一：异常逻辑处理例子
 2Object obj = getObj();
 3if (obj != null) {
 4    //do something
 5}else{
 6    //do something
 7}
 8
 9//举例二：状态处理例子
10Object obj = getObj();
11if (obj.getType == 1) {
12    //do something
13}else if (obj.getType == 2) {
14    //do something
15}else{
16    //do something
17}
```

第一个例子 if (obj != null) 是异常处理，是代码健壮性判断，只有 if 里面才是正常的处理流程，else 分支是出错处理流程；而第二个例子不管 type 等于 1，2 还是其他情况，都属于业务的正常流程。对于这两种情况重构的方法也不一样。

**代码 if-else 代码太多有什么缺点？**

缺点相当明显了：最大的问题是代码逻辑复杂，维护性差，极容易引发 bug。如果使用 if-else，说明 if 分支和 else 分支的重视是同等的，但大多数情况并非如此，容易引起误解和理解困难。

**是否有好的方法优化？如何重构？**

方法肯定是有的。重构 if-else 时，心中无时无刻把握一个原则：

尽可能地维持正常流程代码在最外层。

意思是说，可以写 if-else 语句时一定要尽量保持主干代码是正常流程，避免嵌套过深。

实现的手段有：减少嵌套、移除临时变量、条件取反判断、合并条件表达式等。关注公众号Java核心技术可以获取一份阿里最新的 Java 开发手册。

下面举几个实例来讲解这些重构方法：

# 异常逻辑处理型重构方法实例一

重构前：

```
 1double disablityAmount(){
 2    if(_seniority < 2)
 3        return 0;
 4
 5    if(_monthsDisabled > 12)
 6        return 0;
 7
 8    if(_isPartTime)
 9        return 0;
10
11    //do somethig
12}
```

重构后：

```
1double disablityAmount(){
2    if(_seniority < 2 || _monthsDisabled > 12 || _isPartTime)
3        return 0;
4
5    //do somethig
6}
```

这里的重构手法叫合并条件表达式：如果有一系列条件测试都得到相同结果，将这些结果测试合并为一个条件表达式。推荐看下：[狗屎一样的代码重构](http://mp.weixin.qq.com/s?__biz=MzI3ODcxMzQzMw==&mid=2247488468&idx=1&sn=5ce2259a11bd98e9409055d3afa42fab&chksm=eb5396e3dc241ff594259c689353bb61a3870cc7c05b55bf25ad23c7&scene=21#wechat_redirect)。

这个重构手法简单易懂，带来的效果也非常明显，能有效地较少if语句，减少代码量逻辑上也更加易懂。

# 异常逻辑处理型重构方法实例二

重构前：

```
 1double getPayAmount(){
 2    double result;
 3    if(_isDead) {
 4        result = deadAmount();
 5    }else{
 6        if(_isSeparated){
 7            result = separatedAmount();
 8        }
 9        else{
10            if(_isRetired){
11                result = retiredAmount();
12            else{
13                result = normalPayAmount();
14            }
15        }
16    }
17    return result;
18}
```

重构后：

```
 1double getPayAmount(){
 2    if(_isDead)
 3        return deadAmount();
 4
 5    if(_isSeparated)
 6        return separatedAmount();
 7
 8    if(_isRetired)
 9        return retiredAmount();
10
11    return normalPayAmount();
12}
```

怎么样？比对两个版本，会发现重构后的版本逻辑清晰，简洁易懂。

和重构前到底有什么区别呢？

最大的区别是减少 if-else 嵌套。可以看到，最初的版本 if-else 最深的嵌套有三层，看上去逻辑分支非常多，进到里面基本都要被绕晕。其实，仔细想想嵌套内的 if-else 和最外层并没有关联性的，完全可以提取最顶层。

改为平行关系，而非包含关系，if-else 数量没有变化，但是逻辑清晰明了，一目了然。

另一个重构点是废除了 result 临时变量，直接 return 返回。好处也显而易见直接结束流程，缩短异常分支流程。原来的做法先赋值给 result 最后统一 return，那么对于最后 return 的值到底是那个函数返回的结果不明确，增加了一层理解难度。

总结重构的要点：如果 if-else 嵌套没有关联性，直接提取到第一层，一定要避免逻辑嵌套太深。尽量减少临时变量改用 return 直接返回。

# 异常逻辑处理型重构方法实例三

重构前：

```
1public double getAdjustedCapital(){
2    double result = 0.0;
3    if(_capital > 0.0 ){
4        if(_intRate > 0 && _duration >0){
5            resutl = (_income / _duration) *ADJ_FACTOR;
6        }
7    }
8    return result;
9}
```

第一步，运用第一招，减少嵌套和移除临时变量：

```
1public double getAdjustedCapital(){
2    if(_capital <= 0.0 ){
3        return 0.0;
4    }
5    if(_intRate > 0 && _duration >0){
6        return (_income / _duration) *ADJ_FACTOR;
7    }
8    return 0.0;
9}
```

这样重构后，还不够，因为主要的语句 (_income / _duration) *ADJ_FACTOR; 在 if 内部，并非在最外层，根据优化原则（尽可能地维持正常流程代码在最外层），可以再继续重构：

```
 1public double getAdjustedCapital(){
 2    if(_capital <= 0.0 ){
 3        return 0.0;
 4    }
 5    if(_intRate <= 0 || _duration <= 0){
 6        return 0.0;
 7    }
 8
 9    return (_income / _duration) *ADJ_FACTOR;
10}
```

这才是好的代码风格，逻辑清晰，一目了然，没有 if-else 嵌套难以理解的流程。

这里用到的重构方法是：将条件反转使异常情况先退出，让正常流程维持在主干流程。[Spring Boot 如何干掉 if else？](http://mp.weixin.qq.com/s?__biz=MzI3ODcxMzQzMw==&mid=2247489698&idx=2&sn=6242fe69a55363714b86cb671c7b409c&chksm=eb539d94dc24148263b9cfaba8acb0dcd0acf14e1364dbf8aeb983f8a412c6c5fc931636662e&scene=21#wechat_redirect)推荐看下。

# 异常逻辑处理型重构方法实例四

重构前：

```
 1   /* 查找年龄大于18岁且为男性的学生列表 */
 2    public ArrayList<Student> getStudents(int uid){
 3        ArrayList<Student> result = new ArrayList<Student>();
 4        Student stu = getStudentByUid(uid);
 5        if (stu != null) {
 6            Teacher teacher = stu.getTeacher();
 7            if(teacher != null){
 8                ArrayList<Student> students = teacher.getStudents();
 9                if(students != null){
10                    for(Student student : students){
11                        if(student.getAge() > = 18 && student.getGender() == MALE){
12                            result.add(student);
13                        }
14                    }
15                }else {
16                    logger.error("获取学生列表失败");
17                }
18            }else {
19                logger.error("获取老师信息失败");
20            }
21        } else {
22            logger.error("获取学生信息失败");
23        }
24        return result;
25    }
```

典型的"箭头型"代码，最大的问题是嵌套过深，解决方法是异常条件先退出，保持主干流程是核心流程：

重构后：

```
 1   /* 查找年龄大于18岁且为男性的学生列表 */
 2    public ArrayList<Student> getStudents(int uid){
 3        ArrayList<Student> result = new ArrayList<Student>();
 4        Student stu = getStudentByUid(uid);
 5        if (stu == null) {
 6            logger.error("获取学生信息失败");
 7            return result;
 8        }
 9
10        Teacher teacher = stu.getTeacher();
11        if(teacher == null){
12            logger.error("获取老师信息失败");
13            return result;
14        }
15
16        ArrayList<Student> students = teacher.getStudents();
17        if(students == null){
18            logger.error("获取学生列表失败");
19            return result;
20        }
21
22        for(Student student : students){
23            if(student.getAge() > 18 && student.getGender() == MALE){
24                result.add(student);
25            }
26        }
27        return result;
28    }
```

# 状态处理型重构方法实例一

重构前：

```
 1double getPayAmount(){
 2    Object obj = getObj();
 3    double money = 0;
 4    if (obj.getType == 1) {
 5        ObjectA objA = obj.getObjectA();
 6        money = objA.getMoney()*obj.getNormalMoneryA();
 7    }
 8    else if (obj.getType == 2) {
 9        ObjectB objB = obj.getObjectB();
10        money = objB.getMoney()*obj.getNormalMoneryB()+1000;
11    }
12}
```

重构后：

```
 1double getPayAmount(){
 2    Object obj = getObj();
 3    if (obj.getType == 1) {
 4        return getType1Money(obj);
 5    }
 6    else if (obj.getType == 2) {
 7        return getType2Money(obj);
 8    }
 9}
10
11double getType1Money(Object obj){
12    ObjectA objA = obj.getObjectA();
13    return objA.getMoney()*obj.getNormalMoneryA();
14}
15
16double getType2Money(Object obj){
17    ObjectB objB = obj.getObjectB();
18    return objB.getMoney()*obj.getNormalMoneryB()+1000;
19}
```

这里使用的重构方法是：把 if-else 内的代码都封装成一个公共函数。函数的好处是屏蔽内部实现，缩短 if-else 分支的代码。代码结构和逻辑上清晰，能一下看出来每一个条件内做的功能。

# 状态处理型重构方法实例二

针对状态处理的代码，一种优雅的做法是用多态取代条件表达式(《重构》推荐做法)。



你手上有个条件表达式，它根据对象类型的不同而选择不同的行为。将这个表达式的每个分支放进一个子类内的覆写函数中，然后将原始函数声明为抽象函数。

重构前：

```
 1double getSpeed(){
 2    switch(_type){
 3        case EUROPEAN:
 4            return getBaseSpeed();
 5        case AFRICAN:
 6            return getBaseSpeed()-getLoadFactor()*_numberOfCoconuts;
 7        case NORWEGIAN_BLUE:
 8            return (_isNailed)?0:getBaseSpeed(_voltage);
 9    }
10}
```

重构后：

```
 1class Bird{
 2    abstract double getSpeed();
 3}
 4
 5class European extends Bird{
 6    double getSpeed(){
 7        return getBaseSpeed();
 8    }
 9}
10
11class African extends Bird{
12    double getSpeed(){
13        return getBaseSpeed()-getLoadFactor()*_numberOfCoconuts;
14    }
15}
16
17class NorwegianBlue extends Bird{
18    double getSpeed(){
19        return (_isNailed)?0:getBaseSpeed(_voltage);
20    }
21}
```

可以看到，使用多态后直接没有了 if-else，但使用多态对原来代码修改过大，需要一番功夫才行。最好在设计之初就使用多态方式。关注公众号Java技术栈可以获取优秀程序员写代码的系列 Java 规范。

# 总结

if-else 代码是每一个程序员最容易写出的代码，同时也是最容易被写烂的代码，稍不注意，就产生一堆难以维护和逻辑混乱的代码。

针对条件型代码重构把握一个原则：

尽可能地维持正常流程代码在最外层，保持主干流程是正常核心流程。

为维持这个原则：合并条件表达式可以有效地减少if语句数目；减少嵌套能减少深层次逻辑；异常条件先退出自然而然主干流程就是正常流程。

针对状态处理型重构方法有两种：一种是把不同状态的操作封装成函数，简短 if-else 内代码行数；另一种是利用面向对象多态特性直接干掉了条件判断。

现在回头看看自己的代码，犯了哪些典型错误，赶紧运用这些重构方法重构代码吧！！