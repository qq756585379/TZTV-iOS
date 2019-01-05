//
//  PhoneTabBarItem.h
//  YJMall
//
//  Created by 杨俊 on 2019/1/4.
//  Copyright © 2019年 杨俊. All rights reserved.
//

#import "YJTabBarItem.h"
#import "AppTabItemVO.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhoneTabBarItem : YJTabBarItem

@property (nonatomic, strong) NSString *hostString;

@property (nonatomic, strong) AppTabItemVO *vo;

- (BOOL)shouldUpdateWithItemVO:(AppTabItemVO *)aVO;

@end

NS_ASSUME_NONNULL_END
