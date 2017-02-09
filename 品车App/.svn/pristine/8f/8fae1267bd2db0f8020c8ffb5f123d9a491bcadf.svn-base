//
//  ForumTableViewCell.m
//  品车App
//
//  Created by fei on 16/10/24.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "ForumTableViewCell.h"

@implementation ForumTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self CreatTableViewCell];
    }
    return self;
}

-(void)CreatTableViewCell
{
    self.iconView = [[UIImageView alloc]init];
    self.backView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.iconView];
    self.numLabel = [self cretLabel];
    self.numLabel.font = [UIFont systemFontOfSize:12.0];
    self.mainLabel = [self cretLabel];
    self.subLabel = [self cretLabel];
    self.subLabel.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.mainLabel];
    [self.contentView addSubview:self.subLabel];
    
    CGFloat height = SCREEN_HEIGHT/5;
    
    self.numLabel.sd_layout
    .rightSpaceToView(self.contentView,20)
    .centerYEqualToView(self.contentView)
    .autoHeightRatio(0);
    [self.numLabel setSingleLineAutoResizeWithMaxWidth:80.0];
    
    self.backView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
    self.iconView.sd_layout
    .rightSpaceToView(self.numLabel,3)
    .heightRatioToView(self.numLabel,0.8)
    .widthEqualToHeight()
    .centerYEqualToView(self.numLabel);
    
    self.mainLabel.sd_layout
    .leftSpaceToView(self.contentView,30)
    .topSpaceToView(self.contentView,height/3)
    .autoHeightRatio(0);
    [self.mainLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    self.subLabel.sd_layout
    .topSpaceToView(self.mainLabel,0)
    .leftEqualToView(self.mainLabel)
    .autoHeightRatio(0);
    [self.subLabel setSingleLineAutoResizeWithMaxWidth:300];
    

    
}

-(UILabel *)cretLabel
{
    UILabel *label = [[UILabel alloc]init];
//    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor whiteColor];
    return label;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
