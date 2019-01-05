//
//  OTSConstraintHelper.m
//  OneStoreFramework
//
//  Created by Aimy on 14-7-1.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import "OTSConstraintHelper.h"

@implementation OTSConstraintHelper

+ (void)setView:(UIView *)aView fullAsSuperview:(UIView *)aSuperview;{
    [self setView:aView fullAsSuperview:aSuperview andEdgeInsets:UIEdgeInsetsZero];
}
+ (void)setView:(UIView *)aView fullAsSuperview:(UIView *)aSuperview andEdgeInsets:(UIEdgeInsets)aInsets{
    [self setView:aView fullAsSuperview:aSuperview andEdgeInsets:aInsets propert:UILayoutPriorityRequired];
}
+ (void)setView:(UIView *)aView fullAsSuperview:(UIView *)aSuperview andEdgeInsets:(UIEdgeInsets)aInsets propert:(CGFloat)property{
    [self setView:aView fullAsSuperview:aSuperview andEdgeInsets:aInsets propertys:UIEdgeInsetsMake(property, property, property, property)];
}

+ (void)setView:(UIView *)aView fullAsSuperview:(UIView *)aSuperview andEdgeInsets:(UIEdgeInsets)aInsets propertys:(UIEdgeInsets)propertys{
    aView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSMutableDictionary *metrics = @{}.mutableCopy;
    metrics[@"hLeftEdge"] = @(aInsets.left);
    metrics[@"hRightEdge"] = @(aInsets.right);
    metrics[@"vTopEdge"] = @(aInsets.top);
    metrics[@"vBottomEdge"] = @(aInsets.bottom);
    
    metrics[@"hLeftProperty"] = @(propertys.left);
    metrics[@"hRightProperty"] = @(propertys.right);
    metrics[@"vTopProperty"] = @(propertys.top);
    metrics[@"vBottomProperty"] = @(propertys.bottom);
    
    [aSuperview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(hLeftEdge@hLeftProperty)-[aView]-(hRightEdge@hRightProperty)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(aView)]];
    [aSuperview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(vTopEdge@vTopProperty)-[aView]-(vBottomEdge@vBottomProperty)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(aView)]];
}

+ (void)setViews:(NSArray *)aViews equalToSuperview:(UIView *)aSuperview isHorizontal:(BOOL)isHorizontal{
    __block UIView *item = nil, *toItem = nil;
    [aViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            item = aViews[0];
            toItem = aSuperview;
        }else {
            item = aViews[idx];
            toItem = aViews[idx - 1];
        }
        item.translatesAutoresizingMaskIntoConstraints = NO;
        if (idx == 0) {
            if (isHorizontal) {
                [aSuperview addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeLeading multiplier:1.f constant:0.f]];
            }else {
                [aSuperview addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeTop multiplier:1.f constant:0.f]];
            }
        }else {
            if (isHorizontal) {
                [aSuperview addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0.f]];
            }else {
                [aSuperview addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeBottom multiplier:1.f constant:0.f]];
            }
        }
        if (isHorizontal) {
            [aSuperview addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:aSuperview attribute:NSLayoutAttributeWidth multiplier:1.f / aViews.count constant:0.f]];
        }else {
            [aSuperview addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:aSuperview attribute:NSLayoutAttributeHeight multiplier:1.f / aViews.count constant:0.f]];
        }
    }];
}

+ (void)testAmbiguity:(UIView *)aView{
#ifdef DEBUG
    if (aView.hasAmbiguousLayout) {
        YJLog(@"<%@> <%@:0x%0X>: Ambiguous",aView.superview.class, aView.class, (int)aView);
    }
    for (UIView *subView in aView.subviews) {
        [self testAmbiguity:subView];
    }
#endif
}

@end
