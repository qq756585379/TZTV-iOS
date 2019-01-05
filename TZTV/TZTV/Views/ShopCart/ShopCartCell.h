//
//  ShopCartCell.h
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartModel.h"

@interface ShopCartCell : YJTableViewCell

@property (nonatomic, strong) ShopCartModel *smallModel;

@property (nonatomic,   copy) void(^cellBlock)();

@property (weak,   nonatomic) IBOutlet UITextField *countTF;

@end
