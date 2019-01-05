//
//  UIViewController+create.m
//  OneStoreFramework
//
//  Created by Aimy on 14-7-30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "UIViewController+create.h"

@implementation UIViewController (create)

+ (instancetype)createFromXib
{
    return [self createFromXibWithNibName:NSStringFromClass(self)];
}

+ (instancetype)createFromXibWithNibName:(NSString *)aNibName
{
    return [self createFromXibWithNibName:aNibName bundleName:nil];
}

+ (instancetype)createFromXibWithBundleName:(NSString *)aBundleName
{
    return [self createFromXibWithNibName:NSStringFromClass(self) bundleName:aBundleName];
}

+ (instancetype)createFromXibWithNibName:(NSString *)aNibName bundleName:(NSString *)aBundleName
{
    NSBundle *bundle = [self getBundleWithBundleName:aBundleName];
    return [[self alloc] initWithNibName:aNibName bundle:bundle];
}

//storyboard
+ (instancetype)createFromStoryboard
{
    return [self createFromStoryboardWithStoryboardName:NSStringFromClass(self)];
}

+ (instancetype)createFromStoryboardWithStoryboardName:(NSString *)aStoryboardName
{
    return [self createFromStoryboardWithStoryboardID:NSStringFromClass(self) storyboardName:aStoryboardName];
}

+ (instancetype)createFromStoryboardWithStoryboardID:(NSString *)aStoryboardID storyboardName:(NSString *)aStoryboardName
{
    return [self createFromStoryboardWithStoryboardID:aStoryboardID storyboardName:aStoryboardName bundleName:nil];
}

+ (instancetype)createFromStoryboardWithStoryboardName:(NSString *)aStoryboardName bundleName:(NSString *)aBundleName
{
    return [self createFromStoryboardWithStoryboardID:NSStringFromClass(self) storyboardName:aStoryboardName bundleName:aBundleName];
}

+ (instancetype)createFromStoryboardWithStoryboardID:(NSString *)aStoryboardID storyboardName:(NSString *)aStoryboardName bundleName:(NSString *)aBundleName
{
    NSBundle *bundle = [self getBundleWithBundleName:aBundleName];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:aStoryboardName bundle:bundle];
    return [storyboard instantiateViewControllerWithIdentifier:aStoryboardID];
}

+ (NSBundle *)getBundleWithBundleName:(NSString *)aBundleName
{
    NSBundle *bundle = [NSBundle mainBundle];
    if (aBundleName.length) {
        bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:aBundleName withExtension:@"bundle"]];
    }
    
    return bundle;
}

@end
