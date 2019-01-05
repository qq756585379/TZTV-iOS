//
//  HomeButtomCell.h
//  TZTV
//
//  Created by Luosa on 2017/3/2.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeButtomModel.h"

@interface HomeButtomCell : YJTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iv;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *subNameL;
@property (weak, nonatomic) IBOutlet UILabel *desL;

@property (nonatomic, strong) HomeButtomModel *buttomModel;

@end
