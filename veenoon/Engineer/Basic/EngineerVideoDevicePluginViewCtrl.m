//
//  EngineerVideoDevicePluginViewCtrl.h
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerVideoDevicePluginViewCtrl.h"
#import "EngineerEnvDevicePluginViewCtrl.h"
#import "CenterCustomerPickerView.h"
#import "UIButton+Color.h"
#import "IconCenterTextButton.h"
#import "VCameraSettingSet.h"
#import "DataSync.h"
#import "VTouyingjiSet.h"
#import "TeslariaComboChooser.h"
#import "RegulusSDK.h"
#import "DataCenter.h"


@interface EngineerVideoDevicePluginViewCtrl ()<CenterCustomerPickerViewDelegate> {
    
    IconCenterTextButton *_dianyuanguanliBtn;
    IconCenterTextButton *_shipinbofangBtn;
    IconCenterTextButton *_shexiangjiBtn;
    IconCenterTextButton *_xinxiheBtn;
    IconCenterTextButton *_yuanchengshixunBtn;
    IconCenterTextButton *_shipinchuliBtn;
    IconCenterTextButton *_pinjiepingBtn;
    IconCenterTextButton *_yejingdianshiBtn;
    IconCenterTextButton *_lubojiBtn;
    IconCenterTextButton *_touyingjiBtn;
    
    CenterCustomerPickerView *_productTypePikcer;
    CenterCustomerPickerView *_brandPicker;
    CenterCustomerPickerView *_productCategoryPicker;
    
    UIPopoverController *_dataSelector;
}
@property (nonatomic, strong) NSArray *_currentBrands;
@property (nonatomic, strong) NSArray *_currentTypes;
@property (nonatomic, strong) NSArray *_driverUdids;

@property (nonatomic, strong) NSMutableDictionary *_mapDrivers;
@property (nonatomic, strong) NSMutableArray *_videoDrivers;

@end

@implementation EngineerVideoDevicePluginViewCtrl
@synthesize _selectedSysDic;

@synthesize _currentBrands;
@synthesize _currentTypes;
@synthesize _driverUdids;

@synthesize _mapDrivers;
@synthesize _videoDrivers;

