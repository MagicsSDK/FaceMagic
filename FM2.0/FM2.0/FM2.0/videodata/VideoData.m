//
//  VideoData.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/6.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "VideoData.h"
@interface VideoData()
{
    unsigned char *databuffer;
    int            bufferLen;
    int            videoWidth;
    int            videoHeight;
    
}
@end

@implementation VideoData
- (instancetype)initWith:(FMPixelFormat)format width:(int)width height:(int)height{
    self = [super init];
    if (self) {
//        if (format == FMPixelFormatNV12 || format == FMPixelFormatYUV420V) {
//            bufferLen = width*height*3/2;
//        }else{
//            bufferLen = width*height*4;
//        }
        if ( format == FMPixelFormatYUV420V) {
            bufferLen = width*height*3/2;
        }else{
            bufferLen = width*height*4;
        }
        videoWidth = width;
        videoHeight = height;
        databuffer = malloc(bufferLen);
    }
    return self;
}

- (void)setBuffer:(unsigned char *)buffer{
    memcpy(databuffer, buffer, bufferLen);
}

- (unsigned char *)getDataBuffer{
    return databuffer;
}

- (int)getDataWidth{
    return videoWidth;
}

- (int)getDataHeight{
    return videoHeight;
}

- (void)destory{
    if (databuffer) {
        free(databuffer);
    }
}
@end
