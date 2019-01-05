//
//  MeCell1.m
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MeCell1.h"
#import "Account.h"
#import "UIImageView+YJ.h"
#import "AccountTool.h"
#import "YJTOOL.h"

@interface MeCell1 ()
@property (weak, nonatomic) IBOutlet YJBlockImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *desLabel;
@property (weak, nonatomic) IBOutlet UILabel     *not_login_tip_label;
@end

@implementation MeCell1

+(CGFloat)heightForCellData:(id)aData{
    return 92;
}

-(void)setAccount:(Account *)account{
    _account=account;
    if (account) {
        [self.iconIV setCircleImage:account.user_image andPlaceHolderImg:@"head"];
        self.nameLabel.text=[NSString stringWithFormat:@"昵称:%@",account.user_nicname?account.user_nicname:@""];
        self.desLabel.text=[NSString stringWithFormat:@"帐号:%@",account.user_name?account.user_name:@""];
        self.nameLabel.hidden=NO;
        self.desLabel.hidden=NO;
        self.not_login_tip_label.hidden=YES;
    }else{
        self.iconIV.image=[UIImage imageNamed:@"head"];
        self.nameLabel.hidden=YES;
        self.desLabel.hidden=YES;
        self.not_login_tip_label.hidden=NO;
    }
}

@end
