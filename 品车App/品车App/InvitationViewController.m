//
//  InvitationViewController.m
//  品车App
//
//  Created by fei on 16/11/1.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "InvitationViewController.h"
#import "LabelTableViewController.h"
#import "MBProgressHUD.h"

//关于图片选择器
#import "TZTestCell.h"
#import "TZImageManager.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>


#define imageCount 4
#define maxCount 5

@interface InvitationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,MBProgressHUDDelegate>
{
    UILabel *nubLabel;
    UIButton *timButton;
    //下拉列表背景图
    UIView *bkview;
    //下拉列表控制器
    LabelTableViewController *tablecontro;
    //标题输入框
    UITextField *titleFile;
    //内容输入框
    UITextView *contentView;
    
    NSMutableArray *_selectedAssets;
    CGFloat _margin;
    CGFloat _itemWh;
    
    MBProgressHUD *progressHUD;
    
    //存储图片aid
    NSMutableArray *aidArr;
    
}

@property (nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray * selectedPhotos;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property(nonatomic,strong)UIScrollView * scrollView;


@end

@implementation InvitationViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LabelViewTongzhi" object:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    self.title = @"发布新帖子";
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];

    aidArr = [NSMutableArray array];
    //获取发帖主题
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *param = @{@"fid":self.fildId};
    [manager GET:[NSString stringFollowBaseUrl:platetimURL] parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"msg"]isEqualToString:@"success"]) {
            NSArray *tempArr = [responseObject objectForKey:@"data"];
            if (tempArr.count > 0) {
                self.titleReauleArr = [NSArray arrayWithArray:tempArr];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    //注册通知(接收标题分裂发过来的值)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveTongzhi:) name:@"LabelViewTongzhi" object:nil];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    postButton.frame = CGRectMake(0, 0, 40, 30);
    [postButton setTitle:@"发布" forState:UIControlStateNormal];
    postButton.tintColor = [UIColor blackColor];
    [postButton addTarget:self action:@selector(Postinvitation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:postButton];
    self.navigationItem.rightBarButtonItem = rightBtn;
    UIView *classify = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    classify.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:classify];
    //分类 标签
    UILabel *fen = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
    fen.text = @"分类";
    fen.textColor = [UIColor grayColor];
    fen.textAlignment = NSTextAlignmentLeft;
    fen.font = [UIFont systemFontOfSize:16.0];
    [classify addSubview:fen];
    
    //主题标签
    timButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [timButton setTitle:@"全部主题" forState:UIControlStateNormal];
    [timButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    timButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [timButton addTarget:self action:@selector(titleClickLabel) forControlEvents:UIControlEventTouchUpInside];
    [classify addSubview:timButton];
    timButton.sd_layout
    .centerXEqualToView(classify)
    .centerYEqualToView(classify)
    .widthIs(100)
    .heightEqualToWidth(classify);
    
    UILabel *lines = [[UILabel alloc]init];
    lines.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    [classify addSubview:lines];
    lines.sd_layout
    .topSpaceToView(classify,10)
    .leftSpaceToView(fen,0)
    .widthIs(1.0)
    .heightIs(20);
    //标题label
    UILabel * titleLeb = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 45, 35)];
    titleLeb.text = @"标题 :";
    titleLeb.font = [UIFont systemFontOfSize:16.0];
    titleLeb.textColor = [UIColor grayColor];
    [self.view addSubview:titleLeb];
    
    titleFile = [[UITextField alloc]initWithFrame:CGRectMake(60, 40, SCREEN_WIDTH-100, 35)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:titleFile];
    titleFile.placeholder = @"请输出入标题";
    titleFile.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:titleFile];
    //标题后面的字数显示
    nubLabel = [[UILabel alloc]init];
    nubLabel.text = @"0/26";
    nubLabel.font = [UIFont systemFontOfSize:16.0];
    nubLabel.textColor = [UIColor grayColor];
    nubLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:nubLabel];
    nubLabel.sd_layout
    .centerYEqualToView(titleLeb)
    .rightSpaceToView(self.view,10)
    .heightIs(23)
    .widthIs(44);
//    .heightIs(23);
//    [nubLabel setSingleLineAutoResizeWithMaxWidth:60];

    
    UIView *longlin = [[UIView alloc]initWithFrame:CGRectMake(10, 75, SCREEN_WIDTH-10, 1)];
    longlin.backgroundColor = [UIColor grayColor];
    [self.view addSubview:longlin];

    //内容label
    UILabel * contentLeb = [[UILabel alloc]initWithFrame:CGRectMake(10, 76, 45, 35)];
    contentLeb.text = @"内容 :";
    contentLeb.font = [UIFont systemFontOfSize:16.0];
    contentLeb.textColor = [UIColor grayColor];
    [self.view addSubview:contentLeb];
    
    contentView = [[UITextView alloc]initWithFrame:CGRectMake(60, 76, SCREEN_WIDTH-80, SCREEN_HEIGHT/3)];
    contentView.font = [UIFont systemFontOfSize:16.0];
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
    //添加图片选择
    [self configCollectionView];
}

