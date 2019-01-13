//
//  DCBrandsSortHeadView.m
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCBrandsSortHeadView.h"

@implementation DCBrandsSortHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    _headLabel = [[UILabel alloc] init];
    _headLabel.font = [UIFont systemFontOfSize:13];
    _headLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_headLabel];
    _headLabel.frame = CGRectMake(10, 0, self.width, self.height);
}

@end
