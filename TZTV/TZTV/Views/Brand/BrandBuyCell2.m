//
//  BrandBuyCell2.m
//  TZTV
//
//  Created by Luosa on 2016/11/18.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandBuyCell2.h"

@implementation BrandBuyCell2

- (IBAction)reduceClicked:(UIButton *)sender {
    if ([_numLabel.text integerValue]<=0) {
        return;
    }
    NSString *num=[NSString stringWithFormat:@"%d",[_numLabel.text intValue]-1];
    _numLabel.text=num;
}

- (IBAction)addClicked:(UIButton *)sender {
    NSInteger num=[_numLabel.text integerValue];
    if (num==[_sub_sku[@"stock"] integerValue]) {
        [MBProgressHUD showToast:@"库存不够了"];
        return;
    }
    _numLabel.text=[NSString stringWithFormat:@"%ld",num+1];;
}

-(void)setSub_sku:(NSDictionary *)sub_sku{
    _sub_sku=sub_sku;
}

@end
