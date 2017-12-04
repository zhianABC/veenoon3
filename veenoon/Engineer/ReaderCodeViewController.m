////
////  ReaderCodeViewController.m
////  Hint
////
////  Created by chen jack on 2017/3/29.
////  Copyright © 2017年 jack. All rights reserved.
////
//
//#import "ReaderCodeViewController.h"
//#import <AVFoundation/AVFoundation.h>
//
//@interface ReaderCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>
//{
//    AVCaptureSession * session;//输入输出的中间桥梁
//    AVCaptureVideoPreviewLayer * cameraLayer;
//
//
//}
//@property (nonatomic, strong) AVCaptureDeviceInput *_input;
//@property (nonatomic, strong) AVCaptureMetadataOutput *_output;
//@end
//
//@implementation ReaderCodeViewController
//@synthesize delegate;
//@synthesize postion;
//@synthesize _input;
//@synthesize _output;
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//
//    // Do any additional setup after loading the view, typically from a nib.
//
//    self.title = @"扫码";
//
//    //self.view.backgroundColor = [UIColor redColor];
//
//    NSString *mediaType = AVMediaTypeVideo;
//
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
//
//    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
//
//        //出错处理
//        //NSLog(@"%@", error);
//        NSString *msg = [NSString stringWithFormat:@"请在手机【设置】-【隐私】-【相机】选项中，允许【%@】访问您的相机",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
//
//        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提醒"
//                                                    message:msg
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles: nil];
//        [av show];
//
//        return;
//
//    }
//
//    //开始捕获
//    [self initCamera];
//
//}
//
//- (AVCaptureDevice *)cameraWithPosition : (AVCaptureDevicePosition) position
//{
//    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
//    for (AVCaptureDevice *device in devices )
//        if ( device.position == position )
//            return device;
//    return nil ;
//}
//
//
//- (void)setupCamera
//{
//    AVCaptureDevice * device = nil;
//
//    //获取摄像设备
//    if(postion == 0)
//    {
//        device = [self cameraWithPosition:AVCaptureDevicePositionBack];
//    }
//    else
//    {
//        device = [self cameraWithPosition:AVCaptureDevicePositionFront];
//    }
//    if(device == nil)
//        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//
//    // Input
//    self._input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//
//    // Output
//    if (!_output) {
//        self._output = [[AVCaptureMetadataOutput alloc] init];
//    }
//
//    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//
//    // Session
//    if (!session) {
//        session = [[AVCaptureSession alloc] init];
//    }
//
//    [session setSessionPreset:AVCaptureSessionPresetHigh];
//
//    if ([session canAddInput:self._input])
//    {
//        [session addInput:self._input];
//    }
//
//    if ([session canAddOutput:self._output])
//    {
//        [session addOutput:self._output];
//    }
//
//    //self.view.layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    // 条码类型 AVMetadataObjectTypeQRCode
//    _output.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
//    //_output.rectOfInterest = CGRectMake(0,0,1, 1);
//
//    // Preview
//    cameraLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
//    cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    cameraLayer.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
//    [self.view.layer insertSublayer:cameraLayer atIndex:0];
//
//
//    // Start
//    [session startRunning];
//
//    //timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
//}
//
//- (void) initCamera{
//
//    AVCaptureDevice * device = nil;
//
//    //获取摄像设备
//    if(postion == 0)
//    {
//        device = [self cameraWithPosition:AVCaptureDevicePositionBack];
//    }
//    else
//    {
//        device = [self cameraWithPosition:AVCaptureDevicePositionFront];
//    }
//    if(device == nil)
//        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//
//    //创建输入流
//    self._input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//
//    //创建输出流
//    self._output = [[AVCaptureMetadataOutput alloc] init];
//    //设置代理 在主线程里刷新
//    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    //output.rectOfInterest = CGRectMake(0.5,0,0.5, 1);
//
//    //初始化链接对象
//    session = [[AVCaptureSession alloc]init];
//    //高质量采集率
//    [session setSessionPreset:AVCaptureSessionPresetHigh];
//
//
//    if(_input)
//    {
//        [session addInput:_input];
//    }
//    else
//    {
//        //出错处理
//        //NSLog(@"%@", error);
//        NSString *msg = [NSString stringWithFormat:@"请在手机【设置】-【隐私】-【相机】选项中，允许【%@】访问您的相机",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
//
//        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提醒"
//                                                    message:msg
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles: nil];
//        [av show];
//        return;
//    }
//
//    if ([session canAddOutput:self._output]) {
//
//        [session addOutput:_output];
//
//        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
//
//        _output.metadataObjectTypes = [NSArray arrayWithObject:AVMetadataObjectTypeQRCode];
//    }
//
//
//
//
//
//    cameraLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
//    cameraLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
//    cameraLayer.frame = self.view.layer.bounds;
//    [self.view.layer insertSublayer:cameraLayer atIndex:0];
//}
//
//- (void) setDevicePosition:(int)pos
//{
//    self.postion = pos;
//
//    [session stopRunning];
//
//
//    AVCaptureDevice * device = nil;
//    //获取摄像设备
//    if(postion == 0)
//    {
//        device = [self cameraWithPosition:AVCaptureDevicePositionBack];
//    }
//    else
//    {
//        device = [self cameraWithPosition:AVCaptureDevicePositionFront];
//    }
//    if(device == nil)
//        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//
//
//    if(_input)
//    {
//        [session removeInput:_input];
//    }
//
//    //创建输入流
//    self._input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//    [session addInput:_input];
//
//    [session startRunning];
//
//}
//
//- (void) viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    //self.navigationController.navigationBarHidden = YES;
//
//    [session startRunning];
//}
//
//- (void) viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear: animated];
//
//    //self.navigationController.navigationBarHidden = NO;
//
//    [session stopRunning];
//}
//
//-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
//    if (metadataObjects.count > 0) {
//
//        [session stopRunning];
//
//        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
//        //输出扫描字符串
//        NSLog(@"%@",metadataObject.stringValue);
//
//        if(delegate && [delegate respondsToSelector:@selector(didReaderBarData:)])
//        {
//            [delegate didReaderBarData:metadataObject.stringValue];
//        }
//    }
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end

