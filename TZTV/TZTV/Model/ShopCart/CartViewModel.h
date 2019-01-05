//
//  CartViewModel.h
//  TZTV
//
//  Created by Luosa on 2016/11/30.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *modelArray;

/** 请求命令 */
@property (nonatomic, strong) RACCommand *requestCommand;

@property (nonatomic,   copy) NSString *msg;

- (void)loadDataFromNetwork;

@end
