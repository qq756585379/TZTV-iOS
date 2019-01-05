//
//  PhoneTBC.m
//  OneStore
//
//  Created by Aimy on 14-6-25.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "PhoneTBC.h"
#import "OTSOperationManager.h"
#import "PhoneTabBarItem.h"
#import "HomeVC.h"
#import "BrandVC.h"
#import "MeViewController.h"
#import "ShopCartVC.h"
#import "HomePageTableVC.h"
#import "YJWebViewController.h"
#import "ZhiBoListTableVC.h"
#import "OTSNC.h"
#import "YJNav.h"

@interface PhoneTBC () <UITabBarControllerDelegate>
@property (nonatomic, strong) YJTabBar *customTabBar;
@property (nonatomic, assign) NSUInteger lastSelectedIndex;
@property (nonatomic, strong) OTSOperationManager *operationManager;
@end

@implementation PhoneTBC

+ (void)initialize
{
    [UITabBar appearance].barTintColor=[UIColor whiteColor];
    [UITabBar appearance].tintColor=HEXRGBCOLOR(0x333333);
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    attrs[NSForegroundColorAttributeName] = HEXRGBCOLOR(0x333333);
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = YJNaviColor;
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config0_1];
}

-(void)config0_1
{
    HomePageTableVC *homePage=[[HomePageTableVC alloc] init];
    ZhiBoListTableVC *zhiboVc=[[ZhiBoListTableVC alloc] init];
    MeViewController *meVc=[sb instantiateViewControllerWithIdentifier:@"MeViewController"];
    YJNav *nav1=[[YJNav alloc] initWithRootViewController:homePage];
    YJNav *nav2=[[YJNav alloc] initWithRootViewController:zhiboVc];
    YJNav *nav3=[[YJNav alloc] initWithRootViewController:meVc];
    [nav1 updateNavBarBg:[UIImage imageWithColor:kWhiteColor] andShadowImage:[UIImage imageWithColor:kEDEDED]];
    [nav2 updateNavBarBg:[UIImage imageWithColor:kWhiteColor] andShadowImage:[UIImage imageWithColor:kEDEDED]];
    [nav3 updateNavBarBg:[UIImage imageWithColor:kWhiteColor] andShadowImage:[UIImage imageWithColor:kEDEDED]];
    [self setupChildVc:nav1 title:@"首页" image:@"home" selectedImage:@"home_click"];
    [self setupChildVc:nav2 title:@"兔子秀" image:@"live" selectedImage:@"liveselected"];
    [self setupChildVc:nav3 title:@"我的" image:@"my" selectedImage:@"my_selected"];
}

-(void)config0_2{
//    HomeTableVC2 *home=[[HomeTableVC2 alloc] initWithStyle:1];
//    FenLeiTableVC *fenleiVc=[[FenLeiTableVC alloc] initWithStyle:UITableViewStylePlain];
//    ZhiBoListTableVC *zhiboVc=[[ZhiBoListTableVC alloc] initWithStyle:UITableViewStyleGrouped];
//    ShopCartVC *shopCartVc=[sb instantiateViewControllerWithIdentifier:@"ShopCartVC"];
//    MeViewController *meVc=[sb instantiateViewControllerWithIdentifier:@"MeViewController"];
//
//    YJNav *nav1=[[YJNav alloc] initWithRootViewController:home];
//    YJNav *nav2=[[YJNav alloc] initWithRootViewController:fenleiVc];
//    YJNav *nav3=[[YJNav alloc] initWithRootViewController:zhiboVc];
//    YJNav *nav4=[[YJNav alloc] initWithRootViewController:shopCartVc];
//    YJNav *nav5=[[YJNav alloc] initWithRootViewController:meVc];
//
//    [nav1 updateNavBarBg:[UIImage imageWithColor:kWhiteColor] andShadowImage:[UIImage imageWithColor:kEDEDED]];
//    [nav2 updateNavBarBg:[UIImage imageWithColor:kWhiteColor] andShadowImage:[UIImage imageWithColor:kEDEDED]];
//    [nav3 updateNavBarBg:[UIImage imageWithColor:kWhiteColor] andShadowImage:[UIImage imageWithColor:kEDEDED]];
//    [nav4 updateNavBarBg:[UIImage imageWithColor:kWhiteColor] andShadowImage:[UIImage imageWithColor:kEDEDED]];
//    [nav5 updateNavBarBg:[UIImage imageWithColor:kWhiteColor] andShadowImage:[UIImage imageWithColor:kEDEDED]];
//
//    [self setupChildVc:nav1 title:@"首页" image:@"home" selectedImage:@"home_click"];
//    [self setupChildVc:nav2 title:@"品牌" image:@"brand" selectedImage:@"brand_selected"];
//    [self setupChildVc:nav3 title:@"直播" image:@"live" selectedImage:@"liveselected"];
//    [self setupChildVc:nav4 title:@"购物车" image:@"shopping" selectedImage:@"shopping_card_selected"];
//    [self setupChildVc:nav5 title:@"我的" image:@"my" selectedImage:@"my_selected"];
}

- (void)setupChildVc:(YJNav *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    vc.title=title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:vc];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    //    if ([item.title isEqualToString:@"发现"]) {
    //        if (self.web.htmlUrl.length==0) {
    //            self.web.htmlUrl=findURL;
    //            [self.web loadUrl:findURL];
    //        }
    //    }
}

- (void)_PhoneTBC_setup
{
    [[YJRouter sharedInstance] registerRootVC:self];
    [[YJRouter sharedInstance] registerTabArray:@[@"home", @"category", @"", @"cart", @"mystore"]];
}

- (void)_PhoneTBC_setupVCs
{
    HomeVC *home    =[HomeVC new];
    BrandVC *brand  =[BrandVC new];
    YJWebViewController *webVc=[YJWebViewController new];
    ShopCartVC *shopCartVc=[sb instantiateViewControllerWithIdentifier:@"ShopCartVC"];
    MeViewController *meVc=[sb instantiateViewControllerWithIdentifier:@"MeViewController"];
    
    OTSNC *nav1=[[OTSNC alloc] initWithRootViewController:home];
    OTSNC *nav2=[[OTSNC alloc] initWithRootViewController:brand];
    OTSNC *nav3=[[OTSNC alloc] initWithRootViewController:webVc];
    OTSNC *nav4=[[OTSNC alloc] initWithRootViewController:shopCartVc];
    OTSNC *nav5=[[OTSNC alloc] initWithRootViewController:meVc];
    
    [self setViewControllers:@[nav1, nav2, nav3, nav4, nav5] animated:NO];
}

#pragma mark - TBCDelegate
- (void)customTabBar:(YJTabBar *)tabBar didSelectItem:(YJTabBarItem *)item
{
    PhoneTabBarItem *tempItem = (PhoneTabBarItem *)item;
    if (tempItem.vo.type.integerValue > 0 && tempItem.vo.redPoint.boolValue) {
        NSDate *nowDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults]setObject:@((nowDate.timeIntervalSince1970) * 1000) forKey:[NSString stringWithFormat:@"PhoneTabBarItemLastUpdateTime%@",tempItem.vo.type]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)enterLastTab
{
    [self customTabBar:self.customTabBar didSelectItem:self.customTabBar.items[self.lastSelectedIndex]];
    //当切换tab的时候，如果tabbar的显示状态不一样，那么tbc的显示会有问题，所以要强制刷新一下
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self customTabBar:self.customTabBar didSelectItem:self.customTabBar.items[selectedIndex]];
    //当切换tab的时候，如果tabbar的显示状态不一样，那么tbc的显示会有问题，所以要强制刷新一下
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
}

@end




