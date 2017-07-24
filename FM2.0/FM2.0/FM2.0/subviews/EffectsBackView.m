//
//  EffectsBackView.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/12.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "EffectsBackView.h"
#import "FMEffectsView.h"
#import "InternalEffectPool.h"
@interface EffectsBackView()<UIScrollViewDelegate>{
    UIScrollView *mScrollView;
    NSMutableArray *effectsViewArray;
    FMEffectsView  *mCurrentEffectsView;
    FMEffectsView  *mLastEffectsView;
}
@end
@implementation EffectsBackView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        mScrollView.backgroundColor = [UIColor clearColor];
        mScrollView.showsHorizontalScrollIndicator = NO;
        mScrollView.showsVerticalScrollIndicator = NO;
        mScrollView.pagingEnabled = YES;
        mScrollView.delegate = self;
        [self addSubview:mScrollView];
    }
    return self;
}

- (void)updateEffectsViewArray:(NSArray *)array{
    if (!array || array.count == 0) {
        return;
    }
    effectsViewArray = [[NSMutableArray alloc]init];
    mScrollView.contentSize = CGSizeMake(self.bounds.size.width * array.count, self.bounds.size.height);
    [[mScrollView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    mLastEffectsView = nil;
    for (int i = 0; i < array.count; i ++) {
        FMEffectsView *effectView = [[FMEffectsView alloc]initWithFrame:CGRectMake(i * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        effectView.backgroundColor = [UIColor grayColor];
        [mScrollView addSubview:effectView];
        [effectsViewArray addObject:effectView];
        InternalEffectPool *internalPool = [InternalEffectPool new];
        [internalPool loadEffect];
        [effectView setEffectPool:internalPool];
        [effectView reload];
    }
    mCurrentEffectsView = effectsViewArray[0];
    [mCurrentEffectsView didSelectIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (mCurrentEffectsView) {
        __weak EffectsBackView *weakSelf = self;
        mCurrentEffectsView.getEffectPath = ^(NSString *effectpath) {
            if (weakSelf.setEffectPath) {
                weakSelf.setEffectPath(effectpath);
            }
        };
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取滚动位置
    //页码
    int pageNo= scrollView.contentOffset.x/scrollView.frame.size.width;
    if (pageNo >= 0 && pageNo < effectsViewArray.count) {
        mLastEffectsView = mCurrentEffectsView;
        mCurrentEffectsView = effectsViewArray[pageNo];
    }
    if (mCurrentEffectsView) {
        __weak EffectsBackView *weakSelf = self;
        __weak FMEffectsView   *weakEffectsView = mLastEffectsView;
        mCurrentEffectsView.getEffectPath = ^(NSString *effectpath) {
            if (weakSelf.setEffectPath) {
                if (weakEffectsView && weakEffectsView.currentIndexPath) {
                    [weakEffectsView unDidSelectIndexPath:weakEffectsView.currentIndexPath];
                }
                weakSelf.setEffectPath(effectpath);
            }
        };
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
