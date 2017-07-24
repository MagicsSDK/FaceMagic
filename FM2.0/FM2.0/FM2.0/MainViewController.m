//
//  MainViewController.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/4.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "MainViewController.h"
#import "camera/Camera.h"
#import <MKEngine/FM2.h>
#import "display/FMGLView.h"
#import "Detection.h"
#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>
#import "subviews/FMEffectsBackgroundView.h"
#import "videodata/VideoData.h"
#import "record/RecordImage.h"
#import "record/RecordVideo.h"
#import "UIView+Toast.h"
#import <CoreMotion/CoreMotion.h>
#import "parsebundle/ParseBundle.h"
#import "FileUtil2.h"
#import "SSZipArchive.h"
#import "CollectionViewController.h"

#import "MagicLocalVC.h"

#define SCENENAME @"fm2"
@interface MainViewController ()<CameraDelegate,MagicLocalVCSelecteDelegate>
{
    int                   mVideoWidth;
    int                   mVideoHeight;
    float                 mVideoAngle;
    Detection             *mDetection;
    FM2                   *mfm2;
    FMGLView              *mfmGLKView;
    Camera                *mCamera;
    FMEffectsBackgroundView *meffectBackgroundView;
    NSMutableArray        *mButtonsArray;
    dispatch_semaphore_t  mSemaphore;
    VideoData             *mYUVData;
    RecordImage           *mRecordImage;
    RecordVideo           *mRecordVideo;
    //陀螺仪
    CMMotionManager       *mCmmotionManager;
    CMAttitude            *mDeviceCMAttitude;
    bool                  mSensorActive;
    //
    //parse
    ParseBundle           *mParseBundle;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self initializeParameter];
    [self initializeMKEngine];
    [self initializeDetection];
    [self createGLKView];
    [self initializeCamera];
    [self initializeRecorder];
    [self initMotionManager];
    [self initUI];
    [self initializeEffectBackgroundView];
    [self registNotification];
    [self initializeParse];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [mCamera startCapture];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [mCamera stopCapture];
}

- (void)dealloc{
    [mfm2 fm2Destroy];
    [mDetection destory];
    [mYUVData destory];
    [self unRegistNotification];
}

- (void)initializeCamera{
    mCamera = [[Camera alloc]init];
    mCamera.delegate = self;
}

