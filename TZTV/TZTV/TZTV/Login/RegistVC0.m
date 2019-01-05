//
//  RegistVC0.m
//  TZTV
//
//  Created by Luosa on 2016/11/10.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "RegistVC0.h"
#import "RegistVC.h"

@interface RegistVC0 ()
@property (weak, nonatomic) IBOutlet UITextField *telTF;
@end

@implementation RegistVC0

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"注册";
    self.view.backgroundColor=[UIColor whiteColor];
}

- (IBAction)getVertifyCode:(UIButton *)sender {
    if (![_telTF.text isPhoneNo]) {
        [MBProgressHUD showError:@"请输入正确的手机号！"];
        return;
    }
    //type - 1:注册; 2：找回密码;
    [[YJHttpRequest sharedManager] get:[NSString stringWithFormat:GetRegVerifyCodeURL,_telTF.text,1] params:nil success:^(id json) {
        YJLog(@"%@",json);
        RegistVC *vc=[sb instantiateViewControllerWithIdentifier:@"RegistVC"];
        vc.telNum=_telTF.text;
        if ([json[@"code"] isEqualToNumber:@0]) {
            vc.type=GetVerifyCodeSuccess;
            vc.codeID=json[@"data"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            vc.type=GetVerifyCodeFail;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        RegistVC *vc=[sb instantiateViewControllerWithIdentifier:@"RegistVC"];
        vc.type=GetVerifyCodeFail;
        vc.telNum=_telTF.text;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


@end
