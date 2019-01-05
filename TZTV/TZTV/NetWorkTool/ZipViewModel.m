//
//  ZipViewModel.m
//  klxc
//
//  Created by sctto on 16/10/18.
//  Copyright © 2016年 sctto. All rights reserved.
//

#import "ZipViewModel.h"

@implementation ZipViewModel

- (void)loadNewDataWithSignalA_url:(NSString *)SignalA_url andSignalB_url:(NSString *)SignalB_url{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[YJHttpRequest sharedManager] get:SignalA_url params:nil success:^(id json) {
                if ([json[@"code"] isEqualToNumber:@0]) {
                    [subscriber sendNext:json];
                }else{
                    [subscriber sendCompleted];
                }
            } failure:^(NSError *error) {
                [subscriber sendError:error];
            }];
            return nil;
        }];
        RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[YJHttpRequest sharedManager] get:SignalB_url params:nil success:^(id json) {
                if ([json[@"code"] isEqualToNumber:@0]) {
                    [subscriber sendNext:json];
                }else{
                    [subscriber sendCompleted];
                }
            } failure:^(NSError *error) {
                [subscriber sendError:error];
            }];
            return nil;
        }];
        // 压缩成一个信号  同时请求
        // zipWith:当一个界面多个请求的时候,要等所有请求完成才能更新UI
        // zipWith:等所有信号都发送内容的时候才会调用
        RACSignal *zipSignal = [signalA zipWith:signalB];
        return zipSignal;
    }];
}

@end
