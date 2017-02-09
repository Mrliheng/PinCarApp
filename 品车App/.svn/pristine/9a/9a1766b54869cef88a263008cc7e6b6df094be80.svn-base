//
//  ListTableViewCell.m
//  品车App
//
//  Created by fei on 16/10/25.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self CreateView];
    }
    return self;
}

-(void)CreateView
{
    
    self.iconView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.iconView];
    
    self.eliteView = [[UIImageView alloc]init];
    [self.iconView addSubview:self.eliteView];
    
    self.titleLabel = [self LoadLabel:16.0];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    self.scanView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.scanView];
    
    self.scanLabel = [self LoadLabel:14.0];
    self.scanLabel.textColor = [UIColor colorWithRed:55/255.0 green:30/255.0 blue:97/255.0 alpha:1.0];
    [self.contentView addSubview:self.scanLabel];
    
    self.commentView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.commentView];
    
    self.commentLabel = [self LoadLabel:14.0];
    self.commentLabel.textColor = [UIColor colorWithRed:55/255.0 green:30/255.0 blue:97/255.0 alpha:1.0];
    [self.contentView addSubview:self.commentLabel];
    
    self.dataLabe = [self LoadLabel:14.0];
    self.dataLabe.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    [self.contentView addSubview:self.dataLabe];
    //图片布局
    self.iconView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,10)
    .widthIs(90);
    //加精图标布局
    self.eliteView.sd_layout
    .leftSpaceToView(self.contentView,12)
    .bottomSpaceToView(self.contentView,12)
    .widthIs(10)
    .heightIs(10);
    //标题布局
    self.titleLabel.sd_layout
    .leftSpaceToView(self.iconView,10)
    .topEqualToView(self.iconView)
    .rightSpaceToView(self.contentView,10)
    .autoHeightRatio(0)
    .maxHeightIs(40);
    //浏览图标布局
    self.scanView.sd_layout
    .leftEqualToView(self.titleLabel)
    .bottomEqualToView(self.iconView)
    .heightIs(16.0)
    .widthEqualToHeight();

    //浏览数布局
    self.scanLabel.sd_layout
    .leftSpaceToView(self.scanView,3)
    .bottomEqualToView(self.iconView)
    .autoHeightRatio(0);
    [self.scanLabel setSingleLineAutoResizeWithMaxWidth:100.0];
    //评论图标布局
    self.commentView.sd_layout
    .leftSpaceToView(self.scanView,SCREEN_WIDTH/6)
    .bottomEqualToView(self.iconView)
    .heightRatioToView(self.scanView,1)
    .widthEqualToHeight();
    //评论数布局
    self.commentLabel.sd_layout
    .leftSpaceToView(self.commentView,3)
    .bottomEqualToView(self.iconView)
    .autoHeightRatio(0);
    [self.commentLabel setSingleLineAutoResizeWithMaxWidth:100.0];
    //日期布局
    self.dataLabe.sd_layout
    .bottomEqualToView(self.iconView)
    .rightSpaceToView(self.contentView,15)
    .autoHeightRatio(0);
    [self.dataLabe setSingleLineAutoResizeWithMaxWidth:150.0];
    
    
}

-(UILabel *)LoadLabel:(CGFloat)size
{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    
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
