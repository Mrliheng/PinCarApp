//
//  HomeTableViewController.m
//  品车App
//
//  Created by fei on 16/10/17.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "HomeTableViewController.h"

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "CityTableViewController.h"
#import "StoreViewController.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"


#define pageNum 3  //每页显示的条数
#define headerWidth 50 //头像的宽高
#define xSpace headerWidth/2  //头像距离页面左边距
#define ySpace 10  //头像距离页面上边距
#define dataHeight 40 //天气页面日期高度
#define dataWidth 108 //天气页面日期宽度
#define weatherWidth  45//天气页面图标宽度

@interface HomeTableViewController ()<CLLocationManagerDelegate,UIWebViewDelegate,MBProgressHUDDelegate>
{
    //经度
    CGFloat _longitude;
    //纬度
    CGFloat _latitude;
    //页数
    NSInteger _page;
    
    /***个人中心部分*****/
    UIButton *imageBtn;   //个人图标
    UILabel *labelName;   //名字
    UILabel *labelRank;   //等级
    UILabel *labelCourse; //里程标签
    //UILabel *labelGold;   //品币标签
    /***天气部分*****/
    UILabel *dayLabel;    //日子
    UILabel *weekLabel;   //星期
    UILabel *yearLabel;   //年月
    UIImageView *_weatherImage; //天气图标；
    UILabel *_tempLabel;  //低/高温度
    UILabel *_pmLabel;    //pm值
    
    NSMutableArray *_dataArray;
    CLLocationManager *_locationManager;
    NSString *_cityName;
    NSString *_cityId;
    UIView *_headerView;
    MBProgressHUD *progressHUD;

    //是否定位成功
    BOOL _isLocation;
    NSDictionary *_weatherDic;//天气接口返回的值
    UIView *_weatherView; //天气view;
    UIView *whiteView;    //天气view上的白色view

}
@property (nonatomic,strong) UIWebView *webView;

@end

@implementation HomeTableViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    if ([[NSUserDefaults standardUserDefaults]valueForKey:USER_NAME]) {
//        //获取用户基本信息
//        [self getUserInfomation];
//    }
}

//-(void)getUserInfomation{
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
//    [manager GET:[NSString stringFollowBaseUrl:getUserInfo] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSDictionary *rootDic = responseObject;
//        if ([rootDic[@"code"]integerValue] == 0) {
//            NSDictionary *data = rootDic[@"data"];
//            [imageBtn sd_setImageWithURL:[NSURL URLWithString:data[@"avatar"]] forState:UIControlStateNormal];
//            labelName.text = [[NSUserDefaults standardUserDefaults]stringForKey:USER_NAME];
//            labelRank.text = [NSString stringWithFormat:@"%@",data[@"grouptitle"]];
//            labelCourse.text = [NSString stringWithFormat:@"%@",data[@"extcredits1"]];
////            labelGold.text = [NSString stringWithFormat:@"%@",data[@"extcredits2"]];
//            
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//}
- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [NSMutableArray array];
    _page = 1;
    [self startLocating];
    self.navigationItem.title = @"首页";
    _cityName = @"定位中";
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //默认【上拉加载】
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (!_isLocation) {
            [self.tableView.mj_footer endRefreshing];

            return ;
        }
        _page ++;
        [self getData];
        [self.tableView.mj_footer endRefreshing];

    }];
    
    [self createItem:_cityName];

    if(![[NSUserDefaults standardUserDefaults]valueForKey:USER_NAME]){

        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(login)];
        right.tintColor = [UIColor colorWithRed:249/255.0 green:66/255.0 blue:71/255.0 alpha:1];
        self.navigationItem.rightBarButtonItem = right;

    }
