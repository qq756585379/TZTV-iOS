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

+ (void)load
{
    YJMappingVO *vo = [YJMappingVO new];
    vo.className = NSStringFromClass(self);
    vo.createdType = YJMappingClassCreateByStoryboard;
    [[YJRouter sharedInstance] registerRouterVO:vo withKey:@"SettingVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    self.tableView.separatorStyle=1;
    NSString *key = @"CFBundleShortVersionString";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    self.versionLabel.text=[NSString stringWithFormat:@"V%@",currentVersion];
    self.cacheLabel.text=[self calculateSize];
    [self.logOutBtn doBorderWidth:1 color:HEXRGBCOLOR(0x999999) cornerRadius:21];
}

#pragma mark - 退出登录
- (IBAction)logoutClicked:(UIButton *)sender
{
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    return footer;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) return;
    
    if (indexPath.row==0) {
        if ([AccountTool account]) {
            [YJRouter routeToDestVc:@"SingleInfoVC" from:self extraData:nil];
        }else{
            [MBProgressHUD showToast:@"您还没有登录，请q先登录"];
        }
    }else if (indexPath.row==1){
        [YJAlertView alertWithTitle:@"清除缓存" message:nil leftBtn:@"取消" rightBtn:@"确认" andCompleteBlock:^(NSInteger buttonIndex) {
            [[SDImageCache sharedImageCache] clearMemory];
            self.cacheLabel.text = [self calculateSize];
        }];
    }else if (indexPath.row==2){
        [YJRouter routeToDestVc:@"SuggestionsVC" from:self extraData:nil];
    }
}

-(NSString *)calculateSize
{
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

@end
