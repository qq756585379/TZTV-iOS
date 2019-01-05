//
//  HomePageCellTableViewCell.m
//  TZTV
//
//  Created by Luosa on 2016/11/10.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomePageCellTableViewCell.h"
#import "OTSCollectionVIew.h"
#import "HomeScrollItem.h"

@interface HomePageCellTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet OTSCollectionView *scrollCollectionView;
@end

@implementation HomePageCellTableViewCell

+(CGFloat)cellHeight{
    return 50+128+ScreenW*360/750;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.scrollCollectionView.showsVerticalScrollIndicator=NO;
    self.scrollCollectionView.showsHorizontalScrollIndicator=NO;
    [self.scrollCollectionView registerNib:[HomeScrollItem nib] forCellWithReuseIdentifier:[HomeScrollItem cellReuseIdentifier]];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeScrollItem *item=(HomeScrollItem *)[collectionView dequeueReusableCellWithReuseIdentifier:[HomeScrollItem cellReuseIdentifier] forIndexPath:indexPath];
    return item;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(93,128);
//}
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0,0,0,0);
//}

@end
