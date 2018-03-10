//
//  EngineerPortDNSViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerAudioDevicePluginViewCtrl.h"
#import "EngineerVedioDevicePluginViewCtrl.h"
#import "CenterCustomerPickerView.h"
#import "UIButton+Color.h"

@interface EngineerAudioDevicePluginViewCtrl () <CenterCustomerPickerViewDelegate>{
    UIButton *_electronicSysBtn;
    UIButton *_musicPlayBtn;
    UIButton *_wuxianhuatongBtn;
    UIButton *_huiyiBtn;
    UIButton *_fankuiyizhiBtn;
    UIButton *_yinpinchuliBtn;
    UIButton *_floorWarmBtn;
    
    UIButton *_confirmButton;
    
    CenterCustomerPickerView *_productTypePikcer;
    CenterCustomerPickerView *_brandPicker;
    CenterCustomerPickerView *_productCategoryPicker;
    CenterCustomerPickerView *_numberPicker;
}
@end

@implementation EngineerAudioDevicePluginViewCtrl
@synthesize _meetingRoomDic;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, ENGINEER_VIEW_TOP+10, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:20];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"请配置您的音频管理系统";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, CGRectGetMaxY(portDNSLabel.frame)+20, SCREEN_WIDTH-80, 20)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont systemFontOfSize:18];
    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    portDNSLabel.text = @"选择您所需要设置的设备类型> 品牌 > 型号> 数量";
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"< 上一步" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"下一步 >" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int left = 150;
    int rowGap = (SCREEN_WIDTH - left * 2)/5 - 10;
    int height = 200;
    _electronicSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _electronicSysBtn.frame = CGRectMake(left, height, 80, 132);
    [_electronicSysBtn setImage:[UIImage imageNamed:@"engineer_dianyuanguanli_n.png"] forState:UIControlStateNormal];
    [_electronicSysBtn setImage:[UIImage imageNamed:@"engineer_dianyuanguanli_s.png"] forState:UIControlStateHighlighted];
    [_electronicSysBtn setTitle:@"电源管理" forState:UIControlStateNormal];
    [_electronicSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_electronicSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _electronicSysBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_electronicSysBtn setTitleEdgeInsets:UIEdgeInsetsMake(_electronicSysBtn.imageView.frame.size.height+10,-80,-20,-20)];
    [_electronicSysBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_electronicSysBtn.titleLabel.bounds.size.height, 0)];
    [_electronicSysBtn addTarget:self action:@selector(electronicSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_electronicSysBtn];
    
    
    _musicPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _musicPlayBtn.frame = CGRectMake(left+rowGap, height, 80, 132);
    [_musicPlayBtn setImage:[UIImage imageNamed:@"engineer_music_play_n.png"] forState:UIControlStateNormal];
    [_musicPlayBtn setImage:[UIImage imageNamed:@"engineer_music_play_s.png"] forState:UIControlStateHighlighted];
    [_musicPlayBtn setTitle:@"音乐播放" forState:UIControlStateNormal];
    [_musicPlayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_musicPlayBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _musicPlayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_musicPlayBtn setTitleEdgeInsets:UIEdgeInsetsMake(_musicPlayBtn.imageView.frame.size.height+10,-80,-20,-20)];
    [_musicPlayBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_musicPlayBtn.titleLabel.bounds.size.height, 0)];
    [_musicPlayBtn addTarget:self action:@selector(musicPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_musicPlayBtn];
    
    _wuxianhuatongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _wuxianhuatongBtn.frame = CGRectMake(left+rowGap*2, height, 80, 132);
    [_wuxianhuatongBtn setImage:[UIImage imageNamed:@"engineer_wuxianhuatong_n.png"] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setImage:[UIImage imageNamed:@"engineer_wuxianhuatong_s.png"] forState:UIControlStateHighlighted];
    [_wuxianhuatongBtn setTitle:@"无线话筒" forState:UIControlStateNormal];
    [_wuxianhuatongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _wuxianhuatongBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_wuxianhuatongBtn setTitleEdgeInsets:UIEdgeInsetsMake(_wuxianhuatongBtn.imageView.frame.size.height+10,-75,-20,-35)];
    [_wuxianhuatongBtn setImageEdgeInsets:UIEdgeInsetsMake(-10,15,_wuxianhuatongBtn.titleLabel.bounds.size.height, -15)];
    [_wuxianhuatongBtn addTarget:self action:@selector(wuxianhuatongAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_wuxianhuatongBtn];
    
    _huiyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _huiyiBtn.frame = CGRectMake(left+rowGap*3, height, 80, 132);
    [_huiyiBtn setImage:[UIImage imageNamed:@"engineer_huiyi_n.png"] forState:UIControlStateNormal];
    [_huiyiBtn setImage:[UIImage imageNamed:@"engineer_huiyi_s.png"] forState:UIControlStateHighlighted];
    [_huiyiBtn setTitle:@"会议" forState:UIControlStateNormal];
    [_huiyiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_huiyiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _huiyiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_huiyiBtn setTitleEdgeInsets:UIEdgeInsetsMake(_huiyiBtn.imageView.frame.size.height+10,-55,-20,-5)];
    [_huiyiBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,5.0,_huiyiBtn.titleLabel.bounds.size.height, -5)];
    [_huiyiBtn addTarget:self action:@selector(huiyiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_huiyiBtn];
    
    _fankuiyizhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fankuiyizhiBtn.frame = CGRectMake(left+rowGap*4, height, 80, 132);
    [_fankuiyizhiBtn setImage:[UIImage imageNamed:@"enginner_fankuiyizhi_n.png"] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setImage:[UIImage imageNamed:@"enginner_fankuiyizhi_s.png"] forState:UIControlStateHighlighted];
    [_fankuiyizhiBtn setTitle:@"反馈抑制" forState:UIControlStateNormal];
    [_fankuiyizhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _fankuiyizhiBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_fankuiyizhiBtn setTitleEdgeInsets:UIEdgeInsetsMake(_fankuiyizhiBtn.imageView.frame.size.height+10,-80,-20,-20)];
    [_fankuiyizhiBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_fankuiyizhiBtn.titleLabel.bounds.size.height, 0)];
    [_fankuiyizhiBtn addTarget:self action:@selector(fankuiyizhiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fankuiyizhiBtn];
    
    _yinpinchuliBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _yinpinchuliBtn.frame = CGRectMake(left+rowGap*5, height, 80, 132);
    [_yinpinchuliBtn setImage:[UIImage imageNamed:@"engineer_yinpinchuli_n.png"] forState:UIControlStateNormal];
    [_yinpinchuliBtn setImage:[UIImage imageNamed:@"engineer_yinpinchuli_s.png"] forState:UIControlStateHighlighted];
    [_yinpinchuliBtn setTitle:@"音频处理" forState:UIControlStateNormal];
    [_yinpinchuliBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yinpinchuliBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _yinpinchuliBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_yinpinchuliBtn setTitleEdgeInsets:UIEdgeInsetsMake(_yinpinchuliBtn.imageView.frame.size.height+10,-90,-20,-20)];
    [_yinpinchuliBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_yinpinchuliBtn.titleLabel.bounds.size.height, 0)];
    [_yinpinchuliBtn addTarget:self action:@selector(yinpinchuliAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yinpinchuliBtn];
    
    _floorWarmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _floorWarmBtn.frame = CGRectMake(left, height+132, 80, 132);
    [_floorWarmBtn setImage:[UIImage imageNamed:@"engineer_gongfang_n.png"] forState:UIControlStateNormal];
    [_floorWarmBtn setImage:[UIImage imageNamed:@"engineer_gongfang_s.png"] forState:UIControlStateHighlighted];
    [_floorWarmBtn setTitle:@"功放" forState:UIControlStateNormal];
    [_floorWarmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_floorWarmBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _floorWarmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_floorWarmBtn setTitleEdgeInsets:UIEdgeInsetsMake(_floorWarmBtn.imageView.frame.size.height+10,-90,-20,-20)];
    [_floorWarmBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_floorWarmBtn.titleLabel.bounds.size.height, -10)];
    [_floorWarmBtn addTarget:self action:@selector(gongfangAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_floorWarmBtn];
    
    int labelStartX = 170;
    int labelStartY = 500;
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX-35, labelStartY, 200, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"产品类型";
    
    _productTypePikcer = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX, labelStartY+30, 120, 150) withGrayOrLight:@"light"];
    [_productTypePikcer removeArray];
    _productTypePikcer.delegate_=self;
    _productTypePikcer.tag = 101;
    _productTypePikcer.fontSize=14;
    _productTypePikcer._pickerDataArray = @[@{@"values":@[@"电源管理",@"音乐播放",@"无线话筒",@"会议",@"反馈抑制",@"音频处理",@"功放"]}];
    [_productTypePikcer selectRow:0 inComponent:0];
    _productTypePikcer._selectColor = RGB(253, 180, 0);
    _productTypePikcer._rowNormalColor = RGB(117, 165, 186);
    [self.view addSubview:_productTypePikcer];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX+145, labelStartY, 200, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"品牌";
    
    _brandPicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX+200, labelStartY+30, 91, 150) withGrayOrLight:@"light"];
    _brandPicker.tag=102;
    [_brandPicker  removeArray];
    _brandPicker._pickerDataArray = @[@{@"values":@[@"f",@"e",@"a"]}];
    [_brandPicker selectRow:0 inComponent:0];
    _brandPicker._selectColor = RGB(253, 180, 0);
    _brandPicker._rowNormalColor = RGB(117, 165, 186);
    [self.view addSubview:_brandPicker];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX+345, labelStartY, 200, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"型号";
    
    _productCategoryPicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX+400, labelStartY+30, 91, 150) withGrayOrLight:@"light"];
    _productCategoryPicker.tag=103;
    _productCategoryPicker.delegate_=self;
    [_productCategoryPicker removeArray];
    _productCategoryPicker._pickerDataArray = @[@{@"values":@[@"c",@"v",@"b"]}];
    [_productCategoryPicker selectRow:0 inComponent:0];
    _productCategoryPicker._selectColor = RGB(253, 180, 0);
    _productCategoryPicker._rowNormalColor = RGB(117, 165, 186);
    [self.view addSubview:_productCategoryPicker];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX+595, labelStartY, 100, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"数量";
    
    _numberPicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX+600, labelStartY+30, 91, 150) withGrayOrLight:@"light"];
    _numberPicker.tag=104;
    [_numberPicker removeArray];
    _numberPicker._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    [_numberPicker selectRow:0 inComponent:0];
    _numberPicker._selectColor = RGB(253, 180, 0);
    _numberPicker._rowNormalColor = RGB(117, 165, 186);
    [self.view addSubview:_numberPicker];
    
    UIButton *signup = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:YELLOW_COLOR];
    signup.frame = CGRectMake(SCREEN_WIDTH/2-50, labelStartY+120+25, 100, 40);
    signup.layer.cornerRadius = 5;
    signup.layer.borderWidth = 2;
    signup.layer.borderColor = RGB(0, 89, 118).CGColor;
    signup.clipsToBounds = YES;
    [self.view addSubview:signup];
    [signup setTitle:@"确认" forState:UIControlStateNormal];
    [signup setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signup setTitleColor:RGB(1, 138, 182) forState:UIControlStateHighlighted];
    signup.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
}