#pragma mark ---  CameraDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    dispatch_semaphore_wait(mSemaphore, DISPATCH_TIME_FOREVER);
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (!imageBuffer) {
        dispatch_semaphore_signal(mSemaphore);
        return;
    }
    if(CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
    {
        GASYUVFrame yuvFrame;
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        int pixelFormat = CVPixelBufferGetPixelFormatType(imageBuffer);
        bool isYUVFormat = false;
        switch (pixelFormat) {
            case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange:
                isYUVFormat = true;
                break;
            case kCVPixelFormatType_422YpCbCr8:
                break;
            default:
                isYUVFormat = false;
        }
        
        if (!isYUVFormat) {
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
        if (mSensorActive) {
            CMRotationMatrix deviceRotation = [self getRotationMatrix];
            [mfm2 updateGyroDataX:deviceRotation.m31 Y:deviceRotation.m32 Z:-deviceRotation.m33];
        }
        //进行图片识别
//        FMDRESULT detectResult = [mDetection processImageFrame:&yuvFrame];
//        //推送识别结果
//        [mfm2 pushDetectDataAS:detectResult.fmFaceCount facePoints:detectResult.fmFacePoints_as faceRect:detectResult.fmFaceRects faceOrient:detectResult.fmFaceOrients Name:SCENENAME];
//        
        //推送相机图片
        [mfm2 pushCameraImage:yuvFrame.plane[0] Name:SCENENAME WithHandle:nil];
        
        [mfm2 getYUVDataWithName1:SCENENAME andBuffer:[mYUVData getDataBuffer]];
        
        [mfm2 getYUVDataWithName1:SCENENAME andBuffer:yuvFrame.plane[0]];
        
        [mRecordVideo setVideoSampleBuffer:sampleBuffer];
        //            [weakFm2 renderToPixelBuffer];
        
        //            CVPixelBufferRef pixelBufferRef = [weakFm2 getPixelBuffer];
        
        if (mfmGLKView) {
            [mfmGLKView display];
        }
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
    dispatch_semaphore_signal(mSemaphore);
}

- (void)initializeRecorder{
    mRecordImage = [[RecordImage alloc]init];
    [mRecordImage setVideoData:mYUVData];
    __weak MainViewController *weakSelf = self;
    mRecordImage.saveImageResult = ^(NSString *msg) {
        // basic usage
        // toast with a specific duration and position
        [weakSelf.view makeToast:msg
                        duration:1.0
                        position:CSToastPositionCenter];
    };
    
    //
    mRecordVideo = [[RecordVideo alloc]init];
    [mRecordVideo setupWithCameraSite:mCamera];
    NSURL *videoURL = [[NSURL alloc] initFileURLWithPath:[NSString pathWithComponents:@[NSTemporaryDirectory(), @"Movie.MOV"]]];
    [mRecordVideo setReocrdURL:videoURL];
    mRecordVideo.videoRecorderError = ^(NSError *error) {
        NSLog(@"start video recorder error:%@",error.description);
        [weakSelf.view makeToast:@"录制失败"
                        duration:1.0
                        position:CSToastPositionCenter];
        
    };
    mRecordVideo.videoRecorderDidStart = ^{
        //正在录制
    };
    mRecordVideo.videoRecorderWillStop = ^{
        //录制将要结束
    };
    mRecordVideo.videoRecorderDidStop = ^{
        //录制已经停止
        [weakSelf.view makeToast:@"录制成功"
                        duration:1.0
                        position:CSToastPositionCenter];
    };
}

- (void)initializeParameter{
    mVideoWidth = 720;
    mVideoHeight = 1280;
    mVideoAngle = 0.0f;
    mSemaphore = dispatch_semaphore_create(1);
    mButtonsArray = [[NSMutableArray alloc]init];
}

- (void)initializeDetection{
    mDetection = [[Detection alloc]initWithDetectionType:DetectionType1];
}

- (void)initializeMKEngine {
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
    //
//    [mfm2 enableOutputPixelBuffer];
    //创建一个场景
 
    [mfm2 createScene:SCENENAME sceneWidth:[UIScreen mainScreen].bounds.size.width*scale sceneHeight:[UIScreen mainScreen].bounds.size.height*scale videoWidth:mVideoWidth videoHeight:mVideoHeight mirrored:true];
    //设置输出流格式
    [mfm2 setInputFormat:FMPixelFormatYUV420V Width:mVideoWidth Height:mVideoHeight Angle:mVideoAngle Name:SCENENAME];
    //设置输出流格式
    [mfm2 setOutputFormat:FMPixelFormatYUV420V Name:SCENENAME];
    //
    mYUVData = [[VideoData alloc]initWith:FMPixelFormatYUV420V width:mVideoWidth height:mVideoHeight];
    //
}

#pragma mark ----- 传感器

- (void)initMotionManager {
    if (!mCmmotionManager) {
        mCmmotionManager = [[CMMotionManager alloc] init];
        if (mCmmotionManager.deviceMotionAvailable) {
            CMDeviceMotion *deviceMotion = mCmmotionManager.deviceMotion;
            mDeviceCMAttitude = deviceMotion.attitude;
//            [mCmmotionManager startDeviceMotionUpdates];
//            [self startSensor];
            mSensorActive = false;
        }else{
            NSLog(@"该设备的deviceMotion不可用");
        }
        
    }
    
}
- (void)startSensor{
    if (!mSensorActive) {
        [mCmmotionManager startDeviceMotionUpdates];
        mSensorActive = true;
    }
}
- (void)stopSensor{
    if (mSensorActive) {
        [mCmmotionManager stopDeviceMotionUpdates];
        mSensorActive = false;
    }
}
- (CMRotationMatrix)getRotationMatrix{
    CMRotationMatrix rotation;
    CMDeviceMotion *deviceMotion = mCmmotionManager.deviceMotion;
    CMAttitude *attitude = deviceMotion.attitude;
    if (mDeviceCMAttitude != nil) {
        [attitude multiplyByInverseOfAttitude:mDeviceCMAttitude];
    }
    rotation = attitude.rotationMatrix;
    return rotation;
}
//////////////////////////
#pragma mark -----notification
- (void)registNotification {
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addEffect:) name:@"effectPath" object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(configFilesActionNotice:) name:CONFIGFILESACTION object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(personActionNotice:) name:PERSONACTION object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(audioActionNotice:) name:AUDIOACTION object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(effectActionNotice:) name:EFFECTACTION object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(effectFileNotice:) name:EFFECTFILE object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(touchActionNotice:) name:TOUCHACTION object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sensorActionNotice:) name:@"sensorActive" object:nil];
}
- (void)sensorActionNotice:(NSNotification *)event {
    NSDictionary * dic = event.userInfo[@"action"];
    NSString *sensorState = dic[@"sensor"];
    if ([sensorState isEqualToString:@"open"]) {
        [self startSensor];
        
    }else if ([sensorState isEqualToString:@"close"]){
        
        [self stopSensor];
    }
}

