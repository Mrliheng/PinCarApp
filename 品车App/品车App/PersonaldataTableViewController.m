
//
//  PersonaldataTableViewController.m
//  品车App
//
//  Created by fei on 16/11/3.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "PersonaldataTableViewController.h"
#import "PersonNameViewController.h"
#import "ChangePwdViewController.h"
#import "JSAddressPickerView.h"
#import "MBProgressHUD.h"

@interface PersonaldataTableViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,JSAddressPickerDelegate,MBProgressHUDDelegate>
{
    NSArray *titleArray;
    NSIndexPath *index;
    NSArray *sexArray;
    NSInteger sexrow;

}

@property(nonatomic,strong)UIDatePicker *datapicker;

@property (nonatomic, strong) JSAddressPickerView *pickerView;

@end

@implementation PersonaldataTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.navcTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(SavePersonalMessage)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    self.changePersonal = [[NSMutableDictionary alloc]init];
//    titleArray = @[@[@"头衔",@"里程",@"品币"],@[@"真实姓名",@"性别",@"出生日期",@"出生城市",@"居住城市"],@[@"修改密码"]];
    titleArray = @[@[@"头衔",@"里程"],@[@"真实姓名",@"性别",@"出生日期",@"出生城市",@"居住城市"],@[@"修改密码"]];
    if (self.dataDic.count>0) {
        NSString *sex;
        if ([[self.dataDic objectForKey:@"sex"]isEqual:@1]) {
            sex = @"男";
        }else{
            sex = @"女";
        }
//        self.dataArray = @[@[[self.dataDic objectForKey:@"grouptitle"],[self.dataDic objectForKey:@"extcredits1"],[self.dataDic objectForKey:@"extcredits2"]],@[[self.dataDic objectForKey:@"realname"],sex,[self.dataDic objectForKey:@"birth"],[NSString stringWithFormat:@"%@ %@",[self.dataDic objectForKey:@"birthprovince"],[self.dataDic objectForKey:@"birthcity"]],[NSString stringWithFormat:@"%@ %@",[self.dataDic objectForKey:@"resideprovince"],[self.dataDic objectForKey:@"residecity"]]],@[@""]];
        self.dataArray = @[@[[self.dataDic objectForKey:@"grouptitle"],[self.dataDic objectForKey:@"extcredits1"]],@[[self.dataDic objectForKey:@"realname"],sex,[self.dataDic objectForKey:@"birth"],[NSString stringWithFormat:@"%@ %@",[self.dataDic objectForKey:@"birthprovince"],[self.dataDic objectForKey:@"birthcity"]],[NSString stringWithFormat:@"%@ %@",[self.dataDic objectForKey:@"resideprovince"],[self.dataDic objectForKey:@"residecity"]]],@[@""]];
    }else
    {
        self.dataArray = @[@[@"",@"",@""],@[@"",@"",@"",@"",@""],@[@""]];
    }

    self.tableView.tableFooterView = [[UITableView alloc]init];
    
    sexArray = @[@"男",@"女"];
    
}


-(void)SavePersonalMessage
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    progressHUD.delegate = self;
    progressHUD.label.text = @"保存中...";
    progressHUD.removeFromSuperViewOnHide = YES;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    [manager POST:[NSString stringFollowBaseUrl:changepersonalmessageURL] parameters:self.changePersonal progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        progressHUD.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        progressHUD.label.text = @"保存失败！";
        [progressHUD hideAnimated:YES afterDelay:1.5];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArray = titleArray[section];
    return sectionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonaldataCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PersonaldataCell"];
    }
    NSArray *tempArr = titleArray[indexPath.section];
    NSArray *tempData = self.dataArray[indexPath.section];
    cell.textLabel.text = tempArr[indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",tempData[indexPath.row]];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    if (indexPath.section == 0) {
        cell.userInteractionEnabled = NO;
    }else{
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"21-2"]];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        switch (indexPath.row) {
            case 0:
            {
                //真实姓名
                PersonNameViewController *personname = [[PersonNameViewController alloc]init];
                personname.passName =^(NSString *str)
                {
                    cell.detailTextLabel.text = str;
                    [self.changePersonal setObject:[NSString stringWithFormat:@"%@",str] forKey:@"realname"];
                };
                
                [self.navigationController pushViewController:personname animated:YES];
            }
                break;
            case 1:
            {
                //性别
                self.tableView.scrollEnabled = NO;
                index = indexPath;
                [self CreatDataPicker];
            }
                break;
            case 2:
            {
                //出生日期
                self.tableView.scrollEnabled = NO;
                index = indexPath;
                [self CreatDataPicker];
            }
                break;
            case 3:
            {
                //出生城市
                self.tableView.scrollEnabled = NO;
                index = indexPath;
                [self enterAddress];
                
            }
                break;
            case 4:
            {
                //居住城市
                self.tableView.scrollEnabled = NO;
                [self enterAddress];
                index = indexPath;
            }
                break;
 
            default:
                break;
        }

    }else if(indexPath.section == 2){
        ChangePwdViewController *change = [[ChangePwdViewController alloc]init];
        [self.navigationController pushViewController:change animated:YES];
    }
}


