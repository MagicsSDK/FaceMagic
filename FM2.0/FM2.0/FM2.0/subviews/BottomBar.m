//
//  BottomBar.m
//  FM2.0
//
//  Created by 李晓帆 on 2017/7/11.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "BottomBar.h"
#import "BottomTableViewCell.h"
@interface BottomBar ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *effectKindArray;
    UITableView *mTableView;
}
@end;
@implementation BottomBar
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.12 green:0.07 blue:0.07 alpha:0.5];
        [self initializeTableView:frame];
    }
    return self;
}

- (void)initializeTableView:(CGRect)frame{
    CGFloat t_oldX = 0, t_oldY = 0, t_oldW = frame.size.height, t_oldH = frame.size.width;
    CGFloat t_newX = 0, t_newY = t_oldW, t_newW = t_oldH, t_newH = t_oldW;
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(t_oldX, t_oldY, t_oldW, t_oldH) style:UITableViewStylePlain];
    //铆钉点0，0
    mTableView.layer.anchorPoint = CGPointMake(0, 0);
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.scrollsToTop = NO;
    mTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    mTableView.showsVerticalScrollIndicator = NO;
    mTableView.pagingEnabled = YES;
    mTableView.bounces = NO;
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.frame = CGRectMake(t_newX, t_newY, t_newW, t_newH);
    [self addSubview:mTableView];
}

- (void)updateEffectKinds:(NSArray *)effectsKind{
    effectKindArray = [[NSMutableArray alloc]initWithArray:effectsKind];
    [mTableView reloadData];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return effectKindArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BottomTableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:@"BottomTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BottomTableViewCell" owner:nil options:nil] lastObject];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.IconImageView.backgroundColor = [UIColor clearColor];
    NSString *title = effectKindArray[indexPath.row];
    cell.iconTitle.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
