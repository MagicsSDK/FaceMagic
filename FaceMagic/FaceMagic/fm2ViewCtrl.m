//
//  ViewController.m
//  GLKCamera
// Identifier -> Framework -> type -> 宏
//  Created by xuye on 4/13/16.
//  Copyright © 2016 appmagics. All rights reserved.
//

#import "fm2ViewCtrl.h"
#import <GLKit/GLKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/PhotosDefines.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <MKEngine/FM2.h>
#import <FaceMagicDetection/FaceMagicDetection.h>

@interface fm2ViewCtrl () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate,AVAudioPlayerDelegate,GLKViewDelegate>{
    FM2*        mfm2;
    float       mVideoAngle;
    int         mVideoWidth;
    int         mVideoHeight;
    NSLock      *mCamlock;
    BOOL        mIsYUVFormat;
    Detection   *mDetection;
    int         mCount;
}

@property(nonatomic, strong) dispatch_queue_t sessionQuene;         //任务队列
@property(nonatomic, strong) AVCaptureDevice *backCameraDevice;
@property(nonatomic, strong) AVCaptureDevice *frontCameraDevcie;
@property(nonatomic, strong) AVCaptureDevice *currentCameraDevcie;
@property(nonatomic, strong) AVCaptureSession *captureSession;
@property(nonatomic, strong) GLKView *cameraVideoView;              //视频流显示glkview
@property(nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property(nonatomic, strong) AVCaptureDeviceInput *currentCameraInput;
@property (nonatomic,assign)int isMirrored;

//@property (nonatomic, strong) MagicBarVC* barVC;

@property (nonatomic, strong) dispatch_semaphore_t frameRenderingSemaphore;


@end

@implementation fm2ViewCtrl

- (void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    mCamlock = [NSLock new];
    //初始化识别模块
    mDetection = [[Detection alloc]initWithDetectionType:DetectionType2];
    //
    mVideoWidth = 720;
    mVideoHeight = 1280;
    mVideoAngle = 0.0f;
    mIsYUVFormat = YES;
    mCount = 0;
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor clearColor];
    //创建和初始化FM2引擎
    [self initFM2];
    //创建GL设备上下文
    [self createGLKView];
    //初始化UI
    [self initUI];
    
}


- (void)initUI {
    //
    UIButton *addEffectVideoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 40, 40)];
    UIImage *t_image = [UIImage imageNamed:@"addEffect"];
    [addEffectVideoBtn setImage:t_image forState:UIControlStateNormal];
    [addEffectVideoBtn addTarget:self action:@selector(addVideoEffect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addEffectVideoBtn];
    //
    UIButton *deleteVideoEffectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-40-60, 80, 40)];
    [deleteVideoEffectBtn setTitle:@"清除动效" forState:UIControlStateNormal];
    [deleteVideoEffectBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deleteVideoEffectBtn addTarget:self action:@selector(deleteVideoEffect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteVideoEffectBtn];
    //
    UIButton *changeCamerabutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [changeCamerabutton setImage:[UIImage imageNamed:@"changeCamera"] forState:UIControlStateNormal];
    [changeCamerabutton addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeCamerabutton];
    changeCamerabutton.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, changeCamerabutton.center.y);
    //
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 40, 40)];
    t_image = [UIImage imageNamed:@"closeCamera"];
    [closeBtn setImage:t_image forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

- (void)initFM2 {
    float scale = [UIScreen mainScreen].scale;
    //创建MF2对象
    mfm2 = [FM2 new];
    //初始化引擎
    [mfm2 fm2Init:NULL Version:2];
    //设置资源路径
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"res" ofType:@"bundle"];
    bundlePath = [NSString stringWithFormat:@"%@/",bundlePath];
    [mfm2 addSearchPath:bundlePath];
    //开启引擎
    [mfm2 startEngine:FMDetectTypeFP];
    //开启直接绘制模式 主要用于测试 便于观察
    [mfm2 enableDDrawMode:true];
    //创建一个场景
    [mfm2 createScene:@"fm2" Width:[UIScreen mainScreen].bounds.size.width*scale Height:[UIScreen mainScreen].bounds.size.height*scale];
    //设置输出流格式
    [mfm2 setInputFormat:FMPixelFormatYUV420V Width:mVideoWidth Height:mVideoHeight Angle:mVideoAngle Name:@"fm2"];
    //设置输出流格式
    [mfm2 setOutputFormat:FMPixelFormatYUV420V Name:@"fm2"];
}

