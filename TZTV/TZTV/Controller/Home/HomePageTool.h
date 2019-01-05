//
//  HomePageTool.h
//  TZTV
//
//  Created by Luosa on 2016/12/29.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageTool : NSObject

/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络中加载启动页数据 */
- (void)loadNewDataFromNetwork;

@property (nonatomic, strong) NSArray *zhuboList;
@property (nonatomic, strong) NSArray *LiveList;

@end