//    else{
//        
//        [self createHeaderView];
//    }


    
}
#pragma mark --天气页面
-(void)getweather{
    NSString *appcode = @"18258472a22548ef8a7320fc0bafec9f";
    NSString *host = @"http://ali-weather.showapi.com";
    NSString *path = @"/gps-to-weather";
    NSString *method = @"GET";

    if (!_isLocation) {
        _latitude = 40.206;
        _longitude = 116.165;
    }
    NSString *querys = [NSString stringWithFormat:@"?from=5&lat=%@&lng=%@&need3HourForcast=0&needAlarm=0&needHourData=0&needIndex=0&needMoreDay=0",[NSString stringWithFormat:@"%f",_latitude],[NSString stringWithFormat:@"%f",_longitude]];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
    request.HTTPMethod  =  method;
    [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
    NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                   completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       NSLog(@"Response object: %@" , response);
                                                       if (error) {
                                                           [self getweather];
                                                       }
                                                       else{
                                                           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingAllowFragments error:nil];
                                                           NSLog(@"%@",dic);
                                                           _weatherDic = dic;
                                                           
                                                           if ([[NSUserDefaults standardUserDefaults]valueForKey:USER_NAME]) {
                                                               [self performSelectorOnMainThread:@selector(createWeatherItem) withObject:nil waitUntilDone:NO];
                                                           }
                                                       }
                                                   }];
    
    [task resume];
    

}
-(void)createWeatherItem{
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 28, 26)];
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 26, 15)];
    leftLabel.font = [UIFont systemFontOfSize:11];
    leftLabel.textAlignment = NSTextAlignmentRight;
    leftLabel.backgroundColor = [UIColor clearColor];
    NSDictionary *bodyDic = _weatherDic[@"showapi_res_body"];
    NSDictionary *nowDic = bodyDic[@"now"];
    leftLabel.text = [NSString stringWithFormat:@"%@°",nowDic[@"temperature"]];
    leftLabel.textColor = [UIColor blackColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel.frame) - 10, 3, 65-CGRectGetMaxX(leftLabel.frame), CGRectGetHeight(rightView.frame)-3)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",nowDic[@"weather_pic"]]]];
    [rightView addSubview:imageView];
    [rightView addSubview:leftLabel];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = 5;//这个值可以根据自己需要自己调整
    
    self.navigationItem.rightBarButtonItems = @[nagetiveSpacer,rightItem];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getDetailWeather)];
    [rightView addGestureRecognizer:tap];

}
-(void)getDetailWeather{
    
    [self createWeatherView];
    
}
-(void)createWeatherView{
    
    NSDictionary *bodyDic = _weatherDic[@"showapi_res_body"];
    NSDictionary *day1Dic = bodyDic[@"f1"];
    NSString *data = day1Dic[@"day"];
    NSString *year = [data substringWithRange:NSMakeRange(0, 4)];  //年
    NSString *month = [data substringWithRange:NSMakeRange(4, 2)]; //月
    NSString *day = [data substringFromIndex:6];                   //日
    NSString *week = day1Dic[@"weekday"];
    NSArray *weekArr = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    NSString *weekDay = weekArr[[week integerValue]-1];           //星期

    _weatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _weatherView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.7];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:_weatherView];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView)];
    [_weatherView addGestureRecognizer:tap];
    
    
    whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    [app.window addSubview:whiteView];
    whiteView.sd_layout
    .topEqualToView(app.window)
    .rightEqualToView(self.view)
    .leftEqualToView(self.view);
    /****** 日期 ******/
    UIView *dataView = [UIView new];
    [whiteView addSubview:dataView];
    //日子
    dayLabel = [UILabel new];
    dayLabel.textColor = [UIColor redColor];
    dayLabel.font = [UIFont fontWithName:@"微软雅黑" size:48];
    dayLabel.font = [UIFont systemFontOfSize:38];
    dayLabel.textAlignment = NSTextAlignmentRight;
    dayLabel.text = day;
    [dataView addSubview:dayLabel];
    //星期
    weekLabel = [UILabel new];
    [dataView addSubview:weekLabel];
    weekLabel.textColor = [UIColor purpleColor];
    weekLabel.text = weekDay;
    weekLabel.font = [UIFont fontWithName:@"微软雅黑" size:12];
    weekLabel.font = [UIFont systemFontOfSize:13];
