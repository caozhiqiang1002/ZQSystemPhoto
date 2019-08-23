//
//  ZQCommonView.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/23.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 导航栏

typedef NS_OPTIONS(NSUInteger, ZQNavigationViewType) {
    ZQNavigationViewTypeDefault     = 0,
    ZQNavigationViewTypeLeftText    = 1 << 0,
    ZQNavigationViewTypeLeftImage   = 1 << 1,
    ZQNavigationViewTypeRightText   = 1 << 2,
    ZQNavigationViewTypeRightImage  = 1 << 3,
};

@protocol ZQNavigationViewDelegate <NSObject>

@optional
/**
 * @brief 点击左侧UI触发的事件
 */
- (void)navigationBarLeftOperation;

/**
 * @breif 点击右侧UI触发的事件
 */
- (void)navigationBarRightOperation;

@end

@interface ZQNavigationView : UIView

/**
 * @brief 初始化导航栏
 *
 * @param type     类型
 * @param title    标题
 * @param delegate 代理对象
 */
+ (ZQNavigationView *)navigationViewWithType:(ZQNavigationViewType)type
                                       title:(NSString *)title
                                    delegate:(id<ZQNavigationViewDelegate>)delegate;

/**
 * @brief 设置副标题（如果导航栏两侧需要显示文字，则设置此项）
 *
 * @param titles 标题数组（标题最多有2个）
 */
- (void)setSubTitles:(NSArray<NSString *> *)titles;

/**
 * @brief 设置副标题（如果导航栏两侧需要显示图片，则设置此项）
 *
 * @param imageNames 图片名称数组（图片名称最多有2个）
 */
- (void)setSubImages:(NSArray<NSString *> *)imageNames;

/**
 * @brief 设置副标题状态
 *
 * @param type     类型
 * @param isHidden 是否隐藏
 */
- (void)updateBarItemState:(ZQNavigationViewType)type isHidden:(BOOL)isHidden;

@end


#pragma mark - 底部Tab栏

@protocol ZQTabbarViewDelegate <NSObject>

@optional
/**
 * @brief 点击左侧UI触发的事件
 */
- (void)tabbarLeftOperation;

/**
 * @brief 点击右侧UI触发的事件
 */
- (void)tabbarRightOperation;

@end


@interface ZQTabbarView : UIView

/**
 * @brief 工厂方法
 *
 * @param title     左侧UI标题
 * @param delegate  代理对象
 */
+ (ZQTabbarView *)tabbarViewWithTitle:(NSString *)title delegate:(id<ZQTabbarViewDelegate>)delegate;

/**
 * @brief 是否隐藏Tab栏上的遮罩层
 *
 * @param isHide        是否隐藏
 * @param selectedCount 当前选择的照片数量
 */
- (void)hideShadowView:(BOOL)isHide selectedCount:(NSUInteger)selectedCount;

@end


#pragma mark - 缩略图

@class ZQSmallPhotoView;

@protocol ZQSmallPhotoViewDelegate <NSObject>

/**
 * @brief 选择某个索引下的缩略图
 *
 * @param smallPhotoView 缩率图对象
 * @param indexPath      选中当前缩略图的索引
 */
- (void)smallPhotoView:(ZQSmallPhotoView *)smallPhotoView didSelectedItem:(NSIndexPath *)indexPath;

@end

@interface ZQSmallPhotoView : UIView

/**
 * @brief 工厂方法
 *
 * @param frame    尺寸大小
 * @param delegate 代理对象
 */
+ (ZQSmallPhotoView *)smallViewWithFrame:(CGRect)frame delegate:(id<ZQSmallPhotoViewDelegate>)delegate;

/**
 * @brief 更新数据
 *
 * @param assets 照片集
 */
- (void)reloadData:(NSArray *)assets;

/**
 * @brief 更新UI的状态
 *
 * @param indexPath 索引
 */
- (void)updateItemStatus:(NSIndexPath *)indexPath;

@end
