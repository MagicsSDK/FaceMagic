//
//  FMEffectsBackgroundView.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/5.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "FMEffectsBackgroundView.h"
#import "FMEffectsView.h"
#import "BottomBar.h"
#import "EffectsBackView.h"
#import "InternalEffectPool.h"
@interface FMEffectsBackgroundView()<UIGestureRecognizerDelegate>
{
    BottomBar          *mBottomBar;
    EffectsBackView    *mEffectBackView;
}
@end
@implementation FMEffectsBackgroundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init{
    self = [super init];
    if (self) {
        self.isShow  = false;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = true;
        
        [self initializeTapGestureRecognizer];
        [self initializeBottomBar];
        [self initializeBackScrollView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.isShow = false;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = true;
        [self initializeTapGestureRecognizer];
        [self initializeBottomBar];
        [self initializeBackScrollView];
    }
    return self;
}

- (void)initializeTapGestureRecognizer{
    //创建手势对象
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    //配置属性
    //轻拍次数
    tap.numberOfTapsRequired =1;
    //轻拍手指个数
    tap.numberOfTouchesRequired =1;
    //
    tap.delegate = self;
    //讲手势添加到指定的视图上
    [self addGestureRecognizer:tap];
}

//轻拍事件
//隐藏
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.tapEvent) {
        self.tapEvent();
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return true;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *t_touchView = touch.view;
    if ([NSStringFromClass([t_touchView class]) isEqualToString:@"FMEffectsBackgroundView"]) {
        return true;
    }
    return false;
}

- (void)show{
    [UIView animateWithDuration:0.2f animations:^{
        self.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            self.isShow = true;
        }
    }];
}

- (void)hidden{
    [UIView animateWithDuration:0.2f animations:^{
        self.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            self.isShow = false;
        }
    }];
}

- (void)initializeBackScrollView{
    mEffectBackView = [[EffectsBackView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 200 - 40, self.bounds.size.width, 200)];
    NSArray *array = [[NSArray alloc]initWithObjects:@"本地",nil];
    [mEffectBackView updateEffectsViewArray:array];
    [self addSubview:mEffectBackView];
    __weak FMEffectsBackgroundView *weakSelf = self;
    mEffectBackView.setEffectPath = ^(NSString *effectpath) {
        if (weakSelf.getEffectPath) {
            weakSelf.getEffectPath(effectpath);
        }
    };
}

- (void)initializeBottomBar{
    NSArray *kind = [[NSArray alloc]initWithObjects:@"本地", nil];
    mBottomBar = [[BottomBar alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 40)];
    [self addSubview:mBottomBar];
     [mBottomBar updateEffectKinds:kind];
}
@end
