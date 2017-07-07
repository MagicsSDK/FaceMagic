//
//  Detection.h
//  FaceMagic
//
//  Created by 李晓帆 on 2016/12/6.
//  Copyright © 2016年 appmagics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MKEngine/MagicDef.h>



typedef enum{
    
    DetectionType1 = 1,//AS
    
    DetectionType2,//FP
    
    DetectionType3,//ST
    
}MagicDetectionType;

typedef struct __fmDetectionResult
{
    MGInt32     fmFaceCount;
    
    MGInt32     fmPointsCount;
    
    MGINTPOINT*    fmFacePoints;
    
    MGRECT*     fmFaceRects;
    
    MGFloat*    fmFaceOrients;
    
    MGFLOATPOINT *fmFacePoints_fp;
    
} FMDRESULT, *PFMDRESULT;


@interface Detection : NSObject
@property(assign,nonatomic)bool canDetect;

-(instancetype)initWithDetectionType:(MagicDetectionType)detectionType;

- (FMDRESULT)processImageFrame:(LPYUVFrame)imageFrame;
- (void)destory;
@end
