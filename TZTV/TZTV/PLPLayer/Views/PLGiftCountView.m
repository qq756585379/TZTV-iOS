//
//  PLGiftCountView.m
//  TZTV
//
//  Created by Luosa on 2017/2/22.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "PLGiftCountView.h"
#import "PLGiftCountViewItem.h"

@implementation PLGiftCountView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUpUI];
}

-(void)setUpUI{
    // 150 150
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(50, 50);
    UICollectionView *contentView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self addSubview:contentView];
    [contentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [contentView autoSetDimension:ALDimensionHeight toSize:150];
    contentView.backgroundColor = kF5F5F5;
    contentView.dataSource = self;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.scrollsToTop = NO;
    contentView.bounces = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    [contentView registerNib:[PLGiftCountViewItem nib] forCellWithReuseIdentifier:[PLGiftCountViewItem cellReuseIdentifier]];
    [contentView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

#pragma mark - Collection view data souce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PLGiftCountViewItem *item=[collectionView dequeueReusableCellWithReuseIdentifier:[PLGiftCountViewItem cellReuseIdentifier]
                                                                        forIndexPath:indexPath];
    item.countLabel.text=[[self countString] safeObjectAtIndex:indexPath.row];
    return item;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string=[[self countString] safeObjectAtIndex:indexPath.row];
    if (self.myBlock) {
        self.myBlock(string);
    }
}
-(NSArray *)countString{
    return @[@"1",@"10",@"20",@"66",@"88",@"99",@"520",@"888",@"1314"];
}

@end




