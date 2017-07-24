//
//  FaceManager.h
//  FaceMagic
//
//  Created by 刘铭 on 16/7/8.
//  Copyright © 2016年 刘铭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "amcomdef.h"
#import "MagicDef.h"
#import "FaceMagicCommon.h"
//短视频场景
#define S_YINGKEVIDEOSCENE  @"yingkevideo"
//礼物场景
#define S_YINGKEVIEWSCENE   @"yingkeview"
//
#define max_face_count = 4;
//短视频动效的ID和Type
#define S_YINGKEVIDEOSCENE_RESID  230
#define S_YINGKEVIDEOSCENE_RESTYPE  1
//礼物动效的ID和Type
#define S_YINGKEVIEWSCENE_RESID  231
#define S_YINGKEVIEWSCENE_RESTYPE  2
//大眼睛动效的ID和Type
#define YINGKERESID_EYEEFFECT 100
#define YINGKERESTYPE_EYEEFFECT 10
//瘦脸动效的ID和Type
#define YINGKERESID_SHOULIANEFFECT 101
#define YINGKERESTYPE_SHOULIANEFFECT 11
//配置文件中需显示的文字
#define CONFIGFILESACTION   @"ConfigFilesAction"
//人的动作
#define PERSONACTION        @"PersonAction"
//音效事件名
#define AUDIOACTION        @"audioAction"
//特效包结束事件名
#define EFFECTACTION        @"effectAction"
//特效包解析结果
#define EFFECTFILE        @"effectFile"
//触摸回调
#define TOUCHACTION       @"touchAction"
//传感器
#define EFFECTSENSOR      @"sensorActive"

@interface FaceManager : NSObject

/**
 *  Creates and returns an `FaceManager` object.
 */
+ (instancetype)sharedInstance;

/**
 @bref 初始化默认FaceMagic
 */
- (void)maininit;

/**
 @bref 创建上下文和渲染场景
 */
- (void)initContext;

/**
 @bref 创建上下文和渲染场景

 @param context 外部 EAGLContext
 @param textureID 外部 texture
 */
- (void)initContext:(EAGLContext *)context textrueID:(unsigned int)textureID;

/**
 @bref 设置输出的纹理

 @param textureID 纹理
 @param width     纹理宽
 @param height    纹理高
 */
- (void)setOutputTexture:(unsigned int)textureID width:(int)width height:(int)height;

/**
 @bref  设置输入的背景纹理

 @param textureID 纹理
 @param width 纹理宽
 @param height 纹理高
 */
- (void)setBackgroundTexture:(unsigned int)textureID width:(int)width height:(int)height;

/**
 @bref 释放FaceMagic
 */
- (void)releaseContext;

/**
 @bref 得到渲染上下文
 @return context
 */
- (EAGLContext *)getContext;

/**
 @bref  输入接口
 @return 0  正常运行
 */
- (int)processSampleBuffer:(LPYUVFrame)yuvData processFaceNum:(MInt32)nFaceCountInOut facePoints:(MPOINT *)pFaceOutlinePointOut faceRect:(MRECT *)rcFaceRectOut faceOrient:(MFloat *)faceOrientOut;

/**
 @bref 是否开启pbo  只有在es3.0版本下可用

 @param enable bool
 */
- (void)enablePBO:(bool)enable;

/**
 @bref  构建GL ES 版本

 @param version 2 es2  3 es3  缺省为 es2
 */
- (void)setOpenGLESVersion:(int)version;

/**
 @bref 开启pixelbuffer
 */
- (void)enableOutputPixelBuffer;

/**
 @bref 得到最终渲染结果数据

 @return CVPixelBufferRef
 */
- (CVPixelBufferRef)getPixelBuffer;
/**
 *  @brief 暂停动效库
 *
 */
- (void)suspendRun;
/**
 *  @brief 恢复动效库
 *
 */
- (void)resumeRum;

/**
 @bref 获取FaceManager初始化状态

 @return true 初始化成功  false 初始化失败
 */
- (bool)getContextState;

- (void)drawTestWidth:(int)_w Height:(int)_h;

/**
 @bref 设置数据格式

 @param inputformate 视频数据输出格式
 @param outformate 视频数据输出格式
 @param w 视频数据宽
 @param h 视频数据高
 @param angle 视频数据角度
 */
- (void)setCameraDspInputFormate:(FMPixelFormat)inputformate outFormate:(FMPixelFormat)outformate w:(int)w h:(int)h angle:(float)angle;
/**
 @bref 主场景显示尺寸，仅供显示的时候使用
 
 @param sceneWidth 主场景宽，缺省为750
 @param sceneHeight 主场景高，缺省为1334
 */
- (void)setMainSceneWidth:(int)sceneWidth Height:(int)sceneHeight;

/**
 *  @brief 设置主场景特效
 *
 *  @param effectPath 特效目录，该目录包含配置，图片等所有跟该特效相关的资源。
 *  @param error      error
 */
- (BOOL)setEffect:(NSString *)effectPath error:(NSError **)error;

/**
 @bref 清除特效
 */
- (void)clearEffect;
/**
 *  @brief 设置外部场景特效
 *
 *  @param effectPath 特效目录，该目录包含配置，图片等所有跟该特效相关的资源。
 *  @param error      error
 */
