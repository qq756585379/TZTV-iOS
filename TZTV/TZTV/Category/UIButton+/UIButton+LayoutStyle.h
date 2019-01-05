//
//  UIButton+LayoutStyle.h
//  OneStore
//
//  Created by airspuer on 14-5-13.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

/**
*  1.建议使用autoLayout来设置button,frame不用设置，可自动适配
*  2.如果需要固定frame,那么就按照没有改变样式之前设置.
*    布局改变时,会根据titleLabe,imageView的frame来修改其位置.
*    修改layoutStyle之前titleLabe,imageView显示异常,修改之后也会异常.
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OTSUIButtonLayoutStyle) {
    OTSDefalutStyle = 0,//默认的方式
	OTSImageLeftTitleRightStyle = 1, // image左 title右
	OTSTitleLeftImageRightStyle = 2, // image右,title左
	OTSImageTopTitleBottomStyle = 3, // image上，title下
	OTSTitleTopImageBottomStyle = 4, // image下,title上
};

@interface UIButton(LayoutStyle)

/**
 *  图片和文字显示方向
 */
@property(nonatomic)IBInspectable OTSUIButtonLayoutStyle layoutStyle;

/**
 *  图片和文字之间的间距
 */
@property (nonatomic, assign) IBInspectable CGFloat layoutSpacing;

/**
 *	功能:设置UIButton的布局，图片和文字按照指定方向显示
 */
- (void)setLayout:(OTSUIButtonLayoutStyle )aLayoutStyle
		  spacing:(CGFloat)aSpacing;
@end




