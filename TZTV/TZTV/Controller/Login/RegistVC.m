//
//  RegistVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "RegistVC.h"
#import "YJTOOL.h"
#import "Account.h"
#import "AccountTool.h"
#import "UIWindow+YJ.h"
#import "CountDownBtn.h"
#import "YJWebViewController.h"

@interface RegistVC () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField     *TF1;//昵称
@property (weak, nonatomic) IBOutlet UITextField     *TF2;//密码
@property (weak, nonatomic) IBOutlet UITextField     *TF3;//验证码
@property (weak, nonatomic) IBOutlet UIButton        *iconBtn;
@property (weak, nonatomic) IBOutlet CountDownBtn    *getCodeBtn;
@property (nonatomic, copy) NSString *imageUrl;
@end

@implementation RegistVC

+ (void)load
{
    YJMappingVO *vo = [YJMappingVO new];
    vo.className = NSStringFromClass(self);
    vo.createdType = YJMappingClassCreateByStoryboard;
    [[YJRouter sharedInstance] registerRouterVO:vo withKey:@"RegistVC"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"注册";
    self.imageUrl=@"";
    self.view.backgroundColor=[UIColor whiteColor];
    if (self.type==GetVerifyCodeSuccess) {
        YJLog(@"GetVerifyCodeSuccess");
        [self.getCodeBtn startCount];
    }
    [_TF1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)textFieldDidChange:(UITextField *)textField
{
    if (_TF1.text.length>20) {
        _TF1.text=[_TF1.text substringToIndex:20];
    }
}

- (IBAction)agreementClicked:(UIButton *)sender
{
    YJWebViewController *web=[YJWebViewController new];
    web.htmlUrl=agreeMentURL;
    web.title=@"用户协议";
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark - 获取验证码
- (IBAction)getCodeClicked:(UIButton *)sender
{
    //type - 1:注册; 2：找回密码;
    [[YJHttpRequest sharedManager] get:[NSString stringWithFormat:GetRegVerifyCodeURL,_telNum,1] params:nil success:^(id json) {
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            self.type=GetVerifyCodeSuccess;
            self.codeID=json[@"data"];
            [self.getCodeBtn startCount];
            [MBProgressHUD showSuccess:@"获取验证码成功！"];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"获取验证码失败！"];
    }];
}

#pragma mark - 确认注册
- (IBAction)sureClicked:(UIButton *)sender
{
    if (self.type==GetVerifyCodeFail) {
        [MBProgressHUD showToast:@"请重新获取验证码！"];
        return;
    }
    if (_TF1.text.length==0) {
        [MBProgressHUD showError:@"请输入您的昵称！"];
        return;
    }
    if (_TF2.text.length<6) {
        [MBProgressHUD showError:@"密码至少为6位！"];
        return;
    }
    if (_TF3.text.length<6) {
        [MBProgressHUD showError:@"请输入6位验证码！"];
        return;
    }
    [self verifyCode];//校验验证码
}

#pragma mark - 校验验证码
-(void)verifyCode{
    NSString *url=[NSString stringWithFormat:ValidateMobileCodeURL,self.codeID,self.TF3.text];
    YJLog(@"%@",url);
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            [self registWith];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"注册失败！"];
    }];
}

-(void)registWith{
    NSString *url=[NSString stringWithFormat:REGISTURL,self.codeID,_TF3.text,_TF2.text,self.imageUrl,_TF1.text,@"",@""];
    YJLog(@"%@",url);
    [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            [MBProgressHUD showSuccess:@"注册成功"];
            Account *account=[Account mj_objectWithKeyValues:json[@"data"]];
            [AccountTool saveAccount:account];
            [YJAppDelegate endEditing];
            [YJWindow switchRootViewController];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"注册失败!"];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.getCodeBtn stopCount];
}

#pragma mark - 上传照片
- (IBAction)iconBtnClicked:(UIButton *)sender
{
    [YJAlertSheet actionSheetWithTitle:nil message:nil buttons:@[@"拍照",@"从相册选择"] selectIndex:-1
                     cancelButtonTitle:@"取消" andCompleteBlock:^(NSString *title, NSInteger index) {
                         if (index==0) {
                             if ([YJTOOL checkCameraAuthorizationStatusInView:self.view]) {
                                 [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
                             }
                         }else{
                             if ([YJTOOL checkPhotoLibraryAuthorizationStatusInView:self.view]) {
                                 [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
                             }
                         }
                     }];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)type
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegatec
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *newimage = [image yp_imageCompressForSize:CGSizeMake(200,200)];
    NSData *data = UIImageJPEGRepresentation(newimage, 0.5);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = 0;
    params[@"type"] = @1;
    [MBProgressHUD showMessage:@"头像上传中..."];
    [[YJHttpRequest sharedManager] createAnUploadTask:UploadFileUrl imageData:data andParameters:params success:^(id json) {
        YJLog(@"%@",json);
        [MBProgressHUD hideHUD];
        if ([json[@"code"] isEqualToNumber:@0]) {
            [MBProgressHUD showSuccess:@"上传头像成功"];
            [self.iconBtn setImage:[image circleImage] forState:UIControlStateNormal];
            self.imageUrl=json[@"data"];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"上传头像失败！"];
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end


