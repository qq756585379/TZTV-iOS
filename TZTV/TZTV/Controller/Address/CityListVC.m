//
//  CityListVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/11.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "CityListVC.h"
#import "CityListCell.h"
#import "MapManager.h"
#import "CityListHeader.h"

@interface CityListVC ()
@property (strong, nonatomic) NSMutableArray *cityArr;
@property (nonatomic, strong) NSMutableArray *locationArr;
@property (nonatomic, strong) NSMutableArray *recentCityArr;
@end

@implementation CityListVC

-(NSMutableArray *)cityArr{
    if (!_cityArr) {
        _cityArr=[NSMutableArray array];
    }
    return _cityArr;
}
-(NSMutableArray *)recentCityArr{
    if (!_recentCityArr) {
        _recentCityArr=[NSMutableArray array];
    }
    return _recentCityArr;
}
-(NSMutableArray *)locationArr{
    if (!_locationArr) {
        _locationArr=[NSMutableArray array];
    }
    return _locationArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"城市选择";
    self.view.backgroundColor=kF5F5F5;
    [self.tableView registerNib:[CityListCell nib] forCellReuseIdentifier:[CityListCell cellReuseIdentifier]];
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    [self startLocation];
}

-(void)startLocation{
    [[MapManager sharedManager] startWithCompleteBlock:^(CLPlacemark *mark, NSDictionary *addressDictionary, CLLocation *aLocation) {
        if (mark==nil || aLocation==nil) {
            return;
        }
        [self.locationArr removeAllObjects];
        [self.locationArr addObject:mark.locality];
        [self.locationArr addObject:mark.subLocality];
        [self.tableView reloadData];
    }];
}

-(void)loadData{
    [MBProgressHUD showMessage:@""];
    [[YJHttpRequest sharedManager] get:getOpenCityListURL params:nil success:^(id json) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUD];
        if ([json[@"code"] isEqualToNumber:@0]) {
            YJLog(@"%@",json);
            [self.cityArr removeAllObjects];
            for (NSDictionary *dict in json[@"data"]) {
                [self.cityArr addObject:dict[@"city_name"]];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showToast:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }else{
        return self.recentCityArr.count?3:2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return nil;
    }else{
        if (indexPath.row==0) {
            CityListCell *cell=[tableView dequeueReusableCellWithIdentifier:[CityListCell cellReuseIdentifier]];
            if (self.locationArr.count==0) {
                cell.cityArray=@[@"定位中"];
            }else{
                cell.cityArray=self.locationArr;
            }
            cell.headerLabel.text=@"已定位城市";
            return cell;
        }
        if (self.recentCityArr.count && indexPath.row==1) {
            CityListCell *cell=[tableView dequeueReusableCellWithIdentifier:[CityListCell cellReuseIdentifier]];
            cell.cityArray=self.recentCityArr;
            cell.headerLabel.text=@"最近访问城市";
            return cell;
        }
        CityListCell *cell=[tableView dequeueReusableCellWithIdentifier:[CityListCell cellReuseIdentifier]];
        cell.cityArray=self.cityArr;
        cell.headerLabel.text=@"热门城市";
        return cell;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 0;
    }else{
        if (indexPath.row==0) {
            return [CityListCell heightForCellData:self.locationArr];
        }
        if (self.recentCityArr.count && indexPath.row==1) {
            return [CityListCell heightForCellData:self.recentCityArr];
        }
        return [CityListCell heightForCellData:self.cityArr];
    }
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        CityListHeader *headerView=[CityListHeader tableHeaderWithTableView:tableView];
        headerView.headerLabel.text=@"当前：上海-全城";
        return headerView;
    }else{
        return nil;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0?30:0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

@end
