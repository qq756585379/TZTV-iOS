//
//  MyOrderDetailVC.m
//  TZTV
//
//  Created by Luosa on 2016/12/6.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrderDetailVC.h"
#import "OrderDetailCell.h"
#import "OrderDetailCell2.h"
#import "OrderDetailCell3.h"
#import "ConfirmOrderCell0.h"
#import "ConfirmOrderHeader.h"

@interface MyOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@end

@implementation MyOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"订单详情";
    self.tableView.backgroundColor=kF5F5F5;
    [_btn1 doBorderWidth:1 color:kEDEDED cornerRadius:5];
    [_btn2 doBorderWidth:1 color:kEDEDED cornerRadius:5];
    [self.tableView registerNib:[ConfirmOrderCell0 nib] forCellReuseIdentifier:[ConfirmOrderCell0 cellReuseIdentifier]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==1?_order.goodsList.count+1:1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        OrderDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:[OrderDetailCell cellReuseIdentifier] forIndexPath:indexPath];
        cell.order=_order;
        return cell;
    }else if (indexPath.section==1){
        if (indexPath.row < _order.goodsList.count) {//商品详情
            ConfirmOrderCell0 *cell0=[tableView dequeueReusableCellWithIdentifier:[ConfirmOrderCell0 cellReuseIdentifier] forIndexPath:indexPath];
            MyOrderSon *orderSon=[_order.goodsList safeObjectAtIndex:indexPath.row];
            cell0.orderSon=orderSon;
            if (indexPath.row==_order.goodsList.count-1) {
                if (_order.order_state==3 && orderSon.goods_state==0) {//订单已完成并且商品的状态是正常的，显示退款按钮
                    cell0.bottomView.hidden=NO;//显示退款按钮
                }else{
                    cell0.bottomView.hidden=YES;//不显示退款按钮
                }
            }
            return cell0;
        }else{
            OrderDetailCell2 *cell2=[tableView dequeueReusableCellWithIdentifier:[OrderDetailCell2 cellReuseIdentifier] forIndexPath:indexPath];
            cell2.order=_order;
            return cell2;
        }
    }else{
        OrderDetailCell3 *cell3=[tableView dequeueReusableCellWithIdentifier:[OrderDetailCell3 cellReuseIdentifier] forIndexPath:indexPath];
        cell3.order=_order;
        return cell3;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        ConfirmOrderHeader *header=[ConfirmOrderHeader tableHeaderWithTableView:tableView];
        header.label.text=_order.brand_name;
        [header.iconIV sd_setImageWithURL:[NSURL URLWithString:_order.brand_img] placeholderImage:[UIImage imageNamed:@"placehold_160"]];
        return header;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return [OrderDetailCell heightForCellData:nil];
    }else if (indexPath.section==1){
        if (indexPath.row==0) {
            MyOrderSon *orderSon=[_order.goodsList safeObjectAtIndex:indexPath.row];
            NSMutableArray *arr=[NSMutableArray arrayWithObjects:_order,orderSon, nil];
            return [ConfirmOrderCell0 heightForCellData:[arr copy]];
        }else{
            return [OrderDetailCell2 heightForCellData:nil];
        }
    }else{
        return [OrderDetailCell3 heightForCellData:nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==1?44:0.1;
}



@end



