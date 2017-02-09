
//
//  PersonNameViewController.m
//  品车App
//
//  Created by fei on 16/11/3.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "PersonNameViewController.h"

@interface PersonNameViewController ()
{
    UITextField *textfild;
}

@end

@implementation PersonNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"真实姓名";
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];

    textfild = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 44)];
    textfild.backgroundColor = [UIColor whiteColor];
    textfild.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    textfild.leftViewMode = UITextFieldViewModeAlways;
    textfild.placeholder = @"请输入您的真实姓名";
    [self.view addSubview:textfild];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(BackLastView)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    
    
    
}

-(void)BackLastView
{
    if (textfild.text.length > 0) {
        if (self.passName) {
            self.passName(textfild.text);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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
