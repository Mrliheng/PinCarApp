//
//  ServiceRepresentativeTableViewController.m
//  品车App
//
//  Created by zt on 2016/10/20.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "ServiceRepresentativeTableViewController.h"
#import "IconTableViewCell.h"
#import "SalesTableViewController.h"
#import "MessageViewController.h"
#import "BindSalesViewController.h"
@interface ServiceRepresentativeTableViewController ()
{
    NSMutableArray *_dataArray;
    NSMutableArray *_iconArray;
}
@end

@implementation ServiceRepresentativeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.navcTitle;
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //设置分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
    [self createData];
    
}

-(void)createData{
    
    _dataArray = [NSMutableArray arrayWithObjects:@"销售代表",@"售后",@"给店内留言",@"绑定专属代表", nil];
    _iconArray = [NSMutableArray arrayWithObjects:@"24-1",@"23-4",@"11-12",@"23-3", nil];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[IconTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 7, 14)];
    view.image = [UIImage imageNamed:@"21-2"];
    [cell setCellWithIcon:[UIImage imageNamed:_iconArray[indexPath.row]] withTitle:_dataArray[indexPath.row] withAccessoryView:view];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            //销售代表
            SalesTableViewController *sales = [[SalesTableViewController alloc]init];
            sales.navTitle = @"销售代表";
            [self.navigationController pushViewController:sales animated:YES];
        }
            break;
            
        case 1:
        {
            //售后
            SalesTableViewController *sales = [[SalesTableViewController alloc]init];
            sales.navTitle = @"售后";
            sales.group = @"售后";
            [self.navigationController pushViewController:sales animated:YES];
        }
            break;
        case 2:{
            //给店长留言
            MessageViewController *message = [[MessageViewController alloc]init];
            message.isLogin = YES;
            [self.navigationController pushViewController:message animated:YES];
        }
            break;
        case 3:{
            //绑定销售代表
            BindSalesViewController *bind = [[BindSalesViewController alloc]init];
            bind.navTitle = @"绑定专属代表";
            [self.navigationController pushViewController:bind animated:YES];
        }
            break;
        default:
            break;
    }
}
@end
