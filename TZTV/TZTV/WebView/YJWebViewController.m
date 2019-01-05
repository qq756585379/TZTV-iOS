//
//  YJWebViewController.m
//  TZTV
//
//  Created by Luosa on 2016/12/27.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "YJWebViewController.h"
#import "YJWebViewProgressView.h"

@interface YJWebViewController ()<WKNavigationDelegate,UIWebViewDelegate>
@property (nonatomic,strong) YJWebViewProgressView *webProgressView;
@end

@implementation YJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.navigationDelegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.scrollView.backgroundColor = [UIColor whiteColor];
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:self.webView];
    
    if (_htmlUrl) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlUrl]];
        [self.webView loadRequest:request];
    }
    [self.webView setNeedsUpdateConstraints];
    
    CGFloat progressBarHeight = 2.f;
    _webProgressView = [[YJWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, progressBarHeight)];
    _webProgressView.progressBarColor = [UIColor orangeColor];
    _webProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_webProgressView];
    
    [self addObservers];
}

- (void)addObservers {
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    //[_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    //[_webView removeObserver:self forKeyPath:@"title"];
    [_webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.webView) {
            [self.webProgressView setProgress:self.webView.estimatedProgress animated:YES];
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView) {
            self.title = self.webView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"contentSize"]){
        if (object == self.webView.scrollView) {
            //self.scrollView.contentSize = self.webView.scrollView.contentSize;
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)loadUrl:(NSString *)url{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - WebView Delegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self.webProgressView setProgress:0 animated:YES];
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}



@end
