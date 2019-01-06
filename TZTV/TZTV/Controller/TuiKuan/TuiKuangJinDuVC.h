//
//  TuiKuangJinDuVC.h
//  TZTV
//
//  Created by Luosa on 2016/12/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

typedef NS_ENUM(NSUInteger, TuiKuangJinDuType) {
    TypeFromShenQingTuiKuanVC = 1,
};

@interface TuiKuangJinDuVC : YJTableViewController

@property (nonatomic, assign) TuiKuangJinDuType type;

@end
