//
//  HomePageCell.m
//  TZTV
//
//  Created by Luosa on 2016/12/27.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomePageCell.h"
#import "UIImage+YJ.h"
#import "UIButton+WebCache.h"
#import "YJWebViewController.h"
#import "PLPlayerVC.h"
#import "UIView+YJ.h"

@interface HomePageCell()<OTSCyclePageViewDataSource, OTSCyclePageViewDelegate>

@end

@implementation HomePageCell

- (IBAction)btnClicked:(UIButton *)sender {
    sender.enabled=NO;
    NSString *url=@"";
    if (sender==self.btn1) {
        NSDictionary *dict1=_dataArr[0];
        url=[NSString stringWithFormat:getLiveInfoByUidURL,dict1[@"user_id"]];
    }else if (sender==self.btn2){
        NSDictionary *dict2=_dataArr[1];
        url=[NSString stringWithFormat:getLiveInfoByUidURL,dict2[@"user_id"]];
    }else if (sender==self.btn3){
        NSDictionary *dict3=_dataArr[2];
        url=[NSString stringWithFormat:getLiveInfoByUidURL,dict3[@"user_id"]];
    }else if (sender==self.btn4){
        NSDictionary *dict4=_dataArr[3];
        url=[NSString stringWithFormat:getLiveInfoByUidURL,dict4[@"user_id"]];
    }
    
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        YJLog(@"%@",json);
        sender.enabled=YES;
        if ([json[@"code"] isEqualToNumber:@0]) {
            if ([json[@"data"] isKindOfClass:[NSDictionary class]]) {
                [self exchangeUrl:json[@"data"]];
            }else{
                [MBProgressHUD showToast:@"主播还未开播"];
            }
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        sender.enabled=YES;
        [MBProgressHUD showError:@"网络不太好"];
    }];
}

-(void)exchangeUrl:(NSDictionary *)info{
    NSString *url=[NSString stringWithFormat:getHistoryURL,info[@"live_id"],info[@"live_rtmp_play_url"]];
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        if ([json[@"code"] isEqualToNumber:@0]) {
            PLPlayerVC *vc=[sb instantiateViewControllerWithIdentifier:@"PLPlayerVC"];
            vc.live_id=info[@"live_id"];;
            vc.live_rtmp_play_url=json[@"data"];
            vc.live_user_id=info[@"user_id"];
            [[YJTOOL getRootControllerSelectedVc] pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bannerView.delegate = self;
    self.bannerView.dataSource = self;
    self.bannerView.disableCycle = NO;//可以循环
    self.bannerView.autoRunPage = YES;
    self.bannerView.interval = 3.f;
    self.bannerView.disableClickEffect = YES;
    // 强制刷新界面使布局精准
    [self.bannerView updateConstraintsIfNeeded];//强制更新约束
    [self.bannerView layoutIfNeeded];//强制刷新界面
    
    YJPageControl *pageControl = [[YJPageControl alloc] init];
    pageControl.hidesForSinglePage = YES;
    pageControl.fillColor=YJNaviColor;
    self.bannerView.pageControl = pageControl;
    [self.bannerView addSubview:pageControl];
    [self.bannerView reloadData];
    [self.bannerView runCyclePageView];
    [pageControl autoPinEdgesToSuperviewMarginsExcludingEdge:ALEdgeTop];
    [pageControl autoSetDimension:ALDimensionHeight toSize:20];
}

+(CGFloat)heightForCellData:(id)aData
{
    return 105 + ScreenW * 420 / 750;
}

#pragma mark - OTSCyclePageViewDataSource
- (NSUInteger)numberOfPagesInPageView:(OTSCyclePageView *)aPageView{
    return 5;
}
- (UIView *)pageView:(OTSCyclePageView *)aPageView pageAtIndex:(NSUInteger)aIndex{
//    YJPlaceholderImageView *imageView = [[OTSPlaceholderImageView alloc] initWithFrame:aPageView.bounds];
//    imageView.image=[UIImage imageNamed:[self images][aIndex]];
//    return imageView;
    
    return nil;
}

-(NSArray *)images
{
    return @[@"1",@"5",@"3",@"2",@"4"];
}
#pragma mark - OTSCyclePageViewDelegate
- (void)pageView:(OTSCyclePageView *)aPageView didSelectedPageAtIndex:(NSUInteger)aIndex{
    NSString *url=[NSString stringWithFormat:bannerLinkURL,(int)aIndex+1];
    YJWebViewController *web=[YJWebViewController new];
    web.htmlUrl=url;
    web.title=@"活动";
    [[YJTOOL getRootControllerSelectedVc] pushViewController:web animated:YES];
}

//功能:从当前页 切换另一页时,此方法会被调用
- (void)pageView:(OTSCyclePageView *)pageView didChangeToIndex:(NSUInteger)aIndex{
    
}
//功能:滑动到最后一页继续往后滑动
- (void)pageViewScrollEndOfPage:(OTSCyclePageView *)aPageView{
    
}
//数据暂时全写死
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr=dataArr;
    if (dataArr.count==4) {
        NSDictionary *dict1=dataArr[0];
        NSDictionary *dict2=dataArr[1];
        NSDictionary *dict3=dataArr[2];
        NSDictionary *dict4=dataArr[3];
        [self.btn1 setImage:[[UIImage imageNamed:@"i03"] circleImage] forState:UIControlStateNormal];
        [self.btn2 setImage:[[UIImage imageNamed:@"i04"] circleImage] forState:UIControlStateNormal];
        [self.btn3 setImage:[[UIImage imageNamed:@"i02"] circleImage] forState:UIControlStateNormal];
        [self.btn4 setImage:[[UIImage imageNamed:@"i01"] circleImage] forState:UIControlStateNormal];
        self.label1.text=dict1[@"user_nicname"];
        self.label2.text=dict2[@"user_nicname"];
        self.label3.text=dict3[@"user_nicname"];
        self.label4.text=dict4[@"user_nicname"];
    }
}



@end
