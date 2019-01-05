//
//  FenLeiModel.m
//  TZTV
//
//  Created by Luosa on 2017/2/28.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "FenLeiModel.h"

@implementation SubBrandModel

-(instancetype)initWithJson:(NSDictionary *)json
{
    if (self=[super init]) {
        _brand_img=json[@"brand_img"];
        _brand_floor=json[@"brand_floor"];
        _brand_address=json[@"brand_address"];
        _brand_info=json[@"brand_info"];
        _catalogs=json[@"catalogs"];
        _create_time=json[@"create_time"];
        _market_id=json[@"market_id"];
        _brand_id=json[@"brand_id"];
        _brand_name=json[@"brand_name"];
    }
    return self;
}

@end

@implementation FenLeiModel

-(NSMutableArray *)brandList
{
    if (!_brandList) {
        _brandList=[NSMutableArray array];
    }
    return _brandList;
}

-(instancetype)initWithJson:(NSDictionary *)json
{
    if (self = [super init]) {
        NSDictionary *dict=json[@"catalog"];
        _ID=dict[@"id"];
        _img=dict[@"img"];
        _name=dict[@"name"];
        for (NSDictionary *subJson in json[@"brandList"]) {
            SubBrandModel *m=[[SubBrandModel alloc] initWithJson:subJson];
            [self.brandList addObject:m];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

@end
