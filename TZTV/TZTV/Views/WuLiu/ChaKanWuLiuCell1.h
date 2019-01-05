//
//  ChaKanWuLiuCell1.h
//  TZTV
//
//  Created by Luosa on 2016/12/5.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrder.h"

@interface ChaKanWuLiuCell1 : YJTableViewCell

@property (nonatomic, strong) MyOrder *order;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;//商品数量
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;//快递状态
@property (weak, nonatomic) IBOutlet UILabel *kuaidiLabel;//快递公司
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;//运单编号
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;

@end
