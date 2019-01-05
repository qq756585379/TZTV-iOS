//
//  UIViewController+YJ.m
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "UIViewController+YJ.h"
#import "OTSDataNaviBtn.h"

@implementation UIViewController (YJ)

- (void)setNaviButtonType:(NaviButtonType)aType
                    frame:(CGRect)aFrame
{
//    [self setNaviButtonType:aType isBgImg:NO frame:aFrame text:nil color:nil font:nil shadowOffset:CGSizeZero alignment:UIControlContentHorizontalAlignmentLeft edgeInsets:UIEdgeInsetsZero isLeft:YES];
}

- (void)setNaviButtonType:(NaviButtonType)aType
                    frame:(CGRect)aFrame
                     text:(NSString *)aText
                    color:(UIColor *)aColor
                     font:(UIFont *)aFont
{
//    [self setNaviButtonType:aType isBgImg:NO frame:aFrame text:aText color:aColor font:aFont shadowOffset:CGSizeZero alignment:UIControlContentHorizontalAlignmentLeft edgeInsets:UIEdgeInsetsZero isLeft:YES];
}




- (void)leftBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtnClicked:(id)sender{
    
}


@end
