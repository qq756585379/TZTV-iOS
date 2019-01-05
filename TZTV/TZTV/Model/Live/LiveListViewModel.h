//
//  LiveListViewModel.h
//  TZTV
//
//  Created by Luosa on 2016/11/28.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveListViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *modelArray;

/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

@property (nonatomic,   copy) NSString *msg;

/** 从网络中加载启动页数据 */
- (void)loadDataFromNetworkIsNewData:(BOOL)isNew;

@end
