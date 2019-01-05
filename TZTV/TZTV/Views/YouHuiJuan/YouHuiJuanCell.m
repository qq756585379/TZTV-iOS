//
//  YouHuiJuanCell.m
//  TZTV
//
//  Created by Luosa on 2016/11/28.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "YouHuiJuanCell.h"
#import "NSString+safe.h"

@implementation YouHuiJuanCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor=kF5F5F5;
}

-(void)setCoupon:(CouponModel *)coupon{
    _coupon=coupon;
    _lebel1.text=coupon.name;
    _titleL.text=coupon.DES;
    _quanmaLabel.text=[NSString stringWithFormat:@"券码：%@",coupon.coupon_token];
    _useDateLabel.text=[NSString stringWithFormat:@"截止期限 %@",coupon.end_time];
    // 0,正常;1,代表已使用；2，已失效
    if (coupon.status==0) {
        self.rightView.backgroundColor=YJNaviColor;
        
        self.usedIcon.hidden=YES;
        self.shixiaoIcon.hidden=YES;
    
    }else if (coupon.status==1){
        
        self.rightView.backgroundColor=kEDEDED;
        self.usedIcon.hidden=NO;
        self.shixiaoIcon.hidden=YES;
        
    }else if (coupon.status==2){
        
        self.rightView.backgroundColor=kEDEDED;
        self.usedIcon.hidden=YES;
        self.shixiaoIcon.hidden=NO;
        
    }
}

@end
