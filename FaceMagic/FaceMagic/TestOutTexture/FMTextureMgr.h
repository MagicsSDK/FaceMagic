//
//  FMTextureMgr.h
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2017/2/6.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMTexture.h"
@interface FMTextureMgr : NSObject
+ (instancetype)shareInst;
- (void)destory;
- (void)pushTexture:(FMTexture *)texture;
- (void)removeTexture:(FMTexture *)texture;
- (void)removeAllTextures;
- (FMTexture*)getTextureWithName:(NSString *)textureName;
@end
