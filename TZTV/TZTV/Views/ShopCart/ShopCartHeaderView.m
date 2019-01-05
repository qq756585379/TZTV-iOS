//
//  ShopCartHeaderView.m
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ShopCartHeaderView.h"
#import "ShopCartModel.h"

@interface ShopCartHeaderView ()
@property (nonatomic, strong) UIButton      *choosebtn;
@property (nonatomic, strong) UIImageView   *icon;
@property (nonatomic, strong) UILabel       *label;
@end

@implementation ShopCartHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor=kWhiteColor;
        
        [self.contentView addSubview:self.choosebtn];
        
        [self.contentView addSubview:self.icon];
        
        [self.contentView addSubview:self.label];
       
        [self.choosebtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.choosebtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.choosebtn autoSetDimensionsToSize:CGSizeMake(30, 30)];
        
        [self.icon autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.choosebtn];
        [self.icon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.icon autoSetDimensionsToSize:CGSizeMake(35, 35)];
        
        [self.label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.icon withOffset:10];
    }
    return self;
}

-(void)choose:(UIButton *)sender
{
    sender.selected=!sender.selected;
    _cartModel.selectState=sender.selected;
    for (ShopCartModel *model in _cartModel.array) {
        if (_cartModel.selectState != model.selectState) {
            model.selectState = _cartModel.selectState;
        }
    }
    if (self.headerBlock) self.headerBlock();//回调
}

-(void)setCartModel:(CartModel *)cartModel
{
    _cartModel=cartModel;
    self.choosebtn.selected=cartModel.selectState;
    self.label.text=cartModel.brand_name;
    [self.icon sd_setImageWithURL:[NSURL URLWithString:cartModel.brand_img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

-(UIButton *)choosebtn{
    if (!_choosebtn) {
        _choosebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_choosebtn setImage:[UIImage imageNamed:@"notChoose_"] forState:UIControlStateNormal];
        [_choosebtn setImage:[UIImage imageNamed:@"choose_"] forState:UIControlStateSelected];
        [_choosebtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _choosebtn;
}

-(UILabel *)label{
    if (!_label) {
        _label=[[UILabel alloc] init];
        _label.textColor=HEXRGBCOLOR(0x333333);
        _label.font=YJFont(15);
    }
    return _label;
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon=[UIImageView new];
    }
    return _icon;
}

@end
