//
//  ClassifyVO.m
//  TZTV
//
//  Created by 杨俊 on 2019/1/7.
//  Copyright © 2019年 Luosa. All rights reserved.
//

#import "ClassifyVO.h"

@implementation ClassifyVO
+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"children" : [ClassifyVO class] };
}
@end
