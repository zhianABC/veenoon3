//
//  EngineerPortDNSViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerAudioDevicePluginViewCtrl.h"
#import "EngineerVideoDevicePluginViewCtrl.h"
#import "CenterCustomerPickerView.h"
#import "UIButton+Color.h"

#import "IconCenterTextButton.h"
#import "DataSync.h"
#import "AudioEProcessor.h"


@interface EngineerAudioDevicePluginViewCtrl () <CenterCustomerPickerViewDelegate>{
    IconCenterTextButton *_electronicSysBtn;
    IconCenterTextButton *_musicPlayBtn;
    IconCenterTextButton *_wuxianhuatongBtn;
    IconCenterTextButton *_huiyiBtn;
    IconCenterTextButton *_fankuiyizhiBtn;
    IconCenterTextButton *_yinpinchuliBtn;
    IconCenterTextButton *_floorWarmBtn;
    
    CenterCustomerPickerView *_productTypePikcer;
    CenterCustomerPickerView *_brandPicker;
    CenterCustomerPickerView *_productCategoryPicker;
}
@property (nonatomic, strong) NSArray *_currentBrands;
@property (nonatomic, strong) NSArray *_currentTypes;
@property (nonatomic, strong) NSArray *_driverUdids;
@property (nonatomic, strong) NSMutableDictionary *_mapDrivers;
@property (nonatomic, strong) NSMutableArray *_audioDrivers;

@end

@implementation EngineerAudioDevicePluginViewCtrl
@synthesize _meetingRoomDic;
@synthesize _selectedSysDic;

@synthesize _currentBrands;
@synthesize _currentTypes;
@synthesize _driverUdids;
@synthesize _mapDrivers;
@synthesize _audioDrivers;


