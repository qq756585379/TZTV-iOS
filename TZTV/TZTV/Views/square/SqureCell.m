//
//  SqureCell.m
//  TZTV
//
//  Created by Luosa on 2016/11/16.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "SqureCell.h"
#import "UIButton+LayoutStyle.h"

@interface SqureCell ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (nonatomic, strong) UIButton *selectedBtn;
@end

@implementation SqureCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self updateConstraintsIfNeeded];//强制更新约束
    [self layoutIfNeeded];//强制刷新界面
    [_btn1 setLayout:OTSImageTopTitleBottomStyle spacing:5];
    [_btn2 setLayout:OTSImageTopTitleBottomStyle spacing:5];
    [_btn3 setLayout:OTSImageTopTitleBottomStyle spacing:5];
    [_btn4 setLayout:OTSImageTopTitleBottomStyle spacing:5];
    [_btn5 setLayout:OTSImageTopTitleBottomStyle spacing:5];
    _selectedBtn=_btn1;
    [self btnClicked:_btn1];
}

- (IBAction)btnClicked:(UIButton *)sender
{
    _selectedBtn.selected=NO;
    sender.selected=YES;
    _selectedBtn=sender;
}

@end
