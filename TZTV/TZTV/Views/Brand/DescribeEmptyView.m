//
//  DescribeEmptyView.m
//  TZTV
//
//  Created by Luosa on 2016/11/16.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "DescribeEmptyView.h"

@implementation DescribeEmptyView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.separatorLineView];
        self.separatorLineView.hidden = YES;
        
        [self addSubview:self.alertIconView];
        [self addSubview:self.emptyLabel];
        
        [self.alertIconView autoSetDimensionsToSize:CGSizeMake(90, 90)];
        [self.alertIconView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [self.alertIconView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [self.emptyLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.emptyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.alertIconView withOffset:20];
        [self.emptyLabel autoSetDimension:ALDimensionHeight toSize:13];
    }
    return self;
}

#pragma mark- Setup
- (void)showSeparatorLineView{
    self.separatorLineView.hidden = NO;
}

- (void)hideSeparatorLineView{
    self.separatorLineView.hidden = YES;
}

#pragma mark- Layout
- (void)layoutSubviews{
    [super layoutSubviews];
    self.separatorLineView.width = self.width;
    self.separatorLineView.top = 0;
}

#pragma mark-
- (UIImageView *)alertIconView{
    if (_alertIconView == nil) {
        _alertIconView = [UIImageView autolayoutView];
        _alertIconView.image = [UIImage imageNamed:@"alert_face"];
    }
    return _alertIconView;
}

- (UILabel *)emptyLabel{
    if (_emptyLabel == nil) {
        _emptyLabel = [UILabel autolayoutView];
        _emptyLabel.font = YJFont(15);
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.textColor = [UIColor grayColor];
    }
    return _emptyLabel;
}

#pragma mark- Property
- (UIImageView *)separatorLineView{
    if (_separatorLineView == nil) {
        _separatorLineView.backgroundColor=kF5F5F5;
        _separatorLineView.height = 0.5;
    }
    return _separatorLineView;
}

@end
