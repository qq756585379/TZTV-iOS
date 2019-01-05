//
//  SquareVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/16.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "SquareVC.h"
#import "SqureHeadView.h"
#import "SqureCell.h"
#import "SqureCell2.h"

@interface SquareVC ()
@property (nonatomic, strong) SqureHeadView *headView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SquareVC

-(SqureHeadView *)headView
{
    if (!_headView) {
        _headView=[[SqureHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 300)];
    }
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"推荐";
    self.tableView.tableHeaderView = self.headView;
    [self.tableView registerNib:[SqureCell nib] forCellReuseIdentifier:[SqureCell cellReuseIdentifier]];
    [self.tableView registerNib:[SqureCell2 nib] forCellReuseIdentifier:[SqureCell2 cellReuseIdentifier]];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_big"] style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    [self loadData];
}

-(void)loadData{
    [[YJHttpRequest sharedManager] get:getRecommendURL params:nil success:^(id json) {
        YJLog(@"%@",json);
    } failure:^(NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        SqureCell *cell=[tableView dequeueReusableCellWithIdentifier:[SqureCell cellReuseIdentifier] forIndexPath:indexPath];
        return cell;
    }
    SqureCell2 *cell2=[tableView dequeueReusableCellWithIdentifier:[SqureCell2 cellReuseIdentifier] forIndexPath:indexPath];
    return cell2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.row==0?80:100;
}

@end