-(void)CreatDataPicker
{
    if (!self.datapicker) {
        self.datapicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-220, SCREEN_WIDTH, 220)];
    }
    if (!self.sexPick) {
        self.sexPick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-220, SCREEN_WIDTH, 220)];
        self.sexPick.delegate = self;
        self.sexPick.dataSource = self;
        self.sexPick.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:249/255.0 alpha:1];
    }
    UIColor *color = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:249/255.0 alpha:1];
    UIColor *btnColor = [UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 314, SCREEN_HEIGHT, 30)];
    selectView.backgroundColor = color;
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:0];
    [cancleBtn setTitleColor:btnColor forState:0];
    cancleBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancleBtn addTarget:self action:@selector(dateCancleAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:cancleBtn];
    
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitle:@"确定" forState:0];
    [ensureBtn setTitleColor:btnColor forState:0];
    ensureBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40);
    [ensureBtn addTarget:self action:@selector(dateEnsureAction:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:ensureBtn];
    [view addSubview:selectView];
    NSLocale *detalocal = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    self.datapicker.locale = detalocal;
    self.datapicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    self.datapicker.datePickerMode = UIDatePickerModeDate;
    self.datapicker.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:249/255.0 alpha:1];
    if (index.row ==  2) {
        [view addSubview:self.datapicker];
    }else if (index.row == 1){
        [view addSubview:self.sexPick];
    }
    [self.tableView addSubview:view];
}

-(void)dateCancleAction:(UIView *)view
{
    self.tableView.scrollEnabled = YES;
    [view.superview.superview removeFromSuperview];
}
-(void)dateEnsureAction:(UIView *)view
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    self.tableView.scrollEnabled = YES;
    if (index.row == 1) {
        cell.detailTextLabel.text = sexArray[sexrow];
        [self.changePersonal setValue:sexArray[sexrow] forKeyPath:@"sex"];
    }else if(index.row == 2)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:nil];
        [formatter setDateFormat:dateFormat];
        NSString *timeDate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datapicker.date]];
        cell.detailTextLabel.text = timeDate;
        NSRange range = NSMakeRange(5, 2);
        [self.changePersonal setValue:[timeDate substringToIndex:4] forKeyPath:@"birthyear"];
        [self.changePersonal setValue:[timeDate substringWithRange:range] forKeyPath:@"birthmonth"];
        [self.changePersonal setValue:[timeDate substringFromIndex:8] forKeyPath:@"birthday"];
    }
    [view.superview.superview removeFromSuperview];
}


- (void)enterAddress {
//    [self.view endEditing:YES];
    if (self.pickerView) {
        [self.pickerView updateAddressAtProvince:self.selectedProvince[@"code"] city:self.selectedCity[@"code"] town:self.selectedTown[@"code"]];
        self.pickerView.hidden = NO;
        
        return;
    }
    self.pickerView = [[JSAddressPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.pickerView updateAddressAtProvince:self.selectedProvince[@"code"] city:self.selectedCity[@"code"] town:self.selectedTown[@"code"]];
    self.pickerView.delegate = self;
    self.pickerView.font = [UIFont boldSystemFontOfSize:14];
    [self.tableView addSubview:self.pickerView];
}

- (void)JSAddressCancleAction:(id)senter {
    self.tableView.scrollEnabled = YES;
    self.pickerView.hidden = YES;
}

- (void)JSAddressPickerRerurnBlockWithProvince:(NSDictionary *)province city:(NSDictionary *)city town:(NSDictionary *)town {
    self.tableView.scrollEnabled = YES;
    self.pickerView.hidden = YES;
    self.selectedProvince = province;
    self.selectedCity = city;
    self.selectedTown = town;
    NSString *address;
    if (!town) {
        address = [NSString stringWithFormat:@"%@-%@",province[@"name"],city[@"name"]];
    }
    else if (!city){
        address = [NSString stringWithFormat:@"%@",province[@"name"]];
    }
    else{
        address = [NSString stringWithFormat:@"%@-%@-%@",province[@"name"],city[@"name"],town[@"name"]];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    cell.detailTextLabel.text = address;
    
    if (index.row == 3){
//        NSLog(@"出生城市");
        
        [self.changePersonal setValue:[NSString stringWithFormat:@"%@",province[@"name"]] forKey:@"birthprovince"];
        [self.changePersonal setValue:[NSString stringWithFormat:@"%@",city[@"name"]] forKey:@"birthcity"];
        [self.changePersonal setValue:[NSString stringWithFormat:@"%@",town[@"name"]] forKey:@"birthdist"];

        
    }else if (index.row == 4){
//        NSLog(@"居住城市");
        [self.changePersonal setValue:[NSString stringWithFormat:@"%@",province[@"name"]] forKey:@"resideprovince"];
        [self.changePersonal setValue:[NSString stringWithFormat:@"%@",city[@"name"]] forKey:@"residecity"];
        [self.changePersonal setValue:[NSString stringWithFormat:@"%@",town[@"name"]] forKey:@"residedist"];
    }
    
}

- (void)setPickerView:(JSAddressPickerView *)pickerView {
    if (!_pickerView) {
        
    }
    _pickerView = pickerView;
}

//显示返回的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//显示返回的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return sexArray.count;
}

//返回当前行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    sexrow = row;
    return [sexArray objectAtIndex:row];
}

@end
