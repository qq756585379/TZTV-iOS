//
//  SingleInfoVC+YJ.m
//  TZTV
//
//  Created by Luosa on 2016/11/18.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "SingleInfoVC+YJ.h"
#import "AccountTool.h"
#import "YJTOOL.h"
#import "ActionSheetDatePicker.h"
#import "NSDate+YJ.h"

@implementation SingleInfoVC (YJ)

-(void)updateSex:(NSInteger)index andAexLabel:(UILabel *)sexLabel
{
    Account *account=[AccountTool account];
    //未知；1；男；2：女
    NSString *url=[NSString stringWithFormat:uptSexURL,account.pid,index+1];
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        if ([json[@"code"] isEqualToNumber:@0]) {
            YJLog(@"%@",json);
            [MBProgressHUD showSuccess:@"设置成功!"];
            sexLabel.text=(index==0)?@"男":@"女";
//            account.user_sex=[NSNumber numberWithInteger:index+1];
            [AccountTool saveAccount:account];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"设置失败!"];
    }];
}

-(void)updateBrithday:(UILabel *)birthdayLabel
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:1900];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    [ActionSheetDatePicker showPickerWithTitle:@"" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] minimumDate:minDate maximumDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        Account *account=[AccountTool account];
        NSString *url=[NSString stringWithFormat:uptBirthdayURL,account.pid,[selectedDate stringFromDateWithFormat:@"yyyy-MM-dd"]];
        [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
            if ([json[@"code"] isEqualToNumber:@0]) {
                YJLog(@"%@",json);
                birthdayLabel.text=[selectedDate stringFromDateWithFormat:@"yyyy-MM-dd"];
//                account.user_birthday=[selectedDate stringFromDateWithFormat:@"yyyy-MM-dd"];
                [AccountTool saveAccount:account];
                [MBProgressHUD showSuccess:@"设置成功!"];
            }else{
                [MBProgressHUD showError:json[@"msg"]];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"设置失败!"];
        }];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:YJWindow];
}

//-(void)updateNickName:(UILabel *)nickLabel{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        [textField setFont:[UIFont fontWithName:@"Heiti-SC" size:20]];
//        textField.placeholder = @"请输入昵称";
//        //textField.secureTextEntry = YES;
//        //textField.keyboardType = UIKeyboardTypeNumberPad;
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        NSString *nickName = ((UITextField *)[alertController.textFields objectAtIndex:0]).text;
//        if (nickName.length==0) {
//            [MBProgressHUD showError:@"请输入昵称！"];
//        }else{
//            Account *account=[AccountTool account];
//            NSString *url=[NSString stringWithFormat:uptNicknameURL,account.user_id,nickName];
//            [[YJHttpRequest sharedManager] get:[url yj_stringByAddingPercentEscapesUsingEncoding] params:nil success:^(id json) {
//                if ([json[@"code"] isEqualToNumber:@0]) {
//                    YJLog(@"%@",json);
//                    nickLabel.text=nickName;
//                    account.user_nicname=nickName;
//                    [AccountTool saveAccount:account];
//                    [MBProgressHUD showSuccess:@"设置成功!"];
//                }else{
//                    [MBProgressHUD showError:json[@"msg"]];
//                }
//            } failure:^(NSError *error) {
//                [MBProgressHUD showError:@"设置失败!"];
//            }];
//        }
//    }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:otherAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//}

@end
