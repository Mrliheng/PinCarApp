//
//  FriendsTableViewCell.m
//  品车App
//
//  Created by fei on 16/11/21.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "FriendsTableViewCell.h"

@implementation FriendsTableViewCell

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
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = 20;
    [self.contentView addSubview:self.iconView];
    
    self.titleLab = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLab];
    
    self.nextView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.nextView];
    
    self.acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.acceptBtn setBackgroundColor:[UIColor redColor]];
    [self.acceptBtn setTitle:@"接受" forState:UIControlStateNormal];
    self.acceptBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    self.acceptBtn.layer.masksToBounds = YES;
    self.acceptBtn.layer.cornerRadius = 13;
    [self.acceptBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.acceptBtn addTarget:self action:@selector(AccrptButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.acceptBtn];
    
    self.iconView.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView,20)
    .topSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,10)
    .widthEqualToHeight();
    
    self.titleLab.sd_layout
    .leftSpaceToView(self.iconView,20)
    .centerYEqualToView(self.iconView)
    .heightIs(20);
    [self.titleLab setSingleLineAutoResizeWithMaxWidth:200];
    
    self.nextView.sd_layout
    .rightSpaceToView(self.contentView,20)
    .centerYEqualToView(self.contentView)
    .widthIs(8)
    .heightIs(15);
    
    self.acceptBtn.sd_layout
    .centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView,20)
    .widthIs(60)
    .heightIs(26);
    
}

-(void)AccrptButton
{
    [_cellDelegate regiseTableViewCell:self];
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
