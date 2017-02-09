//
//  StoreViewController.m
//  品车App
//
//  Created by zt on 2016/10/27.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreCollectionViewCell.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "StoreDetailViewController.h"
#import "MessageViewController.h"
#import "ServiceRepresentativeTableViewController.h"


#define baseTag 100 //底部三个button的baseTag
#define scale 3/4.0 //图片宽高比,和cell相关

#define middleScale 0.3  //中间图片宽高比

#define scrollHeight SCREEN_WIDTH * 0.88 //轮播图的高
#define scrollWidth SCREEN_WIDTH  //轮播图的宽
#define labelH 0.1  //图片下面的标题高，和cell相关

#define bottomXspace 8 //底部三个图片的x距离
#define bottomYspace SCREEN_WIDTH*0.046 //底部三个图片的y距离
#define bottomWidth (SCREEN_WIDTH - bottomXspace*4)/3.0 //底部三个图片的宽
#define bottomHeight bottomWidth *scale //底部三个图片的高
#define bottomFont 14 //底部字体大小
#define lineSpace 1
@interface StoreViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>
{
    UIScrollView *_scrollView;  //背景scrollView;
    SDCycleScrollView *_headerScroll;
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
    NSMutableArray *_imageUrl; //存储轮播图图片地址
    NSMutableArray *_scrollUrl; //存储轮播图图片网址
    NSDictionary *_bottomDic;  //底部data。
}
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _navTitle;

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor whiteColor];

    if(![[NSUserDefaults standardUserDefaults]valueForKey:USER_NAME]){
        
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(login)];
        right.tintColor = [UIColor colorWithRed:249/255.0 green:66/255.0 blue:71/255.0 alpha:1];
        self.navigationItem.rightBarButtonItem = right;
        
    }

    _dataArray = [NSMutableArray array];
    _imageUrl = [NSMutableArray array];
    _scrollUrl = [NSMutableArray array];
    //获取轮播图图片
    [self getScrollImagesUrl];
    
}
-(void)login{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginViewController *login = [[LoginViewController alloc]init];
    app.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:login];
    
}
-(void)getScrollImagesUrl{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    NSInteger dealerId = [self.dealerId integerValue];
    NSNumber *dealerNum = [NSNumber numberWithInteger:dealerId];
    [manager GET:[NSString stringFollowBaseUrl:getScrollImages] parameters:@{@"dealerid":dealerNum} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *rootDic = responseObject;
        if ([rootDic[@"code"] integerValue] == 0) {
            for (NSDictionary *subDic in rootDic[@"data"]) {
                
                [_scrollUrl addObject:subDic[@"url"]];
                [_imageUrl addObject:subDic[@"img"]];
            }
            [self createHeadView];
            [self getCarData];
            [self createCollectionView];
            [self getOtherData];
        }

        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];

}
#pragma mark -- 获取车型信息
-(void)getCarData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSInteger dealerId = [self.dealerId integerValue];
    NSNumber *dealerNum = [NSNumber numberWithInteger:dealerId];
    [manager POST:[NSString stringFollowBaseUrl:getCarInfo] parameters:@{@"dealerid":dealerNum} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = responseObject;
        if ([rootDic[@"code"] integerValue] == 0) {
            
            [_dataArray addObjectsFromArray:rootDic[@"data"]];
            [_collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];

}
#pragma mark --获取除轮播图外的信息
-(void)getOtherData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSInteger dealerId = [self.dealerId integerValue];
    NSNumber *dealerNum = [NSNumber numberWithInteger:dealerId];
    [manager POST:[NSString stringFollowBaseUrl:getIndexInfo] parameters:@{@"dealerid":dealerNum} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = responseObject;
        if ([rootDic[@"code"] integerValue] == 0) {
            _bottomDic = rootDic[@"data"];
            [self createFooterViewWithDic:rootDic[@"data"]];

            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);

    }];
}
#pragma mark--创建collectionView
-(void)createCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH*middleScale+SCREEN_WIDTH*labelH);
    //竖排间距
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerScroll.frame), SCREEN_WIDTH, SCREEN_WIDTH*middleScale+SCREEN_WIDTH*labelH) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[StoreCollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId"];
    [_scrollView addSubview:_collectionView];
    
}
#pragma mark -- uicollectionView的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    if (_dataArray.count >0) {
        NSDictionary *dic = _dataArray[indexPath.row];
        [cell setCellWithImage:dic[@"img"] withTitle:dic[@"title"]];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StoreDetailViewController *store = [[StoreDetailViewController alloc]init];
    NSDictionary *dic = _dataArray[indexPath.row];
    store.url = dic[@"url"];
    store.navcTitle = dic[@"title"];
    [self.navigationController pushViewController:store animated:YES];
}
-(void)createFooterViewWithDic:(NSDictionary *)dic{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_collectionView.frame), SCREEN_WIDTH, lineSpace+bottomYspace*2 + bottomHeight)];
    [_scrollView addSubview:footerView];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, lineSpace, SCREEN_WIDTH, bottomYspace*2 + bottomHeight)];
    [footerView addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    NSArray *imgArr = @[[NSString stringWithFormat:@"%@",dic[@"bottom_left_img1"]],[NSString stringWithFormat:@"%@",dic[@"bottom_left_img2"]],[NSString stringWithFormat:@"%@",dic[@"bottom_left_img3"]]];
    NSArray *titles = @[[NSString stringWithFormat:@"%@",dic[@"bottom_left_title1"]],[NSString stringWithFormat:@"%@",dic[@"bottom_left_title2"]],[NSString stringWithFormat:@"%@",dic[@"bottom_left_title3"]]];
    for (int i=0; i<3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomView addSubview:btn];
        btn.frame = CGRectMake(bottomXspace + i*(bottomXspace+bottomWidth), bottomYspace, bottomWidth, bottomHeight);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTintColor:[UIColor whiteColor]];
        btn.tag = baseTag + i;
        btn.titleLabel.font = [UIFont systemFontOfSize:bottomFont];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [btn sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] forState:UIControlStateNormal];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgArr[i]] forState:UIControlStateNormal];
        
    }
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(footerView.frame));
    
}
-(void)btnClick:(UIButton *)btn{
    
    switch (btn.tag - baseTag) {
        case 0:
        {
            //
            StoreDetailViewController *store = [[StoreDetailViewController alloc]init];
            
            store.url = _bottomDic[@"bottom_left_link1"];
            store.navcTitle = _bottomDic[@"bottom_left_title1"];
            [self.navigationController pushViewController:store animated:YES];
        }
            break;
        case 1:
        {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:USER_NAME]) {
                //如果存有用户名，即登录成功后。
                ServiceRepresentativeTableViewController *ser = [[ServiceRepresentativeTableViewController alloc]init];
                ser.navcTitle = @"热线电话";
                [self.navigationController pushViewController:ser animated:YES];
            }
            else{
                //热线电话
                MessageViewController *msg = [[MessageViewController alloc]init];
                msg.isLogin = NO;
                [self.navigationController pushViewController:msg animated:YES];
            }
            
            
        }
            break;
        case 2:
        {
            //
            StoreDetailViewController *store = [[StoreDetailViewController alloc]init];
            
            store.url = _bottomDic[@"bottom_left_link3"];
            store.navcTitle = _bottomDic[@"bottom_left_title3"];
            [self.navigationController pushViewController:store animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)createHeadView{
    
    _headerScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, scrollWidth, scrollHeight) imageURLStringsGroup:_imageUrl];
    _headerScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    //    cycleScrollView.titlesGroup = remarks;
    _headerScroll.delegate = self;
    // 轮播时间间隔，默认1.0秒，可自定义
    _headerScroll.autoScrollTimeInterval = 5.0;
    [_scrollView addSubview:_headerScroll];
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    StoreDetailViewController *store = [[StoreDetailViewController alloc]init];
    
    store.url = _scrollUrl[index];
    
    [self.navigationController pushViewController:store animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
