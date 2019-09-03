//
//  ZQSystemPhotoAPI.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/20.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief collectionView 中 cell 的相关配置
 */
@interface ZQPhotoItemConfig : NSObject
/**< 一行显示的 cell 的个数 >*/
@property (nonatomic, assign) NSUInteger itemCount;
/**< 每个cell之间的间隔 >*/
@property (nonatomic, assign) CGFloat itemSpace;
/**< 每个section 四周的间隔 >*/
@property (nonatomic, assign) CGFloat sectionSpace;
/**< 选择照片的最大张数 >*/
@property (nonatomic, assign) NSUInteger selectedMaxCount;

+ (ZQPhotoItemConfig *)createObjectWithCount:(NSUInteger)itemCount
                                   itemSpace:(CGFloat)itemSpace
                                sectionSpace:(CGFloat)sectionSpace
                            selectedMaxCount:(NSUInteger)selectedMaxCount;

@end


#pragma mark - 调用系统相册的公开接口

typedef void(^ZQHandleResult)(NSArray <NSDictionary *>*imagesInfo);


@interface ZQSystemPhotoAPI : NSObject

/**
 * @brief 单例对象
 */
+ (ZQSystemPhotoAPI *)sharedAPI;

#pragma mark - 首先显示照片列表页面

/**
 * @brief 显示照片列表页面
 *
 * @note 采用默认组合方式（count => 4, itemSpace => 3.0, sectionSpace => 3.0）
 *
 * @param currentVC 当前控制器
 * @param handler   结果回调
 */
- (void)showSystemPhoto:(UIViewController *)currentVC handler:(ZQHandleResult)handler;

/**
 * @brief 显示照片列表页面
 *
 * @param currentVC    当前控制器
 * @param config       配置信息
 * @param handler      结果回调
 */
- (void)showSystemPhoto:(UIViewController *)currentVC
                 config:(ZQPhotoItemConfig *)config handler:(ZQHandleResult)handler;


#pragma mark - 首先显示相册列表页面

/**
 * @brief 显示相册列表页面
 *
 * @param currentVC 当前控制器
 * @param handler   结果回调
 */
- (void)showSystemPhotoAlbum:(UIViewController *)currentVC handler:(ZQHandleResult)handler;

/**
 * @brief 显示相册列表页面
 *
 * @param currentVC    当前控制器
 * @param config       配置信息
 * @param handler      结果回调
 */
- (void)showSystemPhotoAlbum:(UIViewController *)currentVC
                      config:(ZQPhotoItemConfig *)config handler:(ZQHandleResult)handler;

@end
