//
//  ZQCommon.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/21.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

/**
 * @brief 相册模型
 */
@interface ZQFetchAlbumInfoModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) PHFetchResult<PHAsset *> *fetchResult;
@property (nonatomic, assign) NSUInteger count;

+ (instancetype)modelWithTitle:(NSString *)title result:(PHFetchResult<PHAsset *> *)fetchResult;

@end


/**
 * @brief 照片列表相关信息配置
 */
@interface ZQPhotoListConfig : NSObject

/**< 某个相册下的所有照片信息 >*/
@property (nonatomic, strong, readonly) NSArray *wholeAssets;
/**< 点击当前 cell 的位置 >*/
@property (nonatomic, strong) NSIndexPath *indexPath;
/**< 当前选择的所有照片索引 >*/
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;
/**< 当前选择的所有照片信息 >*/
@property (nonatomic, strong) NSMutableArray *selectedImgInfo;
/**< 当前选择的所有照片集合 >*/
@property (nonatomic, strong) NSMutableArray *selectedAssets;

+ (ZQPhotoListConfig *)configWithWholeAssets:(NSArray *)wholeAssets;

- (void)addIndexPath:(NSIndexPath *)indexPath;

- (void)removeIndexPath:(NSIndexPath *)indexPath;

@end
