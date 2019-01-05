//
//  OTSRouter.m
//  OneStore
//
//  Created by Luosa on 2017/2/14.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "OTSRouter.h"
#import "NSString+router.h"
#import "NSDictionary+router.h"
#import "NSObject+PerformBlock.h"
#import "UIViewController+create.h"
#import "UIViewController+router.h"
#import "OTSJsonKit.h"

@interface OTSRouter ()
@property (nonatomic, strong) NSMutableDictionary *mapping;
@property (nonatomic, strong) NSMutableDictionary *nativeFuncMapping;
@property (nonatomic, strong) UIViewController *rootVC;
@property (nonatomic, strong) UIViewController *pcContainer;
@property (nonatomic, strong) NSString *appScheme;
@property (nonatomic, strong) NSString *appFuncScheme;
@property (nonatomic, strong) NSArray  *tabArray;
@end

@implementation OTSRouter

+ (instancetype)singletonInstance{
    static OTSRouter *router = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        router = [OTSRouter new];
    });
    return router;
}

- (instancetype)init{
    if (self = [super init]) {
        self.mapping = [NSMutableDictionary dictionary];
        self.nativeFuncMapping = [NSMutableDictionary dictionary];
        self.appScheme = @"txtv";
        self.appFuncScheme = @"tztviosfun";
    }
    return self;
}

#pragma mark - Register
//功能1:注册VC
- (void)registerRouterVO:(OTSMappingVO *)aVO withKey:(NSString *)aKeyName{
    aKeyName = [aKeyName lowercaseString];
    if (self.mapping[aKeyName]) {
        NSLog(@"overwrite router vo key[%@], mapping vo,%@", aKeyName, self.mapping[aKeyName]);
    }
    self.mapping[aKeyName] = aVO;
}
//功能2:注册本地方法
- (void)registerNativeFuncVO:(OTSNativeFuncVO *)aVO withKey:(NSString *)aKeyName{
    aKeyName = [aKeyName lowercaseString];
    if (self.nativeFuncMapping[aKeyName]) {
        NSLog(@"overwrite native func vo key[%@], mapping vo,%@", aKeyName, self.nativeFuncMapping[aKeyName]);
    }
    self.nativeFuncMapping[aKeyName] = aVO;
}
- (void)registerRootVC:(UIViewController *)aRootVC{
    if (self.rootVC) {
        NSLog(@"已经设置了rootvc，不能重复设置");
        return;
    }
    self.rootVC = aRootVC;
}
- (void)registerTabArray:(NSArray *)aTabArray{
    if (self.tabArray) {
        NSLog(@"已经设置了tabarray，不能重复设置");
        return ;
    }
    self.tabArray = aTabArray;
}
- (void)registerPCContainer:(UIViewController *)aPCContainer{
    if (self.pcContainer) {
        NSLog(@"已经设置了pc Container，不能重复设置");
        return ;
    }
    self.pcContainer = aPCContainer;
}

