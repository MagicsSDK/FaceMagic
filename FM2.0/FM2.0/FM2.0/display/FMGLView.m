//
//  FMGLView.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/3.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "FMGLView.h"
@interface FMGLView()<GLKViewDelegate>
{
    GLKView *m_glkView;
}
@end
@implementation FMGLView
- (id)initilizeGLKViewWidth:(int)width height:(int)heigth context:(EAGLContext *)context{
    m_glkView = [[GLKView alloc]initWithFrame:CGRectMake(0, 0, width, heigth) context:context];
    [m_glkView setDelegate:self];
    [m_glkView setDrawableColorFormat:GLKViewDrawableColorFormatRGBA8888];
    m_glkView.opaque = NO;
    [m_glkView setEnableSetNeedsDisplay:NO];
    return m_glkView;
}

- (GLKView *)getGLKView{
    return m_glkView;
}

- (void)display{
    [m_glkView display];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    if (self.fmGLKViewRender) {
        self.fmGLKViewRender();
    }
}
@end
