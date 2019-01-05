//
//  ConfirmOrderCell0.m
//  TZTV
//
//  Created by Luosa on 2016/11/29.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ConfirmOrderCell0.h"
#import "ShenQingTuiKuanVC.h"

@interface ConfirmOrderCell0()
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *tuihuoBtn;//退货按钮
@end

@implementation ConfirmOrderCell0

/**OrderDetailTableVC有用到该cell*/
+(CGFloat)heightForCellData:(id)aData
{
    if ([aData isKindOfClass:[NSArray class]]) {
        MyOrder *order = [aData safeObjectAtIndex:0];
        MyOrderSon *orderSon = [aData safeObjectAtIndex:1];
        if (order.order_state==3 && orderSon.goods_state==0) {//订单已完成并且商品的状态是正常的，显示退款按钮
            return 160;
        }else{//不显示退款按钮
            return 119;
        }
    }
    return 119;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor=kFAFAFA;
    [_tuihuoBtn doBorderWidth:1 color:kEDEDED cornerRadius:5];
}

- (IBAction)tuihuoClicked:(UIButton *)sender
{
    ShenQingTuiKuanVC *vc=[sb instantiateViewControllerWithIdentifier:@"ShenQingTuiKuanVC"];
    vc.orderSon=_orderSon;
    [[YJTOOL getRootControllerSelectedVc] pushViewController:vc animated:YES];
}

//不显示退货按钮
-(void)setShop:(ShopCartModel *)shop
{
    _shop=shop;
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:shop.goods_img_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _nameLabel.text=shop.goods_name;
    _colorLabel.text=[NSString stringWithFormat:@"颜色：%@，尺码：%@",shop.goods_color,shop.goods_size];
    _priceLabel.text=[NSString stringWithFormat:@"￥%@",shop.goods_now_price];
    _numLabel.text=[NSString stringWithFormat:@"x%ld",shop.goods_num];
    _bottomView.hidden=YES;
}

//看情况显示退货按钮
-(void)setOrderSon:(MyOrderSon *)orderSon
{
    _orderSon=orderSon;
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:orderSon.goods_img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _nameLabel.text=orderSon.goods_name;
    _colorLabel.text=[NSString stringWithFormat:@"颜色：%@，尺码：%@",orderSon.goods_color,orderSon.goods_size];
    _priceLabel.text=[NSString stringWithFormat:@"￥%@",orderSon.goods_price];
    _numLabel.text=[NSString stringWithFormat:@"x%ld",orderSon.goods_num];
}

@end
