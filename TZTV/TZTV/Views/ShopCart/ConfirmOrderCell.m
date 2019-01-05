//
//  ConfirmOrderCell.m
//  TZTV
//
//  Created by Luosa on 2016/11/29.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ConfirmOrderCell.h"
#import "ShopCartModel.h"

@interface ConfirmOrderCell ()
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn1;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn2;
@property (weak, nonatomic) IBOutlet UILabel *youhuijuanLabel;
@property (weak, nonatomic) IBOutlet UITextField *liuyanTF;//买家留言输入框
@property (weak, nonatomic) IBOutlet UILabel *youfeiLabel;//邮费label
@property (weak, nonatomic) IBOutlet UILabel *xiaojiLabel;//小计金额=邮费+订单金额
@property (weak, nonatomic) IBOutlet UILabel *xiaojiNumLabel;//小计数量
@end

@implementation ConfirmOrderCell

+(CGFloat)heightForCellData:(id)aData
{
    return 224;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [_liuyanTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(id) sender
{
    _cart.order_remark=_liuyanTF.text;
}

- (IBAction)chooseClicked:(UIButton *)sender
{
    if (sender==_chooseBtn1) {
        _chooseBtn1.selected=YES;
        _cart.isDeliver=YES;
        _chooseBtn2.selected=NO;
    }else{
        _chooseBtn1.selected=NO;
        _cart.isDeliver=NO;
        _chooseBtn2.selected=YES;
    }
    [self calculateTotalMoney];//计算小计
    if (self.myBlock) {
        self.myBlock();
    }
}

-(void)setCart:(CartModel *)cart
{
    _cart=cart;
    [self calculateTotalMoney];
}

//计算小计
- (void)calculateTotalMoney
{
    CGFloat sumPrice = 0;
    
    for (ShopCartModel *shop in _cart.array) {
        sumPrice = sumPrice + shop.goods_num * [shop.goods_now_price floatValue];
    }
    
    if (_chooseBtn1.selected) {//加邮费
        sumPrice = sumPrice + 15;//邮费先写死
    }
    _xiaojiLabel.text=[NSString stringWithFormat:@"￥%.2f",sumPrice];
}

@end
