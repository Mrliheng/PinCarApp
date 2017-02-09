//
//  FindPwdViewController.m
//  品车App
//
//  Created by zt on 2016/10/27.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "FindPwdViewController.h"

#define textBGColor [UIColor colorWithRed:246/255.0 green:244/255.0 blue:242/255.0 alpha:0.1]  //文本框背景
#define btnHeight 50
#define textSpace btnHeight/2        //文本框的文字距文本框左边的距离

#define bottomHeight 140  //确认距离最底部的高度，与登录页的bottomHeight相关

#define placeHolderColor [UIColor colorWithRed:240/255.0 green:216/255.0 blue:223/255.0 alpha:1] //placeholder颜


@interface FindPwdViewController ()
{
    CGFloat _ySpace;   //控件之间的高度，和注册页高度一样。
    UITextField *_telText;     //手机号
    UITextField *_verifyText;  //验证码
    UITextField *_pwdText;     //密码
    UILabel *_msgLabel;        //提示label
}
@end

@implementation FindPwdViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self createItem];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ConfigureSetting setViewControllerTitleWithTextColor:@"重置密码" color:[UIColor whiteColor] targetCtrl:self];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    _ySpace = (SCREEN_HEIGHT - 64 - 7 * btnHeight)/(7 + 3);  //控件之间的高度

    [self.view setbackgroundImage:[UIImage imageNamed:@"background.jpg"]];

    [self createUI];
    [self createMsgLabel];
}
-(void)createMsgLabel{
    
    _msgLabel = [UILabel new];
    _msgLabel.backgroundColor = [UIColor clearColor];
    _msgLabel.textColor = [UIColor whiteColor];
    _msgLabel.font = [UIFont systemFontOfSize:12];
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_msgLabel];
    
    _msgLabel.sd_layout
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(30);
    
}
-(void)createItem{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBG"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    backBtn.frame = CGRectMake(0, 0, 15, 10);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createUI{
    
    _telText = [self createTextFieldWithPlaceHolder:@"已绑定手机号"];
    _telText.keyboardType = UIKeyboardTypeNumberPad;
    [self createVerify];
    _pwdText = [self createTextFieldWithPlaceHolder:@"新密码"];
    _pwdText.secureTextEntry = YES;

    UIButton *registBtn = [UIButton new];
    [registBtn setTitle:@"确认" forState:UIControlStateNormal];
    [registBtn setTitleColor:placeHolderColor forState:UIControlStateNormal];
    registBtn.layer.masksToBounds = YES;
    registBtn.layer.cornerRadius = btnHeight/2;
    registBtn.layer.borderColor = placeHolderColor.CGColor;
    registBtn.layer.borderWidth = 0.5;
    [registBtn addTarget:self action:@selector(changePWD) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *viewsArr = @[_telText,_verifyText,_pwdText,registBtn];
    [self setAutolayoutWithViews:viewsArr];
}
-(void)setAutolayoutWithViews:(NSArray *)arr{
    
    CGFloat xSpace =50;
    if (SCREEN_WIDTH<330) {
        xSpace = SCREEN_WIDTH/15;
    }
    
    for (UIView *view in arr) {
        [self.view addSubview:view];
    }
    for(int i=0;i<arr.count;i++){
        CGFloat topHeight;
        UIView *topView;
        if (i==0) {
            topView = self.view;
            topHeight = _ySpace *2;
        }
        else{
            topView = arr[i-1];
            topHeight = _ySpace;
        }
        UIView *view = arr[i];
        view.sd_layout
        .leftSpaceToView(self.view,xSpace)
        .rightSpaceToView(self.view,xSpace)
        .topSpaceToView(topView,topHeight)
        .heightIs(btnHeight);
        [view updateLayout];
    }
}
-(void)changePWD{
    
    NSDictionary *paramDic = @{@"mobile":_telText.text,@"verifycode":_verifyText.text,@"password":_pwdText.text};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:[NSString stringFollowBaseUrl:finPWD] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = responseObject;
        if ([rootDic[@"code"] integerValue] == 0) {
            
            _msgLabel.text = @"密码修改成功";
            [self.navigationController popViewControllerAnimated:YES];

        }
        else{
            _msgLabel.text = @"密码修改失败";
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        _msgLabel.text = @"网络连接失败";
        
    }];
    
    
    
}
-(void)createVerify{
    
    if (_verifyText) {
        return;
    }
    _verifyText = [self createTextFieldWithPlaceHolder:@"验证码"];
    _verifyText.keyboardType = UIKeyboardTypeNumberPad;
    UIButton *obtainVerify = [UIButton new];
    //    obtainVerify.backgroundColor = [UIColor lightGrayColor];
    [obtainVerify setTitle:@"获取验证码" forState:UIControlStateNormal];
    [obtainVerify addTarget:self action:@selector(getButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_verifyText addSubview:obtainVerify];
    
    obtainVerify.sd_layout
    .rightSpaceToView(_verifyText,0)
    .topSpaceToView(_verifyText,0)
    .bottomSpaceToView(_verifyText,0)
    .widthRatioToView(_verifyText,0.5);
    
    [obtainVerify setLeftLine];
    
}
-(UITextField *)createTextFieldWithPlaceHolder:(NSString *)placeHolder{
    
    UITextField *textField = [UITextField new];
    
    textField.placeholder = placeHolder;
    [textField setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    textField.textColor = [UIColor whiteColor];

    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = btnHeight/2;
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, textSpace, 0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.backgroundColor = textBGColor;
    
    return textField;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取验证码
- (void)getButtonClick:(UIButton *)sender
{
    //发送短信接口
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    NSDictionary *param = @{@"mobile":_telText.text};
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
