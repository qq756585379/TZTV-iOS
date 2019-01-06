//
//  SingleInfoChangeNameVC.m
//  TZTV
//
//  Created by Luosa on 2017/3/7.
//  Copyright © 2017年 Luosa. All rights reserved.
//

#import "SingleInfoChangeNameVC.h"

@interface SingleInfoChangeNameVC ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@end

@implementation SingleInfoChangeNameVC

+ (void)load
{
    YJMappingVO *vo = [YJMappingVO new];
    vo.className = NSStringFromClass(self);
    vo.createdType = YJMappingClassCreateByStoryboard;
    [[YJRouter sharedInstance] registerRouterVO:vo withKey:@"SingleInfoChangeNameVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"修改昵称";
}

- (IBAction)saveClicked:(UIButton *)sender {
    if (_userNameTF.text.length==0) {
        [MBProgressHUD showToast:@"请输入用户名!"];
        return;
    }
    Account *account=[AccountTool account];
    NSString *url=[NSString stringWithFormat:uptNicknameURL,account.pid,_userNameTF.text];
    [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
        if ([json[@"code"] isEqualToNumber:@0]) {
            YJLog(@"%@",json);
            account.nickName=_userNameTF.text;
            [AccountTool saveAccount:account];
            [MBProgressHUD showSuccess:@"设置成功!"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"设置失败!"];
    }];
}

@end
