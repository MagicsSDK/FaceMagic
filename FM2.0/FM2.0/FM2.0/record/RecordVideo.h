//
//  SaveVideo.h
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/6.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "RecordMedia.h"
#import "VideoRecorder.h"
typedef  void (^VideoRecorderError)(NSError *error);
typedef  void (^VideoRecorderDidStart)();
typedef  void (^VideoRecorderWillStop)();
typedef  void (^VideoRecorderDidStop)();
typedef  void (^SaveVideoResult)(NSString *msg);
@class Camera;
@interface RecordVideo : RecordMedia
@property(copy,nonatomic)VideoRecorderError videoRecorderError;
@property(copy,nonatomic)VideoRecorderDidStart videoRecorderDidStart;
@property(copy,nonatomic)VideoRecorderWillStop videoRecorderWillStop;
@property(copy,nonatomic)VideoRecorderDidStop videoRecorderDidStop;
@property(copy,nonatomic)SaveVideoResult  saveVideoResult;
- (void)setVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)setReocrdURL:(NSURL *)url;
- (void)setupWithCameraSite:(Camera *)camera;
- (void)startRecording;
- (void)finishRecording;
@end
