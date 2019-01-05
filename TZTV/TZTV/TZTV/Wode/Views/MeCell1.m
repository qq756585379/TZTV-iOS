//
//  MeCell1.m
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MeCell1.h"
#import "Account.h"
#import "OTSBlockImageView.h"
#import "UIImageView+YJ.h"
#import "AccountTool.h"
#import "YJTOOL.h"

@interface MeCell1 ()
@property (weak, nonatomic) IBOutlet OTSBlockImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *desLabel;
@end

@implementation MeCell1

-(void)setAccount:(Account *)account{
    _account=account;
    [self.iconIV setCircleImage:account.user_image];
    self.nameLabel.text=account.user_nicname?account.user_nicname:@"null";
    self.desLabel.text=[NSString stringWithFormat:@"帐号:%@",account.user_name];
    
    [self.iconIV setBlock:^(OTSBlockImageView *sender) {
        if ([AccountTool getAccount:YES]==nil) return;
        [[YJTOOL getRootControllerSelectedVc] pushViewController:[sb instantiateViewControllerWithIdentifier:@"SingleInfoVC"] animated:YES];
    }];
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

@end
