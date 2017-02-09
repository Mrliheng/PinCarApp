//
//  qrCodeViewController.m
//  品车App
//
//  Created by zt on 2016/11/14.
//  Copyright © 2016年 fei. All rights reserved.
//

#import "qrCodeViewController.h"
#import "ZXingObjC/ZXingObjC.h"
#import <AVFoundation/AVFoundation.h>




@interface qrCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    AVCaptureDevice * device;//获取摄像设备
    AVCaptureDeviceInput * input;//创建输入流
    AVCaptureMetadataOutput * output;//创建输出流
    AVCaptureVideoPreviewLayer * layer;//扫描窗口
}

@property (strong, nonatomic) UIImageView *imageFrame;
@property (strong, nonatomic) UIImageView *imageLine;
@end

@implementation qrCodeViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self createItem];
    if (session!=nil) {
        [session startRunning];
        
        //开始动画
        [self performSelectorOnMainThread:@selector(timerFired) withObject:nil waitUntilDone:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ConfigureSetting setViewControllerTitleWithTextColor:@"扫描二维码" color:[UIColor whiteColor] targetCtrl:self];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(scanFromLibrary)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    
    
    
    [self initScanningContent];
    //开始动画
    [self performSelectorOnMainThread:@selector(timerFired) withObject:nil waitUntilDone:NO];
    //添加监听->APP从后台返回前台，重新扫描
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStartRunning) name:UIApplicationDidBecomeActiveNotification object:nil];

}

-(void)scanFromLibrary{
    
    UIImagePickerController *imageVC = [[UIImagePickerController alloc] init];
    imageVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imageVC.allowsEditing = NO;
    imageVC.delegate = self;
    [self presentViewController:imageVC animated:YES completion:nil];
    
}

//从相册中识别二维码
- (void)decodeQRWithImage:(UIImage *)img{
    CGImageRef imageToDecode = img.CGImage;  // Given a CGImage in which we are looking for barcodes
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString *contents = result.text;
        
        // The barcode format, such as a QR code or UPC-A
        //        ZXBarcodeFormat format = result.barcodeFormat;
        
        if ([contents containsString:@"http://"]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:contents]];
        }else{
            [self toResultViewControllerWithResultString:contents];
        }
        
    } else {
        // Use error to determine why we didn't get a result, such as a barcode
        // not being found, an invalid checksum, or a format inconsistency.
        NSLog(@"识别失败");
    }
}

-(void)createItem{
    
    NSString *navcBack = @"navigationBarBG";
    if (SCREEN_WIDTH>375) {
        navcBack = @"navigationBarBGPlus";
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:navcBack] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    backBtn.frame = CGRectMake(0, 0, 15, 10);
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sessionStartRunning{
    if (session!=nil) {
        [session startRunning];
        
        //开始动画
        [self performSelectorOnMainThread:@selector(timerFired) withObject:nil waitUntilDone:NO];
    }
}

/**
 *  添加扫描控件
 */
- (void)initScanningContent{
    
    //获取摄像设备
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //创建输出流
    output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    //设置相机可视范围--全屏
    layer.frame = self.view.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [session startRunning];
    
    //设置扫描作用域范围(中间透明的扫描框)
    CGRect intertRect = [layer metadataOutputRectOfInterestForRect:CGRectMake(SCREEN_WIDTH/7, 114, SCREEN_WIDTH/7*5, SCREEN_WIDTH/7*5)];
    output.rectOfInterest = intertRect;
    
    
    //添加全屏的黑色半透明蒙版
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.view addSubview:maskView];
    
    //从蒙版中扣出扫描框那一块
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(SCREEN_WIDTH/7, 114-32, SCREEN_WIDTH/7*5, SCREEN_WIDTH/7*5) cornerRadius:1] bezierPathByReversingPath]];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskView.layer.mask = maskLayer;
    
    self.imageFrame =  [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/7, 114-32, SCREEN_WIDTH/7*5, SCREEN_WIDTH/7*5)];
    [self.view addSubview:self.imageFrame];
    
    self.imageFrame.image = [UIImage imageNamed:@"frame.png"];
    
    self.imageLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_imageFrame.frame), 1)];
    [self.imageFrame addSubview:self.imageLine];
    self.imageLine.image = [UIImage imageNamed:@"line.png"];
}

/**
 *  加载动画
 */
-(void)timerFired {
    
    [self.imageLine.layer addAnimation:[self moveY:3 Y:[NSNumber numberWithFloat:SCREEN_WIDTH/7*5-8]] forKey:nil];
}

/**
 *  扫描线动画
 *
 *  @param time 单次滑动完成时间
 *  @param y    滑动距离
 *
 *  @return 返回动画
 */
-(CABasicAnimation *)moveY:( float )time Y:( NSNumber *)y {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath : @"transform.translation.y" ]; ///.y 的话就向下移动。
    
    animation. toValue = y;
    
    animation. duration = time;
    
    animation. removedOnCompletion = YES ; //yes 的话，又返回原位置了。
    
    animation. repeatCount = MAXFLOAT ;
    
    animation. fillMode = kCAFillModeForwards ;
    
    return animation;
    
}

/**
 *  去扫描结果显示页面
 *
 *  @param str 扫描结果
 */
- (void)toResultViewControllerWithResultString:(NSString *)str {
    
    self.block(str);
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
/**
 *  获取扫描到的结果
 *
 *  @param captureOutput   输出
 *  @param metadataObjects 结果
 *  @param connection      连接
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count>0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        NSLog(@"stringValue = %@",metadataObject.stringValue);
        if ([[metadataObject type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            if ([metadataObject.stringValue containsString:@"http://"]) {
//                self.urlResult = metadataObject.stringValue;
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlResult]];
            }else{
                [self toResultViewControllerWithResultString:metadataObject.stringValue];
            }
        }
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (image!=nil) {
        [self decodeQRWithImage:image];
    }
    
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

@end
