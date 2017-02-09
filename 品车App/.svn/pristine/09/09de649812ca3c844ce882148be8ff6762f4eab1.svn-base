//
//  FriendsTableViewCell.h
//  品车App
//
//  Created by fei on 16/11/21.
//  Copyright © 2016年 fei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendsTableViewCell;
@protocol FriendsTableViewCellDelegate <NSObject>

-(void)regiseTableViewCell:(FriendsTableViewCell *)cell;

@end


@interface FriendsTableViewCell : UITableViewCell

@property(strong,nonatomic)UIImageView *iconView;

@property(strong,nonatomic)UILabel *titleLab;

@property(strong,nonatomic)UIImageView *nextView;

@property(strong,nonatomic)UIButton *acceptBtn;

@property(nonatomic,weak)id<FriendsTableViewCellDelegate>cellDelegate;

@end
