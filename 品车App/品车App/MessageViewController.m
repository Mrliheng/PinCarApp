//
//  MessageViewController.m
//  品车App
//
//  Created by zt on 2016/10/20.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "MessageViewController.h"
#import "TelToPersonTableViewCell.h"

#define textSpace 5        //文本框的文字距文本框左边的距离
#define nameHeight 50 //姓名和电话的高度
#define nameWidth 50  //姓名和电话的宽度
#define xSpace 10
#define height 70
#define lineSpace 1
#define btnWidth 100 //提交按钮的宽
#define fontSize 17 //姓名，电话，提交的字体大小
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface MessageViewController ()<UIAlertViewDelegate>
{
    TelToPersonTableViewCell *cell;
    NSString *_dealerId;
    NSDictionary *_perDic;
    UITableViewCell *_cell;
}

@property (nonatomic,strong)UITextView *textView;

@property (nonatomic,strong)UITextField *nameText;
@property (nonatomic,strong)UITextField *telText;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"留言";
    [self createUI];
    [self getData];
    if(![[NSUserDefaults standardUserDefaults]valueForKey:USER_NAME]){
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(login)];
        right.tintColor = [UIColor colorWithRed:249/255.0 green:66/255.0 blue:71/255.0 alpha:1];
        self.navigationItem.rightBarButtonItem = right;
        
    }
    

}

-(void)login{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginViewController *login = [[LoginViewController alloc]init];
    app.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:login];
    
}

-(void)getData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    _dealerId = [[NSUserDefaults standardUserDefaults]stringForKey:DEALER_ID];
    NSInteger dealerId = [_dealerId integerValue];
    NSNumber *dealerNum = [NSNumber numberWithInteger:dealerId];
    [manager GET:[NSString stringFollowBaseUrl:getASellerTel] parameters:@{@"dealerid":dealerNum} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = responseObject;
        if ([rootDic[@"code"] integerValue] == 0) {
            
            NSArray *data = rootDic[@"data"];
            if (data.count >0) {
                NSDictionary *perDic = data[0];
                _perDic = perDic;
                if (!_isLogin){
                    [cell setCellWithIcon:[NSString stringWithFormat:@"%@",perDic[@"avtar"]] withBigTitle:[NSString stringWithFormat:@"%@",perDic[@"username"]] withSmallTitle:@"销售代表" withTelButton:[UIImage imageNamed:@"11-13"] withRow:0];
                }
                else{
                    _cell.textLabel.font = [UIFont systemFontOfSize:18];
                    _cell.textLabel.text = @"店内客服";
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setBackgroundImage:[UIImage imageNamed:@"11-13"] forState:UIControlStateNormal];
                    btn.frame = CGRectMake(0, 0, 50, 50);
                    [btn addTarget:self action:@selector(telToStore) forControlEvents:UIControlEventTouchUpInside];
                    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    _cell.accessoryView = btn;
                }
                

            }
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
}
-(void)createUI{
    
    //创建最上面的textView
    UITextView *textView = [UITextView new];
    [self.view addSubview:textView];
    _textView = textView;
    
    
    //创建中间的提交按钮
    UIView *submitView = [UIView new];
    submitView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:submitView];
    UIButton *submitButton = [UIButton new];
    submitButton.backgroundColor = [UIColor redColor];
    submitButton.layer.masksToBounds = YES;
    submitButton.layer.cornerRadius = (height - 2*xSpace) / 2;
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [submitButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [submitView addSubview:submitButton];
    
    //创建最下面的随机出现的销售代表
    cell = [[TelToPersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    cell.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cell];
    
    _cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    _cell.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_cell];
    
    cell.sd_layout
    .leftSpaceToView(self.view,xSpace)
    .bottomSpaceToView(self.view,xSpace)
    .rightSpaceToView(self.view,xSpace)
    .heightIs(height);
//    [cell setupAutoHeightWithBottomView:self.view bottomMargin:0];
    
    _cell.sd_layout
    .leftSpaceToView(self.view,xSpace)
    .bottomSpaceToView(self.view,xSpace)
    .rightSpaceToView(self.view,xSpace)
    .heightIs(height);
    
    submitView.sd_layout
    .leftEqualToView(cell)
    .bottomSpaceToView(cell,lineSpace)
    .rightEqualToView(cell)
    .heightIs(height);
    
    submitButton.sd_layout
    .topSpaceToView(submitView,xSpace)
    .bottomSpaceToView(submitView,xSpace)
    .widthIs(btnWidth)
    .centerXEqualToView(submitView);
    
    if (!_isLogin) {
        //如果没有登录，则显示出姓名和电话
        _cell.hidden = YES;
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = @"姓名:";
        nameLabel.textAlignment = NSTextAlignmentRight;
        nameLabel.backgroundColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:fontSize];
        [self.view addSubview:nameLabel];
        
        _nameText = [UITextField new];
        _nameText.backgroundColor = [UIColor whiteColor];
        _nameText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, textSpace, 0)];
        _nameText.leftViewMode = UITextFieldViewModeAlways;
        _nameText.font = [UIFont systemFontOfSize:fontSize];
        [self.view addSubview:_nameText];
        
        UILabel *telLabel = [UILabel new];
        telLabel.text = @"电话:";
        telLabel.textAlignment = NSTextAlignmentRight;
        telLabel.backgroundColor = [UIColor whiteColor];
        telLabel.font = [UIFont systemFontOfSize:fontSize];
        [self.view addSubview:telLabel];
        
        _telText = [UITextField new];
        _telText.backgroundColor = [UIColor whiteColor];
        _telText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, textSpace, 0)];
        _telText.leftViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:_telText];
        _telText.font = [UIFont systemFontOfSize:fontSize];
        _telText.keyboardType = UIKeyboardTypePhonePad;
        
        telLabel.sd_layout
        .leftSpaceToView(self.view,xSpace)
        .bottomSpaceToView(submitView,lineSpace)
        .widthIs(nameWidth)
        .heightIs(nameHeight);
    
        _telText.sd_layout
        .leftSpaceToView(telLabel,0)
        .rightEqualToView(submitView)
        .heightIs(nameHeight)
        .bottomEqualToView(telLabel);
        
        nameLabel.sd_layout
        .leftEqualToView(telLabel)
        .bottomSpaceToView(telLabel,lineSpace)
        .heightIs(nameHeight)
        .widthIs(nameWidth);
        
        _nameText.sd_layout
        .leftSpaceToView(nameLabel,0)
        .rightEqualToView(submitView)
        .heightIs(nameHeight)
        .bottomEqualToView(nameLabel);
        
        textView.sd_layout
        .leftEqualToView(cell)
        .topSpaceToView(self.view,xSpace)
        .rightEqualToView(cell)
        .bottomSpaceToView(nameLabel,lineSpace);
    }
    else{
        cell.hidden = YES;
        textView.sd_layout
        .leftEqualToView(cell)
        .topSpaceToView(self.view,xSpace)
        .rightEqualToView(cell)
        .bottomSpaceToView(submitView,lineSpace);

    }
    
    
