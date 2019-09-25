//
//  ZQPhotoListBaseController.m
//  ZQSystemPhoto
//
//  Created by caozhiqiang on 2019/9/9.
//

#import "ZQPhotoListBaseController.h"
#import "ZQPhotoDetailController.h"
#import "ZQPhotoAlbumController.h"

#import "ZQDataSource.h"
#import "ZQPhotoManager.h"
#import "ZQCommonView.h"

static NSString * const ZQ_Photo_HeaderID = @"Photo_HeaderID";
static NSString * const ZQ_Photo_FooterID = @"Photo_FooterID";

@interface ZQPhotoListBaseController ()<UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, ZQDataSourceDelegate, ZQNavigationViewDelegate>
@property (nonatomic, strong) ZQNavigationView *navigationView;

@property (nonatomic, strong) ZQDataSource *dataSource;
@property (nonatomic, assign) CGRect previousPreheatRect;
@end

@implementation ZQPhotoListBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self createDataSource];
    [self createCollectionView];
    [self createNavigationView];
    [self configCellInfo];
    [self getPhotoListData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

#pragma mark - Create UI

- (void)createDataSource {
    @zq_weakify(self);
    ZQDataSourceCompletion completion = ^(id item, NSIndexPath *indexPath, id cell) {
        [[ZQPhotoManager sharedInstance] getSmallImageInfo:item
                                                      size:ZQPhotoSmallSize
                                                   handler:^(UIImage *image, NSDictionary *imageInfo) {
            @zq_strongify(self);
            [self getImage:image indexPath:indexPath cell:cell];
        }];
    };
    
    self.dataSource = [ZQDataSource dataSourceWithCellID:self.cellIdentifer
                                               cellClass:NSClassFromString(self.cellClassName)
                                                delegate:self
                                              completion:completion];
}

- (void)createCollectionView {
    ZQPhotoItemConfig *config = [ZQPhotoManager sharedInstance].config;
    CGFloat cellWidth = (kScreenWidth-config.sectionSpace*2-config.itemSpace*(config.itemCount-1))/config.itemCount;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(cellWidth, cellWidth);
    layout.minimumLineSpacing = config.itemSpace;
    layout.minimumInteritemSpacing = config.itemSpace;
    layout.sectionInset = UIEdgeInsetsMake(config.sectionSpace, config.sectionSpace, config.sectionSpace, config.sectionSpace);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                             collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
}

- (void)createNavigationView {
    self.navigationView = [ZQNavigationView navigationViewWithType:ZQNavigationViewTypeLeftImage | ZQNavigationViewTypeRightText
                                                             title:self.model.title ?: @"所有照片"
                                                          delegate:self];
    [self.navigationView setSubTitles:@[@"取消"]];
    [self.navigationView setSubImages:@[@"back_black"]];
    self.navigationView.backgroundColor = ZQUIColorAFromHex(0xf0f0f0, 0.8);
    [self.view addSubview:self.navigationView];
}

#pragma mark - Initialized Data

- (void)getPhotoListData {
    @zq_weakify(self);
    [[ZQPhotoAlbumManager sharedInstance] requestAuthorization:^(BOOL isAuthorized) {
        if (isAuthorized) {
            if (self.model) {
                @zq_strongify(self);
                NSArray *photos = [[ZQPhotoAlbumManager sharedInstance] getPhotoList:self.model];
                [ZQPhotoAlbumManager sharedInstance].config = [ZQPhotoListConfig configWithWholeAssets:photos];
                [self.dataSource updateData:photos];
                [self.collectionView reloadData];
            } else {
                NSArray *photos = [[ZQPhotoAlbumManager sharedInstance] getWholePhotoList];
                [ZQPhotoAlbumManager sharedInstance].config = [ZQPhotoListConfig configWithWholeAssets:photos];
                [self.dataSource updateData:photos];
                [self.collectionView reloadData];
            }
        }else{
            [self showNotAuthorizedWarning];
        }
    }];
}

#pragma mark - Public

- (void)configCellInfo {
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:ZQ_Photo_HeaderID];
    
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:ZQ_Photo_FooterID];
}

#pragma mark - Private

- (void)showNotAuthorizedWarning {
    [UIAlertController settingAlertWithTitle:nil
                                     message:@"想要选择图片，需要修改访问照片设置"
                                      target:self
                                  completion:^(BOOL isSure) {
                                      if (isSure) {
                                          NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                          if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                              [[UIApplication sharedApplication] openURL:url];
                                          }
                                      }
                                  }];
}

