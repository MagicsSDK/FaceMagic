//
//  FMParameterGlobal.m
//  FaceMagicDemo
//
//  Created by 李晓帆 on 2016/11/15.
//  Copyright © 2016年 李晓帆. All rights reserved.
//

#import "FMParameterGlobal.h"

@implementation FMParameterGlobal
static FMParameterGlobal* m_Inst;
static dispatch_once_t onceToken;
+ (instancetype)shareInst {
    
    dispatch_once(&onceToken, ^{
        m_Inst = [[self alloc]init];
    });
    return m_Inst;
    
}
- (void)destory {
    onceToken = 0;
    m_Inst = nil;
}
- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.m_Width = 720;
        self.m_Height = 1280;
    }
    return self;
}
@end
