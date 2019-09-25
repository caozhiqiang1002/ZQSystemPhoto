//
//  ZQPhotoAlbumController.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/14.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQPhotoAlbumController.h"
#import "ZQPhotoAlbumManager.h"
#import "ZQDataSource.h"
#import "ZQPhotoManager.h"
#import "ZQPhotoListController.h"

static NSString  * const Photo_Album_CellID = @"Photo_Album_CellID";

@interface ZQPhotoAlbumController ()<UITableViewDelegate, ZQNavigationViewDelegate>

@property (nonatomic, strong) ZQDataSource *dataSource;

@property (nonatomic, strong) ZQNavigationView *navigationView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZQPhotoAlbumController

- (void)dealloc {
    NSLog(@"ZQPhotoAlbumController dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self createDataSource];
    [self createTableView];
    [self createNavigationView];
    [self getPhotoAlbumsData];
}

#pragma mark - Create UI

- (void)createNavigationView {
    self.navigationView = [ZQNavigationView navigationViewWithType:ZQNavigationViewTypeRightText
                                                             title:@"照片"
                                                          delegate:self];
    [self.navigationView setSubTitles:@[@"取消"]];
    self.navigationView.backgroundColor = ZQUIColorAFromHex(0xf0f0f0, 0.8);
    [self.view addSubview:self.navigationView];
}

- (void)createTableView {
    CGRect tableRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavTitleBarHeight)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - InitializeData

- (void)createDataSource {
    ZQDataSourceCompletion completion = ^(id item, NSIndexPath *indexPath, id cell) {
        ZQFetchAlbumInfoModel *model = (ZQFetchAlbumInfoModel *)item;
        if ([model.title isEqualToString:@"所有照片"]) {
            NSArray *photos = [[ZQPhotoAlbumManager sharedInstance] getWholePhotoList];
            [((ZQPhotoAlbumCell *)cell) handleData:model.title images:photos];
        }else{
            NSArray *photos = [[ZQPhotoAlbumManager sharedInstance] getPhotoList:model];
            [((ZQPhotoAlbumCell *)cell) handleData:model.title images:photos];
        }
    };
    
    self.dataSource = [ZQDataSource dataSourceWithCellID:Photo_Album_CellID
                                               cellClass:[ZQPhotoAlbumCell class]
                                                delegate:nil
                                              completion:completion];
}

- (void)getPhotoAlbumsData {
    [[ZQPhotoAlbumManager sharedInstance] requestAuthorization:^(BOOL isAuthorized) {
        if (isAuthorized) {
            NSArray *photoAlbums = [[ZQPhotoAlbumManager sharedInstance] getPhotoAlbumList];
            NSMutableArray *albums = [[NSMutableArray alloc] initWithArray:photoAlbums];
            ZQFetchAlbumInfoModel *wholeModel = [ZQFetchAlbumInfoModel modelWithTitle:@"所有照片" result:nil];
            [albums insertObject:wholeModel atIndex:0];
            [self.dataSource updateData:albums];
            [self.tableView reloadData];
        }else{
            [self showNotAuthorizedWarning];
        }
    }];
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

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZQFetchAlbumInfoModel *model = (ZQFetchAlbumInfoModel *)[self.dataSource itemWithIndexPath:indexPath];
    if ([model.title isEqualToString:@"所有照片"]) {
        model = nil;
    }
    
    ZQPhotoItemConfig *config = [ZQPhotoManager sharedInstance].config;
    if (config.style == ZQPhotoSelectStyleMore) {
        ZQPhotoListMoreController *photoListVC = [ZQPhotoListMoreController showPhotoListVC:model];
        [self.navigationController pushViewController:photoListVC animated:YES];
    }else{
        ZQPhotoListSingleController *photoListVC = [ZQPhotoListSingleController showPhotoListVC:model];
        [self.navigationController pushViewController:photoListVC animated:YES];
    }
}

#pragma mark - ZQNavigationViewDelegate

- (void)navigationBarRightOperation {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
