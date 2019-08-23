//
//  ZQPhotoAlbumManager.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/14.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQPhotoAlbumManager.h"
#import "ZQPhotoManager.h"

@implementation ZQPhotoAlbumManager

+ (instancetype)sharedInstance {
    static ZQPhotoAlbumManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark - Public

- (void)getPhotoAlbumList:(void (^)(NSArray * _Nullable, BOOL))completion {
    @zq_weakify(self);
    [self requestAuthorization:^(BOOL isAuthorized) {
        @zq_strongify(self);
        if (isAuthorized) {
            NSMutableArray *photoAlbums = [[NSMutableArray alloc] init];
            [photoAlbums addObjectsFromArray:[self getPhotoAlbumsForFetchResult:[self getSmartAlbum]]];
            [photoAlbums addObjectsFromArray:[self getPhotoAlbumsForFetchResult:[self getUserCustomeAlbum]]];
            if (completion) {
                completion(photoAlbums, YES);
            }
        }else{
            completion(nil, NO);
        }
    }];
}

- (void)getPhotoList:(ZQFetchAlbumInfoModel *)model completion:(void (^)(NSArray * _Nullable))completion {
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    for (PHAsset * asset in model.fetchResult) {
        [photos addObject:asset];
    }
    completion ? completion(photos) : nil;
}

- (void)getWholePhotoList:(void (^)(NSArray * _Nullable))completion {
    
    NSMutableArray *wholePhotos = [[NSMutableArray alloc] init];
    
    //智能相册
    NSArray *smartAlbums = [self getPhotoAlbumsForFetchResult:[self getSmartAlbum]];
    for (ZQFetchAlbumInfoModel *model in smartAlbums) {
        [self getPhotoList:model completion:^(NSArray * _Nullable photos) {
            [wholePhotos addObjectsFromArray:photos];
        }];
    }
    
    //用户自定义相册
    NSArray *customAlbums = [self getPhotoAlbumsForFetchResult:[self getUserCustomeAlbum]];
    for (ZQFetchAlbumInfoModel *model in customAlbums) {
        [self getPhotoList:model completion:^(NSArray * _Nullable photos) {
            [wholePhotos addObjectsFromArray:photos];
        }];
    }
    
    completion ? completion(wholePhotos) : nil;
}

#pragma mark - Private

//获取检索照片条件的配置项
- (PHFetchOptions *)getFetchOption {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
    return options;
}

//获取访问照片库权限
- (void)requestAuthorization:(void(^)(BOOL isAuthorized))completion {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (completion) {
            completion(status == PHAuthorizationStatusAuthorized);
        }
    }];
}

//获取智能相册（该相册是系统自动生成的相册：任务、地点等相册名称）
- (PHFetchResult<PHAssetCollection *> *)getSmartAlbum {
    return [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                    subtype:PHAssetCollectionSubtypeAlbumRegular
                                                    options:nil];
}

//获取用户创建的相册
- (PHFetchResult<PHAssetCollection *> *)getUserCustomeAlbum {
    return (PHFetchResult<PHAssetCollection *> *)[PHAssetCollection fetchTopLevelUserCollectionsWithOptions:nil];
}

//获取在某种 PHFetchResult 下的相册
- (NSArray *)getPhotoAlbumsForFetchResult:(PHFetchResult *)fetchResult {
    PHFetchOptions *options = [self getFetchOption];
    NSMutableArray *photoAlbums = [[NSMutableArray alloc] init];
    for (PHAssetCollection *collection in fetchResult) {
        PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        if (assetResult.count > 0) {
            ZQFetchAlbumInfoModel *model = [ZQFetchAlbumInfoModel modelWithTitle:collection.localizedTitle result:assetResult];
            [photoAlbums addObject:model];
        }
    }
    return photoAlbums;
}

@end
