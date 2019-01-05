//
//  Common_Define.h
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#ifndef Common_Define_h
#define Common_Define_h

//关于颜色
#define RGBCOLOR(r,g,b)           [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)        [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define HEXRGBACOLOR(rgbValue, alphaValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0x00FF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0x0000FF)) / 255.0 alpha : alphaValue]

#define HEXRGBCOLOR(rgbValue) [UIColor colorWithRed : ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green : ((float)((rgbValue & 0x00FF00) >> 8)) / 255.0 blue : ((float)(rgbValue & 0x0000FF)) / 255.0 alpha:1.0f]

//随机色
#define RANDOM_COLOR [UIColor colorWithRed:arc4random()%255/255.f green:arc4random()%255/255.f blue:arc4random()%255/255.f alpha:arc4random()%255/255.f]


#define YJNaviColor             HEXRGBCOLOR(0xfede0a)
#define kF5F5F5                 HEXRGBCOLOR(0xf5f5f5)
#define kECECEC                 HEXRGBCOLOR(0xececec)
#define kEDEDED                 HEXRGBCOLOR(0xededed)
#define kDCDCDC                 HEXRGBCOLOR(0xdcdcdc)
#define kFAFAFA                 HEXRGBCOLOR(0xfafafa)

#define kWhiteColor             [UIColor whiteColor]
#define kClearColor             [UIColor clearColor]
#define kRedColor               [UIColor redColor]
#define kGreenColor             [UIColor greenColor]
#define kBlackColor             [UIColor blackColor]


#define ScreenW                   [UIScreen mainScreen].bounds.size.width
#define ScreenH                   [UIScreen mainScreen].bounds.size.height

#define kMargin_10 10
#define kMargin_15 15

#define sb                        [UIStoryboard storyboardWithName:@"Main" bundle:nil]

/**快速创建弱指针*/
#define WEAK_SELF    __weak typeof(self) weakSelf = self;
#define STRONG_SELF  __strong typeof(weakSelf) self = weakSelf;

/**打印*/
#ifdef DEBUG
#define YJLog(...) printf("%s 第%d行: %s\n\n", [[NSString stringWithFormat:@"%s", __FILE__].lastPathComponent UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define YJLog(...)
#endif

//字体
#define YJFont(size)     [UIFont systemFontOfSize:size]
#define YJBoldFont(size) [UIFont boldSystemFontOfSize:size]

//判断ios版本
#define IOS_SDK_MORE_THAN_OR_EQUAL(__num) [UIDevice currentDevice].systemVersion.floatValue >= (__num)
#define IOS_SDK_MORE_THAN(__num) [UIDevice currentDevice].systemVersion.floatValue > (__num)
#define IOS_SDK_LESS_THAN(__num) [UIDevice currentDevice].systemVersion.floatValue < (__num)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define YJAppDelegate       ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define YJWindow            ((UIWindow *)[[UIApplication sharedApplication] keyWindow])

#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#define USER_DEFAULT                     [NSUserDefaults standardUserDefaults]
#define NOTIFICATION_CENTER              [NSNotificationCenter defaultCenter]


#define LY_EaseMob_MSG_TYPE_COMMENT      @"comment"         // 评论
#define LY_EaseMob_MSG_TYPE_C_LIKE       @"commentAndLike"  // 点赞加评论提示
#define LY_EaseMob_MSG_TYPE_LIKE         @"like"            // 点赞动画
#define LY_EaseMob_MSG_TYPE_GIFT         @"gift"            // 礼物
#define LY_EaseMob_MSG_TYPE_LEAVE        @"leave"           // 主播离开一会
#define LY_EaseMob_MSG_TYPE_BACK         @"back"            // 主播回来了
#define LY_EaseMob_MSG_TYPE_USER_JOIN    @"userJoined"      // 有人加入了
#define LY_EaseMob_MSG_TYPE_USER_LEAVE   @"userLeaved"      // 有人离开了
#define LY_EaseMob_MSG_TYPE_END_LIVE     @"endLive"         // 直播结束

#define LY_avatar   @"avatar"
#define LY_nickName @"nickName"
#define LY_content  @"content"
#define LY_giftType @"giftType"
#define LY_level    @"level"
#define LY_userId   @"userId"
#define LY_dataType @"dataType"
#define LY_onlineCount @"onlineCount"
#define LY_coinCount @"coinCount"

// 用户的信息
#define USER_avatar @"default_head"
#define USER_nickName @"Louisly" // [GVUserDefaults standardUserDefaults].nickname
#define USER_userId @"12345" // [GVUserDefaults standardUserDefaults].userid
#define USER_level @"43" // [GVUserDefaults standardUserDefaults].level

//判空
#define StringNotEmpty(str)                 (str && (str.length > 0))
#define ArrayNotEmpty(arr)                  (arr && (arr.count > 0))

#endif /* Common_Define_h */