//    weekLabel.font = [UIFont systemFontOfSize:14];
    //年月
    yearLabel = [UILabel new];
    [dataView addSubview:yearLabel];
    yearLabel.text = [NSString stringWithFormat:@"%@/%@",month,year];
    yearLabel.font = [UIFont fontWithName:@"微软雅黑" size:12];
    yearLabel.font = [UIFont systemFontOfSize:13];
    yearLabel.textColor = [UIColor purpleColor];
    //布局
    dataView.sd_layout
    .leftSpaceToView(whiteView,xSpace)
    .topSpaceToView(whiteView,ySpace*2+20)
    .widthIs(dataWidth)
    .heightIs(dataHeight);
    dayLabel.sd_layout
    .leftEqualToView(dataView)
    .topEqualToView(dataView)
    .bottomEqualToView(dataView)
    .widthIs(53);
    weekLabel.sd_layout
    .leftSpaceToView(dayLabel,3)
    .topSpaceToView(dataView,0)
    .rightEqualToView(dataView)
    .heightRatioToView(dataView,0.5);
    yearLabel.sd_layout
    .leftEqualToView(weekLabel)
    .topSpaceToView(weekLabel,0)
    .rightEqualToView(dataView)
    .bottomEqualToView(dataView);
    
    NSDictionary *nowDic = bodyDic[@"now"];
    NSDictionary *aqiDic = nowDic[@"aqiDetail"];
    /****** 天气 ******/
    UIView *weatherView = [UIView new];
    [whiteView addSubview:weatherView];
    //天气图标
    _weatherImage = [UIImageView new];
    [_weatherImage sd_setImageWithURL:[NSURL URLWithString:nowDic[@"weather_pic"]]];
    _weatherImage.contentMode = UIViewContentModeScaleAspectFit;
    [weatherView addSubview:_weatherImage];
    //温度
    _tempLabel = [UILabel new];
    [weatherView addSubview:_tempLabel];
    _tempLabel.text = [NSString stringWithFormat:@"%@/%@°C",day1Dic[@"night_air_temperature"],day1Dic[@"day_air_temperature"]];
    _tempLabel.textColor = [UIColor purpleColor];
    _tempLabel.font = [UIFont systemFontOfSize:15];
    //PM2.5
    UILabel *PM = [UILabel new];
    PM.text = @"PM2.5";
    [weatherView addSubview:PM];
    PM.textColor = [UIColor purpleColor];
    PM.font = [UIFont systemFontOfSize:15];
    //PM值
    _pmLabel = [UILabel new];
    [weatherView addSubview:_pmLabel];
    _pmLabel.text = [NSString stringWithFormat:@"%@",aqiDic[@"pm2_5"]];
    _pmLabel.textColor = [UIColor redColor];
    _pmLabel.font = [UIFont systemFontOfSize:28];
    
    //布局
    weatherView.sd_layout
    .rightSpaceToView(whiteView,ySpace)
    .topSpaceToView(whiteView,ySpace +20)
    .widthIs(dataWidth+25)
    .heightIs(dataHeight +2*ySpace);
    _weatherImage.sd_layout
    .topEqualToView(weatherView)
    .leftEqualToView(weatherView)
    .widthIs(weatherWidth)
    .heightRatioToView(weatherView,0.6);
    PM.sd_layout
    .leftEqualToView(weatherView)
    .topSpaceToView(_weatherImage,0)
    .widthIs(weatherWidth)
    .heightRatioToView(weatherView,0.4);
    _tempLabel.sd_layout
    .topSpaceToView(weatherView,0)
    .leftSpaceToView(_weatherImage,5)
    .rightEqualToView(weatherView)
    .heightRatioToView(weatherView,0.5);
    _pmLabel.sd_layout
    .topSpaceToView(_tempLabel,0)
    .leftEqualToView(_tempLabel)
    .heightRatioToView(weatherView,0.5)
    .rightEqualToView(weatherView);


    /****** 线label ******/
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = [UIColor redColor];
    [whiteView addSubview:lineLabel];
    lineLabel.sd_layout
    .topSpaceToView(dataView,ySpace*2)
    .leftSpaceToView(whiteView,0)
    .rightSpaceToView(whiteView,0)
    .heightIs(1);
    
    /****** 提示 ******/
    UIView *suggestionView = [UIView new];
