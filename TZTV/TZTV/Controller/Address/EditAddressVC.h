//
//  EditAddressVC.h
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

typedef NS_ENUM(NSUInteger, AddressType) {
    AddAddressType = 1,
    EditAddressType = 2
};

@interface EditAddressVC : YJTableViewController

@property (nonatomic, assign) AddressType type;

@property (nonatomic, strong) AddressModel *model;

@property (nonatomic,   copy) void(^block)();

@end
