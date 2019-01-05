//
//  PLGoodsModel.h
//  TZTV
//
//  Created by Luosa on 2017/2/21.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLGoodsModel : NSObject

@property (nonatomic, assign) NSNumber *nowPrice;
@property (nonatomic, assign) NSNumber *num_id;
@property (nonatomic, assign) NSNumber *ID;
@property (nonatomic, assign) NSNumber *price;
@property (nonatomic,   copy) NSString *picture;
@property (nonatomic,   copy) NSString *catalog_name;
@property (nonatomic, assign) NSNumber *brand_id;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic,   copy) NSString *brand_name;

/*
 {
	nowPrice = 699,
	num_id = 5,
	id = 1000004,
	price = 799,
	picture = http://114.55.234.142:89/tuzi/images/bbbab9f7bb4e2ec0f972411e612f9205.jpg,
	catalog_name = 运动上衣,
	brand_id = 43,
	name = adidas 阿迪达斯 跑步 女子 套衫,
	brand_name = 阿迪达斯（adidas）
 },
 */
@end
