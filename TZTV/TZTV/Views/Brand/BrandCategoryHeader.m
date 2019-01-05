//
//  BrandCategoryHeader.m
//  TZTV
//
//  Created by Luosa on 2016/11/15.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandCategoryHeader.h"

@interface BrandCategoryHeader()
@property(nonatomic, strong)UITapGestureRecognizer * tap;

@end

@implementation BrandCategoryHeader

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.tap];
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    [self addSubview:self.titleLb];
    NSDictionary *views = NSDictionaryOfVariableBindings(_titleLb);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_titleLb]-0-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_titleLb]-0-|" options:0 metrics:nil views:views]];
}

-(UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel autolayoutView];
        _titleLb.textColor = HEXRGBCOLOR(0x333333);
        _titleLb.font = [UIFont systemFontOfSize:16.0];
        _titleLb.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLb;
}

-(UITapGestureRecognizer *)tap{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] init];
        [_tap addTarget:self action:@selector(totalBtnClicked:)];
        _tap.numberOfTapsRequired = 1;
    }
    return _tap;
}

- (void)totalBtnClicked:(id)sneder {
//    if ([self.delegate respondsToSelector:@selector(phoneCategoryHeaderEnterSearch:totalBtnClicked:)]) {
//        [self.delegate phoneCategoryHeaderEnterSearch:self totalBtnClicked:@111];
//    }
}

@end
