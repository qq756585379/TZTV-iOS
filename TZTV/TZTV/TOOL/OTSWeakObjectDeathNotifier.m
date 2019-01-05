//
//  OTSWeakObjectDeathNotifier.m
//  OneStoreFramework
//
//  Created by Aimy on 15/3/10.
//  Copyright (c) 2015年 OneStore. All rights reserved.
//

#import "OTSWeakObjectDeathNotifier.h"
#import "NSObject+category.h"

@interface OTSWeakObjectDeathNotifier ()
@property (nonatomic, copy) OTSWeakObjectDeathNotifierBlock aBlock;
@end

@implementation OTSWeakObjectDeathNotifier

- (void)setBlock:(OTSWeakObjectDeathNotifierBlock)block{
    self.aBlock = block;
}

- (void)dealloc{
    if (self.aBlock) {
        self.aBlock(self);
    }
    self.aBlock = nil;
}

- (void)setOwner:(id)owner{
    _owner = owner;
    [owner objc_setAssociatedObject:[NSString stringWithFormat:@"observerOwner_%p",self] value:self policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

@end
