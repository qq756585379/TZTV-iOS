//
//  ConfirmOrderCell0.h
//  TZTV
//
//  Created by Luosa on 2016/11/29.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartModel.h"
#import "MyOrder.h"

@interface ConfirmOrderCell0 : YJTableViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) ShopCartModel *shop;

//订单详情数据
@property (nonatomic, strong) MyOrderSon *orderSon;

@end
