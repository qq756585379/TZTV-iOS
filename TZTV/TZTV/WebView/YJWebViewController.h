//
//  YJWebViewController.h
//  TZTV
//
//  Created by Luosa on 2016/12/27.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface YJWebViewController : UIViewController

// http://www.jianshu.com/p/6ba2507445e4

@property (nonatomic,   copy) NSString *htmlUrl;

@property (nonatomic,strong) WKWebView *webView;

-(void)loadUrl:(NSString *)url;

@end
