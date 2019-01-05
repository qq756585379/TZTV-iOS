//
//  OrderDetailCell.h
//  TZTV
//
//  Created by Luosa on 2016/12/6.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrder.h"

@interface OrderDetailCell : YJTableViewCell

@property (nonatomic, strong) MyOrder    *order;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouhuorenLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouhuodizhiLabel;

@end
