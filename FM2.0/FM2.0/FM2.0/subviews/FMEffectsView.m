//
//  FMEffectsView.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/4.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "FMEffectsView.h"
#import "EffectsCollectionViewCell.h"
#import "EffectPool.h"
#define PADDING 20
#define ROWCELLNUM 5
static NSString *const cellID = @"effectcell";
@interface FMEffectsView() <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *mCollectionView;
    CGFloat           mCellWidth;
    CGFloat           mCellHeight;
    NSMutableArray   *mEffectsArray;
    EffectPool       *mCurrentEffectPool;
}
@end

@implementation FMEffectsView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.2];
        [self initilizeCollectionView];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.2];
        mEffectsArray = [[NSMutableArray alloc]init];
        [self initilizeCollectionView];
    }
    return self;
}

- (void)setEffectPool:(EffectPool *)effectPool{
    if (effectPool && mCurrentEffectPool != effectPool) {
        mCurrentEffectPool = effectPool;
        mEffectsArray = [[NSMutableArray alloc]initWithArray:[mCurrentEffectPool getEffectPool]];
    }
}

- (void)reload{
    [mCollectionView reloadData];
//    if (mEffectsArray && mEffectsArray.count > 0) {
//        NSString *t_firstName = mEffectsArray[0];
//        if ([t_firstName isEqualToString:@"cleareffect"]) {
//            NSIndexPath *t_indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//            [self didSelectIndexPath:t_indexPath];
//        }
//    }
}

- (void)didSelectIndexPath:(NSIndexPath *)indexPath{
    if (indexPath == nil) {
        return;
    }
    [mCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:mCollectionView didSelectItemAtIndexPath:indexPath];
}

- (void)unDidSelectIndexPath:(NSIndexPath *)indexPath{
    if (indexPath == nil) {
        return;
    }
    [mCollectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self collectionView:mCollectionView didDeselectItemAtIndexPath:indexPath];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)initilizeCollectionView
{
    mCellWidth = (self.bounds.size.width - (ROWCELLNUM - 1)*PADDING) / ROWCELLNUM;
    mCellHeight = mCellWidth;
    UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    mCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:customLayout];
    mCollectionView.backgroundColor = [UIColor clearColor];
    mCollectionView.dataSource = self;
    mCollectionView.delegate = self;
    [self addSubview:mCollectionView];
    // 注册cell、sectionHeader、sectionFooter
    UINib *cellNib = [UINib nibWithNibName:@"EffectsCollectionViewCell" bundle:nil];
    [mCollectionView registerNib:cellNib forCellWithReuseIdentifier:cellID];
//    [mCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
//    [mCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
//    [mCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
}


#pragma mark ---- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return mEffectsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EffectsCollectionViewCell *cell = [mCollectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSString *effectName = mEffectsArray[indexPath.item];
    cell.title.text = effectName;
    if ([effectName isEqualToString:@"cleareffect"]) {
        cell.effectIconImageView.image = [UIImage imageNamed:@"cleareffect"];
    }else{
        cell.effectIconImageView.image = nil;
    }
    if (_currentIndexPath && _currentIndexPath == indexPath) {
        cell.selected = YES;
    }else{
        cell.selected = NO;
    }
    if (cell.isSelected) {
        [cell showBorder];
    }else{
        [cell hideBorder];
    }
    return cell;
}

#pragma mark ---- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *t_effectname = mEffectsArray[indexPath.item];
    if (!t_effectname) {
        return;
    }
    if (mCurrentEffectPool.kind == INTERNAL) {
        NSString *t_effectpath = [[NSBundle mainBundle] pathForResource:t_effectname ofType:@"bundle"];
        if (self.getEffectPath) {
            self.getEffectPath(t_effectpath);
        }
    }else if (mCurrentEffectPool.kind == NET){
        
    }
    EffectsCollectionViewCell *cell = (EffectsCollectionViewCell *)[mCollectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    _currentIndexPath = indexPath;
    [cell showBorder];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    EffectsCollectionViewCell *cell = (EffectsCollectionViewCell *)[mCollectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;
    _currentIndexPath = nil;
    [cell hideBorder];
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){mCellWidth,mCellHeight};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return (CGSize){ScreenWidth,44};
//}
//
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return (CGSize){ScreenWidth,22};
//}

@end
