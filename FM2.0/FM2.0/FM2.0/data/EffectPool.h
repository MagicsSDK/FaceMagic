//
//  EffectPool.h
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/5.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <Foundation/Foundation.h>
enum EffectKind {
    INTERNAL = 1,
    NET
};
@interface EffectPool : NSObject
{
    @public
    NSMutableArray *mEffectPool;
}
@property(assign,nonatomic)enum EffectKind kind;
- (void)loadEffect;
- (NSMutableArray *)getEffectPool;
@end
