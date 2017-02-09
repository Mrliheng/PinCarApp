//
//  SetViewController.m
//  品车App
//
//  Created by fei on 16/10/28.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "SetViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"


@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *dataArray;
    NSIndexPath * _indexPath;
}

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.navcTitle;
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    
    dataArray = @[@"定位开关",@"清除缓存",@"版本号"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 132) style:UITableViewStylePlain];
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SetCell"];
    [self.view addSubview:self.tableView];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exitBtn.backgroundColor = [UIColor redColor];
    [exitBtn setTitle:@"退出账号" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    exitBtn.layer.masksToBounds = YES;
    exitBtn.layer.cornerRadius = 20;
    [self.view addSubview:exitBtn];
    exitBtn.sd_layout
    .topSpaceToView(self.tableView,30)
    .centerXEqualToView(self.view)
    .widthIs(SCREEN_WIDTH/3)
    .heightIs(40);
}

-(void)loginOut
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    [manager GET:[NSString stringFollowBaseUrl:exitURL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[NSUserDefaults standardUserDefaults]setValue:nil forKey:USER_NAME];
        [[NSUserDefaults standardUserDefaults]setValue:nil forKey:USER_PWD];
        [[NSUserDefaults standardUserDefaults]setValue:nil forKey:COOKIE];
        [[NSUserDefaults standardUserDefaults]synchronize];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LoginViewController *login = [[LoginViewController alloc]init];
        app.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:login];
//        if ([[responseObject objectForKey:@"msg"] isEqualToString:@"success"]) {
//            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//            LoginViewController *login = [[LoginViewController alloc]init];
//            app.window.rootViewController = login;
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"shibai");
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SetCell"];
    }
    cell.textLabel.text = dataArray[indexPath.row];
    if (indexPath.row == 0) {
        UISwitch *locatSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 6, 40, 30)];
        [locatSwitch setOn:YES];
        [locatSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:locatSwitch];
    }else if(indexPath.row == 1){
        float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
        NSString *size = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
        _indexPath = indexPath;

        cell.detailTextLabel.text = size;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要清除缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];//可有可无

        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_indexPath];
        cell.detailTextLabel.text = @"0.00K";
    }
    
}

-(void)switchValueChanged:(id)sender
{
    UISwitch *control = (UISwitch *)sender;
    if (control.on) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-隐私内将定位服务开启" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请在设置-隐私内将定位服务关闭" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
