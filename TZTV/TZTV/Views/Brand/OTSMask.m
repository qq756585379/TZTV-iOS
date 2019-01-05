//
//  OTSMask.m
//  OneStoreFramework
//
//  Created by Aimy on 9/25/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "OTSMask.h"
#import "AppDelegate.h"

@interface OTSMask () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestuer;
@property (nonatomic, strong) UIGestureRecognizer      *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer   *tapGesture;
@property (nonatomic, strong) UIView *foregroundView;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, weak) UIWindow *window;

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGFloat startX;

@property (nonatomic) CGFloat edge;
@property (nonatomic) CGFloat gesEdge;

@property (nonatomic) BOOL mask;

@end

@implementation OTSMask

+ (instancetype)maskWithForegroundView:(UIView *)aForegroundView backgroundView:(UIView *)aBackgroundView edge:(CGFloat)aEdge gesEdge:(CGFloat)aGesEdge{
    OTSMask *mask = [self new];
    mask.foregroundView = aForegroundView;
    mask.backgroundView = aBackgroundView;
    mask.gesEdge = aGesEdge;
    mask.edge = aEdge;
    [mask.foregroundView addGestureRecognizer:mask.panGesture];
    return mask;
}

- (instancetype)init{
    if (self = [super init]) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self                                                                             action:@selector(paningGestureReceive:)];
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureReceive:)];
        self.swipeGestuer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(endMask)];
        self.swipeGestuer.direction = UISwipeGestureRecognizerDirectionRight;
        self.panGesture.delegate = self;
    
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        self.window = delegate.window;
    }
    return self;
}

- (void)createDoGesViewWithViewWidth:(NSInteger)width{
    //创建阴影背景
    self.doGesView = [[UIView alloc ] initWithFrame:CGRectMake(0,0,width,self.window.bounds.size.height)];
    self.doGesView.alpha = 0.0f;
    self.doGesView.backgroundColor = [UIColor blackColor];
    [self.doGesView addGestureRecognizer:self.panGesture];
    [self.doGesView addGestureRecognizer:self.tapGesture];
    [self.doGesView addGestureRecognizer:self.swipeGestuer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    CGPoint velocity = [gestureRecognizer velocityInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    CGPoint touchPoint = [gestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    
    if ([self.delegate respondsToSelector:@selector(shouldShowMask)]) {
        if (![self.delegate shouldShowMask]) {
            return NO;
        }
    }
    
    if (self.mask) {
        return (velocity.x > velocity.y) && (self.window.bounds.size.width - touchPoint.x < self.gesEdge);
    }else {
        return (velocity.y > velocity.x) && (self.window.bounds.size.width - touchPoint.x < self.gesEdge);
    }
}

- (void)tapGestureReceive:(UITapGestureRecognizer *)gestureRecognizer{
    [self endMask];
}

- (void)paningGestureReceive:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint touchPoint = [gestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow];

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        touchPoint = [gestureRecognizer locationInView:[UIApplication sharedApplication].keyWindow];
        self.startX = self.window.rootViewController.view.left;
        self.startPoint = touchPoint;
        self.backgroundView.frame = CGRectMake(self.edge, 0, self.window.bounds.size.width - self.edge, self.window.bounds.size.height);
        [self.window insertSubview:self.backgroundView belowSubview:self.window.rootViewController.view];
    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if (self.window.rootViewController.view.left * 2 + self.window.bounds.size.width <= 0) {
            [self beginMask];
        }else {
            [self endMask];
        }
    }else {
        CGFloat moveX = touchPoint.x - self.startPoint.x;
        if(moveX>=0){
            self.doGesView.width = self.edge+moveX;
        }else{
            self.doGesView.width = self.edge;
        }
        self.window.rootViewController.view.left = self.startX + moveX;
        
        if (self.window.rootViewController.view.left > 0) {
            self.window.rootViewController.view.left = 0;
        }
        if (self.window.bounds.size.width + self.window.rootViewController.view.left <= self.edge) {
            self.window.rootViewController.view.left = self.edge - self.window.bounds.size.width;
        }
    }
}

- (void)beginMask{
    self.backgroundView.frame = CGRectMake(self.edge, 0, self.window.bounds.size.width - self.edge, self.window.bounds.size.height);
    [self.window addSubview:self.doGesView];
    [self.window insertSubview:self.backgroundView belowSubview:self.window.rootViewController.view];
    [UIView animateWithDuration:0.5f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.window.rootViewController.view.left = self.edge - self.window.bounds.size.width;
        self.doGesView.alpha = 0.5f;
        self.doGesView.width = self.edge;
    } completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(didShowMask)]) {
            [self.delegate didShowMask];
        }
        
    }];
    self.mask = YES;
}

- (void)endMask{
    if(IOS_SDK_LESS_THAN(9.1)){
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    }
    [UIView animateWithDuration:.3f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.window.rootViewController.view.left = 0;
        self.doGesView.alpha = 0.0f;
        self.doGesView.width = self.edge;
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self.doGesView removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(didHideMask)]) {
            [self.delegate didHideMask];
        }
    }];
    self.mask = NO;
}

- (void)cancelMask{
    [UIView animateWithDuration:.3f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.window.rootViewController.view.left = 0;
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [self.doGesView removeFromSuperview];
        [self.foregroundView removeGestureRecognizer:self.panGesture];
        if ([self.delegate respondsToSelector:@selector(didHideMask)]) {
            [self.delegate didHideMask];
        }
    }];
    self.mask = NO;
}

@end
