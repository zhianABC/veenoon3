//
//  EngineerPortDNSViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerEnvDevicePluginViewCtrl.h"
#import "CenterCustomerPickerView.h"
#import "UIButton+Color.h"
#import "IconCenterTextButton.h"
#import "EDimmerLight.h"
#import "DataSync.h"
#import "EnginnerChuanGanDevicePluginViewCtrl.h"
#import "AirConditionPlug.h"
#import "DataCenter.h"
#import "RegulusSDK.h"
#import "TeslariaComboChooser.h"
#import "AirConditionPlug.h"
#import "BlindPlugin.h"
#import "WaitDialog.h"

@interface EngineerEnvDevicePluginViewCtrl () <CenterCustomerPickerViewDelegate> {
    IconCenterTextButton *_zhaomingBtn;
    IconCenterTextButton *_kongtiaoBtn;
    IconCenterTextButton *_diandongmadaBtn;
    IconCenterTextButton *_xinfengBtn;
    IconCenterTextButton *_dinuanBtn;
    IconCenterTextButton *_kongqijinghuaBtn;
    IconCenterTextButton *_jingshuiBtn;
    IconCenterTextButton *_jiashiqiBtn;
    IconCenterTextButton *_menjinBtn;
    IconCenterTextButton *_jiankongBtn;
    IconCenterTextButton *_nenghaotongjiBtn;
    
    CenterCustomerPickerView *_productTypePikcer;
    CenterCustomerPickerView *_brandPicker;
    CenterCustomerPickerView *_productCategoryPicker;
    
    UIPopoverController *_dataSelector;
}
@property (nonatomic, strong) NSArray *_currentCategorys;
@property (nonatomic, strong) NSArray *_currentBrands;
@property (nonatomic, strong) NSArray *_currentTypes;
@property (nonatomic, strong) NSArray *_driverUdids;

@property (nonatomic, strong) NSMutableDictionary *_mapDrivers;
@property (nonatomic, strong) NSMutableArray *_envDrivers;

@property (nonatomic, strong) NSMutableDictionary *typeAndSubTypeMap;
@property (nonatomic, strong) NSMutableDictionary *nameDriverMap;
@property (nonatomic, strong) NSMutableDictionary *_tmpMap;
@property (nonatomic, strong) NSString *_typeName;


@end

@implementation EngineerEnvDevicePluginViewCtrl
@synthesize _selectedSysDic;

@synthesize _currentCategorys;
@synthesize _currentBrands;
@synthesize _currentTypes;
@synthesize _driverUdids;

@synthesize _mapDrivers;
@synthesize _envDrivers;

@synthesize typeAndSubTypeMap;
@synthesize nameDriverMap;
@synthesize _tmpMap;
@synthesize _typeName;

