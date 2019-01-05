//
//  FindPwdVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/14.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "FindPwdVC.h"
#import "CountDownBtn.h"

@interface FindPwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *TF1;
@property (weak, nonatomic) IBOutlet UITextField *TF2;
@property (weak, nonatomic) IBOutlet UITextField *TF3;
@property (weak, nonatomic) IBOutlet CountDownBtn *codeBtn;
@property (nonatomic, copy) NSString *msgCode;
@end

@implementation FindPwdVC

+ (void)load
{
    YJMappingVO *vo = [YJMappingVO new];
    vo.className = NSStringFromClass(self);
    vo.createdType = YJMappingClassCreateByStoryboard;
    [[YJRouter sharedInstance] registerRouterVO:vo withKey:@"FindPwdVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"找回密码";
    self.view.backgroundColor=[UIColor whiteColor];
    if ([self.title isEqualToString:@"修改密码"]) {
        _TF1.text=[NSString stringWithFormat:@"%@",[[AccountTool account] telephone]];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_codeBtn stopCount];
}

- (IBAction)codeBtnClicked:(CountDownBtn *)sender {
    if (![_TF1.text isPhoneNo]) {
        [MBProgressHUD showError:@"请输入正确的手机号！"];
        return;
    }
    //type - 1:注册; 2：找回密码;
    NSString *url=[NSString stringWithFormat:GetRegVerifyCodeURL,_TF1.text,2];
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            [_codeBtn startCount];
            [MBProgressHUD showSuccess:@"发送验证码成功！"];
            self.msgCode=json[@"data"];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发送验证码失败！"];
    }];
}

- (IBAction)completeClicked:(UIButton *)sender {
    [self cancelFirstResponse];
    if (![_TF1.text isPhoneNo]) {
        [MBProgressHUD showError:@"请输入正确的手机号！"];
        return;
    }
    if (_TF2.text.length<6) {
        [MBProgressHUD showError:@"请输入验证码！"];
        return;
    }
    if (_TF3.text.length<6) {
        [MBProgressHUD showError:@"密码个数至少6位！"];
        return;
    }
    NSString *url =[NSString stringWithFormat:findPwdUrl,_TF1.text,self.msgCode,_TF2.text,_TF3.text];
    YJLog(@"%@",url);
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            [MBProgressHUD showSuccess:@"修改密码成功！"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"修改密码失败！"];
    }];
}

@end
