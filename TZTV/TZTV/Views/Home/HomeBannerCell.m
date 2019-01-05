//
//  HomeBannerCell.m
//  TZTV
//
//  Created by Luosa on 2016/11/18.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomeBannerCell.h"
#import "YJWebViewController.h"

@implementation HomeBannerCell

+(CGFloat)heightForCellData:(id)aData
{
    return ScreenW*260/750;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        OTSCyclePageView *dynamicLaunchView = [[OTSCyclePageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW*260/750)];
        dynamicLaunchView.backgroundColor = [UIColor whiteColor];
        dynamicLaunchView.delegate = self;
        dynamicLaunchView.dataSource = self;
        dynamicLaunchView.disableCycle = NO;//禁止循环
        dynamicLaunchView.autoRunPage = YES;
        dynamicLaunchView.interval = 3.f;
        dynamicLaunchView.disableClickEffect = YES;
        
        YJPageControl *pageControl = [[YJPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dynamicLaunchView.frame)-20,CGRectGetWidth(dynamicLaunchView.frame), 20)];
        pageControl.hidesForSinglePage = YES;
        dynamicLaunchView.pageControl = pageControl;
        [dynamicLaunchView addSubview:pageControl];
    
        [dynamicLaunchView reloadData];
        [self.contentView addSubview:dynamicLaunchView];
    }
    return self;
}

#pragma mark - OTSCyclePageViewDataSource
- (NSUInteger)numberOfPagesInPageView:(OTSCyclePageView *)aPageView{
    return 6;
}

- (UIView *)pageView:(OTSCyclePageView *)aPageView pageAtIndex:(NSUInteger)aIndex{
//    OTSPlaceholderImageView *imageView = [[OTSPlaceholderImageView alloc] initWithFrame:aPageView.bounds];
//    imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d",(int)aIndex]];
//    return imageView;
    
    return nil;
}

#pragma mark - OTSCyclePageViewDelegate
- (void)pageView:(OTSCyclePageView *)aPageView didSelectedPageAtIndex:(NSUInteger)aIndex{
    NSString *url=[NSString stringWithFormat:bannerLinkURL,(int)aIndex+1];
    YJWebViewController *web=[YJWebViewController new];
    web.htmlUrl=url;
    web.title=@"活动";
    [[YJTOOL getRootControllerSelectedVc] pushViewController:web animated:YES];
}

@end





