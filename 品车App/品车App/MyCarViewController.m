//
//  MyCarViewController.m
//  品车App
//
//  Created by fei on 16/11/17.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "MyCarViewController.h"
#import "IconTableViewCell.h"
#import "AddFriendsViewController.h"
#import "FriendsTableViewCell.h"
#import "MBProgressHUD.h"
#import "ChatViewController.h"

@interface MyCarViewController ()<UITableViewDelegate,UITableViewDataSource,FriendsTableViewCellDelegate,MBProgressHUDDelegate>
{
    //我的车友
    UIButton *buddyBtn;
    //好友申请
    UIButton *proposerBtn;
    
    MBProgressHUD *progressHUD;
}

@end

@implementation MyCarViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    buddyBtn.hidden = NO;
    proposerBtn.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    buddyBtn.hidden = YES;
    proposerBtn.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建添加好友。
    [self createItem];
    buddyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 80, 44)];
    [buddyBtn setImage:[UIImage imageNamed:@"buddy"] forState:UIControlStateNormal];
    [buddyBtn setImage:[UIImage imageNamed:@"buddysele"] forState:UIControlStateSelected];
    [buddyBtn addTarget:self action:@selector(CreateBuddy) forControlEvents:UIControlEventTouchUpInside];
    buddyBtn.selected = YES;
    [self.navigationController.view addSubview:buddyBtn];
    proposerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 80, 44)];
    [proposerBtn setImage:[UIImage imageNamed:@"proposer"] forState:UIControlStateNormal];
    [proposerBtn setImage:[UIImage imageNamed:@"proposersele"] forState:UIControlStateSelected];
    [proposerBtn addTarget:self action:@selector(CreatProposer) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:proposerBtn];
    
    buddyBtn.sd_layout
    .centerXIs(SCREEN_WIDTH/3);
    
    proposerBtn.sd_layout
    .centerXIs(SCREEN_WIDTH/3*2);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 15, 10);
    [button setImage:[[UIImage imageNamed:@"back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ViewBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    [self friendList];
}
//添加好友按钮
-(void)createItem{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"加友" style:UIBarButtonItemStyleDone target:self action:@selector(addFriends)];
}
-(void)addFriends{
    
    AddFriendsViewController *add = [[AddFriendsViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}
//返回按钮，（主要为了隐藏好友列表和好友申请两个按钮）
-(void)ViewBack
{
    [buddyBtn removeFromSuperview];
    [proposerBtn removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

//我的车友接口请求
-(void)friendList
{
    progressHUD = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    progressHUD.delegate = self;
    progressHUD.label.text = @"加载中...";
    progressHUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    NSDictionary *param = @{@"page":@1};
    [manager POST:[NSString stringFollowBaseUrl:getfriendlistURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        progressHUD.hidden = YES;
        if ([[responseObject objectForKey:@"code"]isEqual:@0]) {
            self.acceptArr = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败！");
        progressHUD.label.text = @"加载失败！";
        [progressHUD hideAnimated:YES afterDelay:2.0];
    }];
}

//我的车友
-(void)CreateBuddy
{
    buddyBtn.selected = YES;
    proposerBtn.selected = NO;
    progressHUD.hidden = YES;
    self.acceptArr = [NSMutableArray array];
    [self.tableView reloadData];
    [self friendList];
}
//好友申请
-(void)CreatProposer
{
    proposerBtn.selected = YES;
    buddyBtn.selected = NO;
    progressHUD.hidden = YES;
    self.acceptArr = [NSMutableArray array];
    [self.tableView reloadData];
    
    
    progressHUD = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    progressHUD.delegate = self;
    progressHUD.label.text = @"加载中...";
    progressHUD.removeFromSuperViewOnHide = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    NSDictionary *param = @{@"page":@1};
    [manager POST:[NSString stringFollowBaseUrl:getrequestlistURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        progressHUD.hidden = YES;
        if ([[responseObject objectForKey:@"code"]isEqual:@0]) {
            self.acceptArr = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败！!");
        progressHUD.label.text = @"加载失败！";
        [progressHUD hideAnimated:YES afterDelay:2.0];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.acceptArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCarCell"];
    if (!cell) {
        cell =  [[FriendsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCarCell"];
    }
    cell.cellDelegate = self;
    NSDictionary *dict = self.acceptArr[indexPath.row];
    [cell.iconView sd_setImageWithURL:[dict objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"pers.png"]];
    cell.titleLab.text = [dict objectForKey:@"username"];
    if (buddyBtn.selected) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.acceptBtn.hidden = YES;
        cell.nextView.hidden = NO;
        cell.nextView.image = [UIImage imageNamed:@"21-2"];
    }else if (proposerBtn.selected){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.acceptBtn.hidden = NO;
        cell.nextView.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dic = self.acceptArr[indexPath.row];
    ChatViewController *chat = [[ChatViewController alloc]init];
    chat.navcTitle = @"我的车友";
    chat.userid = [dic objectForKey:@"uid"];
    [self.navigationController pushViewController:chat animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//cell代理点击事件（即：好友申请里的“接受”按钮点击事件）
-(void)regiseTableViewCell:(FriendsTableViewCell *)cell
{
    
    progressHUD = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    progressHUD.delegate = self;
    progressHUD.label.text = @"处理中...";
    progressHUD.removeFromSuperViewOnHide = YES;
    
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    NSDictionary *dict = self.acceptArr[index.row];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"uid"],@"uid", nil];
    [manager POST:[NSString stringFollowBaseUrl:confirmationfriemURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //重新走一下获取好友申请列表
        [self CreatProposer];
        progressHUD.hidden = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        progressHUD.hidden = YES;
    }];
}

@end
