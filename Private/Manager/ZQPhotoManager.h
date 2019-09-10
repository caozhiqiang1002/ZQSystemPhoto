//
//  ZQPhotoManager.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/15.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQCommon.h"
#import "ZQSystemPhotoAPI.h"

typedef void(^ZQPhotoHandler)(UIImage *image, NSDictionary *imageInfo);

@interface ZQPhotoManager : NSObject

/**< 照片列表中cell的配置 >*/
@property (nonatomic, strong) ZQPhotoItemConfig *config;
/*< 是否同步获取图片 >*/
@property (nonatomic, assign) BOOL isSyncOperation;

/**
 * @brief 单例对象
 */
+ (instancetype)sharedInstance;

/**
 * @brief 获取缩略图信息
 *
 * @param asset   照片asset
 * @param size    照片尺寸
 * @param handler 结果回调
 */
- (void)getSmallImageInfo:(PHAsset *)asset size:(CGSize)size handler:(ZQPhotoHandler)handler;

/**
 * @brief 获取原图信息
 *
 * @param handler 结果回调
 */
- (void)getOriginalImageInfo:(PHAsset *)asset handler:(ZQPhotoHandler)handler;

/**
 * @breif 开始缓存图片数据
 *
 * @param assets 要缓存的照片集
 * @param assetSize 缓存的照片大小
 */
- (void)startCaches:(NSArray<PHAsset *> *)assets assetSize:(CGSize)assetSize;

/**
 * @breif 移除缓存的图片数据
 *
 * @param assets 要移除的照片集
 * @param assetSize 移除的照片大小
 */
- (void)stopCaches:(NSArray<PHAsset *> *)assets assetSize:(CGSize)assetSize;

/**
 * @brief 移除所有照片集缓存
 */
- (void)resetCachesAsset;

@end
