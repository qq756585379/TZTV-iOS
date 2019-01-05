//
//  UIScrollView+DeliverTouch.h
//  TZTV
//
//  Created by Luosa on 2016/11/15.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (DeliverTouch)

/**
 *  在scrollView上的点击事件是否往上层(父视图)传递,默认是NO.
 *  如果设置为YES,在scrollView上的点击事件自己处理后，然后再传递给上层视图处理
 */
@property(nonatomic)IBInspectable BOOL deliverTouchEvent;

@end
