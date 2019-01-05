//
//  ChatModel.h
//  TZTV
//
//  Created by Luosa on 2016/12/26.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject
@property (nonatomic,   copy) NSString *nicname;
@property (nonatomic,   copy) NSString *msg_content;
@property (nonatomic,   copy) NSString *create_time;
@property (nonatomic,   copy) NSString *msg_id;
@property (nonatomic,   copy) NSString *room_id;
@property (nonatomic,   copy) NSString *user_id;

@property (nonatomic,   copy) NSMutableAttributedString *chatString;
/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

-(instancetype)initWith:(NSDictionary *)dict;

@end
