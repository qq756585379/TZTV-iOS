//
//  OrderDetailCell3.m
//  TZTV
//
//  Created by Luosa on 2016/12/6.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "OrderDetailCell3.h"

@implementation OrderDetailCell3

+(CGFloat)heightForCellData:(id)aData
{
    return 80;
}

-(void)setOrder:(MyOrder *)order
{
    _order=order;
    _dingdanbianhaoLabel.text=[NSString stringWithFormat:@"订单编号：%@",order.order_no];
    _jiaoyihaoLabel.text=[NSString stringWithFormat:@"交易号：%@",order.pick_up_code];
    NSString *createTime=[order.create_time safeSubstringToIndex:order.create_time.length-2];
    _createTimeLabel.text=[NSString stringWithFormat:@"创建时间：%@",createTime];
}

@end
