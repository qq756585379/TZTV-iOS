//
//  ShopCartHeaderView.h
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "CartModel.h"

@interface ShopCartHeaderView : YJTableHeaderFooterView

@property (nonatomic, strong) CartModel *cartModel;

@property (nonatomic,   copy) void(^headerBlock)();

//@property (nonatomic, assign) NSInteger section;

@end
