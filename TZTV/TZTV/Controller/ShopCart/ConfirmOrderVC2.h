//
//  ConfirmOrderVC2.h
//  TZTV
//
//  Created by Luosa on 2016/12/1.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "AddressModel.h"
#import "MyOrder.h"

typedef NS_ENUM(NSUInteger, ConfirmOrderType) {
    ConfirmOrderTypeFromMyOrderSon         = 1,
    ConfirmOrderTypeFromComfirmOrderVC     = 2
};

@interface ConfirmOrderVC2 : YJTableViewController

//ConfirmOrderTypeFromComfirmOrderVC
@property (nonatomic,   copy) NSString      *totalPrice;
@property (nonatomic,   copy) NSString      *data;
@property (nonatomic, strong) AddressModel  *addressM;

//我的订单里的去付款按钮点击进来传这个参数,ConfirmOrderTypeFromMyOrderSon
@property (nonatomic, strong) MyOrder *order;//order里有price,address等信息

@property (nonatomic, assign) ConfirmOrderType type;

@end
