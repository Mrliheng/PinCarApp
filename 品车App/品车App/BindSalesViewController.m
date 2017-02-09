//
//  BindSalesViewController.m
//  品车App
//
//  Created by zt on 2016/11/29.
//  Copyright © 2016年 fei. All rights reserved.
//


#import "BindSalesViewController.h"
#import "qrCodeViewController.h"
#define textBGColor [UIColor colorWithRed:246/255.0 green:244/255.0 blue:242/255.0 alpha:0.1]  //文本框背景
#define btnHeight 50
#define placeHolderColor [UIColor colorWithRed:240/255.0 green:216/255.0 blue:223/255.0 alpha:1] //placeholder颜色
#define textSpace btnHeight/2        //文本框的文字距文本框左边的距离

@interface BindSalesViewController ()
{
    CGFloat _xSpace;

    UITextField *_inviteText;  //邀请码
    UIButton *_registBtn;      //注册
}
@end

@implementation BindSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _xSpace = (SCREEN_HEIGHT - 64 - 2 * btnHeight)/(2 + 3);

    self.title = self.navTitle;
    [self createUI];
}

-(void)createUI{
    
    _inviteText = [self createTextFieldWithPlaceHolder:@"邀请码(非必填项)"];
    _inviteText.keyboardType = UIKeyboardTypeNumberPad;
    UIButton *obtainInvite = [UIButton new];
    [obtainInvite addTarget:self action:@selector(scanQRCode) forControlEvents:UIControlEventTouchUpInside];
    [_inviteText addSubview:obtainInvite];
    obtainInvite.sd_layout
    .rightSpaceToView(_inviteText,8)
    .topSpaceToView(_inviteText,0)
    .bottomSpaceToView(_inviteText,0)
    .widthIs(btnHeight);
    [obtainInvite setLeftLine];
    
    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reg_qrcode"]];
    [obtainInvite addSubview:bgView];
    bgView.sd_layout
    .centerXEqualToView(obtainInvite)
    .centerYEqualToView(obtainInvite);
    
    UIButton *registBtn = [UIButton new];
    [registBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [registBtn setTitleColor:placeHolderColor forState:UIControlStateNormal];
    registBtn.layer.masksToBounds = YES;
    registBtn.layer.cornerRadius = btnHeight/2;
    registBtn.layer.borderColor = placeHolderColor.CGColor;
    registBtn.layer.borderWidth = 0.5;
    [registBtn addTarget:self action:@selector(bindSalesPer) forControlEvents:UIControlEventTouchUpInside];
    _registBtn = registBtn;
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:_inviteText,_registBtn, nil];
    [self setAutolayoutWithViews:arr];
    
}
-(UITextField *)createTextFieldWithPlaceHolder:(NSString *)placeHolder{
    
    UITextField *textField = [UITextField new];
    
    textField.placeholder = placeHolder;
    [textField setValue:placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    textField.textColor = [UIColor whiteColor];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = btnHeight/2;
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, textSpace, 0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.backgroundColor = textBGColor;
    
    return textField;
    
}

-(void)scanQRCode{
    
    qrCodeViewController *qrCode = [[qrCodeViewController alloc]init];
    __weak typeof(UITextField *)weakInvite = _inviteText;
    qrCode.block = ^(NSString *code){
        
        weakInvite.text = code;
    };
    [self.navigationController pushViewController:qrCode animated:YES];
    
}

-(void)setAutolayoutWithViews:(NSArray *)arr{
    
    CGFloat xSpace = 50;
    if (SCREEN_WIDTH<330) {
        xSpace = SCREEN_WIDTH/15;
    }
    
    for (UIView *view in arr) {
        [self.view addSubview:view];
    }
    for(int i=0;i<arr.count;i++){
        CGFloat topHeight;
        UIView *topView;
        if (i==0) {
            topView = self.view;
            topHeight = _xSpace*2;
        }
        else{
            topView = arr[i-1];
            topHeight = _xSpace;
        }
        UIView *view = arr[i];
        
        view.sd_layout
        .leftSpaceToView(self.view,xSpace)
        .rightSpaceToView(self.view,xSpace)
        .topSpaceToView(topView,topHeight)
        .heightIs(btnHeight);
        [view updateLayout];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bindSalesPer{
    
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
