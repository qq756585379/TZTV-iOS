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

@interface RegistVC () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField     *TF1;//昵称
@property (weak, nonatomic) IBOutlet UITextField     *TF2;//密码
@property (weak, nonatomic) IBOutlet UITextField     *TF3;//验证码
@property (weak, nonatomic) IBOutlet UIButton        *iconBtn;
@property (weak, nonatomic) IBOutlet CountDownBtn    *getCodeBtn;
@property (nonatomic, copy) NSString *imageUrl;
@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageUrl=@"";
    self.view.backgroundColor=[UIColor whiteColor];
    if (self.type==GetVerifyCodeSuccess) {
        [self.getCodeBtn startCount];
    }
}

#pragma mark - 上传照片
- (IBAction)iconBtnClicked:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([YJTOOL checkCameraAuthorizationStatusInView:self.view]) {
            [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([YJTOOL checkPhotoLibraryAuthorizationStatusInView:self.view]) {
            [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = type;
    ipc.delegate = self;
    ipc.allowsEditing=YES;
    [self presentViewController:ipc animated:YES completion:nil];
}
#warning 后期改
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    [image drawInRect:CGRectMake(0, 0, 200, 200)];
    UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *data = UIImageJPEGRepresentation(newimage, 0.5);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = 0;
    params[@"type"] = @1;
    [MBProgressHUD showMessage:@"头像上传中..."];
    [[YJHttpRequest sharedManager] createAnUploadTask:UploadImagesUrl imageData:data andParameters:params success:^(id json) {
        YJLog(@"%@",json);
        [MBProgressHUD hideHUD];
        if ([json[@"code"] isEqualToNumber:@0]) {
            [MBProgressHUD showSuccess:@"上传头像成功"];
            [self.iconBtn setImage:image forState:UIControlStateNormal];
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
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)agreementClicked:(UIButton *)sender {
    
}

#pragma mark - 获取验证码
- (IBAction)getCodeClicked:(UIButton *)sender {
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
- (IBAction)sureClicked:(UIButton *)sender {
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

@end
