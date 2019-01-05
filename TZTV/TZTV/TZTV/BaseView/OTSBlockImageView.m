//
//  OTSBlockImageView.m
//  OneStoreMain
//
//  Created by Aimy on 14/12/23.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSBlockImageView.h"

@interface OTSBlockImageView ()
@property (nonatomic, copy) OTSBlockImageViewClickBlock clickBlock;
@end

@implementation OTSBlockImageView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.userInteractionEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPressedImageView:)];
    [self addGestureRecognizer:tap];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPressedImageView:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)onPressedImageView:(OTSBlockImageView *)sender;{
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

- (void)setBlock:(OTSBlockImageViewClickBlock)block{
    self.clickBlock = block;
    if (self.clickBlock) {
        self.userInteractionEnabled = YES;
    }else {
        self.userInteractionEnabled = NO;
    }
}

@end
