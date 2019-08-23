//
//  ZQCommonView.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/23.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQCommonView.h"
#import "ZQDataSource.h"
#import "ZQPhotoManager.h"

@interface ZQNavigationView ()
@property (nonatomic, assign) ZQNavigationViewType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id<ZQNavigationViewDelegate> delegate;
@end

@implementation ZQNavigationView

- (instancetype)initWithFrame:(CGRect)frame
                         type:(ZQNavigationViewType)type
                        title:(NSString *)title
                     delegate:(id<ZQNavigationViewDelegate>)delegate {
    
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        self.title = title;
        self.delegate = delegate;
        
        [self createTitleLabel];
    }
    return self;
}

#pragma mark - Ceate UI

- (void)createTitleLabel {
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(0, self.height-kNavTitleBarHeight, self.width, kNavTitleBarHeight)
                                            title:self.title
                                             font:ZQFontBold(17.0f)
                                        textColor:[UIColor blackColor]
                                        alignment:NSTextAlignmentCenter];
    [self addSubview:titleLabel];
}

#pragma mark - Target

- (void)leftClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationBarLeftOperation)]) {
        [self.delegate navigationBarLeftOperation];
    }
}

- (void)rightClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationBarRightOperation)]) {
        [self.delegate navigationBarRightOperation];
    }
}

#pragma mark - Public

+ (ZQNavigationView *)navigationViewWithType:(ZQNavigationViewType)type
                                       title:(NSString *)title
                                    delegate:(id<ZQNavigationViewDelegate>)delegate {
    
    ZQNavigationView *navigationView = [[ZQNavigationView alloc]
                                        initWithFrame:CGRectMake(0, 0, kScreenWidth, [ZQHelper navBarHeight] + kStatusBarHeight)
                                        type:type
                                        title:title
                                        delegate:delegate];
    return navigationView;
}

- (void)setSubTitles:(NSArray<NSString *> *)titles {
    
    CGRect rect = CGRectZero;
    if (self.type & ZQNavigationViewTypeLeftText) {
        
        CGSize subTitleSize = [titles.firstObject sizeWithDirection:ZQTextDirectionHorizontal
                                                        fixedLength:kNavTitleBarHeight
                                                         attributes:@{NSFontAttributeName: ZQFont(17.0f)}];
        
        rect = CGRectMake(19.0f,
                          self.height-kNavTitleBarHeight,
                          subTitleSize.width,
                          kNavTitleBarHeight);
        
        UILabel *leftLabel = [UILabel labelWithFrame:rect
                                               title:titles.firstObject
                                                font:ZQFont(17.0f)
                                            selector:@selector(leftClick)
                                              target:self];
        leftLabel.tag = 100;
        [self addSubview:leftLabel];
        
    }
    
    if (self.type & ZQNavigationViewTypeRightText) {
        
        CGSize subTitleSize = [titles.lastObject sizeWithDirection:ZQTextDirectionHorizontal
                                                       fixedLength:kNavTitleBarHeight
                                                        attributes:@{NSFontAttributeName: ZQFont(17.0f)}];
        
        rect = CGRectMake(self.width-subTitleSize.width-19.0f,
                          self.height-kNavTitleBarHeight,
                          subTitleSize.width,
                          kNavTitleBarHeight);
        
        UILabel *rightLabel = [UILabel labelWithFrame:rect
                                                title:titles.lastObject
                                                 font:ZQFont(17.0f)
                                             selector:@selector(rightClick)
                                               target:self];
        rightLabel.tag = 101;
        [self addSubview:rightLabel];
    }
}

