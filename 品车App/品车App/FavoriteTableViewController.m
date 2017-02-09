//
//  FavoriteTableViewController.m
//  品车App
//
//  Created by fei on 16/11/17.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "FavoriteTableViewController.h"
#import "FavoriteTableViewCell.h"

#import "DetailViewController.h"//webview页面

@interface FavoriteTableViewController ()
{
    NSMutableArray *_dataArray;
}
@end

@implementation FavoriteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    _dataArray = [NSMutableArray array];
    [self getData];
}

-(void)getData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    [manager GET:[NSString stringFollowBaseUrl:myFavoriteURL] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = responseObject;
        if ([rootDic[@"code"] integerValue] == 0) {
            
            [_dataArray addObjectsFromArray:rootDic[@"data"]];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favoriteCell"];
    if (!cell) {
        cell = [[FavoriteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"favoriteCell"];
    }
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.mainLabe.text = [NSString stringWithFormat:@"%@",dic[@"title"]];
    cell.subLabe.text = [NSString stringWithFormat:@"%@",dic[@"forumname"]];
    cell.dateLabe.text = @"2016-11-17";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detail = [[DetailViewController alloc]init];
    NSDictionary *dic = _dataArray[indexPath.row];
    detail.requestUrl = dic[@"url"];
    detail.tid = [NSString stringWithFormat:@"%@",dic[@"tid"]];
    detail.supportNum = [[NSString stringWithFormat:@"%@",dic[@"recommend_add"]] integerValue];
    detail.likeNum = [[NSString stringWithFormat:@"%@",dic[@"favtimes"]] integerValue];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
