//
//  SaveImage.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/6.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "RecordImage.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "VideoData.h"
@implementation RecordImage
- (void)saveImageToPhoto
{
    if (!mVideoData) {
        return;
    }
    UIImage *savedImage = [self yuvToImage:[mVideoData getDataBuffer] w:[mVideoData getDataWidth] h:[mVideoData getDataHeight]];
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.saveImageResult) {
            self.saveImageResult(msg);
        }
    });
   
}

- (UIImage *)yuvToImage:(unsigned char *)plane0 w:(int)w h:(int)h
{
    //YUV(NV12)-->CIImage--->UIImage Conversion
    NSDictionary *pixelAttributes = @{(id)kCVPixelBufferIOSurfacePropertiesKey : @{}};
    CVPixelBufferRef pixelBuffer = NULL;
    CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
                                          w,
                                          h,
                                          kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
                                          (__bridge CFDictionaryRef)(pixelAttributes),
                                          &pixelBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer,0);
    unsigned char *yDestPlane = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    memcpy(yDestPlane, plane0, w * h); //Here y_ch0 is Y-Plane of YUV(NV12) data.
    unsigned char *uvDestPlane = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    memcpy(uvDestPlane, plane0 + w * h, w * h / 2); //Here y_ch1 is UV-Plane of YUV(NV12) data.
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    if (result != kCVReturnSuccess) {
        NSLog(@"Unable to create cvpixelbuffer %d", result);
    }
    CIImage *coreImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];//CIImage Conversion DONE!!!!
    CIContext *MytemporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef MyvideoImage = [MytemporaryContext
                               createCGImage:coreImage
                               fromRect:CGRectMake(0, 0,
                                                   w,
                                                   h)];
    UIImage *Mynnnimage = [[UIImage alloc] initWithCGImage:MyvideoImage scale:1.0 orientation:UIImageOrientationUp];//UIImage Conversion DONE!!!
    CVPixelBufferRelease(pixelBuffer);
    CGImageRelease(MyvideoImage);
    return Mynnnimage;
}
@end
