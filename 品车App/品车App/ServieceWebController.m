//
//  ServieceWebController.m
//  品车App
//
//  Created by fei on 16/11/14.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "ServieceWebController.h"
#import "MBProgressHUD.h"

@interface ServieceWebController ()<UIWebViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *progressHUD;
}
@end

@implementation ServieceWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.navcTitle;
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    NSURL *url = [NSURL URLWithString:self.request];
    web.delegate = self;
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:web];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    progressHUD = [MBProgressHUD showHUDAddedTo:webView animated:YES];
    progressHUD.delegate = self;
    progressHUD.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 64);
    progressHUD.label.text = @"加载中...";
    progressHUD.removeFromSuperViewOnHide = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    progressHUD.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
