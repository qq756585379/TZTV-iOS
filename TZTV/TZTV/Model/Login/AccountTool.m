//
//  AccountTool.m
//  klxc
//
//  Created by sctto on 16/3/30.
//  Copyright © 2016年 sctto. All rights reserved.
//

#import "AccountTool.h"
#import "Account.h"

#define AccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation AccountTool

+ (void)saveAccount:(Account *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:AccountPath];
}

+ (Account *)account
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:AccountPath];
}

+ (Account *)getAccount:(BOOL)showLoginController
{
    Account *account = [self account];
    if (!account && showLoginController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController *fromVc = [UIApplication sharedApplication].keyWindow.rootViewController;
            [YJRouter routeToDestVc:@"LoginVC" from:fromVc extraData:nil];
        });
    }
    return account;
}

@end
