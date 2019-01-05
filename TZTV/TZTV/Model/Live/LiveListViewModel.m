//
//  LiveListViewModel.m
//  TZTV
//
//  Created by Luosa on 2016/11/28.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "LiveListViewModel.h"
#import "HomeModel2.h"

@interface LiveListViewModel()
@property (nonatomic, assign) NSInteger page;
@end

@implementation LiveListViewModel

-(NSMutableArray *)modelArray
{
    if (!_modelArray) {
        _modelArray=[NSMutableArray array];
    }
    return _modelArray;
}

/** 从网络中加载启动页数据 */
- (void)loadDataFromNetworkIsNewData:(BOOL)isNew
{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSString *location=[NSString stringWithFormat:@"%@,%@",[YJUserDefault getValueForKey:LongitudeKey],[YJUserDefault getValueForKey:LatitudeKey]];
            
            NSString *city=[YJUserDefault getValueForKey:CurrentCityKey];
            NSInteger page=isNew?1:_page+1;
            NSString *url=[NSString stringWithFormat:getLiveListURL,city.length?city:@"上海",page,10,location];
            YJLog(@"%@",url);
            [MBProgressHUD showMessage:@""];
            [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
                [MBProgressHUD hideHUD];
                if ([json[@"code"] isEqualToNumber:@0]) {
                    _page=page;
                    if (isNew) {
                        self.modelArray=[HomeModel2 mj_objectArrayWithKeyValuesArray:json[@"data"]];
                        [subscriber sendNext:self.modelArray];
                    }else{
                        NSMutableArray *arr=[HomeModel2 mj_objectArrayWithKeyValuesArray:json[@"data"]];
                        if (arr.count) {
                            [self.modelArray addObjectsFromArray:arr];
                        }
                        [subscriber sendNext:arr];
                    }
                }else{
                    self.msg=json[@"msg"];
                    [subscriber sendCompleted];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [subscriber sendError:error];
            }];
            return nil;
        }];
        return signal;
    }];
}


@end
