//
//  FavoriteTableViewCell.m
//  品车App
//
//  Created by fei on 16/11/17.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "FavoriteTableViewCell.h"

@implementation FavoriteTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self CreateView];
    }
    return self;
}

-(void)CreateView
{
    self.mainLabe = [UILabel new];
    self.mainLabe.textColor = [UIColor colorWithRed:96/255.0 green:97/255.0 blue:97/255.0 alpha:1.0];
    [self.contentView addSubview:self.mainLabe];
    
    self.subLabe = [UILabel new];
    self.subLabe.textColor = [UIColor colorWithRed:58/255.0 green:25/255.0 blue:110/255.0 alpha:1.0];
    [self.contentView addSubview:self.subLabe];
    
    self.dateLabe = [UILabel new];
    self.dateLabe.font = [UIFont systemFontOfSize:13.0];
    self.dateLabe.textColor = [UIColor colorWithRed:145/255.0 green:145/255.0 blue:145/255.0 alpha:1.0];
    [self.contentView addSubview:self.dateLabe];
    
    self.mainLabe.sd_layout
    .topSpaceToView(self.contentView,10)
    .leftSpaceToView(self.contentView,20)
    .rightSpaceToView(self.contentView,20)
    .heightIs(20);
//    [self.mainLabe setSingleLineAutoResizeWithMaxWidth:200];
    
    self.subLabe.sd_layout
    .leftEqualToView(self.mainLabe)
    .bottomSpaceToView(self.contentView,10)
    .heightIs(20)
    .rightSpaceToView(self.contentView,105);
//    [self.subLabe setSingleLineAutoResizeWithMaxWidth:150];
    
    self.dateLabe.sd_layout
    .rightSpaceToView(self.contentView,15)
    .bottomEqualToView(self.subLabe)
    .heightIs(20)
    .leftSpaceToView(self.subLabe,15);
//    [self.dateLabe setSingleLineAutoResizeWithMaxWidth:100];
    
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
