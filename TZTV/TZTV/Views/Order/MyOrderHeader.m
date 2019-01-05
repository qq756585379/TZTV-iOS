//
//  MyOrderHeader.m
//  TZTV
//
//  Created by Luosa on 2016/12/6.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrderHeader.h"

@implementation MyOrderHeader

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.icon];
        
        //[self.contentView addSubview:self.moreIcon];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.desLabel];
        
        [self.icon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15];
        [self.icon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.icon autoSetDimensionsToSize:CGSizeMake(35, 35)];
        
        [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.icon withOffset:5];
   
        //[self.moreIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        //[self.moreIcon autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.titleLabel withOffset:5];
        //[self.moreIcon autoSetDimensionsToSize:CGSizeMake(7, 12)];
        
        [self.desLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.desLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15];
    }
    return self;
}

-(void)setOrder:(MyOrder *)order
{
    _order=order;
    [_icon sd_setImageWithURL:[NSURL URLWithString:order.brand_img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _titleLabel.text=order.brand_name;
    _desLabel.text=[self getStateString];
}

// 订单状态；-1：已关闭，0：待付款，1：待发货，2：待收货，3：已完成，4：退款中，5：已退款，6：已提货
-(NSString *)getStateString
{
    if (_order.order_state==0) {//待付款
        return @"待付款";
    }else if(_order.order_state==1){//待发货
        return @"待发货";
    }else if (_order.order_state==2 || _order.order_state==6){//待收货
        return @"待收货";
    }else if (_order.order_state==3){//已完成
        return @"已完成";
    }else if (_order.order_state==-1){//交易关闭
        return @"交易关闭";
    }else if (_order.order_state==4){//退款中
        return @"退款中";
    }else if (_order.order_state==5){//已退款
        return @"已退款";
    }
    return @"";
}

-(UIImageView *)icon
{
    if (!_icon) {
        _icon=[UIImageView new];
        _icon.image=[UIImage imageNamed:@"placeholder"];
        _icon.contentMode=UIViewContentModeCenter;
        _icon.clipsToBounds=YES;
    }
    return _icon;
}

//-(UIImageView *)moreIcon{
//    if (!_moreIcon) {
//        _moreIcon=[UIImageView new];
//        _moreIcon.image=[UIImage imageNamed:@"more"];
//    }
//    return _moreIcon;
//}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
        _titleLabel.textColor=HEXRGBCOLOR(0x333333);
        _titleLabel.font=YJFont(15);
    }
    return _titleLabel;
}

-(UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel=[UILabel new];
        _desLabel.textColor=YJNaviColor;
        _desLabel.font=YJFont(15);
        _desLabel.textAlignment=2;
    }
    return _desLabel;
}

@end
