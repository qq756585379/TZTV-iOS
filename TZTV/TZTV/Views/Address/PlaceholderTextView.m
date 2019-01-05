//
//  PlaceholderTextView.m
//  百思姐
//
//  Created by sctto on 16/4/29.
//  Copyright © 2016年 sctto. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView ()
@property (nonatomic, weak) UILabel *placeholderLabel;
@end

@implementation PlaceholderTextView

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.x = 4;
        placeholderLabel.y = 7;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
}

-(void)initUI{
    self.alwaysBounceVertical = YES;
    self.font = [UIFont systemFontOfSize:15];
    self.placeholderColor = [UIColor grayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange)
                                                 name:UITextViewTextDidChangeNotification object:nil];
}

/**
 * 监听文字改变
 */
- (void)textDidChange{
    self.placeholderLabel.hidden = self.hasText;
}

#pragma mark - 重写setter
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    [self.placeholderLabel sizeToFit];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
