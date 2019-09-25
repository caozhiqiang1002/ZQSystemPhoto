//
//  ZQPhotoDetailBaseController.m
//  ZQSystemPhoto
//
//  Created by caozhiqiang on 2019/9/9.
//

#import "ZQPhotoDetailBaseController.h"

#import "ZQPhotoManager.h"
#import "ZQDataSource.h"
#import "ZQPhotoAlbumManager.h"

@interface ZQPhotoDetailBaseController ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) ZQDataSource *dataSource;
@end

@implementation ZQPhotoDetailBaseController

- (void)dealloc {
    [[ZQPhotoManager sharedInstance] stopCaches:[ZQPhotoAlbumManager sharedInstance].config.wholeAssets
                                      assetSize:ZQPhotoBigSize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self createDataSource];
    [self createCollectionView];
    [self configCellInfo];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Create UI

- (void)createDataSource {
    @zq_weakify(self);
    ZQDataSourceCompletion completion = ^(id item, NSIndexPath *indexPath, id cell){
        [[ZQPhotoManager sharedInstance] getSmallImageInfo:item
                                                      size:ZQPhotoBigSize
                                                   handler:^(UIImage *image, NSDictionary *imageInfo) {
            @zq_strongify(self);
            [self getImage:image indexPath:indexPath cell:cell];
        }];
    };
    
    self.dataSource = [ZQDataSource dataSourceWithCellID:self.cellIdentifer
                                               cellClass:NSClassFromString(self.cellClassName)
                                                delegate:nil
                                              completion:completion];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    layout.minimumInteritemSpacing = 0.0f;
    layout.minimumLineSpacing = 0.0f;
    layout.sectionInset = UIEdgeInsetsZero;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                             collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = ZQUIColorFromHex(0x000000);
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
}

#pragma mark - Public

- (void)getPhotoListData {
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    
    [[ZQPhotoManager sharedInstance] startCaches:config.wholeAssets assetSize:ZQPhotoBigSize];
    
    [self.dataSource updateData:config.wholeAssets];
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:config.indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
}


@end
