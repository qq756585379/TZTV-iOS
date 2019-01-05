//
//  OTSWeakObjectDeathNotifier.h
//  OneStoreFramework
//
//  Created by Aimy on 15/3/10.
//  Copyright (c) 2015年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

//当owner释放的时候通知block
@class OTSWeakObjectDeathNotifier;

typedef void(^OTSWeakObjectDeathNotifierBlock)(OTSWeakObjectDeathNotifier *sender);

@interface OTSWeakObjectDeathNotifier : NSObject

@property (nonatomic,   weak) id owner;
@property (nonatomic, strong) id data;

- (void)setBlock:(OTSWeakObjectDeathNotifierBlock)block;

@end
