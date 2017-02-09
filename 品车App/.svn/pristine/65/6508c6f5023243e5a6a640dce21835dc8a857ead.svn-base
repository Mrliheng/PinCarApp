//
//  ChatViewController.m
//  品车App
//
//  Created by fei on 16/11/23.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "ChatViewController.h"
#import "UIView+CateGory.h"
#import "MBProgressHUD.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define MAINRGBCOLOR [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
{
    BOOL whosay;
}
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)UITableView *chatTab;

@end

@implementation ChatViewController
{
    UITextField *chatField;
    UIView *bgView;
    NSString *userName;
    MBProgressHUD *progressHUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteFriends)];
    userName = [[NSUserDefaults standardUserDefaults]objectForKey:USER_NAME];
    self.title = self.navcTitle;
    
    self.array = [NSMutableArray array];
    [self.view addSubview:self.chatTab];
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64-44, self.view.frame.size.width, 44)];
    bgView.backgroundColor = MAINRGBCOLOR;
    [self.view addSubview:bgView];
    chatField = [self.view initWithField:CGRectMake(5, 5, 300, 34) color:[UIColor whiteColor]];
    [bgView addSubview:chatField];
    
    UIButton *button = [self.view initWithBtn:CGRectMake(CGRectGetMaxX(chatField.frame)+4, 0, self.view.frame.size.width-CGRectGetMaxX(chatField.frame), 44) title:@"发送" titleColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:button];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWilShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWIlhide:) name:UIKeyboardWillHideNotification object:nil];

    
    progressHUD = [MBProgressHUD showHUDAddedTo:_chatTab animated:YES];
    progressHUD.delegate = self;
    progressHUD.label.text = @"加载中...";
    progressHUD.removeFromSuperViewOnHide = YES;
    
    [self getUsersMessage];
    
    
}
//删除好友
-(void)deleteFriends{

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    NSDictionary *param = @{@"uid":self.userid};
    [manager POST:[NSString stringFollowBaseUrl:deleteFriendsURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        progressHUD.hidden = YES;
        if ([[responseObject objectForKey:@"code"] isEqual:@0]) {
            [self.navigationController popViewControllerAnimated:YES];

        }
        else{
            NSLog(@"===%@",responseObject[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
    
}
//获取两个用户的对话列表
-(void)getUsersMessage
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    NSDictionary *param = @{@"touid":self.userid};
    [manager POST:[NSString stringFollowBaseUrl:getpmlistoneURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        progressHUD.hidden = YES;
        if ([[responseObject objectForKey:@"code"] isEqual:@0]) {
            NSArray *arry = [responseObject objectForKey:@"data"];
            if (arry.count > 0) {
                for (NSDictionary *dic in arry) {
                    UIView *chatView=[self chatViewwithDictionary:dic];
                    [_array addObject:chatView];
                }
                [_chatTab reloadData];
                //直接显示cell最底部
                NSInteger rows = [_chatTab numberOfRowsInSection:0];
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:rows-1 inSection:0];
                if (indexPath.row < [_chatTab numberOfRowsInSection:0]) {
                    [_chatTab scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        progressHUD.label.text = @"加载失败！";
        [progressHUD hideAnimated:YES afterDelay:2.0];
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWIlhide:(NSNotification *)user
{
    
}
-(void)keyboardWilShow:(NSNotification *)user
{
    if (_array.count>0)
    {
        NSIndexPath *index=[NSIndexPath indexPathForItem:_array.count-1 inSection:0];
        [_chatTab scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
}

-(UITableView *)chatTab
{
    if(!_chatTab)
    {
        _chatTab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-44) style:UITableViewStylePlain];
        _chatTab.dataSource = self;
        _chatTab.delegate = self;
        
        
        [_chatTab registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _chatTab.separatorColor = [UIColor clearColor];
        
        UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        
        [_chatTab addGestureRecognizer:tap];
    }
    return _chatTab;
    
}
-(void)tap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
-(void)btnClick:(UIButton *)sender
{
    if (chatField.text.length>0) {
        //走接口发布信息
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:self.userid,@"touid",chatField.text,@"message", nil];
        [manager POST:[NSString stringFollowBaseUrl:voiceMessageURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
        whosay = NO;
        NSString *totalString=[NSString stringWithFormat:@"%@",chatField.text];
        
        UIView *chatView=[self chatViewwithString:totalString];
        
        chatField.text = nil;
        
        [_array addObject:chatView];
        [_chatTab reloadData];
        //    滚动到最新的一行
        if (_array.count>0)
        {
            NSIndexPath *index=[NSIndexPath indexPathForItem:_array.count-1 inSection:0];
            [_chatTab scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
    
    
}


//加载聊天信息cell内容
-(UIView *)chatViewwithDictionary:(NSDictionary *)dict
{
    BOOL whoname = YES;
    if ([[dict objectForKey:@"msgfrom"]isEqualToString:userName]) {
        whoname = NO;
    }
    
    NSString *str = [dict objectForKey:@"message"];
    //自定义聊天内容
    CGRect rect = [str boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    //    聊天的内容
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(12, 3, rect.size.width+5, rect.size.height+20)];
    
    lab.text = str;
    lab.numberOfLines = 0;
    lab.textColor = [UIColor redColor];
    
    //对原有的图片进行拉伸
    NSString *imageName = whoname?@"bubble":@"bubbleSelf";
    
    UIImage *oldimage = [UIImage imageNamed:imageName];
    
    UIImage *newImage = [oldimage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    //头像
    int headviewX = whoname?10:WIDTH/2-12;
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(headviewX, CGRectGetHeight(lab.frame)-15, 30, 30)];
    NSURL *url = [NSURL URLWithString:[dict objectForKey:@"avatar"]];
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = 15;
    [headView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"personal"]];
    
    // 获取到拉伸后的图片
    int ImageX = whoname?CGRectGetWidth(headView.frame)+10:WIDTH/2-CGRectGetWidth(headView.frame)-CGRectGetWidth(lab.frame)-2;
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ImageX, 0, lab.frame.size.width+20, lab.frame.size.height+10)];
    bgImageView.image = newImage;
    
    //创建左右视图
    int x = whoname?0:[UIScreen mainScreen].bounds.size.width/2-25;
    UIView *chatView = [[UIView alloc]initWithFrame:CGRectMake(x, 10, 220, bgImageView.frame.size.height)];
    chatView.tag = 1;
    [chatView addSubview:bgImageView];
    [bgImageView addSubview:lab];
    [chatView addSubview:headView];
    
    return chatView;
}


//加载聊天信息cell内容
-(UIView *)chatViewwithString:(NSString *)string
{
    //自定义聊天内容
    CGRect rect = [string boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    //    聊天的内容
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(12, 3, rect.size.width+5, rect.size.height+20)];
    
    lab.text = string;
    lab.numberOfLines = 0;
    lab.textColor = [UIColor redColor];
    
    //对原有的图片进行拉伸
    NSString *imageName = whosay?@"bubble":@"bubbleSelf";
    UIImage *oldimage = [UIImage imageNamed:imageName];
    
    UIImage *newImage = [oldimage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    //头像
    int headviewX = whosay?10:WIDTH/2-12;
    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(headviewX, CGRectGetHeight(lab.frame)-15, 30, 30)];
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = 15;
    NSURL *url = [[NSUserDefaults standardUserDefaults]objectForKey:@"iconImagView"];
    [headView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"personal"]];
    
    // 获取到拉伸后的图片
    int ImageX = whosay?CGRectGetWidth(headView.frame)+10:WIDTH/2-CGRectGetWidth(headView.frame)-CGRectGetWidth(lab.frame)-2;
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ImageX, 0, lab.frame.size.width+20, lab.frame.size.height+10)];
    bgImageView.image = newImage;
    
    //创建左右视图
    int x = whosay?0:[UIScreen mainScreen].bounds.size.width/2-25;
    UIView *chatView = [[UIView alloc]initWithFrame:CGRectMake(x, 10, 220, bgImageView.frame.size.height)];
    chatView.tag = 1;
    [chatView addSubview:bgImageView];
    [bgImageView addSubview:lab];
    [chatView addSubview:headView];

    return chatView;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Class identifer = [UITableViewCell class];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(identifer) forIndexPath:indexPath];
    //    防止单元格重用
    UIView *moveView = [cell viewWithTag:1];
    [moveView removeFromSuperview];
    
    
    UIView *view = [_array objectAtIndex:indexPath.row];
    
    [cell addSubview:view];
    cell.selectionStyle = 0;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIView *chatView = [_array objectAtIndex:indexPath.row];
    
    return chatView.frame.size.height+20;
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
