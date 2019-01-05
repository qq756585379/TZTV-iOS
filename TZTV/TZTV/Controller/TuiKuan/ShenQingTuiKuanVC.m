//
//  ShenQingTuiKuanVC.m
//  TZTV
//
//  Created by Luosa on 2016/12/6.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ShenQingTuiKuanVC.h"
#import "TuiKuangCell1.h"
#import "TuiKuangCell2.h"
#import "TuiKuangCell3.h"
#import "TuiKuangCell4.h"
#import "TuiKuangCell5.h"
#import "UIImage+YJ.h"
#import "ActionSheetStringPicker.h"
#import "TuiKuangJinDuVC.h"

@interface ShenQingTuiKuanVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,   copy) NSString *refund_type; //退款/退货
@property (nonatomic,   copy) NSString *refundMoney; //退款金额
@property (nonatomic,   copy) NSString *refundReason;//退款原因
@property (nonatomic,   copy) NSString *refundDes;   //退款备注
@property (nonatomic,   weak) UITextField *currentTF;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) float offY;
@end

@implementation ShenQingTuiKuanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"退款申请";
    self.refund_type=@"退款";
    self.refundReason=@"请选择退款原因";
    self.tableView.separatorStyle=0;
    [self.tableView registerNib:[TuiKuangCell1 nib] forCellReuseIdentifier:[TuiKuangCell1 cellReuseIdentifier]];
    [self.tableView registerNib:[TuiKuangCell2 nib] forCellReuseIdentifier:[TuiKuangCell2 cellReuseIdentifier]];
    [self.tableView registerNib:[TuiKuangCell3 nib] forCellReuseIdentifier:[TuiKuangCell3 cellReuseIdentifier]];
    [self.tableView registerNib:[TuiKuangCell4 nib] forCellReuseIdentifier:[TuiKuangCell4 cellReuseIdentifier]];
    [self.tableView registerNib:[TuiKuangCell5 nib] forCellReuseIdentifier:[TuiKuangCell5 cellReuseIdentifier]];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGRect keyBoradRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect newRect = [[UIApplication sharedApplication].keyWindow convertRect:_currentTF.superview.bounds fromView:_currentTF.superview];
    //(当前编辑的view的y起点 + view的高 - 键盘的Y值 = 偏移量)
    _offY = newRect.origin.y - keyBoradRect.origin.y + 96;
    NSLog(@"%f",_offY);
    if (_offY<0) {
        return;
    }
    [UIView animateWithDuration:.3f animations:^{
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x,self.tableView.contentOffset.y + _offY);
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification{
    if (_offY<0) {
        return;
    }
    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x,self.tableView.contentOffset.y - _offY);
}

