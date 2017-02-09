//
//  TelToPersonTableViewCell.h
//  品车App
//
//  Created by zt on 2016/10/20.
//  Copyright © 2016年 fei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^telBlock)(NSInteger index);
@interface TelToPersonTableViewCell : UITableViewCell

/**
 拨打电话按钮的block
 */
@property (nonatomic,copy) telBlock block;

/**
 设置cell的icon(小图标)，bigTitle(大标题),smallTitle(小标题),telButton(按钮图片),row(第几行)
 */
-(void)setCellWithIcon:(NSString *)icon withBigTitle:(NSString *)bigTitle withSmallTitle:(NSString *)smallTitle withTelButton:(UIImage *)telButton withRow:(NSInteger)row;
@end
