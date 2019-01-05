//
//  HomeScrollItem.m
//  TZTV
//
//  Created by Luosa on 2016/11/10.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomeScrollItem.h"

@interface HomeScrollItem()
@property (weak, nonatomic) IBOutlet UIImageView *imageIV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@end

@implementation HomeScrollItem

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=[UIColor whiteColor];
}

-(void)setGoodModel:(BrandDetailModel *)goodModel{
    _goodModel=goodModel;
    [_imageIV sd_setImageWithURL:[NSURL URLWithString:goodModel.picture] placeholderImage:[UIImage imageNamed:@"60_60"]];
    _nameL.text=goodModel.name;
    _priceL.text=[NSString stringWithFormat:@"￥%@",goodModel.price];
}

@end
