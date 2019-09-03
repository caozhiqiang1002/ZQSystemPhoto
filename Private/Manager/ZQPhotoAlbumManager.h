//
//  ZQPhotoAlbumManager.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/14.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQCommon.h"
#import "ZQSystemPhotoAPI.h"

@interface ZQPhotoAlbumManager : NSObject

@property (nonatomic, strong, nonnull) ZQPhotoListConfig *config;

@property (nonatomic, copy, nonnull) ZQHandleResult handleResult;

/**
 * @brief 单例对象
 */
+ (instancetype __nonnull)sharedInstance;

/**
 * @brief 请求权限
 *
 * @param completion 结果毁掉
 */
- (void)requestAuthorization:(void(^ __nullable)(BOOL isAuthorized))completion;

/**
 * @brief 获取相册列表
 */
- (NSArray * __nullable)getPhotoAlbumList;

/**
 * @brief 获取某个相册下的所有照片
 *
 * @param model      相册模型对象
 */
- (NSArray * __nullable)getPhotoList:(ZQFetchAlbumInfoModel * __nullable)model;

/**
 * @brief 获取所有图片
 */
- (NSArray * __nullable)getWholePhotoList;

@end

