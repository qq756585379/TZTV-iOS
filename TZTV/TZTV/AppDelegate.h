//
//  AppDelegate.h
//  TZTV
//
//  Created by Luosa on 2016/11/7.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UIWindow *topWindow;

- (void)endEditing;

//在plist文件中，加入View controller-based status bar appearance项，并设置为NO。这样，就能通过代码来显示&隐藏电量条。

//RAC(_loginBtn,enabled) = [RACSignal combineLatest:@[_TelTF.rac_textSignal,
//                                                    _PwdTF.rac_textSignal]
//                                           reduce:^id(NSString *telStr,NSString *pwdStr){
//                                               return @([telStr isPhoneNo] && pwdStr.length>=6);
//                                           }];


//[[_TF1.rac_textSignal filter:^BOOL(id value) {
//    // value:源信号的内容
//    // 返回值,就是过滤条件,只有满足这个条件,才能能获取到内容
//    return  [value length] == 11;
//}] subscribeNext:^(id x) {
//    YJLog(@"%@",x);
//}];

//[self.tagView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

//    [self.view updateConstraintsIfNeeded];//强制更新约束
//    [self.view layoutIfNeeded];//强制刷新界面

//[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];

/**
 * setNeedsDisplay方法 : 会在恰当的时刻自动调用drawRect:方法
 * setNeedsLayout方法 : 会在恰当的时刻调用layoutSubviews方法
 */

//[self.placeHoldView autoCenterInSuperview];
//[self.placeHoldView autoPinEdgesToSuperviewEdges];

/*
 typedef NS_ENUM(NSUInteger, YouHuiJuanType) {
 YouHuiJuanTypeXianShang   = 1,
 YouHuiJuanTypeXianXia     = 2
 };
 */

/**
 self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, titleViewW, 32)];
 self.searchBar.delegate = self;
 self.searchBar.placeholder = @"请输入要搜索的文字";
 self.searchBar.showsCancelButton = NO;
 self.searchBar.returnKeyType = UIReturnKeySearch;
 self.searchBar.backgroundColor = [UIColor clearColor];
 self.searchBar.backgroundImage = [UIImage new];
 UITextField *searBarTextField = [self.searchBar valueForKey:@"_searchField"];
 if (searBarTextField){
 [searBarTextField setBackgroundColor:kClearColor];
 searBarTextField.borderStyle = UITextBorderStyleRoundedRect;
 searBarTextField.layer.cornerRadius = 5.0f;
 }else{
 [self.searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:kClearColor] forState:UIControlStateNormal];
 }
 [titleView addSubview:self.searchBar];
 self.navigationItem.titleView = titleView;
 
 [self.searchBar becomeFirstResponder];
 [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:YJNaviColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateNormal];
 [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:@"取消"];
 //[[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor redColor]];
 */
@end

