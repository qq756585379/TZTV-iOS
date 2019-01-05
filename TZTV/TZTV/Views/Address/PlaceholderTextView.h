//
//  PlaceholderTextView.h
//  百思姐
//
//  Created by sctto on 16/4/29.
//  Copyright © 2016年 sctto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
