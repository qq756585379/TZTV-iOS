//
//  OTSNC.m
//  TZTV
//
//  Created by Luosa on 2017/2/16.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "OTSNC.h"
#import "OTSVC.h"

@interface OTSNC ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation OTSNC

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.appearingVC = YES;
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.appearingVC = NO;
}
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactivePopTransition;
}
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController{
    return nil;
}

@end
    
    
