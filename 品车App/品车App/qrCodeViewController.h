//
//  qrCodeViewController.h
//  品车App
//
//  Created by zt on 2016/11/14.
//  Copyright © 2016年 fei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^obtainQRCode)(NSString *str);
@interface qrCodeViewController : UIViewController

@property (nonatomic,copy) obtainQRCode block;
@end
