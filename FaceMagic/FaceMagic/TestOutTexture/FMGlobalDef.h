//
//  FMGlobalDef.h
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/15.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#ifndef FMGlobalDef_h
#define FMGlobalDef_h

#define CHANNEL_POSITION    0
#define CHANNEL_NORMAL      1
#define CHANNEL_COLOR       2
#define CHANNEL_TEXCOORD0   3
#define CHANNEL_TEXCOORD1   4
#define CHANNEL_TEXCOORD2   5
#define CHANNEL_TEXCOORD3   6

//内置变量
#define NAME_POSITION   "aPosition"
#define NAME_NORMAL     "aNormal"
#define NAME_COLOR      "aColor"
#define NAME_TEXCOORD0  "aTexcoord0"
#define NAME_TEXCOORD1  "aTexcoord1"
#define NAME_TEXCOORD2  "aTexcoord2"
#define NAME_TEXCOORD3  "aTexcoord3"

//
#define NAME_TEX0  "aTexture0"
#define NAME_TEX1  "aTexture1"
#define NAME_TEX2  "aTexture2"
#define NAME_TEX3  "aTexture3"

#define BLEND_FARC      "uBlendfrac"
#define TEXCOORD_ROT    "uTexcoordRot"
#define TEXCOORD_FLIP   "uTexcoordFlip"
#define NAME_TEXSIZE_0  "uTex0size"
#define NAME_TEXSIZE_1  "uTex1size"
#define NAME_TEXSIZE_2  "uTex2size"
#define NAME_TEXSIZE_3  "uTex3size"

#define NAME_POINTSIZE  "uPtsize"

#define NAME_M_MATRIX   "aMatrixM"
#define NAME_V_MATRIX   "aMatrixV"
#define NAME_P_MATRIX   "aMatrixP"
#define NAME_VP_MATRIX  "aMatrixVP"
#define NAME_MVP_MATRIX "aMatrixMVP"

#define PI 3.1415926
#define DEGREE_T0_RAD 0.01745     //(PI/180.0f)
#define RAD_T0_DEGREE 57.29578    //(180.0/PI)

typedef struct __fmvev2{

    float x;
    float y;
    
}FMVec2,*PFMVec2;

typedef struct __fmvev3{
    
    float x;
    float y;
    float z;
    
}FMVec3,*PFMVec3;

typedef struct __fmvev4{
    
    float x;
    float y;
    float z;
    float w;
    
}FMVec4,*PFMVec4;
#endif /* FMGlobalDef_h */
