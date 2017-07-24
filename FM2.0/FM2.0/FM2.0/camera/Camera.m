//
//  Camera.m
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/15.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#import "Camera.h"
@interface Camera()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>{
    NSLock *lock;
    dispatch_queue_t openGLConcurrentQueue;
    bool    pauseCamera;
}
@property(nonatomic, strong) AVCaptureDevice *backCameraDevice;
@property(nonatomic, strong) AVCaptureDevice *frontCameraDevcie;
@property(nonatomic, strong) AVCaptureDevice *currentCameraDevcie;
@property(nonatomic, strong) AVCaptureSession *captureSession;
@property(nonatomic, strong) dispatch_queue_t sessionQueue;
@property(nonatomic, strong) CIContext *ciContext;
@property(nonatomic, strong) dispatch_queue_t videoQueue;
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong) AVCaptureDeviceInput *currentCameraInput;
@property(nonatomic, strong) AVAssetWriter *videoWriter;
@property(nonatomic, strong) AVAssetWriterInput *videoWriterInput;
@property (nonatomic,assign)int isMirrored;
@end

@implementation Camera
- (instancetype)init {
    self = [super init];
    if (self) {
        pauseCamera = false;
        [self initializeCamera];
    }
    return self;
}
- (void)initializeCamera {
    lock = [[NSLock alloc]init];
    openGLConcurrentQueue = dispatch_queue_create("my.fm2.queue", DISPATCH_QUEUE_SERIAL);
    self.videoQueue = dispatch_queue_create("sample buffer delegate", DISPATCH_QUEUE_SERIAL);
    
    NSError *error;
    self.captureSession = [[AVCaptureSession alloc] init];
    
    for(AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if(device.position == AVCaptureDevicePositionBack) {
            self.backCameraDevice = device;
        } else if(device.position == AVCaptureDevicePositionFront) {
            self.frontCameraDevcie = device;
        }
        
        [device lockForConfiguration:&error];
        //[self.captureSession beginConfiguration];
        device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        //device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        [device unlockForConfiguration];
        //[self.captureSession commitConfiguration];
    }
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.frontCameraDevcie error:&error];
    self.currentCameraInput = input;
    
    if([self.captureSession canAddInput:input]) {
        [self.captureSession addInput:input];
    }
    self.currentCameraDevcie = self.frontCameraDevcie;
    
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    [self.videoOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey]]; // kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
    [self.videoOutput setSampleBufferDelegate:self queue:self.videoQueue];
    if([self.captureSession canAddOutput:self.videoOutput]) {
        [self.captureSession addOutput:self.videoOutput];
    }
    
    self.captureSession.sessionPreset = AVCaptureSessionPresetiFrame1280x720;//AVCaptureSessionPresetPhoto;//AVCaptureSessionPresetiFrame1280x720;//AVCaptureSessionPresetPhoto; //
    
    AVCaptureConnection *captureConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([captureConnection isVideoOrientationSupported])
    {
        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;
        [captureConnection setVideoOrientation:orientation];
        [captureConnection setVideoMirrored:YES];
    }
    [self setFrameRate:25];
    [self.captureSession commitConfiguration];
    
    
}
//设置相机采集帧率
-(void) setFrameRate:(int)rate;
{
    
    
    
    if ([self.currentCameraDevcie respondsToSelector:@selector(activeVideoMinFrameDuration)]) {
        [self.currentCameraDevcie lockForConfiguration:nil];
        self.currentCameraDevcie.activeVideoMinFrameDuration = CMTimeMake(1, rate);
        self.currentCameraDevcie.activeVideoMaxFrameDuration = CMTimeMake(1, rate);
        [self.currentCameraDevcie unlockForConfiguration];
        
    }else{
        AVCaptureConnection *conn = [[_captureSession.outputs lastObject] connectionWithMediaType:AVMediaTypeVideo];
        if (conn.supportsVideoMinFrameDuration)
            conn.videoMinFrameDuration = CMTimeMake(1,rate);
        if (conn.supportsVideoMaxFrameDuration)
            conn.videoMaxFrameDuration = CMTimeMake(1,rate);
        
    }
}

