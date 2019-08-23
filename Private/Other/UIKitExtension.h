//
//  UIKitExtension.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/16.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZQTextDirection) {
    ZQTextDirectionHorizontal,
    ZQTextDirectionVertical,
};

#pragma mark - NSString

@interface NSString (ZQCustom)

- (CGSize)sizeWithDirection:(ZQTextDirection)direction fixedLength:(CGFloat)fixedLength attributes:(NSDictionary *)attributes;

@end

#pragma mark - UIView

@interface UIView (ZQFrame)

@property (nonatomic, assign) CGFloat minX;
@property (nonatomic, assign) CGFloat minY;

@property (nonatomic, assign, readonly) CGFloat maxX;
@property (nonatomic, assign, readonly) CGFloat maxY;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end

#pragma mark - UIImageView

@interface UIImageView (ZQCustom)

/**
 * @brief 初始化操作
 *
 * @param frame     尺寸
 * @param imageName 图片名
 * @param selector  目标方法
 * @param target    目标对象
 */
+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                          imageName:(NSString *)imageName
                           selector:(SEL)selector target:(id)target;

/**
 * @brief 初始化操作
 *
 * @param frame     尺寸
 * @param imageName 图片名
 * @param mode      图片处理类型
 */
+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                          imageName:(NSString *)imageName
                               mode:(UIViewContentMode)mode;

/**
 * @brief 初始化操作
 *
 * @param frame        尺寸
 * @param imageName    图片名
 * @param mode         图片处理类型
 * @param cornerRadius 圆角
 */
+ (UIImageView *)imageViewWithFrame:(CGRect)frame
                          imageName:(NSString *)imageName
                               mode:(UIViewContentMode)mode
                       cornerRadius:(CGFloat)cornerRadius;

@end

#pragma mark - UILabel

@interface UILabel (ZQCustom)

/**
 * @brief 带用户交互的Label
 *
 * @param frame     位置大小
 * @param title     标题
 * @param font      字体大小
 * @param selector  目标方法
 * @param target    目标对象
 */
+ (UILabel *)labelWithFrame:(CGRect)frame
                      title:(NSString *)title
                       font:(UIFont *)font
                   selector:(SEL)selector target:(id)target;

/**
 * @brief 普通Label
 *
 * @param frame     位置大小
 * @param title     标题
 * @param font      字体大小
 * @param textColor 字体颜色
 * @param alignment 字体位置
 */
+ (UILabel *)labelWithFrame:(CGRect)frame
                      title:(NSString *)title
                       font:(UIFont *)font
                  textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment;

@end

#pragma mark - UIAlertController

@interface UIAlertController (ZQCustom)

/**
 * @brief 提示权限需要设置
 *
 * @param title      标题
 * @param message    信息内容
 * @param target     目标对象
 * @param completion 完成回调
 */
+ (void)settingAlertWithTitle:(NSString *)title
                      message:(NSString *)message
                       target:(UIViewController *)target
                   completion:(void(^)(BOOL isSure))completion;

/**
 * @brief 提示权限需要设置
 *
 * @param title      标题
 * @param message    信息内容
 * @param cancel     取消的标题
 * @param sure       其他标题
 * @param completion 完成回调
 */
+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
                cancel:(NSString *)cancel
                  sure:(NSString *)sure
            completion:(void(^)(BOOL isSure))completion;

@end
