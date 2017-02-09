//
//  HomeTableViewCell.m
//  品车App
//
//  Created by zt on 2016/10/25.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "HomeTableViewCell.h"

#define fontSize 18
#define imageHeight SCREEN_WIDTH*0.53  //图片宽是屏幕宽
#define labelHeight 40
@implementation HomeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        [self createUI];

    }
    return self;
}
-(void)createUI{
    
    self.iconView = [UIImageView new];
    [self.contentView addSubview:self.iconView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    
    self.distanceLabel = [UILabel new];
    self.distanceLabel.textColor = [UIColor whiteColor];
    self.distanceLabel.font = [UIFont systemFontOfSize:fontSize-5];
    self.distanceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.distanceLabel];
    
    self.iconView.sd_layout
    .rightSpaceToView(self.contentView,0)
    .leftSpaceToView(self.contentView,0)
    .topSpaceToView(self.contentView,0)
    .heightIs(imageHeight);
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,100)
    .bottomEqualToView(self.iconView)
    .heightIs(labelHeight);
    
    self.distanceLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .rightSpaceToView(self.contentView,10)
    .bottomEqualToView(self.iconView)
    .heightIs(labelHeight - 10);
    
    [self setupAutoHeightWithBottomView:self.iconView bottomMargin:0];

    
}

-(void)setCellWithIcon:(NSString *)icon withTitle:(NSString *)title withDistance:(NSString *)distance{
    
//    self.iconView.backgroundColor = [UIColor redColor];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:icon]];
    self.titleLabel.text = title;
    self.distanceLabel.text = distance;
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
