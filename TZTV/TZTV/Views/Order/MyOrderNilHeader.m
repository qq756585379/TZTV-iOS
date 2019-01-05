//
//  MyOrderNilHeader.m
//  TZTV
//
//  Created by Luosa on 2016/11/23.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrderNilHeader.h"

@implementation MyOrderNilHeader

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=kF5F5F5;
        [self initUI];
    }
    return self;
}

-(void)initUI{
    [self addSubview:self.placeHoldView];
    [self addSubview:self.dragTipView];
    
    [self.placeHoldView autoPinEdgesToSuperviewEdges];
    
    [self.dragTipView autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.dragTipView autoSetDimension:ALDimensionHeight toSize:35];
}

-(PlaceHoldView *)placeHoldView {
    if (_placeHoldView == nil) {
        _placeHoldView = [PlaceHoldView autolayoutView];
        _placeHoldView.backgroundColor = kF5F5F5;
    }
    return _placeHoldView;
}

- (PhoneDragTips *)dragTipView{
    if (_dragTipView == nil) {
        _dragTipView = [[PhoneDragTips alloc] initWithTips:@"猜你喜欢"];
        _dragTipView.tipsLabel.font=YJFont(16);
        _dragTipView.tipsLabel.textColor=HEXRGBCOLOR(0x333333);
        _dragTipView.height = 35;
        _dragTipView.backgroundColor=HEXRGBCOLOR(0xefefef);
        _dragTipView.width = ScreenW;
    }
    return _dragTipView;
}

@end
