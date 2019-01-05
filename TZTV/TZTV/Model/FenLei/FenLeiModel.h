//
//  FenLeiModel.h
//  TZTV
//
//  Created by Luosa on 2017/2/28.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubBrandModel : NSObject
@property (nonatomic,   copy) NSString *brand_img;
@property (nonatomic,   copy) NSString *brand_floor;
@property (nonatomic,   copy) NSString *brand_address;
@property (nonatomic,   copy) NSString *brand_info;
@property (nonatomic,   copy) NSString *catalogs;
@property (nonatomic,   copy) NSString *create_time;
@property (nonatomic,   copy) NSString *market_id;
@property (nonatomic,   copy) NSString *brand_id;
@property (nonatomic,   copy) NSString *brand_name;

-(instancetype)initWithJson:(NSDictionary *)json;

@end

@interface FenLeiModel : NSObject
@property (nonatomic,   copy) NSString *ID;
@property (nonatomic,   copy) NSString *img;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *brandList;

-(instancetype)initWithJson:(NSDictionary *)json;

@end
