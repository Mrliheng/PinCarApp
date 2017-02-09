//
//  TelToPersonTableViewCell.m
//  品车App
//
//  Created by zt on 2016/10/20.
//  Copyright © 2016年 fei. All rights reserved.
//
#define iconSpace 10      //小图标距离边距大小
#define iconWidth 50      //小图标宽高
#define rightSpace 50     //距离屏幕右边的边距大小
#define bigTitleFont 15   //大标题的字体大小
#define smallTitleFont 9 //小标题的字体大小
#define bigColor [UIColor blackColor]
#define smallColor [UIColor grayColor]

#define telTag 100        //拨打电话button的tag值，用来传递电话号码
#import "TelToPersonTableViewCell.h"

@interface TelToPersonTableViewCell ()<UIAlertViewDelegate>

//头像
@property (nonatomic,strong) UIImageView *iconView;
//大标题
@property (nonatomic,strong) UILabel *bigTitleLabel;
//小标题
@property (nonatomic,strong) UILabel *smallTitleLabel;
//拨打button
@property (nonatomic,strong) UIButton *telButton;


@end
@implementation TelToPersonTableViewCell

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
    
    self.bigTitleLabel = [UILabel new];
    self.bigTitleLabel.font = [UIFont systemFontOfSize:bigTitleFont];
    self.bigTitleLabel.textColor = bigColor;
    [self.contentView addSubview:self.bigTitleLabel];
    
    self.smallTitleLabel = [UILabel new];
    self.smallTitleLabel.font = [UIFont systemFontOfSize:smallTitleFont];
    self.smallTitleLabel.textColor = smallColor;
    [self.contentView addSubview:self.smallTitleLabel];
    
    self.telButton = [UIButton new];
    [self.contentView addSubview:self.telButton];
    [self.telButton addTarget:self action:@selector(telToSomeone:) forControlEvents:UIControlEventTouchUpInside];
    
    self.iconView.sd_layout
    .leftSpaceToView(self.contentView,iconSpace)
    .topSpaceToView(self.contentView,iconSpace)
    .heightIs(iconWidth)
    .widthIs(iconWidth);
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = iconWidth/2.0;
    
    self.telButton.sd_layout
    .rightSpaceToView(self.contentView,iconSpace)
    .topEqualToView(self.iconView)
    .widthIs(iconWidth)
    .heightIs(iconWidth);
    
    self.bigTitleLabel.sd_layout
    .leftSpaceToView(self.iconView,iconSpace)
    .topEqualToView(self.iconView)
    .heightRatioToView(self.iconView,0.5)
    .rightSpaceToView(self.telButton,iconSpace);
    
    self.smallTitleLabel.sd_layout
    .leftSpaceToView(self.iconView,iconSpace)
    .topSpaceToView(self.bigTitleLabel,1)
    .heightRatioToView(self.iconView,0.5)
    .rightSpaceToView(self.telButton,iconSpace);
    
    [self setupAutoHeightWithBottomView:self.iconView bottomMargin:iconSpace];
    
}
-(void)setCellWithIcon:(NSString *)icon withBigTitle:(NSString *)bigTitle withSmallTitle:(NSString *)smallTitle withTelButton:(UIImage *)telButton withRow:(NSInteger)row{
    
    self.telButton.tag = telTag +row;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"pers.png"]];
    self.bigTitleLabel.text = bigTitle;
    self.smallTitleLabel.text = smallTitle;
    [self.telButton setBackgroundImage:telButton forState:UIControlStateNormal];
    
}
-(void)telToSomeone:(UIButton *)btn{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"是否要拨打电话" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    alertView.tag = btn.tag - telTag;
    [alertView show];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {
            //
            if (self.block) {
                self.block(alertView.tag);

            }
        }
            break;
            
        case 1:
        {
            
        }
            break;
        default:
            break;
    }
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
