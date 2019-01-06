//
//  LoginInterface.m
//  TZTV
//
//  Created by 杨俊 on 2019/1/6.
//  Copyright © 2019年 Luosa. All rights reserved.
//

#import "LoginInterface.h"

@implementation LoginInterface

+ (YJOperationParam *)getLoginParam:(NSDictionary *)parma completionBlock:(YJCompletionBlock)aCompletionBlock
{
    YJOperationParam *param = [YJOperationParam paramWithUrl:LOGINURL type:kRequestPost param:parma callback:^(id aResponseObject, NSError *anError) {
        if (aCompletionBlock) {
            aCompletionBlock(aResponseObject, anError);
        }
    }];
    
    param.timeoutTime = 20;
    param.cacheTime = 5;
    return param;
}

@end
