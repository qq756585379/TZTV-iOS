//
//  ZhiBoViewModel.m
//  TZTV
//
//  Created by Luosa on 2016/12/26.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ZhiBoViewModel.h"
#import "ChatModel.h"

@implementation ZhiBoViewModel

-(NSMutableArray *)chatArray
{
    if (!_chatArray) {
        _chatArray=[NSMutableArray arrayWithCapacity:500];
    }
    return _chatArray;
}

/** 从网络中加载启动页数据 */
- (void)loadDataFromNetworkWith:(NSDictionary *)info{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *user_id=@"0";
            Account *account=[AccountTool account];
            if (account) {
                user_id=account.pid;
            }
            NSString *url=[NSString stringWithFormat:getChatListURL,info[@"live_id"],self.msg_id,user_id];
            YJLog(@"getChatListURL==%@",url);
            [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
                if ([json[@"code"] isEqualToNumber:@0]) {
                    NSArray *arr0=json[@"data"];
                    YJLog(@"getChatListURL==%@",json);
                    if (arr0.count) {
                        NSArray *arr=[ChatModel mj_objectArrayWithKeyValuesArray:arr0];
                        [self.chatArray addObjectsFromArray:arr];
                        ChatModel *model=[self.chatArray lastObject];
                        if (model) self.msg_id=[model.msg_id intValue];
                    }
                    [subscriber sendNext:nil];
                }
            } failure:^(NSError *error) {
                
            }];
            return nil;
        }];
        
        RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *url=[NSString stringWithFormat:getChatNumURL,info[@"live_id"]];
            YJLog(@"getChatNumURL==%@",url);
            [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
                YJLog(@"getChatNumURL==%@",json);
                if ([json[@"code"] isEqualToNumber:@0]) {
                    self.online_num=json[@"data"][@"online_num"];
                    self.like_num=json[@"data"][@"like_num"];
                    [subscriber sendNext:nil];
                }
            } failure:^(NSError *error) {
                
            }];
            return nil;
        }];
        RACSignal *zipSignal = [signalA zipWith:signalB];
        return zipSignal;
    }];
}

@end
