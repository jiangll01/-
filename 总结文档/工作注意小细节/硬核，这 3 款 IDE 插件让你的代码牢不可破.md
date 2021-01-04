有一段时间没去电影院了，上次看的还是战争题材的《八佰》，现在还能记得当时的观影感受：热血沸腾的同时，一种宁死不屈的信念从心底油然而生。战场虽然只有四行仓库那么大点的地方，却显得牢不可破，敌人再凶猛的火力，似乎都无法有所突破。

作为和代码打交道的我们，天敌除了乱改需求的“产品经理”（请老老实实地背锅），还有那无穷无尽永远也修改不完的 bug。为了抵御 bug 的侵扰，我们想尽了各种办法，不停地修缮工地，努力让我们的代码变得牢不可破。

这些努力当中，有 3 款优秀的 IDE 插件功不可没。是哪 3 个呢？请腰杆挺直，眼睛睁大，大声呼喊出它们的名字。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCeMsJY8GN3503d4gYica2SDELjEMKQmYZyDsicdrKoRG3cCibkBrtSiaZlg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

### 01、CheckStyle

> Checkstyle 是一个静态代码分析工具，用来检查 Java 源代码是否符合编码规则。

那编码规则由谁定义才能比较被认可呢？

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfC1Bx9qrLbku3uw9WU0GX6HSBSe07MCUPew4jxhrsiasNicBkpYZQ6iaNwA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

除了 Sun，还有谷歌，可以吧？感兴趣的小伙伴可以通过下面的地址阅读一下谷歌的 Java 代码规范。

> https://google.github.io/styleguide/javaguide.html

可以在 Intellij IDEA 的插件市场里直接安装 CheckStyle 这个插件。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfC0NRiagnHQdicSUibcxh3qgOIdRe6icdvG6E6SnAcLO7Iibfzf10pmh0c97A/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

点击 OK 后，就可以在 Intellij IDEA 的底部看到「CheckStyle」面板，默认支持 Sun 和谷歌的代码规范。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCCec0gS3uDIxicj0tl1xtRoMl1zuCwibgc4chVB5BjTCiandOaNPBJhBYQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

选择一种规则后，可以点击左侧的 2 个小图标对项目或者模块进行检查（也可以使用右键「Check Current File」 检查当前类文件），然后就可以看到修改建议了。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCiafv0BxE1QYOArau7aDsOjcBzU1cjyM2ywWpBTZQibCTeqKruSWnKKKg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

不过，输出的信息里有大量对代码缩进的建议，是因为 CheckStyle 默认的缩进规则是使用 2 个空格，但我更习惯使用 4 个空格，能不能自定义一下呢？

当然可以。

**第一步**，按照下面的路径把 CheckStyle 的 GitHub 仓库导入到码云（可以提高克隆速度）。

> https://github.com/itwanger/checkstyle

**第二步**，使用 GitHub 桌面版把导入后的仓库 clone 到本地。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCfib1PN7xdpUevMk28ZRRWxpzLh5dSzv6MmsQGPXYVmtft3XQf3sichYQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

PS：我已经克隆过了，所以会有警告提示。

**第三步**，找到 src/main/resources/google_checks.xml 文件，修改 Indentation（缩进）元素后保存。

```
<module name="Indentation">
  <property name="basicOffset" value="4"/>
  <property name="braceAdjustment" value="0"/>
  <property name="caseIndent" value="4"/>
  <property name="throwsIndent" value="4"/>
  <property name="lineWrappingIndentation" value="4"/>
  <property name="arrayInitIndent" value="4"/>
</module>
```

**第四步**，打开 Intellij IDEA 的首选项，找到「Tools」→「Checkstyle」。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCibRaEoxy5LZult5ywaO76O0drxLtfLDmzN3b0Yt8Dic8bGZ4Npibpbvxw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

点击「Configuration File」 栏目底部的「+」号，自定义 Checkstyle 规则。填写「Description」，并将之前复制的路径粘贴到「URL」中，点击「Next」。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCJRibR40CTzUgD8AtcSLjk717rJ1e2wiaUOk70Y1LltRCD1boB6x2bYSQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

**第五步**，配置成功后，在「CheckStyle」面板看到我们自定义的检查规则了。选中后，再次扫描，就可以看到缩进的警告信息消失了。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCWeCbW873sTWqOsqQmP9aiagoZrmYcQ8unYZV1IicYiaRPvA8KF4YAic0Jw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

如果团队内部使用的话，也可以在谷歌和 sun 的代码规约基础上进行一些调整，从而更符合团队开发的习惯，同时还能起到统一代码规范的作用，美哉美哉。

