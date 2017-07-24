//
//  CollectionViewController.m
//  FM2.0
//
//  Created by 刘铭 on 2017/7/17.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "MagicLocalVC.h"
#import <MagicStickerStore/MagicBaseProtocol.h>
#import <sys/xattr.h>
#import "SSZipArchive.h"

#import "MagicParse.h"


#define SCREEN_FRAME ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface MagicLocalEffectCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *coverImageV;

@property (nonatomic, strong) UIImageView *downLoadImageV;

@property (nonatomic, assign) BOOL isLoading;
- (void)refreshCellWithData:(NSDictionary *)data;

@end

@implementation MagicLocalEffectCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.isLoading = NO;
        [self.contentView addSubview:self.coverImageV];
        [self.contentView addSubview:self.downLoadImageV];
        
        //        [self.contentView addSubview:self.loadView];
        //        [self.contentView addSubview:self.activityView];
    }
    return self;
}

- (void)refreshCellWithData:(NSDictionary *)data{
    
}

- (UIImageView *)coverImageV
{
    if (!_coverImageV) {
        _coverImageV = [[UIImageView alloc] initWithFrame:self.bounds];
        _coverImageV.contentMode = UIViewContentModeScaleAspectFit;
//        _coverImageV.image = 
    }
    return _coverImageV;
}

- (UIImageView *)downLoadImageV
{
    if (!_downLoadImageV) {
        _downLoadImageV = [[UIImageView alloc] initWithFrame:self.bounds];
        _downLoadImageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _downLoadImageV;
}

@end

@interface MagicLocalVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UISlider *m_slider;
    
    // 承载 effect
    UIScrollView *_contentScrollView;
    // title SCrollView
    UIScrollView *_titleScrollView;
    // 顶部分类数组
    NSMutableArray *_titleArrays;
    
    NSMutableArray *_categoryArray;
    
    UIImageView *btn_imageView;
    
    UIImageView *cell_imageView;
    
    UIButton *click_btn;
}

@end

@implementation MagicLocalVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    // 初始化 解析
    MagicParse *pares = [MagicParse new];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"magic_cfg.json" ofType:nil];
    NSArray *array = [pares loadJsonWithPath:path];
    
    _titleArrays = [NSMutableArray array];
    _categoryArray = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        NSDictionary *info = @{
                               @"id" : dic[@"id"],
                               @"name" : dic[@"name"],
                               @"isSlider" : dic[@"isSlider"]
                               };
        [_titleArrays addObject:info];
        [_categoryArray addObject:dic[@"value"]];
    }
    
    [self refreshBackView];
    
}


- (void)initUI{
    
    m_slider = [[UISlider alloc]initWithFrame:CGRectMake(20,0, self.view.frame.size.width-40, 40)];
    m_slider.minimumValue = 0.0;
    m_slider.maximumValue = 0.8;
    m_slider.value = 0;
    [m_slider addTarget:self action:@selector(sliderEvent:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:m_slider];
    //承载魔贴View
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 150)];
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.scrollEnabled = NO;
    _contentScrollView.bounces = NO;
    _contentScrollView.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.6];
    //    _contentScrollView.backgroundColor = [UIColor redColor];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.contentSize = CGSizeMake( 1 * SCREEN_WIDTH , 0);
    [self.view addSubview:_contentScrollView];
    
    _titleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,  _contentScrollView.frame.origin.y + _contentScrollView.frame.size.height, SCREEN_WIDTH, 50)];
    _titleScrollView.userInteractionEnabled = YES;
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.showsVerticalScrollIndicator = NO;
    _titleScrollView.scrollEnabled = NO;
    _titleScrollView.bounces = NO;
    _titleScrollView.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:0.8];
    //    _titleScrollView.backgroundColor = [UIColor yellowColor];
    _titleScrollView.delegate = self;
    _titleScrollView.pagingEnabled = YES;
    
    [self.view addSubview:_titleScrollView];
    
}

- (void)sliderEvent:(UISlider *)slider{
    if (click_btn.tag == 0) {
        [self.delegate setIntentityValue:slider.value];
    }else{
        [self.delegate setSlimStrengthValue:slider.value];
    }
}

