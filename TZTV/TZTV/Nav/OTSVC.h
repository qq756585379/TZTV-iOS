//
//  OTSVC.h
//  TZTV
//
//  Created by Luosa on 2017/2/16.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface OTSVC : UIViewController

/**
 *  motion 处理摇一摇截图
 */
@property (nonatomic, strong) CMMotionManager *motionManager;

//将NSDate类型的时间转换为NSInteger类型,从1970/1/1开始
-(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime;
//添加人机识别参数的方法，在需要  接入人机识别  的VC里调用
- (void)addBaseInfoToHciTokens;

@end
