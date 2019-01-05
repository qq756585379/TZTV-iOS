//
//  HomaePageCell3.m
//  TZTV
//
//  Created by Luosa on 2016/12/27.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomaePageCell3.h"

@implementation HomaePageCell3

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_categoryLabel doBorderWidth:1 color:HEXRGBCOLOR(0x999999) cornerRadius:3];
}

+(CGFloat)heightForCellData:(id)aData
{
    return 125;
}

@end
