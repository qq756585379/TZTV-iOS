//
//  MeViewController.m
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MeViewController.h"
#import "MeCell1.h"
#import "MeCell2.h"
#import "MeCell3.h"
#import "AccountTool.h"
#import "JhtFloatingBall.h"

@interface MeViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,   weak) JhtFloatingBall *floatBoll;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = kF5F5F5;
    [self addFolatingball];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(NSArray *)titleArr
{
    return @[@"客服中心",@"收货地址",@"关于兔子",@"设置",@"开启直播"];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section==1){
        return 1;
    }else{
        Account *account = [AccountTool account];//1显示
        return account.user_type == 1 ? 5 : 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        MeCell1 *cell1=[tableView dequeueReusableCellWithIdentifier:[MeCell1 cellReuseIdentifier] forIndexPath:indexPath];
        cell1.account=[AccountTool account];
        return cell1;
    }else if (indexPath.section==1){
        MeCell2 *cell2=[tableView dequeueReusableCellWithIdentifier:[MeCell2 cellReuseIdentifier] forIndexPath:indexPath];
        return cell2;
    }else{
        MeCell3 *cell3=[tableView dequeueReusableCellWithIdentifier:[MeCell3 cellReuseIdentifier] forIndexPath:indexPath];
        cell3.leftLabel.text=[[self titleArr] safeObjectAtIndex:indexPath.row];
        cell3.rightLabel.text=indexPath.row==0?@"021-68411796":@"";
        cell3.moreIV.hidden=(indexPath.row==0);
        return cell3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return [MeCell1 heightForCellData:nil];
    }else if (indexPath.section==1){
        return [MeCell2 heightForCellData:nil];
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 2 ? 0.1 : 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.section * 10 + indexPath.row) {
        case 0:{
            if ([AccountTool getAccount:YES] == nil) return;
            [YJRouter routeToDestVc:@"SingleInfoVC" from:self extraData:nil];
        }
            break;
        case 20:
            [self makeCall];
            break;
        case 21:{//收货地址
            if ([AccountTool getAccount:YES] == nil) return;
            [YJRouter routeToDestVc:@"AddressVC" from:self extraData:nil];
        }
            break;
        case 22://关于兔子h5页面
        {
//            YJWebViewController *web=[YJWebViewController new];
//            web.htmlUrl=aboutTZ_URL;
//            web.title=@"关于兔子";
//            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        case 23://设置
            [YJRouter routeToDestVc:@"SettingVC" from:self extraData:nil];
            break;
        case 24:{
            [YJRouter routeToDestVc:@"StartZhiBoTableVC" from:self extraData:nil];
        }
            break;
        default:
            break;
    }
}

-(void)makeCall
{
#if !TARGET_IPHONE_SIMULATOR
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:@"tel:021-68411796"];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
#endif
}

#pragma mark - 添加addFolatingball
- (void)addFolatingball
{
    JhtFloatingBall *fb = [[JhtFloatingBall alloc] init];
    UIImage *suspendedBallImage = [UIImage imageNamed:@"logo_136_139"];
    fb.frame = CGRectMake(ScreenW-suspendedBallImage.size.width, ScreenH/2, suspendedBallImage.size.width, suspendedBallImage.size.height);
    fb.image = suspendedBallImage;
    fb.stayAlpha = 0.7;
    fb.stayMode = stayMode_OnlyLeftAndRight;
    [YJWindow addSubview:fb];
    self.floatBoll=fb;
    UITapGestureRecognizer *fbGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fbTap:)];
    fbGesture.delegate = self;
    [fb addGestureRecognizer:fbGesture];
}

/** fb点击 事件 */
- (void)fbTap:(UITapGestureRecognizer *)ges
{
    self.floatBoll.hidden=YES;
    [YJRouter routeToDestVc:@"StartZhiBoTableVC" from:self extraData:nil];
}

@end



