//
//  TuiKuangCell2.h
//  TZTV
//
//  Created by Luosa on 2016/12/7.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuiKuangCell2 : YJTableViewCell

@property (nonatomic,   copy) void(^block)();

@property (weak, nonatomic) IBOutlet UILabel *refund_reasonLabel;

@end
