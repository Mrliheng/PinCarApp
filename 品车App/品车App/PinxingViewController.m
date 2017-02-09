//
//  PinxingViewController.m
//  品车App
//
//  Created by zt on 2016/11/14.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "PinxingViewController.h"

@interface PinxingViewController ()

@end

@implementation PinxingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WechatIMG3.png"]];
//    bgView.frame = self.view.bounds;
//    [self.view addSubview:bgView];
    [self.view setbackgroundImage:[UIImage imageNamed:@"WechatIMG3.png"]];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 100, 40);
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
}

-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
