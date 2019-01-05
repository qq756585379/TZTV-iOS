//
//  SubHomeVC.h
//  TZTV
//
//  Created by Luosa on 2016/11/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSUInteger, XMGTopicType) {
    XMGTopicType1 = 1,
    XMGTopicType2 = 2,
    XMGTopicType3 = 3,
    XMGTopicType4 = 4,
    XMGTopicType5 = 5,
    XMGTopicType6 = 6
};

@interface SubHomeVC : BaseTableViewController

@property (nonatomic, assign) XMGTopicType type;

@end
