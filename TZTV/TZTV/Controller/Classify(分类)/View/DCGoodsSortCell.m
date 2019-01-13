//
//  DCGoodsSortCell.m
//  CDDMall
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCGoodsSortCell.h"

@interface DCGoodsSortCell ()
/* imageView */
@property (strong , nonatomic)UIImageView *goodsImageView;
/* label */
@property (strong , nonatomic)UILabel *goodsTitleLabel;
@end

@implementation DCGoodsSortCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    self.backgroundColor = YJBGColor;
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_goodsImageView];
    
    _goodsTitleLabel = [[UILabel alloc] init];
    _goodsTitleLabel.font = [UIFont systemFontOfSize:13];
    _goodsTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_goodsTitleLabel];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self) setOffset:5];
        make.size.mas_equalTo(CGSizeMake(self.width * 0.85, self.width * 0.85));
    }];
    
    [_goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(_goodsImageView.mas_bottom) setOffset:5];
        make.width.mas_equalTo(_goodsImageView);
        make.centerX.mas_equalTo(self);
    }];
}

-(void)setClassifyVO:(ClassifyVO *)classifyVO{
    _classifyVO = classifyVO;
    if ([classifyVO.image containsString:@"http"]) {
        [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:classifyVO.image]];
    }else{
        _goodsImageView.image = [UIImage imageNamed:classifyVO.image];
    }
    _goodsTitleLabel.text = classifyVO.name;
}

@end
