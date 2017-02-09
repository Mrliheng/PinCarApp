//
//  UIView+CateGory.m
//  ChatView
//
//  Created by 罗贤民 on 16/7/14.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import "UIView+CateGory.h"

@implementation UIView (CateGory)

-(UITextField *)initWithField:(CGRect)rect color:(UIColor *)color
{
    UITextField *field=[[UITextField alloc]initWithFrame:rect];
    
    field.backgroundColor = color;
    field.layer.cornerRadius = 4.25f;
    field.layer.borderColor = [[UIColor whiteColor] CGColor];
    field.layer.borderWidth = 0.5f;
    [self addSubview:field];
    
    return field;
    
}
-(UIButton *)initWithBtn:(CGRect)rect title:(NSString *)title titleColor:(UIColor *)textColor
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=rect;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    button.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:button];
    
    return button;
}

@end
