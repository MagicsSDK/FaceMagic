//
//  EffectsBackView.h
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/12.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SetEffectPath)(NSString *effectpath);
@interface EffectsBackView : UIView
- (void)updateEffectsViewArray:(NSArray *)array;
@property(copy,nonatomic)SetEffectPath setEffectPath;
@end
