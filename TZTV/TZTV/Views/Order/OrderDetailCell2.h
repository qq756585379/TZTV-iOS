//
//  OrderDetailCell2.h
//  TZTV
//
//  Created by Luosa on 2016/12/6.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrder.h"

@interface OrderDetailCell2 : YJTableViewCell

@property (nonatomic, strong) MyOrder       *order;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;//商品价格
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;//邮费
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;//优惠金额
@property (weak, nonatomic) IBOutlet UILabel *dingdanzongjieLabel;//订单总结
@property (weak, nonatomic) IBOutlet UILabel *shifukuangLabel;//实付款


@end
