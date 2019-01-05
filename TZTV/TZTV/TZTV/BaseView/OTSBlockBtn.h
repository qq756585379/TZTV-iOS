//
//  OTSBlockBtn.h
//  OneStoreMain
//
//  Created by Aimy on 14/12/23.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTSBlockBtn;

typedef void(^OTSBlockBtnClickBlock)(OTSBlockBtn *sender);

@interface OTSBlockBtn : UIButton

@property (nonatomic, strong) id data;

- (void)setBlock:(OTSBlockBtnClickBlock)block;

@end
