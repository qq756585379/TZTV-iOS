//
//  PLPlayerVC.h
//  TZTV
//
//  Created by Luosa on 2016/11/10.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ZhiBoViewModel.h"

@interface PLPlayerVC : YJViewController

@property (nonatomic,   copy) NSString *live_id;
@property (nonatomic,   copy) NSString *live_user_id;//直播用户ID
@property (nonatomic,   copy) NSString *live_rtmp_play_url;

//- (void)hiddenChat;
//- (void)showChat;

@property (weak, nonatomic) IBOutlet UIImageView    *iconIV;
@property (weak, nonatomic) IBOutlet UILabel        *nameLabel;
//在线人数
@property (weak, nonatomic) IBOutlet UILabel        *zaixianNumLabel;
//点赞数
@property (weak, nonatomic) IBOutlet UILabel        *loveNumLabel;

@end
