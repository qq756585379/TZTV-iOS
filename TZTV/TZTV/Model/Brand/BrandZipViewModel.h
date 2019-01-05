//
//  BrandZipViewModel.h
//  TZTV
//
//  Created by Luosa on 2016/12/2.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BrandRecommendModel;
@class BrandCategoryModel;

@interface BrandZipViewModel : NSObject

/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络中加载启动页数据 */
- (void)loadNewDataFromNetwork;

-(void)loadRightDataFromNetWorkWith:(BrandCategoryModel *)model;

@property (nonatomic, strong) NSArray *leftCategoryArr;//左边类别

@property (nonatomic, strong) BrandRecommendModel *recommendModel;//为你推荐

@property (nonatomic,   copy) NSString *rightMsg;
@property (nonatomic,   copy) NSString *leftMsg;

@end
