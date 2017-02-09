//
//  ForumTableViewController.m
//  品车App
//
//  Created by fei on 16/11/2.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "ForumTableViewController.h"
#import "ForumTableViewCell.h"
#import "ListTableViewController.h"
#import "MBProgressHUD.h"

@interface ForumTableViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *progressHUD;
}
@end

@implementation ForumTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:[NSString stringFollowBaseUrl:forumURL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        progressHUD.hidden = YES;
        if ([[responseObject objectForKey:@"msg"] isEqualToString:@"success"]) {
            self.resultArr = [responseObject objectForKey:@"data"];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"车友圈";
    
    progressHUD = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    progressHUD.delegate = self;
    progressHUD.label.text = @"加载中...";
    progressHUD.removeFromSuperViewOnHide = YES;
    
    [self.tableView registerClass:[ForumTableViewCell class] forCellReuseIdentifier:@"ForumTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:[NSString stringFollowBaseUrl:forumURL] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        progressHUD.hidden = YES;
        if ([[responseObject objectForKey:@"msg"] isEqualToString:@"success"]) {
            self.resultArr = [responseObject objectForKey:@"data"];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        progressHUD.hidden = YES;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ForumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForumTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ForumTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ForumTableViewCell"];
    }
    NSDictionary *resultDic = self.resultArr[indexPath.row];
    cell.iconView.image = [UIImage imageNamed:@"18-2"];
    cell.numLabel.text = resultDic[@"postnum"];
    cell.mainLabel.text = resultDic[@"name"];
    cell.subLabel.text = resultDic[@"name_en"];
    [cell.backView sd_setImageWithURL:[NSURL URLWithString:resultDic[@"img"]] placeholderImage:nil];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT/4.4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewController *listView = [[ListTableViewController alloc]init];
    NSDictionary *resultDic = self.resultArr[indexPath.row];
    listView.fildId = resultDic[@"fid"];
    listView.navcTitle = resultDic[@"name"];
    [self.navigationController pushViewController:listView animated:YES];
}


@end
