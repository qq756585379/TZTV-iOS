//
//  MyOrderCell3.h
//  TZTV
//
//  Created by Luosa on 2016/11/22.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrder.h"

@interface MyOrderCell3 : YJTableViewCell

@property (nonatomic, strong) MyOrder *order;

@property (nonatomic,   copy) void(^block)(void);

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
