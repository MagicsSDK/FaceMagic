//
//  Camera.h
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/15.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol CameraDelegate<NSObject>
@optional
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;
@end
@interface Camera : NSObject
@property(weak,nonatomic)id<CameraDelegate> delegate;
@property(nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property(nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;
- (void)changeCamera;
- (void)startCapture;
- (void)stopCapture;
@end
