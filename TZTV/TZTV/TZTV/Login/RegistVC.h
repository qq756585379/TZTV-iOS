//
//  RegistVC.h
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, GetVerifyCodeType) {
    GetVerifyCodeSuccess = 1,
    GetVerifyCodeFail = 2
};

@interface RegistVC : BaseViewController

@property (nonatomic, assign) GetVerifyCodeType type;

@property (nonatomic, assign) NSNumber *codeID;

@property (nonatomic, copy) NSString *telNum;

@end
