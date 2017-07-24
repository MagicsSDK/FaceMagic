//
//  VideoData.h
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/6.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MKEngine/FM2.h>
@interface VideoData : NSObject
- (instancetype)initWith:(FMPixelFormat)format width:(int)width height:(int)height;
- (void)setBuffer:(unsigned char *)buffer;
- (unsigned char *)getDataBuffer;
- (int)getDataWidth;
- (int)getDataHeight;
- (void)destory;
@end
