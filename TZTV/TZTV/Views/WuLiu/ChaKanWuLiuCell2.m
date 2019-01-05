//
//  ChaKanWuLiuCell2.m
//  TZTV
//
//  Created by Luosa on 2016/12/5.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ChaKanWuLiuCell2.h"

@interface ChaKanWuLiuCell2()
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *smallCircle;
@property (weak, nonatomic) IBOutlet UIImageView *bigCircle;
@end

@implementation ChaKanWuLiuCell2

+(CGFloat)heightForCellData:(id)aData
{
    // 文字的最大尺寸
    CGSize maxSize = CGSizeMake(ScreenW - 60 - 15, MAXFLOAT);
    // 计算文字的高度
    CGFloat textH = [aData boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height;
    return textH+10+5+20+5;
}

- (void)setDataSourceIsFirst:(BOOL)isFirst isLast:(BOOL)isLast
{
    _titleLabel.textColor=isFirst?HEXRGBCOLOR(0x189778):HEXRGBCOLOR(0x333333);
    _timeLabel.textColor=isFirst?HEXRGBCOLOR(0x189778):HEXRGBCOLOR(0x333333);
    _bigCircle.hidden=!isFirst;
    _topLine.hidden=isFirst;
    _bottomLine.hidden=isLast;
}

@end
