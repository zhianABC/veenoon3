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
#import "VTVSet.h"
#import "VDVDPlayerSet.h"
#import "WaitDialog.h"

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
@property (nonatomic, strong) NSArray *_currentCategorys;
@property (nonatomic, strong) NSArray *_currentBrands;
@property (nonatomic, strong) NSArray *_currentTypes;
@property (nonatomic, strong) NSArray *_driverUdids;

@property (nonatomic, strong) NSMutableDictionary *_mapDrivers;
@property (nonatomic, strong) NSMutableArray *_videoDrivers;

@property (nonatomic, strong) NSMutableDictionary *typeAndSubTypeMap;
@property (nonatomic, strong) NSMutableDictionary *nameDriverMap;
@property (nonatomic, strong) NSMutableDictionary *_tmpMap;
@property (nonatomic, strong) NSString *_typeName;

@end

@implementation EngineerVideoDevicePluginViewCtrl
@synthesize _selectedSysDic;

@synthesize _currentCategorys;
@synthesize _currentBrands;
@synthesize _currentTypes;
@synthesize _driverUdids;

@synthesize _mapDrivers;
@synthesize _videoDrivers;

@synthesize typeAndSubTypeMap;
@synthesize nameDriverMap;
@synthesize _tmpMap;
@synthesize _typeName;

- (void) prepareDrivers{
    
    self._mapDrivers = [NSMutableDictionary dictionary];
    
    //根据Subtype分类
    self.typeAndSubTypeMap = [NSMutableDictionary dictionary];
    self.nameDriverMap = [NSMutableDictionary dictionary];
    
    
    NSArray *drivers = [[DataCenter defaultDataCenter] driversWithType:@"video"];
    
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
    portDNSLabel.text = @"请配置您的视频管理系统";
    
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
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
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
    
    _dianyuanguanliBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left-10, height,100, 110)];
    [_dianyuanguanliBtn buttonWithIcon:[UIImage imageNamed:@"engineer_dianyuanguanli_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_dianyuanguanli_s.png"] text:@"视频电源管理" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
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
    
    /*先隐藏掉
    _xinxiheBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*3, height,80, 110)];
    [_xinxiheBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_xinxihe_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_xinxihe_s.png"] text:@"信息盒" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_xinxiheBtn addTarget:self action:@selector(xinxiheAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_xinxiheBtn];
     */
    
    _yuanchengshixunBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*3, height,80, 110)];
    [_yuanchengshixunBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_yuanchengshixun_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_yuanchengshixun_s.png"] text:@"远程视讯" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_yuanchengshixunBtn addTarget:self action:@selector(yuanchengshixunAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yuanchengshixunBtn];
    
    _shipinchuliBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*4, height,80, 110)];
    [_shipinchuliBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_shipinchuli_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_shipinchuli_s.png"] text:@"视频处理" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_shipinchuliBtn addTarget:self action:@selector(shipinchuliAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shipinchuliBtn];
    
    _pinjiepingBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*5, height,80, 110)];
    [_pinjiepingBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_pinjieping_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_pinjieping_s.png"] text:@"拼接屏" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_pinjiepingBtn addTarget:self action:@selector(pinjiepingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pinjiepingBtn];
    
    _yejingdianshiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*6, height,80, 110)];
    [_yejingdianshiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_yejingdianshi_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_yejingdianshi_s.png"] text:@"液晶电视" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_yejingdianshiBtn addTarget:self action:@selector(yejingdianshiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yejingdianshiBtn];
    
    _lubojiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left, height+120,80, 110)];
    [_lubojiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_luboji_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_luboji_s.png"] text:@"录播机" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_lubojiBtn addTarget:self action:@selector(lubojiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lubojiBtn];
    
    _touyingjiBtn = [[IconCenterTextButton alloc] initWithFrame: CGRectMake(left+rowGap*1, height+120,80, 110)];
    [_touyingjiBtn buttonWithIcon:[UIImage imageNamed:@"engineer_video_touyingji_n.png"] selectedIcon:[UIImage imageNamed:@"engineer_video_touyingji_s.png"] text:@"投影机" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_touyingjiBtn addTarget:self action:@selector(touyingjiAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_touyingjiBtn];
    
    /*
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
     */
    
    int maxWidth = 120;
    float labelStartX = (SCREEN_WIDTH - maxWidth*2 - 60 - 15)/2.0;
    int labelStartY = 480;
    
    labelStartX=labelStartX-25;
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX,
                                                                labelStartY,
                                                                maxWidth,
                                                                20)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:16];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"类型";
    
    _productTypePikcer = [[CenterCustomerPickerView alloc] initWithFrame:CGRectMake(labelStartX,
                                                                                    labelStartY+20,
                                                                                    maxWidth, 160)];
    [_productTypePikcer removeArray];
    _productTypePikcer.delegate_=self;
    _productTypePikcer.fontSize = 16;
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
    _brandPicker.delegate_ = self;
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
    
    self._videoDrivers = [NSMutableArray array];
    [self._selectedSysDic setObject:_videoDrivers forKey:@"video"];
    
    [self emptyBrandAndTypes];
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

