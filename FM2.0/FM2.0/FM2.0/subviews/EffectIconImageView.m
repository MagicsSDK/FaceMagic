//
//  EffectIconImageView.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/5.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "EffectIconImageView.h"

@implementation EffectIconImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)initialize{
    UIImageView *imageView = self;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.layer.borderWidth = 1.5f;
    imageView.layer.borderColor = [UIColor clearColor].CGColor;
    imageView.layer.cornerRadius = 5.0f;
//    圆角
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//    maskLayer.strokeColor = [UIColor greenColor].CGColor;
//    //设置大小
//    maskLayer.frame = imageView.bounds;
//    //设置图形样子
//    maskLayer.path = maskPath.CGPath;
//    imageView.layer.mask = maskLayer;
    
}

- (void)showBorder{
    self.layer.borderColor = [UIColor greenColor].CGColor;
}

- (void)hideBorder{
    self.layer.borderColor = [UIColor clearColor].CGColor;
}

@end
