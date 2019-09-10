//
//  ZQViewController.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/14.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQViewController.h"
#import <ZQSystemPhoto/ZQSystemPhotoAPI.h>

@interface ZQViewController ()

@end

@implementation ZQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"访问照片";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ZQPhotoItemConfig *config = [[ZQPhotoItemConfig alloc] init];
    config.style = ZQPhotoSelectStyleSingle;
    
    [[ZQSystemPhotoAPI sharedAPI] showSystemPhoto:self config:config handler:^(NSArray<NSDictionary *> *imagesInfo) {
        NSLog(@"%@", imagesInfo);
    }];
    
//    [[ZQSystemPhotoAPI sharedAPI] showSystemPhotoAlbum:self config:nil handler:^(NSArray<NSDictionary *> *imagesInfo) {
//        NSLog(@"%@", imagesInfo);
//    }];
}

@end
