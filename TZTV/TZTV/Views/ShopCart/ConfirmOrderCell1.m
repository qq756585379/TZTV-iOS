//
//  ConfirmOrderCell1.m
//  TZTV
//
//  Created by Luosa on 2016/11/29.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ConfirmOrderCell1.h"

@implementation ConfirmOrderCell1

+(CGFloat)heightForCellData:(id)aData
{
    return 80;
}

-(void)setAddressM:(AddressModel *)addressM{
    _addressM=addressM;
    _shouhuorenLabel.text=addressM?addressM.name:@"";
    _telLabel.text=addressM.phone;
    _addressLabel.text=addressM?[NSString stringWithFormat:@"%@%@",addressM.address,addressM.detail]:@"";
}

@end
