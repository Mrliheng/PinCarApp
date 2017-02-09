//
//  ForumTableViewCell.h
//  品车App
//
//  Created by fei on 16/10/24.
//  Copyright © 2016年 fei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumTableViewCell : UITableViewCell
//评论图标
@property(strong,nonatomic)UIImageView *iconView;
//评论数
@property(strong,nonatomic)UILabel *numLabel;
//主标题
@property(strong,nonatomic)UILabel *mainLabel;
//副标题
@property(strong,nonatomic)UILabel *subLabel;
//Cell背景
@property(strong,nonatomic)UIImageView *backView;
@end
