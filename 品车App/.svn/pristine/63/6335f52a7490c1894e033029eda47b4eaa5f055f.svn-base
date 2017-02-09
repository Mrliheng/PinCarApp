//
//  DetailViewController.m
//  品车App
//
//  Created by fei on 16/11/7.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"

@interface DetailViewController ()<UIWebViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *progressHUD;
    UIButton *likeBtn;
    UIButton *zanBtn;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createData];
    [self createItem];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl]]];
    [self.view addSubview:webView];
    
    progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.delegate = self;
    progressHUD.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-64);
    progressHUD.label.text = @"加载中...";
    progressHUD.removeFromSuperViewOnHide = YES;
    
}
-(void)createData{
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    NSDictionary *param = @{@"fid":self.fildId};
//    [manager GET:[NSString stringFollowBaseUrl:platetimURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        if ([[responseObject objectForKey:@"msg"]isEqualToString:@"success"]) {
//            NSArray *tempArr = [responseObject objectForKey:@"data"];
//            if (tempArr.count > 0) {
//                self.titleReauleArr = [NSArray arrayWithArray:tempArr];
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
}
-(void)createItem{
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"19-4"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(0, 0, 65, 40);
    
    likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeBtn setImage:[UIImage imageNamed:@"19-3"] forState:UIControlStateNormal];
    likeBtn.frame = CGRectMake(0, 0, 65, 40);
    [likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)self.likeNum] forState:UIControlStateNormal];
    [likeBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, likeBtn.imageView.bounds.size.width+1, 0, 0)];
    [likeBtn addTarget:self action:@selector(likeIt) forControlEvents:UIControlEventTouchUpInside];

    
    zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zanBtn setImage:[UIImage imageNamed:@"19-2"] forState:UIControlStateNormal];
    zanBtn.frame = CGRectMake(0, 0, 65, 40);
    [zanBtn setTitle:[NSString stringWithFormat:@"%ld",(long)self.supportNum] forState:UIControlStateNormal];
    [zanBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [zanBtn addTarget:self action:@selector(supportIt) forControlEvents:UIControlEventTouchUpInside];
    [zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, zanBtn.imageView.bounds.size.width+1, 0, 0)];

    
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    UIBarButtonItem *left2 = [[UIBarButtonItem alloc]initWithCustomView:likeBtn];
    UIBarButtonItem *left3 = [[UIBarButtonItem alloc]initWithCustomView:zanBtn];
    
    self.navigationItem.rightBarButtonItems = @[left1,left2,left3];
    
}
-(void)likeIt{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    [manager GET:[NSString stringFollowBaseUrl:likeUrl] parameters:@{@"id":self.tid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        if ([rootDic[@"code"] isEqual:@0]) {
            self.likeNum += 1;
        }
        [likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)self.likeNum] forState:UIControlStateNormal];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:rootDic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(void)supportIt{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    [manager GET:[NSString stringFollowBaseUrl:supportUrl] parameters:@{@"tid":self.tid} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        if ([rootDic[@"code"] isEqual:@0]) {
            self.supportNum +=1;
        }
        [zanBtn setTitle:[NSString stringWithFormat:@"%ld",(long)self.supportNum] forState:UIControlStateNormal];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:rootDic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
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
