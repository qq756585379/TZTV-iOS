//
//  CityListCell.m
//  TZTV
//
//  Created by Luosa on 2016/11/11.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "CityListCell.h"
#import "CityListItem.h"

@interface CityListCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet YJCollectionView *myCollectionV;
@end

@implementation CityListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.myCollectionV registerClass:[CityListItem class] forCellWithReuseIdentifier:[CityListItem cellReuseIdentifier]];
}

-(void)setCityArray:(NSArray *)cityArray{
    _cityArray=cityArray;
    [self.myCollectionV reloadData];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _cityArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CityListItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:[CityListItem cellReuseIdentifier] forIndexPath:indexPath];
    item.backgroundColor=[UIColor whiteColor];
    item.customLabel.text=self.cityArray[indexPath.row];
//    if (_cityArray.count>1) {
//        NSString *savedCityStr=[YJTool objectForKey:savedCity];
//        if ([savedCityStr isEqualToString:_cityArray[indexPath.row]]) {
//            cell.customL.backgroundColor=TabBarColor;
//            cell.customL.textColor=[UIColor whiteColor];
//        }
//    }
    return item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    BaseCollectionItem *cell = (BaseCollectionItem *)[collectionView cellForItemAtIndexPath:indexPath];
//    [YJTool setObject:cell.customL.text forKey:savedCity];
//    if ([self.delegate respondsToSelector:@selector(headerCellDidSelectCity:)]) {
//        [self.delegate headerCellDidSelectCity:_cityArray[indexPath.row]];
//    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-60)/3, 45);
}

//返回Section距离父视图的边距(上左下右)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,20,10,20);
}

+ (CGFloat)heightForCellData:(id)aData{
    NSArray *arr=aData;
    return 30 + (arr.count/3 + 1) * 55+10;
}

@end
