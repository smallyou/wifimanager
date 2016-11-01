//
//  WMForumViewController.m
//  WifiManager
//
//  Created by 陈华 on 16/10/18.
//  Copyright © 2016年 陈华. All rights reserved.
//

#import "WMForumViewController.h"

@interface WMForumViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;


@end

@implementation WMForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://sundraygd.sinaapp.com"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
    
    self.webView.delegate = self;
    self.webView.hidden = YES;
    
    
    
    
}


#pragma mark - UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return  YES;
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
   
    [SVProgressHUD showWithStatus:@"加载中..."];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    self.webView.hidden = NO;
    [SVProgressHUD dismiss];
    
}



-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}




@end
