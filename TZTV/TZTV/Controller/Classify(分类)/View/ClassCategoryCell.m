//
//  ClassCategoryCell.m
//  TZTV
//
//  Created by 杨俊 on 2019/1/7.
//  Copyright © 2019年 Luosa. All rights reserved.
//

#import "ClassCategoryCell.h"

@interface ClassCategoryCell()
/* 标题 */
@property (strong , nonatomic)UILabel *titleLabel;
/* 指示View */
@property (strong , nonatomic)UIView *indicatorView;
@end

@implementation ClassCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_titleLabel];
    
    _indicatorView = [[UIView alloc] init];
    _indicatorView.hidden = NO;
    _indicatorView.backgroundColor = [UIColor redColor];
    [self addSubview:_indicatorView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(4);
    }];
}

#pragma mark - cell点击
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _indicatorView.hidden = NO;
        _titleLabel.textColor = [UIColor redColor];
        self.backgroundColor = [UIColor whiteColor];
    }else{
        _indicatorView.hidden = YES;
        _titleLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - Setter Getter Methods
-(void)setClassifyVO:(ClassifyVO *)classifyVO{
    _classifyVO = classifyVO;
    self.titleLabel.text = classifyVO.name;
}

@end
