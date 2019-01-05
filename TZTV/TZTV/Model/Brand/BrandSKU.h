//
//  BrandSKU.h
//  TZTV
//
//  Created by Luosa on 2016/11/24.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandSKU : NSObject
@property (nonatomic,   copy) NSString *ID;    //商品id
@property (nonatomic,   copy) NSString *brand_name;
@property (nonatomic,   copy) NSString *catalog_name;//分类
@property (nonatomic,   copy) NSString *isnew;
@property (nonatomic,   copy) NSString *picture;
@property (nonatomic,   copy) NSString *market_name;
@property (nonatomic,   copy) NSString *nowPrice;
//@property (nonatomic, assign) NSInteger stock;//库存要看sku_dict里
@property (nonatomic, assign) NSNumber *brand_id;
@property (nonatomic,   copy) NSString *brand_img;
@property (nonatomic,   copy) NSString *issale;
@property (nonatomic,   copy) NSString *price;
@property (nonatomic, assign) NSNumber *sellcount;
@property (nonatomic,   copy) NSString *express_price;
@property (nonatomic,   copy) NSString *images;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic, strong) NSArray  *skuList;

@property (nonatomic,   copy) NSDictionary *sku_dict;

-(instancetype)initWithDict:(NSDictionary *)dict;


@end
