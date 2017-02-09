//
//  JSAddressPickerView.m
//  JSAddressDemo
//
//  Created by Macx on 16/8/19.
//  Copyright © 2016年 gaojs. All rights reserved.
//

#import "JSAddressPickerView.h"

@interface JSAddressPickerView () <UIPickerViewDelegate,UIPickerViewDataSource>

//@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSDictionary *selectedProvince;
@property (strong, nonatomic) NSDictionary *selectedCity;
@property (strong, nonatomic) NSDictionary *selectedTown;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) UIPickerView *pickView;
@property (strong, nonatomic) NSArray *pickerArray;

@end

@implementation JSAddressPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self getAddressInformation];
        [self setBaseView];
    }
    return self;
}

- (void)getAddressInformation {
   
    NSString *provincePath = [[NSBundle mainBundle]pathForResource:@"Allcity" ofType:@"json"];
    NSDictionary *provinceDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:provincePath] options:NSJSONReadingAllowFragments error:nil];
    self.pickerArray = provinceDic[@"provinces"];
    
    [self getProvinceAtIndex:0];
    [self getCityAtIndex:0];
    [self getTownAtIndex:0];
   
}
-(void)getTownAtIndex:(NSInteger)row{
//    NSString *townPath = [[NSBundle mainBundle] pathForResource:@"level3" ofType:@"json"];
//    NSDictionary *townDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:townPath] options:NSJSONReadingAllowFragments error:nil];
//    NSArray *townArr = townDic[@"rows"];
//    NSMutableArray *townMutArr = [NSMutableArray array];
//    for (NSDictionary *subDic in townArr) {
//        if ([subDic[@"parent_code"] isEqualToString:self.selectedCity[@"code"]]) {
//            [townMutArr addObject:subDic];
//        }
//    }
//    self.townArray = [NSArray arrayWithArray:townMutArr];
    self.townArray = self.selectedCity[@"city"];
    if (self.townArray.count > 0) {
        if (row >= self.townArray.count) {
            row = self.townArray.count - 1;
        }
        self.selectedTown = self.townArray[row];
    }
    
}
-(void)getCityAtIndex:(NSInteger)row{
//    NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"level2" ofType:@"json"];
//    NSDictionary *cityDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:cityPath] options:NSJSONReadingAllowFragments error:nil];
//    NSArray *cityArr = cityDic[@"rows"];
//    NSMutableArray *cityMutArr = [NSMutableArray array];
//    for (NSDictionary *subDic in cityArr) {
//        if ([subDic[@"parent_code"] isEqualToString:self.selectedProvince[@"code"]]) {
//            [cityMutArr addObject:subDic];
//        }
//    }
//    self.cityArray = [NSArray arrayWithArray:cityMutArr];
    self.cityArray = self.selectedProvince[@"state"];
    if (self.cityArray.count > 0) {
        if (row >= self.cityArray.count) {
            row = self.cityArray.count - 1;
        }
        self.selectedCity = self.cityArray[row];
    }

    
}
-(void)getProvinceAtIndex:(NSInteger)row{
    NSMutableArray *provinceMutArr = [NSMutableArray array];
    for (NSDictionary *subDic in self.pickerArray) {
        [provinceMutArr addObject:subDic[@"region"]];
    }
    self.provinceArray = [NSArray arrayWithArray:provinceMutArr];
    if (self.provinceArray.count > 0) {
        if (row >= self.provinceArray.count) {
            row = self.provinceArray.count - 1;
        }
        self.selectedProvince = self.provinceArray[row];
    }
    
}
- (void)setBaseView {
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    UIColor *color = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:249/255.0 alpha:1];
    UIColor *btnColor = [UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1];
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, height - 300, width, 30)];
    selectView.backgroundColor = color;
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:0];
    [cancleBtn setTitleColor:btnColor forState:0];
    cancleBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancleBtn addTarget:self action:@selector(dateCancleAction) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:cancleBtn];
    
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitle:@"确定" forState:0];
    [ensureBtn setTitleColor:btnColor forState:0];
    ensureBtn.frame = CGRectMake(width - 60, 0, 60, 40);
    [ensureBtn addTarget:self action:@selector(dateEnsureAction) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:ensureBtn];
  
    
    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, height - 220 -64 , width,  220)];
    self.pickView.delegate   = self;
    self.pickView.dataSource = self;
    self.pickView.backgroundColor = color;
    [self addSubview:self.pickView];
    [self.pickView reloadAllComponents];
    [self updateAddress];
    
    [self addSubview:selectView];
}
//code值传过来
- (void)updateAddressAtProvince:(NSString *)province city:(NSString *)city town:(NSString *)town {
    self.province = province;
    self.city = city;
    self.town = town;
    if (self.province) {
        for (NSInteger i = 0; i < self.provinceArray.count; i++) {
//            NSString *city = self.provinceArray[i];
//            NSInteger select = 0;
            NSDictionary *subDic = self.provinceArray[i];
            if ([self.province isEqualToString:subDic[@"code"]]) {
//                select = i;
                self.selectedProvince = subDic;
                [self.pickView selectRow:i inComponent:0 animated:YES];
                [self.pickView.delegate pickerView:self.pickView didSelectRow:i inComponent:0];
                break;
            }
        }
        [self getCityAtIndex:[self.pickView selectedRowInComponent:1]];
        for (NSInteger i = 0; i < self.cityArray.count; i++) {
            NSDictionary *subDic = self.cityArray[i];
            if ([subDic[@"code"] isEqualToString:self.city]) {
                self.selectedCity = subDic;
                [self.pickView selectRow:i inComponent:1 animated:YES];
                [self.pickView.delegate pickerView:self.pickView didSelectRow:i inComponent:1];
                break;
            }
        }
        [self getTownAtIndex:[self.pickView selectedRowInComponent:2]];
//        self.townArray = self.pickerDic[self.province][0][self.city];
        for (NSInteger i = 0; i < self.townArray.count; i++) {
            NSDictionary *subDic = self.townArray[i];
            if ([subDic[@"code"] isEqualToString:self.town]) {
                self.selectedTown = subDic;
                [self.pickView selectRow:i inComponent:2 animated:YES];
                [self.pickView.delegate pickerView:self.pickView didSelectRow:i inComponent:2];
                break;
            }
        }
    }
//    [self.pickView reloadAllComponents];
    [self updateAddress];

}