- (void) confirmAction:(id)sender{
    
}

- (void) gongfangAction:(id)sender{
    [_electronicSysBtn setImage:[UIImage imageNamed:@"engineer_dianyuanguanli_n.png"] forState:UIControlStateNormal];
    [_electronicSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_musicPlayBtn setImage:[UIImage imageNamed:@"engineer_music_play_n.png"] forState:UIControlStateNormal];
    [_musicPlayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setImage:[UIImage imageNamed:@"engineer_wuxianhuatong_n.png"] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_huiyiBtn setImage:[UIImage imageNamed:@"engineer_huiyi_n.png"] forState:UIControlStateNormal];
    [_huiyiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setImage:[UIImage imageNamed:@"enginner_fankuiyizhi_n.png"] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yinpinchuliBtn setImage:[UIImage imageNamed:@"engineer_yinpinchuli_n.png"] forState:UIControlStateNormal];
    [_yinpinchuliBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_floorWarmBtn setImage:[UIImage imageNamed:@"engineer_gongfang_s.png"] forState:UIControlStateNormal];
    [_floorWarmBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}

- (void) yinpinchuliAction:(id)sender{
    [_electronicSysBtn setImage:[UIImage imageNamed:@"engineer_dianyuanguanli_n.png"] forState:UIControlStateNormal];
    [_electronicSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_musicPlayBtn setImage:[UIImage imageNamed:@"engineer_music_play_n.png"] forState:UIControlStateNormal];
    [_musicPlayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setImage:[UIImage imageNamed:@"engineer_wuxianhuatong_n.png"] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_huiyiBtn setImage:[UIImage imageNamed:@"engineer_huiyi_n.png"] forState:UIControlStateNormal];
    [_huiyiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setImage:[UIImage imageNamed:@"enginner_fankuiyizhi_n.png"] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yinpinchuliBtn setImage:[UIImage imageNamed:@"engineer_yinpinchuli_s.png"] forState:UIControlStateNormal];
    [_yinpinchuliBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_floorWarmBtn setImage:[UIImage imageNamed:@"engineer_gongfang_n.png"] forState:UIControlStateNormal];
    [_floorWarmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}

- (void) fankuiyizhiAction:(id)sender{
    [_electronicSysBtn setImage:[UIImage imageNamed:@"engineer_dianyuanguanli_n.png"] forState:UIControlStateNormal];
    [_electronicSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_musicPlayBtn setImage:[UIImage imageNamed:@"engineer_music_play_n.png"] forState:UIControlStateNormal];
    [_musicPlayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setImage:[UIImage imageNamed:@"engineer_wuxianhuatong_n.png"] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_huiyiBtn setImage:[UIImage imageNamed:@"engineer_huiyi_n.png"] forState:UIControlStateNormal];
    [_huiyiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setImage:[UIImage imageNamed:@"enginner_fankuiyizhi_s.png"] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_yinpinchuliBtn setImage:[UIImage imageNamed:@"engineer_yinpinchuli_n.png"] forState:UIControlStateNormal];
    [_yinpinchuliBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_floorWarmBtn setImage:[UIImage imageNamed:@"engineer_gongfang_n.png"] forState:UIControlStateNormal];
    [_floorWarmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}

- (void) huiyiAction:(id)sender{
    [_electronicSysBtn setImage:[UIImage imageNamed:@"engineer_dianyuanguanli_n.png"] forState:UIControlStateNormal];
    [_electronicSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_musicPlayBtn setImage:[UIImage imageNamed:@"engineer_music_play_n.png"] forState:UIControlStateNormal];
    [_musicPlayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setImage:[UIImage imageNamed:@"engineer_wuxianhuatong_n.png"] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_huiyiBtn setImage:[UIImage imageNamed:@"engineer_huiyi_s.png"] forState:UIControlStateNormal];
    [_huiyiBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_fankuiyizhiBtn setImage:[UIImage imageNamed:@"enginner_fankuiyizhi_n.png"] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yinpinchuliBtn setImage:[UIImage imageNamed:@"engineer_yinpinchuli_n.png"] forState:UIControlStateNormal];
    [_yinpinchuliBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_floorWarmBtn setImage:[UIImage imageNamed:@"engineer_gongfang_n.png"] forState:UIControlStateNormal];
    [_floorWarmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}

- (void) wuxianhuatongAction:(id)sender{
    [_electronicSysBtn setImage:[UIImage imageNamed:@"engineer_dianyuanguanli_n.png"] forState:UIControlStateNormal];
    [_electronicSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_musicPlayBtn setImage:[UIImage imageNamed:@"engineer_music_play_n.png"] forState:UIControlStateNormal];
    [_musicPlayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setImage:[UIImage imageNamed:@"engineer_wuxianhuatong_s.png"] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_huiyiBtn setImage:[UIImage imageNamed:@"engineer_huiyi_n.png"] forState:UIControlStateNormal];
    [_huiyiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setImage:[UIImage imageNamed:@"enginner_fankuiyizhi_n.png"] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yinpinchuliBtn setImage:[UIImage imageNamed:@"engineer_yinpinchuli_n.png"] forState:UIControlStateNormal];
    [_yinpinchuliBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_floorWarmBtn setImage:[UIImage imageNamed:@"engineer_gongfang_n.png"] forState:UIControlStateNormal];
    [_floorWarmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}

- (void) musicPlayAction:(id)sender{
    [_electronicSysBtn setImage:[UIImage imageNamed:@"engineer_dianyuanguanli_n.png"] forState:UIControlStateNormal];
    [_electronicSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_musicPlayBtn setImage:[UIImage imageNamed:@"engineer_music_play_s.png"] forState:UIControlStateNormal];
    [_musicPlayBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_wuxianhuatongBtn setImage:[UIImage imageNamed:@"engineer_wuxianhuatong_n.png"] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_huiyiBtn setImage:[UIImage imageNamed:@"engineer_huiyi_n.png"] forState:UIControlStateNormal];
    [_huiyiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setImage:[UIImage imageNamed:@"enginner_fankuiyizhi_n.png"] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yinpinchuliBtn setImage:[UIImage imageNamed:@"engineer_yinpinchuli_n.png"] forState:UIControlStateNormal];
    [_yinpinchuliBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_floorWarmBtn setImage:[UIImage imageNamed:@"engineer_gongfang_n.png"] forState:UIControlStateNormal];
    [_floorWarmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}

- (void) electronicSysAction:(id)sender{
    [_electronicSysBtn setImage:[UIImage imageNamed:@"engineer_dianyuanguanli_s.png"] forState:UIControlStateNormal];
    [_electronicSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateNormal];
    [_musicPlayBtn setImage:[UIImage imageNamed:@"engineer_music_play_n.png"] forState:UIControlStateNormal];
    [_musicPlayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setImage:[UIImage imageNamed:@"engineer_wuxianhuatong_n.png"] forState:UIControlStateNormal];
    [_wuxianhuatongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_huiyiBtn setImage:[UIImage imageNamed:@"engineer_huiyi_n.png"] forState:UIControlStateNormal];
    [_huiyiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setImage:[UIImage imageNamed:@"enginner_fankuiyizhi_n.png"] forState:UIControlStateNormal];
    [_fankuiyizhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yinpinchuliBtn setImage:[UIImage imageNamed:@"engineer_yinpinchuli_n.png"] forState:UIControlStateNormal];
    [_yinpinchuliBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_floorWarmBtn setImage:[UIImage imageNamed:@"engineer_gongfang_n.png"] forState:UIControlStateNormal];
    [_floorWarmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIButton *btn = (UIButton*) sender;
    NSString *btnText = btn.titleLabel.text;
    [self setBrandValue:btnText];
}
-(void) didScrollPickerValue:(NSString*)brand {
    if ([@"电源管理" isEqualToString:brand]) {
        [self electronicSysAction:_electronicSysBtn];
    } else if ([@"音乐播放" isEqualToString:brand]) {
        [self musicPlayAction:_musicPlayBtn];
    } else if ([@"无线话筒" isEqualToString:brand]) {
        [self wuxianhuatongAction:_wuxianhuatongBtn];
    } else if ([@"会议" isEqualToString:brand]) {
        [self huiyiAction:_huiyiBtn];
    } else if ([@"反馈抑制" isEqualToString:brand]) {
        [self fankuiyizhiAction:_fankuiyizhiBtn];
    } else if ([@"音频处理" isEqualToString:brand]) {
        [self yinpinchuliAction:_yinpinchuliBtn];
    } else {
        [self gongfangAction:_floorWarmBtn];
    }
}
-(void) setBrandValue:(NSString*)brand {
    if (brand == nil) {
        return;
    }
    NSArray *array = _productTypePikcer._pickerDataArray;
    int index = 0;
    for (NSDictionary *dic in array) {
        NSArray *valueArray = [dic objectForKey:@"values"];
        for (NSString * str in valueArray) {
            if ([str isEqualToString:brand]) {
                break;
            }
            index++;
        }
    }
    [_productTypePikcer selectRow:index inComponent:0];
}

- (void) okAction:(id)sender{
    EngineerVedioDevicePluginViewCtrl *ctrl = [[EngineerVedioDevicePluginViewCtrl alloc] init];
    ctrl._meetingRoomDic = self._meetingRoomDic;
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end