- (void) prepareDrivers{
    
    self._mapDrivers = [NSMutableDictionary dictionary];
    
    NSDictionary *audioDic = @{@"type":@"audio",
                               @"name":@"音频处理器",
                               @"driver":UUID_Audio_Processor,
                               @"brand":@"Teslaria",
                               @"icon":@"engineer_yinpinchuli_n.png",
                               @"icon_s":@"engineer_yinpinchuli_s.png",
                               @"driver_class":@"AudioEProcessor",
                               @"ptype":@"Audio Processor"
                               };
    
    NSDictionary *audioDic2 = @{@"type":@"audio",
                               @"name":@"会议",
                               @"driver":UUID_Audio_Mixer,
                               @"brand":@"Teslaria",
                               @"icon":@"engineer_huiyi_n.png",
                               @"icon_s":@"engineer_huiyi_s.png",
                               @"driver_class":@"AudioEMix",
                               @"ptype":@"Audio Mixer"
                               };
    
    [_mapDrivers setObject:audioDic forKey:UUID_Audio_Processor];
    [_mapDrivers setObject:audioDic2 forKey:UUID_Audio_Mixer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BLACK_COLOR;
    
    [self prepareDrivers];
    
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
    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:1];
    portDNSLabel.text = @"选择您所需要设置的设备类型 > 品牌 > 型号";
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
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
    
    int left = 100;
    int rowGap = (SCREEN_WIDTH - left * 2)/6 - 10;
    int height = 200;
    
    _electronicSysBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left, height,80, 110)];
    [_electronicSysBtn  buttonWithIcon:[UIImage imageNamed:@"engineer_dianyuanguanli_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_dianyuanguanli_s.png"] text:@"电源管理" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_electronicSysBtn addTarget:self action:@selector(electronicSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_electronicSysBtn];
    
    
    _musicPlayBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap, height,80, 110)];
    [_musicPlayBtn  buttonWithIcon:[UIImage imageNamed:@"engineer_music_play_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_music_play_s.png"] text:@"音乐播放" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_musicPlayBtn addTarget:self action:@selector(musicPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_musicPlayBtn];
    
    _wuxianhuatongBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*2, height,80, 110)];
    [_wuxianhuatongBtn  buttonWithIcon:[UIImage imageNamed:@"engineer_wuxianhuatong_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_wuxianhuatong_s.png"] text:@"无线话筒" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_wuxianhuatongBtn addTarget:self action:@selector(wuxianhuatongAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_wuxianhuatongBtn];
    
    _huiyiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*3, height,80, 110)];
    [_huiyiBtn  buttonWithIcon:[UIImage imageNamed:@"engineer_huiyi_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_huiyi_s.png"] text:@"会议" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_huiyiBtn addTarget:self action:@selector(huiyiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_huiyiBtn];
    
    _fankuiyizhiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*4, height,80, 110)];
    [_fankuiyizhiBtn  buttonWithIcon:[UIImage imageNamed:@"enginner_fankuiyizhi_n.png"] selectedIcon:[UIImage imageNamed:@"enginner_fankuiyizhi_s.png"] text:@"反馈抑制" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_fankuiyizhiBtn addTarget:self action:@selector(fankuiyizhiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fankuiyizhiBtn];
    
    _yinpinchuliBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*5, height,80, 110)];
    [_yinpinchuliBtn  buttonWithIcon:[UIImage imageNamed:@"engineer_yinpinchuli_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_yinpinchuli_s.png"] text:audio_process_name normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_yinpinchuliBtn addTarget:self action:@selector(yinpinchuliAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yinpinchuliBtn];
    
    _floorWarmBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*6, height,80, 110)];
    [_floorWarmBtn  buttonWithIcon:[UIImage imageNamed:@"engineer_gongfang_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_gongfang_s.png"] text:@"功放" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_floorWarmBtn addTarget:self action:@selector(gongfangAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_floorWarmBtn];
    
 
    int maxWidth = 120;
    float labelStartX = (SCREEN_WIDTH - maxWidth*2 - 60 - 15)/2.0;
    int labelStartY = 480;
    
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX,
                                                                labelStartY,
                                                                maxWidth, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"产品类型";
    
    _productTypePikcer = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX, labelStartY+20, maxWidth, 160)];
    [_productTypePikcer removeArray];
    _productTypePikcer.delegate_=self;
    _productTypePikcer.tag = 101;
    _productTypePikcer.fontSize=14;
    _productTypePikcer._pickerDataArray = @[@{@"values":@[@"电源管理",
                                                          @"音乐播放",
                                                          @"无线话筒",
                                                          audio_mixer_name,
                                                          @"反馈抑制",
                                                          audio_process_name,
                                                          @"功放"]}];
    [_productTypePikcer selectRow:0 inComponent:0];
    _productTypePikcer._selectColor = RGB(253, 180, 0);
    _productTypePikcer._rowNormalColor = [UIColor whiteColor];
    [self.view addSubview:_productTypePikcer];
    
    int x1 = CGRectGetMaxX(titleL.frame)+5;
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(x1,
                                                       labelStartY,
                                                       maxWidth, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"品牌";
    
    [self initBrandAndTypes];
    
    _brandPicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(x1,
                                                                              labelStartY+20,
                                                                              maxWidth, 160)];
    _brandPicker.tag=102;
    [_brandPicker  removeArray];
    _brandPicker._pickerDataArray = @[@{@"values":_currentBrands}];
    [_brandPicker selectRow:0 inComponent:0];
    _brandPicker._selectColor = RGB(253, 180, 0);
    _brandPicker._rowNormalColor = [UIColor whiteColor];
    [self.view addSubview:_brandPicker];
    
    
    x1 = CGRectGetMaxX(titleL.frame)+5;
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(x1, labelStartY, maxWidth, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"型号";
    
    _productCategoryPicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(x1, labelStartY+20, maxWidth, 160)];
    _productCategoryPicker.tag=103;
    [_productCategoryPicker removeArray];
    _productCategoryPicker._pickerDataArray = @[@{@"values":_currentTypes}];
    [_productCategoryPicker selectRow:0 inComponent:0];
    _productCategoryPicker._selectColor = RGB(253, 180, 0);
    _productCategoryPicker._rowNormalColor = [UIColor whiteColor];
    [self.view addSubview:_productCategoryPicker];
    
    UIButton *addBtn = [UIButton buttonWithColor:YELLOW_COLOR selColor:nil];
    addBtn.frame = CGRectMake(SCREEN_WIDTH/2-50, labelStartY+120+55, 100, 40);
    addBtn.layer.cornerRadius = 5;
    addBtn.layer.borderWidth = 2;
    addBtn.layer.borderColor = [UIColor clearColor].CGColor;
    addBtn.clipsToBounds = YES;
    [self.view addSubview:addBtn];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setTitleColor:RGB(1, 138, 182) forState:UIControlStateHighlighted];
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [addBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //[[DataSync sharedDataSync] syncAreaHasDrivers];
    
    self._audioDrivers = [NSMutableArray array];
    [self._selectedSysDic setObject:_audioDrivers forKey:@"audio"];
}

