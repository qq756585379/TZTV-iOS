//
//  CouponModel.h
//  TZTV
//
//  Created by Luosa on 2016/12/30.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject

@property (nonatomic,   copy) NSString *ID;
@property (nonatomic,   copy) NSString *user_id;
@property (nonatomic,   copy) NSString *activity_id;
@property (nonatomic,   copy) NSString *coupon_token;
@property (nonatomic, assign) NSInteger status;// 0,正常;1,代表已使用；2，已失效
@property (nonatomic,   copy) NSString *market_id;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic,   copy) NSString *DES;
@property (nonatomic,   copy) NSString *coupon_amount;
@property (nonatomic,   copy) NSString *conditions_amount;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic,   copy) NSString *start_time;
@property (nonatomic,   copy) NSString *end_time;
@property (nonatomic,   copy) NSString *create_time;

@end

/**
 {
 "activity_id":8,
 "conditions_amount":0,
 "count":1500,
 "coupon_amount":30,
 "coupon_token":"1230102009753800",
 "create_time":"2016-12-30 10:20:09.0",
 "description":"新世界周年庆",
 "end_time":"2017-01-01 10:52:01.0",
 "id":9,
 "market_id":1,
 "name":"购物积点卡",
 "start_time":"2016-12-29 10:52:09.0",
 "status":0,
 "user_id":100013
 },
 */
