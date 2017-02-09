//
//  UIView+CateGory.h
//  ChatView
//
//  Created by 罗贤民 on 16/7/14.
//  Copyright © 2016年 罗贤民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CateGory)

-(UITextField *)initWithField:(CGRect)rect color:(UIColor *)color;
-(UIButton *)initWithBtn:(CGRect)rect title:(NSString *)title titleColor:(UIColor *)textColor;
@end
