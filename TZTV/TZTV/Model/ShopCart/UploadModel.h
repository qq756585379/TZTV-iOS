//
//  UploadModel.h
//  TZTV
//
//  Created by Luosa on 2016/11/29.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadModel : NSObject
@property (nonatomic, assign) NSNumber *brand_id;
@property (nonatomic,   copy) NSString *goods_id;
@property (nonatomic, assign) NSNumber *goods_sku_id;
@property (nonatomic, assign) NSInteger goods_num;
@property (nonatomic,   copy) NSString *goods_price;
@end


@interface UploadBigModel : NSObject
@property (nonatomic, strong) NSMutableArray *goodsList;//里面装的是上面的模型
@property (nonatomic, assign) NSNumber       *brand_id;
@property (nonatomic, assign) NSInteger express_method;//配送方式
@property (nonatomic,   copy) NSString  *express_price;//运费
@property (nonatomic,   copy) NSString  *coupon_token;
@property (nonatomic,   copy) NSString  *coupon_price;
@property (nonatomic,   copy) NSString  *order_remark;
@end
