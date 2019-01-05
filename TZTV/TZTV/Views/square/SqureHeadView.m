//
//  SqureHeadView.m
//  TZTV
//
//  Created by Luosa on 2016/11/16.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "SqureHeadView.h"

@implementation SqureHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initUI];
        [self initConstraint];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.headImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.squreLabel];
    [self addSubview:self.desLabel];
}

-(void)initConstraint{
    [self.headImageView autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.headImageView autoSetDimension:ALDimensionHeight toSize:210];
    
    [self.iconImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.headImageView withOffset:25];
    [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [self.iconImageView autoSetDimensionsToSize:CGSizeMake(50, 50)];
    
    [self.squreLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconImageView withOffset:10];
    [self.squreLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.iconImageView];
    
    [self.desLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.iconImageView withOffset:10];
    [self.desLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [self.desLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [self.desLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10 relation:NSLayoutRelationGreaterThanOrEqual];
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView=[[UIImageView alloc] init];
        _headImageView.contentMode=UIViewContentModeScaleAspectFill;
        _headImageView.image=[UIImage imageNamed:@"banner"];
    }
    return _headImageView;
}
-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc] init];
        _iconImageView.image=[UIImage imageNamed:@"placeholder"];
        _iconImageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;//阴影颜色
        _iconImageView.layer.shadowOffset = CGSizeMake(0.5, 0.5);//偏移距离
        _iconImageView.layer.shadowOpacity = 0.5;//不透明度
        _iconImageView.layer.shadowRadius = 5.0;//半径
    }
    return _iconImageView;
}
-(UILabel *)squreLabel{
    if (!_squreLabel) {
        _squreLabel=[[UILabel alloc] init];
        _squreLabel.font=YJFont(15);
        _squreLabel.textColor=HEXRGBCOLOR(0x333333);
        _squreLabel.text=@"正大广场";
    }
    return _squreLabel;
}
-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel=[[UILabel alloc] init];
        _desLabel.font=YJFont(13);
        _desLabel.numberOfLines=0;
        _desLabel.textColor=HEXRGBCOLOR(0x333333);
        _desLabel.text=@"上海正大广场上海正大广场上海正大广场上海正大广场上海正大广场上海正大广场上海正大广场上海正大广场上海正大广场上海正大广场";
    }
    return _desLabel;
}
@end
