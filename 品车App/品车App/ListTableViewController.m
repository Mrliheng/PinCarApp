
//
//  ListTableViewController.m
//  品车App
//
//  Created by fei on 16/10/25.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "ListTableViewController.h"
#import "ListTableViewCell.h"
#import "MTToViewTopButton.h"
#import "LabelTableViewController.h"
#import "InvitationViewController.h"
#import "DetailViewController.h"
#import "MoreTableViewController.h"


@interface ListTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //下拉列表背景图
    UIView *bkview;
    //下拉列表控制器
    LabelTableViewController *tablecontro;
    //下拉控制器（更多）
    MoreTableViewController *moretalecon;
    //全部主题
    NSArray *titleArr;
    
}


@end

@implementation ListTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestDateBase];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navcTitle;
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    
    //获取全部主题
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *param = @{@"fid":self.fildId};
    [manager GET:[NSString stringFollowBaseUrl:platetimURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"msg"]isEqualToString:@"success"]) {
            NSArray *tempArr = [responseObject objectForKey:@"data"];
            if (tempArr.count > 0) {
                titleArr = [NSArray arrayWithArray:titleArr];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    //所有车型
    UIButton *allcarBtn = [self CreateButtton:@"所有类型" :0];
    allcarBtn.tag = 10034;
    [allcarBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allcarBtn];
    //全部主题
    UIButton *alltimBtn = [self CreateButtton:@"全部主题" :SCREEN_WIDTH/3];
    alltimBtn.tag = 10036;
    [alltimBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alltimBtn];
    //更多
    UIButton *moreBtn = [self CreateButtton:@"更多" :SCREEN_WIDTH/3*2];
    moreBtn.tag = 10038;
    [moreBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    postButton.frame = CGRectMake(0, 0, 50, 35);
    [postButton setTitle:@"发新贴" forState:UIControlStateNormal];
    postButton.tintColor = [UIColor blackColor];
    [postButton addTarget:self action:@selector(PostInvitation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:postButton];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, SCREEN_HEIGHT-35-64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[ListTableViewCell class] forCellReuseIdentifier:@"ListTableView"];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    [self createToViewTopButton];

    __block int page = 2;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
       
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSNumber *numb = [NSNumber numberWithInteger:page];
        [params setValue:self.fildId forKey:@"fid"];
        [params setValue:numb forKey:@"page"];
        [manager POST:[NSString stringFollowBaseUrl:listTabURL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *dateArr = [responseObject objectForKey:@"data"];
            if ([[responseObject objectForKey:@"code"]isEqual:@0]&&dateArr.count > 0) {
                [self.resultArr addObjectsFromArray:dateArr];
                page ++;
                [self.tableView reloadData];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
}

//加载数据源
-(void)requestDateBase
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.fildId,@"fid", nil];
    [manager POST:[NSString stringFollowBaseUrl:listTabURL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"msg"]isEqualToString:@"success"]) {
            self.resultArr = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"data"]];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


//返回顶部按钮
- (void)createToViewTopButton
{
    MTToViewTopButton *topButton = [[MTToViewTopButton alloc] initWithFrame:CGRectZero scrollView:self.tableView];
    topButton.showBtnOffset = SCREEN_HEIGHT-64-35;
    [self.view addSubview:topButton];
    topButton.hidden = YES;
}

//发帖时间
-(void)PostInvitation
{
    InvitationViewController *invitation = [[InvitationViewController alloc]init];
    invitation.fildId = self.fildId;
    [self.navigationController pushViewController:invitation animated:YES];
}

-(UIButton *)CreateButtton:(NSString *)title :(CGFloat )pointX
{
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    Button.frame = CGRectMake(pointX, 0, SCREEN_WIDTH/3, 35);
    [Button setTintColor:[UIColor clearColor]];
    [Button setTitle:title forState:UIControlStateNormal];
    [Button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [Button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    //按钮图片不让自动渲染
    [Button setImage:[[UIImage imageNamed:@"21-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    //将按钮的图标和文字交换位置
    [Button setTitleEdgeInsets:UIEdgeInsetsMake(0, -Button.imageView.bounds.size.width-2, 0, Button.imageView.bounds.size.width)];
    [Button setImageEdgeInsets:UIEdgeInsetsMake(0, Button.titleLabel.bounds.size.width, 0, -Button.titleLabel.bounds.size.width-2)];
    Button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    return Button;
}

//创建下拉菜单
-(void)titleClick:(UIButton *)titButton
{
    if (!bkview) {
        bkview = [[UIView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, SCREEN_HEIGHT-99)];
        bkview.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.4];
    }
    [self.view addSubview:bkview];
    if (!tablecontro) {
        tablecontro = [[LabelTableViewController alloc]init];
    }
    
    if (titButton.tag == 10034)
    {
        if (moretalecon) {
            [moretalecon.view removeFromSuperview];
        }
        //所有类型
        tablecontro.tableArray = [NSMutableArray arrayWithObjects:@{@"name":@"精华"},@{@"name":@"最新"},@{@"name":@"热门"},@{@"name":@"热帖"}, nil];
        [tablecontro.tableView reloadData];
        [bkview addSubview:tablecontro.view];
    }
    else if (titButton.tag == 10036)
    {
        //全部车型
        if (moretalecon) {
            [moretalecon.view removeFromSuperview];
        }
        tablecontro.tableArray = [NSMutableArray arrayWithArray:titleArr];
        [tablecontro.tableView reloadData];
        [bkview addSubview:tablecontro.view];
    }
//    else if (titButton.tag == 10038)
//    {
//        //更多接口
//        if (tablecontro) {
//            [tablecontro.view removeFromSuperview];
//        }
//        if (!moretalecon) {
//            moretalecon = [[MoreTableViewController alloc]init];
//        }
//        [bkview addSubview:moretalecon.view];
//    }
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [bkview removeFromSuperview];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.resultArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableView" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListTableView"];
    }
    NSDictionary *dic = self.resultArr[indexPath.row];

    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]] placeholderImage:[UIImage imageNamed:@"hehhe.png"]];
    cell.titleLabel.text = dic[@"title"];
    cell.scanView.image = [UIImage imageNamed:@"18-1"];
    cell.scanLabel.text = dic[@"viewnum"];
    cell.eliteView.image = [UIImage imageNamed:@"18-3"];
    cell.commentView.image = [UIImage imageNamed:@"18-2"];
    cell.commentLabel.text = dic[@"postnum"];
    cell.dataLabe.text = dic[@"dateline"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detal = [[DetailViewController alloc]init];
    NSDictionary *dic = self.resultArr[indexPath.row];
    detal.requestUrl = [NSString stringWithFormat:@"%@",dic[@"url"]];
    detal.tid = [NSString stringWithFormat:@"%@",dic[@"tid"]];
    detal.supportNum = [[NSString stringWithFormat:@"%@",dic[@"recommend_add"]] integerValue];
    detal.likeNum = [[NSString stringWithFormat:@"%@",dic[@"favtimes"]] integerValue];
    [self.navigationController pushViewController:detal animated:YES];
}


@end
