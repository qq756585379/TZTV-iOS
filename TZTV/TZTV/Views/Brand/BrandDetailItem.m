//
//  BrandDetailItem.m
//  TZTV
//
//  Created by Luosa on 2016/11/15.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandDetailItem.h"

@interface BrandDetailItem()
@property (weak, nonatomic) IBOutlet UIImageView    *iv;
@property (weak, nonatomic) IBOutlet UILabel        *topLabel;
@property (weak, nonatomic) IBOutlet UILabel        *priceLabel;
@end

@implementation BrandDetailItem

-(void)setDetail:(BrandDetailModel *)detail
{
    _detail=detail;
    [_iv sd_setImageWithURL:[NSURL URLWithString:detail.picture] placeholderImage:nil];
    _topLabel.text=detail.name;
    _priceLabel.text=[NSString stringWithFormat:@"￥%@元",detail.nowPrice];
}

@end
