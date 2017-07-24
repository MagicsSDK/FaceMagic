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
#import "MagicDef.h"


@interface FM2 : NSObject

/**
 *  @bref 初始化
 *
 *  @param _context 不使用可传nil
 *  @param _version 2
 */
- (void)fm2Init:(EAGLContext*)_context Version:(int)_version;

/**
 *  @bref 获取上下文
 *
 */
- (EAGLContext *)getContext;

/**
 *  @bref 析构引擎
 *
 */
- (void)fm2Destroy;

/**
 *  @bref 增加资源搜索路径
 *
 *  @param _path 本地资源路径
 */
- (void)addSearchPath:(NSString *)_path;

/**
 *  @bref 开启引擎
 *
 *  @param datatype 人脸识别库类型
 */

- (void)startEngine:(FMDetectType)datatype;

/**
 *  @bref 停止引擎
 *
 */
- (void)stopEngine;

/**
 *  @bref 是否开启引擎
 *
 *  @param enable YES or NO
 */
- (void)enableDDrawMode:(bool)enable;

/**
 *  @bref 创建场景
 *
 *  @param _name 场景名字
 *  @param _w 视图宽
 *  @param _h 视图高
 */
- (void)createScene:(NSString*)_name  Width:(int)_w Height:(int)_h Mirrored:(bool)_mirrored;

/**
 @bref 创建场景

 @param _name 场景名字
 @param _sceneWidth 场景宽
 @param _sceneHeight 场景高
 @param _videoWidth 视图宽
 @param _videoHeight 视图高
 */
- (void)createScene:(NSString*)_name sceneWidth:(int)_sceneWidth sceneHeight:(int)_sceneHeight videoWidth:(int)_videoWidth videoHeight:(int)_videoHeight mirrored:(bool)_mirrored;
/**
 *  @bref 设置输入流格式
 *
 *  @param inputFormat 视频流输入格式 fm2PixelFormat
 *  @param _w 分辨率宽
 *  @param _h 分辨率高
 *  @param _angle 视频流旋转角度
 *  @param _name 场景名字
 */
- (void)setInputFormat:(FMPixelFormat)inputFormat Width:(int)_w Height:(int)_h Angle:(float)_angle Name:(NSString*)_name;

/**
 *  @bref 设置输出流格式
 *
 *  @param outputFormat 视频流输出格式 fm2PixelFormat
 *  @param _name 场景名字
 */
- (void)setOutputFormat:(FMPixelFormat)outputFormat Name:(NSString*)_name;

/**
 @bref 开启pixelbuffer输出
 */
- (void)enableOutputPixelBuffer;

/**
 @bref 输出结果到pixelbuffer
 */
- (void)renderToPixelBuffer;

/**
 @bref 得到最终渲染结果数据
 
 @return CVPixelBufferRef
 */
- (CVPixelBufferRef)getPixelBuffer;

/**
 *  @bref 推送输入视频流
 *
 *  @param _pdata 视频流
 *  @param _name 场景名字
 */
- (void)pushCameraImage:(uint8_t*)_pdata Name:(NSString*)_name WithHandle:(dispatch_semaphore_t)sem;

/**
 *  @brief 虹软 人脸识别数据输入输出接口
 *
 *  @param nFaceCountInOut 人脸个数
 *  @param pFaceOutlinePointOut 脸部点位
 *  @param rcFaceRectOut 脸的轮廓(top left bottom right)
 *  @param faceOrientOut 头部信息(roll,yaw,pitch)
 *  @param _name 场景名字
 */
-(void)pushDetectDataAS:(MGInt32)nFaceCountInOut facePoints:(MGINTPOINT *)pFaceOutlinePointOut faceRect:(MGRECT *)rcFaceRectOut faceOrient:(MGFloat *)faceOrientOut Name:(NSString*)_name;

