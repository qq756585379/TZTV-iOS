//
//  AccountTool.h
//  klxc
//
//  Created by sctto on 16/3/30.
//  Copyright © 2016年 sctto. All rights reserved.
//

#import "Account.h"

@interface AccountTool : NSObject

+ (void)saveAccount:(Account *)account;

+ (Account *)account;
+ (Account *)getAccount:(BOOL)showLoginController;

@end
