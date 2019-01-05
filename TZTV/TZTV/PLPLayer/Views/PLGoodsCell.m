//
//  PLGoodsCell.m
//  TZTV
//
//  Created by Luosa on 2017/2/21.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "PLGoodsCell.h"

@interface PLGoodsCell()
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNumLabel;

@end

@implementation PLGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setGoodModel:(PLGoodsModel *)goodModel{
    _goodModel=goodModel;
    _numLabel.text=[NSString stringWithFormat:@"%@",goodModel.num_id];
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:goodModel.picture] placeholderImage:[UIImage imageNamed:@""]];
    _topLabel.text=goodModel.name;
    _moneyLabel.text=[NSString stringWithFormat:@"￥%@",goodModel.price];
//    _payNumLabel.text=[NSString stringWithFormat:@""]
}

- (IBAction)buyClicked:(UIButton *)sender {
    
}

@end
