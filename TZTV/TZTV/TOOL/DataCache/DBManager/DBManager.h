//
//  DBManager.h
//  TZTV
//
//  Created by Luosa on 2016/11/23.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopCartModel.h"
#import "AddressModel.h"

@interface DBManager : NSObject

/**
 *  添加一个到购物车
 */
//+ (void)addToShopCart:(ShopCartModel *)deal;
/**
 *  从购物车删除一个
 */
//+ (void)removeShopCart:(ShopCartModel *)deal;

+ (NSMutableArray *)getShopCartArray;


@end
