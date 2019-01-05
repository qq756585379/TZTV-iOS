//
//  BrandRecommendModel.m
//  TZTV
//
//  Created by Luosa on 2016/11/22.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandRecommendModel.h"

@implementation MarketModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end

@implementation BrandModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end

@implementation BrandRecommendModel
/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"market_list" : [MarketModel class],
             @"brand_list": [BrandModel class]
             };
}
@end
