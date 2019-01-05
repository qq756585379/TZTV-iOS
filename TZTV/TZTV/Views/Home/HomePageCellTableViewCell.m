//
//  HomePageCellTableViewCell.m
//  TZTV
//
//  Created by Luosa on 2016/11/10.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomePageCellTableViewCell.h"
#import "HomeScrollItem.h"
#import "LiveListModel.h"
#import "PLPlayerVC.h"
#import "UIImageView+YJ.h"
#import "ZipViewModel.h"
#import "ChatModel.h"
#import "BrandDetailVC1.h"
#import "KRVideoPlayerController.h"

@interface HomePageCellTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel     *label1;
@property (weak, nonatomic) IBOutlet UILabel     *squreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) KRVideoPlayerController *videoController;
@end

@implementation HomePageCellTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.scrollCollectionView.showsVerticalScrollIndicator=NO;
    self.scrollCollectionView.showsHorizontalScrollIndicator=NO;
    [self.scrollCollectionView registerNib:[HomeScrollItem nib] forCellWithReuseIdentifier:[HomeScrollItem cellReuseIdentifier]];
}

+(CGFloat)heightForCellData:(id)aData
{
    HomeModel2 *model=(HomeModel2 *)aData;
    return model.goodsList.count?(128 + 60 + ScreenW * 420/750):(60 + ScreenW * 420/750);
}

#pragma mark - 播放
- (IBAction)playClicked:(UIButton *)sender {//type=1不需要调getHistoryURL，2需要调getHistoryURL
    sender.enabled=NO;
    //type=1需要调getHistoryURL，2不需要调getHistoryURL
    if ([_homeModel2.live_type intValue]==1) {
        NSString *url=[NSString stringWithFormat:getHistoryURL,_homeModel2.live_id,_homeModel2.live_rtmp_play_url];
        YJLog(@"getHistoryURL===%@",url);
        [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
            sender.enabled=YES;
            YJLog(@"getHistoryURL===%@",json);
            if ([json[@"code"] isEqualToNumber:@0]) {
                PLPlayerVC *vc=[sb instantiateViewControllerWithIdentifier:@"PLPlayerVC"];
                vc.live_id=self.homeModel2.live_id;
                vc.live_user_id=_homeModel2.user_id;
                vc.live_rtmp_play_url=json[@"data"];
                [[YJTOOL getRootControllerSelectedVc] pushViewController:vc animated:YES];
            }
        } failure:^(NSError *error) {
            sender.enabled=YES;
        }];
    }else if ([_homeModel2.live_type intValue]==2){//直接使用播放器
        sender.enabled=YES;
        NSURL *playerUrl = [NSURL URLWithString:_homeModel2.live_rtmp_play_url];
        [self playVideoWithURL:playerUrl];
//        if (self.block) {
//            self.block(_homeModel2);
//        }
    }
}

- (void)playVideoWithURL:(NSURL *)url{
    if (!self.videoController) {
        self.videoController = [[KRVideoPlayerController alloc] init];
        WEAK_SELF
        [self.videoController setDimissCompleteBlock:^{
            [weakSelf.videoController dismiss];
            weakSelf.videoController=nil;
        }];
        [self.bigImageView addSubview:self.videoController.view];
        [self.videoController.view autoPinEdgesToSuperviewEdges];
    }
    self.videoController.contentURL = url;
}

-(void)setHomeModel2:(HomeModel2 *)homeModel2{
    _homeModel2=homeModel2;
    _locationLabel.text=homeModel2.live_market_name;
    _label1.text=homeModel2.live_title;
    _squreLabel.text=[NSString stringWithFormat:@"播放%@次",homeModel2.play_num];//换成播放次数
    _timeLabel.text=homeModel2.create_time;
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:homeModel2.live_snapshot_play_url] placeholderImage:[UIImage imageNamed:@"Loading_pictures"]];
    [_iconIV setCircleImage:homeModel2.user_image andPlaceHolderImg:@"225_243"];
    self.scrollCollectionView.hidden=(homeModel2.goodsList.count==0);
    [self.scrollCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.homeModel2.goodsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeScrollItem *item=(HomeScrollItem *)[collectionView dequeueReusableCellWithReuseIdentifier:[HomeScrollItem cellReuseIdentifier] forIndexPath:indexPath];
//    item.goodModel=[self.homeModel2.goodsList safeObjectAtIndex:indexPath.row];
    return item;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandDetailVC1 *vc=[BrandDetailVC1 new];
    BrandDetailModel *detail=[self.homeModel2.goodsList safeObjectAtIndex:indexPath.row];
    vc.ID=detail.ID;//goodsid
    vc.brand_id=detail.brand_id;
    [[YJTOOL getRootControllerSelectedVc] pushViewController:vc animated:YES];
}

@end




