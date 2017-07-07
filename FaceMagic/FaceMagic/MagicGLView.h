//
//  MagicGLView.h
//  FaceMagic
//
//  Created by 付一洲 on 16/7/27.
//  Copyright © 2016年 appmagics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface MagicGLView :  NSObject<GLKViewDelegate>

- (id)initWithGLKView:(GLKView*)glkView;
- (void)setup;
- (void)setGlkView:(GLKView *)glkView;
- (void)dealloc;
- (void)_fitViewWithRatio:(CGRect)rect;
- (void)clear;

@end
