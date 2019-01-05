//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

@interface MBProgressHUD()

@end

@implementation MBProgressHUD (MJ)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    hud.labelText = text;
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // .2秒之后再消失
    [hud hide:YES afterDelay:1.5];
}

+ (void)showSuccess:(NSString *)success{
    [self show:success icon:@"success.png" view:YJWindow];
}

+ (void)showError:(NSString *)error{
    [self show:error icon:@"error.png" view:YJWindow];
}

+ (MBProgressHUD *)showMessage:(NSString *)message{
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:YJWindow animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

+ (MBProgressHUD *)showCustomHUD{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:YJWindow animated:YES];
    hud.color=[UIColor clearColor];
    hud.mode=MBProgressHUDModeCustomView;
    
    UIImageView *imgLoading=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    
    NSMutableArray *arr=[NSMutableArray array];
    for (int i=0; i<12; i++) {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"l%d",i+1]];
        [arr addObject:image];
    }
    imgLoading.animationImages=arr;
    imgLoading.animationDuration=1;
    imgLoading.animationRepeatCount=3000;
    hud.customView=imgLoading;
    [imgLoading stopAnimating];
    [imgLoading startAnimating];
    
    hud.dimBackground=NO;// YES代表需要蒙版效果
    hud.removeFromSuperViewOnHide=YES;
    
    return hud;
}

+ (void)hideHUD{
    [self hideHUDForView:YJWindow animated:YES];
}

+(void)showToast:(NSString *)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:YJWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15.0];
    hud.detailsLabelText = msg;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.0];
}

@end
