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

# 详情文档 请参阅 下方链接

   [文档地址](https://www.gitbook.com/book/appmagics/facemagic-sdk/details) 

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

##

`#import<MKEngine/FaceManager.h>

#import<FaceMagicDetection/MagicDetection.h>

@property(nonatomic, assign) MagicDetection *detection;`

## 初始化人脸识别引擎 FaceMagicDetection

`_detection=[[Detectionalloc]initWithDetectionType:MagicDetectionType];(识别库类型设置)`

## 初始化渲染引擎 FaceManager

`float scale = [UIScreen mainScreen].scale;

mfm2 = [FM2 new];

[mfm2 fm2Init:NULL Version:2];

[mfm2 startEngine:fm2DETECTTYPE];(识别库类型设置)
//[mfm2 enableDDrawMode:true];//用FaceMagic做显示 不获取数据流
[mfm2 enableDDrawMode:false];//不用FaceMagic做显示 获取数据流
[mfm2 createScene:@"fm2" Width:[UIScreen mainScreen].bounds.size.width*scale Height:[UIScreen mainScreen].bounds.size.height*scale];

[mfm2 setInputFormat:fm2PixelFormatYUV420V Width:videoWidth Height:videoHeight Angle:videoAngle Name:@"fm2"];

[mfm2 enableOutputPixelBuffer];`

## 传入相机数据流

`CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);

 GASYUVFrame yuvFrame;
 
 if(CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
 
 {
 
     GASYUVFrame yuvFrame;
     
     size_t width = CVPixelBufferGetWidth(imageBuffer);
     
     size_t height = CVPixelBufferGetHeight(imageBuffer);
     
     if (!isYUVFormat) {
     
         UInt8 *bufferPtr = (UInt8*)CVPixelBufferGetBaseAddress(imageBuffer);
         
         yuvFrame.plane[0] = bufferPtr;
         
         yuvFrame.width = (int32_t)width;
         
         yuvFrame.height = (int32_t)height;
         
         yuvFrame.format = FMPixelFormatBGRA;
         
     }else {
     
         UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
         
         UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,1);
         
         yuvFrame.plane[0] = bufferPtr;
         
         yuvFrame.plane[1] = bufferPtr1;
         
         yuvFrame.width = (int32_t)width;
         
         yuvFrame.height = (int32_t)height;
         
         yuvFrame.format = FMPixelFormatYUV420V;
         
     }
     
     FMDRESULT detectResult = [mDetection processImageFrame:&yuvFrame];
     
     //推送识别结果
     
     [mfm2 pushDetectDataAS:detectResult.fmFaceCount facePoints:detectResult.fmFacePoints faceRect:detectResult.fmFaceRects faceOrient:detectResult.fmFaceOrients Name:@"fm2"];
     //这是3D 特效 调用函数
      if (_sensorActive) {
                CMRotationMatrix deviceRotation = [self getRotationMatrix];
                [mfm2 updateGyroDataX:deviceRotation.m31 Y:deviceRotation.m32 Z:-deviceRotation.m33];
            }
    //推送相机数据流
     
      [mfm2 pushCameraPixelBuffer:imageBuffer Name:@"fm2" WithHandle:nil];
     
     [self.cameraVideoView display];
     
     CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
     
  }`
  
  ## 设置特效
  
  path 的值是特效的本地地址
  
  `[[FaceManager sharedInstance] setEffect:path error:nil];`
  
  ## 停止/销毁识别库和引擎
  
  `
 ## 停止/销毁识别库和引擎
 
 mDetection.canDetect=false;
 
[mDetection destory];

if(mfm2){

[mfm2 fm2Destroy];

}`
  
