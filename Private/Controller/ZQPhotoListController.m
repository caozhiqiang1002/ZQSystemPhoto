//
//  ZQPhotoListController.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/15.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQPhotoListController.h"
#import "ZQPhotoDetailController.h"
#import "ZQPhotoAlbumController.h"

#import "ZQDataSource.h"
#import "ZQPhotoManager.h"

static NSString * const ZQ_Photo_CellID = @"Photo_CellID";
static NSString * const ZQ_Photo_HeaderID = @"Photo_HeaderID";

@interface ZQPhotoListController ()<UICollectionViewDelegateFlowLayout, ZQNavigationViewDelegate, ZQDataSourceDelegate, ZQTabbarViewDelegate, ZQPhotoCellDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) ZQFetchAlbumInfoModel *model;
@property (nonatomic, strong) ZQDataSource *dataSource;

@property (nonatomic, assign) CGRect previousPreheatRect;

@property (nonatomic, strong) ZQNavigationView *navigationView;
@property (nonatomic, strong) ZQTabbarView *tabbarView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ZQPhotoListController

- (void)dealloc {
    NSLog(@"ZQPhotoListController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createDataSource];
    [self createCollectionView];
    [self createNavigationView];
    [self createTabbarView];
    
    [self getPhotoListData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
}

#pragma mark - Create UI

- (void)createNavigationView {
    self.navigationView = [ZQNavigationView navigationViewWithType:ZQNavigationViewTypeLeftImage | ZQNavigationViewTypeRightText
                                                             title:self.model.title ?: @"所有照片"
                                                          delegate:self];
    [self.navigationView setSubTitles:@[@"取消"]];
    [self.navigationView setSubImages:@[@"back_black"]];
    self.navigationView.backgroundColor = ZQUIColorAFromHex(0xf0f0f0, 0.8);
    [self.view addSubview:self.navigationView];
}

- (void)createTabbarView {
    self.tabbarView = [ZQTabbarView tabbarViewWithTitle:@"预览" delegate:self];
    self.tabbarView.backgroundColor = ZQUIColorFromHex(0x272d32);
    [self.view addSubview:self.tabbarView];
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
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kTabbarCustomHeight)
                                             collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ZQPhotoCell class]
            forCellWithReuseIdentifier:ZQ_Photo_CellID];
    
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:ZQ_Photo_HeaderID];
}

#pragma mark - InitializeData

- (void)createDataSource {
    @zq_weakify(self);
    ZQDataSourceCompletion completion = ^(id item, NSIndexPath *indexPath, id cell) {
        [[ZQPhotoManager sharedInstance] getSmallImageInfo:item
                                                      size:ZQPhotoSmallSize
                                                   handler:^(UIImage *image, NSDictionary *imageInfo) {
                                                       
                                                       @zq_strongify(self);
                                                       [((ZQPhotoCell *)cell) handleData:image];
                                                       ((ZQPhotoCell *)cell).delegate = self;
                                                       [self updateCellStatus:cell indexPath:indexPath];
                                                       
                                                   }];
    };
    
    self.dataSource = [ZQDataSource dataSourceWithCellID:ZQ_Photo_CellID
                                               cellClass:[ZQPhotoCell class]
                                                delegate:self
                                              completion:completion];
}

- (void)getPhotoListData {
    
    @zq_weakify(self);
    if (self.model) {
        [[ZQPhotoAlbumManager sharedInstance] getPhotoList:self.model completion:^(NSArray * _Nullable photos) {
            @zq_strongify(self);
            [ZQPhotoAlbumManager sharedInstance].config = [ZQPhotoListConfig configWithWholeAssets:photos];
            [self.dataSource updateData:photos];
            [self.collectionView reloadData];
        }];
    } else {
        [[ZQPhotoAlbumManager sharedInstance] getWholePhotoList:^(NSArray * _Nullable photos) {
            @zq_strongify(self);
            [ZQPhotoAlbumManager sharedInstance].config = [ZQPhotoListConfig configWithWholeAssets:photos];
            [self.dataSource updateData:photos];
            [self.collectionView reloadData];
        }];
    }
}

