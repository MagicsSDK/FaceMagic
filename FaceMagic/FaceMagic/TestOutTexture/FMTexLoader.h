//
//  FMTexLoader.h
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/28.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <UIKit/UIKit.h>
#import "FMTexture.h"
@interface FMTexLoader : NSObject
+ (FMTexture *)createTextureWithImagePath:(NSString *)imagePath;
+ (FMTexture *)createRGBATexture:(unsigned char*)pixels Width:(int)width Height:(int)height Name:(NSString*)name;
@end
