//
//  NetEffectPool.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/5.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "NetEffectPool.h"

@implementation NetEffectPool
- (instancetype)init{
    self = [super init];
    if (self) {
        self.kind = NET;
    }
    return self;
}
@end
