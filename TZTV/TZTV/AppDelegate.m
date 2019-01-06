//
//  AppDelegate.m
//  TZTV
//
//  Created by Luosa on 2016/11/7.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "AppDelegate.h"
#import "MeViewController.h"
#import "PhoneTBC.h"
#import "MapManager.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[MapManager sharedManager] startSearchLocation];
    [[UITextField appearance] setTintColor:[UIColor lightGrayColor]];
    
    //微信支付初始化
    [WXApi registerApp:@"wxa5b3e3de83f1c79e"];
    
    //for 轮播图广告等
    self.topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.topWindow.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    self.topWindow.windowLevel = UIWindowLevelAlert + 1;
    self.topWindow.rootViewController = [UIViewController new];
    [self.topWindow makeKeyAndVisible];
    self.topWindow.hidden = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[PhoneTBC alloc] init];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)endEditing
{
    [self.window endEditing:YES];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[SDImageCache sharedImageCache] clearMemory];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSLog(@"9.0以后使用新API接口");
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [self postNotification:PaySuccessNotification withObject:nil userInfo:resultDic];//发通知
        }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result2 = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    //微信支付
    if ([WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]] && url ){
        return YES;
    }else{
        return NO;
    }
    return YES;
}

@end
