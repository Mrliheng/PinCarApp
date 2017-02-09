//
//  SalesTableViewController.m
//  品车App
//
//  Created by zt on 2016/10/20.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "SalesTableViewController.h"
#import "TelToPersonTableViewCell.h"
@interface SalesTableViewController ()
{
    NSString *_dealerId;

}
@end

@implementation SalesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.navTitle;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //设置分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 53, 0, 0);
    [self createData];
    

}

-(void)createData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    _dealerId = [[NSUserDefaults standardUserDefaults]stringForKey:DEALER_ID];
    NSInteger dealerId = [_dealerId integerValue];
    NSNumber *dealerNum = [NSNumber numberWithInteger:dealerId];
    NSDictionary *paramDic;
    if (_group.length > 0) {
        paramDic = @{@"dealerid":dealerNum,@"group":_group};
    }
    else{
        paramDic = @{@"dealerid":dealerNum};
    }
    [manager GET:[NSString stringFollowBaseUrl:getSellerList] parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = responseObject;
        NSArray *data = rootDic[@"data"];
        if ( data.count >0) {
            
            _dataArray = rootDic[@"data"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TelToPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[TelToPersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    
    cell.block = ^(NSInteger row){
        
        NSDictionary *dic = _dataArray[indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",dic[@"mobile"]]];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://010-111111"]];

        [[UIApplication sharedApplication] openURL:url];
    };
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell setCellWithIcon:dic[@"avtar"] withBigTitle:dic[@"username"] withSmallTitle:self.navTitle withTelButton:[UIImage imageNamed:@"11-13"] withRow:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH];
}
@end