- (void) prepareDrivers{
    
    self._mapDrivers = [NSMutableDictionary dictionary];
    
    //根据Subtype分类
    self.typeAndSubTypeMap = [NSMutableDictionary dictionary];
    self.nameDriverMap = [NSMutableDictionary dictionary];
    
    
    NSArray *drivers = [[DataCenter defaultDataCenter] driversWithType:@"env"];
    
    for(NSDictionary *dr in drivers)
    {
        if([dr objectForKey:@"driver"] == nil)
            continue;
        
        [self._mapDrivers setObject:dr forKey:[dr objectForKey:@"driver"]];
        
        id key = [dr objectForKey:@"subtype"];
        if(key)
        {
            NSMutableArray* arr = [typeAndSubTypeMap objectForKey:key];
            if(arr == nil)
            {
                arr = [NSMutableArray array];
                [typeAndSubTypeMap setObject:arr forKey:key];
            }
            
            [arr addObject:dr];
            
            //
            key = [dr objectForKey:@"name"];
            arr = [nameDriverMap objectForKey:key];
            if(arr == nil)
            {
                arr = [NSMutableArray array];
                [nameDriverMap setObject:arr forKey:key];
            }
            
            [arr addObject:dr];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;
    
    [self prepareDrivers];

    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, ENGINEER_VIEW_TOP+10, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:18];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"请配置您的环境管理系统";
    
    UILabel* portDNSLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, CGRectGetMaxY(portDNSLabel.frame)+20, SCREEN_WIDTH-80, 20)];
    portDNSLabel1.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel1];
    portDNSLabel1.font = [UIFont systemFontOfSize:16];
    portDNSLabel1.textColor  = [UIColor colorWithWhite:1.0 alpha:0.9];
    portDNSLabel1.text = @"选择您所需要设置的设备类型> 品牌 > 型号";
    
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
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"下一步 >" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int left = 110;
    int rowGap = (SCREEN_WIDTH - left * 2)/6 - 10;
    int height = 200;
    
    _zhaomingBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left, height, 80, 110)];
    [_zhaomingBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_zhaoming_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_zhaoming_s.png"] text:@"照明" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_zhaomingBtn addTarget:self action:@selector(zhaomingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_zhaomingBtn];
    
    
    _kongtiaoBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap, height, 80, 110)];
    [_kongtiaoBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_kongtiao_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_kongtiao_s.png"] text:@"空调" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_kongtiaoBtn addTarget:self action:@selector(kongtiaoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_kongtiaoBtn];
    
    
    
    _diandongmadaBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*2, height, 80, 110)];
    [_diandongmadaBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_diandongmada_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_diandongmada_s.png"] text:@"电动马达" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_diandongmadaBtn addTarget:self action:@selector(diandongmadaAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_diandongmadaBtn];
    
    
    _xinfengBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*3, height, 80, 110)];
    [_xinfengBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_xinfeng_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_xinfeng_s.png"] text:@"新风" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_xinfengBtn addTarget:self action:@selector(xinfengAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_xinfengBtn];
    
    
    _dinuanBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*4, height, 80, 110)];
    [_dinuanBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_dire_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_dire_s.png"] text:@"地暖" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_dinuanBtn addTarget:self action:@selector(dinuanAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_dinuanBtn];
    
    _kongqijinghuaBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*4, height, 80, 110)];
    [_kongqijinghuaBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_kongqijignhua_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_kongqijignhua_s.png"] text:@"空气净化" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_kongqijinghuaBtn addTarget:self action:@selector(kongqijinghuaAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_kongqijinghuaBtn];
    
    
    _jiashiqiBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*5, height, 80, 110)];
    [_jiashiqiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_jiashi_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_jiashi_s.png"] text:@"加湿器" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_jiashiqiBtn addTarget:self action:@selector(jiashiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_jiashiqiBtn];
    
    _jiankongBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*6, height, 80, 110)];
    [_jiankongBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_jiankong_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_jiankong_s.png"] text:@"监控" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_jiankongBtn addTarget:self action:@selector(jiankongAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_jiankongBtn];
    
    _nenghaotongjiBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap, height+120, 80, 110)];
    [_nenghaotongjiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_env_nenghao_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_env_nenghao_s.png"] text:@"能耗统计" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_nenghaotongjiBtn addTarget:self action:@selector(nenghaotongjiAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_nenghaotongjiBtn];
    
    /*
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(left, height+120, 80, 80);
    [btnAdd setImage:[UIImage imageNamed:@"engineer_scenario_add_small.png"]
            forState:UIControlStateNormal];
    [self.view addSubview:btnAdd];
    [btnAdd addTarget:self
               action:@selector(addNewIR:)
     forControlEvents:UIControlEventTouchUpInside];
    UILabel* addTitle = [[UILabel alloc] initWithFrame:CGRectMake(left-20,
                                                                height+120+80,
                                                                120, 20)];
    addTitle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:addTitle];
    addTitle.font = [UIFont systemFontOfSize:15];
    addTitle.textAlignment = NSTextAlignmentCenter;
    addTitle.textColor  = [UIColor whiteColor];
    addTitle.text = @"添加红外设备";
    */

    
    int maxWidth = 120;
    float labelStartX = (SCREEN_WIDTH - maxWidth*2 - 60 - 15)/2.0;
    int labelStartY = 480;
    
    labelStartX=labelStartX-25;
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX,
                                                                labelStartY,
                                                                maxWidth, 20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"类型";
    
    _productTypePikcer = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX, labelStartY+20, maxWidth, 160)];
    [_productTypePikcer removeArray];
    _productTypePikcer.delegate_=self;
    _productTypePikcer.fontSize=16;
    _productTypePikcer._selectColor = NEW_ER_BUTTON_SD_COLOR;
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
    _brandPicker._selectColor = NEW_ER_BUTTON_SD_COLOR;
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
    _productCategoryPicker._selectColor = NEW_ER_BUTTON_SD_COLOR;
    _productCategoryPicker._rowNormalColor = [UIColor whiteColor];
    [self.view addSubview:_productCategoryPicker];
    
 
    UIButton *addBtn = [UIButton buttonWithColor:[UIColor clearColor] selColor:RGB(242, 148, 20)];
    addBtn.frame = CGRectMake(SCREEN_WIDTH/2-50, labelStartY+120+55, 100, 40);
    
    addBtn.clipsToBounds = YES;
    [self.view addSubview:addBtn];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [addBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self._envDrivers = [NSMutableArray array];
    [self._selectedSysDic setObject:_envDrivers forKey:@"env"];
    
    [self emptyBrandAndTypes];
}


