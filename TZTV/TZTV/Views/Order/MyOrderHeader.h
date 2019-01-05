//
//  MyOrderHeader.h
//  TZTV
//
//  Created by Luosa on 2016/12/6.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrder.h"

@interface MyOrderHeader : YJTableHeaderFooterView

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *moreIcon;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *desLabel;

@property (nonatomic, strong) MyOrder *order;

@end