- (void)setSubImages:(NSArray<NSString *> *)imageNames {
    
    CGRect rect = CGRectZero;
    if (self.type & ZQNavigationViewTypeLeftImage) {
        rect = CGRectMake(0,
                          self.height-kNavImageBarHeight-(kNavTitleBarHeight-kNavImageBarHeight)/2,
                          kNavImageBarWidth,
                          kNavImageBarHeight);
        
        UIImageView *leftImageView = [UIImageView imageViewWithFrame:rect
                                                           imageName:imageNames.firstObject
                                                            selector:@selector(leftClick)
                                                              target:self];
        leftImageView.tag = 200;
        [self addSubview:leftImageView];
        
    }
    if (self.type & ZQNavigationViewTypeRightImage) {
        rect = CGRectMake(self.width-kNavImageBarWidth,
                          self.height-25-(kNavTitleBarHeight-25)/2,
                          kNavImageBarWidth,
                          25);
        
        UIImageView *rightImageView = [UIImageView imageViewWithFrame:rect
                                                            imageName:imageNames.lastObject
                                                             selector:@selector(rightClick)
                                                               target:self];
        rightImageView.tag = 201;
        [self addSubview:rightImageView];
    }
}

- (void)updateBarItemState:(ZQNavigationViewType)type isHidden:(BOOL)isHidden {
    if (type & ZQNavigationViewTypeLeftText) {
        UILabel *leftLabel = (UILabel *)[self viewWithTag:100];
        leftLabel.hidden = isHidden;
    }
    if (type & ZQNavigationViewTypeRightText) {
        UILabel *rightLabel = (UILabel *)[self viewWithTag:101];
        rightLabel.hidden = isHidden;
    }
    if (type & ZQNavigationViewTypeLeftImage) {
        UIImageView *leftImageView = (UIImageView *)[self viewWithTag:200];
        leftImageView.hidden = isHidden;
    }
    if (type & ZQNavigationViewTypeRightImage) {
        UIImageView *rightImageView = (UIImageView *)[self viewWithTag:201];
        rightImageView.hidden = isHidden;
    }
}

@end




@interface ZQTabbarView ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, weak) id<ZQTabbarViewDelegate> delegate;

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UIView *shadowView;

@end

@implementation ZQTabbarView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                     delegate:(id<ZQTabbarViewDelegate>)delegate {
    
    if (self = [super initWithFrame:frame]) {
        self.title = title;
        self.delegate = delegate;
        
        [self createLeftLabel];
        [self createRightLabel];
        [self createShadowView];
    }
    return self;
}

#pragma mark - Create UI

- (void)createLeftLabel {
    self.leftLabel = [UILabel labelWithFrame:CGRectMake(13, 0, 40, self.height)
                                       title:self.title
                                        font:ZQFont(16.0f)
                                    selector:@selector(leftClick)
                                      target:self];
    self.leftLabel.textColor = [UIColor whiteColor];
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.leftLabel];
}

- (void)createRightLabel {
    self.rightLabel = [UILabel labelWithFrame:CGRectMake(self.width-13-60, (self.height-30)/2, 60, 30)
                                        title:@"完成"
                                         font:ZQFont(13.0f)
                                     selector:@selector(rightClick)
                                       target:self];
    self.rightLabel.clipsToBounds = YES;
    self.rightLabel.layer.cornerRadius = 5.0f;
    self.rightLabel.textColor = [UIColor whiteColor];
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    self.rightLabel.backgroundColor = ZQUIColorFromHex(0x51aa38);
    
    [self addSubview:self.rightLabel];
}

- (void)createShadowView {
    self.shadowView = [[UIView alloc] initWithFrame:self.bounds];
    self.shadowView.backgroundColor = ZQUIColorAFromHex(0x000000, 0.6f);
    [self addSubview:self.shadowView];
}

#pragma mark - Target

- (void)leftClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbarLeftOperation)]) {
        [self.delegate tabbarLeftOperation];
    }
}

- (void)rightClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbarRightOperation)]) {
        [self.delegate tabbarRightOperation];
    }
}

#pragma mark - Public

+ (ZQTabbarView *)tabbarViewWithTitle:(NSString *)title
                             delegate:(id<ZQTabbarViewDelegate>)delegate {
    
    return [[self alloc] initWithFrame:CGRectMake(0, kScreenHeight-kTabbarCustomHeight, kScreenWidth, kTabbarCustomHeight)
                                 title:title
                              delegate:delegate];;
}

