//
//  CartModel.h
//  TZTV
//
//  Created by Luosa on 2016/11/25.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartModel : NSObject

@property (nonatomic, assign) NSNumber       *brand_id;
@property (nonatomic,   copy) NSString       *brand_name;
@property (nonatomic,   copy) NSString       *brand_img;

@property (nonatomic, strong) NSMutableArray *array;

/** 记录选中状态 */
@property (nonatomic, assign) BOOL selectState;

@property (nonatomic, assign) BOOL isDeliver;        //是否需要配送
@property (nonatomic,   copy) NSString *order_remark;//买家留言

@end
