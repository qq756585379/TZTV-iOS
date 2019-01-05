//
//  CouponModel.m
//  TZTV
//
//  Created by Luosa on 2016/12/30.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",@"DES" : @"description"};
}

-(NSString *)start_time
{
    return [_start_time safeSubstringToIndex:_start_time.length-2];
}

-(NSString *)end_time
{
    return [_end_time safeSubstringToIndex:_end_time.length-2];
}

@end
