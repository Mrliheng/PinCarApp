//
//  UIView+UIView.m
//  品车App
//
//  Created by zt on 2016/10/25.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "UIView+UIView.h"

@implementation UIView (UIView)

-(void)setbackgroundImage:(UIImage *)image{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.image = image;
    [self addSubview:imageView];
}
@end
