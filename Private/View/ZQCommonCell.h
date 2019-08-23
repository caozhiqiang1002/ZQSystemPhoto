//
//  ZQCommonCell.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/23.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 照片列表

@class ZQPhotoCell;

@protocol ZQPhotoCellDelegate <NSObject>

- (BOOL)photoCell:(ZQPhotoCell *)cell isSelectImage:(BOOL)isSelect;

@end


@interface ZQPhotoCell : UICollectionViewCell

@property (nonatomic, weak) id<ZQPhotoCellDelegate> delegate;

- (void)handleData:(UIImage *)image;

- (void)updateSeleectedImageCount:(NSUInteger)count isSelected:(BOOL)isSelected;

@end


#pragma mark - 相册列表

@interface ZQPhotoAlbumCell : UITableViewCell

- (void)handleData:(NSString *)title images:(NSArray *)images;

@end


#pragma mark - 照片详情中的原图

@interface ZQPhotoDetailCell : UICollectionViewCell

- (void)handleData:(UIImage *)image;

@end


#pragma mark - 照片详情中的缩放图

@interface ZQPhotoSmallCell : UICollectionViewCell

- (void)handleData:(UIImage *)image;

- (void)updateStatus:(BOOL)isSelected;

@end


