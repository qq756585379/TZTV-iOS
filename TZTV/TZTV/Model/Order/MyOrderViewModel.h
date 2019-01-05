//
//  MyOrderViewModel.h
//  TZTV
//
//  Created by Luosa on 2016/12/3.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyOrder.h"

@interface MyOrderViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic,   copy) NSString *msg;
/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;
/** 从网络中加载启动页数据 */
- (void)loadDataFromNetworkWithType:(NSInteger)type IsNewData:(BOOL)isNew;

@end
