//
//  OTSCollectionVIew.m
//  OneStoreFramework
//
//  Created by Aimy on 14-7-2.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSCollectionView.h"
#import "OTSCollectionViewCell.h"
#import "OTSCollectionReusableView.h"
#import "OTSWeakObjectDeathNotifier.h"

@implementation OTSCollectionView

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [super dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([cell isKindOfClass:[OTSCollectionViewCell class]]) {
        [(OTSCollectionViewCell *)cell setIndexPath:indexPath];
    }
    return cell;
}

- (id)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [super dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier forIndexPath:indexPath];
    if ([cell isKindOfClass:[OTSCollectionReusableView class]]) {
        [(OTSCollectionReusableView *)cell setIndexPath:indexPath];
    }
    return cell;
}

- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate{
    [super setDelegate:delegate];
    if (delegate == nil) {
        return;
    }
    OTSWeakObjectDeathNotifier *wo = [OTSWeakObjectDeathNotifier new];
    [wo setOwner:delegate];
    WEAK_SELF;
    [wo setBlock:^(OTSWeakObjectDeathNotifier *sender) {
        STRONG_SELF;
        self.delegate = nil;
        self.dataSource = nil;
    }];
}

- (void)reloadData{
    [self.collectionViewLayout invalidateLayout];
    [super reloadData];
}

@end
