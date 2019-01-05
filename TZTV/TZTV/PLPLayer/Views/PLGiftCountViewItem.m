//
//  PLGiftCountViewItem.m
//  TZTV
//
//  Created by Luosa on 2017/2/23.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "PLGiftCountViewItem.h"

@implementation PLGiftCountViewItem

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    _countLabel.textColor=selected ? YJNaviColor : HEXRGBCOLOR(0x333333);
}

@end
