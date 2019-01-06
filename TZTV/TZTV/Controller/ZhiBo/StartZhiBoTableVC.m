//
//  StartZhiBoTableVC.m
//  TZTV
//
//  Created by Luosa on 2016/12/14.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "StartZhiBoTableVC.h"
#import "MapManager.h"
#import "ActionSheetStringPicker.h"
#import "ZhiBoVC.h"

@interface StartZhiBoTableVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField        *huodongTF;
@property (weak, nonatomic) IBOutlet UITextField        *guangchangTF;
@property (weak, nonatomic) IBOutlet YJBlockImageView  *upLoadIV;
@property (nonatomic,   copy) NSString *imgUrl;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation StartZhiBoTableVC

+ (void)load
{
    YJMappingVO *vo = [YJMappingVO new];
    vo.className = NSStringFromClass(self);
    vo.createdType = YJMappingClassCreateByStoryboard;
    [[YJRouter sharedInstance] registerRouterVO:vo withKey:@"StartZhiBoTableVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"开启直播";
    self.tableView.separatorStyle=1;
    [self.upLoadIV doBorderWidth:1 color:kF5F5F5 cornerRadius:5];
    [self.upLoadIV setBlock:^(YJBlockImageView *sender) {
        [self uploadImage];
    }];
    [[YJHttpRequest sharedManager] get:StartLiveBrandListURL params:nil success:^(id json) {
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]){
            self.dataArray=json[@"data"];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 开启直播
- (IBAction)startLive:(UIButton *)sender {
    if (_huodongTF.text.length==0) {
        [MBProgressHUD showError:@"请输入活动主题"];
        return;
    }
    if (_guangchangTF.text.length==0) {
        [MBProgressHUD showError:@"请输入广场名称"];
        return;
    }
    if (self.imgUrl.length==0) {
        [MBProgressHUD showError:@"请上传封面图片"];
        return;
    }
    NSString *location=[NSString stringWithFormat:@"%@,%@",[YJUserDefault getValueForKey:LongitudeKey],[YJUserDefault getValueForKey:LatitudeKey]];
    NSString *url=[NSString stringWithFormat:startLiveURL,[[AccountTool account] pid],self.huodongTF.text,self.guangchangTF.text,@"1",self.imgUrl,[YJUserDefault getValueForKey:CurrentCityKey],location];
  
    [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            ZhiBoVC *vc=[sb instantiateViewControllerWithIdentifier:@"ZhiBoVC"];
            vc.info=json[@"data"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showToast:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络不好"];
    }];
}

-(void)uploadImage{
    if ([YJTOOL checkPhotoLibraryAuthorizationStatusInView:self.view]) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImage *newimage = [image yp_imageCompressForSize:CGSizeMake(ScreenW,ScreenW*420/750)];
    NSData *data = UIImageJPEGRepresentation(newimage, 0.5);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    Account *account=[AccountTool account];
    params[@"userId"] = account.pid;
    params[@"type"] = @2;//1：头像；2：图片
    [MBProgressHUD showMessage:@"上传中"];
    [[YJHttpRequest sharedManager] createAnUploadTask:UploadFileUrl imageData:data andParameters:params success:^(id json) {
        YJLog(@"%@",json);
        [MBProgressHUD hideHUD];
        if ([json[@"code"] isEqualToNumber:@0]) {
            [MBProgressHUD showSuccess:@"上传成功"];
            self.imgUrl=json[@"data"];
            [self.upLoadIV sd_setImageWithURL:[NSURL URLWithString:json[@"data"]] placeholderImage:[UIImage imageNamed:@"Cover_photo"]];
        }else{
            [MBProgressHUD showToast:json[@"msg"]];
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        YJLog(@"%@",error);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"上传失败"];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (indexPath.row==2) {
//        NSMutableArray *brandArr=[NSMutableArray array];
//        for (NSDictionary *dict in self.dataArray) {
//            [brandArr addObject:dict[@"brand_name"]];
//        }
//        [ActionSheetStringPicker showPickerWithTitle:@"选择品牌" rows:brandArr initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
//           
//        } cancelBlock:nil origin:self.view];
//    }
//}

@end
