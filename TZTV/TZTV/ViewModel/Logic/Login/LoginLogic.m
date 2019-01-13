//
//  LoginLogic.m
//  TZTV
//
//  Created by 杨俊 on 2019/1/6.
//  Copyright © 2019年 Luosa. All rights reserved.
//

#import "LoginLogic.h"

@implementation LoginLogic

- (void)loginWithParma:(NSDictionary *)dict completionBlock:(YJCompletionBlock)aCompletionBlock
{
    WEAK_SELF
    [MBProgressHUD showMessage:@""];
    YJOperationParam *param = [YJOperationParam paramWithUrl:LOGINURL type:kRequestPost param:dict callback:^(id aResponseObject, NSError *anError) {
        STRONG_SELF
        [MBProgressHUD hideHUD];
        if (!anError) {
            Account *account = [Account mj_objectWithKeyValues:aResponseObject];
            [AccountTool saveAccount:account];
        }
        [self performInMainThreadBlock:^{
            !aCompletionBlock ? : aCompletionBlock(aResponseObject, anError);
        }];
    }];
    
    [self.operationManger requestWithParam:param];
}

@end
