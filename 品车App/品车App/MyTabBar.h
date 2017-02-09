//
//  MyTabBar.h
//  品车App
//
//  Created by zt on 2016/10/21.
//  Copyright © 2016年 fei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTabBar;

@protocol MyTabBarDelegate <UITabBarDelegate>

@optional

-(void)tabBarDidClickMiddleButton:(MyTabBar *)tabBar;

@end

@interface MyTabBar : UITabBar


@property (nonatomic,weak)id<MyTabBarDelegate> tabBarDelegate;
@end
