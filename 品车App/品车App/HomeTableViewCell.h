//
//  HomeTableViewCell.h
//  品车App
//
//  Created by zt on 2016/10/25.
//  Copyright © 2016年 fei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *distanceLabel;

-(void)setCellWithIcon:(NSString *)icon withTitle:(NSString *)title withDistance:(NSString *)distance;
@end
