//
//  UIKitExtension.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/16.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "UIKitExtension.h"

#pragma mark - NSString

@implementation NSString (ZQCustom)

- (CGSize)sizeWithDirection:(ZQTextDirection)direction
                fixedLength:(CGFloat)fixedLength
                 attributes:(NSDictionary *)attributes {
    
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    
    if (direction == ZQTextDirectionHorizontal) {
        return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, fixedLength)
                                  options:options
                               attributes:attributes
                                  context:nil].size;
    }else{
        return [self boundingRectWithSize:CGSizeMake(fixedLength, MAXFLOAT)
                                  options:options
                               attributes:attributes
                                  context:nil].size;
    }
}

@end

#pragma mark - UIView

@implementation UIView (ZQFrame)

- (void)setMinX:(CGFloat)minX {
    CGRect frame = self.frame;
    frame.origin.x = minX;
    self.frame = frame;
}

- (CGFloat)minX {
    return CGRectGetMinX(self.frame);
}

- (void)setMinY:(CGFloat)minY {
    CGRect frame = self.frame;
    frame.origin.y = minY;
    self.frame = frame;
}

- (CGFloat)minY {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

@end

#pragma mark - UIImageView

@implementation UIImageView (ZQCustom)

+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                          imageName:(NSString *)imageName
                           selector:(SEL)selector target:(id)target {
    
    return [self imageViewWithFrame:frame
                          imageName:imageName
                               mode:UIViewContentModeScaleAspectFit
                       cornerRadius:0.0
                           selector:selector
                             target:target
                           isActive:YES isRadius:NO];
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                          imageName:(NSString *)imageName
                               mode:(UIViewContentMode)mode {
    
    return [self imageViewWithFrame:frame
                          imageName:imageName
                               mode:mode
                       cornerRadius:0.0
                           selector:nil
                             target:nil
                           isActive:NO isRadius:NO];
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                          imageName:(NSString *)imageName
                               mode:(UIViewContentMode)mode
                       cornerRadius:(CGFloat)cornerRadius {
    
    return [self imageViewWithFrame:frame
                          imageName:imageName
                               mode:mode
                       cornerRadius:cornerRadius
                           selector:nil
                             target:nil
                           isActive:NO isRadius:YES];
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                          imageName:(NSString *)imageName
                               mode:(UIViewContentMode)mode
                       cornerRadius:(CGFloat)cornerRadius
                           selector:(SEL)selector
                             target:(id)target
                           isActive:(BOOL)isActive isRadius:(BOOL)isRadius {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = frame;
    imageView.userInteractionEnabled = isActive;
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = mode;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [imageView addGestureRecognizer:tapGesture];
    
    if (isRadius) {
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = cornerRadius;
    }
    
    return imageView;
}

@end

#pragma mark - UILabel

@implementation UILabel (ZQCustom)

+ (UILabel *)labelWithFrame:(CGRect)frame
                      title:(NSString *)title
                       font:(UIFont *)font
                   selector:(SEL)selector target:(id)target {
    
    return [UILabel labelWithFrame:frame
                             title:title
                              font:font
                         textColor:[UIColor blackColor]
                         alignment:NSTextAlignmentLeft
                          selector:selector target:target isActive:YES];
}

+ (UILabel *)labelWithFrame:(CGRect)frame
                      title:(NSString *)title
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment {
    
    return [UILabel labelWithFrame:frame
                             title:title
                              font:font
                         textColor:textColor
                         alignment:alignment
                          selector:nil target:nil isActive:NO];
}

+ (UILabel *)labelWithFrame:(CGRect)frame
                      title:(NSString *)title
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor
                  alignment:(NSTextAlignment)alignment
                   selector:(SEL)selector target:(id)target isActive:(BOOL)isActive {
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    label.userInteractionEnabled = isActive;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = alignment;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [label addGestureRecognizer:tap];
    
    return label;
}

@end

#pragma mark - UIAlertController

@implementation UIAlertController (ZQCustom)

+ (void)settingAlertWithTitle:(NSString *)title
                      message:(NSString *)message
                       target:(UIViewController *)target
                   completion:(void (^)(BOOL))completion {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             completion ? completion(NO) : nil;
                                                         }];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"设置"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           completion ? completion(YES) : nil;
                                                       }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    
    [target presentViewController:alertVC animated:YES completion:nil];
}

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
                cancel:(NSString *)cancel
                  sure:(NSString *)sure
            completion:(void (^)(BOOL))completion {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancel && cancel.length > 0) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 completion ? completion(NO) : nil;
                                                             }];
        [alertVC addAction:cancelAction];
    }
    
    if (sure && sure.length > 0) {
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sure
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               completion ? completion(YES) : nil;
                                                           }];
        [alertVC addAction:sureAction];
    }
    
    [[ZQHelper getCurrentVC] presentViewController:alertVC animated:YES completion:nil];
}

@end
