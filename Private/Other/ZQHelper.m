//
//  ZQHelper.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/15.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQHelper.h"

@implementation ZQHelper

+ (UIViewController *)getRootVC {
    return [self getWindow].rootViewController;
}

+ (UIViewController *)getCurrentVC {
    UIViewController * currentVC = [self getRootVC];
    while (1) {
        if (currentVC.presentedViewController) {
            currentVC = currentVC.presentedViewController;
        }else if ([currentVC isKindOfClass:[UINavigationController class]]) {
            currentVC = ((UINavigationController *)currentVC).childViewControllers.lastObject;
        }else if ([currentVC isKindOfClass:[UITabBarController class]]) {
            currentVC = ((UITabBarController *)currentVC).selectedViewController;
        }else {
            if (currentVC.childViewControllers.count > 0) {
                return currentVC.childViewControllers.lastObject;
            }else{
                return currentVC;
            }
        }
    }
}

+ (UIWindow *)getWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [UIApplication sharedApplication].windows.firstObject;
    }
    return window;
}

+ (UIEdgeInsets)safeAreaInsetsForWindow {
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = [self getWindow].safeAreaInsets;
    }
    
    return UIEdgeInsetsMake(safeAreaInsets.top > 20 ? safeAreaInsets.top - 20 : 0,
                            safeAreaInsets.left,
                            safeAreaInsets.bottom,
                            safeAreaInsets.right);
}

+ (CGFloat)navBarHeight {
    UIEdgeInsets safeAreaInset = [self safeAreaInsetsForWindow];
    return safeAreaInset.top + kNavTitleBarHeight;
}

+ (CGFloat)tabBarHeight {
    UIEdgeInsets safeAreaInset = [self safeAreaInsetsForWindow];
    return safeAreaInset.bottom + kTabTitleBarHeight;
}

@end
