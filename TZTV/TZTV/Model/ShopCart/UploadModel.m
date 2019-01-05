//
//  UploadModel.m
//  TZTV
//
//  Created by Luosa on 2016/11/29.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "UploadModel.h"

@implementation UploadModel

@end

@implementation UploadBigModel
/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"upload_List" : @"UploadModel"
             };
}

-(NSMutableArray *)goodsList{
    if (!_goodsList) {
        _goodsList=[NSMutableArray array];
    }
    return _goodsList;
}
@end
