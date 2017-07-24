//
//  EffectPool.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/5.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "EffectPool.h"

@implementation EffectPool
- (instancetype)init{
    self = [super init];
    if (self) {
        mEffectPool = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)loadEffect{
    
}

- (NSMutableArray *)getEffectPool{
    return mEffectPool;
}
@end
