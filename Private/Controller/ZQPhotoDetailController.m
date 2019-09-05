//
//  ZQPhotoDetailController.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/15.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQPhotoDetailController.h"
#import "ZQDataSource.h"
#import "ZQPhotoManager.h"

static NSString * const Photo_Detail_CellID = @"Photo_Detail_CellID";

@interface ZQPhotoDetailController ()<UICollectionViewDelegateFlowLayout, ZQNavigationViewDelegate, ZQTabbarViewDelegate,UIScrollViewDelegate, ZQSmallPhotoViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZQNavigationView *navigationView;
@property (nonatomic, strong) ZQTabbarView *tabbarView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) ZQSmallPhotoView *smallPhotoView;

@property (nonatomic, strong) ZQDataSource *dataSource;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, assign) CGRect previousPreheatRect;

@end

@implementation ZQPhotoDetailController

- (void)dealloc {
    NSLog(@"ZQPhotoDetailController dealloc");
    [[ZQPhotoManager sharedInstance] stopCaches:[ZQPhotoAlbumManager sharedInstance].config.wholeAssets
                                      assetSize:ZQPhotoBigSize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createDataSource];
    [self createCollectionView];
    [self createNavigationView];
    [self createCountLabel];
    [self createTabbarView];
    [self createSmallPhotoView];
    
    [self getPhotoListData];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Create UI

- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight-20);
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
    
    [self.collectionView registerClass:[ZQPhotoDetailCell class] forCellWithReuseIdentifier:Photo_Detail_CellID];
}

- (void)createNavigationView {
    self.navigationView = [ZQNavigationView navigationViewWithType:ZQNavigationViewTypeLeftImage|ZQNavigationViewTypeRightImage
                                                             title:nil
                                                          delegate:self];
    
    [self.navigationView setSubImages:@[@"back_white", @"select_white"]];
    self.navigationView.backgroundColor = ZQUIColorAFromHex(0x202020, 0.95);
    [self.view addSubview:self.navigationView];
}

- (void)createCountLabel {
    CGRect rect = CGRectMake(self.navigationView.width-25-(kNavImageBarWidth-25)/2,
                             self.navigationView.height-25-(kNavTitleBarHeight-25)/2,
                             25,
                             25);
    self.countLabel = [UILabel labelWithFrame:rect
                                        title:nil
                                         font:ZQFont(15.0f)
                                     selector:@selector(cancelClick)
                                       target:self];
    self.countLabel.backgroundColor = ZQUIColorFromHex(0x51aa38);
    self.countLabel.textColor = ZQUIColorFromHex(0xffffff);
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.hidden = YES;
    [self.navigationView addSubview:self.countLabel];
    
    self.countLabel.clipsToBounds = YES;
    self.countLabel.layer.cornerRadius = 12.5f;
}

- (void)createTabbarView {
    self.tabbarView = [ZQTabbarView tabbarViewWithTitle:@"编辑" delegate:self];
    self.tabbarView.backgroundColor = ZQUIColorAFromHex(0x202020, 0.95);
    [self.view addSubview:self.tabbarView];
}

- (void)createSmallPhotoView {
    self.smallPhotoView = [ZQSmallPhotoView smallViewWithFrame:CGRectMake(0, self.tabbarView.minY-88.5, kScreenWidth, 88.5)
                                                      delegate:self];
    self.smallPhotoView.backgroundColor = ZQUIColorAFromHex(0x202020, 0.95);
    self.smallPhotoView.hidden = YES;
    [self.view addSubview:self.smallPhotoView];
}

#pragma mark - InitializeData

- (void)createDataSource {
    ZQDataSourceCompletion completion = ^(id item, NSIndexPath *indexPath, id cell){
        [[ZQPhotoManager sharedInstance] getSmallImageInfo:item
                                                      size:ZQPhotoBigSize
                                                   handler:^(UIImage *image, NSDictionary *imageInfo) {
                                                       [((ZQPhotoDetailCell *)cell) handleData:image];
                                                   }];
    };
    
    self.dataSource = [ZQDataSource dataSourceWithCellID:Photo_Detail_CellID
                                               cellClass:[ZQPhotoDetailCell class]
                                                delegate:nil
                                              completion:completion];
}

- (void)getPhotoListData {
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    
    [[ZQPhotoManager sharedInstance] startCaches:config.wholeAssets assetSize:ZQPhotoBigSize];
    
    [self.dataSource updateData:config.wholeAssets];
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:config.indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];

    [self updateCountLabelStatus:config.indexPath];
    
    if (config.selectedAssets.count > 0) {
        [self.smallPhotoView reloadData:config.selectedAssets];
        self.smallPhotoView.hidden = NO;
        
        [self.tabbarView hideShadowView:YES
                          selectedCount:config.selectedIndexPaths.count];
        
        /* 当点击非选中照片时，下方缩略图没有选中状态 */
        [self.smallPhotoView updateItemStatus:nil];
    }
}

