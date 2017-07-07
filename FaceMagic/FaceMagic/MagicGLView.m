//
//  MagicGLView.m
//  FaceMagic
//
//  Created by 付一洲 on 16/7/27.
//  Copyright © 2016年 appmagics. All rights reserved.
//

#import "MagicGLView.h"
//#import <faceMagic/FaceManager.h>

@interface MagicGLView(){
    GLKView* _glkView;
    bool _shouldResetViewport;
    bool _shouldUpdateViewport;
    bool _firstFrame;
    bool _firstFrameCalled ;
    CGRect _viewArea;
}
@end

@implementation MagicGLView

- (id)initWithGLKView:(GLKView*)glkView
{
    self = [super init];
    [self setup];
    [self setGlkView:glkView];
    return self;
}

- (void)setup
{
    _shouldResetViewport = NO;
    _shouldUpdateViewport = NO;
    _firstFrame = YES;
    _firstFrameCalled = NO;
}

- (void)setGlkView:(GLKView *)glkView
{
//    _glkView = glkView;
//    [_glkView setDelegate:self];
//    [_glkView setDrawableColorFormat:GLKViewDrawableColorFormatRGBA8888];
//    EAGLContext* t_context = [[FaceManager sharedInstance] getContext];
//    [_glkView setContext:t_context];
//    [_glkView setEnableSetNeedsDisplay:NO];
//    [_glkView setBackgroundColor:[UIColor clearColor]];
}

- (void)dealloc
{
    [self clear];
}

- (void)clear
{
}

- (void)_fitViewWithRatio:(CGRect)rect
{
    CGSize sz ;
    sz.width = 720;
    sz.height =1280;
    _viewArea.size.width = 720;
    _viewArea.size.height = 1280;
    _viewArea.origin.x = 0;
    _viewArea.origin.y = 0;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
//    [[FaceManager sharedInstance] lock];
//    float scale = [UIScreen mainScreen].scale;
//    EAGLContext* t_context = [[FaceManager sharedInstance] getContext];
//    if( t_context )
//    {
//        [self _fitViewWithRatio:rect];
//        [[FaceManager sharedInstance] drawTestWidth:rect.size.width*scale Height:rect.size.height*scale InverX:false InverY:false];
//    }
//    [[FaceManager sharedInstance] unlock];
}

@end
