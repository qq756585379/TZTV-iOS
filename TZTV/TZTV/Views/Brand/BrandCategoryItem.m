//
//  BrandCategoryItem.m
//  TZTV
//
//  Created by Luosa on 2016/11/15.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandCategoryItem.h"

@interface BrandCategoryItem()
@property (nonatomic, strong) UIImageView *iv;
@property (nonatomic, strong) UILabel *desLabel;
@end

@implementation BrandCategoryItem

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.backgroundColor=[UIColor whiteColor];
    self.iv=[[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.width-20, self.height-30)];
    self.iv.contentMode=UIViewContentModeScaleAspectFit;
    self.iv.clipsToBounds=YES;
    [self addSubview:self.iv];
    
    self.desLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.iv.frame), self.width-20, 30)];
    self.desLabel.textAlignment=1;
    self.desLabel.numberOfLines=2;
    self.desLabel.textColor=HEXRGBCOLOR(0x333333);
    self.desLabel.font=YJFont(11);
    [self addSubview:self.desLabel];
}

-(void)setSubModel:(BrandSubModel *)subModel
{
    _subModel=subModel;
    [self.iv sd_setImageWithURL:[NSURL URLWithString:subModel.catalog_pic] placeholderImage:nil];//@"productpicture1"
    self.desLabel.text=subModel.name;
}

-(void)setMarketModel:(MarketModel *)marketModel
{
    _marketModel=marketModel;
    [self.iv sd_setImageWithURL:[NSURL URLWithString:marketModel.market_img] placeholderImage:nil];
    self.desLabel.text=marketModel.market_name;
}

-(void)setBrandModel:(BrandModel *)brandModel
{
    _brandModel=brandModel;
    [self.iv sd_setImageWithURL:[NSURL URLWithString:brandModel.catalog_pic] placeholderImage:nil];
    self.desLabel.text=brandModel.name;
}

@end
