//
//  TuiKuangCell1.h
//  TZTV
//
//  Created by Luosa on 2016/12/7.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuiKuangCell1 : YJTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn1;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn2;

@property (nonatomic,   copy) void(^block)(NSString *refund_type);

@end
