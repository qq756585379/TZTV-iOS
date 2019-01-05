//
//  TuiKuangCell5.h
//  TZTV
//
//  Created by Luosa on 2016/12/7.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuiKuangCell5 : YJTableViewCell

@property (weak, nonatomic) IBOutlet UIView *smallView1;
@property (weak, nonatomic) IBOutlet UIView *smallView2;
@property (weak, nonatomic) IBOutlet UIView *smallView3;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic,   copy) void(^block)(NSInteger i);

@end
