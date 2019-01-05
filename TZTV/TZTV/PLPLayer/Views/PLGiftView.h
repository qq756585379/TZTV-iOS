//
//  PLGiftView.h
//  TZTV
//
//  Created by Luosa on 2017/2/20.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PLGiftView;

@protocol PLGiftViewDelegate <NSObject>
@optional;
- (void)giftView:(PLGiftView *)giftView rechargeBtnDidClicked:(UIButton *)rechargeBtn;
- (void)giftView:(PLGiftView *)giftView sendBtnDidClickedWithFCount:(NSString *)fCount;
@end

@interface PLGiftView : UIView

+(CGFloat)view_height;

@property (nonatomic, strong) NSArray *giftArray;

@property (nonatomic, weak) id<PLGiftViewDelegate> delegate;

@end
