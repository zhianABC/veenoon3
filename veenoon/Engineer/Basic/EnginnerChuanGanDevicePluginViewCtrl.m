//
//  EngineerPortDNSViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EnginnerChuanGanDevicePluginViewCtrl.h"
#import "CenterCustomerPickerView.h"
#import "UIButton+Color.h"
#import "IconCenterTextButton.h"
#import "EDimmerLight.h"
#import "DataSync.h"
#import "EngineerPortPluginViewCtrl.h"


@interface EnginnerChuanGanDevicePluginViewCtrl () <CenterCustomerPickerViewDelegate> {
    IconCenterTextButton *_rentichuanganBtn;
    IconCenterTextButton *_wenshiduBtn;
    IconCenterTextButton *_kongqizhiliangBtn;
    
    CenterCustomerPickerView *_productTypePikcer;
    CenterCustomerPickerView *_brandPicker;
    CenterCustomerPickerView *_productCategoryPicker;
}
@property (nonatomic, strong) NSArray *_currentBrands;
@property (nonatomic, strong) NSArray *_currentTypes;
@property (nonatomic, strong) NSArray *_driverUdids;

@property (nonatomic, strong) NSMutableDictionary *_mapDrivers;
@property (nonatomic, strong) NSMutableArray *_chuanganDrivers;

@end

@implementation EnginnerChuanGanDevicePluginViewCtrl
@synthesize _meetingRoomDic;
@synthesize _selectedSysDic;

@synthesize _currentBrands;
@synthesize _currentTypes;
@synthesize _driverUdids;

@synthesize _mapDrivers;
@synthesize _chuanganDrivers;


- (void) prepareDrivers{
    
    self._mapDrivers = [NSMutableDictionary dictionary];
    
    NSDictionary *light = @{@"type":@"env",
                            @"name":@"照明",
                            @"driver":UUID_6CH_Dimmer_Light,
                            @"brand":@"Teslaria",
                            @"icon":@"engineer_env_zhaoming_n.png",
                            @"icon_s":@"engineer_env_zhaoming_s.png",
                            @"driver_class":@"EDimmerLight",
                            @"ptype":@"6 CH Dimmer Light"
                            };
    
    [_mapDrivers setObject:light forKey:UUID_6CH_Dimmer_Light];
    
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
    portDNSLabel.text = @"请配置您的传感器管理系统";
    
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
    cancelBtn.frame = CGRectMake(0, 0, 160, 50);
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
    int rowGap = (SCREEN_WIDTH - left * 2)/6 -10;
    int height = 200;
    
    _rentichuanganBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left, height, 140, 110)];
    [_rentichuanganBtn buttonWithIcon:[UIImage imageNamed:@"rentichuangan_n.png"] selectedIcon:[UIImage imageNamed:@"rentichuangan_s.png"] text:@"人体感应传感器" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_rentichuanganBtn addTarget:self action:@selector(rentichuangangAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rentichuanganBtn];
    
    
    _wenshiduBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap, height, 140, 110)];
    [_wenshiduBtn buttonWithIcon:[UIImage imageNamed:@"wenshiduchuangan_n.png"] selectedIcon:[UIImage imageNamed:@"wenshiduchuangan_s.png"] text:@"温湿度传感器" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_wenshiduBtn addTarget:self action:@selector(wenshiduchuanganAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_wenshiduBtn];
    
    
    
    _kongqizhiliangBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*2, height, 140, 110)];
    [_kongqizhiliangBtn buttonWithIcon:[UIImage imageNamed:@"kongqichuangan_n.png"] selectedIcon:[UIImage imageNamed:@"kongqichuangan_s.png"] text:@"空气质量传感器" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_kongqizhiliangBtn addTarget:self action:@selector(kongqizhiliangchuanganAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_kongqizhiliangBtn];
    
    
    
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
    _productTypePikcer.fontSize=14;
    _productTypePikcer._pickerDataArray = @[@{@"values":@[@"人体感应传感器",@"温湿度传感器",@"空气质量传感器"]}];
    [_productTypePikcer selectRow:0 inComponent:0];
    _productTypePikcer._selectColor = RGB(253, 180, 0);
    _productTypePikcer._rowNormalColor = [UIColor whiteColor];
    [self.view addSubview:_productTypePikcer];
    
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
    
    self._chuanganDrivers = [NSMutableArray array];
    [self._selectedSysDic setObject:_chuanganDrivers forKey:@"chuangan"];
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
        obj._driverUUID = [device objectForKey:@"brand"];
        
        id key = [device objectForKey:@"driver"];
        obj._driverInfo = [[DataSync sharedDataSync] driverInfoByUUID:key];
        
        obj._plugicon = [device objectForKey:@"icon"];
        obj._plugicon_s = [device objectForKey:@"icon_s"];
        
        //根据此类型的插件，创建自己的驱动，上传到中控
        [obj createDriver];
        
        [_chuanganDrivers addObject:obj];
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


- (void) rentichuangangAction:(id)sender{
    [_rentichuanganBtn setBtnHighlited:YES];
    [_wenshiduBtn setBtnHighlited:NO];
    [_kongqizhiliangBtn setBtnHighlited:NO];
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
    self._currentBrands = @[@"TESLARIA"];
    self._currentTypes = @[@"Dimmer-6"];
    self._driverUdids = @[UUID_6CH_Dimmer_Light];
    
    _brandPicker._pickerDataArray = @[@{@"values":_currentBrands}];
    _productCategoryPicker._pickerDataArray = @[@{@"values":_currentTypes}];
    
    [_brandPicker selectRow:0 inComponent:0];
    [_productCategoryPicker selectRow:0 inComponent:0];
    
    
}
- (void) wenshiduchuanganAction:(id)sender{
    [_rentichuanganBtn setBtnHighlited:NO];
    [_wenshiduBtn setBtnHighlited:YES];
    [_kongqizhiliangBtn setBtnHighlited:NO];
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
}
- (void) kongqizhiliangchuanganAction:(id)sender{
    [_rentichuanganBtn setBtnHighlited:NO];
    [_wenshiduBtn setBtnHighlited:NO];
    [_kongqizhiliangBtn setBtnHighlited:YES];
    
    IconCenterTextButton *btn = (IconCenterTextButton*) sender;
    NSString *btnText = btn._titleL.text;
    [self setBrandValue:btnText];
    
}

-(void) didScrollPickerValue:(NSString*)brand {
    if ([@"人体感应传感器" isEqualToString:brand]) {
        [self rentichuangangAction:_rentichuanganBtn];
    } else if ([@"温湿度传感器" isEqualToString:brand]) {
        [self wenshiduchuanganAction:_wenshiduBtn];
    } else if ([@"空气质量传感器" isEqualToString:brand]) {
        [self kongqizhiliangchuanganAction:_kongqizhiliangBtn];
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
    
    EngineerPortPluginViewCtrl *ctrl = [[EngineerPortPluginViewCtrl alloc] init];
    ctrl._selectedSysDic = self._selectedSysDic;
    ctrl._meetingRoomDic = _meetingRoomDic;
    [self.navigationController pushViewController:ctrl animated:YES];
    
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
- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end