- (IBAction)submitClicked:(UIButton *)sender {
    if (_refundMoney.length==0) {
        [MBProgressHUD showError:@"请输入退款金额"];
        return;
    }
    Account *account=[AccountTool account];
    NSDictionary *parma=@{
                          @"user_id":account.user_id,
                          @"order_no":_orderSon.order_no,
                          @"goods_id":_orderSon.goods_id,
                          @"order_goods_id":_orderSon.ID,
                          @"refund_price":_refundMoney,
                          @"refund_type":_refund_type,
                          @"refund_reason":_refundReason.length?_refundReason:@"",
                          @"refund_remark":_refundDes.length?_refundDes:@"",
                          @"refund_imgs":@"",
                          @"token":account.token
                          };
    [[YJHttpRequest sharedManager] post:addRefundURL params:parma success:^(id json) {
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            TuiKuangJinDuVC *vc=[sb instantiateViewControllerWithIdentifier:@"TuiKuangJinDuVC"];
            vc.type=TypeFromShenQingTuiKuanVC;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD showToast:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"申请退款失败"];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;//隐藏了上传照片的功能
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        TuiKuangCell1 *cell1=[tableView dequeueReusableCellWithIdentifier:[TuiKuangCell1 cellReuseIdentifier] forIndexPath:indexPath];
        cell1.block=^(NSString *refund_type){
            self.refund_type=refund_type;
        };
        return cell1;
    }else if (indexPath.section==1){//退款原因
        TuiKuangCell2 *cell2=[tableView dequeueReusableCellWithIdentifier:[TuiKuangCell2 cellReuseIdentifier] forIndexPath:indexPath];
        cell2.refund_reasonLabel.text=self.refundReason;
        cell2.block=^(){
            [ActionSheetStringPicker showPickerWithTitle:@"退款原因" rows:[self reasons] initialSelection:1 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                self.refundReason=selectedValue;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            } cancelBlock:nil origin:YJWindow];
        };
        return cell2;
    }else if (indexPath.section==2){//退款金额
        TuiKuangCell3 *cell3=[tableView dequeueReusableCellWithIdentifier:[TuiKuangCell3 cellReuseIdentifier] forIndexPath:indexPath];
        [cell3.moneyTF.rac_textSignal subscribeNext:^(id x){
            self.refundMoney=x;
        }];
        cell3.moneyTF.delegate=self;
        return cell3;
    }else if (indexPath.section==3){//退款说明
        TuiKuangCell4 *cell4=[tableView dequeueReusableCellWithIdentifier:[TuiKuangCell4 cellReuseIdentifier] forIndexPath:indexPath];
        [cell4.tuikuanDesTF.rac_textSignal subscribeNext:^(id x){
            self.refundDes=x;
        }];
        cell4.tuikuanDesTF.delegate=self;
        return cell4;
    }else if (indexPath.section==4){//上传照片
        TuiKuangCell5 *cell5=[tableView dequeueReusableCellWithIdentifier:[TuiKuangCell5 cellReuseIdentifier] forIndexPath:indexPath];
        cell5.images=self.dataArray;
        cell5.block=^(NSInteger i){
            [self.dataArray removeObjectAtIndex:i];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell5;
    }
    return nil;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _currentTF = textField;
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 192;
    }
    return 96;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0?10:0.1;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (indexPath.section==4) {
//        if (self.dataArray.count==3) {
//            [MBProgressHUD showToast:@"最多上传3张图片"];
//            return;
//        }
//        [self addIcon];
//    }
//}

//-----------------------------------------------------------------------------------------------------------------
//-(void)addIcon{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        if ([YJTOOL checkCameraAuthorizationStatusInView:self.view]) {
//            [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
//        }
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        if ([YJTOOL checkPhotoLibraryAuthorizationStatusInView:self.view]) {
//            [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
//        }
//    }]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
//}

//- (void)openImagePickerController:(UIImagePickerControllerSourceType)type{
//    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
//    ipc.sourceType = type;
//    ipc.delegate = self;
//    [self presentViewController:ipc animated:YES completion:nil];
//}

//#pragma mark - UIImagePickerControllerDelegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
//    UIImage *newimage = [image yj_imageWithScale:200];
//    NSData *data = UIImageJPEGRepresentation(newimage, 0.5);
//    [self.dataArray addObject:newimage];
//    [self.tableView reloadData];
//    
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"userId"] = 0;
//        params[@"type"] = @1;
//        [MBProgressHUD showMessage:@"头像上传中..."];
//        [[YJHttpRequest sharedManager] createAnUploadTask:UploadImagesUrl imageData:data andParameters:params success:^(id json) {
//            YJLog(@"%@",json);
//            [MBProgressHUD hideHUD];
//            if ([json[@"code"] isEqualToNumber:@0]) {
//                [MBProgressHUD showSuccess:@"上传头像成功"];
//            }else{
//                [MBProgressHUD showError:json[@"msg"]];
//            }
//        } failure:^(NSError *error) {
//            [MBProgressHUD hideHUD];
//            [MBProgressHUD showError:@"上传头像失败！"];
//        }];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NOTIFICATION_CENTER removeObserver:self];
}

-(NSArray *)reasons{
    return @[@"7天无理由退换货",@"退运费",@"做工粗糙／有瑕疵",@"质量问题",@"大小／尺寸与商品描述不符",@"颜色／图案／款式与商品描述不符",@"材质与商品描述不符",@"少件／漏发",@"卖家发错货",@"假冒品牌",@"未按约定时间发货",@"发票问题",@"其他"];
}

@end