- (void)hideShadowView:(BOOL)isHide selectedCount:(NSUInteger)selectedCount {
    self.shadowView.hidden = isHide;
    if (isHide) {
        self.rightLabel.text = [NSString stringWithFormat:@"完成(%ld)", selectedCount];
    }else{
        self.rightLabel.text = @"完成";
    }
}

@end




static NSString * const ZQ_Small_CellID = @"ZQ_Small_CellID";

@interface ZQSmallPhotoView ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, weak) id<ZQSmallPhotoViewDelegate> delegate;
@property (nonatomic, strong) ZQDataSource *dataSource;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation ZQSmallPhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self createDataSource];
        [self createCollectionView];
        [self createLineView];
    }
    return self;
}

- (void)createDataSource {
    ZQDataSourceCompletion completion = ^(id item, NSIndexPath *indexPath, id cell) {
        [[ZQPhotoManager sharedInstance] getSmallImageInfo:item size:ZQPhotoSmallSize handler:^(UIImage *image, NSDictionary *imageInfo) {
            [((ZQPhotoSmallCell *)cell) handleData:image];
            [((ZQPhotoSmallCell *)cell) updateStatus:(self.indexPath && indexPath.item == self.indexPath.item)];
        }];
        
    };
    
    self.dataSource = [ZQDataSource dataSourceWithCellID:ZQ_Small_CellID
                                               cellClass:[ZQPhotoSmallCell class]
                                                delegate:nil completion:completion];
}

- (void)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(62.0f, 62.0f);
    layout.minimumInteritemSpacing = 13.0f;
    layout.sectionInset = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, 88.0f)
                                             collectionViewLayout:layout];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ZQPhotoSmallCell class] forCellWithReuseIdentifier:ZQ_Small_CellID];
}

- (void)createLineView {
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.maxY, self.width, 0.5)];
    self.lineView.backgroundColor = ZQUIColorAFromHex(0x303030, 0.95);
    [self addSubview:self.lineView];
}

#pragma mark - Public

+ (ZQSmallPhotoView *)smallViewWithFrame:(CGRect)frame delegate:(id<ZQSmallPhotoViewDelegate>)delegate {
    ZQSmallPhotoView *smallView = [[ZQSmallPhotoView alloc] initWithFrame:frame];
    smallView.delegate = delegate;
    return smallView;
}

- (void)reloadData:(NSArray *)assets {
    self.assets = assets;
    [self.dataSource updateData:assets];
    [self.collectionView reloadData];
}

- (void)updateItemStatus:(NSIndexPath *)indexPath {
    if (indexPath) {
        for (NSInteger index = 0; index < self.assets.count; index++) {
            NSIndexPath *subIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
            ZQPhotoSmallCell *cell = (ZQPhotoSmallCell *)[self.collectionView cellForItemAtIndexPath:subIndexPath];
            [cell updateStatus:NO];
        }
        
        ZQPhotoSmallCell *cell = (ZQPhotoSmallCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell updateStatus:YES];
        
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
    }else{
        ZQPhotoSmallCell *cell = (ZQPhotoSmallCell *)[self.collectionView cellForItemAtIndexPath:self.indexPath];
        [cell updateStatus:NO];
    }
    self.indexPath = indexPath;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath;
    
    
    for (NSInteger index = 0; index < self.assets.count; index++) {
        NSIndexPath *subIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
        ZQPhotoSmallCell *cell = (ZQPhotoSmallCell *)[collectionView cellForItemAtIndexPath:subIndexPath];
        [cell updateStatus:NO];
    }
    
    ZQPhotoSmallCell *cell = (ZQPhotoSmallCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell updateStatus:YES];
    [self.delegate smallPhotoView:self didSelectedItem:indexPath];
}


@end

