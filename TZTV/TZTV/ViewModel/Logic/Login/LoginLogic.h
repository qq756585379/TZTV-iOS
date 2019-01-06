//
//  LoginLogic.h
//  TZTV
//
//  Created by 杨俊 on 2019/1/6.
//  Copyright © 2019年 Luosa. All rights reserved.
//

#import "BaseLogic.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginLogic : BaseLogic

- (void)loginWithParma:(NSDictionary *)dict completionBlock:(YJCompletionBlock)aCompletionBlock;

@end

NS_ASSUME_NONNULL_END
