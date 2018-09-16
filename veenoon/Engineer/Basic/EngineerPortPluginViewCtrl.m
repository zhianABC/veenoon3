//
//  EngineerPortDNSViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/4.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerPortPluginViewCtrl.h"
#import "CenterCustomerPickerView.h"
#import "UIButton+Color.h"
#import "IconCenterTextButton.h"
#import "EDimmerLight.h"
#import "DataSync.h"
#import "EngineerToUseTeslariViewCtrl.h"
#import "TeslariaComboChooser.h"
#import "RegulusSDK.h"
#import "DataCenter.h"


@interface EngineerPortPluginViewCtrl () <CenterCustomerPickerViewDelegate> {
    IconCenterTextButton *_chuankoufuwuqiBtn;
    IconCenterTextButton *_wangkoufuwuqiBtn;
    IconCenterTextButton *_hongwaizhuanhuanqiBtn;
    IconCenterTextButton *_chumopingBtn;
    
    CenterCustomerPickerView *_productTypePikcer;
    CenterCustomerPickerView *_brandPicker;
    CenterCustomerPickerView *_productCategoryPicker;
    
    
}
@property (nonatomic, strong) NSArray *_currentCategorys;
@property (nonatomic, strong) NSArray *_currentBrands;
@property (nonatomic, strong) NSArray *_currentTypes;
@property (nonatomic, strong) NSArray *_driverUdids;

@property (nonatomic, strong) NSMutableDictionary *_mapDrivers;
@property (nonatomic, strong) NSMutableArray *_portDrivers;

@property (nonatomic, strong) NSMutableDictionary *typeAndSubTypeMap;
@property (nonatomic, strong) NSMutableDictionary *nameDriverMap;
@property (nonatomic, strong) NSMutableDictionary *_tmpMap;
@property (nonatomic, strong) NSString *_typeName;


@end

@implementation EngineerPortPluginViewCtrl
@synthesize _selectedSysDic;

@synthesize _currentCategorys;
@synthesize _currentBrands;
@synthesize _currentTypes;
@synthesize _driverUdids;

@synthesize _mapDrivers;
@synthesize _portDrivers;

@synthesize typeAndSubTypeMap;
@synthesize nameDriverMap;
@synthesize _tmpMap;
@synthesize _typeName;

- (void) prepareDrivers{
    
    self._mapDrivers = [NSMutableDictionary dictionary];
    
    //根据Subtype分类
    self.typeAndSubTypeMap = [NSMutableDictionary dictionary];
    self.nameDriverMap = [NSMutableDictionary dictionary];
    
    
    NSArray *drivers = [[DataCenter defaultDataCenter] driversWithType:@"com"];
    
    for(NSDictionary *dr in drivers)
    {
        [self._mapDrivers setObject:dr forKey:[dr objectForKey:@"driver"]];
        
        id key = [dr objectForKey:@"subtype"];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;
    
    [self prepareDrivers];
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, ENGINEER_VIEW_TOP+10, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:18];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"请配置您的辅助管理系统";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT, CGRectGetMaxY(portDNSLabel.frame)+20, SCREEN_WIDTH-80, 20)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont systemFontOfSize:16];
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
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"完成配置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int left = 110;
    int rowGap = (SCREEN_WIDTH - left * 2)/6 -10;
    int height = 200;
    
    _chuankoufuwuqiBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left, height, 120, 110)];
    [_chuankoufuwuqiBtn buttonWithIcon:[UIImage imageNamed:@"chuankoushebei_n.png"] selectedIcon:[UIImage imageNamed:@"chuankoushebei_s.png"] text:@"串口服务器" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_chuankoufuwuqiBtn addTarget:self action:@selector(chuankouAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chuankoufuwuqiBtn];
    
    
    _hongwaizhuanhuanqiBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap, height, 120, 110)];
    [_hongwaizhuanhuanqiBtn buttonWithIcon:[UIImage imageNamed:@"hongwaishebei_n.png"] selectedIcon:[UIImage imageNamed:@"hongwaishebei_s.png"] text:@"红外转发器" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_hongwaizhuanhuanqiBtn addTarget:self action:@selector(hongwaiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hongwaizhuanhuanqiBtn];
    
    
    _chumopingBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*2, height, 120, 110)];
    [_chumopingBtn buttonWithIcon:[UIImage imageNamed:@"chumoping_n.png"] selectedIcon:[UIImage imageNamed:@"chumoping_s.png"] text:@"触摸屏" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_chumopingBtn addTarget:self action:@selector(chumopingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chumopingBtn];
    
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
    titleL.text = @"类型";
    
    _productTypePikcer = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX, labelStartY+20, maxWidth, 160)];
    [_productTypePikcer removeArray];
    _productTypePikcer.delegate_=self;
    _productTypePikcer.fontSize=14;
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
    _productCategoryPicker._selectColor = RGB(253, 180, 0);
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
    
    self._portDrivers = [NSMutableArray array];
    [self._selectedSysDic setObject:_portDrivers forKey:@"port"];
    [self emptyBrandAndTypes];
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
        
        obj._plugicon = [device objectForKey:@"icon"];
        obj._plugicon_s = [device objectForKey:@"icon_s"];
        
        //根据此类型的插件，创建自己的驱动，上传到中控
        [obj createDriver];
        
        [_portDrivers addObject:obj];
    }
}



- (void) chuankouAction:(id)sender{
    
    [_chuankoufuwuqiBtn setBtnHighlited:YES];
    [_wangkoufuwuqiBtn setBtnHighlited:NO];
    [_hongwaizhuanhuanqiBtn setBtnHighlited:NO];
    [_chumopingBtn setBtnHighlited:NO];
    
     [self choosedDevice:@"串口服务器"];
    
}
- (void) hongwaiAction:(id)sender{
    
    [_chuankoufuwuqiBtn setBtnHighlited:NO];
    [_wangkoufuwuqiBtn setBtnHighlited:NO];
    [_hongwaizhuanhuanqiBtn setBtnHighlited:YES];
    [_chumopingBtn setBtnHighlited:NO];
    
    [self choosedDevice:@"红外转发器"];
    
}
- (void) chumopingAction:(id)sender{
    [_chuankoufuwuqiBtn setBtnHighlited:NO];
    [_wangkoufuwuqiBtn setBtnHighlited:NO];
    [_hongwaizhuanhuanqiBtn setBtnHighlited:NO];
    [_chumopingBtn setBtnHighlited:YES];
    
    [self choosedDevice:@"触摸屏"];
    
}
- (void) okAction:(id)sender{
    
    EngineerToUseTeslariViewCtrl *ctrl = [[EngineerToUseTeslariViewCtrl alloc] init];
    ctrl._selectedDevices = self._selectedSysDic;
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





