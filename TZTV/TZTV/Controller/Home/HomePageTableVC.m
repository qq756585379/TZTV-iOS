//
//  HomePageTableVC.m
//  TZTV
//
//  Created by Luosa on 2016/12/27.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "HomePageTableVC.h"
#import "HomePageCell.h"
#import "HomePageCell2.h"
#import "HomaePageCell3.h"
#import "HomePageHeader.h"
#import "HomePageTool.h"
#import "ShowPictureVC.h"
#import "YJWebViewController.h"
#import "KRVideoPlayerController.h"

@interface HomePageTableVC ()
@property (nonatomic, strong) HomePageTool  *tool;
@property (nonatomic, strong) KRVideoPlayerController *videoController;
@end

@implementation HomePageTableVC

-(HomePageTool *)tool
{
    if (!_tool) {
        _tool=[HomePageTool new];
    }
    return _tool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle=0;
    [self.tableView registerNib:[HomePageCell nib] forCellReuseIdentifier:[HomePageCell cellReuseIdentifier]];
    [self.tableView registerNib:[HomePageCell2 nib] forCellReuseIdentifier:[HomePageCell2 cellReuseIdentifier]];
    [self.tableView registerNib:[HomaePageCell3 nib] forCellReuseIdentifier:[HomaePageCell3 cellReuseIdentifier]];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    [self initData];
}

