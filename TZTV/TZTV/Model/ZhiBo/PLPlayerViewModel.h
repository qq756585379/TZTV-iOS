//
//  PLPlayerViewModel.h
//  TZTV
//
//  Created by Luosa on 2016/12/28.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "ChatModel.h"

@interface PLPlayerViewModel : NSObject

@property (nonatomic,  assign) BOOL needUpdate;

@property (nonatomic, strong) NSArray *giftDataArray;

@property (nonatomic, strong) NSMutableArray *chatArray;

@property (nonatomic, strong) NSDictionary *zhuboInfo;

@property (nonatomic,   copy) NSString *online_num;

@property (nonatomic,   copy) NSString *like_num;

//初始化数据
- (RACSignal *)configDataWithJson:(NSDictionary *)json;

- (RACSignal *)sendChatDataWithParma:(NSDictionary *)parma;

- (RACSignal *)getChatAndNumWithParma:(NSDictionary *)parma;

//获取商品的列表
- (RACSignal *)getGoodsInfoWithParma:(NSDictionary *)parma;

@end
