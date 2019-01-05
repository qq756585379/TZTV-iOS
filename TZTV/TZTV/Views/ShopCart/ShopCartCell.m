//
//  ShopCartCell.m
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ShopCartCell.h"

@interface ShopCartCell()
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@end

@implementation ShopCartCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor=kFAFAFA;
    _countTF.enabled=NO;
}

-(void)setSmallModel:(ShopCartModel *)smallModel
{
    _smallModel=smallModel;
    _chooseBtn.selected=smallModel.selectState;
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:smallModel.goods_img_url] placeholderImage:[UIImage imageNamed:@"225_243"]];
    _titleLabel.text=smallModel.goods_name;
    _countTF.text=[NSString stringWithFormat:@"%ld",smallModel.goods_num];
    _priceLabel.text=[NSString stringWithFormat:@"￥%@",smallModel.goods_now_price];
    //原价加中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",smallModel.goods_price] attributes:attribtDic];
    _oldPriceLabel.attributedText=attribtStr;
}

- (IBAction)chooseClicked:(UIButton *)sender
{
    sender.selected=!sender.selected;
    _smallModel.selectState=sender.selected;
    if (self.cellBlock) self.cellBlock();//回调重新计算价格
}

- (IBAction)addClicked:(UIButton *)sender
{
    NSInteger num=[_countTF.text integerValue];
    if (num == _smallModel.goods_stock) {
        [MBProgressHUD showToast:@"库存不够"];
        return;
    }
    NSString *url=[NSString stringWithFormat:uptShopCartURL,[[AccountTool account] user_id],_smallModel.ID,num+1];
    NSLog(@"add======%@",url);
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        if ([json[@"code"] isEqualToNumber:@0]) {
            _countTF.text = [NSString stringWithFormat:@"%ld",num+1];
            _smallModel.goods_num = num+1;
            //回调是为了重新计算价格，只有选中的才回调去计算价格
            if (self.chooseBtn.selected && self.cellBlock) self.cellBlock();
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)reduceClicked:(UIButton *)sender
{
    NSInteger num=[_countTF.text integerValue];
    if (num == 1) return;
    
    NSString *url=[NSString stringWithFormat:uptShopCartURL,[[AccountTool account] user_id],_smallModel.ID,num-1];
    NSLog(@"reduce======%@",url);
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        if ([json[@"code"] isEqualToNumber:@0]) {
            _countTF.text = [NSString stringWithFormat:@"%ld",num-1];
            _smallModel.goods_num = num-1;
            //回调是为了重新计算价格，只有选中的才回调去计算价格
            if (self.chooseBtn.selected && self.cellBlock) self.cellBlock();
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
