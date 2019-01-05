//
//  HomePageCell2.m
//  TZTV
//
//  Created by Luosa on 2016/12/27.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomePageCell2.h"
#import "PLPlayerVC.h"

@implementation HomePageCell2

+(CGFloat)heightForCellData:(id)aData
{
    return ScreenW * 420 / 750;
}

#pragma mark - 播放
- (IBAction)player:(UIButton *)sender
{
    sender.enabled=NO;
    if (_listModel.live_type==1) {//需要调getHistoryURL
        NSString *url=[NSString stringWithFormat:getHistoryURL,_listModel.live_id,_listModel.live_rtmp_play_url];
        [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
            sender.enabled=YES;
            if ([json[@"code"] isEqualToNumber:@0]) {
                PLPlayerVC *vc=[sb instantiateViewControllerWithIdentifier:@"PLPlayerVC"];
                vc.live_id=_listModel.live_id;
                vc.live_user_id=_listModel.user_id;
                vc.live_rtmp_play_url=json[@"data"];
                [[YJTOOL getRootControllerSelectedVc] pushViewController:vc animated:YES];
            }
        } failure:^(NSError *error) {
            sender.enabled=YES;
        }];
    }else if (_listModel.live_type==2){//不需要调getHistoryURL,直接使用播放器
        sender.enabled=YES;
        if (self.block) {
            self.block(_listModel);
        }
    }
}

-(void)setListModel:(LiveListModel *)listModel
{
    _listModel=listModel;
    [self.bgIV sd_setImageWithURL:[NSURL URLWithString:listModel.live_snapshot_play_url] placeholderImage:[UIImage imageNamed:@"Loading_pictures"]];
    self.desLabel.text=listModel.live_title;
}

@end
