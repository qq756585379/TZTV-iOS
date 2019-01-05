//
//  UIButton+Create.h
//  TZTV
//
//  Created by Luosa on 2016/11/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Create)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

// 创建按钮
+ (UIButton *)createButtonWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)txcolor font:(UIFont *)font image:(NSString *)imageName bgImage:(NSString *)bgImageName superView:(UIView *)superView;

+ (UIButton *)createButtonWithText:(NSString *)text textColor:(UIColor *)txcolor font:(UIFont *)font image:(NSString *)imageName bgImage:(NSString *)bgImageName superView:(UIView *)superView;

+ (UIButton *)createButtonWithText:(NSString *)text textColor:(UIColor *)txcolor font:(UIFont *)font bgColor:(UIColor *)color image:(NSString *)imageName superView:(UIView *)superView;

+ (UIButton *)createButtonWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)txcolor font:(UIFont *)font bgColor:(UIColor *)color image:(NSString *)imageName superView:(UIView *)superView;

+ (UIButton *)createButtonWithText:(NSString *)text textColor:(UIColor *)txcolor font:(UIFont *)font tag:(NSInteger )tag  superView:(UIView *)superView;

@end
