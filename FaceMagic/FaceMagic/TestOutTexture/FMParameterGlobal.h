//
//  FMParameterGlobal.h
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/15.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMParameterGlobal : NSObject
@property (assign,nonatomic)int m_Width;
@property (assign,nonatomic)int m_Height;
+ (instancetype)shareInst;
- (void)destory;
@end
