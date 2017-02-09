//
//  MyMessageTableViewCell.h
//  品车App
//
//  Created by fei on 16/11/17.
//  Copyright © 2016年 fei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageTableViewCell : UITableViewCell
/**
 头像
 */
@property(nonatomic,strong)UIImageView *iconView;
/**
 主标题
 */
@property(nonatomic,strong)UILabel *mainLabe;
/**
 子标题
 */
@property(nonatomic,strong)UILabel *subLabe;
/**
 时间
 */
@property(nonatomic,strong)UILabel *dateLabe;

@end
