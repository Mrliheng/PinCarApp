//
//  ConfigureSetting.m
//  品车App
//
//  Created by fei on 16/10/17.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "ConfigureSetting.h"

@implementation ConfigureSetting

+(void)setViewControllerTitleWithTextColor:(NSString *)title color:(UIColor *)color targetCtrl:(UIViewController *)targetCtrl
{
    NSString *newTitle;
    
    if ([title length]>16) {
        
        NSRange first = NSMakeRange(0, 15);
        NSMutableString *mStr = [NSMutableString string];
        //substringWithRange需要传进来NSRange类型，表示从哪里开始截取和长度，返回字符串类型
        [mStr appendString:[title substringWithRange:first]];
        [mStr appendString:@"…"];
        newTitle = mStr;
    }
    else {
        newTitle = title;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:18];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize size = [title sizeWithAttributes:attributes];
    label.frame = CGRectMake((SCREEN_WIDTH-size.width)*0.5, 0, size.width, 44);
    label.textAlignment = NSTextAlignmentCenter;
    
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:color];
    label.text = newTitle;
    targetCtrl.navigationItem.titleView = label;
}

@end
