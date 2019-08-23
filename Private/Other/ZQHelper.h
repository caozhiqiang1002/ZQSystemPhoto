//
//  ZQHelper.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/15.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQHelper : NSObject

#pragma mark - 视图相关

/**
 * @brief 获取根控制器
 */
+ (UIViewController *)getRootVC;

/**
 * @brief 获取当前控制器
 */
+ (UIViewController *)getCurrentVC;

/**
 * @brief 获取当前窗口
 */
+ (UIWindow *)getWindow;

#pragma mark - 尺寸相关

/**
 * @brief 相对于window的安全区
 */
+ (UIEdgeInsets)safeAreaInsetsForWindow;

/**
 * @brief 实际的导航栏高度
 */
+ (CGFloat)navBarHeight;

/**
 * @brief 实际的Tab栏高度
 */
+ (CGFloat)tabBarHeight;

@end
