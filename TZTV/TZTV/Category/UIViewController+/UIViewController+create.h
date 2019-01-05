//
//  UIViewController+create.h
//  OneStoreFramework
//
//  Created by Aimy on 14-7-30.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (create)

#pragma mark - create
/**
 *  从xib创建vc
 */
+ (instancetype)createFromXib;
/**
 *  从xib创建vc
 *
 *  @param aBundleName res bundle name，NibName = self.class
 *
 *  @return OTSVC
 */
+ (instancetype)createFromXibWithBundleName:(NSString *)aBundleName NS_DEPRECATED_IOS(6_0,7_0,"Pad的资源已经合并到Application Target中，不需要从bundle中取出来，请使用不带bundle的方法");
/**
 *  从xib创建vc
 */
+ (instancetype)createFromXibWithNibName:(NSString *)aNibName;
/**
 *  从xib创建vc
 */
+ (instancetype)createFromXibWithNibName:(NSString *)aNibName bundleName:(NSString *)aBundleName NS_DEPRECATED_IOS(6_0,7_0,"Pad的资源已经合并到Application Target中，不需要从bundle中取出来，请使用不带bundle的方法");
/**
 *  从storyboard创建vc
 */
+ (instancetype)createFromStoryboard;
/**
 *  从storyboard创建vc
 */
+ (instancetype)createFromStoryboardWithStoryboardName:(NSString *)aStoryboardName;
/**
 *  @return OTSVC
 */
+ (instancetype)createFromStoryboardWithStoryboardID:(NSString *)aStoryboardID storyboardName:(NSString *)aStoryboardName;
/**
 *  从storyboard创建vc
 */
+ (instancetype)createFromStoryboardWithStoryboardName:(NSString *)aStoryboardName bundleName:(NSString *)aBundleName NS_DEPRECATED_IOS(6_0,7_0,"Pad的资源已经合并到Application Target中，不需要从bundle中取出来，请使用不带bundle的方法");
/**
 *  @param aBundleName res bundle name，storyboardID = self.class
 *
 *  @return OTSVC
 */
+ (instancetype)createFromStoryboardWithStoryboardID:(NSString *)aStoryboardID storyboardName:(NSString *)aStoryboardName bundleName:(NSString *)aBundleName NS_DEPRECATED_IOS(6_0,7_0,"Pad的资源已经合并到Application Target中，不需要从bundle中取出来，请使用不带bundle的方法");
@end
