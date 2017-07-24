//
//  FMGLView.h
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/3.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface FMGLView : NSObject
typedef void (^FMGLKViewRender)();
@property(nonatomic,copy)FMGLKViewRender fmGLKViewRender;
- (GLKView *)getGLKView;
- (void)display;
- (id)initilizeGLKViewWidth:(int)width height:(int)heigth context:(EAGLContext *)context;
@end
