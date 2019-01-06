//
//  BaseLogic.m
//  TZTV
//
//  Created by 杨俊 on 2019/1/6.
//  Copyright © 2019年 Luosa. All rights reserved.
//

#import "BaseLogic.h"

@implementation BaseLogic

+ (id)logicWithOperationManager:(YJOperationManager *)operationManger
{
    BaseLogic *logic = [[self alloc] init];
    logic.operationManger = operationManger;
    logic.loading = NO;
    return logic;
}

- (void)dealloc{
    [self unobserveAllNotifications];
}

@end
