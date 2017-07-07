//
//  MagicSkinSoftenEngine.h
//  MagicSkinSoften
//
//  Created by 村长在开会～ on 2017/5/20.
//  Copyright © 2017年 村长在开会～. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

// Tips: 本引擎依赖 AVFoundation.framework 以及 CoreMedia.framework


// 用于控制输出帧数据格式的枚举
typedef enum
{
    MGSkinPixelFormatRGBA = 0,              // 输出 kCVPixelFormatType_32BGRA 格式的 PixelBuffer, 内部数据为 RGBA
    MGSkinPixelFormatBGRA,                  // 输出 kCVPixelFormatType_32BGRA 格式的 PixelBuffer, 内部数据为 BGRA
    MGSkinPixelFormatYUV420                 // 输出 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, 内部数据为 YUV420
} MGSkinPixelFormat;


// 用于控制输出旋转方向的枚举
typedef enum
{
    MGSkinGOrientationNormal = 0,           // 原样输出
    MGSkinOrientationRightRotate90,        // 右旋90度输出（注意改变输出宽高）
    MGSkinOrientationRightRotate180,       // 右旋180度输出
    MGSkinOrientationRightRotate270,       // 右旋270度输出（注意改变输出宽高）
    MGSkinOrientationFlippedMirrored,      // 翻转并镜像输出
    MGSkinOrientationFlipped,              // 上下翻转输出
    MGSkinOrientationMirrored              // 左右镜像输出
} MGSkinOrientation;



// 美肤结果输出委托，当美肤完成时，引擎会回调此委托，传入美肤结果
@protocol MGSkinPrettifyDelegate <NSObject>

- (void) MGSkinPrettifyResultOutput:(CVPixelBufferRef)pixelBuffer;

@end


@interface MagicSkinSoftenEngine : NSObject

/*
 描述：初始化引擎
 返回值：成功返回 YES，失败或已经初始化过返回 NO
 参数：无
 */
- (BOOL) InitEngine;

/*
 描述：根据所设置的参数，运行引擎
 返回值：成功返回 YES, 失败返回 NO
 参数：无
 */
- (BOOL) RunEngine;

/*
 描述：销毁引擎
 返回值：无
 参数：无
 */
- (void) DestroyEngine;

/*
 描述：设置输入帧
 返回值：无
 参数：pInputPixel - 相机回调所给的预览帧，sFaceRect - 帧所对应的人脸信息，用于人形虚化及基准肤色计算，若没有人脸则置为(0,0,0,0)，此时会对全图进行美肤，并关闭人形虚化
 */
- (void) SetInputFrameByCVImage:(CVPixelBufferRef)pInputPixel FaceRect:(CGRect)sFaceRect;

/*
 描述：设置一个方向，用于校正输入的预览帧
 返回值：无
 参数：eAdjustInputOrient - 方向值
 */
- (void) SetOrientForAdjustInput:(MGSkinOrientation)eAdjustInputOrient;

/*
 描述：设置一个尺寸，用于调整输入帧的宽高，也是最终输出帧的宽高
 返回值：无
 参数：sSize - 宽和高
 */
- (void) SetSizeForAdjustInput:(CGSize)sSize;

/*
 描述：设置美肤步骤中磨皮的强度
 返回值：无
 参数：iSoftenStrength - 磨皮强度，范围 0 - 100
 */
- (void) SetSkinSoftenStrength:(int)iSoftenStrength;

/*
 描述：设置人形虚化的强度
 返回值：无
 参数：iBlurStrength - 虚化强度，范围 0 - 100，videoOrientation 当前相机的预览方向
 */
- (void) SetPortraitBlurStrength:(int)iBlurStrength VideoOrient:(AVCaptureVideoOrientation)videoOrientation;

/*
 描述：设置美肤步骤中的肤色调整参数
 返回值：无
 参数：fPinking - 粉嫩程度， fWhitening - 白晰程度，fRedden - 红润程度，范围都是0.0 - 1.0
 */
- (void) SetSkinColor:(float)fPinking Whitening:(float)fWhitening Redden:(float)fRedden;

/*
 描述：设置美肤结果的输出方向
 返回值：无
 参数：eOutputOrientation - 方向值
 */
- (void) SetOutputOrientation:(MGSkinOrientation)eOutputOrientation;

/*
 描述：设置美肤结果的输出格式
 返回值：无
 参数：eOutFormat - 输出的色彩格式
 */
- (void) SetOutputFormat:(MGSkinPixelFormat)eOutFormat;

/*
 描述：设置美肤结果的输出回调
 返回值：无
 参数：outputCallback - 委托
 */
- (void) SetSkinPrettifyResultDelegate:(id <MGSkinPrettifyDelegate>)outputCallback;

/*
 描述：主动获取美肤结果
 返回值：无
 参数：pResultBuffer - 指向 CVPixelBufferRef 的指针
 */
- (void) GetSkinPrettifyResult:(CVPixelBufferRef *)pResultBuffer;

/*
 描述：创建一个预览美肤效果的 View ,返回的 View 会在 DestroyEngine 时销毁，不需要外部销毁
 返回值：所创建的 PGOglView 指针
 参数：View 的尺寸
 */
- (UIView *) MGOglViewCreateWithFrame:(CGRect)sFrame;

/*
 描述：将美肤结果刷新到 PGOglView
 返回值：成功返回 YES，引擎未初始化，或 View 未成功创建返回 NO
 参数：View 的尺寸
 */
- (BOOL) MGOglViewPresent;

/*
 描述：将显示内容左右镜像
 返回值：无
 参数：bMirrored - 为YES时显示内容会左右镜像
 */
- (void) MGOglViewMirrored:(BOOL)bMirrored;

/*
 描述：外部更改了 PGOglView 的 Size 后通过调用此方法通知引擎更新 PGOglView 相关的组件
 返回值：无
 参数：无
 */
- (void) MGOglViewSizeChanged;


@end
