//
//  ViewController.m
//  GLKCamera
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
#import "Detection.h"
#import "MagicLocalVC.h"

#import <CoreMotion/CoreMotion.h>

@interface fm2ViewCtrl () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate,AVAudioPlayerDelegate,GLKViewDelegate,MagicLocalVCSelecteDelegate>{
    FM2*        mfm2;
    float       mVideoAngle;
    int         mVideoWidth;
    int         mVideoHeight;
    NSLock      *mCamlock;
    BOOL        mIsYUVFormat;
    Detection   *mDetection;
    int         mCount;
    MagicLocalVC *localVC;
    UIButton *selectEffectBtn;
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

@property(nonatomic,strong)CMMotionManager *cmmotionManager;
@property(nonatomic,strong)CMAttitude      *deviceCMAttitude;
@property(nonatomic,assign)bool             sensorActive;
//@property (nonatomic, strong) MagicBarVC* barVC;

@property (nonatomic, strong) dispatch_semaphore_t frameRenderingSemaphore;


@end

@implementation fm2ViewCtrl

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initCamera];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mCamlock = [NSLock new];
    //初始化识别模块
    mDetection = [[Detection alloc]initWithDetectionType:DetectionType1];
    //
    mVideoWidth = 720;
    mVideoHeight = 1280;
    mVideoAngle = 0.0f;
    mIsYUVFormat = 0;
    mCount = 0;
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor clearColor];
    //创建和初始化FM2引擎
    [self initFM2];
    //创建GL设备上下文
    [self createGLKView];
    
    UIButton *changeCamerabutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [changeCamerabutton setImage:[UIImage imageNamed:@"changeCamera"] forState:UIControlStateNormal];
    [changeCamerabutton addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeCamerabutton];
    changeCamerabutton.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, changeCamerabutton.center.y);
    
    selectEffectBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.bounds.size.height-70, 60, 60)];
    [selectEffectBtn setImage:[UIImage imageNamed:@"selecteffect"] forState:UIControlStateNormal];
    [selectEffectBtn addTarget:self action:@selector(selectEffect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectEffectBtn];
    
    //初始化UI
    [self initializeEffectBackgroundView];
    
    [self initMotionManager];
    
}

#pragma  mark --- init UI
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
    [mfm2 startEngine:FMDetectTypeAS];
    //开启直接绘制模式 主要用于测试 便于观察
    [mfm2 enableDDrawMode:true];
    //创建一个场景
    [mfm2 createScene:@"fm2" sceneWidth:[UIScreen mainScreen].bounds.size.width*scale sceneHeight:[UIScreen mainScreen].bounds.size.height*scale videoWidth:mVideoWidth videoHeight:mVideoHeight mirrored:true];
    
//    [mfm2 createScene:@"fm2" Width:[UIScreen mainScreen].bounds.size.width*scale Height:[UIScreen mainScreen].bounds.size.height*scale  Mirrored:true];
    //设置输入流格式
    [mfm2 setInputFormat:FMPixelFormatBGRA Width:mVideoWidth Height:mVideoHeight Angle:mVideoAngle Name:@"fm2"];
    //设置输出流格式
    [mfm2 setOutputFormat:FMPixelFormatBGRA Name:@"fm2"];
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

- (void)initializeEffectBackgroundView{
    selectEffectBtn.hidden = YES;
#if 0
    CollectionViewController *collectionView = [[CollectionViewController alloc]init];
    collectionView.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, self.view.frame.size.width, 200);
    [self.view addSubview:collectionView.view];
#else
    localVC = [MagicLocalVC new];
    localVC.delegate = self;
    localVC.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 240, self.view.frame.size.width, 240);
    [self addChildViewController:localVC];
    [self.view addSubview:localVC.view];
#endif
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 240)];
    [self.view addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenLocalVC:)];
    [view addGestureRecognizer:tap];
}

#pragma mark --- gyro
- (void)initMotionManager {
    if (!self.cmmotionManager) {
        self.cmmotionManager = [[CMMotionManager alloc] init];
        CMDeviceMotion *deviceMotion = self.cmmotionManager.deviceMotion;
        self.deviceCMAttitude = deviceMotion.attitude;
        [self.cmmotionManager startDeviceMotionUpdates];
    }
    _sensorActive = true;
}

- (void)startSensor{
    if (!_sensorActive) {
        [self.cmmotionManager startDeviceMotionUpdates];
        _sensorActive = true;
    }
}

- (void)stopSensor{
    if (_sensorActive) {
        [self.cmmotionManager stopDeviceMotionUpdates];
        _sensorActive = false;
    }
}

- (CMRotationMatrix)getRotationMatrix{
    CMRotationMatrix rotation;
    CMDeviceMotion *deviceMotion = self.cmmotionManager.deviceMotion;
    CMAttitude *attitude = deviceMotion.attitude;
    if (self.deviceCMAttitude != nil) {
        [attitude multiplyByInverseOfAttitude:self.deviceCMAttitude];
    }
    rotation = attitude.rotationMatrix;
    return rotation;
}

#pragma mark --- button method
- (void)deleteVideoEffect:(UIButton *)btn {
    [mfm2 clearEffectName:@"fm2"];
}

