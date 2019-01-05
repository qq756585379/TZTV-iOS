//
//  PlaceHoldView.m
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "PlaceHoldView.h"

@implementation PlaceHoldView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupMainView];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setupMainView];
}

- (void)setupMainView {
    self.backgroundColor=kF5F5F5;
    
    [self addSubview:self.placeImageView];
    [self addSubview:self.placeHoldLabel];
    [self addSubview:self.placeHoldBtn];
    
    [self.placeHoldLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.placeHoldLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.placeHoldLabel autoSetDimension:ALDimensionWidth toSize:250];
    
    [self.placeImageView autoSetDimensionsToSize:CGSizeMake(100, 100)];
    [self.placeImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.placeHoldLabel withOffset:-5];
    [self.placeImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [self.placeHoldBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.placeHoldLabel withOffset:10];
    [self.placeHoldBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.placeHoldBtn autoSetDimensionsToSize:CGSizeMake(120, 25)];
    
    [self.placeHoldBtn addTarget:self action:@selector(callBack) forControlEvents:UIControlEventTouchUpInside];
}

-(YJBlockImageView *)placeImageView
{
    if (!_placeImageView) {
        _placeImageView = [YJBlockImageView autolayoutView];
        [_placeImageView setBlock:^(YJBlockImageView *sender) {
            YJLog(@"121313");
        }];
    }
    return _placeImageView;
}

-(UILabel *)placeHoldLabel
{
    if (!_placeHoldLabel) {
        _placeHoldLabel = [UILabel autolayoutView];
        _placeHoldLabel.font = YJFont(14);
        _placeHoldLabel.textColor = HEXRGBCOLOR(0x333333);
        _placeHoldLabel.textAlignment = NSTextAlignmentCenter;
        _placeHoldLabel.numberOfLines = 0;
    }
    return _placeHoldLabel;
}

-(UIButton *)placeHoldBtn
{
    if (!_placeHoldBtn) {
        _placeHoldBtn = [UIButton autolayoutView];
        _placeHoldBtn.backgroundColor = YJNaviColor;
        _placeHoldBtn.layer.cornerRadius = 5;
        _placeHoldBtn.layer.masksToBounds = YES;
        _placeHoldBtn.titleLabel.font = YJFont(16);
        [_placeHoldBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_placeHoldBtn addTarget:self action:@selector(callBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _placeHoldBtn;
}

- (void)setInfo:(NSString *)Info ImgName:(NSString *)ImgName buttonTitle:(NSString *)title
{
    self.placeHoldLabel.text=Info;
    if (ImgName.length) {
        self.placeImageView.image=[UIImage imageNamed:ImgName];
    }
    
    if (title.length) {
        self.placeHoldBtn.hidden=NO;
        [self.placeHoldBtn setTitle:title forState:UIControlStateNormal];
    }else{
        self.placeHoldBtn.hidden=YES;
    }
}

-(void)callBack
{
    if (self.PlaceHoldBlock) {
        self.PlaceHoldBlock(self.placeHoldBtn.titleLabel.text);
    }
}

@end