- (void)createGLKView {
    EAGLContext* tGlContext = [mfm2 getContext];
    if(tGlContext){
        [EAGLContext setCurrentContext:tGlContext];
        self.view.backgroundColor = [UIColor orangeColor];
        self.cameraVideoView = [[GLKView alloc] initWithFrame:[UIScreen mainScreen].bounds context:tGlContext];
        self.cameraVideoView.frame = [UIScreen mainScreen].bounds;
        [self.cameraVideoView setDelegate:self];
        [self.cameraVideoView setDrawableColorFormat:GLKViewDrawableColorFormatRGBA8888];
        [self.cameraVideoView setContext:tGlContext];
        [self.cameraVideoView setEnableSetNeedsDisplay:NO];
        [self.cameraVideoView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:self.cameraVideoView];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initCamera];
}

- (void)addVideoEffect:(UIButton *)btn {
    
    NSArray * array = @[
                        @"kanhai",
                        @"ningmenge",
                        @"vz",
                        @"srtoutao",
                        @"xiaoxiong2",
                        @"fadai",
                        @"jixiangruyi",
                        @"nvwang"
                        ];
    NSString *name = array[mCount%array.count];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"bundle"];
    //设置特效
    [mfm2 setEffect:path Name:@"fm2"];
    mCount++;
    if(mCount>=array.count){
        mCount = 0;
    }
}

