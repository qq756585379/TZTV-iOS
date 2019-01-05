//
//  BrandCategoryItem.h
//  TZTV
//
//  Created by Luosa on 2016/11/15.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandCategoryModel.h"
#import "BrandRecommendModel.h"

@interface BrandCategoryItem : YJCollectionViewCell

@property (nonatomic, strong) BrandSubModel *subModel;
@property (nonatomic, strong) BrandModel    *brandModel;
@property (nonatomic, strong) MarketModel   *marketModel;

@end
