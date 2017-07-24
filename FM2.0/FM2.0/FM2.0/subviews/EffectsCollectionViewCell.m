//
//  EffectsCollectionViewCell.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/4.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "EffectsCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation EffectsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.effectIconImageView initialize];
}

- (void)showBorder{
    [self.effectIconImageView showBorder];
}

- (void)hideBorder{
    [self.effectIconImageView hideBorder];
}
@end
