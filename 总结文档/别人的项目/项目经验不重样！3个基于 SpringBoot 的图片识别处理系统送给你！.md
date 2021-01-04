最近看了太多读者小伙伴的简历，发现各种商城/秒杀系统/在线教育系统真的是挺多的。推荐一下昨晚找的几个还不错的基于 Java 的图片识别处理系统。

## 中药图片拍照识别系统

项目地址：https://gitee.com/xiaohaoo/chinese-medicine-identification-admin

### 项目简介

主要用来对拍摄的中药图片进行识别，系统会给出概率值最高的 10 种中药， 同时主要包含功能还有：中药详细信息查看、中药筛选、中药全文检索、问题社区等。

### 项目后端介绍

本项目后端包含五个模块：

- **admin：** 服务器端。Maven+SpringBoot+MongoDB+Elasticsearch 和 IK 分词器（全文检索）+MySQL+Deeplearning4j（基于 Java 深度学习框架探索）
- **medicine-collection**：爬虫工程，用于爬取中药数据。爬虫框架：WebMagic，数据持久化：MongoDB。
- **image-cnn-model：** 卷积神经网络工程 。Python+TensorFlow（深度学习框架）
- **util：**抽离的项目公用工具类
- **datasets：**数据集

![img](https://mmbiz.qpic.cn/mmbiz_png/iaIdQfEric9Ty7dfc677cqgJm40n0sVQf0PRTESR7BXZpp3VUatVR8jUmfI34BrLvGCFhwbfibLfEeKZ6brof2vZg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

### 效果预览

![img](https://mmbiz.qpic.cn/mmbiz_png/iaIdQfEric9Ty7dfc677cqgJm40n0sVQf0icPiaOqqHOZpFzWINgBZ9e0vxrJ8tmrZga9r9dTLZXvV9OPOx4W3uZIA/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)image-20200805083034969

### 依赖环境说明

| 依赖                 | 版本        |
| :------------------- | :---------- |
| JDK                  | 8+          |
| Python               | 3.6         |
| Maven                | 3.0+        |
| TensorFlow           | 2.0         |
| mongoDB              | 4.2.2       |
| mongo-java-driver    | 3.12        |
| MySQL                | 8.0+        |
| Spring Boot          | 2.2.2       |
| Elasticsearch        | 7.4.2       |
| IK 分词器            | 7.4.2       |
| deeplearning4j       | 1.0.0-beta6 |
| nd4j-native-platform |             |

## 身份证号码识别系统

项目地址：https://gitee.com/endlesshh/idCardCv 。

### 项目简介

1. 本项目是一个基于 java 和 opencv 开发, 整合 tess4j,不需要经过训练直接使用的身份证识别系统。如果想训练，请学习一下源码，或者到我参考前作者的https://gitee.com/nbsl/idCardCv 项目里看一看。
2. 项目部署在 SpringBoot 应用程序项目上来展示（*简单看了下 SpringBoot 项目后端代码，写的很烂，哈哈，可以自行优化*）。
3. 在图片清晰情况下，号码检测与识别准确率在 90%以上。

### 效果预览

![img](https://mmbiz.qpic.cn/mmbiz_png/iaIdQfEric9Ty7dfc677cqgJm40n0sVQf0rwWh4U2Z9D481ns04iaZqxMSBzlt8SkQRciaF6oZrBZEjuj4TwZ25KtQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

### 依赖环境说明

| 依赖      | 版本  |
| :-------- | :---- |
| JDK       | 8+    |
| opencv    | 4.3   |
| tess4j    | 4.5.1 |
| tesseract | 4.0.0 |

## 车牌识别系统

项目地址：https://gitee.com/admin_yu/yx-image-recognition 。

### 项目简介

yx-image-recognition 是一款基于 spring boot +opencv+ maven 实现的车牌识别及训练系统。

这是一个**入门级的基于 java 语言的深度学习项目**，本人目前也正在学习图片识别相关技术；大牛请绕路

当前已经添加基于 svm 算法的车牌检测训练、以及基于 ann 算法的车牌号码识别训练功能。后续会逐步加入证件识别、人脸识别等功能

目前已经实现下面这些功能:

- **黄蓝绿车牌检测及车牌号码识别**
- **单张图片、多张图片并发、单图片多车牌检测及识别**
- **图片车牌检测训练**
- **图片文字识别训练**

### 效果预览

![img](https://mmbiz.qpic.cn/mmbiz_png/iaIdQfEric9Ty7dfc677cqgJm40n0sVQf0d9r5I6La5JjvwFsQiaDBXm1ia4yjFrj49t4WuHEene5g4yh9Td6R4eLQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)

### 依赖环境说明

| 依赖            | 版本          |
| :-------------- | :------------ |
| jdk             | 1.8.61+       |
| maven           | 3.0+          |
| opencv          | 4.0.1         |
| javacpp1        | 4.4           |
| opencv-platform | 4.0.1-1.4.4   |
| spring boot     | 2.1.5.RELEASE |