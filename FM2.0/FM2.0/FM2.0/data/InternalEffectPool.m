//
//  InternalEffectPool.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/5.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "InternalEffectPool.h"

@implementation InternalEffectPool
- (instancetype)init{
    self = [super init];
    if (self) {
        self.kind = INTERNAL;
    }
    return self;
}

- (void)loadEffect{
    [super loadEffect];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"internaleffects" ofType:@"plist"];
    NSArray *data = [[NSArray alloc] initWithContentsOfFile:plistPath];
    if (data) {
         [mEffectPool addObjectsFromArray:data];
    }
}
@end
