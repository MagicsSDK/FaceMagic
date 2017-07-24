#ifndef TESTMAGICENGINE_FACEMAGICCOMMON_H
#define TESTMAGICENGINE_FACEMAGICCOMMON_H
//
//  FaceMagicCommon.h
//  FaceMagicDetection
//
//  Created by 李晓帆 on 2016/9/25.
//  Copyright © 2016年 appmagics. All rights reserved.
//




//下巴
#define FM_CONTOUR_CHIN 0
//左边轮廓
#define FM_CONTOUR_LEFT1 1
#define FM_CONTOUR_LEFT2 2
#define FM_CONTOUR_LEFT4 3
#define FM_CONTOUR_LEFT6 4
#define FM_CONTOUR_LEFT8 5
//右边轮廓
#define FM_CONTOUR_RIGHT1 6
#define FM_CONTOUR_RIGHT2 7
#define FM_CONTOUR_RIGHT4 8
#define FM_CONTOUR_RIGHT6 9
#define FM_CONTOUR_RIGHT8 10
//左眼
#define FM_LEFT_EYE_BOTTOM 11
#define FM_LEFT_EYE_LEFT_CORNER 12
#define FM_LEFT_EYE_PUPIL 13
#define FM_LEFT_EYE_RIGHT_CORNER 14
#define FM_LEFT_EYE_TOP 15
//左眉
#define FM_LEFT_EYEBROW_LEFT_CORNER 16
#define FM_LEFT_EYEBROW_LOWER_MIDDLE 17
#define FM_LEFT_EYEBROW_RIGHT_CORNER 18
#define FM_LEFT_EYEBROW_UPPER_MIDDLE 19
//嘴
#define FM_MOUTH_LEFT_CORNER 20
#define FM_MOUTH_LOWER_LIP_BOTTOM 21
#define FM_MOUTH_LOWER_LIP_TOP 22
#define FM_MOUTH_RIGHT_CORNER 23
#define FM_MOUTH_UPPER_LIP_BOTTOM 24
#define FM_MOUTH_UPPER_LIP_TOP 25
//鼻子
#define FM_NOSE_CONTOUR_LOWER_MIDDLE 26
#define FM_NOSE_LEFT 27
#define FM_NOSE_RIGHT 28
#define FM_NOSE_TIP 29
//右眼
#define FM_RIGHT_EYE_BOTTOM 30
#define FM_RIGHT_EYE_LEFT_CORNER 31
#define FM_RIGHT_EYE_PUPIL 32
#define FM_RIGHT_EYE_RIGHT_CORNER 33
#define FM_RIGHT_EYE_TOP 34
//右眉
#define FM_RIGHT_EYEBROW_LEFT_CORNER 35
#define FM_RIGHT_EYEBROW_LOWER_MIDDLE 36
#define FM_RIGHT_EYEBROW_RIGHT_CORNER 37
#define FM_RIGHT_EYEBROW_UPPER_MIDDLE 38

#define FM_EYEBROW_BETWEEN 39
//
#define FM_LEFT_EYE_1 40
#define FM_LEFT_EYE_2 41
#define FM_LEFT_EYE_3 42
#define FM_LEFT_EYE_4 43

#define FM_RIGHT_EYE_1 44
#define FM_RIGHT_EYE_2 45
#define FM_RIGHT_EYE_3 46
#define FM_RIGHT_EYE_4 47

//最大支持人脸数
#define SUPPORT_MAX_PERSON_NUM 4

//脸部中心
#define FM_FACE_CENTER 48

enum FaceMagicDetectionType{

    FaceMagicDetection1 = 1,
    FaceMagicDetection2,
    FaceMagicDetection3,
    FaceMagicDetection4
};

enum FMDetectionFormat
{
    FMDetectionFormatRGBA = 0,              //kCVPixelFormatType_32RGBA
    FMDetectionFormatBGRA,              //kCVPixelFormatType_32BGRA
    FMDetectionFormatYUV420V                 // kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
} ;

//输入输出格式
typedef struct __fm_frame_format{

    enum FMDetectionFormat inputFormat;
    enum FMDetectionFormat outputFormat;

}FMFrameFormat, *PFMFrameFormat;



#endif