- (void)startCapture {
    dispatch_queue_t sessionQueue = dispatch_queue_create("com.example.camera.capture_session", DISPATCH_QUEUE_SERIAL);
    self.sessionQueue = sessionQueue;
        dispatch_async(sessionQueue, ^(void) {
            [self.captureSession startRunning];
        });
}

- (void)stopCapture {

    dispatch_async(self.sessionQueue, ^(void) {
        [self.captureSession stopRunning];
    });
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if(captureOutput == self.videoOutput) {
        if (!pauseCamera) {
            if ([self.delegate respondsToSelector:@selector(captureOutput:didOutputSampleBuffer:fromConnection:)]) {
                [self.delegate captureOutput:captureOutput didOutputSampleBuffer:sampleBuffer fromConnection:connection];
            }
        }
        
        
    }
}

- (UIImage *)rgbPixelBufferToImage:(unsigned char *)rgbBuffer W:(int)w H:(int)h
{
    
    NSDictionary *pixelAttributes = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
    
    CVPixelBufferRef pixelBuffer = NULL;
    
    CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
                                          w,
                                          h,
                                          kCVPixelFormatType_32BGRA,
                                          (__bridge CFDictionaryRef)(pixelAttributes),
                                          &pixelBuffer);
    
    //    NSDictionary *attrs = @{ (NSString*)kCVPixelBufferIOSurfacePropertiesKey : @{},
    //                             (NSString*)kCVPixelBufferOpenGLESCompatibilityKey: @YES};
    
    
    CVPixelBufferLockBaseAddress(pixelBuffer,0);
    unsigned char *destPlane = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
    memcpy(destPlane, rgbBuffer, w * h*4);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    if (result != kCVReturnSuccess) {
        NSLog(@"Unable to create cvpixelbuffer %d", result);
    }
    CIImage *coreImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];//CIImage Conversion DONE!!!!
    
    CIContext *MytemporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef MyvideoImage = [MytemporaryContext
                               createCGImage:coreImage
                               fromRect:CGRectMake(0, 0,
                                                   w,
                                                   h)];
    
    UIImage *Mynnnimage = [[UIImage alloc] initWithCGImage:MyvideoImage scale:1.0 orientation:UIImageOrientationUp];//UIImage Conversion DONE!!!
    CVPixelBufferRelease(pixelBuffer);
    CGImageRelease(MyvideoImage);
    
    
    return Mynnnimage;
}

#pragma mark - camera control
- (void)changeCamera
{
    dispatch_async(self.sessionQueue, ^(void) {
        pauseCamera = true;
        if(self.currentCameraDevcie == self.frontCameraDevcie) {
            
            NSError *error;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.backCameraDevice error:&error];
            [self.captureSession removeInput:self.currentCameraInput];
            
            if([self.captureSession canAddInput:input]) {
                [self.captureSession addInput:input];
                self.currentCameraInput = input;
                
                self.currentCameraDevcie = self.backCameraDevice;
            }
            self.isMirrored = NO;
        } else {
            NSError *error;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.frontCameraDevcie error:&error];
            [self.captureSession removeInput:self.currentCameraInput];
            
            if([self.captureSession canAddInput:input]) {
                [self.captureSession addInput:input];
                self.currentCameraInput = input;
                
                self.currentCameraDevcie = self.frontCameraDevcie;
            }
            self.isMirrored = YES;
        }
        
        AVCaptureConnection *captureConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoOrientationSupported])
        {
            AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;
            [captureConnection setVideoOrientation:orientation];
            [captureConnection setVideoMirrored:self.isMirrored];
        }
        pauseCamera = false;
    });
}
@end
