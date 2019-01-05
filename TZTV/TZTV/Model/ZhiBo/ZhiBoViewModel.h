//
//  ZhiBoViewModel.h
//  TZTV
//
//  Created by Luosa on 2016/12/26.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhiBoViewModel : NSObject

/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 从网络中加载启动页数据 */
- (void)loadDataFromNetworkWith:(NSDictionary *)info;

@property (nonatomic, assign) int               msg_id;

@property (nonatomic,   copy) NSString          *online_num;
@property (nonatomic,   copy) NSString          *like_num;

@property (nonatomic, strong) NSMutableArray    *chatArray;

@end