- (void) prepareDrivers{
    
    self._mapDrivers = [NSMutableDictionary dictionary];
    
    NSArray *drivers = [[DataCenter defaultDataCenter] driversWithType:@"video"];
    
    for(NSDictionary *dr in drivers)
    {
        [self._mapDrivers setObject:dr forKey:[dr objectForKey:@"driver"]];
    }
    
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
    portDNSLabel.text = @"请配置您的视频管理系统";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, CGRectGetMaxY(portDNSLabel.frame)+20, SCREEN_WIDTH-80, 20)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont systemFontOfSize:18];
    portDNSLabel.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    portDNSLabel.text = @"选择您所需要设置的设备类型> 品牌 > 型号";
    
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
    
    _dianyuanguanliBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left, height,80, 110)];
    [_dianyuanguanliBtn buttonWithIcon:[UIImage imageNamed:@"engineer_dianyuanguanli_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_dianyuanguanli_s.png"] text:audio_power_sequencer normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_dianyuanguanliBtn addTarget:self action:@selector(dianyuanguanliAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dianyuanguanliBtn];
    
    _shipinbofangBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap, height,80, 110)];
    [_shipinbofangBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_dvd_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_dvd_s.png"] text:@"视频播放" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_shipinbofangBtn addTarget:self action:@selector(shipinbofangAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shipinbofangBtn];
    
    
    _shexiangjiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*2, height,80, 110)];
    [_shexiangjiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_shexiangji_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_shexiangji_s.png"] text:video_camera_name normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_shexiangjiBtn addTarget:self action:@selector(shexiangjiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shexiangjiBtn];
    
    _xinxiheBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*3, height,80, 110)];
    [_xinxiheBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_xinxihe_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_xinxihe_s.png"] text:@"信息盒" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_xinxiheBtn addTarget:self action:@selector(xinxiheAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_xinxiheBtn];
    
    _yuanchengshixunBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*4, height,80, 110)];
    [_yuanchengshixunBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_yuanchengshixun_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_yuanchengshixun_s.png"] text:@"远程视讯" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_yuanchengshixunBtn addTarget:self action:@selector(yuanchengshixunAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yuanchengshixunBtn];
    
    _shipinchuliBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*5, height,80, 110)];
    [_shipinchuliBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_shipinchuli_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_shipinchuli_s.png"] text:@"视频处理" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_shipinchuliBtn addTarget:self action:@selector(shipinchuliAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shipinchuliBtn];
    
    _pinjiepingBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*6, height,80, 110)];
    [_pinjiepingBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_pinjieping_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_pinjieping_s.png"] text:@"拼接屏" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_pinjiepingBtn addTarget:self action:@selector(pinjiepingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pinjiepingBtn];
    
    _yejingdianshiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left, height+120,80, 110)];
    [_yejingdianshiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_yejingdianshi_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_yejingdianshi_s.png"] text:@"液晶电视" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_yejingdianshiBtn addTarget:self action:@selector(yejingdianshiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yejingdianshiBtn];
    
    _lubojiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*1, height+120,80, 110)];
    [_lubojiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_luboji_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_luboji_s.png"] text:@"录播机" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_lubojiBtn addTarget:self action:@selector(lubojiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lubojiBtn];
    
    _touyingjiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*2, height+120,80, 110)];
    [_touyingjiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_touyingji_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_touyingji_s.png"] text:@"投影机" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_touyingjiBtn addTarget:self action:@selector(touyingjiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_touyingjiBtn];
    
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(left+rowGap*3, height+120, 80, 80);
    [btnAdd setImage:[UIImage imageNamed:@"engineer_scenario_add_small.png"]
            forState:UIControlStateNormal];
    [self.view addSubview:btnAdd];
    [btnAdd addTarget:self
               action:@selector(addNewIR:)
     forControlEvents:UIControlEventTouchUpInside];
    UILabel* addTitle = [[UILabel alloc] initWithFrame:CGRectMake(left+rowGap*3-20,
                                                                  height+120+80,
                                                                  120, 20)];
    addTitle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:addTitle];
    addTitle.font = [UIFont systemFontOfSize:15];
    addTitle.textAlignment = NSTextAlignmentCenter;
    addTitle.textColor  = [UIColor whiteColor];
    addTitle.text = @"添加红外设备";

    
    int maxWidth = 120;
    float labelStartX = (SCREEN_WIDTH - maxWidth*2 - 60 - 15)/2.0;
    int labelStartY = 480;
    
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX,
                                                                labelStartY,
                                                                maxWidth,
                                                                20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"产品类型";
    
    _productTypePikcer = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX,
                                                                                    labelStartY+20,
                                                                                    maxWidth, 160)];
    [_productTypePikcer removeArray];
    _productTypePikcer.delegate_=self;
    _productTypePikcer.fontSize = 14;
    _productTypePikcer._pickerDataArray = @[@{@"values":@[audio_power_sequencer,@"视频播放",video_camera_name,@"信息盒",@"远程视讯",@"视频处理",@"拼接屏",@"液晶电视",@"录播机",@"投影机"]}];
    [_productTypePikcer selectRow:0 inComponent:0];
    _productTypePikcer._selectColor = RGB(253, 180, 0);
    _productTypePikcer._rowNormalColor = [UIColor whiteColor];
    [self.view addSubview:_productTypePikcer];
    
    [self initBrandAndTypes];
    
    int x1 = CGRectGetMaxX(titleL.frame)+5;
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(x1, labelStartY, maxWidth, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"品牌";
    
    
    _brandPicker = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(x1, labelStartY+20, maxWidth, 160)];
    [_brandPicker removeArray];
    _brandPicker._pickerDataArray = @[@{@"values":@[@"F",@"E",@"A"]}];
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
    [_productCategoryPicker removeArray];
    _productCategoryPicker._pickerDataArray = @[@{@"values":@[@"C",@"V",@"B"]}];
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
    
    self._videoDrivers = [NSMutableArray array];
    [self._selectedSysDic setObject:_videoDrivers forKey:@"video"];
}


