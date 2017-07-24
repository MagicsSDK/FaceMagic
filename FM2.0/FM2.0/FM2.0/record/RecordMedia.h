//
//  SaveMedia.h
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/6.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VideoData;
@interface RecordMedia : NSObject
{
    VideoData *mVideoData;
}
- (void)setVideoData:(VideoData *)videoData;
@end
