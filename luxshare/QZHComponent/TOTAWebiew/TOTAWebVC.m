//
//  DDWebVC.m
//  DDSample
//
//  Created by 黄振 on 2020/3/25.
//  Copyright © 2020 KingYellow. All rights reserved.
//

#import "TOTAWebVC.h"
#import <WebKit/WebKit.h>

@interface TOTAWebVC ()
@property (copy, nonatomic)WKWebView *webView;
@end

@implementation TOTAWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QZH_KIT_Color_WHITE_100;
    self.navigationItem.title = @"帮助详情";
    [self UIConfig];
    [self loadUrl];
}
- (void)UIConfig{
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, QZHHeightBottom, 0));
    }];
}
- (void)loadUrl {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)self.urlString,
                                                                                                    (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                                    NULL,
                                                                                                    kCFStringEncodingUTF8));
    NSURL *url = [NSURL URLWithString:encodedString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}
#pragma mark -lazy
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
    }
    return _webView;
}

@end
