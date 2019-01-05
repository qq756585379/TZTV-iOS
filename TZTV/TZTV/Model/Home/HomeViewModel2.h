//
//  HomeViewModel2.h
//  TZTV
//
//  Created by Luosa on 2017/3/2.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeViewModel2 : NSObject

- (RACSignal *)getDataWithJson:(NSDictionary *)json;
- (RACSignal *)getMoreDataWithJson:(NSDictionary *)json;

@property(nonatomic,  assign) BOOL needUpdate;

@property (nonatomic, assign) int page;

@property (nonatomic, strong) NSArray *topArray;

@property (nonatomic, strong) NSMutableArray *buttomArray;

@end
