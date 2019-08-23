//
//  ZQDataSource.m
//  ZQSystemPhotoDemo
//
//  Created by caozhiqiang on 2019/8/14.
//  Copyright © 2019 caozhiqiang. All rights reserved.
//

#import "ZQDataSource.h"

@interface ZQDataSource ()

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, copy) NSString *cellID;
@property (nonatomic, strong) Class cellClass;
@property (nonatomic, weak) id<ZQDataSourceDelegate> delegate;
@property (nonatomic, copy) ZQDataSourceCompletion completion;

@end

@implementation ZQDataSource

#pragma mark - Public

+ (ZQDataSource *)dataSourceWithCellID:(NSString *)cellID
                             cellClass:(Class)cellClass
                              delegate:(id<ZQDataSourceDelegate>)delegate
                            completion:(ZQDataSourceCompletion)completion {
    
    ZQDataSource *dataSource = [[ZQDataSource alloc] init];
    dataSource.cellID = cellID;
    dataSource.cellClass = cellClass;
    dataSource.completion = completion;
    dataSource.delegate = delegate;
    
    return dataSource;
}

- (void)updateData:(NSArray *)items {
    self.items = items;
}

- (id)itemWithIndexPath:(NSIndexPath *)indexPath {
    return self.items[indexPath.item];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items ? self.items.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellID];
    if (!cell) {
        cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    self.completion(self.items[indexPath.row], indexPath, cell);
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items ? self.items.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellID forIndexPath:indexPath];
    self.completion(self.items[indexPath.item], indexPath, cell);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [self.delegate collectionView:collectionView kind:kind indexPath:indexPath];
}

@end
