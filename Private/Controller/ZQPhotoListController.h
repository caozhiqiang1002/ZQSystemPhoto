//
//  ZQPhotoListController.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/15.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQBaseController.h"
#import "ZQPhotoAlbumManager.h"

@interface ZQPhotoListController : ZQBaseController

+ (ZQPhotoListController *)showPhotoListVC:(ZQFetchAlbumInfoModel *)model;

@end