- (void)setChildVCForNavigationVC {
    NSMutableArray *childVCs = [[NSMutableArray alloc] initWithArray:self.navigationController.childViewControllers];
    ZQPhotoAlbumController *albumVC = [[ZQPhotoAlbumController alloc] init];
    [childVCs insertObject:albumVC atIndex:0];
    self.navigationController.viewControllers = childVCs;
}

#pragma mark - Private

- (void)updateCellStatus:(ZQPhotoCell *)cell indexPath:(NSIndexPath *)indexPath {
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    
    BOOL isFind = NO;
    for (NSUInteger index = 0; index < config.selectedIndexPaths.count; index++) {
        NSIndexPath *subIndexPath = config.selectedIndexPaths[index];
        if (subIndexPath.item == indexPath.item) {
            [cell updateSeleectedImageCount:index+1 isSelected:YES];
            isFind = YES;
            break;
        }
    }
    if (!isFind) {
        [cell updateSeleectedImageCount:0 isSelected:NO];
    }
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
    
    NSArray *layoutAttributes = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *layoutAttr in layoutAttributes) {
        NSIndexPath *indexPath = layoutAttr.indexPath;
        PHAsset *asset = config.wholeAssets[indexPath.item];
        [assets addObject:asset];
    }
    return assets;
}

#pragma mark - Public

+ (ZQPhotoListController *)showPhotoListVC:(ZQFetchAlbumInfoModel *)model {
    ZQPhotoListController *rootVC = [[ZQPhotoListController alloc] init];
    rootVC.model = model;
    return rootVC;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [ZQPhotoAlbumManager sharedInstance].config.indexPath = indexPath;
    
    ZQPhotoDetailController *detailVC = [[ZQPhotoDetailController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, [ZQHelper navBarHeight]);
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
    }
    return [[UICollectionReusableView alloc] init];
}

#pragma mark - ZQNavigationViewDelegate

- (void)navigationBarLeftOperation {
    [self setChildVCForNavigationVC];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBarRightOperation {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZQTabbarViewDelegate

- (void)tabbarLeftOperation {
    
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    
    config.indexPath = config.selectedIndexPaths.firstObject;
    
    ZQPhotoDetailController *detailVC = [[ZQPhotoDetailController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tabbarRightOperation {
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    
    if (config.selectedImgInfo.count > 0) {
        [ZQPhotoAlbumManager sharedInstance].handleResult(config.selectedImgInfo);
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - ZQPhotoCellDelegate

- (BOOL)photoCell:(ZQPhotoCell *)cell isSelectImage:(BOOL)isSelect {
    
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSUInteger selectedMaxCount = [ZQPhotoManager sharedInstance].config.selectedMaxCount;
    
    if (isSelect) {
        
        if (config.selectedIndexPaths.count >= selectedMaxCount) {
            NSString *message = [NSString stringWithFormat:@"最多选择%ld张图片",selectedMaxCount];
            [UIAlertController alertWithTitle:nil
                                      message:message
                                       cancel:nil
                                         sure:@"好的"
                                   completion:nil];
            return NO;
        }
        
        [config addIndexPath:indexPath];
        
    }else{
        [config removeIndexPath:indexPath];
    }
    
    for (NSUInteger index = 0; index < config.selectedIndexPaths.count; index++) {
        NSIndexPath *indexPath = config.selectedIndexPaths[index];
        ZQPhotoCell *cell = (ZQPhotoCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell updateSeleectedImageCount:index+1 isSelected:YES];
    }
    
    [self.tabbarView hideShadowView:(config.selectedIndexPaths.count > 0)
                      selectedCount:config.selectedIndexPaths.count];
    
    return YES;
}

@end
