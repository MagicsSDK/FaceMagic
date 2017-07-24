//
//  EffectsCollectionViewCell.h
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/4.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EffectIconImageView.h"
@interface EffectsCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet EffectIconImageView *effectIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
- (void)showBorder;
- (void)hideBorder;
@end
