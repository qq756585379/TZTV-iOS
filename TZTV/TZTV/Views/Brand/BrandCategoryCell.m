//
//  BrandCategoryCell.m
//  TZTV
//
//  Created by Luosa on 2016/11/14.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandCategoryCell.h"

@interface BrandCategoryCell()
@property (nonatomic, strong) UIView *selectedIndicator;
@end

@implementation BrandCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 清除文字背景色（这样就不会挡住分割线）
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font=YJFont(13);
        
        UILabel *line=[UILabel new];
        line.backgroundColor=kEDEDED;
        [self addSubview:line];
        
        _selectedIndicator=[UIView new];
        _selectedIndicator.backgroundColor=YJNaviColor;
        [self addSubview:_selectedIndicator];
        
        [line autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsZero excludingEdge:ALEdgeTop];
        [line autoSetDimension:ALDimensionHeight toSize:1];
        
        [_selectedIndicator autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsZero excludingEdge:ALEdgeRight];
        [_selectedIndicator autoSetDimension:ALDimensionWidth toSize:5];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.textLabel.textColor = selected ? YJNaviColor : [UIColor darkGrayColor];
    self.selectedIndicator.hidden = !selected;
    self.contentView.backgroundColor=selected?kF5F5F5:[UIColor whiteColor];
}

@end
