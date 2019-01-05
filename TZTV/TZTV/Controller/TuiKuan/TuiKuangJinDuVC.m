//
//  TuiKuangJinDuVC.m
//  TZTV
//
//  Created by Luosa on 2016/12/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "TuiKuangJinDuVC.h"

@implementation TuiKuangJinDuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviButtonType:NaviButton_Return isLeft:YES];
}

- (void)leftBtnClicked:(id)sender
{
    if (_type==TypeFromShenQingTuiKuanVC) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2]
                                              animated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section==0?170:360;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
@end
