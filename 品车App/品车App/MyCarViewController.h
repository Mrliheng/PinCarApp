//
//  MyCarViewController.h
//  品车App
//
//  Created by fei on 16/11/17.
//  Copyright © 2016年 fei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCarViewController : UIViewController

@property(nonatomic,strong)UITableView *tableView;

//好友申请数据源
@property(nonatomic,strong)NSMutableArray *acceptArr;

@end
