//
//  RegistVC.h
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

typedef NS_ENUM(NSUInteger, GetVerifyCodeType) {
    GetVerifyCodeSuccess = 1,
    GetVerifyCodeFail = 2
};

@interface RegistVC : YJViewController

@property (nonatomic, assign) GetVerifyCodeType type;

@property (nonatomic, assign) NSNumber *codeID;

@property (nonatomic, copy) NSString *telNum;

@end