- (void)deleteVideoEffect:(UIButton *)btn {
    [mfm2 clearEffectName:@"fm2"];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    if (mfm2 && [mfm2 getContext]) {
         float scale = [UIScreen mainScreen].scale;
        [mfm2 drawTestWidth:rect.size.width*scale Height:rect.size.height*scale Name:@"fm2"];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    [mCamlock lock];
    CVImageBufferRef imageBuffer = NULL;
    if (captureOutput == self.videoOutput) {
        imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        
        if(imageBuffer && CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
        {
            GASYUVFrame yuvFrame;
            size_t width = CVPixelBufferGetWidth(imageBuffer);
            size_t height = CVPixelBufferGetHeight(imageBuffer);
            if (!mIsYUVFormat) {
                UInt8 *bufferPtr = (UInt8*)CVPixelBufferGetBaseAddress(imageBuffer);
                yuvFrame.plane[0] = bufferPtr;
                yuvFrame.width = (int32_t)width;
                yuvFrame.height = (int32_t)height;
                yuvFrame.format = FMPixelFormatBGRA;
            }else {
                
                UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
                UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,1);
                yuvFrame.plane[0] = bufferPtr;
                yuvFrame.plane[1] = bufferPtr1;
                yuvFrame.width = (int32_t)width;
                yuvFrame.height = (int32_t)height;
                yuvFrame.format = FMPixelFormatYUV420V;
            }
            //进行图片识别
            FMDRESULT detectResult = [mDetection processImageFrame:&yuvFrame];
            //推送识别结果
//            [mfm2 pushDetectDataAS:detectResult.fmFaceCount facePoints:detectResult.fmFacePoints faceRect:detectResult.fmFaceRects faceOrient:detectResult.fmFaceOrients Name:@"fm2"];
            [mfm2 pushDetectDataFP:detectResult.fmFaceCount facePoints:detectResult.fmFacePoints_fp faceRect:detectResult.fmFaceRects faceOrient:detectResult.fmFaceOrients Name:@"fm2"];
            //推送相机图片
            [mfm2 pushCameraImage:yuvFrame.plane[0] Name:@"fm2"];
            //
            [self.cameraVideoView display];
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        }
    }
    [mCamlock unlock];
}

- (CMSampleBufferRef)changeVideoType:(CMSampleBufferRef)ref{
    CVImageBufferRef imageBuffer = NULL;
        imageBuffer = CMSampleBufferGetImageBuffer(ref);
        
        
        if(imageBuffer && CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
        {
            GASYUVFrame yuvFrame;
            size_t width = CVPixelBufferGetWidth(imageBuffer);
            size_t height = CVPixelBufferGetHeight(imageBuffer);
            if (!mIsYUVFormat) {
                UInt8 *bufferPtr = (UInt8*)CVPixelBufferGetBaseAddress(imageBuffer);
                yuvFrame.plane[0] = bufferPtr;
                yuvFrame.width = (int32_t)width;
                yuvFrame.height = (int32_t)height;
                yuvFrame.format = FMPixelFormatBGRA;
            }else {
                
                UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
                UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,1);
                yuvFrame.plane[0] = bufferPtr;
                yuvFrame.plane[1] = bufferPtr1;
                yuvFrame.width = (int32_t)width;
                yuvFrame.height = (int32_t)height;
                yuvFrame.format = FMPixelFormatYUV420V;
            }
            //进行图片识别
            FMDRESULT detectResult = [mDetection processImageFrame:&yuvFrame];
            //推送识别结果
            [mfm2 pushDetectDataAS:detectResult.fmFaceCount facePoints:detectResult.fmFacePoints faceRect:detectResult.fmFaceRects faceOrient:detectResult.fmFaceOrients Name:@"fm2"];
//            [mfm2 pushDetectDataFP:detectResult.fmFaceCount facePoints:detectResult.fmFacePoints_fp faceRect:detectResult.fmFaceRects faceOrient:detectResult.fmFaceOrients Name:@"fm2"];
            //推送相机图片
            [mfm2 pushCameraImage:yuvFrame.plane[0] Name:@"fm2"];
            //
            [self.cameraVideoView display];
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        }
    [mCamlock unlock];
    return (CMSampleBufferRef)imageBuffer;
}

#pragma mark - camera control
- (void)changeCamera:(UIButton *)button
{
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
}

- (IBAction)closeCamera:(id)sender
{
    mDetection.canDetect = false;
    [self dismissViewControllerAnimated:YES completion:^{
        //
        if(mfm2){
            [mfm2 stopEngine];
            [mfm2 fm2Destroy];
            mfm2 = NULL;
        }
        if(mDetection){
            [mDetection destory];
            mDetection = NULL;
        }
        mCamlock = NULL;
        //
        dispatch_async(self.sessionQuene, ^(void) {
            [self.captureSession stopRunning];
        });
    }];
}

- (void)initCamera{
    
    self.sessionQuene = dispatch_queue_create("sample buffer delegate", DISPATCH_QUEUE_SERIAL);
    
    NSError *error;
    self.captureSession = [[AVCaptureSession alloc] init];
    
    for(AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if(device.position == AVCaptureDevicePositionBack) {
            self.backCameraDevice = device;
        } else if(device.position == AVCaptureDevicePositionFront) {
            self.frontCameraDevcie = device;
        }
        
        [device lockForConfiguration:&error];
        device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        [device unlockForConfiguration];
    }
    
    //添加摄像头
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.frontCameraDevcie error:&error];
    self.currentCameraInput = input;
    
    if([self.captureSession canAddInput:input]) {
        [self.captureSession addInput:input];
    }
    self.currentCameraDevcie = self.frontCameraDevcie;
    
    //添加摄像头输出
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];

    //  kCVPixelFormatType_32BGRA mIsYUVFormat = NO; kCVPixelFormatType_420YpCbCr8BiPlanarFullRange mIsYUVFormat=YES
    self.videoOutput.videoSettings =[NSDictionary dictionaryWithObject:@(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
                                                                    forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    [self.videoOutput setSampleBufferDelegate:self queue:self.sessionQuene];
    if([self.captureSession canAddOutput:self.videoOutput]) {
        [self.captureSession addOutput:self.videoOutput];
    }
    
    self.captureSession.sessionPreset = AVCaptureSessionPresetiFrame1280x720;
    //视频连接
    AVCaptureConnection *captureConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([captureConnection isVideoOrientationSupported])
    {
        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationPortrait;
        [captureConnection setVideoOrientation:orientation];
        [captureConnection setVideoMirrored:YES];
    }
    //音频连接
    [self.captureSession commitConfiguration];
    self.isMirrored = YES;
    
    dispatch_async(self.sessionQuene, ^(void) {
        [self.captureSession startRunning];
    });
    mDetection.canDetect = true;
}

@end
