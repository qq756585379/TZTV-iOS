//
//  BrandCategoryModel.m
//  TZTV
//
//  Created by Luosa on 2016/11/17.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandCategoryModel.h"

@implementation BrandSubModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end


@implementation BrandRightModel

/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"sub_list" : [BrandSubModel class]
             };
}

-(NSMutableArray *)sub_list
{
    if (!_sub_list) {
        _sub_list=[NSMutableArray array];
    }
    return _sub_list;
}

@end


@implementation BrandCategoryModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end
