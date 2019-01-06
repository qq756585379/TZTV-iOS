//
//  Account.h
//  klxc
//
//  Created by sctto on 16/3/30.
//  Copyright © 2016年 sctto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding>

@property (nonatomic, assign) NSNumber *pid;
@property (nonatomic,   copy) NSString *account;
@property (nonatomic,   copy) NSString *nickName;
@property (nonatomic,   copy) NSString *realName;
@property (nonatomic,   copy) NSString *email;
@property (nonatomic,   copy) NSString *phone;
@property (nonatomic,   copy) NSString *question;
@property (nonatomic,   copy) NSString *answer;
@property (nonatomic, assign) NSInteger role;

//@property (nonatomic,   copy) NSString *user_address;
//@property (nonatomic,   copy) NSString *user_birthday;
//@property (nonatomic, assign) NSInteger user_type;
//@property (nonatomic,   copy) NSString *user_id;
//@property (nonatomic,   copy) NSString *token;
//@property (nonatomic, assign) NSInteger user_age;
//@property (nonatomic,   copy) NSString *user_name;
//@property (nonatomic, assign) NSNumber *user_sex;
//@property (nonatomic, assign) NSNumber *user_source;
//@property (nonatomic,   copy) NSString *create_time;
//@property (nonatomic,   copy) NSString *telephone;
//@property (nonatomic,   copy) NSString *user_city;
//@property (nonatomic,   copy) NSString *user_image;
@end

