//
//  SaveImage.h
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/6.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "RecordMedia.h"
@class VideoData;
typedef  void(^SaveImageResult)(NSString *msg);
@interface RecordImage : RecordMedia
@property(copy,nonatomic)SaveImageResult saveImageResult;
- (void)saveImageToPhoto;
@end
