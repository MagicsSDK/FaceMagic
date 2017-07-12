//
//  SV.h
//
//  Created by 李晓帆 on 2017/6/7.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#define SCENENAME @"videoscene"

@class SVThreadQueue;
@class SVGLView;
@interface SV : NSObject

//创建引擎
- (void)createEngine:(int)_version Context:(EAGLContext*)_context;
//销毁引擎
- (void)destroyEngine;
//设置资源路径
- (void)addResPath:(NSString*)_path;
//开启引擎
- (void)startEngine;
//关闭引擎
- (void)stopEngine;
//创建场景
- (int)createScene:(id)glkView;
//设置模板
- (void)setTemplate:(NSString *)_path;
//刷新演员
-(void)refreshActor;
//增加演员
-(void)addActor:(NSString *)_path;
//删除演员
-(void)delActorByName:(NSString *)_path;
-(void)delActorByIndex:(int)_index;
//清空演员
-(void)clearActor;
//设置背景音乐
-(void)setBGMusic:(NSString *)_path;
//清空背景音乐
-(void)clearBGMusic;
//保存视频
-(void)saveVideo:(NSString*)_name;
//保存编辑配置
-(void)saveEditConfig:(NSString*)_name;
//设置输出的视频文件地址
-(void)setOutputVideoFilePath:(NSString *)_fileName;
- (void)setAudioFilePath:(NSString *)_fileName;
//
//- (int)initialize;
//- (void)loadConfig;
//- (void)loadVideo:(NSString *)path;
- (EAGLContext *)getContext;
//
- (SVThreadQueue*)getThreadQuene;
//
-(SVGLView*)getGLView;
//更新
-(void)update;
//渲染
-(void)render;
//- (int)setGLKView:(id)glkView;
//- (GLKView *)getGLKView;
//- (void)removeGLKView;
//- (void)destory;
@end
