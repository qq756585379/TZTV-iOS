//
//  UIWindow+YJ.m
//  TZTV
//
//  Created by Luosa on 2016/11/11.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "UIWindow+YJ.h"

@implementation UIWindow (YJ)

- (void)switchRootViewController{
    NSString *key = @"CFBundleShortVersionString";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if (![currentVersion isEqualToString:lastVersion]) {
//        NewFeatureVC *vc=[[NewFeatureVC alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
//        YJAppDelegate.topWindow.hidden=NO;
//        [YJAppDelegate.topWindow.rootViewController.view addSubview:vc];
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
//    self.rootViewController = [[YJTabBarVC alloc] init];
}

@end
