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
                    frame:(CGRect)aFrame{
//    [self setNaviButtonType:aType isBgImg:NO frame:aFrame text:nil color:nil font:nil shadowOffset:CGSizeZero alignment:UIControlContentHorizontalAlignmentLeft edgeInsets:UIEdgeInsetsZero isLeft:YES];
}

- (void)setNaviButtonType:(NaviButtonType)aType
                    frame:(CGRect)aFrame
                     text:(NSString *)aText
                    color:(UIColor *)aColor
                     font:(UIFont *)aFont{
//    [self setNaviButtonType:aType isBgImg:NO frame:aFrame text:aText color:aColor font:aFont shadowOffset:CGSizeZero alignment:UIControlContentHorizontalAlignmentLeft edgeInsets:UIEdgeInsetsZero isLeft:YES];
}


- (void)leftBtnClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(id)sender{
    
}

/**
 *  功能:设置左按钮类型（图片）
 *  type:按钮类型
 */
- (void)setNaviButtonType:(NaviButtonType)aType isLeft:(BOOL)aLeft{
    [self setNaviButtonType:aType frame:CGRectZero text:nil color:nil font:nil shadowOffset:CGSizeZero alignment:UIControlContentHorizontalAlignmentLeft edgeInsets:UIEdgeInsetsZero isLeft:aLeft];
}

- (void)setNaviButtonType:(NaviButtonType)aType
                    frame:(CGRect)aFrame
                     text:(NSString *)aText
                    color:(UIColor *)aColor
                     font:(UIFont *)aFont
             shadowOffset:(CGSize)aShadowOffset
                alignment:(UIControlContentHorizontalAlignment)aAlignment
               edgeInsets:(UIEdgeInsets)aEdgeInsets
                   isLeft:(BOOL)aLeft{
    [self setNaviButtonType:aType isBgImg:NO frame:aFrame text:aText color:aColor font:aFont shadowOffset:aShadowOffset alignment:aAlignment edgeInsets:aEdgeInsets isLeft:aLeft];
}

- (void)setNaviButtonType:(NaviButtonType)aType
                  isBgImg:(BOOL)aIsBgImg
                    frame:(CGRect)aFrame
                     text:(NSString *)aText
                    color:(UIColor *)aColor
                     font:(UIFont *)aFont
             shadowOffset:(CGSize)aShadowOffset
                alignment:(UIControlContentHorizontalAlignment)aAlignment
               edgeInsets:(UIEdgeInsets)aEdgeInsets
                   isLeft:(BOOL)aLeft{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CGRectEqualToRect(CGRectZero, aFrame)) {
        btn.frame = CGRectMake(0, 0, 24, 24);
    }else {
        btn.frame = aFrame;
    }
    SEL selector = nil;
    if (aLeft) {
        selector = @selector(leftBtnClicked:);
    }else {
        selector = @selector(rightBtnClicked:);
    }
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    //根据样式不同更改按钮图片
    UIImage *normalImage = nil;
    UIImage *highlightImage = nil;
    switch (aType) {
        case NaviButton_None: {//空的，无图片
            normalImage = nil;
            highlightImage = nil;
            break;
        }
        case NaviButton_Return: {//返回
            normalImage = [UIImage imageNamed:@"return"];
            highlightImage = [UIImage imageNamed:@"return"];
            break;
        }
        case NaviButton_Return_white:{
            
            break;
        }
        case NaviButton_ReturnHome: {//返回首页
            
            break;
        }
        case NaviButton_Setting: {//设置
            
            break;
        }
        case NaviButton_Search: {//搜索
            
            break;
        }
        case NaviButton_Favorite: {//收藏
            
            break;
        }
        case NaviButton_GrayShare: {//灰色分享
            
            break;
        }
        case NaviButton_RockNow: { // 摇一摇
            
            break;
        }
        case NaviButton_Scan: { // 扫描
            
            break;
        }
        case NaviButton_MessageCenter: { // 消息中心
            
            break;
        }
        case NaviButton_WhiteBack: { // 白色边框
            
            break;
        }
        case NaviButton_Category: { // 白色边框
            
            break;
        }
        case NaviButon_Brand_Category: { // 白色边框
            
            break;
        }
        case NaviButton_Logo: { // 白色边框
//            normalImage = [UIImage imageNamed:@"navigationbar_btn_logo" bundleName:nil];
//            highlightImage = [UIImage imageNamed:@"navigationbar_btn_logo" bundleName:nil];
//            btn.frame = CGRectMake(0, 0, 36, 34);
            break;
        }
        case NaviButton_Gray: {
            
            break;
        }
        default:
            normalImage = nil;
            highlightImage = nil;
            break;
    }
    if (aIsBgImg) {
        [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
        [btn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    } else {
        [btn setImage:normalImage forState:UIControlStateNormal];
        [btn setImage:highlightImage forState:UIControlStateHighlighted];
    }
    if (aText != nil) {
        [btn setTitle:aText forState:UIControlStateNormal];
    }
    if (aColor) {
        [btn setTitleColor:aColor forState:UIControlStateNormal];
    }
    if (aFont) {
        btn.titleLabel.font = aFont;
    }
    if (!CGSizeEqualToSize(CGSizeZero, aShadowOffset)) {
        btn.titleLabel.shadowOffset = aShadowOffset;
    }
    btn.contentHorizontalAlignment = aAlignment;
    if (!UIEdgeInsetsEqualToEdgeInsets(aEdgeInsets, UIEdgeInsetsZero)) {
        btn.contentEdgeInsets = aEdgeInsets;
    }
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if (aLeft) {
        self.navigationItem.leftBarButtonItem = btnItem;
    }else {
        self.navigationItem.rightBarButtonItem = btnItem;
    }
}

//设置导航栏样式
-(void) setNavgationBarBackGroundImage:(UIImage *)backGroundImage andShadowImage:(UIImage *)shadowImage{
    [self.navigationController.navigationBar setBackgroundImage:backGroundImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:shadowImage];//去掉黑线
}

@end