- (BOOL)setOutSceneEffect:(NSString *)effectPath error:(NSError **)error;
/**
 @bref 清除特效
 */
- (void)clearOutSceneEffect;

/**
 *  @brief 设置主场景特效
 *
 *  @param effectPath 特效目录，该目录包含配置，图片等所有跟该特效相关的资源。、
 *  @param resID      特效编号
 *  @param resType    特效类型
 *  @param error      error
 */
- (BOOL)setEffect:(NSString *)effectPath resID:(int)resID resType:(int)resType error:(NSError **)error;
/**
 @bref 清除特效
 */
- (void)clearEffectResID:(int)resID;
/**
 @bref 设置视频流输入格式
 
 @param inputFormat 输入格式
 */
- (void)setInputFormat:(FMPixelFormat)inputFormat;
/**
 @bref 设置视频流输出格式

 @param outputFormat 输出格式
 */
- (void)setOutputFormat:(FMPixelFormat)outputFormat;
/**
 @bref 设置头像
 
 @param headImage 头像图片
 @param imageName 头像图片名称
 */
- (void)setSpineHeadImage:(UIImage *)headImage Name:(NSString *)imageName;
/**
 @bref 设置渲染glkView
 
 @param glkView glkView 一个GLKView 实例
 
 @return return 0 设置成功   return 1设置失败
 
 */

- (int)setGLKView:(id)glkView;

/**
 @bref 调用glkvew display
 */
- (void)glkViewDisplay;

/**
 @bref 移除从sdk中移除glkview
 */
- (void)removeGLKView;
- (GLKView *)getGLKView;

/**
 @bref 开启同时输出非镜像数据

 @param enable bool
 */
- (void)enableOutputNonMirroredData:(bool)enable;

/**
 @bref 输出镜像数据

 @param mirroredFrame 数据格式
 */
- (void)getOutputMirroredFrameData:(LPYUVFrame)mirroredFrame;
/**
 @bref 传入传感器参数

 @param x x方向
 @param y y方向
 @param z z方向
 */
- (void)updateGyroDataX:(float)x Y:(float)y Z:(float)z;
/**
 传入触摸点
 
 @param x x 坐标
 @param y y 坐标
 @param touchState 触摸状态
 FMTOUCHSBEGAN 触摸开始
 FMTOUCHSMOVED 触摸移动
 FMTOUCHSEND   触摸结束
 */
- (void)setTouchPositionX:(float)x Y:(float)y TouchState:(FMTOUCHSTATE)touchState;

/**
 @bref 调整磨皮强度
 
 @param adjust 0~15的float值
 @param curve  0或1的float值 目前只有1根曲线 不同值表不同曲线
 @param resID  特效编号
 */
- (void)setFaceBeautyAdjust:(float)adjust Curve:(float)curve resID:(int)resID;
/**
 @bref 调整肤色
 
 @param adjust 0~1的float值
 @param resID  特效编号
 */
- (void)setFaceBeautyColorAdjust:(float)adjust resID:(int)resID;
/**
 @bref 调整瘦脸强度
 
 @param adjust 0-1的float值
 @param resID  特效编号
 */
- (void)setSlimAdjust:(float)adjust resID:(int)resID;
/**
 @bref 调整短脸强度
 
 @param adjust 0-1的float值
 @param resID  特效编号
 */
- (void)setShortAdjust:(float)adjust resID:(int)resID;
/**
 @bref 调整缩鼻强度
 
 @param adjust 0-1的float值
 @param resID  特效编号
 */
- (void)setShrinkNoseAdjust:(float)adjust resID:(int)resID;
/**
 @bref 调整缩嘴强度
 
 @param adjust 0-1的float值
 @param resID  特效编号
 */
- (void)setShrinkMouthAdjust:(float)adjust resID:(int)resID;
/**
 @bref 调整美颜强度
 
 @param adjust 0~15的float值
 @param curve  0或1的float值 目前只有1根曲线 不同值表不同曲线
 @param resID  特效编号
 */
- (void)setFaceBeautyAdjust:(float)adjust Curve:(float)curve resID:(int)resID;
/**
 @bref 调整瘦脸强度
 
 @param adjust 0-1的float值
 @param resID  特效编号
 */
- (void)setSlimAdjust:(float)adjust resID:(int)resID;
/**
 @bref 调整短脸强度
 
 @param adjust 0-1的float值
 @param resID  特效编号
 */
- (void)setShortAdjust:(float)adjust resID:(int)resID;
/**
 @bref 调整缩鼻强度
 
 @param adjust 0-1的float值
 @param resID  特效编号
 */
- (void)setShrinkNoseAdjust:(float)adjust resID:(int)resID;
/**
 @bref 调整缩嘴强度
 
 @param adjust 0-1的float值
 @param resID  特效编号
 */
- (void)setShrinkMouthAdjust:(float)adjust resID:(int)resID;
/**
 @bref 调整瘦脸强度
 
 @param adjust 0-1的float值
 @param resID  特效编号
 */
- (void)setMorphAdjust:(float)adjust resID:(int)resID;
/**
 @bref  调整放大镜强度
 
 @param intensity 0-1的float值  值越大强度越大
 @param resID     特效编号
 */
- (void)setDistortionIntensity:(float)intensity resID:(int)resID;
@end
