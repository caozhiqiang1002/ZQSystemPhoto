//
//  ZQPhotoDetailBaseController.h
//  ZQSystemPhoto
//
//  Created by caozhiqiang on 2019/9/9.
//

#import "ZQBaseController.h"

@interface ZQPhotoDetailBaseController : ZQBaseController

@property (nonatomic, strong) UICollectionView *collectionView;

- (void)getPhotoListData;

@end
