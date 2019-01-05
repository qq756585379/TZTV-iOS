//
//  FenLeiTableCell.m
//  TZTV
//
//  Created by Luosa on 2017/2/23.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "FenLeiTableCell.h"
#import "FenLeiCollectionCell.h"
#import "FenLeiDetailVC.h"
#import "FenLeiSearchVC.h"

@interface FenLeiTableCell()
@property (nonatomic, strong) YJBlockImageView *imageV;
@property (nonatomic, strong) UICollectionView *collectView;
@end

@implementation FenLeiTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    self.imageV=[[YJBlockImageView alloc] init];
    [self.contentView addSubview:self.imageV];
    [self.imageV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.imageV autoSetDimension:ALDimensionHeight toSize:ScreenW*260/750];
    
    WEAK_SELF
    [self.imageV setBlock:^(YJBlockImageView *sender) {
        FenLeiSearchVC *vc = [FenLeiSearchVC new];
        vc.keyWord=weakSelf.bigModel.name;
//        YJNav *nvc = [[YJNav alloc] initWithRootViewController:vc];
//        [[YJTOOL getRootControllerSelectedVc] presentViewController:nvc animated:YES completion:nil];
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(ScreenW/3, ScreenW/3);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectView = [[UICollectionView alloc]
                                     initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.contentView addSubview:collectView];
    [collectView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [collectView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.imageV];
    
    collectView.backgroundColor=[UIColor whiteColor];
    collectView.dataSource = self;
    collectView.delegate = self;
    collectView.pagingEnabled = YES;
    collectView.scrollsToTop = NO;
    collectView.bounces = NO;
    collectView.showsVerticalScrollIndicator = NO;
    collectView.showsHorizontalScrollIndicator = NO;
    [collectView registerNib:[FenLeiCollectionCell nib] forCellWithReuseIdentifier:[FenLeiCollectionCell cellReuseIdentifier]];
    self.collectView=collectView;
}

+ (CGFloat)heightForCellData:(id)aData
{
    NSMutableArray *arr=aData;
    return ScreenW*260/750 + ((arr.count-1)/3 + 1)*(ScreenW/3);
}

-(void)setBigModel:(FenLeiModel *)bigModel
{
    _bigModel=bigModel;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:bigModel.img] placeholderImage:[UIImage imageNamed:@""]];
    [self.collectView reloadData];
}

#pragma mark - Collection view data souce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bigModel.brandList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FenLeiCollectionCell *item=[collectionView dequeueReusableCellWithReuseIdentifier:[FenLeiCollectionCell cellReuseIdentifier] forIndexPath:indexPath];
    SubBrandModel *subM=[self.bigModel.brandList safeObjectAtIndex:indexPath.row];
    [item.iv sd_setImageWithURL:[NSURL URLWithString:subM.brand_img] placeholderImage:[UIImage imageNamed:@"144"]];
    item.titleL.text=subM.brand_name;
    return item;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SubBrandModel *subM=[self.bigModel.brandList safeObjectAtIndex:indexPath.row];
    FenLeiDetailVC *vc=[FenLeiDetailVC new];
    vc.brand_id=subM.brand_id;
    vc.title=subM.brand_name;
    [[YJTOOL getRootControllerSelectedVc] pushViewController:vc animated:YES];
}

@end






