//
//  DetailBrowserView.h
//  TZTV
//
//  Created by Luosa on 2016/11/16.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OTSWebView;
@class OTSToolbar;
@class DetailBrowserView;

@protocol OTSBrowserViewDelegate
@optional
- (void)browserView:(DetailBrowserView *)browserView returnBtnClicked:(id)sender;

- (void)webViewOfBrowserViewDidStartLoad:(UIWebView *)webView;

- (void)webViewOfBrowserViewDidFinishLoad:(UIWebView *)webView;

- (void)webViewOfBrowser:(UIWebView *)webView didFailLoadWithError:(NSError *)error;

- (BOOL)webViewOfBrowserView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

- (void)shareBtnClicked:(id)sender;

//webView滚动的协议方法
- (void)webViewDidScroll:(UIScrollView *)scrollView;
- (void)webViewEndDragging:(UIScrollView *)scrollView;
@end

@interface DetailBrowserView : UIView

@property(nonatomic, strong) NSString   *currentUrl; //当前页面的URL;
@property(nonatomic, strong) NSString   *htmlString; //当前页面的html语句
@property(nonatomic, strong) OTSWebView *safeWebView;
@property(nonatomic, weak)  id delegate;
@property(assign)BOOL  zoomScale;
/**
 *  功能:初始化
 *  url:进入时的url
 *  返回值:当前对象
 */
- (id)initWithFrame:(CGRect)frame toolbar:(OTSToolbar *)aToolbar url:(NSString *)aUrl delegate:(id<OTSBrowserViewDelegate>)aDelegate;

/**
 *  功能:加载页面
 *  aHtmlString:加载的html
 *  返回值:当前对象
 */

- (void)loadHTMLString:(NSString *)htmlString;

@end

@protocol OTSToolbarDelegate <NSObject>
@optional
- (void)returnBtnClicked:(id)sender;

- (void)backwardBtnClicked:(id)sender;

- (void)forwardBtnClicked:(id)sender;

- (void)refreshBtnClicked:(id)sender;

- (void)shareBtnClicked:(id)sender;

#pragma mark - iPad相关代理
- (void)shrinkBtnClicked:(id)sender;
@end

@interface OTSToolbar : UIToolbar
@property(nonatomic, weak) id<OTSToolbarDelegate> theDelegate;
@property(nonatomic, strong) UIBarButtonItem *backwardItem;
@property(nonatomic, strong) UIBarButtonItem *forwardItem;
@end

