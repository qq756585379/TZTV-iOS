//
//  UIViewController+YJ.h
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NaviButton_None = 0,        //空的，无图片
    NaviButton_Return,          //返回
    NaviButton_Return_white,    //返回，白色箭头
    NaviButton_Search,          //搜索
    NaviButton_ReturnHome,      //返回首页
    NaviButton_Setting,         //设置
    NaviButton_Favorite,        //收藏
    NaviButton_GrayShare,       //灰色分享
    NaviButton_RockNow,         //摇一摇
    NaviButton_Scan,            //扫描
    NaviButton_MessageCenter,   //消息中心
    NaviButton_WhiteBack,       //白色背景框
    NaviButton_Category,        //分类
    NaviButton_Logo,            //logo
    NaviButon_Brand_Category,   //品牌团分类选择
    NaviButton_Gray,            //灰色按钮
} NaviButtonType;

@interface UIViewController (YJ)
//功能:设置左按钮的类型（图片）
- (void)setNaviButtonType:(NaviButtonType)aType frame:(CGRect)aFrame;
/**
 *  功能:设置左按钮类型（图片）
 *  type:按钮类型
 */
- (void)setNaviButtonType:(NaviButtonType)aType isLeft:(BOOL)aLeft;
/**
 *  功能:左按钮点击行为，可在子类重写此方法
 */
- (void)leftBtnClicked:(id)sender;
/**
 *  功能:右按钮点击行为，可在子类重写此方法
 */
- (void)rightBtnClicked:(id)sender;

//设置导航栏样式
- (void)setNavgationBarBackGroundImage:(UIImage *)backGroundImage andShadowImage:(UIImage *)shadowImage;
@end
