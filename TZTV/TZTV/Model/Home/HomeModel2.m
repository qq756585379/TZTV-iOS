//
//  HomeModel2.m
//  TZTV
//
//  Created by Luosa on 2017/2/27.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "HomeModel2.h"

@implementation HomeModel2

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"goodsList" : [BrandDetailModel class]};
}

-(NSMutableArray *)goodsList
{
    if (!_goodsList) {
        _goodsList=[NSMutableArray array];
    }
    return _goodsList;
}

-(NSString *)create_time
{
    NSArray *timeArr = [_create_time componentsSeparatedByString:@" "];
    if (timeArr.count) {
        return timeArr[0];
    }
    return @"";
}

@end
