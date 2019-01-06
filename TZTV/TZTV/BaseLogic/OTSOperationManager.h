//
//  OTSOperationManager.h
//  TZTV
//
//  Created by Luosa on 2016/11/17.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface OTSOperationManager : AFHTTPSessionManager

/**
 *  初始化函数,宿主owner
 */
//+ (instancetype)managerWithOwner:(id)owner;

/**
 *  功能:发送请求
 */
//- (NSURLSessionDataTask *)requestWithParam:(OTSOperationParam *)aParam;
//
///**
// *  发送网络请求，创建信号
// */
//- (RACSignal *)rac_requestWithParam:(OTSOperationParam *)aParam;

/**
 *  功能:取消当前manager queue中所有网络请求
 */
//- (void)cancelAllOperations;

@end
