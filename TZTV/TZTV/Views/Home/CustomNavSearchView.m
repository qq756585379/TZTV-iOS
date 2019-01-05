//
//  CustomNavSearchView.m
//  TZTV
//
//  Created by Luosa on 2016/12/2.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "CustomNavSearchView.h"

@implementation CustomNavSearchView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.backgroundColor=kWhiteColor;
    
    [self addSubview:self.cornerView];
    [self addSubview:self.cancelBtn];
    
    [self.cornerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(7, 15, 7, 70)];
    
    [self.cancelBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(7, 0, 7, 5) excludingEdge:ALEdgeLeft];
    [self.cancelBtn autoSetDimension:ALDimensionWidth toSize:60];
}

-(void)cancel
{
    if ([self.delegate respondsToSelector:@selector(cancelSearchClicked)]) {
        [self.delegate cancelSearchClicked];
    }
}

-(UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIView *)cornerView
{
    if (!_cornerView) {
        _cornerView=[UIView new];
        [_cornerView addSubview:self.inputTF];
        [_cornerView addSubview:self.searchIicon];
        [_cornerView doBorderWidth:1 color:kEDEDED cornerRadius:5];
        
        [self.searchIicon autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeRight];
        [self.searchIicon autoSetDimension:ALDimensionWidth toSize:30];
     
        [self.inputTF autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 5) excludingEdge:ALEdgeLeft];
        [self.inputTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.searchIicon];
    }
    return _cornerView;
}

-(UITextField *)inputTF
{
    if (!_inputTF) {
        _inputTF=[UITextField new];
        _inputTF.borderStyle=0 ;
        _inputTF.placeholder=@"快搜我，有惊喜";
    }
    return _inputTF;
}

-(UIImageView *)searchIicon
{
    if (!_searchIicon) {
        _searchIicon=[UIImageView new];
        _searchIicon.image=[UIImage imageNamed:@"search"];
        _searchIicon.contentMode=UIViewContentModeCenter;
    }
    return _searchIicon;
}

@end
