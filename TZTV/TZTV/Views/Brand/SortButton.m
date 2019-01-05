//
//  SortButton.m
//  TZTV
//
//  Created by Luosa on 2016/11/17.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "SortButton.h"

@implementation SortButton

-(void)setSortType:(SortButtonType)sortType{
    _sortType=sortType;
    if (sortType==typeAscending){//升序
        [self setImage:[UIImage imageNamed:@"high"] forState:UIControlStateNormal];
        [self setTitleColor:YJNaviColor forState:UIControlStateNormal];
        [self setTitleColor:YJNaviColor forState:UIControlStateSelected];
    }else if (sortType==typeDescending){//降序
        [self setImage:[UIImage imageNamed:@"low"] forState:UIControlStateNormal];
        [self setTitleColor:YJNaviColor forState:UIControlStateNormal];
        [self setTitleColor:YJNaviColor forState:UIControlStateSelected];
    }else{
        [self setImage:[UIImage imageNamed:@"usually"] forState:UIControlStateNormal];
        [self setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateNormal];
        [self setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateSelected];
    }
}

-(void)setHighlighted:(BOOL)highlighted{}

@end
