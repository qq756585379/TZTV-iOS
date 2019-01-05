//
//  CityListHeader.m
//  TZTV
//
//  Created by Luosa on 2016/11/14.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "CityListHeader.h"
#import "UIButton+LayoutStyle.h"

@implementation CityListHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.headerLabel];
        UIButton *btn=[UIButton createButtonWithText:@"选择区县" textColor:HEXRGBCOLOR(0x999999) font:YJFont(14) image:@"dropdown" bgImage:nil superView:self];
        [self.headerLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 20, 0, 0) excludingEdge:ALEdgeRight];
        [btn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 15) excludingEdge:ALEdgeLeft];
        [btn setLayout:OTSTitleLeftImageRightStyle spacing:5];
    }
    return self;
}

-(UILabel *)headerLabel{
    if (!_headerLabel) {
        _headerLabel=[UILabel new];
        _headerLabel.font=YJFont(14);
        _headerLabel.textColor=HEXRGBCOLOR(0x999999);
    }
    return _headerLabel;
}
@end
