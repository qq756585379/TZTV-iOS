//
//  UIViewController+router.m
//  OneStoreBase
//
//  Created by huangjiming on 11/9/15.
//  Copyright © 2015 OneStoreBase. All rights reserved.
//

#import "UIViewController+router.h"
//router
#import "OTSMappingVO.h"
#import "OTSRouter.h"
//category
#import "UIViewController+create.h"
#import "NSObject+category.h"

@implementation UIViewController (router)

#pragma mark - Property
- (void)setExtraData:(NSDictionary *)extraData{
    [self objc_setAssociatedObject:@"extraData" value:extraData policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}
- (NSDictionary *)extraData{
    return [self objc_getAssociatedObject:@"extraData"];
}

#pragma mark - 通过OTSMappingVO创建VC
+ (instancetype)createWithMappingVOKey:(NSString *)aKey extraData:(NSDictionary *)aParam{
    return [self createWithMappingVO:[OTSRouter singletonInstance].mapping[aKey] extraData:aParam];
}
+ (instancetype)createWithMappingVO:(OTSMappingVO *)aMappingVO extraData:(NSDictionary *)aParam{
    if (aMappingVO.className == nil) {
        NSLog(@"OTSMappingVO error %@, className is nil",aMappingVO.description);
        return nil;
    }
    Class class = NSClassFromString(aMappingVO.className);
    if (!class) {
        NSLog(@"OTSMappingVO error %@, no such class",aMappingVO);
        return nil;
    }
    UIViewController *vc = nil;
    if (aMappingVO.createdType == OTSMappingClassCreateByCode) {
        vc = [[class alloc] initWithNibName:nil bundle:nil];
    }else if (aMappingVO.createdType == OTSMappingClassCreateByXib) {
        NSBundle *bundle = [self getBundleWithBundleName:aMappingVO.bundleName];
        vc = [[class alloc] initWithNibName:aMappingVO.nibName bundle:bundle];
    }else if (aMappingVO.createdType == OTSMappingClassCreateByStoryboard) {
        NSBundle *bundle = [self getBundleWithBundleName:aMappingVO.bundleName];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:aMappingVO.storyboardName bundle:bundle];
        vc = [storyboard instantiateViewControllerWithIdentifier:aMappingVO.storyboardID];
    }
    aParam = aParam ?: @{};
    vc.extraData = aParam;
    return vc;
}

+ (NSBundle *)getBundleWithBundleName:(NSString *)aBundleName{
    NSBundle *bundle = [NSBundle mainBundle];
    if (aBundleName.length) {
        bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:aBundleName withExtension:@"bundle"]];
    }
    return bundle;
}

@end





