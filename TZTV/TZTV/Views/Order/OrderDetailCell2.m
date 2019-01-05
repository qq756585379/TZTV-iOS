//
//  OrderDetailCell2.m
//  TZTV
//
//  Created by Luosa on 2016/12/6.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "OrderDetailCell2.h"

@implementation OrderDetailCell2

+(CGFloat)heightForCellData:(id)aData{
    return 140;
}

-(void)setOrder:(MyOrder *)order{
    _order=order;
    _totalLabel.text=[NSString stringWithFormat:@"￥%@",order.order_price];
    _yunfeiLabel.text=[NSString stringWithFormat:@"￥%@",order.express_price];
    _youhuiLabel.text=[NSString stringWithFormat:@"￥%@",order.coupon_price];
    //订单总结是订单价格减去优惠价格
    float zongjie=[order.order_price floatValue] - [order.coupon_price floatValue];
    _dingdanzongjieLabel.text=[NSString stringWithFormat:@"￥%.2f",zongjie];
    _shifukuangLabel.text=[NSString stringWithFormat:@"￥%.2f",zongjie];
}

@end
