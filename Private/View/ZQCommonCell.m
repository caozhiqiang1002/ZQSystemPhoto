//
//  ZQCommonCell.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/23.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQCommonCell.h"
#import "ZQPhotoManager.h"

#pragma mark - 照片列表

@interface ZQPhotoCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation ZQPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createImageView];
        [self createSelectImageView];
        [self createCountLabel];
    }
    return self;
}

- (void)createImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageView];
}

- (void)createSelectImageView {
    self.selectImageView = [UIImageView imageViewWithFrame:CGRectZero
                                                 imageName:@"select_white"
                                                  selector:@selector(sureClick)
                                                    target:self];
    self.selectImageView.backgroundColor = ZQUIColorAFromHex(0x000000, 0.2);
    [self addSubview:self.selectImageView];
    
    self.selectImageView.clipsToBounds = YES;
    self.selectImageView.layer.cornerRadius = 12.5f;
}

- (void)createCountLabel {
    self.countLabel = [UILabel labelWithFrame:CGRectZero
                                        title:nil
                                         font:ZQFont(15.0f)
                                     selector:@selector(cancelClick)
                                       target:self];
    self.countLabel.backgroundColor = ZQUIColorFromHex(0x51aa38);
    self.countLabel.textColor = ZQUIColorFromHex(0xffffff);
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.hidden = YES;
    [self addSubview:self.countLabel];
    
    self.countLabel.clipsToBounds = YES;
    self.countLabel.layer.cornerRadius = 12.5f;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    self.selectImageView.frame = CGRectMake(self.width-25, 0, 25, 25);
    
    self.countLabel.frame = self.selectImageView.frame;
}

- (void)sureClick {
    
    if (![self.delegate photoCell:self isSelectImage:YES]) {
        return;
    }
    
    self.countLabel.hidden = NO;
    self.selectImageView.hidden = YES;
    self.countLabel.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:0.3f
          initialSpringVelocity:10.0f
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.countLabel.transform = CGAffineTransformIdentity;
                        }
                     completion:nil];
}

- (void)cancelClick {
    
    if (![self.delegate photoCell:self isSelectImage:NO]) {
        return;
    }
    
    self.countLabel.hidden = YES;
    self.selectImageView.hidden = NO;
}

- (void)handleData:(UIImage *)image {
    self.imageView.image = image;
}

- (void)updateSeleectedImageCount:(NSUInteger)count isSelected:(BOOL)isSelected {
    self.countLabel.text = [NSString stringWithFormat:@"%lu",count];
    self.selectImageView.hidden = isSelected;
    self.countLabel.hidden = !isSelected;
}

@end


#pragma mark - 相册列表

@interface ZQPhotoAlbumCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@end

@implementation ZQPhotoAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = ZQUIColorFromHex(0xfefefe);
        
        [self createIconImageView];
        [self createTitleLabel];
        [self createCountLabel];
    }
    return self;
}

- (void)createIconImageView {
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.backgroundColor = [UIColor clearColor];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.clipsToBounds = YES;
    [self addSubview:self.iconImageView];
}

- (void)createTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [self addSubview:self.titleLabel];
}

- (void)createCountLabel {
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.textColor = ZQUIColorFromHex(0x7f7f7f);
    self.countLabel.font = [UIFont systemFontOfSize:17.0f];
    [self addSubview:self.countLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize titleSize = [self.titleLabel.text sizeWithDirection:ZQTextDirectionHorizontal
                                                   fixedLength:self.height
                                                    attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]}];
    
    self.iconImageView.frame = CGRectMake(0, 0, self.height, self.height);
    
    self.titleLabel.frame = CGRectMake(self.iconImageView.maxX + 20,
                                       0,
                                       titleSize.width,
                                       self.height);
    
    self.countLabel.frame = CGRectMake(self.titleLabel.maxX,
                                       self.titleLabel.minY,
                                       self.width - self.titleLabel.maxX,
                                       self.titleLabel.height);
}

- (void)handleData:(NSString *)title images:(NSArray *)images {
    self.titleLabel.text = title;
    self.countLabel.text = [NSString stringWithFormat:@"（%lu）", images.count];
    
    [[ZQPhotoManager sharedInstance] getSmallImageInfo:images.firstObject
                                                  size:ZQPhotoSmallSize
                                               handler:^(UIImage *image, NSDictionary *imageInfo) {
                                                   self.iconImageView.image = image;
                                               }];
    
    [self setNeedsLayout];
}

@end


#pragma mark - 照片详情中的原图

@interface ZQPhotoDetailCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ZQPhotoDetailCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createImageView];
    }
    return self;
}

- (void)createImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageView];
}

- (void)handleData:(UIImage *)image {
    self.imageView.image = image;
}

@end


#pragma mark - 照片详情中的缩放图

@interface ZQPhotoSmallCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ZQPhotoSmallCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createImageView];
    }
    return self;
}

- (void)createImageView {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageView];
    
    self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.imageView.layer.borderWidth = 2.0f;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

- (void)handleData:(UIImage *)image {
    self.imageView.image = image;
}

- (void)updateStatus:(BOOL)isSelected {
    if (isSelected) {
        self.imageView.layer.borderColor = ZQUIColorFromHex(0x51aa38).CGColor;
    }else{
        self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
