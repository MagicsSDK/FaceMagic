//
//  FMScreenRender.h
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/15.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/glext.h>
@interface FMTextureRender : NSObject
+ (instancetype)shareInst;
- (void)destory;
- (void)render;
- (void)reDraw;
- (void)subImageData;
- (void)initialize;
- (int)getTexture;
@end
