//
//  HomePageHeader.m
//  TZTV
//
//  Created by Luosa on 2016/12/27.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomePageHeader.h"

@implementation HomePageHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor=kWhiteColor;
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleLabel];
        
        [self.icon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.icon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.icon autoSetDimension:ALDimensionWidth toSize:15];
        
        [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.icon withOffset:5];
    }
    return self;
}

-(void)setIcon:(NSString *)icon andTitle:(NSString *)title
{
    self.icon.image=[UIImage imageNamed:icon];
    self.titleLabel.text=title;
}

+ (CGFloat)heightForCellData:(id)aData
{
    return 40;
}

-(UIImageView *)icon
{
    if (!_icon) {
        _icon=[UIImageView new];
        _icon.image=[UIImage imageNamed:@"Featured"];
    }
    return _icon;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
        _titleLabel.textColor=HEXRGBCOLOR(0x333333);
        _titleLabel.font=YJFont(15);
    }
    return _titleLabel;
}

@end
