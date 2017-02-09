//
//  ServiceTableViewCell.m
//  品车App
//
//  Created by fei on 16/11/14.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "ServiceTableViewCell.h"

@implementation ServiceTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self CreatViewCell];
    }
    return self;
}

-(void)CreatViewCell
{
    self.bgView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.bgView];
    self.iconViews = [[UIImageView alloc]init];
    [self.contentView addSubview:self.iconViews];
    self.titleLeb = [[UILabel alloc]init];
    self.titleLeb.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLeb];
    
    self.bgView.sd_layout
    .topEqualToView(self.contentView)
    .leftEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .rightEqualToView(self.contentView);
    
    self.iconViews.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView,15)
    .widthIs(20)
    .heightIs(20);
    
    self.titleLeb.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView,20)
    .autoHeightRatio(0);
    [self.titleLeb setSingleLineAutoResizeWithMaxWidth:250];
    
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
