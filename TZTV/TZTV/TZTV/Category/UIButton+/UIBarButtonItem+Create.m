//
//  UIBarButtonItem+Create.m
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "UIBarButtonItem+Create.h"

@implementation UIBarButtonItem (Create)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    //button.size = button.currentBackgroundImage.size;
    //button.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitleColor:HEXRGBCOLOR(0x666666) forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //    button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    return [[self alloc] initWithCustomView:button];
}


@end
