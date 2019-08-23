//
//  ZQAppDelegate.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/14.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQAppDelegate.h"
#import "ZQViewController.h"

@interface ZQAppDelegate ()

@end

@implementation ZQAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ZQViewController *rootVC = [[ZQViewController alloc] init];
    
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = rootNav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
