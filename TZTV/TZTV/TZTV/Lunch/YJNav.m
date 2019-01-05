//
//  YJNav.m
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "YJNav.h"
#import "UIImage+YJ.h"
#import "UIBarButtonItem+Create.h"

@interface YJNav ()

@end

@implementation YJNav

+ (void)initialize{
    //[UINavigationBar appearance].barTintColor=HEXRGBCOLOR(0xfede0a);
    
    [UINavigationBar appearance].tintColor=HEXRGBCOLOR(0x333333);
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]}];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = HEXRGBCOLOR(0x333333);
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = HEXRGBCOLOR(0x333333);
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
}

-(void)updateNavBarBg:(UIImage *)bgImg andShadowImage:(UIImage *)shadowImg{
    [self.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:shadowImg];//去掉黑线，需要设置导航栏图片而不是barTintColor
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"return" highImage:@"return" target:self action:@selector(back)];
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}

@end
