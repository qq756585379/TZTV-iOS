//
//  MyOrder.m
//  TZTV
//
//  Created by Luosa on 2016/12/3.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrder.h"

@implementation MyOrderSon
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end


@implementation MyOrder
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"goodsList" : [MyOrderSon class]
             };
}
-(NSMutableArray *)goodsList{
    if (!_goodsList) {
        _goodsList=[NSMutableArray array];
    }
    return _goodsList;
}
@end
