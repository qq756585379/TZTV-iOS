//
//  ChooseGoodsPropertyVC.h
//  TZTV
//
//  Created by Luosa on 2016/11/19.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandDetailModel.h"
#import "BrandSKU.h"

@interface ChooseGoodsPropertyVC : YJBaseVC

@property (nonatomic, strong) BrandSKU *sku;

//1表示加入购物车   2表示直接购买
@property (nonatomic, assign) NSInteger type;

@end