//    suggestionView.backgroundColor = [UIColor blackColor];
    [whiteView addSubview:suggestionView];
    UILabel *contentLabel = [UILabel new];
    [suggestionView addSubview:contentLabel];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    
    //布局
    suggestionView.sd_layout
    .topSpaceToView(lineLabel,ySpace)
    .leftSpaceToView(whiteView,0)
    .rightSpaceToView(whiteView,0)
    .heightIs(60);
    contentLabel.sd_layout
    .leftSpaceToView(suggestionView,0)
    .rightSpaceToView(suggestionView,0)
    .topSpaceToView(suggestionView,ySpace)
    .bottomSpaceToView(suggestionView,ySpace);
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.text = [NSString stringWithFormat:@"%@,%@,%@,%@",nowDic[@"weather"],aqiDic[@"quality"],nowDic[@"wind_direction"],nowDic[@"wind_power"]];
    
    
    
    
    
    [whiteView setupAutoHeightWithBottomView:suggestionView bottomMargin:ySpace];
    
    
    
    
}
-(void)hideView{
    
    [whiteView removeFromSuperview];
    [_weatherView removeFromSuperview];
}
#pragma mark --上拉加载
-(void)loadMore{
    _page ++;
    [self getData];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark --登录成功后的头视图
-(void)createHeaderView
{
    
    _headerView = [UIView new];
    self.tableView.tableHeaderView = _headerView;
    _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //图标按钮
    imageBtn = [UIButton new];
    [_headerView addSubview:imageBtn];
    
    imageBtn.sd_layout
    .leftSpaceToView(_headerView,xSpace)
    .topSpaceToView(_headerView,ySpace)
    .widthIs(headerWidth)
    .heightIs(headerWidth);
    imageBtn.layer.cornerRadius = headerWidth/2;
    imageBtn.layer.masksToBounds = YES;
    
    labelName = [UILabel new];
    labelName.font = [UIFont systemFontOfSize:18];
    [_headerView addSubview:labelName];
    labelName.sd_layout
    .leftSpaceToView(imageBtn,xSpace)
    .topEqualToView(imageBtn)
    .heightIs(headerWidth/2.0)
    .rightSpaceToView(_headerView,xSpace);
    //宽度自适应
//    [labelName setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH - xSpace*2 - headerWidth];
    
    labelRank = [UILabel new];
    labelRank.font = [UIFont systemFontOfSize:14];
    [_headerView addSubview:labelRank];
    labelRank.sd_layout
    .leftEqualToView(labelName)
    .topSpaceToView(labelName,0)
    .heightIs(headerWidth/2.0)
    .rightSpaceToView(_headerView,xSpace);
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = [UIColor redColor];
    [_headerView addSubview:lineLabel];
    lineLabel.sd_layout
    .topSpaceToView(imageBtn,ySpace)
    .leftSpaceToView(_headerView,0)
    .rightSpaceToView(_headerView,0)
    .heightIs(1);
    
    UIButton *Lichen = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headerView addSubview:Lichen];

    Lichen.layer.masksToBounds = YES;
    Lichen.layer.cornerRadius = 15;
    Lichen.layer.borderColor = [UIColor redColor].CGColor;
    Lichen.layer.borderWidth = 2.0;
    [Lichen setTitle:@"里程" forState:UIControlStateNormal];
    [Lichen setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    Lichen.titleLabel.font = [UIFont systemFontOfSize:15.0];
    Lichen.sd_layout
    .leftEqualToView(imageBtn)
    .topSpaceToView(lineLabel,ySpace)
    .widthIs(headerWidth)
    .heightIs(30);
  
    /*品币
    UIButton *Pinbi = [UIButton buttonWithType:UIButtonTypeCustom];
    Pinbi.backgroundColor = [UIColor redColor];
    Pinbi.layer.masksToBounds = YES;
    Pinbi.layer.cornerRadius = 15;
    [Pinbi setTitle:@"品币" forState:UIControlStateNormal];
    Pinbi.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_headerView addSubview:Pinbi];
    Pinbi.sd_layout
    .leftSpaceToView(_headerView,SCREEN_WIDTH/2)
    .topEqualToView(Lichen)
    .heightIs(30)
    .widthIs(headerWidth);
    
     */
    labelCourse = [UILabel new];
    labelCourse.font = [UIFont boldSystemFontOfSize:16];
    [_headerView addSubview:labelCourse];
    labelCourse.sd_layout
    .leftSpaceToView(Lichen,10)
    .topEqualToView(Lichen)
    .heightIs(30)
    .rightSpaceToView(_headerView,10);
//    .rightSpaceToView(Pinbi,10);

    
    
//    labelGold = [UILabel new];
//    labelGold.font = [UIFont boldSystemFontOfSize:16];
//    [_headerView addSubview:labelGold];
//    labelGold.sd_layout
//    .leftSpaceToView(Pinbi,10)
//    .topEqualToView(Pinbi)
//    .heightIs(30)
//    .rightSpaceToView(_headerView,xSpace);
    
    [_headerView setupAutoHeightWithBottomView:Lichen bottomMargin:ySpace];
    
}

-(void)getData{
    
    if(_page == 1){
        
        _dataArray = [NSMutableArray array];
    }
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    [manager setSecurityPolicy:securityPolicy];

    NSInteger cityId = [_cityId integerValue];
    NSDictionary *paramDic;
    NSString *point = [NSString stringWithFormat:@"%f,%f",_longitude,_latitude];
    if (_cityId.length > 0) {
        paramDic = @{@"area":[NSNumber numberWithInteger:cityId],@"page":[NSNumber numberWithInteger:_page],@"point":point};
        //@"num":@pageNum,
    }
    [manager POST:[NSString stringFollowBaseUrl:getStoreList] parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = responseObject;
        NSArray *arr = rootDic[@"data"];
        if (arr.count <= 0 && _page!=1) {
            _page--;
            return ;
        }
        else if (arr.count <=0 && _page == 1){
            [self.tableView reloadData];
            return;
        }
        [_dataArray addObjectsFromArray: rootDic[@"data"]];
        if (_dataArray.count > 0  || [[NSUserDefaults standardUserDefaults]stringForKey:USER_NAME]) {
            
//            _webView.hidden = YES;
            [self.tableView reloadData];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    progressHUD.hidden = YES;
    
}
-(void)login{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginViewController *login = [[LoginViewController alloc]init];
    app.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:login];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    if (_dataArray.count == 0) {
        return cell;
    }
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell setCellWithIcon:dic[@"img"] withTitle:dic[@"name"] withDistance:dic[@"distance"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:SCREEN_WIDTH];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StoreViewController *store = [[StoreViewController alloc]init];
    NSDictionary *dic = _dataArray[indexPath.row];
    store.navTitle = dic[@"name"];
    store.dealerId = dic[@"id"];
    [[NSUserDefaults standardUserDefaults]setValue:dic[@"id"] forKey:DEALER_ID];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController pushViewController:store animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --开启定位
-(void)startLocating{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        _locationManager = [[CLLocationManager alloc]init];
        
        //设置定位的精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //设置距离筛选器distanceFilter，下面表示设备至少移动100米，才通知委托更新
        _locationManager.distanceFilter = 100.0f;
        _locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
        {
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
        //开始实时定位
        [_locationManager startUpdatingLocation];
    }
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    _longitude = manager.location.coordinate.longitude;
    _latitude = manager.location.coordinate.latitude;
    NSLog(@"Longitude = %f", manager.location.coordinate.longitude);
    NSLog(@"Latitude = %f", manager.location.coordinate.latitude);
    [_locationManager stopUpdatingLocation];
    [self getweather];

    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count <= 0) {
            _cityName = @"定位失败";
            [self getData];
            [self createItem:_cityName];
            _isLocation = NO;
            return ;
//            [self.tableView reloadData];
        }
        
        _isLocation = YES;

        
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            NSLog(@"%@", [test objectForKey:@"Country"]);
            NSLog(@"%@", [test objectForKey:@"State"]);
            if([[test objectForKey:@"State"] isEqualToString:@"北京市"] || [[test objectForKey:@"State"] isEqualToString:@"重庆市"] || [[test objectForKey:@"State"] isEqualToString:@"天津市"] || [[test objectForKey:@"State"] isEqualToString:@"上海市"]){
                
                _cityName = [test objectForKey:@"State"];

            }
            else{
                _cityName = [test objectForKey:@"SubLocality"];

            }
            NSLog(@"%@", [test objectForKey:@"SubLocality"]);

            [self createItem:_cityName];
            [self getCityIdFrom:_cityName];
            [self getData];
            NSLog(@"%@", [test objectForKey:@"Street"]);
        }
    }];
}
-(void)createItem:(NSString *)cityName{
    
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(0, 0, 65, 64);
    left.titleLabel.font = [UIFont systemFontOfSize:14];
    [left setTitle:_cityName forState:UIControlStateNormal];
    [left setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //按钮图片不让自动渲染
    [left setImage:[[UIImage imageNamed:@"21-4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    //将按钮的图标和文字交换位置
    [left setTitleEdgeInsets:UIEdgeInsetsMake(0, -left.imageView.bounds.size.width-2, 0, left.imageView.bounds.size.width)];
    [left setImageEdgeInsets:UIEdgeInsetsMake(0, left.titleLabel.bounds.size.width, 0, -left.titleLabel.bounds.size.width-2)];
    left.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [left addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -10;//这个值可以根据自己需要自己调整
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, leftItem];

}
-(void)selectCity{
    
    CityTableViewController *city = [[CityTableViewController alloc]init];
    
    city.locationBlock = ^(NSString *city){
        
        _cityName = city;
        [self createItem:_cityName];
        [self getCityIdFrom:_cityName];
        _page = 1;
        [self getData];
    };
    
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:city];
    [self presentViewController:navc animated:YES completion:nil];
}

#pragma mark --根据城市名称获取城市id
-(void)getCityIdFrom:(NSString *)cityName{
    
    NSString *Path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"json"];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:Path] options:NSJSONReadingAllowFragments error:nil];
    
    for (NSDictionary *subDic in array) {
        NSArray *subArr = subDic[@"city"];
        for (NSDictionary *subCity in subArr) {
            if ([cityName isEqualToString:subCity[@"name"]]) {
                
                _cityId = subCity[@"id"];
                break;
            }
        }
    }
}

@end
