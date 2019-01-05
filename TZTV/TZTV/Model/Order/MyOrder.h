//
//  MyOrder.h
//  TZTV
//
//  Created by Luosa on 2016/12/3.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderSon : NSObject
@property (nonatomic,   copy) NSString *goods_name;
@property (nonatomic,   copy) NSString *ID;
@property (nonatomic,   copy) NSString *goods_color;
@property (nonatomic,   copy) NSString *brand_name;
@property (nonatomic,   copy) NSString *catalog_name;
@property (nonatomic, assign) NSInteger goods_num;
@property (nonatomic,   copy) NSString *goods_img;
// 订单商品状态；0：正常；1：退货中；2：退货完成
@property (nonatomic, assign) NSInteger goods_state;
@property (nonatomic,   copy) NSString *brand_id;
@property (nonatomic, assign) NSInteger goods_stock;
@property (nonatomic,   copy) NSString *goods_size;
@property (nonatomic,   copy) NSString *goods_id;
@property (nonatomic, assign) NSNumber *goods_price;
@property (nonatomic,   copy) NSString *order_no;
@end

@interface MyOrder : NSObject
@property (nonatomic,   copy) NSString *ID;
@property (nonatomic,   copy) NSString *pick_up_code;
@property (nonatomic, assign) NSNumber *pay_done;
@property (nonatomic,   copy) NSString *effective_time;
@property (nonatomic,   copy) NSString *user_id;
@property (nonatomic,   copy) NSString *coupon_token;
@property (nonatomic,   copy) NSString *brand_id;
@property (nonatomic, assign) NSNumber *order_original_price;
@property (nonatomic,   copy) NSString *order_no;
@property (nonatomic, assign) NSNumber *coupon_price;//优惠金额
@property (nonatomic,   copy) NSString *create_time;

@property (nonatomic,   copy) NSString *order_name;
@property (nonatomic,   copy) NSString *order_phone;
@property (nonatomic, assign) NSNumber *order_price;//订单价格
@property (nonatomic,   copy) NSString *order_address;//订单地址
// 订单状态；-1：已关闭，0：待付款，1：待发货，2：待收货，3：已完成，4：退款中，5：已退款，6：已提货显示待收货
@property (nonatomic, assign) NSInteger order_state;

@property (nonatomic, assign) NSInteger express_method;//
@property (nonatomic,   copy) NSString *express_code;//运单编号
@property (nonatomic,   copy) NSString *express_name;//顺丰
@property (nonatomic, assign) NSNumber *express_price;//运费
//
@property (nonatomic,   copy) NSString *brand_img;
@property (nonatomic,   copy) NSString *brand_name;

@property (nonatomic, strong) NSMutableArray *goodsList;

@end
