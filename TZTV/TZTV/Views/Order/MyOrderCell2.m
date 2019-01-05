//
//  MyOrderCell2.m
//  TZTV
//
//  Created by Luosa on 2016/11/22.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrderCell2.h"

@interface MyOrderCell2()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *moneyLabel;//现价
@property (weak, nonatomic) IBOutlet UILabel     *oldPriceLabel;//原价不需要
@property (weak, nonatomic) IBOutlet UILabel     *numLabel;
@property (weak, nonatomic) IBOutlet UILabel     *desLabel;//颜色尺码
@end

@implementation MyOrderCell2

+(CGFloat)heightForCellData:(id)aData
{
    return 94;
}

-(void)setOrderSon:(MyOrderSon *)orderSon
{
    _orderSon=orderSon;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:orderSon.goods_img] placeholderImage:[UIImage imageNamed:@"225_243"]];
    _titleLabel.text=[NSString stringWithFormat:@"%@\n%@",orderSon.goods_name,orderSon.order_no];
    _moneyLabel.text=[NSString stringWithFormat:@"￥%@",orderSon.goods_price];//现价
    _numLabel.text=[NSString stringWithFormat:@"x%ld",orderSon.goods_num];
    _desLabel.text=[NSString stringWithFormat:@"颜色：%@\n尺码：%@",orderSon.goods_color,orderSon.goods_size];
    
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",orderSon.goods_price] attributes:attribtDic];
    _oldPriceLabel.attributedText = attribtStr;//原价
}

@end
