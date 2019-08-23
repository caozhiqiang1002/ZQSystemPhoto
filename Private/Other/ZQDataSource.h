//
//  ZQDataSource.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/14.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZQDataSourceContainerViewType) {
    ZQDataSourceContainerViewTypeHeader,
    ZQDataSourceContainerViewTypeFooter,
};

typedef void(^ZQDataSourceCompletion)(id item, NSIndexPath *indexPath, id cell);

@protocol ZQDataSourceDelegate <NSObject>

/**
 * @brief 为collectionView设置页头或页脚
 *
 * @param collectionView 容器视图（UITableView、UICollectionView）
 * @param kind           类型
 * @param indexPath      位置索引
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
                                        kind:(NSString *)kind
                                   indexPath:(NSIndexPath *)indexPath;

@end

@interface ZQDataSource : NSObject<UITableViewDataSource, UICollectionViewDataSource>

/**
 * @brief 类方法生成实例对象
 *
 * @param cellID     cell唯一标识
 * @param cellClass  cell类
 * @param delegate   代理对象
 * @param completion 回调结果
 */
+ (ZQDataSource *)dataSourceWithCellID:(NSString *)cellID
                             cellClass:(Class)cellClass
                              delegate:(id<ZQDataSourceDelegate>)delegate
                            completion:(ZQDataSourceCompletion)completion;

/**
 * @brief 刷新cell
 *
 * @param items 需要更新的信息
 */
- (void)updateData:(NSArray *)items;

/**
 * @brief 获取 item
 *
 * @param indexPath cell索引
 */
- (id)itemWithIndexPath:(NSIndexPath *)indexPath;

@end

