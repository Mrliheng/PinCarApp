//
//  AppDelegate.m
//  品车App
//
//  Created by fei on 16/10/17.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeTableViewController.h"
#import "ForumTableViewController.h"
#import "ServiceViewController.h"
#import "PersonalViewController.h"
#import "NavigationController.h"
#import "TabBarViewController.h"
#import "IQKeyboardManager.h"
#import "LoginViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()
{
    
    
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    self.window  = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    //调用键盘方法
    [self IQKeyBoard];
    [self.window makeKeyWindow];
    
    if(![[NSUserDefaults standardUserDefaults]boolForKey:SAVE_PWD]){
        //如果没有选择记住密码，则清空用户名
        [[NSUserDefaults standardUserDefaults]setValue:nil forKey:USER_NAME];
    }
    if(![[NSUserDefaults standardUserDefaults]valueForKey:USER_NAME]){
        
        HomeTableViewController *home = [[HomeTableViewController alloc]init];
        NavigationController *navc1 = [[NavigationController alloc]initWithRootViewController:home];
        
        self.window.rootViewController = navc1;
    }
    else{
        UIViewController *viewcontroller = [[UIViewController alloc]initWithNibName:nil bundle:nil];
        viewcontroller.view.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = viewcontroller;
        [self login];
    }
    

    return YES;
}

-(void)login{
    
    NSDictionary *paramDic = @{@"username":[[NSUserDefaults standardUserDefaults]stringForKey:USER_NAME],@"password":[[NSUserDefaults standardUserDefaults]stringForKey:USER_PWD]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:[NSString stringFollowBaseUrl:loginURL] parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //获取cookie
        [self getCookieWithUrl:[NSString stringFollowBaseUrl:loginURL]];
        NSDictionary *rootDic = responseObject;
        if ([rootDic[@"code"] integerValue] == 0) {
            
            TabBarViewController *tabBar = [[TabBarViewController alloc]init];
            UIView *bgView = [[UIView alloc]initWithFrame:tabBar.tabBar.bounds];
            bgView.backgroundColor = [UIColor whiteColor];
            [tabBar.tabBar insertSubview:bgView atIndex:0];
            tabBar.tabBar.opaque = YES;
            
            //tabbar未选中时字体颜色及大小
            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:96.0/255.0 green:40.0/255.0 blue:132.0/255.0 alpha:1.0],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
            //tabbar选中时字体颜色及大小
            [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12.0],NSFontAttributeName, nil] forState:UIControlStateSelected];
            
            self.window.rootViewController = tabBar;
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:rootDic[@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LoginViewController *login = [[LoginViewController alloc]init];
        self.window.rootViewController = login;
    }];
}
-(void)getCookieWithUrl:(NSString *)url{
    
    //获取cookie
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:url]];
    NSDictionary *Request = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    NSUserDefaults *userCookies = [NSUserDefaults standardUserDefaults];
    [userCookies setObject:[Request objectForKey:@"Cookie"] forKey:COOKIE];
    [userCookies synchronize];
    
}
//键盘操作
-(void)IQKeyBoard
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    

}


@end
