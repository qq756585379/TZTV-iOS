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

@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSArray *)titleArr{
    return @[@"我的订单",@"我的关注",@"优惠券",@"收货地址",@"个人资料",@"客服中心",@"关于兔子"];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else if (section==1){
        return 5;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        MeCell1 *cell1=[tableView dequeueReusableCellWithIdentifier:@"MeCell1"];
        cell1.account=[AccountTool account];
        return cell1;
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            MeCell2 *cell2=[tableView dequeueReusableCellWithIdentifier:@"MeCell2"];
            return cell2;
        }else{
            MeCell3 *cell3=[tableView dequeueReusableCellWithIdentifier:@"MeCell3"];
            cell3.leftLabel.text=[self titleArr][indexPath.row];
            cell3.rightLabel.text=@"";cell3.moreIV.hidden=NO;
            return cell3;
        }
    }else{
        MeCell3 *cell3=[tableView dequeueReusableCellWithIdentifier:@"MeCell3"];
        cell3.leftLabel.text=[self titleArr][5+indexPath.row];
        if(indexPath.row==0){
            cell3.rightLabel.text=@"1515";cell3.moreIV.hidden=YES;
        }else{
            cell3.rightLabel.text=@"";cell3.moreIV.hidden=NO;
        }
        return cell3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 92;
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            return 95;
        }else{
            return 50;
        }
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([AccountTool getAccount:YES]==nil) {
        return;
    }
}


@end
