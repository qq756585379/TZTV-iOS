//
//  PLGoodsTV.h
//  TZTV
//
//  Created by Luosa on 2017/2/21.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLGoodsTV : YJTableView

@property (nonatomic, assign) NSNumber *type;
@property (nonatomic,   copy) NSString *live_user_id;//直播用户ID

-(void)loadNewData;

@end