- (void) addDriverToCenter:(NSDictionary*)device{
    
    NSString *classname = [device objectForKey:@"driver_class"];
    Class someClass = NSClassFromString(classname);
    BasePlugElement * obj = [[someClass alloc] init];
    
    if(obj)
    {
        obj._name = [device objectForKey:@"name"];
        obj._brand = [device objectForKey:@"brand"];
        obj._type = [device objectForKey:@"ptype"];
        obj._driverUUID = [device objectForKey:@"driver"];
        
        id key = [device objectForKey:@"driver"];
        obj._driverInfo = [[DataSync sharedDataSync] driverInfoByUUID:key];
        
        obj._plugicon = [device objectForKey:@"icon"];
        obj._plugicon_s = [device objectForKey:@"icon_s"];
        
        //根据此类型的插件，创建自己的驱动，上传到中控
        [obj createDriver];
        
        [_audioDrivers addObject:obj];
    }
}

- (void) confirmAction:(id)sender{
    
    NSDictionary *val = [_productCategoryPicker._values objectForKey:@0];
    int idx = [[val objectForKey:@"index"] intValue];
    
    if(idx < [_driverUdids count])
    {
        id key = [_driverUdids objectAtIndex:idx];
        NSDictionary *device =  [_mapDrivers objectForKey:key];
        [self addDriverToCenter:device];
    }
    
}

- (void) initBrandAndTypes{
    
    self._currentBrands = @[@"品牌1",@"品牌2",@"品牌3"];
    self._currentTypes = @[@"型号A",@"型号B",@"型号C"];
    self._driverUdids = @[];
    
    _brandPicker._pickerDataArray = @[@{@"values":_currentBrands}];
    _productCategoryPicker._pickerDataArray = @[@{@"values":_currentTypes}];
    
    [_brandPicker selectRow:0 inComponent:0];
    [_productTypePikcer selectRow:0 inComponent:0];
}

- (void) gongfangAction:(id)sender{
    
    [_electronicSysBtn setBtnHighlited:NO];
    [_musicPlayBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_huiyiBtn setBtnHighlited:NO];
    [_fankuiyizhiBtn setBtnHighlited:NO];
    [_yinpinchuliBtn setBtnHighlited:NO];
    [_floorWarmBtn setBtnHighlited:YES];
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    [self initBrandAndTypes];
}

- (void) yinpinchuliAction:(id)sender{
    
    [_electronicSysBtn setBtnHighlited:NO];
    [_musicPlayBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_huiyiBtn setBtnHighlited:NO];
    [_fankuiyizhiBtn setBtnHighlited:NO];
    [_yinpinchuliBtn setBtnHighlited:YES];
    [_floorWarmBtn setBtnHighlited:NO];
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    self._currentBrands = @[@"Teslaria"];
    self._currentTypes = @[@"Audio Processor"];
    self._driverUdids = @[UUID_Audio_Processor];
    
    _brandPicker._pickerDataArray = @[@{@"values":_currentBrands}];
    _productCategoryPicker._pickerDataArray = @[@{@"values":_currentTypes}];
    
    [_brandPicker selectRow:0 inComponent:0];
    [_productCategoryPicker selectRow:0 inComponent:0];
}

