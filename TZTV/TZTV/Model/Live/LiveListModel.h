//
//  LiveListModel.h
//  TZTV
//
//  Created by Luosa on 2016/11/17.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveListModel : NSObject

@property (nonatomic,   copy) NSString *ID;
@property (nonatomic,   copy) NSString *live_id;
@property (nonatomic,   copy) NSString *live_snapshot_play_url;
@property (nonatomic,   copy) NSString *live_title;
@property (nonatomic,   copy) NSString *live_market_name;
@property (nonatomic,   copy) NSString *user_id;
@property (nonatomic,   copy) NSString *brand_id;
@property (nonatomic,   copy) NSString *location;
@property (nonatomic,   copy) NSString *live_rtmp_publish_url;
@property (nonatomic,   copy) NSString *city;
@property (nonatomic,   copy) NSString *live_rtmp_play_url;
@property (nonatomic, assign) NSNumber *live_state;
@property (nonatomic, assign) NSInteger live_type;
@property (nonatomic,   copy) NSString *create_time;
@property (nonatomic,   copy) NSString *live_start_time;
@property (nonatomic,   copy) NSString *user_nicname;
@property (nonatomic,   copy) NSString *user_image;

@end

