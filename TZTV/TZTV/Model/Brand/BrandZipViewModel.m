//
//  BrandZipViewModel.m
//  TZTV
//
//  Created by Luosa on 2016/12/2.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandZipViewModel.h"
#import "BrandCategoryModel.h"
#import "BrandRecommendModel.h"

@implementation BrandZipViewModel

- (void)loadNewDataFromNetwork{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[YJHttpRequest sharedManager] get:getCatalogURL params:nil success:^(id json) {
                if ([json[@"code"] isEqualToNumber:@0]) {
                    self.leftCategoryArr=[BrandCategoryModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
                    [subscriber sendNext:json];
                }else{
                    self.leftMsg=json[@"msg"];
                    [subscriber sendCompleted];
                }
            } failure:^(NSError *error) {
                [subscriber sendError:error];
            }];
            return nil;
        }];
        RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [[YJHttpRequest sharedManager] get:getRecommendURL params:nil success:^(id json) {
                if ([json[@"code"] isEqualToNumber:@0]) {
                    self.recommendModel=[BrandRecommendModel mj_objectWithKeyValues:json[@"data"]];
                    [subscriber sendNext:json];
                }else{
                    self.leftMsg=json[@"msg"];
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

-(void)loadRightDataFromNetWorkWith:(BrandCategoryModel *)model{
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [MBProgressHUD showMessage:@""];
            [[YJHttpRequest sharedManager] get:[NSString stringWithFormat:getCatalogSubURL,model.ID] params:nil success:^(id json) {
                [MBProgressHUD hideHUD];
                if ([json[@"code"] isEqualToNumber:@0]) {
                    NSMutableArray *arr=[NSMutableArray array];
                    for (NSDictionary *dict in json[@"data"]) {
                        BrandRightModel *rightmodel=[BrandRightModel mj_objectWithKeyValues:dict];
                        [arr addObject:rightmodel];
                    }
                    model.rightArr=[arr copy];
                    [subscriber sendNext:model.rightArr];
                }else{
                    self.rightMsg=json[@"msg"];
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


