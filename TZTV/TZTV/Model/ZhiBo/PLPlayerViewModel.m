//
//  PLPlayerViewModel.m
//  TZTV
//
//  Created by Luosa on 2016/12/28.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "PLPlayerViewModel.h"
#import "ChatModel.h"

@implementation PLPlayerViewModel

-(NSMutableArray *)chatArray{
    if (!_chatArray) {
        _chatArray=[NSMutableArray arrayWithCapacity:500];
    }
    return _chatArray;
}

- (RACSignal *)configDataWithJson:(NSDictionary *)json{
    return [RACSignal combineLatest:@[[self getGiftData],
                                      [self getFirstChatListDataWithJson:json],
                                      [self getZhuBoChatInfo:json]]
                             reduce:^id(NSDictionary *x1,NSDictionary *x2,NSDictionary *x3){
                                 NSLog(@"%@++++%@+++++%@",x1,x2,x3);
        return nil;
    }];
}

//获取礼物数据
- (RACSignal *)getGiftData{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[YJHttpRequest sharedManager] get:@"http://114.55.234.142:8080/tztvapi/gift/getGift" params:nil success:^(id json) {
            if ([json[@"code"] isEqualToNumber:@0]) {
                self.giftDataArray=json[@"data"];
                [subscriber sendNext:json];
                [subscriber sendCompleted];
                _needUpdate=NO;
            }else{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                _needUpdate=YES;
            }
        } failure:^(NSError *error) {
            _needUpdate=YES;
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

//获取历史消息记录
- (RACSignal *)getFirstChatListDataWithJson:(NSDictionary *)json{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *SignalA_url=[NSString stringWithFormat:getFirstChatListURL,json[@"live_id"]];
        [[YJHttpRequest sharedManager] get:SignalA_url params:nil success:^(id json) {
            if ([json[@"code"] isEqualToNumber:@0]) {
                self.chatArray=[ChatModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [subscriber sendNext:json];
                [subscriber sendCompleted];
                _needUpdate=NO;
            }else{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                _needUpdate=YES;
            }
        } failure:^(NSError *error) {
            _needUpdate=YES;
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

//获取主播信息
- (RACSignal *)getZhuBoChatInfo:(NSDictionary *)json{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *SignalB_url=[NSString stringWithFormat:getChatInfoURL,json[@"live_id"],json[@"live_user_id"],json[@"user_id"]];
        [[YJHttpRequest sharedManager] get:SignalB_url params:nil success:^(id json) {
            if ([json[@"code"] isEqualToNumber:@0]) {
                self.zhuboInfo=json[@"data"];
                [subscriber sendNext:json];
                [subscriber sendCompleted];
                _needUpdate=NO;
            }else{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                _needUpdate=YES;
            }
        } failure:^(NSError *error) {
            _needUpdate=YES;
            [subscriber sendError:error];
        }];
        return nil;
    }];
}



- (RACSignal *)sendChatDataWithParma:(NSDictionary *)parma{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        Account *account=[AccountTool account];
        NSString *url=[NSString stringWithFormat:addChatURL,parma[@"live_id"],account.user_id,account.user_nicname,parma[@"content"],account.token];
        YJLog(@"addChatURL===%@",url);
        [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
            if ([json[@"code"] isEqualToNumber:@0]) {
                YJLog(@"消息发送成功%@",json);
                ChatModel *lastChatM=[self.chatArray lastObject];
                int msg_id= lastChatM ? [lastChatM.msg_id intValue]+1 : 0;
                ChatModel *chatM=[[ChatModel alloc] initWith:@{@"nicname":account.user_nicname,@"msg_content":parma[@"content"],@"msg_id":[NSString stringWithFormat:@"%d",msg_id]}];
                [self.chatArray addObject:chatM];
                [subscriber sendNext:json];
                [subscriber sendCompleted];
            }else{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)getChatAndNumWithParma:(NSDictionary *)parma{
    return [RACSignal combineLatest:@[[self getChatListWithParma:parma],
                                      [self getChatNumWithParma:parma]]
                             reduce:^id(NSDictionary *x1,NSDictionary *x2){
                                 NSLog(@"%@++++%@",x1,x2);
                                 return nil;
                             }];
}

- (RACSignal *)getChatListWithParma:(NSDictionary *)parma{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        Account *account = [AccountTool account];
        NSString *user_id = account ? account.user_id : @"0";
        ChatModel *lastChatM=[self.chatArray lastObject];
        int msg_id= lastChatM ? [lastChatM.msg_id intValue] : 0;
        NSString *url=[NSString stringWithFormat:getChatListURL,parma[@"live_id"],msg_id,user_id];
        YJLog(@"getChatListURL==%@",url);
        [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
            if ([json[@"code"] isEqualToNumber:@0]) {
                if ([json[@"data"] count]) {
                    NSArray *arr=[ChatModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                    [self.chatArray addObjectsFromArray:arr];
                }
                [subscriber sendNext:json];
                [subscriber sendCompleted];
            }else{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)getChatNumWithParma:(NSDictionary *)parma{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *url=[NSString stringWithFormat:getChatNumURL,parma[@"live_id"]];
        YJLog(@"getChatNumURL==%@",url);
        [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
            if ([json[@"code"] isEqualToNumber:@0]) {
                self.online_num=json[@"data"][@"online_num"];
                self.like_num=json[@"data"][@"like_num"];
                [subscriber sendNext:json];
                [subscriber sendCompleted];
            }else{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

//获取商品的列表
- (RACSignal *)getGoodsInfoWithParma:(NSDictionary *)parma{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *url=[NSString stringWithFormat:@"http://114.55.234.142:8080/tztvapi/goods/getGoodsListByLUid?live_user_id=%@&type=%@&page=%@&pageSize=10",parma[@"live_user_id"],parma[@"type"],parma[@"page"]];
        [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
            if ([json[@"code"] isEqualToNumber:@0]) {
                NSLog(@"=====%@",json);
                [subscriber sendNext:json];
                [subscriber sendCompleted];
            }else{
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

@end
