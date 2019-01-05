//
//  YouHuiJuanCell.h
//  TZTV
//
//  Created by Luosa on 2016/11/28.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

@interface YouHuiJuanCell : YJTableViewCell

@property (nonatomic, strong) CouponModel *coupon;

@property (weak, nonatomic) IBOutlet UILabel *titleL;//新世纪周年庆
@property (weak, nonatomic) IBOutlet UILabel *quanmaLabel;//券码
@property (weak, nonatomic) IBOutlet UILabel *useDateLabel;//使用期限
@property (weak, nonatomic) IBOutlet UILabel *moneyL;//优惠码金额
@property (weak, nonatomic) IBOutlet UILabel *tushuL;//特殊情况说明

@property (weak, nonatomic) IBOutlet UIImageView *shixiaoIcon;//失效图标
@property (weak, nonatomic) IBOutlet UIImageView *usedIcon;//已使用图标

@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UILabel *lebel1;

@end
