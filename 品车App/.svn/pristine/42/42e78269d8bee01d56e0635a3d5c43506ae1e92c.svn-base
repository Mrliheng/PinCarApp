//
//  LabelTableViewController.m
//  品车App
//
//  Created by fei on 16/11/1.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "LabelTableViewController.h"

@interface LabelTableViewController ()

@end

@implementation LabelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat heigt = SCREEN_HEIGHT/2;
    if (self.tableArray.count * 44 < heigt ) {
        heigt = self.tableArray.count*44;
    }
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, heigt);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LabelViewcell"];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
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
    return self.tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelViewcell" forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LabelViewcell"];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.text = [self.tableArray[indexPath.row] objectForKey:@"name"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = @{@"numb":indexPath};
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"LabelViewTongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


@end
