//
//  MyMessageTableViewCell.m
//  品车App
//
//  Created by fei on 16/11/17.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "MyMessageTableViewCell.h"

#define iconSpace 20    //小图标距离边距大小
#define iconWidth 50    //小图标宽高
#define rightSpace 15   //距离屏幕右边的边距大小


@implementation MyMessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self CreatView];
    }
    return self;
}

-(void)CreatView
{
    self.iconView = [UIImageView new];
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = iconWidth/2.0;
    [self.contentView addSubview:self.iconView];
    
    self.mainLabe = [UILabel new];
    self.mainLabe.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:self.mainLabe];
    
    self.subLabe = [UILabel new];
    self.subLabe.font = [UIFont systemFontOfSize:16.0];
    self.subLabe.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
    [self.contentView addSubview:self.subLabe];
    
    self.dateLabe = [UILabel new];
    self.dateLabe.font = [UIFont systemFontOfSize:13.0];
    self.dateLabe.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
    [self.contentView addSubview:self.dateLabe];
    
    self.iconView.sd_layout
    .leftSpaceToView(self.contentView,iconSpace)
    .widthIs(iconWidth)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView);
    
    self.mainLabe.sd_layout
    .topSpaceToView(self.contentView,10)
    .leftSpaceToView(self.iconView,iconSpace)
    .heightIs(20);
    [self.mainLabe setSingleLineAutoResizeWithMaxWidth:100];
    
    self.subLabe.sd_layout
    .leftEqualToView(self.mainLabe)
    .bottomSpaceToView(self.contentView,10)
    .heightIs(20);
    [self.subLabe setSingleLineAutoResizeWithMaxWidth:200];
    
    self.dateLabe.sd_layout
    .rightSpaceToView(self.contentView,rightSpace)
    .bottomEqualToView(self.mainLabe)
    .autoHeightRatio(0);
    [self.dateLabe setSingleLineAutoResizeWithMaxWidth:100];
    
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
