//
//  AddressCell.m
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "AddressCell.h"
#import "NSArray+safe.h"
#import "EditAddressVC.h"

@interface AddressCell()
@property (weak, nonatomic) IBOutlet UILabel *shouhuoren;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@end

@implementation AddressCell

-(void)setModel:(AddressModel *)model
{
    _model=model;
    _shouhuoren.text=model.name;
    _telLabel.text=model.phone;
    _addressLabel.text=[NSString stringWithFormat:@"%@%@",model.address,model.detail];
    _chooseBtn.selected=model.is_default;
}

//去修改地址页面
- (IBAction)edit:(UIButton *)sender
{
    EditAddressVC *vc=[sb instantiateViewControllerWithIdentifier:@"EditAddressVC"];
    vc.type=EditAddressType;
    vc.model=_model;
    vc.block=^(){
        if (self.myBlock) self.myBlock();
    };
    [[YJTOOL getRootControllerSelectedVc] pushViewController:vc animated:YES];
}

//删除地址
- (IBAction)remove:(UIButton *)sender
{
    Account *accout=[AccountTool account];
    [MBProgressHUD showMessage:@""];
    NSString *url=[NSString stringWithFormat:delAddressURL,accout.user_id,_model.ID,accout.token];
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"code"] isEqualToNumber:@0]) {
            if (self.myBlock) self.myBlock();
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络不太好"];
    }];
}

//设置默认地址
- (IBAction)morenClicked:(UIButton *)sender
{
    sender.selected=!sender.selected;
    Account *accout=[AccountTool account];
    [MBProgressHUD showMessage:@""];
    NSString *url=[NSString stringWithFormat:uptAddressURL,accout.user_id,_model.ID,_model.name,_model.phone,_model.address,_model.detail,sender.selected,accout.token];
    YJLog(@"%@",url);
    [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"code"] isEqualToNumber:@0]) {
            if (self.myBlock) self.myBlock();
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络不太好"];
    }];
}

@end
