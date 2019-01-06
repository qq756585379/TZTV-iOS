//
//  AddressVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/21.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "AddressVC.h"
#import "PlaceHoldView.h"
#import "AddressCell.h"
#import "EditAddressVC.h"
#import "NSArray+safe.h"

@interface AddressVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) PlaceHoldView *placeHoldView;
@property (nonatomic, strong) YJTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation AddressVC

+ (void)load
{
    YJMappingVO *vo = [YJMappingVO new];
    vo.className = NSStringFromClass(self);
    [[YJRouter sharedInstance] registerRouterVO:vo withKey:@"AddressVC"];
}

- (void)viewDidLoad {  
    [super viewDidLoad];
    self.title=@"收货地址";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"添加新地址" textColor:YJNaviColor textFont:YJFont(16) target:self action:@selector(rightAction)];
    [self.view addSubview:self.tableView];
    [self loadAddressList];
}

-(void)loadAddressList{
    Account *account=[AccountTool account];
    [MBProgressHUD showMessage:@""];
//    NSString *url=[NSString stringWithFormat:getAddressListURL,account.pid,account.token];
//    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
//        YJLog(@"%@",json);
//        [MBProgressHUD hideHUD];
//        [self.tableView.mj_header endRefreshing];
//        if ([json[@"code"] isEqualToNumber:@0]) {
//            self.dataArray=[AddressModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
//            [self showPlaceHolderViewWithInfo:@"未添加收获地址" imageName:@"placeholder"
//                                  buttonTitle:@"添加地址" show:self.dataArray.count?NO:YES];
//        }else{
//            [self showPlaceHolderViewWithInfo:json[@"msg"] imageName:@"placeholder"
//                                  buttonTitle:@"刷新" show:self.dataArray.count?NO:YES];
//        }
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUD];
//        [self.tableView.mj_header endRefreshing];
//        [self showPlaceHolderViewWithInfo:@"网络不太好" imageName:@"placeholder"
//                              buttonTitle:@"刷新" show:self.dataArray.count?NO:YES];
//    }];
}

-(void)showPlaceHolderViewWithInfo:(NSString *)info imageName:(NSString *)img buttonTitle:(NSString *)title show:(BOOL)show{
    [self.tableView reloadData];
    if (show) {
        self.tableView.hidden=YES;
        [self.placeHoldView setInfo:info ImgName:img buttonTitle:title];
        [self.view addSubview:self.placeHoldView];
        //[self.placeHoldView autoCenterInSuperview];
        [self.placeHoldView autoPinEdgesToSuperviewEdges];
    }else{
        self.tableView.hidden=NO;
        if (self.placeHoldView) {
            [self.placeHoldView removeFromSuperview];
            self.placeHoldView=nil;
        }
    }
}

//去添加地址页面
-(void)rightAction{
    EditAddressVC *vc=[sb instantiateViewControllerWithIdentifier:@"EditAddressVC"];
    vc.type=AddAddressType;
    vc.block=^(){
        [self loadAddressList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressCell *cell=[tableView dequeueReusableCellWithIdentifier:[AddressCell cellReuseIdentifier] forIndexPath:indexPath];
    cell.model=[self.dataArray safeObjectAtIndex:indexPath.section];
    cell.myBlock=^(){
        [self loadAddressList];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(PlaceHoldView *)placeHoldView
{
    if (_placeHoldView == nil) {
        _placeHoldView = [PlaceHoldView autolayoutView];
        WEAK_SELF
        _placeHoldView.PlaceHoldBlock=^(NSString *buttonTitle){
            if ([buttonTitle isEqualToString:@"添加地址"]) {
                [weakSelf rightAction];
            }else if ([buttonTitle isEqualToString:@"刷新"]){
                [weakSelf loadAddressList];
            }
        };
    }
    return _placeHoldView;
}

-(YJTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[YJTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadAddressList)];
        [_tableView registerNib:[AddressCell nib] forCellReuseIdentifier:[AddressCell cellReuseIdentifier]];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
