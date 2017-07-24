//
//  FMEffectsView.h
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/4.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GetEffectPath)(NSString *effectpath);
@class EffectPool;
@interface FMEffectsView : UIView
@property(copy,nonatomic)GetEffectPath getEffectPath;
@property(strong,nonatomic)NSIndexPath *currentIndexPath;
- (void)setEffectPool:(EffectPool *)effectPool;
- (void)reload;
- (void)didSelectIndexPath:(NSIndexPath *)indexPath;
- (void)unDidSelectIndexPath:(NSIndexPath *)indexPath;
@end
