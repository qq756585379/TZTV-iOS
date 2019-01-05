//
//  CityListItem.m
//  TZTV
//
//  Created by Luosa on 2016/11/11.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "CityListItem.h"

@implementation CityListItem

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self doBorderWidth:1 color:HEXRGBCOLOR(0x999999) cornerRadius:3];
        [self addSubview:self.customLabel];
        [self.customLabel autoCenterInSuperview];
    }
    return self;
}

-(UILabel *)customLabel
{
    if (!_customLabel) {
        _customLabel=[UILabel new];
        _customLabel.textColor = HEXRGBCOLOR(0x333333);
        _customLabel.font = YJFont(15);
        _customLabel.textAlignment = 1;
    }
    return _customLabel;
}



@end
