//
//  ChaKanWuLiuCell2.h
//  TZTV
//
//  Created by Luosa on 2016/12/5.
//  Copyright © 2016年 Luosa. All rights reserved.
//

@interface ChaKanWuLiuCell2 : YJTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setDataSourceIsFirst:(BOOL)isFirst isLast:(BOOL)isLast;

@end
