//
//  OTSNativeFuncVO.m
//  OneStore
//
//  Created by Luosa on 2017/2/14.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "OTSNativeFuncVO.h"

@implementation OTSNativeFuncVO

+ (instancetype)createWithBlock:(OTSNativeFuncVOBlock)block{
    OTSNativeFuncVO *vo = [self new];
    vo.block = block;
    return vo;
}

@end