- (void)refreshBackView{
    NSUInteger titleCount = _titleArrays.count;
    
    _titleScrollView.contentSize = CGSizeMake(_titleArrays.count *SCREEN_WIDTH/titleCount, 0);
    _contentScrollView.contentSize = CGSizeMake(_titleArrays.count *SCREEN_WIDTH, 0);
    
    
    float itemWidth = (SCREEN_WIDTH - 25*2 - 20 * 4)/5;
    
    btn_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50 - 5, SCREEN_WIDTH/titleCount, 5)];
    btn_imageView.image = [UIImage imageNamed:@"select"];
    
    cell_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
    cell_imageView.image = [UIImage imageNamed:@"round_selected_ic"];
    
    for (int i = 0; i < _titleArrays.count ; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/titleCount *i, 0, SCREEN_WIDTH/titleCount, _titleScrollView.frame.size.height)];
        [btn setTitle:_titleArrays[i][@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(changeCatg:) forControlEvents:UIControlEventTouchUpInside];
        [_titleScrollView addSubview:btn];
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 11;//行
        layout.minimumInteritemSpacing = 28;//cell间距
        layout.sectionInset = UIEdgeInsetsMake(14, 25, 14, 25);
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, _contentScrollView.frame.size.height ) collectionViewLayout:layout];
        collectionView.tag = 1000 + i;
        collectionView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[MagicLocalEffectCell class] forCellWithReuseIdentifier:reuseIdentifier];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.bounces = NO;
        [_contentScrollView addSubview:collectionView];
        
        [collectionView reloadData];
    }
    UIButton *selctBtn = [_titleScrollView viewWithTag:0];
    [self changeCatg:selctBtn];
    
}


- (void)changeCatg:(UIButton *)btn{
    click_btn = btn;
    if (btn.tag == 0 || btn.tag == 1) {
        m_slider.hidden = NO;
        m_slider.value = 0.0;
    }else{
        m_slider.hidden = YES;
    }
    [btn_imageView removeFromSuperview];
    [_contentScrollView setContentOffset:CGPointMake(btn.tag * SCREEN_WIDTH, 0)  animated:YES];
    [btn addSubview:btn_imageView];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *cells = _categoryArray[collectionView.tag - 1000];
    return cells.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MagicLocalEffectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.coverImageV.image = [UIImage imageNamed:@"clean_magic_ic"];
    }else{
        cell.coverImageV.image = [UIImage imageNamed:@"default_circle_ic"];
    }
//    cell.backgroundColor = [UIColor redColor];
    // Configure the cell
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [cell_imageView removeFromSuperview];
    MagicLocalEffectCell *cell = (MagicLocalEffectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell addSubview:cell_imageView];
    
    if (indexPath.row == 0) {
        [self.delegate cleanEffect];
    }else{
        
        NSString *name = _categoryArray[collectionView.tag - 1000][indexPath.row - 1];
        NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:nil];
        [self.delegate setEffectWithPath:path];
    }
    NSLog(@"");
}

- (NSString*)getDataFile:(NSString*)path
{
    NSString* pathStr;
    NSError* error;
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray  *arr = [fm  contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        pathStr = nil;
    }else{
        for (NSString* name in arr) {
            pathStr = name;
        }
    }
    return pathStr;
}

//获取完整的文件路径
- (NSString *)getFullFilePathInDocuments:(NSString *)subFilePath fileName:(NSString *)fileName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents%@", NSHomeDirectory(), subFilePath];
    //    NSLog(@"function:%s,getFilePath %@", __FUNCTION__,filePath);
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        return [NSString stringWithFormat:@"%@/%@", filePath, fileName];
    }
    if ([fm createDirectoryAtPath:filePath
      withIntermediateDirectories:YES
                       attributes:nil
                            error:nil])
    {
        u_int8_t b = 1;
        setxattr([filePath fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
        return [NSString stringWithFormat:@"%@/%@", filePath, fileName];
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
