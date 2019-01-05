//
//  ChaKanWuLiuVC.m
//  TZTV
//
//  Created by Luosa on 2016/12/5.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ChaKanWuLiuVC.h"
#import "ChaKanWuLiuCell1.h"
#import "ChaKanWuLiuCell2.h"

@interface ChaKanWuLiuVC ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ChaKanWuLiuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"物流详情";
    self.tableView.separatorStyle=1;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self loadNewData];
}

-(void)loadNewData{
    [MBProgressHUD showMessage:@""];
    NSString *url=[[NSString alloc] initWithFormat:getExpressURL,_order.order_no,_order.express_code];
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        YJLog(@"%@",json);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        if ([json[@"code"] isEqualToNumber:@0]) {
            self.dataArray=json[@"data"];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==0?1:self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ChaKanWuLiuCell1 *cell1=[tableView dequeueReusableCellWithIdentifier:[ChaKanWuLiuCell1 cellReuseIdentifier] forIndexPath:indexPath];
        cell1.order=_order;
        return cell1;
    }else{
        ChaKanWuLiuCell2 *cell2=[tableView dequeueReusableCellWithIdentifier:[ChaKanWuLiuCell2 cellReuseIdentifier] forIndexPath:indexPath];
        NSDictionary *dict=[self.dataArray safeObjectAtIndex:indexPath.row];
        NSString *time=dict[@"create_time"];
        cell2.titleLabel.text=dict[@"content"];
        cell2.timeLabel.text=[time safeSubstringToIndex:time.length-2];
        bool isFirst = (indexPath.row == 0);
        bool isLast  = (indexPath.row == self.dataArray.count - 1);
        [cell2 setDataSourceIsFirst:isFirst isLast:isLast];
        return cell2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 110;
    }else{
        NSDictionary *dict=[self.dataArray safeObjectAtIndex:indexPath.row];
        return [ChaKanWuLiuCell2 heightForCellData:dict[@"content"]];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}






@end
