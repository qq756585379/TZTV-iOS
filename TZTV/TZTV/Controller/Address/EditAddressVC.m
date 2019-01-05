//
//  EditAddressVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "EditAddressVC.h"
#import "UIBarButtonItem+Create.h"
#import "MapManager.h"
#import "AddressModel.h"
#import "PlaceholderTextView.h"

@interface EditAddressVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;//姓名
@property (weak, nonatomic) IBOutlet UITextField *telTF;//电话
@property (weak, nonatomic) IBOutlet UITextField *addressTF;//所在地区
@property (weak, nonatomic) IBOutlet UISwitch    *switchBtn;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *textInputView;//详细地址
@end

@implementation EditAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textInputView.placeholder=@"请输入详细地址";
    self.title=(self.type==AddAddressType)?@"添加地址":@"编辑地址";
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"保存" textColor:YJNaviColor
                                                                   textFont:YJFont(16) target:self action:@selector(rightAction)];
    if (self.type==AddAddressType) {
        [[MapManager sharedManager] startWithCompleteBlock:^(CLPlacemark *mark, NSDictionary *addressDictionary, CLLocation *aLocation) {
            if (mark==nil || aLocation==nil) {
                _addressTF.text=@"";
                _textInputView.text=@"";
            }else{
                _addressTF.text=[NSString stringWithFormat:@"%@%@",mark.locality, mark.subLocality];
                _textInputView.text=mark.name;//详细地址
            }
        }];
    }else{//编辑
        _nameTF.text=_model.name;
        _telTF.text=_model.phone;
        _addressTF.text=_model.address;
        _textInputView.text=_model.detail;
        [_switchBtn setOn:_model.is_default animated:NO];
    }
}

//保存
-(void)rightAction
{
    if (_nameTF.text.length==0) {
        [MBProgressHUD showError:@"请填写收货人！"];
        return;
    }
    if (![_telTF.text isPhoneNo]) {
        [MBProgressHUD showError:@"请填写正确的联系电话！"];
        return;
    }
    if (_addressTF.text.length==0 || _textInputView.text.length==0) {
        [MBProgressHUD showError:@"请填写详细的收货地址！"];
        return;
    }
    if (self.type==AddAddressType) {//添加地址
        [self addAddress];
    }else{//编辑地址
        [self editAddress];
    }
}

-(void)editAddress
{
    [MBProgressHUD showMessage:@""];
    Account *account=[AccountTool account];
    NSString *url=[NSString stringWithFormat:uptAddressURL,account.user_id,_model.ID,_nameTF.text,_telTF.text,_addressTF.text,_textInputView.text,_switchBtn.isOn,account.token];
    [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
        YJLog(@"%@",json);
        [MBProgressHUD hideHUD];
        if ([json[@"code"] isEqualToNumber:@0]) {
            if (self.block) self.block();
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络不太好"];
    }];
}

-(void)addAddress
{
    [MBProgressHUD showMessage:@""];
    Account *account=[AccountTool account];
    NSString *url=[NSString stringWithFormat:addAddressURL,account.user_id,_nameTF.text,_telTF.text,_addressTF.text,_textInputView.text,_switchBtn.isOn?1:0,account.token];
    [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"code"] isEqualToNumber:@0]) {
            if (self.block) self.block();
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络不太好"];
    }];
}

-(void)delAddress
{
    Account *accout=[AccountTool account];
    [MBProgressHUD showMessage:@""];
    NSString *url=[NSString stringWithFormat:delAddressURL,accout.user_id,_model.ID,accout.token];
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        [MBProgressHUD hideHUD];
        if ([json[@"code"] isEqualToNumber:@0]) {
            if (self.block) self.block();
              [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络不太好"];
    }];
}

//修改地址时才可以使用该方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section*10+indexPath.row==20) {
//        [AlertViewManager alertWithTitle:@"确定删除吗？"
//                                 message:@""
//                                 leftBtn:@"取消"
//                                rightBtn:@"确定"
//                        andCompleteBlock:^(NSInteger buttonIndex) {
//            if (buttonIndex==1) [self delAddress];
//        }];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.type==AddAddressType?2:3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

@end