/**
 *  @brief Face ++ 人脸识别数据输入输出接口
 *
 *  @param nFaceCountInOut 人脸个数
 *  @param pFaceOutlinePointOut 脸部点位
 *  @param rcFaceRectOut 脸的轮廓(top left bottom right)
 *  @param faceOrientOut 头部信息(roll,yaw,pitch)
 *  @param _name 场景名字
 */
-(void)pushDetectDataFP:(MGInt32)nFaceCountInOut facePoints:(MGFLOATPOINT *)pFaceOutlinePointOut faceRect:(MGRECT *)rcFaceRectOut faceOrient:(MGFloat *)faceOrientOut Name:(NSString*)_name;


/**
 *  @brief Magic Detect 人脸识别数据输入输出接口
 *
 *  @param nFaceCountInOut 人脸个数
 *  @param pFaceOutlinePointOut 脸部点位
 *  @param rcFaceRectOut 脸的轮廓(top left bottom right)
 *  @param faceOrientOut 头部信息(roll,yaw,pitch)
 *  @param _name 场景名字
 */
-(void)pushDetectDataMA:(MGInt32)nFaceCountInOut facePoints:(MGFLOATPOINT *)pFaceOutlinePointOut faceRect:(MGRECT *)rcFaceRectOut faceOrient:(MGFloat *)faceOrientOut Name:(NSString*)_name;



/**
 *  @brief 陀螺仪数据
 *
 *  @param x  x
 *  @param y  y
 *  @param z  z
 */
- (void)updateGyroDataX:(float)x Y:(float)y Z:(float)z;

/**
 *  @brief 大小眼数据
 *
 *  @param intentity  值
 */
- (void)updateIntensity:(float)intentity Name:(NSString*)_name;

/**
 *  @brief 瘦脸数据
 *
 *  @param value  值
 */
- (void)updateSlimStrenrth:(float)value Name:(NSString*)_name;

/** 暂未开放 **/
//推送识别数据
-(void)pushDetectDataFPP:(void*)_datastream Name:(NSString*)_name;

//推送识别数据
-(void)pushDetectDataST:(void*)_datastream Name:(NSString*)_name;

//推送识别数据
-(void)pushDetectData:(void*)_datastream Name:(NSString*)_name Type:(int)_type;
/** 暂未开放 **/

/**
 *  @brief 设置特效
 *
 *  returns YES or NO 成功或失败
 *  @param effectPath 特效目录，该目录包含配置，图片等所有跟该特效相关的资源。
 *  @param _name      场景名字
 */
- (BOOL)setEffect:(NSString *)effectPath Name:(NSString*)_name;

/**
 *  @brief 设置单个特效
 *
 *  returns YES or NO 成功或失败
 *  @param effectPath 特效目录，该目录包含配置，图片等所有跟该特效相关的资源。
 *  @param resID 特效编号
 *  @param resType 特效类型
 *  @param _name      场景名字
 */
- (BOOL)setEffect:(NSString *)effectPath resID:(int)resID resType:(int)resType Name:(NSString*)_name;

/**
 *  @brief 清理特效
 *
 *  @param _name      场景名字
 */
- (void)clearEffectName:(NSString*)_name;
/**
 *  @brief 清理单个特效
 *
 *  @param resID 特效编号
 *  @param _name      场景名字
 */
- (void)clearEffectResID:(int)resID Name:(NSString*)_name;

/**
 * @bref 仅供显示的时候使用
 *
 * @param _w 主场景宽
 * @param _h 主场景高
 * @param _name 场景名字
 */
- (void)drawTestWidth:(int)_w Height:(int)_h Name:(NSString*)_name;

- (CMSampleBufferRef)getRenderBufferWithName:(NSString *)name andBuffer:(CMSampleBufferRef)buf;
- (void)getYUVDataWithName1:(NSString *)name andBuffer:(void *)buf;

/**
 @bref 传入传感器参数
 
 @param x x方向
 @param y y方向
 @param z z方向
 */
- (void)updateGyroDataX:(float)x Y:(float)y Z:(float)z;
@end
