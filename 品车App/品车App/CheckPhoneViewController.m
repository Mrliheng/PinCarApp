//
//  CheckPhoneViewController.m
//  品车App
//
//  Created by fei on 16/11/7.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "CheckPhoneViewController.h"
#import "MBProgressHUD.h"

@interface CheckPhoneViewController ()<MBProgressHUDDelegate>
{
    UITextField *phoneField;
    UITextField *codeField;
}

@end

@implementation CheckPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    
    phoneField = [[UITextField alloc]init];
    phoneField.backgroundColor = [UIColor whiteColor];
    phoneField.placeholder = @"请输入手机号";
    phoneField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    phoneField.leftViewMode = UITextFieldViewModeAlways;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneField];
    
    codeField = [[UITextField alloc]init];
    codeField.backgroundColor = [UIColor whiteColor];
    codeField.placeholder = @"验证码";
    codeField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    codeField.leftViewMode = UITextFieldViewModeAlways;
    codeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:codeField];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.4];
    [codeField addSubview:backView];
    
    UIButton *verifyBtn = [UIButton new];
    [verifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifyBtn setTitleColor:[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.5] forState:UIControlStateNormal];
    verifyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [verifyBtn addTarget:self action:@selector(PostMessige:) forControlEvents:UIControlEventTouchUpInside];
    [codeField addSubview:verifyBtn];
    
    UIButton *createBtn = [[UIButton alloc]init];
    createBtn.backgroundColor = [UIColor whiteColor];
    [createBtn setTitle:@"确定" forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [createBtn addTarget:self action:@selector(boundPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    
    CGFloat xSpace =50;
    if (SCREEN_WIDTH<330) {
        xSpace = SCREEN_WIDTH/15;
    }

    phoneField.sd_layout
    .topSpaceToView(self.view,30)
    .leftSpaceToView(self.view,xSpace)
    .rightSpaceToView(self.view,xSpace)
    .heightIs(40);
    
    codeField.sd_layout
    .topSpaceToView(phoneField,30)
    .leftSpaceToView(self.view,xSpace)
    .rightSpaceToView(self.view,xSpace)
    .heightIs(40);
    
    verifyBtn.sd_layout
    .topEqualToView(codeField)
    .rightEqualToView(codeField)
    .bottomEqualToView(codeField)
    .widthRatioToView(codeField,0.5);
    
    backView.sd_layout
    .topSpaceToView(codeField,8)
    .bottomSpaceToView(codeField,8)
    .rightSpaceToView(verifyBtn,0)
    .widthIs(1);
    
    createBtn.sd_layout
    .topSpaceToView(codeField,30)
    .leftEqualToView(codeField)
    .rightEqualToView(codeField)
    .heightIs(40);
    
}


-(void)boundPhoneNumber
{
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.delegate = self;
    progressHUD.label.text = @"绑定中...";
    progressHUD.removeFromSuperViewOnHide = YES;
    
    //实名认证接口
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    NSDictionary *param = @{@"mobile":phoneField.text,@"verifycode":codeField.text};
    [manager POST:[NSString stringFollowBaseUrl:boundphonenumbURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        if ([rootDic[@"code"] integerValue] == 0) {
            progressHUD.hidden = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:rootDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            progressHUD.hidden = YES;


        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        progressHUD.label.text  = @"绑定失败!";
        [progressHUD hideAnimated:YES afterDelay:1.5];
    }];
}




-(void)PostMessige:(UIButton *)sender
{
    
    //发送短信接口
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    NSDictionary *param = @{@"mobile":phoneField.text};
    [manager POST:[NSString stringFollowBaseUrl:phonetestURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    //正常状态下的背景颜色
    UIColor *mainColor = [UIColor clearColor];
    //倒计时状态下的颜色
    UIColor *countColor = [UIColor clearColor];
    [self setTheCountdownButton:sender startWithTime:59 title:@"重新获取" countDownTitle:@"s后重新发送"mainColor:mainColor countColor:countColor];
}



#pragma mark - button倒计时
- (void)setTheCountdownButton:(UIButton *)button startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color {
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0), 1.0 * NSEC_PER_SEC,0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut == 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                button.backgroundColor = mColor;
                [button setTitle:title forState:UIControlStateNormal];
                button.userInteractionEnabled =YES;
            });
        } else {
            int seconds = timeOut % 60;
            NSString *timeStr = [NSString stringWithFormat:@"%0.1d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                button.backgroundColor = color;
                [button setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle]forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:17.0];
                button.userInteractionEnabled =NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
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
