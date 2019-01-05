//
//  CartViewModel.m
//  TZTV
//
//  Created by Luosa on 2016/11/30.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "CartViewModel.h"
#import "ShopCartModel.h"
#import "CartModel.h"

@implementation CartViewModel

-(NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray=[NSMutableArray array];
    }
    return _modelArray;
}

- (void)loadDataFromNetwork{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [MBProgressHUD showMessage:@""];
            NSString *url=[NSString stringWithFormat:getShopCartListURL,[[AccountTool account] user_id]];
            [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
                YJLog(@"getShopCartList===%@",json);
                [MBProgressHUD hideHUD];
                if ([json[@"code"] isEqualToNumber:@0]) {
                    NSMutableArray *arr=[ShopCartModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                    [self.modelArray removeAllObjects];
                    
                    for (int i=0; i<arr.count; i++) {
                        ShopCartModel *shop=arr[i];
                        NSNumber *brand_id=shop.brand_id;
                        if ([[dict allKeys] containsObject:brand_id]){
                            CartModel *bigModel=dict[brand_id];
                            [bigModel.array addObject:shop];
                        }else{
                            [dict setObject:[CartModel new] forKey:brand_id];
                            CartModel *bigModel=dict[brand_id];
                            bigModel.brand_id=brand_id;
                            bigModel.brand_name=shop.brand_name;
                            bigModel.brand_img=shop.brand_img;
                            [bigModel.array addObject:shop];
                            [self.modelArray addObject:bigModel];
                        }
                    }
                    
                    [subscriber sendNext:self.modelArray];
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




