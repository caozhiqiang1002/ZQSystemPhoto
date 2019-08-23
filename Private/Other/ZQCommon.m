//
//  ZQCommon.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/21.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQCommon.h"
#import "ZQPhotoManager.h"

@implementation ZQFetchAlbumInfoModel

+ (instancetype)modelWithTitle:(NSString *)title result:(PHFetchResult<PHAsset *> *)fetchResult {
    
    ZQFetchAlbumInfoModel *model = [[ZQFetchAlbumInfoModel alloc] init];
    model.title = title;
    model.fetchResult = fetchResult;
    model.count = fetchResult.count;
    
    return model;
}

@end




@implementation ZQPhotoListConfig

- (instancetype)initWithWholeAssets:(NSArray *)wholeAssets {
    if (self = [super init]) {
        _wholeAssets = wholeAssets;
        _selectedIndexPaths = [[NSMutableArray alloc] init];
        _selectedAssets = [[NSMutableArray alloc] init];
        _selectedImgInfo = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (ZQPhotoListConfig *)configWithWholeAssets:(NSArray *)wholeAssets {
    ZQPhotoListConfig *config = [[self alloc] initWithWholeAssets:wholeAssets];
    return config;
}

- (void)addIndexPath:(NSIndexPath *)indexPath {
    [_selectedIndexPaths addObject:indexPath];
    
    PHAsset *asset = _wholeAssets[indexPath.item];
    
    [_selectedAssets addObject:asset];
    
    __weak typeof(NSMutableArray *) weakSelectedImgInfo = _selectedImgInfo;
    [[ZQPhotoManager sharedInstance] getSmallImageInfo:asset size:ZQPhotoBigSize handler:^(UIImage *image, NSDictionary *imageInfo) {
        NSDictionary *info = @{kZQImagekey: image, kZQImageInfoKey: imageInfo};
        [weakSelectedImgInfo addObject:info];
    }];
}

- (void)removeIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = _wholeAssets[indexPath.item];
    [_selectedAssets removeObject:asset];
    
    for (NSInteger index = 0; index < _selectedIndexPaths.count; index++) {
        NSIndexPath *subIndexPath = _selectedIndexPaths[index];
        if (subIndexPath.item == indexPath.item) {
            [_selectedImgInfo removeObjectAtIndex:index];
            break;
        }
    }
    
    [_selectedIndexPaths removeObject:indexPath];
}

@end
