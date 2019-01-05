//
//  HomePageTool.m
//  TZTV
//
//  Created by Luosa on 2016/12/29.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomePageTool.h"
#import "LiveListModel.h"

@implementation HomePageTool

- (void)loadNewDataFromNetwork{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[YJHttpRequest sharedManager] get:getLiveUserListURL params:nil success:^(id json) {
                YJLog(@"%@",json);
                if ([json[@"code"] isEqualToNumber:@0]) {
                    self.zhuboList=json[@"data"];
                    [subscriber sendNext:nil];
                }else{
                    [subscriber sendCompleted];
                }
            } failure:^(NSError *error) {
                [subscriber sendError:error];
            }];
            return nil;
        }];
        
        RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSString *location=[NSString stringWithFormat:@"%@,%@",[YJUserDefault getValueForKey:LongitudeKey],[YJUserDefault getValueForKey:LatitudeKey]];
            NSString *city=[YJUserDefault getValueForKey:CurrentCityKey];
            NSString *url=[NSString stringWithFormat:getLiveListURL,city.length?city:@"上海",1,1,location];
            YJLog(@"%@",url);
            [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
                YJLog(@"LiveList===%@",json);
                if ([json[@"code"] isEqualToNumber:@0]) {
                    self.LiveList=[LiveListModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                    [subscriber sendNext:nil];
                }else{
                    [subscriber sendCompleted];
                }
            } failure:^(NSError *error) {
                [subscriber sendError:error];
            }];
            return nil;
        }];
        RACSignal *zipSignal = [signalA zipWith:signalB];
        return zipSignal;
    }];
}


@end
