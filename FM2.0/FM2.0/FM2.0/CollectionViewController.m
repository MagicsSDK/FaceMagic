//
//  CollectionViewController.m
//  FM2.0
//
//  Created by 刘铭 on 2017/7/17.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "CollectionViewController.h"
#import <MagicStickerStore/MagicBaseProtocol.h>
#import <sys/xattr.h>
#import "SSZipArchive.h"

#import "MagicParse.h"


#define SCREEN_FRAME ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface MagicEffectCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *coverImageV;

@property (nonatomic, strong) UIImageView *downLoadImageV;

@property (nonatomic, assign) BOOL isLoading;
- (void)refreshCellWithData:(NSDictionary *)data;

@end

@implementation MagicEffectCell

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

@interface CollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    // 承载 effect
    UIScrollView *_contentScrollView;
    // title SCrollView
    UIScrollView *_titleScrollView;
    // 顶部分类数组
    NSMutableArray* _titleArrays;
    
    NSMutableDictionary *_categoryDic;


}

@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化 解析
    

    
    
    _titleArrays = [NSMutableArray array];
    _categoryDic = [NSMutableDictionary dictionary];
    
    [self initUI];
    
//    [MagicBaseProtocol registerNetWorkWithClinetID:@"ihb1Fh+TRTZKhCQ5REcNww==" andClientSecret:@"F6gcI8Kxaz06ujZkDgGzGmDdPey29iC2DbtDYpj5rm6yPzwH9xwQIAyZJYEhq6imFimPdkR+h1zaoJpV54RyIg==" success:^(id responseObject) {
//        NSLog(@"初始化结果😤😈😤😈😤😈😤😈😤😈😤😈 ===== %@",responseObject);
//        //        [self getData];
//        [self getCatgray];
//    } failure:^(NSError *error) {
//        NSLog(@"");
//    }];
    // self.clearsSelectionOnViewWillAppear = NO;
    // Do any additional setup after loading the view.
}

- (void)getCatgray{
    [MagicBaseProtocol getMaigicStickerAllCategorySortField:OrderingTypeId andSortOrder:OrderingTypeDesc Success:^(id responseObject) {
        NSArray *array = responseObject[@"entities"];
        for (NSDictionary *cate in array) {
            NSDictionary *info = @{
                                   @"id" : cate[@"id"],
                                    @"name" : cate[@"name"],
                                   @"num"  : cate[@"number"]
                                   };
            [_titleArrays addObject:info];
            
            NSArray *contents = cate[@"spines"];
            [_categoryDic setObject:contents forKey:cate[@"id"]];
        }
        [self refreshBackView];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getDataWithID:(NSString *)cateID andPage:(NSString *)page andPageSize:(NSString *)pageSize{
    [MagicBaseProtocol getAppointCategoryWithID:cateID andPage:page andPageSize:pageSize success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self downloadEffectWithSource:@"laladui.zip"];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)downloadEffectWithSource:(NSString *)source {
    NSString *zipStr = [self getFullFilePathInDocuments:@"/ZipMineStickers" fileName:@"diyige"];
    [MagicBaseProtocol downloadStickerZipWithName:source andSavePath:zipStr networkingDownloadProgress:^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        NSLog(@"%lld, %lld, %lld",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    } success:^(id responseObject) {
        NSLog(@"下载返回值===== %@",responseObject);
        NSString *unZipPath = [self getFullFilePathInDocuments:@"/UnZipMineStickers" fileName:@"diyige"];
        BOOL sucess = [SSZipArchive unzipFileAtPath:zipStr toDestination:unZipPath];
        NSString* folderName = [self getDataFile:unZipPath];
        unZipPath = [unZipPath stringByAppendingFormat:@"/%@",folderName];
        NSLog(@"");
    } failure:^(NSError *error) {
        NSLog(@"下载失败返回值===== %@",error);
    }];
}

- (void)initUI{
#if 1
    
#elif 2
   
#elif 3
    
#else
    
#endif

    //承载魔贴View
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
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

- (void)refreshBackView{
    _titleScrollView.contentSize = CGSizeMake(_titleArrays.count *SCREEN_WIDTH/6, 0);
    
    for (int i = 0; i < _titleArrays.count ; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6 *i, 0, SCREEN_WIDTH/6, _titleScrollView.frame.size.height)];
        [btn setTitle:_titleArrays[i][@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(changeCatg:) forControlEvents:UIControlEventTouchUpOutside];
        [_titleScrollView addSubview:btn];
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 11;//行
        layout.minimumInteritemSpacing = 28;//cell间距
        //        layout.sectionInset = UIEdgeInsetsMake(14, 25, 14, 25);
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, _contentScrollView.frame.size.height ) collectionViewLayout:layout];
        collectionView.tag = 1000 + i;
        collectionView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[MagicEffectCell class] forCellWithReuseIdentifier:@"MagicSecondToolBarCell"];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.bounces = NO;
        [_contentScrollView addSubview:collectionView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
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
