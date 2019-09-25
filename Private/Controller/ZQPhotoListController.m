//
//  ZQPhotoListController.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/15.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQPhotoListController.h"
#import "ZQPhotoDetailController.h"

#import "ZQPhotoManager.h"

@interface ZQPhotoListMoreController ()<ZQTabbarViewDelegate, ZQPhotoCellDelegate>
@property (nonatomic, strong) ZQTabbarView *tabbarView;
@end

@implementation ZQPhotoListMoreController

- (void)dealloc {
    NSLog(@"ZQPhotoListMoreController dealloc");
}

- (NSString *)cellIdentifer {
    return @"Photo_CellID";
}

- (NSString *)cellClassName {
    return NSStringFromClass([ZQPhotoCell class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTabbarView];
}

#pragma mark - Create UI

- (void)createTabbarView {
    self.tabbarView = [ZQTabbarView tabbarViewWithTitle:@"预览" delegate:self];
    self.tabbarView.backgroundColor = ZQUIColorAFromHex(0x202020, 0.95);
    [self.view addSubview:self.tabbarView];
}

#pragma mark - Super

- (void)configCellInfo {
    [super configCellInfo];
    [self.collectionView registerClass:[ZQPhotoCell class] forCellWithReuseIdentifier:self.cellIdentifer];
}

- (void)getImage:(UIImage *)image indexPath:(NSIndexPath *)indexPath cell:(id)cell {
    [((ZQPhotoCell *)cell) handleData:image];
    ((ZQPhotoCell *)cell).delegate = self;
    [self updateCellStatus:cell indexPath:indexPath];
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

#pragma mark - Public

+ (ZQPhotoListMoreController *)showPhotoListVC:(ZQFetchAlbumInfoModel *)model {
    ZQPhotoListMoreController *rootVC = [[ZQPhotoListMoreController alloc] init];
    rootVC.model = model;
    return rootVC;
}

#pragma mark - ZQTabbarViewDelegate

- (void)tabbarLeftOperation {
    ZQPhotoListConfig *config = [ZQPhotoAlbumManager sharedInstance].config;
    config.indexPath = config.selectedIndexPaths.firstObject;
    
    ZQPhotoDetailMoreController *detailVC = [[ZQPhotoDetailMoreController alloc] init];
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




@implementation ZQPhotoListSingleController

- (void)dealloc {
    NSLog(@"ZQPhotoListSingleController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

- (NSString *)cellIdentifer {
    return @"Photo_Base_CellID";
}

- (NSString *)cellClassName {
    return NSStringFromClass([ZQPhotoBaseCell class]);
}

#pragma mark - Super

- (void)configCellInfo {
    [super configCellInfo];
    [self.collectionView registerClass:[ZQPhotoBaseCell class] forCellWithReuseIdentifier:self.cellIdentifer];
}

- (void)getImage:(UIImage *)image indexPath:(NSIndexPath *)indexPath cell:(id)cell {
    [((ZQPhotoBaseCell *)cell) handleData:image];
}

#pragma mark - Public

+ (ZQPhotoListSingleController *)showPhotoListVC:(ZQFetchAlbumInfoModel *)model {
    ZQPhotoListSingleController *rootVC = [[ZQPhotoListSingleController alloc] init];
    rootVC.model = model;
    return rootVC;
}

@end
