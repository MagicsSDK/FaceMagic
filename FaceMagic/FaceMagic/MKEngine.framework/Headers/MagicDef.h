//
//  MagicYUVData.h
//  Detection
//
//  Created by 刘铭 on 16/9/20.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#ifndef MagicYUVData_h
#define MagicYUVData_h

typedef signed		int			MGInt32;

typedef float					MGFloat;


typedef struct __magic_rect
{
    MGInt32 left;
    MGInt32 top;
    MGInt32 right;
    MGInt32 bottom;
} MGRECT, *MG_RECT;

typedef struct __magic_int_point
{
    MGInt32 x;
    MGInt32 y;
} MGINTPOINT, *MG_INT_POINT;


typedef struct __magic_float_point{
    MGFloat x;                ///< 坐标点x轴的值
    
    MGFloat y;                ///< 坐标点y轴的值
} MGFLOATPOINT, *MG_FLOAT_POINT;;

typedef enum
{
    FMPixelFormatRGBA = 0,          //kCVPixelFormatType_32RGBA
    FMPixelFormatBGRA,              //kCVPixelFormatType_32BGRA
    FMPixelFormatYUV420V            // kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
} FMPixelFormat;

typedef enum
{
    FMDetectTypeAS = 1, //AS
    
    FMDetcetTypeST, //ST
    
    FMDetectTypeFP//FacePP
    
}FMDetectType;

typedef struct tagYUVFrame
{
    int32_t    width;
    
    int32_t    height;
    
    uint8_t*   plane[4];
    
    int32_t    stride[4];
    
    int8_t     format;
    
} GASYUVFrame, *LPYUVFrame;

//触摸状态
typedef enum{
    
    FMTOUCHSBEGAN = 0,
    FMTOUCHSMOVED,
    FMTOUCHSENDED,
    FMFACEINTERSECT
    
}FMTOUCHSTATE;

#define S_YINGKEVIDEOSCENE  @"yingkevideo"
#define S_YINGKEVIDEOSCENE_RESID  230
#define S_YINGKEVIDEOSCENE_RESTYPE  0
#define S_YINGKEVIEWSCENE   @"yingkeview"
#define S_YINGKEVIEWSCENE_RESID  231
#define S_YINGKEVIEWSCENE_RESTYPE  1
#define max_face_count = 4;
#endif /* MagicYUVData_h */
