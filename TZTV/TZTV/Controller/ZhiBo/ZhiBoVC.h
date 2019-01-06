//
//  ZhiBoVC.h
//  TZTV
//
//  Created by Luosa on 2016/12/16.
//  Copyright © 2016年 Luosa. All rights reserved.
//

@interface ZhiBoVC : YJViewController

@property (nonatomic,   copy) NSDictionary *info;

@property (weak, nonatomic) IBOutlet UILabel     *zaixianNumLabel;
@property (weak, nonatomic) IBOutlet UILabel     *dianzanshuLabel;
@property (weak, nonatomic) IBOutlet UITableView *chatTV;
@property (weak, nonatomic) IBOutlet UIButton    *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *zhuboIcon;

@end



/**上个页面带过来的数据
 data = {
	id = 0,
	live_id = tzlive1483085910549,
	live_snapshot_play_url = http://116.62.48.85:89/tuzi/images/1483085908308.jpg,
	live_title = qwrty,
	live_market_name = Ritchie,
	user_id = 100010,
	brand_id = 1,
	location = 121.51274196,31.217833914152,
	live_rtmp_publish_url = rtmp://pili-publish.lives.tuzishangcheng.com/tztv-2016/tzlive1483085910549?e=1483089510&token=jU5ygSHVnH6R1rtkeEI_vi3ozO-3LyBAwu3zB0Ra:Pg7mdoT7ih2JMahYiRoYUr5PIhM=,
	city = 上海市,
	live_rtmp_play_url = rtmp://pili-live-rtmp.lives.tuzishangcheng.com/tztv-2016/tzlive1483085910549,
	live_state = 0,
	live_type = 0
 },
 */
