//
//  WebViewExample.m
//  XLRefreshExample
//
//  Created by MengXianLiang on 2017/3/28.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "WebViewExample.h"
#import "XLRefresh.h"
@interface WebViewExample ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation WebViewExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[UIView new]];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    _webView.scrollView.xl_header = [XLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMethod)];
}

-(void)refreshMethod{
    [_webView reload];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView.scrollView.xl_header endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