- (void)dateCancleAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JSAddressCancleAction:)]) {
        [self.delegate JSAddressCancleAction:@""];
    }
}

- (void)dateEnsureAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JSAddressPickerRerurnBlockWithProvince:city:town:)]) {
        [self.delegate JSAddressPickerRerurnBlockWithProvince:self.selectedProvince city:self.selectedCity town:self.selectedTown];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:self.font?:[UIFont boldSystemFontOfSize:14]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row][@"name"];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row][@"name"];
    } else {
        return [self.townArray objectAtIndex:row][@"name"];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.frame.size.width / 3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (component == 0) {
        self.selectedProvince = self.provinceArray[row];
        
        [self getCityAtIndex:[self.pickView selectedRowInComponent:1]];
        [self getTownAtIndex:[self.pickView selectedRowInComponent:2]];

        [pickerView reloadComponent:1];
        [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    if (component == 1) {
        self.selectedCity = self.cityArray[row];
        [self getTownAtIndex:[self.pickView selectedRowInComponent:2]];

        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    if (component == 2) {
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    [self updateAddress];

}

- (void)updateAddress {
    if(self.provinceArray.count > 0){
        self.selectedProvince = [self.provinceArray objectAtIndex:[self.pickView selectedRowInComponent:0]];
    }
    if (self.cityArray.count > 0) {
        self.selectedCity  = [self.cityArray objectAtIndex:[self.pickView selectedRowInComponent:1]];
    }
    else{
        self.selectedCity = nil;
    }
    if (self.townArray.count > 0) {
        self.selectedTown  = [self.townArray objectAtIndex:[self.pickView selectedRowInComponent:2]];
    }else{
        self.selectedTown = nil;
    }
}

@end
