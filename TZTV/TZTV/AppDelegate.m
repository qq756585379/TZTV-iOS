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

-(void)iotConfig
{
    LKIoTConnectConfig * config = [LKIoTConnectConfig new];
    config.productKey = @"a1OqSWWA7BM";
    config.deviceName = @"WJMyrbcXQ9kXlTEoMjQq";
    config.deviceSecret = @"0wVgAzgEIEfk4dQ8jFXobclUhJGqH0X5";
    config.server = nil;//设为nil表示使用IoT平台作为连接服务器
    //config.port = 1883;//your server port。如果server被设置为nil。则port也不要设置。
    config.receiveOfflineMsg = YES;//如果希望收到客户端离线时的消息，可以设为YES.
    [[LKIoTExpress sharedInstance] startConnect:config connectListener:self];
    //如果config.server置为nil，则默认连接的地址为上海节点：${yourProductKey}.iot-as-mqtt.cn-shanghai.aliyuncs.com:1883`
    
    
    [[LKIoTExpress sharedInstance] addDownstreamListener:LKExpressDownListenerTypeGw listener:self];
    //downListener在本SDK中 是 weak reference，所以需要调用者保证生命周期。
    
    
    
    NSString *topic = @"/sys/a1OqSWWA7BM/WJMyrbcXQ9kXlTEoMjQq/app/down/event";
    [[LKIoTExpress sharedInstance] subscribe:topic complete: ^(NSError * error) {
        if (error != nil) {
            NSLog(@"业务请求失败");
        }
    }];
    
    
    
//    NSString *topic = @"/sys/a1OqSWWA7BM/WJMyrbcXQ9kXlTEoMjQq/account/bind";
//    NSDictionary *params = @{ @"iotToken": token};
//    [[LKIoTExpress sharedInstance] invokeWithTopic:topic
//                                              opts:nil
//                                            params:params
//                                       respHandler:^(LKExpressResponseHandler * _Nonnull response) {
//                                           if (![response successed]) {
//                                               NSLog(@"业务请求失败");
//                                           }
//                                       }];
}

///<topic-消息topic，data-消息内容,NSString 或者 NSDictionary
-(void)onDownstream:(NSString *) topic data: (id _Nullable) data{
    NSLog(@".......%@",topic);
    NSLog(@".......%@",data);
}

///<数据使用onDownstream:data:上抛时，可以先过滤一遍，如返回NO，则不上传，返回YES，则会使用onDownstream:data:上抛
-(BOOL)shouldHandle:(NSString *)topic{
    return YES;
}

///<通道连接状况改变，参见枚举LKExpConnectState
-(void)onConnectState:(LKExpressConnectState) state
{
    if (state == LKExpressConnectStateConnected) {
        NSLog(@"已经连接。。。。");
    }else if (state == LKExpressConnectStateDisconnected){
        NSLog(@"失去连接。。。。");
    }else if (state == LKExpressConnectStateConnecting){
        NSLog(@"连接中。。。。");
    }
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