- (void) fankuiyizhiAction:(id)sender{
    
    [_electronicSysBtn setBtnHighlited:NO];
    [_musicPlayBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_huiyiBtn setBtnHighlited:NO];
    [_fankuiyizhiBtn setBtnHighlited:YES];
    [_yinpinchuliBtn setBtnHighlited:NO];
    [_floorWarmBtn setBtnHighlited:NO];
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    [self initBrandAndTypes];
}

- (void) huiyiAction:(id)sender{
    
    [_electronicSysBtn setBtnHighlited:NO];
    [_musicPlayBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_huiyiBtn setBtnHighlited:YES];
    [_fankuiyizhiBtn setBtnHighlited:NO];
    [_yinpinchuliBtn setBtnHighlited:NO];
    [_floorWarmBtn setBtnHighlited:NO];
    
    self._currentBrands = @[@"Teslaria"];
    self._currentTypes = @[@"Audio Mixer"];
    self._driverUdids = @[UUID_Audio_Mixer];
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    _brandPicker._pickerDataArray = @[@{@"values":_currentBrands}];
    _productCategoryPicker._pickerDataArray = @[@{@"values":_currentTypes}];
    
    [_brandPicker selectRow:0 inComponent:0];
    [_productCategoryPicker selectRow:0 inComponent:0];
}

- (void) wuxianhuatongAction:(id)sender{
    [_electronicSysBtn setBtnHighlited:NO];
    [_musicPlayBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:YES];
    [_huiyiBtn setBtnHighlited:NO];
    [_fankuiyizhiBtn setBtnHighlited:NO];
    [_yinpinchuliBtn setBtnHighlited:NO];
    [_floorWarmBtn setBtnHighlited:NO];
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    [self initBrandAndTypes];
}

- (void) musicPlayAction:(id)sender{
    [_electronicSysBtn setBtnHighlited:NO];
    [_musicPlayBtn setBtnHighlited:YES];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_huiyiBtn setBtnHighlited:NO];
    [_fankuiyizhiBtn setBtnHighlited:NO];
    [_yinpinchuliBtn setBtnHighlited:NO];
    [_floorWarmBtn setBtnHighlited:NO];
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    [self initBrandAndTypes];
}

- (void) electronicSysAction:(id)sender{
    [_electronicSysBtn setBtnHighlited:YES];
    [_musicPlayBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_huiyiBtn setBtnHighlited:NO];
    [_fankuiyizhiBtn setBtnHighlited:NO];
    [_yinpinchuliBtn setBtnHighlited:NO];
    [_floorWarmBtn setBtnHighlited:NO];
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    [self initBrandAndTypes];
}
-(void) didScrollPickerValue:(NSString*)brand {
    
    if ([@"电源管理" isEqualToString:brand]) {
        [self electronicSysAction:_electronicSysBtn];
    } else if ([@"音乐播放" isEqualToString:brand]) {
        [self musicPlayAction:_musicPlayBtn];
    } else if ([@"无线话筒" isEqualToString:brand]) {
        [self wuxianhuatongAction:_wuxianhuatongBtn];
    } else if ([audio_mixer_name isEqualToString:brand]) {
        [self huiyiAction:_huiyiBtn];
    } else if ([@"反馈抑制" isEqualToString:brand]) {
        [self fankuiyizhiAction:_fankuiyizhiBtn];
    } else if ([audio_process_name isEqualToString:brand]) {
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
    
    EngineerVideoDevicePluginViewCtrl *ctrl = [[EngineerVideoDevicePluginViewCtrl alloc] init];
    ctrl._meetingRoomDic = self._meetingRoomDic;
    ctrl._selectedSysDic = self._selectedSysDic;
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end


