//
//  BrandDetailModel.h
//  TZTV
//
//  Created by Luosa on 2016/11/23.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandDetailModel : NSObject

@property (nonatomic, assign) NSNumber *nowPrice;   //现价
@property (nonatomic,   copy) NSString *ID;         //goods_id
@property (nonatomic, assign) NSNumber *price;      //原价
@property (nonatomic,   copy) NSString *picture;
@property (nonatomic,   copy) NSString *catalog_name;
@property (nonatomic,   copy) NSString *brand_id;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic,   copy) NSString *brand_name;
//分类里多的属性
@property (nonatomic,   copy) NSString *num_id;
@property (nonatomic,   copy) NSString *live_user_id;
@property (nonatomic,   copy) NSString *sell_count;

@end