- (void) addNewIR:(UIButton*)sender{
    
    if ([_dataSelector isPopoverVisible]) {
        [_dataSelector dismissPopoverAnimated:NO];
    }
    
    TeslariaComboChooser *sel = [[TeslariaComboChooser alloc] init];
    sel._dataArray = @[@"AC"];
    sel._type = 2;
    sel._unit = @"";
    
    int h = (int)[sel._dataArray count]*30 + 50;
    sel.preferredContentSize = CGSizeMake(150, h);
    sel._size = CGSizeMake(150, h);
    
    IMP_BLOCK_SELF(EngineerEnvDevicePluginViewCtrl);
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

- (void) chooseIRType:(NSMutableDictionary*)device idx:(int)index {
    
    RgsIrModel rgs = RGS_IR_M_TV;
    NSString *unit = @"";
    if(index == 0)
    {
        rgs = RGS_IR_M_AC;
        
        unit = @"AC";
    }
    
    NSString *brand = [device objectForKey:@"brand"];
    NSString *name = [device objectForKey:@"name"];
    NSString *ptype = [device objectForKey:@"ptype"];
    NSString* irname = [NSString stringWithFormat:@"%@-%@-%@", brand, name, ptype];

    IMP_BLOCK_SELF(EngineerEnvDevicePluginViewCtrl);
    
    [[RegulusSDK sharedRegulusSDK] MakeIrDriverWithIrModel:rgs
                                                      name:irname
                                                completion:^(BOOL result, RgsDriverInfo *driver_info, NSError *error) {
                                                    
                                                    if(result)
                                                    {
                                                        [block_self saveNewIRDriver:driver_info
                                                                               device:device
                                                                         deviceType:@"AC"];
                                                    }
                                                    
                                                }];
    
    
    
    if ([_dataSelector isPopoverVisible]) {
        [_dataSelector dismissPopoverAnimated:NO];
    }
}

- (void) saveNewIRDriver:(RgsDriverInfo*)driver_info
                  device:(NSMutableDictionary*)device
              deviceType:(NSString*)deviceType{

    
    [device setObject:driver_info.serial forKey:@"driver"];
    
    //Veenoon 插件Info库
    [[DataCenter defaultDataCenter] saveDriver:device];
    
    //中控插件Info库
    [[DataSync sharedDataSync] addDriver:driver_info
                                     key:driver_info.serial];
    
    //红外Info库
    [[DataSync sharedDataSync] saveIrDriverToCache:driver_info];
    
    [self addDriverToCenter:device];

}

- (void) emptyBrandAndTypes{
    
    self._currentCategorys = @[@"类型"];
    self._currentBrands = @[@"品牌"];
    self._currentTypes = @[@"型号"];
    self._driverUdids = @[];
    
    _productTypePikcer._pickerDataArray = @[@{@"values":_currentCategorys}];
    [_productTypePikcer selectRow:0 inComponent:0];
    
    _brandPicker._pickerDataArray = @[@{@"values":_currentBrands}];
    _productCategoryPicker._pickerDataArray = @[@{@"values":_currentTypes}];
    
    [_brandPicker selectRow:0 inComponent:0];
    [_productCategoryPicker selectRow:0 inComponent:0];
}


- (void) choosedDevice:(NSString*)category{
    
    self._typeName = category;
    
    NSArray *types = [typeAndSubTypeMap objectForKey:category];
    
    NSMutableArray *cate = [NSMutableArray array];
    for(NSDictionary *dr in types)
    {
        NSString *name = [dr objectForKey:@"name"];
        [cate addObject:name];
    }
    self._currentCategorys = cate;
    if([cate count])
    {
        _productTypePikcer._pickerDataArray = @[@{@"values":cate}];
        [_productTypePikcer selectRow:0 inComponent:0];
        
        NSString *typename = [cate objectAtIndex:0];
        [self choosedDeviceType:typename];
    }
    else
    {
        [self emptyBrandAndTypes];
    }
}

- (void) choosedDeviceType:(NSString*)type{
    
    NSArray *arr = [nameDriverMap objectForKey:type];
    
    if(!arr || [arr count] == 0)
        return;
    
    NSMutableArray *brands = [NSMutableArray array];
    
    self._tmpMap = [NSMutableDictionary dictionary];
    for(NSDictionary *dr in arr)
    {
        NSString *brand = [dr objectForKey:@"brand"];
        
        NSMutableArray *xhs = [_tmpMap objectForKey:brand];
        if(xhs == nil)
        {
            xhs = [NSMutableArray array];
            [_tmpMap setObject:xhs forKey:brand];
        }
        [xhs addObject:dr];
        
        if(![brands containsObject:brand])
            [brands addObject:brand];
    }
    
    self._currentBrands = brands;
    _brandPicker._pickerDataArray = @[@{@"values":_currentBrands}];
    
    if([brands count])
    {
        [_brandPicker selectRow:0 inComponent:0];
        NSString *b = [brands objectAtIndex:0];
        
        [self choosedCurrentBand:b];
    }
}

- (void) choosedCurrentBand:(NSString*)band{
    
    NSArray *xhs = [_tmpMap objectForKey:band];
    
    NSMutableArray *ts = [NSMutableArray array];
    NSMutableArray *ids = [NSMutableArray array];
    for(NSDictionary *d in xhs)
    {
        [ts addObject:[d objectForKey:@"ptype"]];
        [ids addObject:[d objectForKey:@"driver"]];
    }
    
    self._currentTypes = ts;
    self._driverUdids = ids;
    
    _productCategoryPicker._pickerDataArray = @[@{@"values":_currentTypes}];
    
    if([ts count])
    {
        [_productCategoryPicker selectRow:0 inComponent:0];
    }
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
        
        if(obj._driverInfo == nil)
        {
            [[WaitDialog sharedAlertDialog] setTitle:@"未找到对应设备的插件信息"];
            [[WaitDialog sharedAlertDialog] animateShow];
            
            return;
        }
        
        obj._plugicon = [device objectForKey:@"icon"];
        obj._plugicon_s = [device objectForKey:@"icon_s"];
        
        //根据此类型的插件，创建自己的驱动，上传到中控
        [obj createDriver];
        
        [_envDrivers addObject:obj];
    }
}