//    __weak typeof (NSDictionary *)weakDic = _perDic;
//    __weak typeof (BOOL)weakLogin = _isLogin;
    cell.block = ^(NSInteger row){
        
        NSURL *url;
//        if(!weakLogin){
        
            url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_perDic[@"mobile"]]];

//        }
//        else{
//         
//        }
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://18600016401"]];
        
        [[UIApplication sharedApplication] openURL:url];
    };

    
}
-(void)sendMessage{
//    if (_isLogin) {
//        //如果登录，则给销售代表留言
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
////        _dealerId = [[NSUserDefaults standardUserDefaults]stringForKey:DEALER_ID];
////        NSInteger dealerId = [_dealerId integerValue];
////        NSNumber *dealerNum = [NSNumber numberWithInteger:dealerId];
//        NSDictionary *paramDic;
//        paramDic = @{@"touid":_perDic[@"uid"],@"message":_textView.text};
//        
//        [manager POST:[NSString stringFollowBaseUrl:voiceMessageURL] parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
//            
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            
//            NSDictionary *rootDic = responseObject;
//            if([rootDic[@"code"] isEqual:@0]){
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"提交成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//            else{
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:rootDic[@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alert show];
//            }
//            
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            
//        }];
//        
////    }
//    else{
//        if (_telText.text.length == 0 || _nameText.text.length == 0) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"请留下您的手机号和姓名" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//            return;
//        }
        //未登录，给店里留言
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
        _dealerId = [[NSUserDefaults standardUserDefaults]stringForKey:DEALER_ID];
        NSInteger dealerId = [_dealerId integerValue];
        NSNumber *dealerNum = [NSNumber numberWithInteger:dealerId];
        NSDictionary *paramDic;
    if(_nameText || _telText){
        
        paramDic = @{@"fid":dealerNum,@"realname":_nameText.text,@"message":_textView.text,@"mobile":_telText.text};
        
    }
    else{
        paramDic = @{@"fid":dealerNum,@"realname":@"1",@"message":_textView.text,@"mobile":@"1"};
    }
    

        [manager POST:[NSString stringFollowBaseUrl:voiceToStore] parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *rootDic = responseObject;
            if([rootDic[@"code"] isEqual:@0]){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"提交成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:rootDic[@"msg"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
          
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
//    }
}
-(void)telToStore{
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"是否要拨打电话" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
    [alertView show];
    
    

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {
            //
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_perDic[@"service_phone"]]];
            [[UIApplication sharedApplication] openURL:url];
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
-(IBAction)dismissKeyBoard
{
    [_textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
