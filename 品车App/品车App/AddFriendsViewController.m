//
//  AddFriendsViewController.m
//  品车App
//
//  Created by zt on 2016/11/17.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "AddFriendsViewController.h"

@interface AddFriendsViewController ()
{
    UITextField *_userText;
}
@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.title = @"添加好友";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _userText = [UITextField new];
    _userText.placeholder = @"对方用户名";
    [self.view addSubview:_userText];

    _userText.sd_layout
    .leftSpaceToView(self.view,50)
    .rightSpaceToView(self.view,50)
    .topSpaceToView(self.view,100)
    .heightIs(50);
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    
    addBtn.sd_layout
    .leftEqualToView(_userText)
    .rightEqualToView(_userText)
    .topSpaceToView(_userText,50)
    .heightIs(50);
}

-(void)addFriends{
    
    NSDictionary *paramDic = @{@"username":_userText.text};

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:[NSString stringFollowBaseUrl:addFriendsURL] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = responseObject;
        if ([rootDic[@"code"] integerValue] == 0) {
            
            
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:rootDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertView show];
        }
        else{
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:rootDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertView show];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"网络连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
    }];
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
