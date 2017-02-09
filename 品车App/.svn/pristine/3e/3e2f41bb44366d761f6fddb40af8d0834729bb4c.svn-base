//
//  UIButton+category.m
//  品车App
//
//  Created by zt on 2016/10/25.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "UIButton+category.h"

@implementation UIButton (category)
-(void)setLeftLine{
    
    UIImageView *iv = [UIImageView new];
    iv.image = [UIImage imageNamed:@"reg_line"];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:iv];
    
    iv.sd_layout
    .leftEqualToView(self)
    .topSpaceToView(self,5)
    .bottomSpaceToView(self,5)
    .widthIs(1);
}
@end
