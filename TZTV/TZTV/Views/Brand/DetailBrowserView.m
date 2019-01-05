//
//  DetailBrowserView.m
//  TZTV
//
//  Created by Luosa on 2016/11/16.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "DetailBrowserView.h"
#import "NSString+safe.h"
#import "OTSWebView.h"

//iPad中CMS和进口馆的导航栏不同，用来区别
static BOOL isFromCMS;
@interface DetailBrowserView()<UIWebViewDelegate,UIScrollViewDelegate,OTSToolbarDelegate>
@property(nonatomic, strong) NSMutableArray *URLArray;
@property(nonatomic, strong) OTSToolbar     *toolbar;
@property(nonatomic, assign) BOOL holdWhenInit;//初始化时，是否hold住不加载url，默认加载
@end

@implementation DetailBrowserView

- (id)initWithFrame:(CGRect)frame toolbar:(OTSToolbar *)aToolbar url:(NSString *)aUrl delegate:(id<OTSBrowserViewDelegate>)aDelegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.toolbar = aToolbar;
        if(aUrl)
            self.currentUrl = [[NSString alloc] safeInitWithString:aUrl];
        self.delegate = aDelegate;
        
        /*WithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-self.toolbar.frame.size.height)*/
        self.safeWebView = [[OTSWebView alloc] init];
        self.safeWebView.backgroundColor = [UIColor clearColor];
        [self.safeWebView setDelegate:self];
        [self.safeWebView setDataDetectorTypes:UIDataDetectorTypeNone];
        self.safeWebView.delegate = self;
        self.safeWebView.scrollView.delegate = self;
        self.safeWebView.scrollView.showsHorizontalScrollIndicator = NO;
        
        [self.safeWebView setScalesPageToFit:YES];
        if (self.currentUrl && !self.holdWhenInit) {
            [self.safeWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.currentUrl]]];
        }
        [self addSubview:self.safeWebView];
        
        [self.toolbar setTheDelegate:self];
        [self addSubview:self.toolbar];
        [self updateToolbarState];
        
        [self setUpSubviewsForDevice:frame];
    }
    return self;
}

- (void)setUpSubviewsForDevice:(CGRect)frame {
    self.safeWebView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height-self.toolbar.frame.size.height);
    self.toolbar.frame = CGRectMake(0, self.safeWebView.frame.size.height, frame.size.width, self.toolbar.frame.size.height);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.safeWebView.width = self.width;
    self.safeWebView.height = self.height - self.toolbar.height;
    self.toolbar.top = self.safeWebView.bottom;
    self.toolbar.width = self.width;
}

- (void)loadHTMLString:(NSString *)htmlString{
    if (self.safeWebView != nil) {
        [self.safeWebView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    }
}

/**
 *  功能:刷新tool bar的状态
 */
- (void)updateToolbarState{
    UIImage *image;
    if ([self.safeWebView canGoBack]) {
        if (isFromCMS) {
            image = [UIImage imageNamed:@"pad_cms_back"];
        }else {
            image = [UIImage imageNamed:@"last"];
        }
        [(UIButton*)self.toolbar.backwardItem.customView setImage:image forState:UIControlStateNormal];
        [self.toolbar.backwardItem setEnabled:YES];
    } else {
        if (isFromCMS) {
            image = [UIImage imageNamed:@"pad_cms_back"];
        }else {
            image = [UIImage imageNamed:@"last_gray"];
        }
        [(UIButton*)self.toolbar.backwardItem.customView setImage:image forState:UIControlStateNormal];
        [self.toolbar.backwardItem setEnabled:NO];
    }
    if ([self.safeWebView canGoForward]) {
        if (isFromCMS) {
            image = [UIImage imageNamed:@"pad_cms_forward"];
        }else {
            image = [UIImage imageNamed:@"next"];
        }
        [(UIButton*)self.toolbar.forwardItem.customView setImage:image forState:UIControlStateNormal];
        [self.toolbar.forwardItem setEnabled:YES];
    } else {
        if (isFromCMS) {
            image = [UIImage imageNamed:@"pad_cms_forward"];
        }else {
            image = [UIImage imageNamed:@"next_gray"];
        }
        [(UIButton*)self.toolbar.forwardItem.customView setImage:image forState:UIControlStateNormal];
        [self.toolbar.forwardItem setEnabled:NO];
    }
}

#pragma mark WebView_ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(webViewDidScroll:)]) {
        [self.delegate webViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.delegate respondsToSelector:@selector(webViewEndDragging:)]) {
        [self.delegate webViewEndDragging:scrollView];
    }
}
#pragma mark - webViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    if ([self.delegate respondsToSelector:@selector(webViewOfBrowserViewDidStartLoad:)]) {
        [self.delegate webViewOfBrowserViewDidStartLoad:webView];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([self.delegate respondsToSelector:@selector(webViewOfBrowserViewDidFinishLoad:)]) {
        [self.delegate webViewOfBrowserViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}

@end
