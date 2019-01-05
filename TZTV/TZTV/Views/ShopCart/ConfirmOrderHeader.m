//
//  ConfirmOrderHeader.m
//  TZTV
//
//  Created by Luosa on 2016/11/30.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ConfirmOrderHeader.h"

@implementation ConfirmOrderHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor=kWhiteColor;
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.iconIV];
        
        [self.iconIV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.iconIV autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.iconIV autoSetDimensionsToSize:CGSizeMake(35, 35)];
        
        [self.label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconIV withOffset:10];
    }
    return self;
}

-(UIImageView *)iconIV
{
    if (!_iconIV) {
        _iconIV=[[UIImageView alloc] init];
        [self.contentView addSubview:_iconIV];
    }
    return _iconIV;
}

-(UILabel *)label
{
    if (!_label) {
        _label=[[UILabel alloc] init];
        _label.textColor=HEXRGBCOLOR(0x333333);
        _label.font=YJFont(15);
    }
    return _label;
}

@end
