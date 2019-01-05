//
//  HomeViewModel2.m
//  TZTV
//
//  Created by Luosa on 2017/3/2.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "HomeViewModel2.h"
#import "HomeModel2.h"
#import "HomeButtomModel.h"

@implementation HomeViewModel2

- (RACSignal *)getDataWithJson:(NSDictionary *)json
{
    return [RACSignal combineLatest:@[[self getTopData],
                                      [self getButtomDataWithJson:json]]
                             reduce:^id(NSDictionary *x1,NSDictionary *x2){
                   
                                 return nil;
                             }];
}

//只给3条数据
- (RACSignal *)getTopData
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *city=[YJUserDefault getValueForKey:CurrentCityKey];
        NSString *location=[NSString stringWithFormat:@"%@,%@",[YJUserDefault getValueForKey:LongitudeKey],[YJUserDefault getValueForKey:LatitudeKey]];
        NSString *url = [NSString stringWithFormat:Home2_URL,city.length?city:@"上海",1,location];
       
        [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
            if ([json[@"code"] isEqualToNumber:@0]) {
                self.page=1;
                self.topArray=[HomeModel2 mj_objectArrayWithKeyValuesArray:json[@"data"]];
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

- (RACSignal *)getButtomDataWithJson:(NSDictionary *)json
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *url=[NSString stringWithFormat:Home2_URL2,1];
        [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
            if ([json[@"code"] isEqualToNumber:@0]) {
                self.buttomArray=[HomeButtomModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                self.page=1;
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

- (RACSignal *)getMoreDataWithJson:(NSDictionary *)json
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        int page = self.page+1;
        NSString *url=[NSString stringWithFormat:Home2_URL2,page];
        
        [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
            if ([json[@"code"] isEqualToNumber:@0]) {
                YJLog(@"%@",json);
                NSArray *buttomArray=[HomeButtomModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                [self.buttomArray addObjectsFromArray:buttomArray];
                self.page=page;
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

-(NSMutableArray *)buttomArray
{
    if (!_buttomArray) {
        _buttomArray=[NSMutableArray array];
    }
    return _buttomArray;
}

@end