#pragma mark - Private

//刷新导航条上方选中照片的个数
- (void)updateCountLabelStatus:(NSIndexPath *)indexPath {
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    BOOL isFind = NO;
    for (NSUInteger index = 0; index < config.selectedIndexPaths.count; index++) {
        NSIndexPath *subIndexPath = config.selectedIndexPaths[index];
        if (subIndexPath.item == indexPath.item) {
            self.countLabel.hidden = NO;
            [self.navigationView updateBarItemState:ZQNavigationViewTypeRightImage isHidden:YES];
            self.countLabel.text = [NSString stringWithFormat:@"%ld", index+1];
            isFind = YES;
            break;
        }
    }
    if (!isFind) {
        self.countLabel.hidden = YES;
        [self.navigationView updateBarItemState:ZQNavigationViewTypeRightImage isHidden:NO];
    }
}

#pragma mark - Target

- (void)cancelClick {
    
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    
    self.countLabel.hidden = YES;
    [self.navigationView updateBarItemState:ZQNavigationViewTypeRightImage isHidden:NO];
    
    [config removeIndexPath:config.indexPath];
    
    if (config.selectedAssets.count <= 0) {
        self.smallPhotoView.hidden = YES;
    }
    
    [self.smallPhotoView reloadData:config.selectedAssets];
    [self.smallPhotoView updateItemStatus:nil];
    
    [self.tabbarView hideShadowView:(config.selectedAssets.count > 0)
                      selectedCount:config.selectedAssets.count];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.tabbarView.hidden = !self.isHidden;
    self.smallPhotoView.hidden = !self.isHidden;
    self.navigationView.hidden = !self.isHidden;
    self.isHidden = !self.isHidden;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    
    NSUInteger currentIndex = scrollView.contentOffset.x/scrollView.width;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    
    if (config.indexPath != indexPath) {
        [self updateCountLabelStatus:indexPath];
        BOOL isFind = NO;
        for (NSInteger index = 0; index < config.selectedIndexPaths.count; index++) {
            NSIndexPath *selectedIndexPath = config.selectedIndexPaths[index];
            if (indexPath.item == selectedIndexPath.item) {
                [self.smallPhotoView updateItemStatus:[NSIndexPath indexPathForItem:index inSection:0]];
                isFind = YES;
                break;
            }
        }
        if (!isFind) {
            [self.smallPhotoView updateItemStatus:nil];
        }
        
        [self.collectionView reloadItemsAtIndexPaths:@[config.indexPath]];
        
        config.indexPath = indexPath;
    }
}

#pragma mark - ZQNavigationViewDelegate

- (void)navigationBarLeftOperation {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBarRightOperation {
    
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    NSUInteger selectedMaxCount = [ZQPhotoManager sharedInstance].config.selectedMaxCount;
    
    if (config.selectedIndexPaths.count >= selectedMaxCount) {
        NSString *message = [NSString stringWithFormat:@"最多选择%ld张图片", selectedMaxCount];
        [UIAlertController alertWithTitle:nil
                                  message:message
                                   cancel:nil
                                     sure:@"好的"
                               completion:nil];
        return;
    }
    
    self.countLabel.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.countLabel.hidden = NO;
    [self.navigationView updateBarItemState:ZQNavigationViewTypeRightImage isHidden:YES];
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:0.3f
          initialSpringVelocity:10.0f
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.countLabel.transform = CGAffineTransformIdentity;
                        }
                     completion:nil];
    
    [config addIndexPath:config.indexPath];
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld", config.selectedIndexPaths.count];
    
    [self.tabbarView hideShadowView:(config.selectedIndexPaths.count > 0)
                      selectedCount:config.selectedIndexPaths.count];
    
    [self.smallPhotoView reloadData:config.selectedAssets];
    [self.smallPhotoView updateItemStatus:[NSIndexPath indexPathForItem:config.selectedIndexPaths.count-1 inSection:0]];
    self.smallPhotoView.hidden = NO;
}

#pragma mark - ZQTabbarViewDelegate

- (void)tabbarLeftOperation {
    [UIAlertController alertWithTitle:nil
                              message:@"暂时未开发此功能"
                               cancel:nil
                                 sure:@"好的"
                           completion:nil];
}

- (void)tabbarRightOperation {
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    if (config.selectedImgInfo.count > 0) {
        [ZQPhotoAlbumManager sharedInstance].handleResult(config.selectedImgInfo);
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - ZQSmallPhotoViewDelegate

- (void)smallPhotoView:(ZQSmallPhotoView *)smallPhotoView didSelectedItem:(NSIndexPath *)indexPath {
    
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    
    NSIndexPath *selectedIndexPath = config.selectedIndexPaths[indexPath.item];
    
    [self.collectionView scrollToItemAtIndexPath:selectedIndexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
}

@end
