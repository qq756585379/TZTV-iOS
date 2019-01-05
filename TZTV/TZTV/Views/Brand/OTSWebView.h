//
//  OTSWebView.h
//  TZTV
//
//  Created by Luosa on 2016/11/16.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSWebView : UIWebView
/**
 *  设置cookie
 */
+ (void)setCookie:(NSString *)aDomain name:(NSString *)aName value:(NSString *)aValue;
/**
 *  设置cookie
 */
+ (void)setCookieName:(NSString *)aName value:(NSString *)aValue;
/**
 *  清除cookies
 */
+ (void)clearCookies;

/**
 *  添加默认的cookies
 */
+ (void)setupDefaultCookies;

@end
