//
//  LoginVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "LoginVC.h"
#import "AccountTool.h"
#import "LoginLogic.h"
#import "UIViewController+YJ.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *TF1;//帐号
@property (weak, nonatomic) IBOutlet UITextField *TF2;//密码
@property (nonatomic, strong) LoginLogic *loginLogic;
@end

@implementation LoginVC

+ (void)load
{
    YJMappingVO *vo = [YJMappingVO new];
    vo.routeType = YJRouteTypePresent;
    vo.className = NSStringFromClass(self);
    vo.createdType = YJMappingClassCreateByStoryboard;
    [[YJRouter sharedInstance] registerRouterVO:vo withKey:@"LoginVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _TF1.text = @"13376275127";
    _TF2.text = @"123456";
    [self setNaviButtonType:NaviButton_Return isLeft:YES];
//    [self setNavgationBarBackGroundImage:[UIImage imageWithColor:[UIColor whiteColor]] andShadowImage:[UIImage imageWithColor:kEDEDED]];
    [[_TF1.rac_textSignal filter:^BOOL(id value) {
        // value:源信号的内容,过滤条件,只有满足这个条件,才能能获取到内容
        return  [value length] == 11;
    }] subscribeNext:^(id x) {
        YJLog(@"%@",x);
    }];
}

- (IBAction)login:(UIButton *)sender
{
    [self cancelFirstResponse];
    if (![_TF1.text isPhoneNo]) {
        [MBProgressHUD showError:@"请输入正确的手机号！"];
        return;
    }
    if (_TF2.text.length<6) {
        [MBProgressHUD showError:@"密码个数至少6位！"];
        return;
    }
    WEAK_SELF
    NSDictionary *dict = @{@"accountName":_TF1.text,@"password":_TF2.text};
    [self.loginLogic loginWithParma:dict completionBlock:^(id aResponseObject, NSError *anError) {
        STRONG_SELF
        if (anError) {
            [MBProgressHUD showError:@"登录失败"];
        }else{
            [MBProgressHUD showSuccess:@"登录成功"];
            [self postNotification:LoginSuccess];//发通知
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)eyeClicked:(UIButton *)sender
{
    sender.selected=!sender.selected;
    self.TF2.secureTextEntry=!sender.selected;
}

- (IBAction)findPwd:(UIButton *)sender
{
    [YJRouter routeToDestVc:@"FindPwdVC" from:self extraData:nil];
}

- (IBAction)goToRegist0:(UIButton *)sender
{
    [YJRouter routeToDestVc:@"RegistVC0" from:self extraData:nil];
}

#pragma mark - Property
- (LoginLogic *)loginLogic {
    if (!_loginLogic) {
        _loginLogic = [LoginLogic logicWithOperationManager:self.operationManager];
    }
    return _loginLogic;
}

@end
