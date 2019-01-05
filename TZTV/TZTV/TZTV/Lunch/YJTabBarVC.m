//
//  YJTabBarVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "YJTabBarVC.h"
#import "YJNav.h"
#import "HomeVC.h"
#import "BrandVC.h"
#import "MeViewController.h"

@interface YJTabBarVC ()

@end

@implementation YJTabBarVC

+ (void)initialize{
    UITabBar *bar=[UITabBar appearance];
    bar.barTintColor=[UIColor whiteColor];
    bar.tintColor=HEXRGBCOLOR(0x333333);
    
    //[bar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
//    attrs[NSForegroundColorAttributeName] = HEXRGBCOLOR(0x333333);
//    
//    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
//    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
//    selectedAttrs[NSForegroundColorAttributeName] = YJNaviColor;
//    
//    UITabBarItem *item = [UITabBarItem appearance];
//    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
//    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeVC *home=[HomeVC new];
    BrandVC *brand=[BrandVC new];
    UIViewController *vc3=[UIViewController new];
    UIViewController *vc4=[UIViewController new];
    MeViewController *me=[sb instantiateViewControllerWithIdentifier:@"MeViewController"];
    
    YJNav *nav1=[[YJNav alloc] initWithRootViewController:home];
    YJNav *nav2=[[YJNav alloc] initWithRootViewController:brand];
    YJNav *nav3=[[YJNav alloc] initWithRootViewController:vc3];
    YJNav *nav4=[[YJNav alloc] initWithRootViewController:vc4];
    YJNav *nav5=[[YJNav alloc] initWithRootViewController:me];
    
    [nav1 updateNavBarBg:[UIImage imageWithColor:YJNaviColor] andShadowImage:[UIImage imageWithColor:YJNaviColor]];
    [nav2 updateNavBarBg:[UIImage imageWithColor:[UIColor whiteColor]] andShadowImage:[UIImage imageWithColor:YJGlobalBg]];
    
    [nav5 updateNavBarBg:[UIImage imageWithColor:[UIColor whiteColor]] andShadowImage:[UIImage imageWithColor:YJGlobalBg]];
    
    [self setupChildVc:nav1 title:@"直播" image:@"live" selectedImage:@"liveselected"];
    [self setupChildVc:nav2 title:@"品牌" image:@"brand" selectedImage:@"brand_selected"];
    [self setupChildVc:nav3 title:@"发现" image:@"Find" selectedImage:@"findselect"];
    [self setupChildVc:nav4 title:@"购物车" image:@"shoppingcart" selectedImage:@"shoppingcardselected"];
    [self setupChildVc:nav5 title:@"我的" image:@"my" selectedImage:@"my_selected"];
}

- (void)setupChildVc:(YJNav *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    vc.title=title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:vc];
}

@end