- (void) zhaomingAction:(id)sender{
    
    [_zhaomingBtn setBtnHighlited:YES];
    [_kongtiaoBtn setBtnHighlited:NO];
    [_diandongmadaBtn setBtnHighlited:NO];
    [_xinfengBtn setBtnHighlited:NO];
    [_kongqijinghuaBtn setBtnHighlited:NO];
    [_jiashiqiBtn setBtnHighlited:NO];
    [_jiankongBtn setBtnHighlited:NO];
    
    [self choosedDevice:@"照明"];


    
}
- (void) kongtiaoAction:(id)sender{
    
    [_zhaomingBtn setBtnHighlited:NO];
    [_kongtiaoBtn setBtnHighlited:YES];
    [_diandongmadaBtn setBtnHighlited:NO];
    [_xinfengBtn setBtnHighlited:NO];
    [_kongqijinghuaBtn setBtnHighlited:NO];
    [_jiashiqiBtn setBtnHighlited:NO];
    [_jiankongBtn setBtnHighlited:NO];
    
    [self choosedDevice:@"空调"];

}
- (void) diandongmadaAction:(id)sender{
    
    [_zhaomingBtn setBtnHighlited:NO];
    [_kongtiaoBtn setBtnHighlited:NO];
    [_diandongmadaBtn setBtnHighlited:YES];
    [_xinfengBtn setBtnHighlited:NO];
    [_kongqijinghuaBtn setBtnHighlited:NO];
    [_jiashiqiBtn setBtnHighlited:NO];
    [_jiankongBtn setBtnHighlited:NO];
    
    [self choosedDevice:@"电动马达"];

}
- (void) xinfengAction:(id)sender{
    [_zhaomingBtn setBtnHighlited:NO];
    [_kongtiaoBtn setBtnHighlited:NO];
    [_diandongmadaBtn setBtnHighlited:NO];
    [_xinfengBtn setBtnHighlited:YES];
    [_kongqijinghuaBtn setBtnHighlited:NO];
    [_jiashiqiBtn setBtnHighlited:NO];
    [_jiankongBtn setBtnHighlited:NO];
    
    [self choosedDevice:@"新风"];
}

