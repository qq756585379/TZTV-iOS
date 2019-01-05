//
//  LYLiveGiftView.h
//  TZTV
//
//  Created by Luosa on 2016/12/19.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYLiveGiftView;

@protocol LYLiveGiftViewDelegate <NSObject>
@optional;
- (void)giftView:(LYLiveGiftView *)giftView rechargeBtnDidClicked:(UIButton *)rechargeBtn;
- (void)giftView:(LYLiveGiftView *)giftView sendBtnDidClickedWithFCount:(NSString *)fCount;
@end

@interface LYLiveGiftView : UIView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *remainCoinLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, weak) id<LYLiveGiftViewDelegate> delegate;

@end
