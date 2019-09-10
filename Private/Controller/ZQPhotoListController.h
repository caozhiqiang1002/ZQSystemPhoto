//
//  ZQPhotoListController.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/15.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQPhotoListBaseController.h"

/// 多张图片
@interface ZQPhotoListMoreController : ZQPhotoListBaseController

+ (ZQPhotoListMoreController *)showPhotoListVC:(ZQFetchAlbumInfoModel *)model;

@end


/// 单张图片
@interface ZQPhotoListSingleController : ZQPhotoListBaseController

+ (ZQPhotoListSingleController *)showPhotoListVC:(ZQFetchAlbumInfoModel *)mode;

@end
