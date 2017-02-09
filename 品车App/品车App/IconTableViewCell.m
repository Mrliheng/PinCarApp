//
//  IconTableViewCell.m
//  品车App
//
//  Created by zt on 2016/10/20.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "IconTableViewCell.h"

#define iconSpace 10    //小图标距离边距大小
#define iconWidth 25    //小图标宽高
#define rightSpace 50   //距离屏幕右边的边距大小
#define titleFont 15    //标题的字体大小

@interface IconTableViewCell ()

//小图标
@property (nonatomic,strong) UIImageView *iconView;
//标题
@property (nonatomic,strong) UILabel *titleLabel;

@end
@implementation IconTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //设置无点击效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self createUI];
    }
    return self;
}
-(void)createUI{
    
    self.iconView = [UIImageView new];
//    self.iconView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.iconView];

    self.titleLabel = [UILabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
    [self.contentView addSubview:self.titleLabel];
    
    self.iconView.sd_layout
    .leftSpaceToView(self.contentView,iconSpace)
    .centerYEqualToView(self.contentView)
    .heightIs(iconWidth)
    .widthIs(iconWidth);
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.iconView,iconSpace)
    .topEqualToView(self.iconView)
    .heightRatioToView(self.iconView,1.0f)
    .rightSpaceToView(self.contentView,rightSpace);
    
    [self setupAutoHeightWithBottomView:self.iconView bottomMargin:iconSpace];

}
-(void)setCellWithIcon:(UIImage *)icon withTitle:(NSString *)title withAccessoryView:(UIView *)accessoryView{
    
    self.iconView.image = icon;
    self.titleLabel.text = title;
    self.accessoryView = accessoryView;
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
