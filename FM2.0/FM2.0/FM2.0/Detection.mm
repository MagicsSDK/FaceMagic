//
//  Detection.m
//  FaceMagic
//
//  Created by 李晓帆 on 2016/12/6.
//  Copyright © 2016年 appmagics. All rights reserved.
//

#import "Detection.h"
#import <UIKit/UIKit.h>
// AS
#import "amcomdef.h"
#import "arcsoft_spotlight.h"

@interface Detection(){
    
    int _faceType;
    int _maxFaceCount;
    int pointsCount;
    //
    
    MHandle        m_hEngine;
    int            _faceCount;
    MPOINT* pFaceOutlinePointOut;
    MRECT*  rcFaceRectOut;
    MFloat* faceOrientOut;
    
    MGFLOATPOINT *fmPoints;
    MRECT *fmRects;
    MFloat *fmOrients;
    //数据结构
    FMDRESULT imageResult;

    float _time;
}
@end

@implementation Detection
- (instancetype)init {
    self = [super init];
    if (self) {
//        pFaceOutlinePointOut = MNull;
//        rcFaceRectOut = MNull;
//        faceOrientOut = MNull;
//        [self creatEngine];
       
    }
    return self;
}

-(instancetype)initWithDetectionType:(MagicDetectionType)detectionType{
    self = [super init];
    _faceType = detectionType;
    if (self) {
        pFaceOutlinePointOut = MNull;
        rcFaceRectOut = MNull;
        faceOrientOut = MNull;
        if (detectionType == DetectionType1) {
            [self creatEngine];
        }else if (detectionType == DetectionType2){
            _maxFaceCount = 4;
            pointsCount = 106;
        }else if (detectionType == DetectionType3){
            _maxFaceCount = 4;
            pointsCount = 68;
        }
        
    }
    return self;
}

- (void)creatEngine{
    
    m_hEngine = ASL_CreateEngine();
    NSBundle *mainBundle=[NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:@"track_data" ofType:@"dat"];
    MRESULT hRet = ASL_Initialize(m_hEngine,
                                  [path UTF8String],
                                  ASL_MAX_FACE_NUM,
                                  MNull,MNull);
    if(hRet == MOK)
    {
        ASL_SetProcessModel(m_hEngine,ASL_PROCESS_MODEL_FACEOUTLINE |ASL_PROCESS_MODEL_FACEBEAUTY);
        ASL_SetFaceSkinSoftenLevel(m_hEngine,100);
        ASL_SetFaceBrightLevel(m_hEngine,100);
    }
    
}

- (FMDRESULT)processImageFrame:(LPYUVFrame)imageFrame {
    imageResult.fmFaceCount = 0;
    if (_faceType == DetectionType1) {
        [self processFrame:imageFrame];
    }else if (_faceType == DetectionType2){
        
    }else if (_faceType == DetectionType3){
    
    }
    
    return imageResult;
}

- (void)processFrame:(LPYUVFrame)videoFrame {
    
//    if (!_canDetect) {
//        return;
//    }

    MInt32  width = videoFrame->width;;
    MInt32 height = videoFrame->height;
    MInt8 format = videoFrame->format;
    MUInt8  *buffer0;
    MUInt8  *buffer1;
    if (format == FMPixelFormatYUV420V) {
        buffer0 = videoFrame->plane[0];
        buffer1 = videoFrame->plane[1];
        
    }else if (format == FMPixelFormatBGRA){
        buffer0 = videoFrame->plane[0];
    }
    
    MInt32 nFaceCountInOut = ASL_MAX_FACE_NUM;
    if (pFaceOutlinePointOut == MNull) {
        pFaceOutlinePointOut = new MPOINT[ASL_MAX_FACE_NUM * ASL_GetFaceOutlinePointCount()];
    }
    if (rcFaceRectOut == MNull) {
        rcFaceRectOut = new MRECT[ASL_MAX_FACE_NUM];
    }
    if (faceOrientOut == MNull) {
        faceOrientOut = new MFloat[ASL_MAX_FACE_NUM * 3];
    }
    
    ASVLOFFSCREEN OffScreenIn = {0};
    OffScreenIn.i32Width = width;
    OffScreenIn.i32Height = height;
    if (format == FMPixelFormatBGRA) {
        OffScreenIn.u32PixelArrayFormat = ASVL_PAF_RGB32_B8G8R8A8;
        OffScreenIn.pi32Pitch[0] = OffScreenIn.i32Width*4;
        OffScreenIn.ppu8Plane[0] = buffer0;
    }else if (format == FMPixelFormatYUV420V) {
        OffScreenIn.u32PixelArrayFormat = ASVL_PAF_NV12;
        OffScreenIn.pi32Pitch[0] = OffScreenIn.i32Width;
        OffScreenIn.pi32Pitch[1] = OffScreenIn.i32Width;
        OffScreenIn.ppu8Plane[0] = buffer0;
        OffScreenIn.ppu8Plane[1] = buffer1;
    }
    
    _faceCount = 0;
    
    MRESULT hr = ASL_Process(m_hEngine,
                             &OffScreenIn,
                             &OffScreenIn,
                             &nFaceCountInOut,
                             pFaceOutlinePointOut,
                             rcFaceRectOut,
                             faceOrientOut
                             );
    if(hr == MOK)
    {
        if (nFaceCountInOut > 0) {
            _faceCount = nFaceCountInOut;
            imageResult.fmFaceOrients = faceOrientOut;
            imageResult.fmFacePoints_as = (MGINTPOINT *)pFaceOutlinePointOut;
            imageResult.fmFaceRects = (MGRECT *)rcFaceRectOut;
            imageResult.fmPointsCount = ASL_GetFaceOutlinePointCount();
        }
    }
    imageResult.fmFaceCount = _faceCount;
}

- (void)destory {
    if(m_hEngine != MNull)
    {
        ASL_Uninitialize(m_hEngine);
        ASL_DestroyEngine(m_hEngine);
        delete [] pFaceOutlinePointOut;
        delete [] faceOrientOut;
        delete [] rcFaceRectOut;
        
        delete [] fmPoints;
        delete [] fmRects;
        delete [] fmOrients;
        m_hEngine = MNull;
    }
    
}

@end