- (void)addEffect:(NSNotification*)notifi{
    
    NSString* path = notifi.object;
    if ([path containsString:@"file:///private"]) {
        path =  [path substringFromIndex:15];
    }
    
    NSString * path1 = [FileUtil2 getFullFilePathInDocuments:@"/effectFolder" fileName:@""];
    
    BOOL sucess = [SSZipArchive unzipFileAtPath:path toDestination:path1];
    if (sucess) {
        [FileUtil2 removeFile:path];
        NSString* path2 = [path1 stringByAppendingString:@"/__MACOSX"];
        BOOL isExists = [FileUtil2 isFileExists:path2];
        if(isExists){
            [FileUtil2 removeFile:path2];
        }
    }
    
    NSString* dataPath = [self getDataFile:path1];
    if (dataPath) {
        dataPath = [path1 stringByAppendingFormat:@"%@",dataPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            [mParseBundle loadRes:dataPath];
            if (mParseBundle.enableSensor) {
                [self startSensor];
            }else{
                [self stopSensor];
            }
            [mfm2 setEffect:dataPath Name:SCENENAME];
        });
    }
}

- (NSString*)getDataFile:(NSString*)path
{
    NSString* pathStr;
    NSError* error;
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray  *arr = [fm  contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        pathStr = nil;
    }else{
        for (NSString* name in arr) {
            pathStr = name;
        }
    }
    return pathStr;
}

- (void)unRegistNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"effectPath" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sensorActive" object:nil];
}
/////////////////////
#pragma mark ---- Parse
- (void)initializeParse{
    mParseBundle = [[ParseBundle alloc]init];
}
/////////////////////
- (void)createGLKView {
    mfmGLKView = [[FMGLView alloc]init];
    [mfmGLKView initilizeGLKViewWidth:self.view.bounds.size.width height:self.view.bounds.size.height context:[mfm2 getContext]];
    GLKView *t_glkView = [mfmGLKView getGLKView];
    [self.view addSubview:t_glkView];
    float t_scale = [UIScreen mainScreen].nativeScale;
    int t_sceneWidth = [UIScreen mainScreen].bounds.size.width*t_scale;
    int t_sceneHeight = [UIScreen mainScreen].bounds.size.height*t_scale;
    __weak FM2 *weakFM2 = mfm2;
    //draw
    mfmGLKView.fmGLKViewRender = ^(){
        [weakFM2 drawTestWidth:t_sceneWidth Height:t_sceneHeight Name:SCENENAME];
    };
}

