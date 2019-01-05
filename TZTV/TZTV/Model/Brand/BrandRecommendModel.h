//
//  BrandRecommendModel.h
//  TZTV
//
//  Created by Luosa on 2016/11/22.
//  Copyright © 2016年 Luosa. All rights reserved.
//

@interface MarketModel : NSObject//广场
@property (nonatomic,   copy) NSString *market_info;
@property (nonatomic,   copy) NSString *market_img;
@property (nonatomic,   copy) NSString *ID;
@property (nonatomic,   copy) NSString *market_address;
@property (nonatomic,   copy) NSString *market_area;
@property (nonatomic,   copy) NSString *market_city;
@property (nonatomic,   copy) NSString *total_brand;
@property (nonatomic,   copy) NSString *market_icon;
@property (nonatomic,   copy) NSString *market_name;
@end

@interface BrandModel : NSObject//品牌
@property (nonatomic, assign) NSNumber *catalog_label_id;
@property (nonatomic,   copy) NSString *catalog_pic;
@property (nonatomic,   copy) NSString *ID;
@property (nonatomic,   copy) NSString *name;
@end

//为你推荐模型
@interface BrandRecommendModel : NSObject
@property (nonatomic, strong) NSArray *market_list;
@property (nonatomic, strong) NSArray *brand_list;
@end
