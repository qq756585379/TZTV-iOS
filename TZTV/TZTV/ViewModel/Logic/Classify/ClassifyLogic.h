//
//  ClassifyLogic.h
//  TZTV
//
//  Created by 杨俊 on 2019/1/7.
//  Copyright © 2019年 Luosa. All rights reserved.
//

#import "BaseLogic.h"
#import "ClassifyVO.h"

@interface ClassifyLogic : BaseLogic

@property (nonatomic,  strong)NSArray <ClassifyVO *>*dataArray;
    
- (void)getDataWithParma:(NSDictionary *)dict completionBlock:(YJCompletionBlock)aCompletionBlock;

@end