- (void)initUI{
    UIButton *changeCamera = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 20, 50, 50)];
    [changeCamera setImage:[UIImage imageNamed:@"changeCamera"] forState:UIControlStateNormal];
    [changeCamera addTarget:self action:@selector(changeCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeCamera];
    [mButtonsArray addObject:changeCamera];
    
    UIButton *recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 80, 80, 80)];
    [recordButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [recordButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateSelected];
    [self.view addSubview:recordButton];
    [mButtonsArray addObject:recordButton];
    recordButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, recordButton.center.y - 20);
    [recordButton addTarget:self action:@selector(takeImage:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *lg = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(recordingVideo:)];
    [recordButton addGestureRecognizer:lg];
    
    UIButton *selectEffectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-40, self.view.bounds.size.height-40, 60, 60)];
    selectEffectBtn.center = CGPointMake(recordButton.frame.origin.x + recordButton.frame.size.width + 20 + 60 / 2, recordButton.center.y);
    [selectEffectBtn setImage:[UIImage imageNamed:@"selecteffect"] forState:UIControlStateNormal];
    [selectEffectBtn addTarget:self action:@selector(selectEffect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectEffectBtn];
    [mButtonsArray addObject:selectEffectBtn];
}
//拍照
- (void)takeImage:(UIButton *)btn{
    dispatch_async(dispatch_get_main_queue(), ^{
         [mRecordImage saveImageToPhoto];
    });
   
}

//录像
- (void)recordingVideo:(UILongPressGestureRecognizer *)lg{
        UIButton *btn = (UIButton *)lg.view;
        if (lg.state == UIGestureRecognizerStateBegan) {
            btn.selected = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [mRecordVideo startRecording];
            });
        }
        else if (lg.state == UIGestureRecognizerStateEnded){
            btn.selected = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [mRecordVideo finishRecording];
            });
        }else if (lg.state == UIGestureRecognizerStateCancelled){
            btn.selected = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [mRecordVideo finishRecording];
            });
        }else if (lg.state == UIGestureRecognizerStateFailed){
            btn.selected = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [mRecordVideo finishRecording];
            });
        }
}


- (void)selectEffect:(UIButton *)btn{
    int t_arrayCount = (int)mButtonsArray.count;
    for (int i = 0;i<t_arrayCount ; i++) {
        UIButton *t_button = mButtonsArray[i];
        t_button.hidden = YES;
    }
    [meffectBackgroundView show];
}

- (void)changeCamera:(UIButton *)btn{
    [mCamera changeCamera];
}


- (void)initializeEffectBackgroundView{
#if 0
    CollectionViewController *collectionView = [[CollectionViewController alloc]init];
    collectionView.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, self.view.frame.size.width, 200);
    [self.view addSubview:collectionView.view];
#else
    MagicLocalVC *localVC = [MagicLocalVC new];
    localVC.delegate = self;
    localVC.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, self.view.frame.size.width, 200);
    [self addChildViewController:localVC];
    [self.view addSubview:localVC.view];
#endif
//    meffectBackgroundView = [[FMEffectsBackgroundView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
//    [self.view addSubview:meffectBackgroundView];
//    __weak NSMutableArray *weakArray = mButtonsArray;
//    __weak FMEffectsBackgroundView *weakBackgroundView = meffectBackgroundView;
//    meffectBackgroundView.tapEvent = ^{
//        int t_arrayCount = (int)weakArray.count;
//        for (int i = 0;i<t_arrayCount ; i++) {
//            UIButton *t_button = weakArray[i];
//            t_button.hidden = NO;
//        }
//        [weakBackgroundView hidden];
//    };
//    __weak FM2 *weakfm2 = mfm2;
//    __weak ParseBundle *weakParse = mParseBundle;
//    __weak MainViewController *weakSelf = self;
//    meffectBackgroundView.getEffectPath = ^(NSString *effectpath) {
//        if ([effectpath isEqualToString:@"cleareffect"]) {
//            [weakfm2 clearEffectName:SCENENAME];
//        }else{
//            [weakParse loadRes:effectpath];
//            if (weakParse.enableSensor) {
//                [weakSelf startSensor];
//            }else{
//                [weakSelf stopSensor];
//            }
//            [weakfm2 setEffect:effectpath Name:SCENENAME];
//        }
//    };
}

- (void)cleanEffect{
    [mfm2 clearEffectName:SCENENAME];
}

- (void)setEffectWithPath:(NSString *)path{
    [mfm2 setEffect:path Name:SCENENAME];
    NSLog(@"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
