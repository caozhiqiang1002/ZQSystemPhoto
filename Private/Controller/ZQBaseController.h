//
//  ZQBaseController.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/16.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQBaseController : UIViewController

@property (nonatomic, copy) NSString *cellIdentifer;
@property (nonatomic, copy) NSString *cellClassName;

- (void)configCellInfo;

- (void)getImage:(UIImage *)image indexPath:(NSIndexPath *)indexPath cell:(id)cell;

@end

