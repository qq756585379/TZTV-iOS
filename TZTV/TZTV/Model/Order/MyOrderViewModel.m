//
//  MyOrderViewModel.m
//  TZTV
//
//  Created by Luosa on 2016/12/3.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrderViewModel.h"

@interface MyOrderViewModel()
@property (nonatomic, assign) NSInteger page;
@end

@implementation MyOrderViewModel

-(NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray=[NSMutableArray array];
    }
    return _modelArray;
}

-(NSArray *)state{
    return @[@"qb",@"dfk",@"dfh",@"dsh",@"dpj"];
}

/** 从网络中加载启动页数据 */
- (void)loadDataFromNetworkWithType:(NSInteger)type IsNewData:(BOOL)isNew{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSInteger page=isNew?1:_page+1;
            NSString *url=[NSString stringWithFormat:getOrderByUserIdURL,[[AccountTool account] user_id],page,[self state][type]];
            YJLog(@"%@",url);
            [MBProgressHUD showMessage:@""];
            [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
                [MBProgressHUD hideHUD];
                NSLog(@"%@",json);
                if ([json[@"code"] isEqualToNumber:@0]) {
                    _page=page;
                    if (isNew) {
                        self.modelArray=[MyOrder mj_objectArrayWithKeyValuesArray:json[@"data"]];
                        [subscriber sendNext:self.modelArray];
                    }else{
                        NSMutableArray *arr=[MyOrder mj_objectArrayWithKeyValuesArray:json[@"data"]];
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