//发帖方法
-(void)Postinvitation
{
    if (!(titleFile.text>0) || !(contentView.text>0)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请完善相关发帖信息！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }else{
        progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        progressHUD.delegate = self;
        progressHUD.removeFromSuperViewOnHide = YES;
        progressHUD.label.text = @"发布中...";
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
        
        if (self.selectedPhotos.count>=1) {
            for (int i = 0; i<self.selectedPhotos.count; i++) {
                NSDictionary *params = @{@"fid":self.fildId};
                [manager POST:[NSString stringFollowBaseUrl:invitalimageURL] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    UIImage *image = self.selectedPhotos[i];
                    NSData * imageData = UIImageJPEGRepresentation(image, 0.3);
                    [formData appendPartWithFileData:imageData name:@"Filedata" fileName:@"123.png" mimeType:@"image/jpeg"];
                } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if ([[responseObject objectForKey:@"code"]isEqual:@0]) {
                        NSDictionary *dic = [responseObject objectForKey:@"data"];
//                        [self PostFinallInvital:[dic objectForKey:@"aid"]];
                        [aidArr addObject:[dic objectForKey:@"aid"]];
                        if (aidArr.count == self.selectedPhotos.count) {
                            [self PostFinallInvital:aidArr];
                        }
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                    progressHUD.label.text = @"发布失败，请重试！";
//                    [progressHUD hideAnimated:YES afterDelay:2.0];
                }];
            }
        }else{
            
            NSDictionary *params = [NSDictionary dictionary];
            if (self.selectFid) {
                params = @{@"fid":self.fildId,@"typeid":self.selectFid,@"subject":titleFile.text ,@"message":contentView.text};
            }else{
                params = @{@"fid":self.fildId,@"subject":titleFile.text ,@"message":contentView.text};
            }
            
//            NSDictionary *params = @{@"fid":self.fildId,@"typeid":self.selectFid,@"subject":titleFile.text ,@"message":contentView.text};
            [manager POST:[NSString stringFollowBaseUrl:postinvitationURL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                progressHUD.hidden = YES;
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                progressHUD.label.text = @"发布失败，请重试！";
                [progressHUD hideAnimated:YES afterDelay:2.0];
            }];
        }
    }
}

-(void)PostFinallInvital:(NSMutableArray *)array
{
    NSMutableString *hehe = [NSMutableString string];
    for (NSString*abc in aidArr) {
        NSString *cdf = [NSString stringWithFormat:@"[attachimg]%@[/attachimg]",abc];
        [hehe appendString:cdf];
    }
    NSString *manage = [NSString stringWithFormat:@"%@%@",contentView.text,hehe];
    NSDictionary *params = [NSDictionary dictionary];
    if (self.selectFid) {
        params = @{@"fid":self.fildId,@"typeid":self.selectFid,@"subject":titleFile.text ,@"message":manage};
    }else{
        params = @{@"fid":self.fildId,@"subject":titleFile.text ,@"message":manage};
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults]objectForKey:COOKIE] forHTTPHeaderField:@"cookie"];
    
    [manager POST:[NSString stringFollowBaseUrl:postinvitationURL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
        progressHUD.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        progressHUD.label.text = @"发布失败，请重试！";
        [progressHUD hideAnimated:YES afterDelay:2.0];
    }];
    
}


-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
//    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            NSString *label = [NSString stringWithFormat:@"%lu/26",(unsigned long)toBeString.length];
            nubLabel.text = label;
            if (toBeString.length > 26) {
                textField.text = [toBeString substringToIndex:26];
                nubLabel.text = @"26/26";
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }  
}


//创建下拉菜单
-(void)titleClickLabel
{
    timButton.selected = YES;
    if (!bkview) {
        bkview = [[UIView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, SCREEN_HEIGHT-99)];
        bkview.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.2];
    }
    [self.view addSubview:bkview];
    if (!tablecontro) {
        tablecontro = [[LabelTableViewController alloc]init];
        tablecontro.tableArray = [NSMutableArray arrayWithArray:self.titleReauleArr];
        [bkview addSubview:tablecontro.view];
    }
}

-(void)receiveTongzhi:(NSNotification *)text
{
    NSIndexPath *index = text.userInfo[@"numb"];
    self.selectFid = [self.titleReauleArr[index.row] objectForKey:@"typeid"];
    [timButton setTitle:[self.titleReauleArr[index.row] objectForKey:@"name"] forState:UIControlStateNormal];
    [bkview removeFromSuperview];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [bkview removeFromSuperview];
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
#pragma mark --图片选择器相关代码
- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _margin = 10;
    _itemWh = (SCREEN_WIDTH - (imageCount+1) * _margin) / imageCount;
    layout.itemSize = CGSizeMake(_itemWh, _itemWh);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - _itemWh - 60, SCREEN_WIDTH,_itemWh) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.contentInset = UIEdgeInsetsMake(_margin, _margin, _margin, _margin);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    [self.view addSubview:_collectionView];
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = NO;
}

#pragma mark UICollectionView代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
        cell.deleteBtn.hidden = YES;
    }
    else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.deleteBtn.hidden = NO;
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.row == maxCount) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最多只能选择9张" delegate:nil cancelButtonTitle:nil otherButtonTitles: @"确认", nil];
        [alertView show];
    }
    else if (indexPath.row == _selectedPhotos.count) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
#pragma clang diagnostic pop
        [sheet showInView:self.view];
    }
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxCount-_selectedPhotos.count columnNumber:imageCount delegate:self];
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        //        [_selectedPhotos addObjectsFromArray:photos];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        //        tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) { // 如果保存失败，基本是没有相册权限导致的...
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法保存图片" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                alert.tag = 1;
                [alert show];
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [_selectedAssets addObject:assetModel.asset];
                        [_selectedPhotos addObject:image];
                        [_collectionView reloadData];
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            if (alertView.tag == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"]];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"]];
            }
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
// - (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
// NSLog(@"cancel");
// }

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    //    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    [_selectedPhotos addObjectsFromArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    //    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

#pragma mark Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    //    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}
@end
