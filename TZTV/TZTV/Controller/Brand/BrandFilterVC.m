//
//  BrandFilterVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/17.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "BrandFilterVC.h"
#import "UIViewController+YJ.h"
#import "OTSMask.h"

@interface BrandFilterVC ()
@property (nonatomic, strong) UIButton *emptyBtn;   // 清空筛选
@property (nonatomic, strong) UIButton *confirmBtn; // 确认筛选
@end

@implementation BrandFilterVC

//筛选页面
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"筛选";
    self.view.backgroundColor=[UIColor whiteColor];
    [self setNaviButtonType:NaviButton_Return isLeft:YES];
    [self setNavgationBarBackGroundImage:[UIImage imageWithColor:[UIColor whiteColor]] andShadowImage:[UIImage imageWithColor:kEDEDED]];
}

//重写左边按钮
- (void)leftBtnClicked:(id)sender{
    [self.mask endMask];
}


@end
