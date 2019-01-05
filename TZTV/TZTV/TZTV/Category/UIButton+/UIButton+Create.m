//
//  UIButton+Create.m
//  TZTV
//
//  Created by Luosa on 2016/11/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "UIButton+Create.h"
#import "BaseBtn.h"

@implementation UIButton (Create)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:state];
}

+ (UIButton *)createButtonWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)txcolor font:(UIFont *)font image:(NSString *)imageName bgImage:(NSString *)bgImageName superView:(UIView *)superView{
    UIButton *button=[self createButtonWithText:text textColor:txcolor font:font image:imageName bgImage:bgImageName bgColor:nil superView:superView];
    button.frame=frame;
    return button;
}
+ (UIButton *)createButtonWithText:(NSString *)text textColor:(UIColor *)txcolor font:(UIFont *)font image:(NSString *)imageName bgImage:(NSString *)bgImageName superView:(UIView *)superView{
    UIButton *button=[self createButtonWithText:text textColor:txcolor font:font image:imageName bgImage:bgImageName bgColor:nil superView:superView];
    return button;
}
+ (UIButton *)createButtonWithText:(NSString *)text textColor:(UIColor *)txcolor font:(UIFont *)font bgColor:(UIColor *)color image:(NSString *)imageName superView:(UIView *)superView{
    UIButton *button=[self createButtonWithText:text textColor:txcolor font:font image:imageName bgImage:nil bgColor:color superView:superView];
    return button;
}
+ (UIButton *)createButtonWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)txcolor font:(UIFont *)font bgColor:(UIColor *)color image:(NSString *)imageName superView:(UIView *)superView{
    UIButton *button=[self createButtonWithText:text textColor:txcolor font:font image:imageName bgImage:nil bgColor:color superView:superView];
    button.frame=frame;
    return button;
}

// 创建按钮
+ (UIButton *)createButtonWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font image:(NSString *)imageName bgImage:(NSString *)bgImageName bgColor:(UIColor *)bgColor superView:(UIView *)superView{
    BaseBtn *button=[BaseBtn buttonWithType:UIButtonTypeCustom];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.titleLabel.font=font;
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (bgImageName) {
        [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    if (bgColor) {
        [button setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateNormal];
    }
    if (superView) {
        [superView addSubview:button];
    }
    return button;
}


@end
