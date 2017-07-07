# FaceMagic
    FaceMaigcSDK旨在提供简单易用，功能强大，平台通用的视觉服务，让广大的移动开发者可以轻松使用最前沿的计算机视觉技术，从而搭建个性化的视觉应用。

## 开发人员受众

FaceMagicSDK主要供以下开发人员使用

1 需要脸部识别数据应用程序开发人员。

2 需要在移动应用中视频中叠加各种炫酷特效的开发人员。

3 仅需要炫酷视频特效的开发人员。

## 运行时要求

设备系统必须IOS8及以上。

## 关于FaceMagicSDK

FaceMagicSDK是北京迈吉客科技公司旗下的新型视觉服务平台，旨在提供简单易用、功能强大、平台兼容的新一代视觉服务。

FaceMagic团队致力于将最新、性能最好、使用最方便的脸部识别技术和丰富炫酷特效商店提供给广大移动开发者和用户

## FaceMagic SDK 快速入门

### `第一步` 将下载的SDK解压后导入到您的工程中，见下图
 ![image](https://github.com/MagicsSDK/FaceMagic/tree/master/img_folder/图片1.png)

### `第二步` 配置工程属性

#### `2.1` 向Build Phases → Link Binary With Libraries 中添加依赖库，见下图(注意FaceMagicDetection.framework需放在最后)
![image](https://github.com/MagicsSDK/FaceMagic/tree/master/img_folder/屏幕2.png)

`2.2` 导入资源文件 track_data.data/res.bundle 
![image](https://github.com/MagicsSDK/FaceMagic/tree/master/img_folder/屏幕3.png)
![image](https://github.com/MagicsSDK/FaceMagic/tree/master/img_folder/屏幕4.png)

`2.3` SDK不支持bitcode
向Build Settings → Linking → Enable Bitcode中设置NO。
