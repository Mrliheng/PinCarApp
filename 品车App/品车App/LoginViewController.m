//
//  LoginViewController.m
//  品车App
//
//  Created by zt on 2016/10/24.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "LoginViewController.h"
#import "ConfigureSetting.h"
#import "RegisterViewController.h"
#import "FindPwdViewController.h"
#import "TabBarViewController.h"
#import "AppDelegate.h"
#import "HomeTableViewController.h"
#import "NavigationController.h"
#define labelHeight 50     //控件高度
#define textSpace labelHeight/2.0        //文本框的文字距文本框左边的距离
#define lastFont 16       //忘记密码的字体


#define textBGColor [UIColor colorWithRed:246/255.0 green:244/255.0 blue:242/255.0 alpha:0.1]  //文本框背景
#define placeHolderColor [UIColor colorWithRed:240/255.0 green:216/255.0 blue:223/255.0 alpha:1] //placeholder颜色
@interface LoginViewController ()<UIAlertViewDelegate>
{
    
    UITextField *_userText;
    UITextField *_pwdText;
    UILabel *_msgLabel;
    
}
@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createItem];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [ConfigureSetting setViewControllerTitleWithTextColor:@"登录" color:[UIColor whiteColor] targetCtrl:self];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:COOKIE]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
        [manager GET:[NSString stringFollowBaseUrl:exitURL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"成功！！！！");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"shibai");
        }];
    }
    

    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.view setbackgroundImage:[UIImage imageNamed:@"background.jpg"]];
    //默认不记住密码
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:SAVE_PWD];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self createUI];
}

-(void)createItem{
 
    NSString *navcBack = @"navigationBarBG";
    if (SCREEN_WIDTH>375) {
        navcBack = @"navigationBarBGPlus";
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:navcBack] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    backBtn.frame = CGRectMake(0, 0, 15, 10);
    [backBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
-(void)createUI{
    
    UIImageView *welcome = [UIImageView new];
    welcome.image = [UIImage imageNamed:@"Welcome"];
    welcome.contentMode = UIViewContentModeBottom;
    [self.view addSubview:welcome];
    
    _userText = [UITextField new];
    _userText.placeholder = @"用户名";
    [_userText setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _userText.textColor = [UIColor whiteColor];
    _userText.layer.masksToBounds = YES;
    _userText.layer.cornerRadius = labelHeight/2;
    _userText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, textSpace, 0)];
    _userText.leftViewMode = UITextFieldViewModeAlways;
    _userText.backgroundColor = textBGColor;
    [self.view addSubview:_userText];
    
    _pwdText = [UITextField new];
    _pwdText.placeholder = @"密码";
    [_pwdText setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    _pwdText.textColor = [UIColor whiteColor];
    [_pwdText setSecureTextEntry:YES];
    _pwdText.layer.masksToBounds = YES;
    _pwdText.layer.cornerRadius = labelHeight/2;
    _pwdText.backgroundColor = textBGColor;
    _pwdText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, textSpace, 0)];
    _pwdText.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_pwdText];
    
    UIButton *savePwdBtn = [UIButton new];
    savePwdBtn.selected = NO;
    [savePwdBtn setBackgroundImage:[UIImage imageNamed:@"reg_pwd"] forState:UIControlStateNormal];
    [savePwdBtn setBackgroundImage:[[UIImage imageNamed:@"reg_pwdSaved"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    [savePwdBtn setBackgroundImage:[UIImage imageNamed:@"reg_pwdSaved"] forState:UIControlStateSelected];
    [self.view addSubview:savePwdBtn];
    [savePwdBtn addTarget:self action:@selector(savePwd:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *savePwdLabel = [UILabel new];
    savePwdLabel.text = @"记住密码";
    savePwdLabel.textColor = placeHolderColor;
    savePwdLabel.font = [UIFont systemFontOfSize:lastFont - 2];
    savePwdLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:savePwdLabel];
    
    UIButton *loginBtn = [UIButton new];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:placeHolderColor forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = labelHeight/2;
    loginBtn.layer.borderColor = placeHolderColor.CGColor;
    loginBtn.layer.borderWidth = 0.5;
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    NSString *forgetStr = @"忘记密码";
    UIButton *forgetPwdBtn = [UIButton new];
    forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:lastFont];
    [forgetPwdBtn setTitle:forgetStr forState:UIControlStateNormal];
    [self.view addSubview:forgetPwdBtn];
    [forgetPwdBtn addTarget:self action:@selector(findPwd) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *registerStr = @"还没有账户？注册。";
    UIButton *registerBtn = [UIButton new];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:lastFont];
    registerBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [registerBtn setTitle:registerStr forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    [self createMsgLabel];
    
    CGFloat bottomHeight = SCREEN_HEIGHT/6;  //忘记密码距离最底部的高度
    CGFloat xSpace = 50;
    if (SCREEN_WIDTH<330) {
        bottomHeight = SCREEN_HEIGHT/13;
        xSpace = SCREEN_WIDTH/15;
    }
    
    CGSize forgetSize = [forgetStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:lastFont]}];
    forgetPwdBtn.sd_layout
    .leftEqualToView(_userText)
    .bottomSpaceToView(self.view,bottomHeight)
    .heightIs(40)
    .widthIs(forgetSize.width);
    
    CGSize registerSize = [registerStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:lastFont]}];
    registerBtn.sd_layout
    .bottomSpaceToView(self.view,bottomHeight)
    .rightEqualToView(_userText)
    .heightIs(40)
    .widthIs(registerSize.width);
    
    loginBtn.sd_layout
    .leftEqualToView(_userText)
    .rightEqualToView(_userText)
    .bottomSpaceToView(forgetPwdBtn,30)
    .heightIs(labelHeight);
    
    savePwdBtn.sd_layout
    .leftSpaceToView(self.view,xSpace+20)
    .bottomSpaceToView(loginBtn,20)
    .widthIs(20)
    .heightIs(20);
    
    savePwdLabel.sd_layout
    .leftSpaceToView(savePwdBtn,20)
    .bottomEqualToView(savePwdBtn)
    .rightEqualToView(_userText)
    .heightIs(20);
    
    _pwdText.sd_layout
    .rightSpaceToView(self.view,xSpace)
    .leftSpaceToView(self.view,xSpace)
    .heightIs(labelHeight)
    .bottomSpaceToView(savePwdLabel,15);
    
    _userText.sd_layout
    .rightSpaceToView(self.view,xSpace)
    .leftSpaceToView(self.view,xSpace)
    .heightIs(labelHeight)
    .bottomSpaceToView(_pwdText,25);
    
    welcome.sd_layout
    .rightEqualToView(_userText)
    .leftEqualToView(_userText)
    .bottomSpaceToView(_userText,50);
    
    
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