- (void) kongqijinghuaAction:(id)sender{
    [_zhaomingBtn setBtnHighlited:NO];
    [_kongtiaoBtn setBtnHighlited:NO];
    [_diandongmadaBtn setBtnHighlited:NO];
    [_xinfengBtn setBtnHighlited:NO];
    [_kongqijinghuaBtn setBtnHighlited:YES];
    [_jiashiqiBtn setBtnHighlited:NO];
    [_jiankongBtn setBtnHighlited:NO];
    
    [self choosedDevice:@"空气净化"];
}

- (void) jiashiAction:(id)sender{
    [_zhaomingBtn setBtnHighlited:NO];
    [_kongtiaoBtn setBtnHighlited:NO];
    [_diandongmadaBtn setBtnHighlited:NO];
    [_xinfengBtn setBtnHighlited:NO];
    [_kongqijinghuaBtn setBtnHighlited:NO];
    [_jiashiqiBtn setBtnHighlited:YES];
    [_jiankongBtn setBtnHighlited:NO];
    
    [self choosedDevice:@"加湿"];
}

- (void) jiankongAction:(id)sender{
    [_zhaomingBtn setBtnHighlited:NO];
    [_kongtiaoBtn setBtnHighlited:NO];
    [_diandongmadaBtn setBtnHighlited:NO];
    [_xinfengBtn setBtnHighlited:NO];
    [_kongqijinghuaBtn setBtnHighlited:NO];
    [_jiashiqiBtn setBtnHighlited:NO];
    [_jiankongBtn setBtnHighlited:YES];
    
    [self choosedDevice:@"监控"];
}



-(void) didScrollPickerValue:(NSString*)value  obj:(id)obj{
    
    //类型
    if(obj == _productTypePikcer)
    {
        [self choosedDeviceType:value];
    }//品牌
    else if(obj == _brandPicker)
    {
        [self choosedCurrentBand:value];
    }//型号
    
}

- (void) okAction:(id)sender{
    
    EnginnerChuanGanDevicePluginViewCtrl *ctrl = [[EnginnerChuanGanDevicePluginViewCtrl alloc] init];
    ctrl._selectedSysDic = self._selectedSysDic;
    [self.navigationController pushViewController:ctrl animated:YES];
    
}
- (void) confirmAction:(id)sender{
    
    NSDictionary *val = [_productCategoryPicker._values objectForKey:@0];
    int idx = [[val objectForKey:@"index"] intValue];
    
    if(idx < [_driverUdids count])
    {
        id key = [_driverUdids objectAtIndex:idx];
        
        id info = [[DataSync sharedDataSync] driverInfoByUUID:key];
        if(info == nil)
        {
            NSDictionary *device =  [_mapDrivers objectForKey:key];
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:device];
            
            NSString *name = [device objectForKey:@"name"];
            
            NSString *brand = [device objectForKey:@"brand"];
            NSString *ptype = [device objectForKey:@"ptype"];
            NSString* irname = [NSString stringWithFormat:@"%@-%@-%@", brand, name, ptype];
            
            RgsDriverInfo *irInfo = [[DataSync sharedDataSync] testIrDriverInfoByName:irname];
            if(irInfo == nil)
            {
                if([name isEqualToString:@"空调"])
                    [self chooseIRType:mdic idx:0];
                else
                {
                    [[WaitDialog sharedAlertDialog] setTitle:@"未找到对应设备的插件信息"];
                    [[WaitDialog sharedAlertDialog] animateShow];
                    
                    return;
                }
            }
            else
            {
                [mdic setObject:irInfo.serial forKey:@"driver"];
                
                [mdic setObject:irname forKey:@"IR"];
                
                //Veenoon插件Info库
                [[DataCenter defaultDataCenter] saveDriver:mdic];
                
                //中控插件Info库
                [[DataSync sharedDataSync] addDriver:irInfo
                                                 key:irInfo.serial];
                
                
                [self addDriverToCenter:mdic];
            }
            
            return;
        }
        
        NSDictionary *device =  [_mapDrivers objectForKey:key];
        [self addDriverToCenter:device];
    }
    
}
- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end




