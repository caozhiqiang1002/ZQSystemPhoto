//
//  ZQUIDefine.h
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/15.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#ifndef ZQUIDefine_h
#define ZQUIDefine_h

#ifndef zq_weakify
#if DEBUG
#if __has_feature(objc_arc)
#define zq_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object
#else
#define zq_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object
#endif
#else
#if __has_feature(objc_arc)
#define zq_weakify(object) try{} @finally{} __weak __typeof__(object) weak##_##object = object
#else
#define zq_weakify(object) try{} @finally{} __block __typeof__(object) block##_##object = object
#endif
#endif
#endif

#ifndef zq_strongify
#if DEBUG
#if __has_feature(objc_arc)
#define zq_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object
#else
#define zq_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object
#endif
#else
#if __has_feature(objc_arc)
#define zq_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object
#else
#define zq_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object
#endif
#endif
#endif

#define zq_dispatch_main_async_safe(block) \
if ([NSThread isMainThread]) { \
block(); \
} else { \
dispatch_async(dispatch_get_main_queue(), block); \
}


//尺寸相关
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kNavTitleBarHeight 44
#define kStatusBarHeight 20
#define kTabTitleBarHeight 49

#define kNavImageBarHeight 20
#define kNavImageBarWidth  50

#define kTabbarCustomHeight 45


//UI相关
#define ZQUIColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                   green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                    blue:((float)(rgbValue & 0xFF))/255.0 \
                                                    alpha:1.0]

#define ZQUIColorAFromHex(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                       green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                        blue:((float)(rgbValue & 0xFF))/255.0 \
                                                       alpha:a]

#define ZQFontBold(font) [UIFont boldSystemFontOfSize:font]
#define ZQFont(font) [UIFont systemFontOfSize:font]

#define ZQPhotoAlbumTableColor ZQUIColorFromHex(0xf3f3f3)

//照片的缩略图
#define ZQPhotoSmallSize  CGSizeMake(MIN(kScreenWidth, kScreenHeight), MIN(kScreenWidth, kScreenHeight))
#define ZQPhotoBigSize    CGSizeMake(MAX(kScreenWidth, kScreenHeight), MAX(kScreenWidth, kScreenHeight))


//通知相关
#define ZQ_IMAGE_SELECT_NOTIFY


//数据相关
#define ZQ_SELECTED_MAX_COUNT 9
#define kZQImagekey     @"image"
#define kZQImageInfoKey @"imageInfo"

#endif /* ZQUIDefine_h */