- (void)updateCachedAssets {
    
    // 预热区域 preheatRect 是 可见区域 visibleRect 的两倍高
    CGRect visibleRect = CGRectMake(0.f,
                                    self.collectionView.contentOffset.y,
                                    self.collectionView.bounds.size.width,
                                    self.collectionView.bounds.size.height);
    
    CGRect preheatRect = CGRectInset(visibleRect, 0, -0.5*visibleRect.size.height);
    
    // 只有当可见区域与最后一个预热区域显著不同时才更新
    CGFloat delta = fabs(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > kScreenWidth / 3.f) {
        // 计算开始缓存和停止缓存的区域
        @zq_weakify(self);
        [self computeDifferenceBetweenRect:self.previousPreheatRect
                                   andRect:preheatRect
                            removedHandler:^(CGRect removedRect) {
                                @zq_strongify(self);
                                NSArray *removeAssets = [self indexPathsForElementsWithRect:removedRect];
                                [[ZQPhotoManager sharedInstance] stopCaches:removeAssets
                                                                  assetSize:ZQPhotoSmallSize];
                            }
                              addedHandler:^(CGRect addedRect) {
                                  @zq_strongify(self);
                                  NSArray *addAssets = [self indexPathsForElementsWithRect:addedRect];
                                  [[ZQPhotoManager sharedInstance] startCaches:addAssets
                                                                     assetSize:ZQPhotoSmallSize];
                              }];
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler
{
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        //添加 向下滑动时 newRect 除去与 oldRect 相交部分的区域（即：屏幕外底部的预热区域）
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        //添加 向上滑动时 newRect 除去与 oldRect 相交部分的区域（即：屏幕外底部的预热区域）
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        //移除 向上滑动时 oldRect 除去与 newRect 相交部分的区域（即：屏幕外底部的预热区域）
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        //移除 向下滑动时 oldRect 除去与 newRect 相交部分的区域（即：屏幕外顶部的预热区域）
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    }
    else {
        //当 oldRect 与 newRect 没有相交区域时
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray<PHAsset *> *)indexPathsForElementsWithRect:(CGRect)rect
{
    NSMutableArray *assets = [NSMutableArray array];
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    if (config.wholeAssets && config.wholeAssets.count > 0) {
        NSArray *layoutAttributes = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
        for (UICollectionViewLayoutAttributes *layoutAttr in layoutAttributes) {
            NSIndexPath *indexPath = layoutAttr.indexPath;
            PHAsset *asset = config.wholeAssets[indexPath.item];
            [assets addObject:asset];
        }
    }
    return assets;
}

- (void)setChildVCForNavigationVC {
    NSMutableArray *childVCs = [[NSMutableArray alloc] initWithArray:self.navigationController.childViewControllers];
    for (UIViewController *childVC in childVCs) {
        if (![childVC isKindOfClass:[ZQPhotoAlbumController class]]) {
            ZQPhotoAlbumController *albumVC = [[ZQPhotoAlbumController alloc] init];
            [childVCs insertObject:albumVC atIndex:0];
        }
    }
    self.navigationController.viewControllers = childVCs;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCachedAssets];
}

#pragma mark - ZQDataSourceDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
                                        kind:(NSString *)kind
                                   indexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:ZQ_Photo_HeaderID forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor clearColor];
        return headerView;
    }else{
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                  withReuseIdentifier:ZQ_Photo_FooterID forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor clearColor];
        return footerView;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [ZQPhotoAlbumManager sharedInstance].config.indexPath = indexPath;
    
    ZQPhotoItemConfig *config = [ZQPhotoManager sharedInstance].config;
    if (config.style == ZQPhotoSelectStyleMore) {
        ZQPhotoDetailMoreController *detailVC = [[ZQPhotoDetailMoreController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        ZQPhotoDetailSingleController *detailVC = [[ZQPhotoDetailSingleController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, kNavTitleBarHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    UIEdgeInsets safeInsets = [ZQHelper safeAreaInsetsForWindow];
    return CGSizeMake(kScreenWidth, kTabbarCustomHeight + safeInsets.bottom);
}

#pragma mark - ZQNavigationViewDelegate

- (void)navigationBarLeftOperation {
    [self setChildVCForNavigationVC];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBarRightOperation {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
