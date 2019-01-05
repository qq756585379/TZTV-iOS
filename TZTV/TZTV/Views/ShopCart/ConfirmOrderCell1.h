//
//  ConfirmOrderCell1.h
//  TZTV
//
//  Created by Luosa on 2016/11/29.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "AddressModel.h"

@interface ConfirmOrderCell1 : YJTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *shouhuorenLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, strong) AddressModel *addressM;

@end
