//
//  ZQSystemPhotoAPI.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/20.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQSystemPhotoAPI.h"
#import "ZQPhotoListController.h"
#import "ZQPhotoManager.h"
#import "ZQPhotoAlbumController.h"

@implementation ZQPhotoItemConfig

- (NSUInteger)itemCount {
    NSUInteger itemCount = _itemCount;
    if (itemCount > 5) {
        itemCount = 5;
    }else if (itemCount < 3 && itemCount > 0) {
        itemCount = 3;
    }else if (itemCount <= 0) {
        itemCount = 4;
    }
    return itemCount;
}

- (CGFloat)itemSpace {
    CGFloat itemSpace = _itemSpace;
    if (itemSpace <= 0) {
        itemSpace = 3.0f;
    }
    return itemSpace;
}

- (CGFloat)sectionSpace {
    CGFloat sectionSpace = _sectionSpace;
    if (sectionSpace <= 0) {
        sectionSpace = 3.0f;
    }
    return sectionSpace;
}

- (NSUInteger)selectedMaxCount {
    NSUInteger selectedMaxCount = _selectedMaxCount;
    if (selectedMaxCount == 0) {
        selectedMaxCount = ZQ_SELECTED_MAX_COUNT;
    }
    return selectedMaxCount;
}

+ (ZQPhotoItemConfig *)createObjectWithCount:(NSUInteger)itemCount
                                   itemSpace:(CGFloat)itemSpace
                                sectionSpace:(CGFloat)sectionSpace
                            selectedMaxCount:(NSUInteger)selectedMaxCount style:(ZQPhotoSelectStyle)style {
    
    ZQPhotoItemConfig *config = [[ZQPhotoItemConfig alloc] init];
    config.itemCount = itemCount;
    config.itemSpace = itemSpace;
    config.sectionSpace = sectionSpace;
    config.selectedMaxCount = selectedMaxCount;
    config.style = style;
    
    return config;
}

@end

@implementation ZQSystemPhotoAPI

+ (ZQSystemPhotoAPI *)sharedAPI {
    static ZQSystemPhotoAPI *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

- (void)showSystemPhoto:(UIViewController *)currentVC
                handler:(ZQHandleResult)handler {
    
    ZQPhotoItemConfig *config = [[ZQPhotoItemConfig alloc] init];
    config.itemCount = 4;
    config.itemSpace = 3.0f;
    config.sectionSpace = 3.0f;
    config.selectedMaxCount = 0;
    config.style = ZQPhotoSelectStyleMore;
    
    [self showSystemPhoto:currentVC config:config handler:handler];
}

- (void)showSystemPhoto:(UIViewController *)currentVC
                 config:(ZQPhotoItemConfig *)config
                handler:(ZQHandleResult)handler {
    
    if (!config) {
        config = [[ZQPhotoItemConfig alloc] init];
    }
    
    [ZQPhotoManager sharedInstance].config = config;
    [ZQPhotoAlbumManager sharedInstance].handleResult = handler;
    
    UIViewController *listVC = nil;
    if (config.style == ZQPhotoSelectStyleMore) {
        listVC = [ZQPhotoListMoreController showPhotoListVC:nil];
    }else{
        listVC = [ZQPhotoListSingleController showPhotoListVC:nil];
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listVC];
    [currentVC presentViewController:nav animated:YES completion:nil];
}

- (void)showSystemPhotoAlbum:(UIViewController *)currentVC handler:(ZQHandleResult)handler {
    ZQPhotoItemConfig *config = [[ZQPhotoItemConfig alloc] init];
    config.itemCount = 4;
    config.itemSpace = 3.0f;
    config.sectionSpace = 3.0f;
    config.selectedMaxCount = 0;
    config.style = ZQPhotoSelectStyleMore;
    
    [self showSystemPhotoAlbum:currentVC config:config handler:handler];
}

- (void)showSystemPhotoAlbum:(UIViewController *)currentVC
                      config:(ZQPhotoItemConfig *)config
                     handler:(ZQHandleResult)handler {
    if (!config) {
        config = [[ZQPhotoItemConfig alloc] init];
    }
    
    [ZQPhotoManager sharedInstance].config = config;
    [ZQPhotoAlbumManager sharedInstance].handleResult = handler;
    
    ZQPhotoAlbumController *albumVC = [[ZQPhotoAlbumController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:albumVC];
    [currentVC presentViewController:nav animated:YES completion:nil];
}

@end
