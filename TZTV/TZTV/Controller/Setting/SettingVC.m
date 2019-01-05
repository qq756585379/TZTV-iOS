//
//  SettingVC.m
//  TZTV
//
//  Created by Luosa on 2016/12/2.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "SettingVC.h"
#import "SuggestionsVC.h"

@interface SettingVC ()
@property (weak, nonatomic) IBOutlet UILabel  *cacheLabel;
@property (weak, nonatomic) IBOutlet UILabel  *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *logOutBtn;
@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle=1;
    self.title=@"设置";
    NSString *key = @"CFBundleShortVersionString";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    self.versionLabel.text=[NSString stringWithFormat:@"V%@",currentVersion];
    self.cacheLabel.text=[self calculateSize];
    [self.logOutBtn doBorderWidth:1 color:HEXRGBCOLOR(0x999999) cornerRadius:21];
}

#pragma mark - 退出登录
- (IBAction)logoutClicked:(UIButton *)sender {
    if ([AccountTool account]==nil) {
        [MBProgressHUD showToast:@"您还没有登录！"];
        return;
    }
    
    [YJAlertView alertWithTitle:@"退出登录" message:@"" leftBtn:@"取消" rightBtn:@"确定" andCompleteBlock:^(NSInteger buttonIndex) {
        [AccountTool saveAccount:nil];
        [MBProgressHUD showSuccess:@"退出登录成功"];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        [[SDImageCache sharedImageCache] clearMemory];
        self.cacheLabel.text=[self calculateSize];
        [self postNotification:LoginOutSuccess];
        [self.navigationController popViewControllerAnimated:YES];
        
        //        [JPUSHService setTags:nil alias:@"uuid" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        //            YJLog(@"TagsAlias回调:%@", iAlias);
        //        }];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}

-(NSString *)calculateSize{
    NSUInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
    NSString *cacheSizeStr = nil;
    if (cacheSize < 1024) {
        cacheSizeStr = [NSString stringWithFormat:@"%.2f B", (float)cacheSize];
    } else if (cacheSize >= 1024 && cacheSize < 1024 * 1024) { // KB
        cacheSizeStr = [NSString stringWithFormat:@"%.2f KB", (float)cacheSize / 1024];
    } else if (cacheSize >= 1024 * 1024 && cacheSize < 1024 * 1024 * 1024) { // MB
        cacheSizeStr = [NSString stringWithFormat:@"%.2f MB", (float)cacheSize / (1024 * 1024)];
    }
    return cacheSizeStr;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) return;
    
    if (indexPath.row==0) {
        if ([AccountTool getAccount:YES]==nil) return;
        [self.navigationController pushViewController:[sb instantiateViewControllerWithIdentifier:@"SingleInfoVC"] animated:YES];
    }else if (indexPath.row==1){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[SDImageCache sharedImageCache] clearMemory];
            self.cacheLabel.text=[self calculateSize];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (indexPath.row==2){
        [self.navigationController pushViewController:[sb instantiateViewControllerWithIdentifier:@"SuggestionsVC"] animated:YES];
    }
}

@end
