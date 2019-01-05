//
//  MyOrderCell3.m
//  TZTV
//
//  Created by Luosa on 2016/11/22.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "MyOrderCell3.h"
#import "ChaKanWuLiuVC.h"
#import "ChaKanWuLiuVC.h"
#import "ConfirmOrderVC2.h"

@interface MyOrderCell3()
@property (weak, nonatomic) IBOutlet UIButton *ckwlBtn;//左边按钮
@property (weak, nonatomic) IBOutlet UIButton *qrshBtn;//右边按钮
@property (weak, nonatomic) IBOutlet UILabel  *desLabel;
@property (weak, nonatomic) IBOutlet UILabel  *totalMoneyLabel;
@end

@implementation MyOrderCell3

// 订单状态；-1：已关闭，0：待付款，1：待发货，2：待收货，3：已完成，4：退款中，5：已退款，6：已提货显示待收货
+(CGFloat)heightForCellData:(id)aData
{
    MyOrder *order=aData;
    if (order.order_state==-1 || order.order_state==4 || order.order_state==5 || order.order_state==3) {
        return 40;
    }
    return 80;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_qrshBtn doBorderWidth:1 color:YJNaviColor cornerRadius:5];
    [_ckwlBtn doBorderWidth:1 color:kEDEDED cornerRadius:5];
}

// 订单状态；-1：已关闭，0：待付款，1：待发货，2：待收货，3：已完成，4：退款中，5：已退款，6：已提货
-(void)setOrder:(MyOrder *)order
{
    _order=order;
    _desLabel.text=[NSString stringWithFormat:@"共%ld件商品",order.goodsList.count];
    _totalMoneyLabel.text=[NSString stringWithFormat:@"￥%@(含运费:￥%@元)",order.order_price,order.express_price];
    
    if (order.order_state==0) {         //待付款
        _bottomView.hidden=NO;
        _ckwlBtn.hidden=NO;
        _qrshBtn.hidden=NO;
        [_ckwlBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_qrshBtn setTitle:@"去付款" forState:UIControlStateNormal];
    }else if(order.order_state==1){     //待发货
        _bottomView.hidden=NO;
        _ckwlBtn.hidden=YES;
        _qrshBtn.hidden=NO;
        [_qrshBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
    }else if (order.order_state==2 || order.order_state==6){//待收货
        _bottomView.hidden=NO;
        _ckwlBtn.hidden=NO;
        _qrshBtn.hidden=NO;
        [_ckwlBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [_qrshBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    }else if (order.order_state==3){    //已完成
        _bottomView.hidden=YES;
    }else if (order.order_state==-1){   //交易关闭
        _bottomView.hidden=YES;
    }else if (order.order_state==4){    //退款中
        _bottomView.hidden=YES;
    }else if (order.order_state==5){    //已退款
        _bottomView.hidden=YES;
    }
}

//所有按钮点击事件
- (IBAction)allClickedAction:(UIButton *)sender
{
    Account *account=[AccountTool account];
    if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
//        [AlertViewManager alertWithTitle:@"取消订单" message:nil leftBtn:@"取消" rightBtn:@"确定" andCompleteBlock:^(NSInteger buttonIndex) {
//            [self cancelOrder:account];
//        }];
    }else if ([sender.titleLabel.text isEqualToString:@"确认收货"]){
//        [AlertViewManager alertWithTitle:@"确认收货" message:nil leftBtn:@"取消" rightBtn:@"确定" andCompleteBlock:^(NSInteger buttonIndex) {
//            [self confirmReceive:account];
//        }];
    }else if ([sender.titleLabel.text isEqualToString:@"去付款"]){
        ConfirmOrderVC2 *vc2=[sb instantiateViewControllerWithIdentifier:@"ConfirmOrderVC2"];
        vc2.order=_order;
        vc2.type=ConfirmOrderTypeFromMyOrderSon;
        [[YJTOOL getRootControllerSelectedVc] pushViewController:vc2 animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"提醒发货"]){
        
    }else if ([sender.titleLabel.text isEqualToString:@"查看物流"]){
        ChaKanWuLiuVC *vc=[sb instantiateViewControllerWithIdentifier:@"ChaKanWuLiuVC"];
        vc.order=_order;
        [[YJTOOL getRootControllerSelectedVc] pushViewController:vc animated:YES];
    }
}

//取消订单
-(void)cancelOrder:(Account *)account
{
    NSString *url=[NSString stringWithFormat:cancelOrderURL,account.user_id,_order.ID,account.token];
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            [MBProgressHUD showSuccess:@"取消成功"];
            if (self.block) self.block();//回调刷新数据
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"当前网络不太好"];
    }];
}

//确认收货
-(void)confirmReceive:(Account *)account
{
    NSString *url=[NSString stringWithFormat:confirmReceiveURL,account.user_id,_order.ID,account.token];
    [[YJHttpRequest sharedManager] get:url params:nil success:^(id json) {
        YJLog(@"%@",json);
        if ([json[@"code"] isEqualToNumber:@0]) {
            if (self.block) self.block();//回调刷新数据
        }else{
            [MBProgressHUD showError:json[@"msg"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"当前网络不太好"];
    }];
}

@end
