//
//  StoreCollectionViewCell.m
//  品车App
//
//  Created by zt on 2016/10/28.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "StoreCollectionViewCell.h"
#define scale 0.3 //图片宽高比
#define labelH 0.1  //图片下面的标题高
@interface StoreCollectionViewCell ()

@end

@implementation StoreCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconViw = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH/2, SCREEN_WIDTH*scale)];
        [self.contentView addSubview:self.iconViw];
        self.titLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconViw.frame), SCREEN_WIDTH/2, SCREEN_WIDTH*labelH)];
        self.titLabel.font = [UIFont systemFontOfSize:16.0];
        self.titLabel.textAlignment = NSTextAlignmentCenter;
        self.titLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titLabel];
    }
    return self;
}
-(void)setCellWithImage:(NSString *)icon withTitle:(NSString *)title{
    [self.iconViw sd_setImageWithURL:[NSURL URLWithString:icon]];
    self.titLabel.text = title;
}

@end
