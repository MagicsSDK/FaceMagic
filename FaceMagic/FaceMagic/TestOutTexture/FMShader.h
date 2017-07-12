//
//  FMShader.h
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/15.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMShader : NSObject
+ (instancetype)shareInst;
- (void)destory;
- (void)initializeAllShaders;
- (int)getProgramme:(NSString *)programmeName;
@end
