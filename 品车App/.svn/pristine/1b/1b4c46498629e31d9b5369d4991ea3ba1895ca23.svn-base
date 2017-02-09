//
//  MyTabBar.m
//  品车App
//
//  Created by zt on 2016/10/21.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "MyTabBar.h"

#define middleWidth 44 //中间button的宽高。
#define tabBarNum 5
@interface MyTabBar ()

@property (nonatomic,weak) UIButton *btn;
@end
@implementation MyTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"middle"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"middle"] forState:UIControlStateHighlighted];
        CGRect frame = self.btn.frame;
        frame.size = CGSizeMake(middleWidth, middleWidth);
        btn.frame = frame;
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        self.btn = btn;
        
    }
    return self;
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.btn.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    // 2.设置其他tabbarButton的frame
    CGFloat tabBarButtonW = self.frame.size.width / tabBarNum;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            CGRect frame = child.frame;
            // 设置x
            frame.origin.x = tabBarButtonIndex * tabBarButtonW;
            // 设置宽度
            frame.size.width = tabBarButtonW;
            child.frame = frame;
            // 增加索引
            tabBarButtonIndex++;
            if (tabBarButtonIndex == tabBarNum / 2) {
                tabBarButtonIndex++;
            }
        }
    }
}
-(void)btnClick{
    
    [self.tabBarDelegate tabBarDidClickMiddleButton:self];
}


@end
