//
//  ClassifyVO.h
//  TZTV
//
//  Created by 杨俊 on 2019/1/7.
//  Copyright © 2019年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifyVO : NSObject

@property (strong, nonatomic) NSNumber *pid;
@property (strong, nonatomic) NSNumber *parentId;
@property (nonatomic,   copy) NSString *name;
@property (nonatomic,   copy) NSString *image;
@property (nonatomic,   copy) NSString *urlName;
@property (nonatomic, strong) NSArray <ClassifyVO *>*children;

@end


