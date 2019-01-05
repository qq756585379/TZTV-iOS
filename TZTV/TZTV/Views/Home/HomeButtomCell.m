//
//  HomeButtomCell.m
//  TZTV
//
//  Created by Luosa on 2017/3/2.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "HomeButtomCell.h"

@implementation HomeButtomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setButtomModel:(HomeButtomModel *)buttomModel{
    _buttomModel=buttomModel;
    NSArray *array = [buttomModel.img_url componentsSeparatedByString:@","];
    [_iv sd_setImageWithURL:[NSURL URLWithString:[array safeObjectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"225_243"]];
    _nameL.text=buttomModel.title;
    _subNameL.text=buttomModel.title2;
    _desL.text=buttomModel.remark;
}

@end