//记住密码
-(void)savePwd:(UIButton *)button{

    button.selected = !button.selected;
    if (button.selected) {
        //记住密码
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:SAVE_PWD];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [button setBackgroundImage:[UIImage imageNamed:@"reg_pwdSaved"] forState:UIControlStateHighlighted];
        
    }

}
//登录
-(void)login:(UIButton *)btn{
    btn.enabled = NO;
    NSDictionary *paramDic = @{@"username":_userText.text,@"password":_pwdText.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:[NSString stringFollowBaseUrl:loginURL] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取cookie
        [self getCookieWithUrl:[NSString stringFollowBaseUrl:loginURL]];
        
        NSDictionary *rootDic = responseObject;
        if ([rootDic[@"code"] integerValue] == 0) {

            [[NSUserDefaults standardUserDefaults]setValue:_userText.text forKey:USER_NAME];
            [[NSUserDefaults standardUserDefaults]setValue:_pwdText.text forKey:USER_PWD];
            [[NSUserDefaults standardUserDefaults]synchronize];
            //登录成功。
//            _msgLabel.text = rootDic[@"msg"];
            [self changeRootVC];

//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:rootDic[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
        }
        else{
            _msgLabel.text = rootDic[@"msg"];
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:rootDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alertView show];
        }
        btn.enabled = YES;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        _msgLabel.text = @"网络连接失败";
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"网络连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
    }];
}

-(void)getCookieWithUrl:(NSString *)url{
    
    //获取cookie
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:url]];
    NSDictionary *Request = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    NSUserDefaults *userCookies = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[Request objectForKey:@"Cookie"]);
    [userCookies setObject:[Request objectForKey:@"Cookie"] forKey:COOKIE];
    [userCookies synchronize];
    
}
//返回首页
-(void)backHome{
    HomeTableViewController *home = [[HomeTableViewController alloc]init];
    NavigationController *navc1 = [[NavigationController alloc]initWithRootViewController:home];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

    app.window.rootViewController = navc1;

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    [self changeRootVC];

}
-(void)changeRootVC{
    TabBarViewController *tabBar = [[TabBarViewController alloc]init];
    UIView *bgView = [[UIView alloc]initWithFrame:tabBar.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [tabBar.tabBar insertSubview:bgView atIndex:0];
    tabBar.tabBar.opaque = YES;
    
    //tabbar未选中时字体颜色及大小
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:96.0/255.0 green:40.0/255.0 blue:132.0/255.0 alpha:1.0],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
    //tabbar选中时字体颜色及大小
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12.0],NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    app.window.rootViewController = tabBar;
}
-(void)registerUser{
    
    RegisterViewController *re = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:re animated:YES];
}

//找回密码
-(void)findPwd{
        FindPwdViewController *find = [[FindPwdViewController alloc]init];
        [self.navigationController pushViewController:find animated:YES];
}
//找回密码
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
