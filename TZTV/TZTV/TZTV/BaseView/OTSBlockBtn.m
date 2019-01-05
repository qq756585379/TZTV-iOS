//
//  OTSBlockBtn.m
//  OneStoreMain
//
//  Created by Aimy on 14/12/23.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSBlockBtn.h"

@interface OTSBlockBtn ()
@property (nonatomic, copy) OTSBlockBtnClickBlock clickBlock;
@end

@implementation OTSBlockBtn

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addTarget:self action:@selector(onPressedBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addTarget:self action:@selector(onPressedBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)onPressedBtn:(OTSBlockBtn *)sender;{
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

- (void)setBlock:(OTSBlockBtnClickBlock)block{
    self.clickBlock = block;
}

@end
