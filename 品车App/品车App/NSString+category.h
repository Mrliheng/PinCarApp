//
//  NSString+category.h
//  computer_collected
//
//  Created by zt on 16/8/18.
//  Copyright © 2016年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (category)

/**拼接到baseURL后面
 */
+(NSString *)stringFollowBaseUrl:(NSString *)str;

@end
