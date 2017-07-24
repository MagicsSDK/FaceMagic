//
//  MagicLocalVC.h
//  FM2.0
//
//  Created by 刘铭 on 2017/7/21.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MagicLocalVCSelecteDelegate <NSObject>

- (void)cleanEffect;

- (void)setEffectWithPath:(NSString *)path;

- (void)setIntentityValue:(float)value;

- (void)setSlimStrengthValue:(float)value;
@end

@interface MagicLocalVC : UIViewController

@property (nonatomic, weak) id <MagicLocalVCSelecteDelegate> delegate;

@end
