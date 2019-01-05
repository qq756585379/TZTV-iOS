//
//  OTSLogic.m
//  TZTV
//
//  Created by Luosa on 2016/11/17.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "OTSLogic.h"

@interface OTSLogic()
@property (nonatomic, strong) OTSOperationManager *operationManger;
@end

@implementation OTSLogic

+ (id)logicWithOperationManager:(OTSOperationManager *)aOperationManger;{
    OTSLogic *logic = [[self alloc] init];
    logic.operationManger = aOperationManger;
    logic.loading = NO;
    return logic;
}

- (void)dealloc{
    [self unobserveAllNotifications];
}

@end
