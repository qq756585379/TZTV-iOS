//
//  CartModel.m
//  TZTV
//
//  Created by Luosa on 2016/11/25.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "CartModel.h"

@implementation CartModel

-(NSMutableArray *)array{
    if (!_array) {
        _array=[NSMutableArray array];
    }
    return _array;
}

@end
