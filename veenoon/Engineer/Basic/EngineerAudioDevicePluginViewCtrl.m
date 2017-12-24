//
//  EngineerPortDNSViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerAudioDevicePluginViewCtrl.h"
#import "EngineerVedioDevicePluginViewCtrl.h"
#import "CustomPickerView.h"

@interface EngineerAudioDevicePluginViewCtrl () {
    UIButton *_electronicSysBtn;
    UIButton *_musicPlayBtn;
    UIButton *_wuxianhuatongBtn;
    UIButton *_huiyiBtn;
    UIButton *_fankuiyizhiBtn;
    UIButton *_yinpinchuliBtn;
    UIButton *_floorWarmBtn;
    
    UIButton *_confirmButton;
    
    CustomPickerView *_productTypePikcer;
    CustomPickerView *_brandPicker;
    CustomPickerView *_productCategoryPicker;
    CustomPickerView *_numberPicker;
}
@end

@implementation EngineerAudioDevicePluginViewCtrl
@synthesize _meetingRoomDic;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 30, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
    int startX=80;
    int startY = 120;
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY-20, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:20];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"请配置您的音频管理系统";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, CGRectGetMaxY(portDNSLabel.frame)+15, SCREEN_WIDTH-80, 20)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont systemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    portDNSLabel.text = @"选择您所需要设置的设备类型> 品牌 > 型号> 数量";
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0,160, 60);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"< 上一步" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 60);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"下一步 >" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int left = 210;
    int rowGap = (SCREEN_WIDTH - left * 2)/5;
    int height = 250;
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
    
    int labelStartX = 200;
    int labelStartY = 550;
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX-55, labelStartY, 200, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"产品类型";
    
    _productTypePikcer = [[CustomPickerView alloc] initWithFrame:CGRectMake(labelStartX, labelStartY+50, 91, 150) withGrayOrLight:@"gray"];
    _productTypePikcer._pickerDataArray = @[@{@"values":@[@"a",@"z",@"l"]}];
    [_productTypePikcer selectRow:0 inComponent:0];
    _productTypePikcer._selectColor = RGB(253, 180, 0);
    _productTypePikcer._rowNormalColor = RGB(117, 165, 186);
    [self.view addSubview:_productTypePikcer];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX+140, labelStartY, 200, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"品牌";
    
    _brandPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(labelStartX+200, labelStartY+50, 91, 150) withGrayOrLight:@"light"];
    _brandPicker._pickerDataArray = @[@{@"values":@[@"f",@"e",@"a"]}];
    [_brandPicker selectRow:0 inComponent:0];
    _brandPicker._selectColor = RGB(253, 180, 0);
    _brandPicker._rowNormalColor = RGB(117, 165, 186);
    [self.view addSubview:_brandPicker];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX+340, labelStartY, 200, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"型号";
    
    _productCategoryPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(labelStartX+400, labelStartY+50, 91, 150) withGrayOrLight:@"light"];
    _productCategoryPicker._pickerDataArray = @[@{@"values":@[@"c",@"v",@"b"]}];
    [_productCategoryPicker selectRow:0 inComponent:0];
    _productCategoryPicker._selectColor = RGB(253, 180, 0);
    _productCategoryPicker._rowNormalColor = RGB(117, 165, 186);
    [self.view addSubview:_productCategoryPicker];
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX+600, labelStartY, 100, 30)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"数量";
    
    _numberPicker = [[CustomPickerView alloc] initWithFrame:CGRectMake(labelStartX+600, labelStartY+50, 91, 150) withGrayOrLight:@"light"];
    _numberPicker._pickerDataArray = @[@{@"values":@[@"12",@"10",@"09"]}];
    [_numberPicker selectRow:0 inComponent:0];
    _numberPicker._selectColor = RGB(253, 180, 0);
    _numberPicker._rowNormalColor = RGB(117, 165, 186);
    [self.view addSubview:_numberPicker];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmButton.frame = CGRectMake(labelStartX+600+125, labelStartY+50+55, 50, 50);
    [_confirmButton setImage:[UIImage imageNamed:@"engineer_confirm_bt_n.png"] forState:UIControlStateNormal];
    [_confirmButton setImage:[UIImage imageNamed:@"engineer_confirm_bt_s.png"] forState:UIControlStateHighlighted];
    [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    
}

- (void) confirmAction:(id)sender{
    
}

- (void) gongfangAction:(id)sender{
    
}

- (void) yinpinchuliAction:(id)sender{
    
}

- (void) fankuiyizhiAction:(id)sender{
    
}

- (void) huiyiAction:(id)sender{
    
}

- (void) wuxianhuatongAction:(id)sender{
    
}

- (void) musicPlayAction:(id)sender{
    
}

- (void) electronicSysAction:(id)sender{
    
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

