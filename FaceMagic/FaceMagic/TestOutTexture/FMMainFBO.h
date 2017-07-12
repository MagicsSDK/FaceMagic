//
//  FMMainFBO.h
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/15.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface FMMainFBO : NSObject
+ (instancetype)shareInst;
- (void)destory;
- (void)initializeFBOWidth:(int)width Height:(int)height;
- (void)activeContext;
- (void)bindFBO;
- (EAGLContext *)getContext;
- (int)getTexture;
@end
