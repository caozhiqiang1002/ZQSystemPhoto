//
//  ZQPhotoManager.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/15.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQPhotoManager.h"

@interface ZQPhotoManager ()
@property (nonatomic, strong) PHCachingImageManager *manager;
@end

@implementation ZQPhotoManager

+ (instancetype)sharedInstance {
    static ZQPhotoManager *handler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handler = [[self alloc] init];
    });
    return handler;
}

- (instancetype)init {
    if (self = [super init]) {
        self.manager = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
        self.manager.allowsCachingHighQualityImages = YES;
    }
    return self;
}

#pragma mark - Public

- (void)getSmallImageInfo:(PHAsset *)asset size:(CGSize)size handler:(ZQPhotoHandler)handler {
    [self.manager requestImageForAsset:asset
                            targetSize:size
                           contentMode:PHImageContentModeAspectFit
                               options:[self getImageRequestOptions]
                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                             handler ? handler(result, info) : nil;
                         }];
}

- (void)getOriginalImageInfo:(PHAsset *)asset handler:(ZQPhotoHandler)handler {
    [self.manager requestImageDataForAsset:asset
                                   options:[self getImageRequestOptions]
                             resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                 UIImage *image = nil;
                                 if (imageData) {
                                     image = [UIImage imageWithData:imageData];
                                 }
                                 handler ? handler(image, info) : nil;
                             }];
}

- (void)startCaches:(NSArray<PHAsset *> *)assets assetSize:(CGSize)assetSize
{
    [self.manager startCachingImagesForAssets:assets
                                   targetSize:assetSize
                                  contentMode:PHImageContentModeAspectFit
                                      options:[self getImageRequestOptions]];
}

- (void)stopCaches:(NSArray<PHAsset *> *)assets assetSize:(CGSize)assetSize
{
    [self.manager stopCachingImagesForAssets:assets
                                  targetSize:assetSize
                                 contentMode:PHImageContentModeAspectFit
                                     options:[self getImageRequestOptions]];
}

- (void)resetCachesAsset {
    [self.manager stopCachingImagesForAllAssets];
}

#pragma mark - Prvate

- (PHImageRequestOptions *)getImageRequestOptions {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    return options;
}

@end
