//
//  FMEffectsBackgroundView.h
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/5.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^TapEvent)();
typedef void(^GetEffectPath)(NSString *effectpath);
@interface FMEffectsBackgroundView : UIView
@property(assign,nonatomic)BOOL isShow;
@property(copy,nonatomic)TapEvent tapEvent;
@property(copy,nonatomic)GetEffectPath getEffectPath;
- (void)show;
- (void)hidden;
@end