### 02、Alibaba Java 代码规范

《阿里巴巴 Java 开发手册》自从第一个版本起，就倍受业界关注，毕竟是阿里出品啊。最新版是嵩山版，离线下载地址我贴一下：

> https://pan.baidu.com/s/1iBVFWUPuJNFEBfG8cmd-aA  密码:pplh

我看了很多遍，有些规约已经深深地刻在脑海里，在写代码的时候就会特别注意。甚至有时候写完代码，都要对照一遍规约，看看有哪些细节需要调整。

为了让开发者更加方便、快速的将规范推动并执行起来，阿里巴巴基于这本手册的内容，研发了一套自动化的 IDE 插件（有 Intellij IDEA 和 Eclipse 两个版本）。

Intellij IDEA 可以直接在插件市场进行下载安装。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCMn3T5ZXu6ckwWEaz33x6NOqtQPr74Xnb2icQTAUr6LeIeqHAFfEvBHQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

目前插件检测有两种模式：实时检测和手动触发。

**1）实时检测**

《阿里巴巴 Java 开发手册》的第一条规约如下：

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCwf8r35ViaUicx5eBOwfBnm4LqqiardcHdfIpvdb969GQOLuuFibXuho3zg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

实时检测是默认开启的，我们来“明知故犯”一下：

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCFtSIDFGn2q0KxkzPicYtTR0VXt1SstwhbX4iaYqFJwic9TAuCWP435vwQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

在编码的时候，插件就会及时的给出提示建议，说`【_name】命名不能以_或$开始`。

如果不喜欢实时检测的话，可以通过「Tools」→「阿里编码规约」→「关闭实时检测功能」来进行关闭。

**2）手动触发**

在代码编辑区域右键菜单选择「编码规约扫描」就可以对当前文件进行扫描，也可以选择整个项目或者某个目录进行扫描。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCoA0Mtdf5s5ReYSIQyxYaHbRzibWExPkOv5PkXcsIUaic3BXQjf1B8RSg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

插件扫描后，会将一些不合手册上面的代码按照 Blocker/Critical/Major 三个等级显示出来，点击某个修改建议可以直接跳转到对应的代码处，这样的话，修改起来就非常便捷了。

### 03、SonarLint

SonarLint 可让我们在编写代码的时候就对错误和漏洞进行修复，像拼写检查器一样，可以即时突出地显示出编码中的一些问题，并提供清晰的补救指导，方便我们在提交代码之前就解决它们。

SonarLint 支持很多种语言，包括 Java、Kotlin、JavaScript、Ruby、Python、PHP 等等。也支持很多种 IDE，包括 Eclipse、Intellij IDEA、Visual Studio、VS Code 等等。

Intellij IDEA 可以在插件市场直接安装。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCpM1JEsBCpUCDg9Q7gkGqIwSzz8yQ7f59k8BIB7AlbxgLRaDzugg0YQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

SonarLint 默认也是开启实时检查的，当我们在声明 List 的时候没有使用泛型，它不仅指出了问题，还给出了修改建议，甚至示例都写好了，真贴心。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfCW93BkGa4lLpFR6OvNyia9ibbtGfUzqYDiaEJZ9xOE7KB43GTWwdwfvvhg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

### 04、总结

好的编程规范有助于写出易于阅读、质量更高、错误更少、更易于维护的程序。CheckStyle、Alibaba Java 代码规范、SonarLint 这 3 款 Intellij IDEA 插件能在很大程度上帮助我们达到这个目的。

另外，如果你在 Intellij IDEA 插件市场中下载这 3 款插件的时候速度比较慢的话，可以通过下面的方式进行下载，我已经贴心地替你打包好了。

> 链接:https://pan.baidu.com/s/1W9AsoLrBJTEtE9JTJlqNXw  密码:pa92

下载完成后，可以在 Intellij IDEA 的插件市场选择本地路径的方式进行安装。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfC2bxuIY8iaRSrGdJzic2aH0ZFPN5ZTpQ3lMrPqxuYJ7FxN59YfoAGqMgw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

直接选择对应的 zip 包就可以安装了。

![img](https://mmbiz.qpic.cn/mmbiz_png/z40lCFUAHplicvYCfNEuFZJdXM1x0VKfC5T1LuNKyAjeyfwtDfrcCjiaZibPL6UTmZMgrUXtTaWYj1iaHRLp13icJNw/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

希望能对小伙伴们有所帮助，尽快安排一下吧，从此 bug 离我们远一点，少一点。