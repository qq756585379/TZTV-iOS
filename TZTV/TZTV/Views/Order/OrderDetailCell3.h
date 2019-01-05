//
//  OrderDetailCell3.h
//  TZTV
//
//  Created by Luosa on 2016/12/6.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrder.h"

@interface OrderDetailCell3 : YJTableViewCell

@property (nonatomic, strong) MyOrder       *order;

//订单编号
@property (weak, nonatomic) IBOutlet UILabel *dingdanbianhaoLabel;
//交易号
@property (weak, nonatomic) IBOutlet UILabel *jiaoyihaoLabel;
//创建时间
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

@end
