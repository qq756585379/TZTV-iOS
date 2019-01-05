//
//  UIBarButtonItem+Create.h
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Create)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

+ (instancetype)itemWithTitle:(NSString *)title textColor:(UIColor *)color textFont:(UIFont *)font target:(id)target action:(SEL)action;

@end
