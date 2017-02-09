//
//  StoreDetailViewController.m
//  品车App
//
//  Created by zt on 2016/11/3.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface StoreDetailViewController ()<UIWebViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *progressHUD;
    UIWebView *web;

}
@end

@implementation StoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.navcTitle;
    

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 15, 10);
    [button setImage:[[UIImage imageNamed:@"back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(WebViewBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBtn;
    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];

    if(![[NSUserDefaults standardUserDefaults]valueForKey:USER_NAME]){
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(login)];
        right.tintColor = [UIColor colorWithRed:249/255.0 green:66/255.0 blue:71/255.0 alpha:1];
        self.navigationItem.rightBarButtonItem = right;
        
    }


    [self.view addSubview:web];
    web.delegate = self;
    if (self.url.length != 0) {
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        progressHUD = [MBProgressHUD showHUDAddedTo:web animated:YES];
        progressHUD.delegate = self;
        progressHUD.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 64);
        progressHUD.label.text = @"加载中...";
        progressHUD.removeFromSuperViewOnHide = YES;

    }
    
    
}
-(void)login{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginViewController *login = [[LoginViewController alloc]init];
    app.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:login];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    progressHUD.hidden = YES;
}

-(void)WebViewBack
{
    if ([web canGoBack]) {
        [web goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
