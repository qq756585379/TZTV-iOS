//
//  BaseLogic.h
//  TZTV
//
//  Created by 杨俊 on 2019/1/6.
//  Copyright © 2019年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseLogic : NSObject

@property (nonatomic) BOOL loading;

@property (nonatomic, strong) YJOperationManager *operationManger;

+ (id)logicWithOperationManager:(YJOperationManager *)operationManger;

@end

NS_ASSUME_NONNULL_END

