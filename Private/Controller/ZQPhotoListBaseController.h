//
//  ZQPhotoListBaseController.h
//  ZQSystemPhoto
//
//  Created by caozhiqiang on 2019/9/9.
//

#import "ZQBaseController.h"
#import "ZQPhotoAlbumManager.h"

@interface ZQPhotoListBaseController : ZQBaseController

@property (nonatomic, strong) ZQFetchAlbumInfoModel *model;
@property (nonatomic, strong) UICollectionView *collectionView;

@end