- (void) addNewIR:(UIButton*)sender{
    
    if ([_dataSelector isPopoverVisible]) {
        [_dataSelector dismissPopoverAnimated:NO];
    }
    
    TeslariaComboChooser *sel = [[TeslariaComboChooser alloc] init];
    sel._dataArray = @[@"TV", @"DVD", @"Video Box"];
    sel._type = 2;
    sel._unit = @"";
    
    int h = (int)[sel._dataArray count]*30 + 50;
    sel.preferredContentSize = CGSizeMake(150, h);
    sel._size = CGSizeMake(150, h);
    
    IMP_BLOCK_SELF(EngineerVideoDevicePluginViewCtrl);
    sel._block = ^(id object, int index)
    {
        [block_self chooseIRType:object idx:index];
    };
    
    CGRect rect = sender.frame;
    
    _dataSelector = [[UIPopoverController alloc] initWithContentViewController:sel];
    _dataSelector.popoverContentSize = sel.preferredContentSize;
    
    [_dataSelector presentPopoverFromRect:rect
                                   inView:self.view
                 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void) chooseIRType:(NSString*)device idx:(int)index {
    
    RgsIrModel rgs = RGS_IR_M_TV;
    NSString *unit = @"";
    if(index == 0)
    {
        rgs = RGS_IR_M_TV;
        
        unit = @"TV";
    }
    else if(index == 1)
    {
        rgs = RGS_IR_M_DVD;
        
        unit = @"DVD";
    }
//    else if(index == 2)
//    {
//        rgs = RGS_IR_M_VIDEOBOX;
//
//        unit = @"VIDEOBOX";
//    }
    
    int dd = [[NSDate date] timeIntervalSince1970];
    NSString *name = [NSString stringWithFormat:@"%@-%d",unit, dd];
    
    IMP_BLOCK_SELF(EngineerVideoDevicePluginViewCtrl);
    
    [[RegulusSDK sharedRegulusSDK] MakeIrDriverWithIrModel:rgs
                                                      name:name
                                                completion:^(BOOL result, RgsDriverInfo *driver_info, NSError *error) {
                                                    
                                                    if(result)
                                                    {
                                                        [block_self saveNewIRDriver:driver_info
                                                                               name:name
                                                                         deviceType:unit];
                                                    }
                                                    
                                                }];
    
    
    
    if ([_dataSelector isPopoverVisible]) {
        [_dataSelector dismissPopoverAnimated:NO];
    }
}

- (void) saveNewIRDriver:(RgsDriverInfo*)driver_info
                    name:(NSString*)name
                    deviceType:(NSString*)deviceType{
    
    
    NSString *class_name = @"";
    NSString *icon_name = @"";
    NSString *icon_name1 = @"";
    if([deviceType isEqualToString:@"TV"])
    {
        class_name = @"VTVSet";
        icon_name   = @"engineer_video_yejingdianshi_n.png";
        icon_name1  = @"engineer_video_yejingdianshi_s.png";
    }
    else if([deviceType isEqualToString:@"DVD"])
    {
        class_name = @"VDVDPlayerSet";
        
        icon_name   = @"engineer_video_dvd_n.png";
        icon_name1  = @"engineer_video_dvd_s.png";
    }
//    else if([deviceType isEqualToString:@"VIDEOBOX"])
//    {
//        class_name = @"VDVDPlayerSet";
//    }
    
    NSDictionary *greeac = @{@"type":@"video",
                             @"name":name,
                             @"driver":driver_info.serial,
                             @"brand":@"Unknown",
                             @"icon":icon_name,
                             @"icon_s":icon_name1,
                             @"driver_class":class_name,
                             @"ptype":@"Define"
                             };
    
    [[DataCenter defaultDataCenter] saveDriver:greeac];
    [[DataSync sharedDataSync] addDriver:driver_info
                                     key:driver_info.serial];
    
    [self addDriverToCenter:greeac];
    
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
        
        [_videoDrivers addObject:obj];
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
- (void) touyingjiAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:YES];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    self._currentBrands = @[@"Canon"];
    self._currentTypes = @[@"WUX450"];
    self._driverUdids = @[UUID_CANON_WUX450];
    
    _brandPicker._pickerDataArray = @[@{@"values":_currentBrands}];
    _productCategoryPicker._pickerDataArray = @[@{@"values":_currentTypes}];
    
    [_brandPicker selectRow:0 inComponent:0];
    [_productCategoryPicker selectRow:0 inComponent:0];

}
- (void) lubojiAction:(id)sender{
   
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:YES];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    [self initBrandAndTypes];
}
- (void) yejingdianshiAction:(id)sender{
    
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:YES];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    [self initBrandAndTypes];
}
- (void) pinjiepingAction:(id)sender{
    
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:YES];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    [self initBrandAndTypes];
}