-(void)initData{
    [MBProgressHUD showMessage:@""];
    [self.tool loadNewDataFromNetwork];
    RACSignal *zipSignal = [self.tool.requestCommand execute:nil];
    [zipSignal subscribeNext:^(id x) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    } completed:^{
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    HomePageCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    currentCell.bannerView.autoRunPage=YES;
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    HomePageCell *currentCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    currentCell.bannerView.autoRunPage=NO;
    self.navigationController.navigationBarHidden=NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==3?[[self images] count]:1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        HomePageCell *cell=[tableView dequeueReusableCellWithIdentifier:[HomePageCell cellReuseIdentifier] forIndexPath:indexPath];
        cell.dataArr=self.tool.zhuboList;
        return cell;
    }else if(indexPath.section==1) {
        UITableViewCell *cell=[[UITableViewCell alloc] init];
        cell.selectionStyle=0;
        UIImageView *imgIV=[[UIImageView alloc] init];//WithFrame:CGRectMake(20, 10, ScreenW-40, 82)
        imgIV.contentMode=UIViewContentModeCenter;
        imgIV.image=[UIImage imageNamed:@"shoping_vouchers"];
        [cell.contentView addSubview:imgIV];
        [imgIV autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 20, 0, 20) excludingEdge:ALEdgeBottom];
        [imgIV autoSetDimension:ALDimensionHeight toSize:82];
        [cell.contentView updateConstraintsIfNeeded];//强制更新约束
        [cell.contentView layoutIfNeeded];//强制刷新界面
        return cell;
    }else if (indexPath.section==2){
        HomePageCell2 *cell=[tableView dequeueReusableCellWithIdentifier:[HomePageCell2 cellReuseIdentifier] forIndexPath:indexPath];
        cell.listModel=[self.tool.LiveList safeObjectAtIndex:0];
        cell.block=^(LiveListModel *listModel){
            NSURL *playerUrl = [NSURL URLWithString:listModel.live_rtmp_play_url];
            [self playVideoWithURL:playerUrl];
//            [self.videoController fullScreenButtonClick];//全屏
        };
        return cell;
    }else{
        HomaePageCell3 *cell=[tableView dequeueReusableCellWithIdentifier:[HomaePageCell3 cellReuseIdentifier] forIndexPath:indexPath];
        cell.titleLabel.text=[[self titles] safeObjectAtIndex:indexPath.row];
        cell.smallIV.image=[[UIImage imageNamed:[NSString stringWithFormat:@"z%ld",indexPath.row+1]] circleImage];
        cell.userNamelabel.text=[[self names] safeObjectAtIndex:indexPath.row];
        cell.categoryLabel.text=[[self categorys] safeObjectAtIndex:indexPath.row];
        cell.bigIV.image=[UIImage imageNamed:[[self icons] safeObjectAtIndex:indexPath.row]];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return [HomePageCell heightForCellData:nil];
    }else if (indexPath.section==1){
        return 100;
    }else if (indexPath.section==2){
        return [HomePageCell2 heightForCellData:nil];
    }else{
        return [HomaePageCell3 heightForCellData:nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return (section==0 || section==1)?0.01:[HomePageHeader heightForCellData:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==2){
        HomePageHeader *header=[HomePageHeader tableHeaderWithTableView:tableView];
        [header setIcon:@"tuijian" andTitle:@"今日推荐"];
        return header;
    }else if (section==3){
        HomePageHeader *header=[HomePageHeader tableHeaderWithTableView:tableView];
        [header setIcon:@"Featured" andTitle:@"精选内容"];
        return header;
    }
    return [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if ([AccountTool getAccount:YES]==nil) return;
        YJWebViewController *web=[YJWebViewController new];
        Account *account=[AccountTool account];
        web.htmlUrl=[NSString stringWithFormat:lingquyouhuiquanhtml,account.telephone,account.user_id];
        web.title=@"优惠券";
        [self.navigationController pushViewController:web animated:YES];
    }
    if (indexPath.section==3) {
        ShowPictureVC *vc=[ShowPictureVC new];
        vc.imageName=[[self images] safeObjectAtIndex:indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//在plist文件中，加入View controller-based status bar appearance项，并设置为NO。这样，就能通过代码来显示&隐藏电量条。
- (void)playVideoWithURL:(NSURL *)url{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            [weakSelf.videoController dismiss];
            weakSelf.videoController = nil;
        }];
        [self.videoController showInWindow];
    }
    self.videoController.contentURL = url;
}

-(NSArray *)images
{
    return @[@"01",@"02",@"03",@"adidas",@"basic_house",@"basic_house2_05",
             @"fila",@"heixie",@"mo&co_05",@"mo&co",@"ochirly1",@"ochirly3"];
}

-(NSArray *)titles
{
    return @[@"ochirly欧时力 纯色羊毛呢大衣长外套",@"Adidas阿迪达斯羽绒服运动外套 女式 2016冬季新款",
             @"Adidas阿迪达斯 2016冬季男子炽风系列运动跑步鞋",@"Adidas阿迪达斯 男式 简约纯色运动保暖羽绒服",
             @"Basic house/百家好韩版时尚保暖收腰羽绒服派克大衣外套",@"Basic House/百家好2016年冬季韩版超长款修身连帽羽绒服外套",
             @"FILA斐乐女羽绒服2016冬季新款长款连帽运动羽绒服外套女款",@"SKECHERS斯凯奇的男女同款D'lites休闲鞋（熊猫鞋）",
             @"MO&Co.罗纹立领中长款工装风双向拉链羽绒服",@"MO&CO美猴王贴布绣V领长款侧开衩口袋针织开衫",
             @"ochirly欧时力毛领长款羽绒外套大衣",@"ochirly欧时力 2016新女冬装卡通图案长款毛呢外套大衣"];
}

-(NSArray *)names
{
    return @[@"沙小V",@"是兔豆丝酱",@"魔法少女九九",@"草莓甘ovo",@"sea.",@"Dear Moon",@"冰淇淋也很甜美",@"晴思",@"小幸运",@"娜娜",@"小G娜",@"蜡笔小新"];
}

-(NSArray *)categorys
{
    return @[@"大衣",@"大衣",@"鞋子",@"大衣",@"大衣",@"大衣",@"大衣",@"鞋子",@"大衣",@"大衣",@"大衣",@"大衣",@"大衣",@"大衣",@"大衣",@"大衣"];
}

-(NSArray *)icons
{
    return @[@"348_232_10",@"348_232_12",@"348_232_11",@"348_232_1",@"348_232_6",@"348_232_7",
             @"348_232_2",@"348_232_9",@"348_232_8",@"348_232_5",@"348_232_3",@"348_232_4"];
}

@end







