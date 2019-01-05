//
//  ShopCartModel.h
//  TZTV
//
//  Created by Luosa on 2016/11/23.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCartModel : NSObject

@property (nonatomic,   copy) NSString *goods_name;     //商品名称
@property (nonatomic,   copy) NSString *ID;             //购物车id，删除购物车时传这个id
@property (nonatomic,   copy) NSString *goods_color;    //商品颜色
@property (nonatomic,   copy) NSString *brand_name;     //品牌名称
@property (nonatomic,   copy) NSString *catalog_name;   //类别名称
@property (nonatomic, assign) NSInteger goods_num;      //商品数量
@property (nonatomic, assign) NSNumber *goods_sku_id;
@property (nonatomic,   copy) NSString *user_id;
@property (nonatomic, assign) NSNumber *brand_id;
@property (nonatomic,   copy) NSString *brand_img;
@property (nonatomic,   copy) NSString *goods_img_url;
@property (nonatomic,   copy) NSString *goods_size;
@property (nonatomic, assign) NSInteger goods_stock;    //库存
@property (nonatomic,   copy) NSString *goods_id;       //商品id
@property (nonatomic,   copy) NSString *goods_now_price;//现价
@property (nonatomic,   copy) NSString *goods_price;    //原价
/** 记录选中状态 */
@property (nonatomic, assign) BOOL selectState;

@end



