//
//  SearchVC.m
//  TZTV
//
//  Created by Luosa on 2016/11/9.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "SearchVC.h"
#import "CategorySearchBar.h"
#import "UISearchBar+YJ.h"
#import "HomepageTitleView.h"
#import "YJNav.h"
#import "CustomNavSearchView.h"

@interface SearchVC ()<SearchViewDelegate>
@property (nonatomic, strong) CustomNavSearchView *navBar;
@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [(YJNav *)self.navigationController updateNavBarBg:[UIImage imageWithColor:kWhiteColor] andShadowImage:[UIImage imageWithColor:kEDEDED]];
    _navBar=[[CustomNavSearchView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
    _navBar.delegate=self;
    [self.navigationController.navigationBar addSubview:_navBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_navBar.inputTF becomeFirstResponder];
}

#pragma mark - SearchViewDelegate
-(void)cancelSearchClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navBar removeFromSuperview];
    [(YJNav *)self.navigationController updateNavBarBg:[UIImage imageWithColor:YJNaviColor] andShadowImage:[UIImage imageWithColor:kEDEDED]];
}

@end





