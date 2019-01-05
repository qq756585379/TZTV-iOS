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

+ (void)load
{
    YJMappingVO *vo = [YJMappingVO new];
    vo.className = NSStringFromClass(self);
    vo.createdType = YJMappingClassCreateByStoryboard;
    [[YJRouter sharedInstance] registerRouterVO:vo withKey:@"RegistVC0"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"注册";
    self.view.backgroundColor=[UIColor whiteColor];
    [_telTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)textFieldDidChange:(UITextField *)textField{
    if (_telTF.text.length>11) {
        _telTF.text=[_telTF.text substringToIndex:11];
    }
}
- (IBAction)getVertifyCode:(UIButton *)sender {
    if (![_telTF.text isPhoneNo]) {
        [MBProgressHUD showError:@"请输入正确的手机号！"];
        return;
    }
    NSString *url=[NSString stringWithFormat:GetRegVerifyCodeURL,_telTF.text,1];
    YJLog(@"GetRegVerifyCodeURL==%@",url);
    //type - 1:注册; 2：找回密码;
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        YJLog(@"获取验证码====%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            RegistVC *vc=[sb instantiateViewControllerWithIdentifier:@"RegistVC"];
            vc.telNum=_telTF.text;
            vc.type=GetVerifyCodeSuccess;
            vc.codeID=json[@"data"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        RegistVC *vc=[sb instantiateViewControllerWithIdentifier:@"RegistVC"];
        vc.type=GetVerifyCodeFail;
        vc.telNum=_telTF.text;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


@end
