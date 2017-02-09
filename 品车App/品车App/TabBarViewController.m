//
//  TabBarViewController.m
//  品车App
//
//  Created by zt on 2016/10/21.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "TabBarViewController.h"
#import "MyTabBar.h"
#import "HomeTableViewController.h"
#import "ForumTableViewController.h"
#import "ServiceViewController.h"
#import "PersonalViewController.h"
#import "MiddleViewController.h"
#import "NavigationController.h"

@interface TabBarViewController ()<MyTabBarDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HomeTableViewController *home = [[HomeTableViewController alloc]init];
    NavigationController *navc1 = [[NavigationController alloc]initWithRootViewController:home];
    navc1.tabBarItem.title = @"首页";
    navc1.tabBarItem.image = [[UIImage imageNamed:@"home"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navc1.tabBarItem setSelectedImage:[[UIImage imageNamed:@"home_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    ForumTableViewController *forum = [[ForumTableViewController alloc]init];
    NavigationController *navc2 = [[NavigationController alloc]initWithRootViewController:forum];
    navc2.tabBarItem.title = @"车友圈";
    navc2.tabBarItem.image = [[UIImage imageNamed:@"forum"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navc2.tabBarItem setSelectedImage:[[UIImage imageNamed:@"forum_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    ServiceViewController *service = [[ServiceViewController alloc]init];
    NavigationController *navc3 = [[NavigationController alloc]initWithRootViewController:service];
    navc3.tabBarItem.title = @"生态圈";
    navc3.tabBarItem.image = [[UIImage imageNamed:@"service"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navc3.tabBarItem setSelectedImage:[[UIImage imageNamed:@"service_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    PersonalViewController *personal = [[PersonalViewController alloc]init];
    NavigationController *navc4 = [[NavigationController alloc]initWithRootViewController:personal];
    navc4.tabBarItem.title = @"我的";
    navc4.tabBarItem.image = [[UIImage imageNamed:@"person"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [navc4.tabBarItem setSelectedImage:[[UIImage imageNamed:@"person_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [self addChildViewController:navc1];
    [self addChildViewController:navc2];
    [self addChildViewController:navc3];
    [self addChildViewController:navc4];

    MyTabBar *tabBar = [[MyTabBar alloc]init];
    tabBar.tabBarDelegate = self;
    [self setValue:tabBar forKey:@"tabBar"];
}

-(void)tabBarDidClickMiddleButton:(MyTabBar *)tabBar{
    
    MiddleViewController *middle = [[MiddleViewController alloc]init];
    middle.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.9];
    middle.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;//关键语句，必须有
    [self presentViewController:middle animated:YES completion:nil];
    
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
