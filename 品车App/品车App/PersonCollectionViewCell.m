
//
//  PersonCollectionViewCell.m
//  品车App
//
//  Created by fei on 16/10/28.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "PersonCollectionViewCell.h"

@implementation PersonCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconViw = [[UIImageView alloc]init];
        [self.contentView addSubview:self.iconViw];
        self.titLabel = [[UILabel alloc]init];
        self.titLabel.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:self.titLabel];
        [self CreateView];
    }
    return self;
}

-(void)CreateView
{
    self.iconViw.sd_layout
    .centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView,SCREEN_WIDTH/12)
    .widthIs(SCREEN_WIDTH/12)
    .heightEqualToWidth();
    
    self.titLabel.sd_layout
    .centerXEqualToView(self.contentView)
    .bottomSpaceToView(self.contentView,SCREEN_WIDTH/12)
    .autoHeightRatio(0);
    [self.titLabel setSingleLineAutoResizeWithMaxWidth:(SCREEN_WIDTH/4)];
    
    
}

@end
