//
//  ListTableViewController.h
//  品车App
//
//  Created by fei on 16/10/25.
//  Copyright © 2016年 fei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTableViewController : UIViewController
//导航栏标题
@property(nonatomic,strong)NSString *navcTitle;
//帖子板块id
@property(nonatomic,strong)NSNumber *fildId;
//数据源
@property(nonatomic,strong)NSMutableArray *resultArr;

@property(nonatomic,strong)UITableView *tableView;

@end
