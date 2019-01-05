//
//  OTSNC.h
//  TZTV
//
//  Created by Luosa on 2017/2/16.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSNC : UINavigationController

//@property(nonatomic,retain) PhoneTabBarItem *tabbarItem;

@property (nonatomic, getter=isAppearingVC) BOOL appearingVC;
//进度动画
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactivePopTransition;

@end
