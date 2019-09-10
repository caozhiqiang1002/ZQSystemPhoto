//
//  ZQBaseController.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/16.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQBaseController.h"

@interface ZQBaseController ()

@end

@implementation ZQBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
    [UITableView appearance].separatorInset = UIEdgeInsetsZero;
    [UITableView appearance].layoutMargins = UIEdgeInsetsZero;
#endif
    
}

- (void)configCellInfo {

}

- (void)getImage:(UIImage *)image indexPath:(NSIndexPath *)indexPath cell:(id)cell {
    
}

@end