- (void) shipinchuliAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:YES];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    self._currentBrands = @[@"Teslaria"];
    self._currentTypes = @[@"Video Switch"];
    self._driverUdids = @[UUID_Video_Switch];
    
    _brandPicker._pickerDataArray = @[@{@"values":_currentBrands}];
    _productCategoryPicker._pickerDataArray = @[@{@"values":_currentTypes}];
    
    [_brandPicker selectRow:0 inComponent:0];
    [_productCategoryPicker selectRow:0 inComponent:0];
}

- (void) yuanchengshixunAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:YES];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    [self initBrandAndTypes];
}

- (void) xinxiheAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:YES];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    [self initBrandAndTypes];
}

- (void) shexiangjiAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:YES];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    
    self._currentBrands = @[@"Teslaria"];
    self._currentTypes = @[@"摄像机"];
    self._driverUdids = @[UUID_NetCamera];
    
    _brandPicker._pickerDataArray = @[@{@"values":_currentBrands}];
    _productCategoryPicker._pickerDataArray = @[@{@"values":_currentTypes}];
    
    [_brandPicker selectRow:0 inComponent:0];
    [_productCategoryPicker selectRow:0 inComponent:0];

}

- (void) shipinbofangAction:(id)sender{
    
    [_dianyuanguanliBtn setBtnHighlited:NO];
    [_shipinbofangBtn setBtnHighlited:YES];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    [self initBrandAndTypes];
    
    self._currentBrands = @[@"Philips"];
    self._currentTypes = @[@"DVD"];
    self._driverUdids = @[UUID_Philips_DVD];
    
    _brandPicker._pickerDataArray = @[@{@"values":_currentBrands}];
    _productCategoryPicker._pickerDataArray = @[@{@"values":_currentTypes}];
    
    [_brandPicker selectRow:0 inComponent:0];
    [_productCategoryPicker selectRow:0 inComponent:0];

}

- (void) dianyuanguanliAction:(id)sender{
    [_dianyuanguanliBtn setBtnHighlited:YES];
    [_shipinbofangBtn setBtnHighlited:NO];
    [_shexiangjiBtn setBtnHighlited:NO];
    [_xinxiheBtn setBtnHighlited:NO];
    [_yuanchengshixunBtn setBtnHighlited:NO];
    [_shipinchuliBtn setBtnHighlited:NO];
    [_pinjiepingBtn setBtnHighlited:NO];
    [_yejingdianshiBtn setBtnHighlited:NO];
    [_lubojiBtn setBtnHighlited:NO];
    [_touyingjiBtn setBtnHighlited:NO];
    
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    [self initBrandAndTypes];
}

- (void) didChangedPickerValue:(NSDictionary*)value {
    
    NSDictionary *val = [value objectForKey:@0];
    if(val)
    {
        
    NSString *brand = [val objectForKey:@"value"];
            
            
    if ([audio_power_sequencer isEqualToString:brand]) {
        [self dianyuanguanliAction:_dianyuanguanliBtn];
    } else if ([@"视频播放" isEqualToString:brand]) {
        [self shipinbofangAction:_shipinbofangBtn];
    } else if ([video_camera_name isEqualToString:brand]) {
        [self shexiangjiAction:_shexiangjiBtn];
    } else if ([@"信息盒" isEqualToString:brand]) {
        [self xinxiheAction:_xinxiheBtn];
    } else if ([@"远程视讯" isEqualToString:brand]) {
        [self yuanchengshixunAction:_yuanchengshixunBtn];
    } else if ([video_process_name isEqualToString:brand]) {
        [self shipinchuliAction:_shipinchuliBtn];
    } else if ([@"拼接屏" isEqualToString:brand]) {
        [self pinjiepingAction:_pinjiepingBtn];
    } else if ([@"液晶电视" isEqualToString:brand]) {
        [self yejingdianshiAction:_yejingdianshiBtn];
    }  else if ([@"录播机" isEqualToString:brand]) {
        [self lubojiAction:_lubojiBtn];
    } else {
        [self touyingjiAction:_touyingjiBtn];
    }
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
    EngineerEnvDevicePluginViewCtrl *ctrl = [[EngineerEnvDevicePluginViewCtrl alloc] init];
    ctrl._selectedSysDic = self._selectedSysDic;
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end



