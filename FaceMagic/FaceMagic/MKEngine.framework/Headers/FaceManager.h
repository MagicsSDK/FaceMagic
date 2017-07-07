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

//#include "../library/fp/MG_Common.h"
//#import "MG_Facepp.h"
//#import "MG_Common.h"

#define YINGKERESID_EYEEFFECT 100
#define YINGKERESID_SHOULIANEFFECT 101
#define YINGKERESTYPE_EYEEFFECT 10
#define YINGKERESTYPE_SHOULIANEFFECT 11
//配置文件事件名
#define CONFIGFILESACTION   @"ConfigFilesAction"
//SDK识别事件名
#define PERSONACTION        @"PersonAction"
//音效事件名
#define AUDIOACTION        @"audioAction"
//特效包结束事件名
#define EFFECTACTION        @"effectAction"
//特效包解析错误
#define EFFECTFILE        @"effectFile"
//触摸回调
#define TOUCHACTION       @"touchAction"

/**
 * @brief 坐标点类型
 *
 * 表示一个二维平面上的坐标（笛卡尔坐标系）。
 */
typedef struct {
    float x;                ///< 坐标点x轴的值
    
    float y;                ///< 坐标点y轴的值
} Magic_POINT;

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
 *  @brief 初始化资源
 */
- (void)initContext;
- (void)releaseContext;
- (EAGLContext *)getContext;
- (int)processSampleBuffer:(LPYUVFrame)yuvData processFaceNum:(MInt32)nFaceCountInOut facePoints:(MPOINT *)pFaceOutlinePointOut faceRect:(MRECT *)rcFaceRectOut faceOrient:(MFloat *)faceOrientOut;

- (int)LG_processSampleBuffer:(LPYUVFrame)yuvData processFaceNum:(MInt32)nFaceCountInOut facePoints:(Magic_POINT *)pFaceOutlinePointOut faceRect:(MRECT *)rcFaceRectOut faceOrient:(MFloat *)faceOrientOut;

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
- (void)setOutputMirroredFrameData:(LPYUVFrame)mirroredFrame;
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
