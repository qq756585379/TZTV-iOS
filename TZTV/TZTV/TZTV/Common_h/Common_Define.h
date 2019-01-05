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
#define YJGlobalBg                HEXRGBCOLOR(0xededed)
#define YJNaviColor               HEXRGBCOLOR(0xfede0a)

#define ScreenW                   [UIScreen mainScreen].bounds.size.width
#define ScreenH                   [UIScreen mainScreen].bounds.size.height

#define sb                        [UIStoryboard storyboardWithName:@"Main" bundle:nil]
/**快速创建弱指针*/
#define WEAK_SELF    __weak typeof(self) weakSelf = self;
#define STRONG_SELF  __strong typeof(weakSelf) self = weakSelf;
/**打印*/
#ifdef DEBUG
#define YJLog(...) NSLog(__VA_ARGS__)
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

#define YJAppDelegate       ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define YJWindow            ((UIWindow *)[[UIApplication sharedApplication] keyWindow])

#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#endif /* Common_Define_h */