- (void) chooseIRType:(NSMutableDictionary*)device idx:(int)index {
    
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
    
    NSString *brand = [device objectForKey:@"brand"];
    NSString *name = [device objectForKey:@"name"];
    NSString *ptype = [device objectForKey:@"ptype"];
    NSString* irname = [NSString stringWithFormat:@"%@-%@-%@", brand, name, ptype];
    
    [device setObject:irname forKey:@"IR"];
    
    IMP_BLOCK_SELF(EngineerVideoDevicePluginViewCtrl);
    
    [[RegulusSDK sharedRegulusSDK] MakeIrDriverWithIrModel:rgs
                                                      name:irname
                                                completion:^(BOOL result, RgsDriverInfo *driver_info, NSError *error) {
                                                    
                                                    if(result)
                                                    {
                                                        [block_self saveNewIRDriver:driver_info
                                                                               device:device
                                                                         deviceType:unit];
                                                    }
                                                    
                                                }];

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
    [[DataCenter defaultDataCenter] saveIrDriverToCache:driver_info];
    
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
        if(![cate containsObject:name])
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
        
        [_videoDrivers addObject:obj];
    }
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
            NSString *subtype = [device objectForKey:@"subtype"];
            NSString *brand = [device objectForKey:@"brand"];
            NSString *ptype = [device objectForKey:@"ptype"];
            NSString* irname = [NSString stringWithFormat:@"%@-%@-%@", brand, name, ptype];
            
            RgsDriverInfo *irInfo = [[DataCenter defaultDataCenter] testIrDriverInfoByName:irname];
            if(irInfo == nil)
            {
                if([subtype isEqualToString:@"视频播放器"])
                    [self chooseIRType:mdic idx:1];
                else if([subtype isEqualToString:@"液晶电视"])
                    [self chooseIRType:mdic idx:0];
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
    
    
    [self choosedDevice:@"投影机"];

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
    
    
    [self choosedDevice:@"录播机"];
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
    
    [self choosedDevice:@"液晶电视"];
    
    
    
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
    
    
    [self choosedDevice:@"拼接屏"];
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
    
    
    [self choosedDevice:@"视频处理"];
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
    
    
    [self choosedDevice:@"远程视讯"];
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
    
    
    [self choosedDevice:@"信息盒"];
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
    
    
    [self choosedDevice:@"摄像机"];

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
    
    
   [self choosedDevice:@"视频播放"];
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
    
    
    [self choosedDevice:@"电源管理"];
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
    
    EngineerEnvDevicePluginViewCtrl *ctrl = [[EngineerEnvDevicePluginViewCtrl alloc] init];
    ctrl._selectedSysDic = self._selectedSysDic;
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end



