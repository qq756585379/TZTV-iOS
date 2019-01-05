//
//  PhoneDragTips.m
//  TZTV
//
//  Created by Luosa on 2016/11/15.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "PhoneDragTips.h"

@interface PhoneDragTips()
@property (nonatomic, strong)UIView   *leftLine;
@property (nonatomic, strong)UIView   *rightLine;
@property (nonatomic, strong)NSString *content;
@end

@implementation PhoneDragTips

- (instancetype)initWithTips:(NSString *)tips
{
    if (self = [super init]) {
        self.content = tips;
        [self configerUI];
    }
    return self;
}

- (void)configerUI
{
    [self addSubview:self.leftLine];
    [self addSubview:self.rightLine];
    [self addSubview:self.tipsLabel];

    NSDictionary *views = @{@"leftline": self.leftLine,
                            @"rightline":self.rightLine,
                            @"tipslabel":self.tipsLabel};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[leftline]-(5)-[tipslabel]-(5)-[rightline(leftline)]-(10)-|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(17)-[leftline(0.5)]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(17)-[rightline(0.5)]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8)-[tipslabel]-(8)-|" options:0 metrics:nil views:views]];
}

- (void)setTipsContent:(NSString *)content
{
    self.tipsLabel.text = content;
}

-(UIView *)leftLine{
    if (_leftLine == nil) {
        _leftLine = [UIView autolayoutView];
        _leftLine.backgroundColor = HEXRGBCOLOR(0x777777);
    }
    return _leftLine;
}

-(UIView *)rightLine{
    if (_rightLine == nil) {
        _rightLine = [UIView autolayoutView];
        _rightLine.backgroundColor = HEXRGBCOLOR(0x777777);
    }
    return _rightLine;
}

- (UILabel *)tipsLabel{
    if (_tipsLabel == nil) {
        _tipsLabel = [UILabel autolayoutView];
        _tipsLabel.textColor = [UIColor lightGrayColor];
        _tipsLabel.font = YJFont(13);
        _tipsLabel.textColor = [UIColor lightGrayColor];
        _tipsLabel.text = self.content;
    }
    return _tipsLabel;
}

@end
