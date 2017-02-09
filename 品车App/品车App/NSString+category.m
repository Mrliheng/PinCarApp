//
//  NSString+category.m
//  computer_collected
//
//  Created by zt on 16/8/18.
//  Copyright © 2016年 ZT. All rights reserved.
//

#import "NSString+category.h"

@implementation NSString (category)

-(NSString *)Follow:(NSString *)baseUrl With:(NSString *)str{
    
    return [NSString stringWithFormat:@"%@%@",baseURLs,str];
}
+(NSString *)stringFollowBaseUrl:(NSString *)str{
    
    NSString *url = [[NSString alloc]init];
    return [url Follow:baseURLs With:str];
}

@end
