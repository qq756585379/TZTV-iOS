//
//  AddressModel.h
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
@property (nonatomic,   copy) NSString *address;
@property (nonatomic,   copy) NSString *detail;
@property (nonatomic, assign) NSInteger is_default;
@property (nonatomic,   copy) NSString *ID;
@property (nonatomic,   copy) NSString *phone;
@property (nonatomic,   copy) NSString *user_id;
@property (nonatomic,   copy) NSString *name;
@end
