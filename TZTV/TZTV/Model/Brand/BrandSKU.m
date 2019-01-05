
//
//  BrandSKU.m
//  TZTV
//
//  Created by Luosa on 2016/11/24.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandSKU.h"

@implementation BrandSKU

-(instancetype)initWithDict:(NSDictionary *)dict{
    if(self=[super init]){
        _ID=dict[@"id"];
        _brand_name=dict[@"brand_name"];
        _catalog_name=dict[@"catalog_name"];
        _isnew=dict[@"isnew"];
        _picture=dict[@"picture"];
        _market_name=dict[@"market_name"];
        _nowPrice=dict[@"nowPrice"];
        //_stock=dict[@"stock"];
        _brand_id=dict[@"brand_id"];
        _brand_img=dict[@"brand_img"];
        _issale=dict[@"issale"];
        _price=dict[@"price"];
        _sellcount=dict[@"sellcount"];
        _express_price=dict[@"express_price"];
        _images=dict[@"images"];
        _name=dict[@"name"];
        _skuList=dict[@"skuList"];
        
        NSArray *skuList = dict[@"skuList"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSString *color = skuList[0][@"color"];
        [dict setObject:@[skuList[0]] forKey:color];
        for (int i=1; i<skuList.count; i++) {
            if ([color isEqualToString:skuList[i][@"color"]]) {
                NSMutableArray *temp=[NSMutableArray arrayWithArray:dict[color]];
                [temp addObject:skuList[i]];
                [dict setObject:temp forKey:color];
            }else{
                color=skuList[i][@"color"];
                [dict setObject:@[skuList[i]] forKey:color];
            }
        }
        _sku_dict=[dict copy];
    }
    return self;
}

@end
