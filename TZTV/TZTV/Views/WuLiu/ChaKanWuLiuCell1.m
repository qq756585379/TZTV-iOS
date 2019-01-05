//
//  ChaKanWuLiuCell1.m
//  TZTV
//
//  Created by Luosa on 2016/12/5.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ChaKanWuLiuCell1.h"

@implementation ChaKanWuLiuCell1

-(void)setOrder:(MyOrder *)order{
    _order=order;
    MyOrderSon *son=[_order.goodsList safeObjectAtIndex:0];
    _numLabel.text=[NSString stringWithFormat:@"%d件商品",(int)son.goods_num];
    _stateLabel.text=[self stateStringWith:order.order_state];
    _kuaidiLabel.text=order.express_name;
    _bianhaoLabel.text=order.express_code;
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:son.goods_img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

// 订单状态；-1：已关闭，0：待付款，1：待发货，2：待收货，3：已完成，4：退款中，5：已退款，6：已提货
-(NSString *)stateStringWith:(NSInteger)state{
    if (state==-1) return @"已关闭";
    if (state==0) return @"待付款";
    if (state==1) return @"待发货";
    if (state==2) return @"待收货";
    if (state==3) return @"已完成";
    if (state==4) return @"退款中";
    if (state==5) return @"已退款";
    if (state==6) return @"待收货";
    return @"";
}

@end
