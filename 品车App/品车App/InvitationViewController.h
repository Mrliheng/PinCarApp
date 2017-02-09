//
//  InvitationViewController.h
//  品车App
//
//  Created by fei on 16/11/1.
//  Copyright © 2016年 fei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitationViewController : UIViewController

@property(nonatomic,strong)NSArray *titleReauleArr;

//帖子板块id
@property(nonatomic,strong)NSNumber *fildId;

//所选发帖的板块id
@property(nonatomic,strong)NSNumber *selectFid;

@end
