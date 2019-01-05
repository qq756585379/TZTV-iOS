//
//  OTSWebView.m
//  TZTV
//
//  Created by Luosa on 2016/11/16.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "OTSWebView.h"
#import "OTSWeakObjectDeathNotifier.h"

@implementation OTSWebView

#pragma mark - cookies
+ (void)setCookie:(NSString *)aDomain name:(NSString *)aName value:(NSString *)aValue{
    if (!aName) {
        return ;
    }
    if (!aValue) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies.copy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSHTTPCookie *cookie = obj;
            if ([cookie.properties[NSHTTPCookieName] isEqualToString:aName]) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:obj];
                *stop = YES;
            }
        }];
        return ;
    }
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    cookieProperties[NSHTTPCookieDomain] = aDomain;
    cookieProperties[NSHTTPCookieName] = aName;
    cookieProperties[NSHTTPCookieValue] = aValue;
    cookieProperties[NSHTTPCookiePath] = @"/";
    cookieProperties[NSHTTPCookieVersion] = @"0";
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

+ (void)setCookieName:(NSString *)aName value:(NSString *)aValue{
    [self setCookie:@".yhd.com" name:aName value:aValue];
}

+ (void)setupDefaultCookies{
//    /**
//     *  token
//     */
//    [OTSWebView setCookieName:@"usertoken" value:[OTSGlobalValue sharedInstance].token];
//    /**
//     *  省份ID
//     */
//    [OTSWebView setCookieName:@"provinceid" value:[OTSCurrentAddress sharedInstance].currentProvinceId.stringValue];
//    //应h5之邀请，加这个
//    [OTSWebView setCookieName:@"provinceId" value:[OTSCurrentAddress sharedInstance].currentProvinceId.stringValue];
//    /**
//     *  sessionid
//     */
//    [OTSWebView setCookieName:@"sessionid" value:[OTSGlobalValue sharedInstance].sessionId];
//    /**
//     *  clientinfo
//     */
//    [OTSWebView setCookieName:@"clientinfo" value:[OTSJsonKit stringFromDict:[[OTSClientInfo sharedInstance] convertDictionary]].urlEncodingAllCharacter];
//    /**
//     *  frameworkver
//     */
//    [OTSWebView setCookieName:@"frameworkver" value:@"1.0"];
//    /**
//     *  platform
//     */
//    [OTSWebView setCookieName:@"platform" value:@"ios"];
//    /**
//     *  ut
//     */
//    [OTSWebView setCookieName:@"ut" value:[OTSGlobalValue sharedInstance].token];
//    /**
//     *  guid
//     */
//    [OTSWebView setCookieName:@"guid" value:[OTSClientInfo sharedInstance].deviceCode];
//    /**
//     *  tracker_msessionid
//     */
//    [OTSWebView setCookieName:@"tracker_msessionid" value:[OTSBIGlobalValue sharedInstance].generateSessionId];
//    /**
//     *  打开渠道
//     */
//    [OTSWebView setCookieName:@"tracker_u" value:[OTSBIGlobalValue sharedInstance].trackerUrl];
//    /**
//     *  网站网址ID
//     */
//    [OTSWebView setCookieName:@"websiteId" value:[OTSBIGlobalValue sharedInstance].website];
//    /**
//     *  uid
//     */
//    [OTSWebView setCookieName:@"uid" value:[OTSBIGlobalValue sharedInstance].uid];
}

+ (void)clearCookies{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies.copy enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:obj];
    }];
}

- (void)dealloc{
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDelegate:(id<UIWebViewDelegate>)delegate{
    [super setDelegate:delegate];
    if (delegate == nil) {
        return;
    }
    OTSWeakObjectDeathNotifier *wo = [OTSWeakObjectDeathNotifier new];
    [wo setOwner:delegate];
    WEAK_SELF;
    [wo setBlock:^(OTSWeakObjectDeathNotifier *sender) {
        STRONG_SELF;
        self.delegate = nil;
    }];
}

@end
