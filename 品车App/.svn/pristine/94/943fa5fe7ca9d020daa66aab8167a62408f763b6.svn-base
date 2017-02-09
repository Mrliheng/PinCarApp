//
//  MyQrcodeViewController.m
//  品车App
//
//  Created by zt on 2016/11/14.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "MyQrcodeViewController.h"

@interface MyQrcodeViewController ()
{
    UIImageView *_qrView;
    UILabel *_nameLabel;
}
@end

@implementation MyQrcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邀请码";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(0, 0, 15, 10);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftbutton;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _qrView = [UIImageView new];
    [self.view addSubview:_qrView];
    
    _qrView.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(SCREEN_HEIGHT/2.0 - 64)
    .widthIs(170)
    .heightIs(170);
    
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"扫一扫二维码，获取邀请码";
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
    label.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(_qrView,5)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(20);
    [self createData];
}

-(void)createData{
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"image/png"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:[NSString stringFollowBaseUrl:getQRCode] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        UIImage *image = [UIImage imageWithData:responseObject];
        _qrView.image = image;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
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
