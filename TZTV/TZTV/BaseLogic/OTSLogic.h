//
//  OTSLogic.h
//  TZTV
//
//  Created by Luosa on 2016/11/17.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTSOperationManager.h"

@interface OTSLogic : NSObject

@property (nonatomic, strong, readonly) OTSOperationManager *operationManger;

@property (nonatomic) BOOL loading;

+ (id)logicWithOperationManager:(OTSOperationManager *)aOperationManger;

@end