- (void)selectEffect:(UIButton *)btn{
    localVC.view.hidden = NO;
    selectEffectBtn.hidden = YES;
}

- (void)hiddenLocalVC:(UIGestureRecognizer *)ges{

    localVC.view.hidden = YES;
    selectEffectBtn.hidden = NO;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *fitView = [[self.view superview] hitTest:point withEvent:event];
//    
//    if (fitView == self.view) {
//        return fitView;
//    }else if (fitView == localVC.view || [fitView class] == [UICollectionView class]){
//        return localVC.view;
//    }
//    return fitView;
//}

#pragma mark --- delegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    if (mfm2 && [mfm2 getContext]) {
         float scale = [UIScreen mainScreen].scale;
        [mfm2 drawTestWidth:rect.size.width*scale Height:rect.size.height*scale Name:@"fm2"];
    }
}

- (void)cleanEffect{
    [mfm2 clearEffectName:@"fm2"];
}

- (void)setEffectWithPath:(NSString *)path{
    [mfm2 setEffect:path Name:@"fm2"];
}

- (void)setIntentityValue:(float)value{
    [mfm2 updateIntensity:value Name:@"fm2"];
}

-(void)setSlimStrengthValue:(float)value{
    [mfm2 updateSlimStrenrth:value Name:@"fm2"];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    [mCamlock lock];
//    UIImage *image = [UIImage imageNamed:@"标准头.jpg"];
  
    CVImageBufferRef imageBuffer = NULL;
    if (captureOutput == self.videoOutput) {
        imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//        imageBuffer = [self CVPixelBufferRefFromUiImage:image];
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
                yuvFrame.bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
                yuvFrame.format = FMPixelFormatBGRA;
            }else {
                
                UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
                UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,1);
                yuvFrame.plane[0] = bufferPtr;
                yuvFrame.plane[1] = bufferPtr1;
                yuvFrame.width = (int32_t)width;
                yuvFrame.height = (int32_t)height;
                yuvFrame.bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
                yuvFrame.format = FMPixelFormatYUV420V;
            }
            //进行图片识别
            FMDRESULT detectResult = [mDetection processImageFrame:&yuvFrame];
            
            if (_sensorActive) {
                CMRotationMatrix deviceRotation = [self getRotationMatrix];
                [mfm2  updateGyroDataX:deviceRotation.m31 Y:deviceRotation.m32 Z:-deviceRotation.m33];
            }
            
            //推送识别结果
            [mfm2 pushDetectDataAS:detectResult.fmFaceCount facePoints:detectResult.fmFacePoints_as faceRect:detectResult.fmFaceRects faceOrient:detectResult.fmFaceOrients Name:@"fm2"];
//            [mfm2 pushDetectDataFP:detectResult.fmFaceCount facePoints:detectResult.fmFacePoints_fp faceRect:detectResult.fmFaceRects faceOrient:detectResult.fmFaceOrients Name:@"fm2"];
            
//            [mfm2 pushDetectDataMA:detectResult.fmFaceCount facePoints:detectResult.fmFacePoints_fp faceRect:detectResult.fmFaceRects faceOrient:detectResult.fmFaceOrients Name:@"fm2"];
            
            //推送相机图片
//            [mfm2 pushCameraImage:yuvFrame.plane[0] Name:@"fm2"];
            [mfm2 pushCameraImage:yuvFrame.plane[0] Name:@"fm2" WithHandle:nil];
            
            [self.cameraVideoView display];
             [mfm2 getRenderBufferWithName:@"fm2" andBuffer:sampleBuffer];
            [self imageFromSampleBuffer:sampleBuffer];
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
        }
    }
    [mCamlock unlock];
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
    self.videoOutput.videoSettings =[NSDictionary dictionaryWithObject:@(kCVPixelFormatType_32BGRA)
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

#pragma mark --- other
- (unsigned char *)pixelBRGABytesFromImageRef:(CGImageRef)imageRef {
    
    NSUInteger iWidth = CGImageGetWidth(imageRef);
    NSUInteger iHeight = CGImageGetHeight(imageRef);
    NSUInteger iBytesPerPixel = 4;
    NSUInteger iBytesPerRow = iBytesPerPixel * iWidth;
    NSUInteger iBitsPerComponent = 8;
    unsigned char *imageBytes = (unsigned char*)malloc(iWidth * iHeight * iBytesPerPixel);
    //
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(imageBytes,
                                                 iWidth,
                                                 iHeight,
                                                 iBitsPerComponent,
                                                 iBytesPerRow,
                                                 colorspace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    //
    CGRect rect = CGRectMake(0 , 0 , iWidth , iHeight);
    CGContextDrawImage(context , rect ,imageRef);
    CGColorSpaceRelease(colorspace);
    CGContextRelease(context);
    
    return imageBytes;
}

- (CVPixelBufferRef)CVPixelBufferRefFromUiImage:(UIImage *)img {
    
    CGSize size = img.size;
    CGImageRef image = [img CGImage];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef) options, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    
    return (image);
}

- (void)dealloc{
    
}


@end
