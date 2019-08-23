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

@property (nonatomic, strong) ZQPhotoListConfig *config;

@property (nonatomic, copy) ZQHandleResult handleResult;

/**
 * @brief 单例对象
 */
+ (instancetype)sharedInstance;

/**
 * @brief 获取相册列表
 *
 * @param completion 结果回调
 */
- (void)getPhotoAlbumList:(void(^)(NSArray * __nullable photoAlbums, BOOL isAuthorized))completion;

/**
 * @brief 获取某个相册下的所有照片
 *
 * @param model      相册模型对象
 * @param completion 完成回调
 */
- (void)getPhotoList:(ZQFetchAlbumInfoModel *)model completion:(void(^)(NSArray * __nullable photos))completion;

/**
 * @brief 获取所有图片
 *
 * @param completion 完成回调
 */
- (void)getWholePhotoList:(void(^)(NSArray * __nullable photos))completion;

@end

