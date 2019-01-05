//
//  HomeModel2.h
//  TZTV
//
//  Created by Luosa on 2017/2/27.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrandDetailModel.h"

@interface HomeModel2 : NSObject

@property (nonatomic,   copy) NSString *location;
@property (nonatomic,   copy) NSString *play_num;
@property (nonatomic,   copy) NSString *user_image;
@property (nonatomic,   copy) NSString *live_id;
@property (nonatomic,   copy) NSString *live_rtmp_publish_url;
@property (nonatomic,   copy) NSString *create_time;
@property (nonatomic,   copy) NSString *user_id;
@property (nonatomic,   copy) NSString *live_start_time;
@property (nonatomic,   copy) NSString *live_type;
@property (nonatomic,   copy) NSString *live_state;
@property (nonatomic,   copy) NSString *live_title;
@property (nonatomic,   copy) NSString *city;
@property (nonatomic,   copy) NSString *auth_id;
@property (nonatomic,   copy) NSString *brand_id;
@property (nonatomic,   copy) NSString *user_nicname;
@property (nonatomic,   copy) NSString *live_hls_play_url;
@property (nonatomic,   copy) NSString *ID;
@property (nonatomic,   copy) NSString *live_snapshot_play_url;
@property (nonatomic,   copy) NSString *live_rtmp_play_url;
@property (nonatomic,   copy) NSString *live_market_name;

@property (nonatomic, strong) NSMutableArray *goodsList;

@end

