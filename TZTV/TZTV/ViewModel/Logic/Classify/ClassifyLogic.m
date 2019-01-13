//
//  ClassifyLogic.m
//  TZTV
//
//  Created by 杨俊 on 2019/1/7.
//  Copyright © 2019年 Luosa. All rights reserved.
//

#import "ClassifyLogic.h"

@implementation ClassifyLogic

- (void)getDataWithParma:(NSDictionary *)dict completionBlock:(YJCompletionBlock)aCompletionBlock
{
    WEAK_SELF
    [MBProgressHUD showMessage:@""];
    YJOperationParam *param = [YJOperationParam paramWithUrl:Classify_URL type:kRequestGet param:dict callback:^(id aResponseObject, NSError *anError) {
        STRONG_SELF
        [MBProgressHUD hideHUD];
        if (!anError) {
            self.dataArray = [ClassifyVO mj_objectArrayWithKeyValuesArray:aResponseObject];
        }
        [self performInMainThreadBlock:^{
            !aCompletionBlock ? : aCompletionBlock(aResponseObject, anError);
        }];
    }];
    
    [self.operationManger requestWithParam:param];
}

@end
