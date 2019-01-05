//
//  ZipViewModel.h
//  klxc
//
//  Created by sctto on 16/10/18.
//  Copyright © 2016年 sctto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZipViewModel : NSObject

/** 请求命令 */
@property (nonatomic, strong, readonly) RACCommand *requestCommand;

/** 
    从网络中加载启动页数据
    页面同时请求两个url
 */
- (void)loadNewDataWithSignalA_url:(NSString *)SignalA_url andSignalB_url:(NSString *)SignalB_url;

@end