#pragma mark - Router
//功能:按照url执行
- (id)routerWithUrlString:(NSString *)aUrlString{
    return [self routerWithUrlString:aUrlString callbackBlock:nil];
}
//功能:按照url执行,完成之后执行block回调,传入urlencode的字符串
- (id)routerWithUrlString:(NSString *)aUrlString callbackBlock:(OTSNativeFuncVOBlock)aBlock{
    NSLog(@"aUrlString = %@",aUrlString.stringByRemovingPercentEncoding);
    NSURL *url = [NSURL URLWithString:aUrlString];
    if (!url) {
        url = [NSURL URLWithString:[aUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return [self routerWithUrl:url callbackBlock:aBlock];
}
- (id)routerWithUrl:(NSURL *)aUrl{
    return [self routerWithUrl:aUrl callbackBlock:nil];
}
- (id)routerWithUrl:(NSURL *)aUrl callbackBlock:(OTSNativeFuncVOBlock)aBlock{
    if (!aUrl) {
        NSLog(@"router error url");
        return nil;
    }
    NSString *scheme    = aUrl.scheme;
    NSString *host      = [aUrl.host lowercaseString];
    NSString *query     = aUrl.query;   //query是url里?后面的所有内容
    NSMutableDictionary *params = ((NSDictionary *)([NSString getDictFromJsonString:query][OTSRouterParamKey])).mutableCopy;
    params[OTSRouterFromSchemeKey] = scheme;
    params[OTSRouterFromHostKey] = host;
    params[OTSRouterCallbackKey] = aBlock;
    
    NSLog(@"scheme:%@-host:%@-query:%@-params:%@",scheme,host,query,params);
    
    //根据scheme处理
    if ([scheme isEqualToString:self.appScheme]) {
        return [self p_routeVCWithHost:host params:params];//route到host对应的vc
    } else if ([scheme isEqualToString:self.appFuncScheme]) {
        return [self p_routeNativeFuncWithHost:host params:params];
    } else if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        return [self p_routeWebWithUrl:aUrl];
    } else {
        NSLog(@"is not a router url,%@", aUrl.absoluteString.stringByRemovingPercentEncoding);
        return nil;
    }
}

/**
 *  功能:route到host对应的vc
 */
- (id)p_routeVCWithHost:(NSString *)aHost params:(NSDictionary *)aParams{
    OTSMappingVO *mappingVO = [self.mapping objectForCaseInsensitiveKey:aHost];
    if (mappingVO == nil) {
        return nil;
    }
    //quite apollo
    if ([aHost isEqualToString:@"homepage"] && aParams[@"quitapollo"]) {
        return [self routerWithUrlString:[NSString getRouterFunUrlStringFromUrlString:@"quitapollo" andParams:nil]];
    }
    //tab
    self.tabArray=@[@"1",@"2"];
    //如果tabArray有内容的话index就是很大的值 index==9223372036854775807
    NSUInteger index = [self.tabArray indexOfObject:aHost];
    if (index != NSNotFound) {
        if ([aHost isEqualToString:@"cart"] && aParams[@"push"]) {
            return [self p_routeVCWithMappingVO:mappingVO params:aParams];
        } else if(index == 0){
            return [self enterHomepage];
        } else {
            return [self p_switchTabAndPopToRoot:index withParams:aParams];
        }
    }
    return [self p_routeVCWithMappingVO:mappingVO params:aParams];
}

/**
 *  功能:route到OTSMappingVO对应的vc
 */
- (id)p_routeVCWithMappingVO:(OTSMappingVO *)aVO params:(NSDictionary *)aParams{
    //需要登录，则去登录
//    if (aVO.needLogin && ![OTSGlobalValue sharedInstance].token) {
//        [self routerToLogin];
//        return [NSNull null];
//    }
    NSNotification *notice = nil;
    if (![aVO.className isEqualToString:@"PhoneCatchCatPC"]) {
        notice = [NSNotification notificationWithName:@"changeVC" object:nil userInfo:nil];
    }
    UIViewController *vc = [UIViewController createWithMappingVO:aVO extraData:aParams];
    if (!vc) {
        NSLog(@"router error %@, can not new one",aVO);
        return nil;
    }
    if ([vc isKindOfClass:[UINavigationController class]]) {
        NSLog(@"cannot push a nc");
        return nil;
    }
    //Present PC情况处理
//    if ([vc isPc]) {
//        if ([[self.pcContainer.childViewControllers lastObject] isKindOfClass:[vc class]] && !vc.isPresented) {
//            return nil;
//        }else{
//            if (![vc shouldShareScreen]) {
//                [self p_dismissAllPC];
//            }
//            [vc addToRootVC];
//            // hard code：之所以延迟0.1秒，是因为需要上面p_dismissAllPC执行完毕之后再present
//            [self performInMainThreadBlock:^{
//                [vc presentViewControllerAnimated:YES completion:nil];
//            } afterSecond:0.1];
//            if (notice) {
//                [[NSNotificationCenter defaultCenter] postNotification:notice];
//            }
//            return @[vc];
//        }
//    }
    
    //隐藏PC
    [self p_dismissAllPC];
    
    //Push VC
    if ([self.rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbc = (id)self.rootVC;
        UIViewController *selectedVC = tbc.selectedViewController;
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)selectedVC pushViewController:vc animated:YES];
            if (notice) {
                [[NSNotificationCenter defaultCenter] postNotification:notice];
            }
        } else {
            NSLog(@"没有导航怎么push?");
        }
    } else if ([self.rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nc = (id)self.rootVC;
        UINavigationController *routerNC = nc;
        if (nc == vc.navigationController) {
            routerNC = nc;
        }else if (vc.navigationController){
            routerNC = vc.navigationController;
        }else{
            routerNC = nc;
        }
        if ([routerNC isKindOfClass:[UINavigationController class]]) {
            [routerNC pushViewController:vc animated:YES];
            if (notice) {
                [[NSNotificationCenter defaultCenter] postNotification:notice];
            }
        }
    } else {
        NSLog(@"rootvc is not a nc or tc, cannot push");
    }
    return @[vc];
}

- (NSArray *)routerToRoot{
    NSArray *vcs = nil;
    if ([self.rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbc = (id)self.rootVC;
        vcs = [self p_switchTabAndPopToRoot:tbc.selectedIndex withParams:nil];
    } else if ([self.rootVC isKindOfClass:[UINavigationController class]]) {
        //隐藏PC
        [self p_dismissAllPC];
        UINavigationController *nc = (id)self.rootVC;
        vcs = [nc popToRootViewControllerAnimated:YES];
    }
    return vcs;
}

- (NSArray *)routerBack{
    if ([self.rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbc = (id)self.rootVC;
        UIViewController *selectedVC = tbc.selectedViewController;
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            UIViewController *vc = [(UINavigationController *)selectedVC popViewControllerAnimated:YES];
            if (vc) {
                return @[vc];
            }
            return nil;
        } else {
            NSLog(@"没有导航怎么pop?");
        }
    } else if ([self.rootVC isKindOfClass:[UINavigationController class]]) {
        UIViewController *vc = [(UINavigationController *)self.rootVC popViewControllerAnimated:YES];
        if (vc) {
            return @[vc];
        }
        return nil;
    } else {
        NSLog(@"没有导航怎么pop?");
    }
    return nil;
}

- (void)routerToLogin{
    [[OTSRouter singletonInstance] routerWithUrl:[NSURL URLWithString:[NSString getRouterVCUrlStringFromUrlString:@"login" andParams:nil]]];
}

- (id)enterHomepage{
    if ([self.rootVC isKindOfClass:[UITabBarController class]]) {
        //pop到root
        UITabBarController *tbc = (id)self.rootVC;
        if ([tbc.selectedViewController isKindOfClass:[UINavigationController class]]) {
            if (tbc.selectedIndex != 0) {
                UINavigationController *nc = (id)tbc.selectedViewController;
                if (nc.viewControllers.count > 1) {
                    [self performInMainThreadBlock:^{
                        [nc popToRootViewControllerAnimated:NO];
                        [nc.view setNeedsLayout];
                        [nc.topViewController.tabBarController.view setNeedsLayout];
                    } afterSecond:.5f];
                }
            }
        }
    }
    return  [self p_switchTabAndPopToRoot:0 withParams:nil];
}

#pragma mark - Inner
/**
 *  功能:关闭所有pc
 */
- (void)p_dismissAllPC{
//    for (UIViewController *childVC in self.pcContainer.childViewControllers) {
//        if ([childVC isPc]) {
//            [childVC dismissViewControllerAnimated:NO completion:nil];
//            ((OTSPresentController *)childVC).forceDismissed = YES;
//        }
//    }
}

/**
 *  功能:切到指定的tab，并且pop到root
 */
- (NSArray *)p_switchTabAndPopToRoot:(NSUInteger)aTabIndex withParams:(NSDictionary *)params{
    //隐藏PC
    [self p_dismissAllPC];
    NSArray *vcs = nil;
    if ([self.rootVC isKindOfClass:[UITabBarController class]]) {
        //切到指定的tab
        UITabBarController *tbc = (id)self.rootVC;
        if (tbc.selectedIndex != aTabIndex) {
            UIViewController *vc = [tbc.childViewControllers objectAtIndex:aTabIndex];
            if ([vc isKindOfClass:[UINavigationController class]]) { //如果是 NC 传到 rootContrller
                UINavigationController *nc = (UINavigationController *)vc;
                if (nc.childViewControllers.count > 0) {
                    [nc.childViewControllers firstObject].extraData = params;
                }
            } else {
                vc.extraData = params;
            }
            tbc.selectedIndex = aTabIndex;
        }
        
        //pop到root
        if ([tbc.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nc = (id)tbc.selectedViewController;
            if (nc.viewControllers.count > 1) {
                vcs = [nc popToRootViewControllerAnimated:YES];
            }
        }
    } else if ([self.rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nc = (id)self.rootVC;
        NSArray *tabArray = self.tabArray;
        
        NSString *tabStr = tabArray[aTabIndex];
        OTSMappingVO *tabMappingVO = [self.mapping objectForCaseInsensitiveKey:tabStr];
        Class tabClass = NSClassFromString(tabMappingVO.className);
        NSArray *vcArray = nc.viewControllers.copy;
        NSArray *vcClassArray = [vcArray valueForKeyPath:@"@unionOfObjects.class"];
        
        if (nc.topViewController.class == tabClass) {
            vcs = @[];
        } else if ([vcClassArray containsObject:[tabClass class]]) {
            NSInteger index = [vcClassArray indexOfObject:[tabClass class]];
            UIViewController *tabVC = vcArray[index];
            vcs = [nc popToViewController:tabVC animated:YES];
        } else {
            vcs = [self p_routeVCWithMappingVO:tabMappingVO params:params];
        }
    }
    return vcs;
}

/**
 *  功能:执行host对应的函数
 */
- (id)p_routeNativeFuncWithHost:(NSString *)aHost params:(NSDictionary *)aParams{
    if ([aHost isEqualToString:@"back"]) {
        return [self routerBack];
    }
    OTSNativeFuncVO *nativeFuncVO = [self.nativeFuncMapping objectForCaseInsensitiveKey:aHost];
    if (!nativeFuncVO) {
        return nil;
    }
    return [self p_routeNativeFuncWithVO:nativeFuncVO params:aParams];
}

/**
 *  功能:执行OTSNativeFuncVO对应的函数
 */
- (id)p_routeNativeFuncWithVO:(OTSNativeFuncVO *)aVO params:(NSDictionary *)aParams{
//    if (aVO.needLogin && ![OTSGlobalValue sharedInstance].token) {
//        [self routerToLogin];
//        return [NSNull null];
//    }
//    if (aVO.block) {
//        return aVO.block(aParams);
//    }else {
//        return nil;
//    }
    return nil;
}

/**
 *  功能:route到web页面
 */
- (id)p_routeWebWithUrl:(NSURL *)aUrl{
    OTSMappingVO *vo = self.mapping[@"web"];
    NSDictionary *params = @{@"url": aUrl.absoluteString};
    return [self p_routeVCWithMappingVO:vo params:params];
}

/**
 *  根据RouterUrl，返回url的参数
 *  @param aUrl :规则:yhd://localweb?body={"path":"leigou"}
 *  * 此方法只能在iOS7以上的系统使用
 */
- (NSDictionary *)getRouterParamWithURL:(NSURL *)aUrl{
    if (!aUrl) {
        return nil;
    }
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:aUrl resolvingAgainstBaseURL:NO];
    NSArray *queryItems = urlComponents.queryItems;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", OTSRouterParamKey];
    NSURLQueryItem *queryItem = [[queryItems filteredArrayUsingPredicate:predicate] firstObject];
    NSDictionary *resultDict = [OTSJsonKit dictFromString:queryItem.value]?:@{}.mutableCopy;
    return resultDict;
}

- (UIViewController *)topVC{
    if ([self.rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tbc = (id)self.rootVC;
        UIViewController *selectedVC = tbc.selectedViewController;
        if ([selectedVC isKindOfClass:[UINavigationController class]]) {
            return [(UINavigationController *)selectedVC topViewController];
        } else {
            NSLog(@"没有导航怎么pop?");
        }
    } else if ([self.rootVC isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)self.rootVC topViewController];
    }
    return nil;
}



@end
