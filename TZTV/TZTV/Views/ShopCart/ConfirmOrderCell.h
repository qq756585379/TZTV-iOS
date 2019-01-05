//
//  ConfirmOrderCell.h
//  TZTV
//
//  Created by Luosa on 2016/11/29.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"

@interface ConfirmOrderCell : YJTableViewCell

@property (nonatomic, strong) CartModel *cart;

@property (nonatomic,   copy) void(^myBlock)();

@end
