//
//  EngineerPresetScenarioViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/12.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "EngineerPresetScenarioViewCtrl.h"
#import "ECPlusSelectView.h"
#import "EngineerElectronicSysConfigViewCtrl.h"
#import "EngineerPlayerSettingsViewCtrl.h"
#import "EngineerWirlessYaoBaoViewCtrl.h"
#import "EngineerHunYinSysViewController.h"
#import "EngineerHandtoHandViewCtrl.h"
#import "EngineerWirelessMeetingViewCtrl.h"
#import "EngineerAudioProcessViewCtrl.h"
#import "EngineerPVExpendViewCtrl.h"
#import "EngineerDVDViewController.h"
#import "EngineerCameraViewController.h"
#import "EngineerRemoteVideoViewCtrl.h"
#import "EngineerVideoProcessViewCtrl.h"
#import "EngineerVideoPinJieViewCtrl.h"
#import "EngineerTVViewController.h"
#import "EngineerLuBoJiViewController.h"
#import "EngineerTouYingJiViewCtrl.h"
#import "EngineerLightViewController.h"
#import "EngineerAireConditionViewCtrl.h"
#import "EngineerElectronicAutoViewCtrl.h"
#import "EngineerNewWindViewCtrl.h"
#import "EngineerFloorWarmViewCtrl.h"
#import "EngineerAirCleanViewCtrl.h"
#import "EngineerAddWetViewCtrl.h"
#import "EngineerMonitorViewCtrl.h"
#import "EngineerInfoCollectViewCtrl.h"
#import "EngineerScenarioSettingsViewCtrl.h"
#import "EngineerDimmerSwitchViewController.h"

#import "Scenario.h"
#import "APowerESet.h"
#import "AudioEPlayer.h"
#import "VDVDPlayerSet.h"
#import "AudioEWirlessMike.h"
#import "VCameraSettingSet.h"
#import "VRemoteSettingsSet.h"
#import "VRemoteVideoSet.h"
#import "AudioEHand2Hand.h"
#import "VVideoProcessSet.h"
#import "VPinJieSet.h"
#import "DataSync.h"
#import "KVNProgress.h"
#import "AudioEProcessor.h"

#import "VAProcessorProxys.h"
#import "VCameraProxys.h"
#import "VTouyingjiSet.h"
#import "VProjectProxys.h"
#import "EDimmerLight.h"

#import "WaitDialog.h"
#import "DevicePlugButton.h"
#import "DataCenter.h"
#import "MeetingRoom.h"

#import "CreateScenarioViewController.h"
#import "UIButton+Color.h"

#ifdef OPEN_REG_LIB_DEF
#import "RegulusSDK.h"
#endif

#define E_CELL_WIDTH   44


@interface EngineerPresetScenarioViewCtrl()  <ECPlusSelectViewDelegate>{
    
    UIScrollView *_content;
    
    int audioStartX;
    int space;
    int audioStartY;
    
    NSString *_selectComName;
    
    BOOL _isEditMode;
    UIButton *_setBtn;
    UIButton *_doneBtn;
    
    UIButton *scenarioButton;
    
    BOOL _isEditingScenario;
    
    float _yVal;
}
@property (nonatomic, strong) NSMutableArray *_drCells;
@property (nonatomic, strong) NSMutableArray *_deleteCells;

@property (nonatomic, strong) NSMutableDictionary *_aDataCheckTestMap;
@property (nonatomic, strong) NSMutableDictionary *_vDataCheckTestMap;
@property (nonatomic, strong) NSMutableDictionary *_eDataCheckTestMap;

@end

@implementation EngineerPresetScenarioViewCtrl
@synthesize _scenarioName;

@synthesize _drCells;
@synthesize _deleteCells;

@synthesize _scenario;
@synthesize _aDataCheckTestMap;
@synthesize _vDataCheckTestMap;
@synthesize _eDataCheckTestMap;

@synthesize _selectedDevices;



-(void) initData {
    
    self._drCells = [NSMutableArray array];
   
    self._deleteCells = [NSMutableArray array];
  
    if(_scenario == nil)
    {
        MeetingRoom *room = [DataCenter defaultDataCenter]._currentRoom;
        self._scenario = [[Scenario alloc] init];
        
        if(room){
            self._scenario.regulus_id = room.regulus_id;
        }
        
        _isEditingScenario = NO;
        
        if(_selectedDevices)
        {
            _scenario._audioDevices = [_selectedDevices objectForKey:@"audio"];
            _scenario._videoDevices = [_selectedDevices objectForKey:@"video"];
            _scenario._envDevices = [_selectedDevices objectForKey:@"env"];
            _scenario._comDevices = [_selectedDevices objectForKey:@"port"];
            _scenario._otherDevices = [_selectedDevices objectForKey:@"chuangan"];
        }
        
        [DataCenter defaultDataCenter]._scenario = nil;
    }
    else
    {
        _isEditingScenario = YES;
        
        [DataCenter defaultDataCenter]._scenario = _scenario;
        
    }
    
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    
    BOOL haveEdited = NO;
    for(DevicePlugButton *btn in _drCells)
    {
        if([btn isKindOfClass:[DevicePlugButton class]])
        {
            if(btn._isEdited)
            {
                haveEdited = YES;
                break;
            }
        }
    }
    
    
    if(haveEdited)
    {
        scenarioButton.enabled = YES;
        scenarioButton.alpha = 1.0;
    }
    else
    {
        scenarioButton.enabled = NO;
        scenarioButton.alpha = 0.5;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = LOGIN_BLACK_COLOR;
    
    [self initData];
    
    audioStartX = 30;
    space = 36;
    audioStartY = 50;
    _yVal = 15;
    
    _isEditMode = NO;
    
    [[DataSync sharedDataSync] loadingLocalDrivers];

    
    UIView *topbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                              SCREEN_WIDTH,
                                                              64)];
    topbar.backgroundColor = LOGIN_BLACK_COLOR;
    
    
    UILabel *centerTitleL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100,
                                                                      25,
                                                                      200,
                                                                      30)];
    centerTitleL.textColor = [UIColor whiteColor];
    centerTitleL.backgroundColor = [UIColor clearColor];
    centerTitleL.textAlignment = NSTextAlignmentCenter;
    [topbar addSubview:centerTitleL];
    centerTitleL.text = @"设备调试";


    _content = [[UIScrollView alloc] init];
    [self.view addSubview:_content];
    _content.backgroundColor = [UIColor clearColor];
    int top = 64;
    _content.frame = CGRectMake(ENGINEER_VIEW_LEFT+30,
                                    top,
                                    SCREEN_WIDTH-(ENGINEER_VIEW_LEFT+30)*2,
                                SCREEN_HEIGHT - top - 50);
    
    _content.userInteractionEnabled = YES;
    
    
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           SCREEN_HEIGHT-50,
                                                                           SCREEN_WIDTH, 50)];
    
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:topbar];
    [self.view addSubview:bottomBar];

    scenarioButton = [UIButton buttonWithColor:[UIColor clearColor] selColor:nil];
    scenarioButton.frame = CGRectMake(SCREEN_WIDTH-20-160, 0,160, 50);
    [bottomBar addSubview:scenarioButton];
    scenarioButton.layer.cornerRadius = 3;
    scenarioButton.clipsToBounds = YES;
    [scenarioButton setTitle:@"生成场景" forState:UIControlStateNormal];
    [scenarioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scenarioButton setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    scenarioButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [scenarioButton addTarget:self
                       action:@selector(createScenarioAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    scenarioButton.enabled = NO;

    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.frame = CGRectMake(SCREEN_WIDTH-2-160, 20, 160, 44);
    [self.view addSubview:_setBtn];
    [_setBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_setBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    _setBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_setBtn addTarget:self
                 action:@selector(editAction:)
       forControlEvents:UIControlEventTouchUpInside];
    //_setBtn.hidden = YES;
    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.frame = CGRectMake(SCREEN_WIDTH-2-160, 20, 160, 44);
    [self.view addSubview:_doneBtn];
    [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    _doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_doneBtn addTarget:self
                 action:@selector(doneAction:)
       forControlEvents:UIControlEventTouchUpInside];
    _doneBtn.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyScenarioResult:)
                                                 name:@"Notify_Scenario_Create_Result"
                                               object:nil];
    
    
    if(_isEditingScenario)
    {
        [scenarioButton setTitle:@"保存场景" forState:UIControlStateNormal];
        [self recoverScrollThumbCells];
    }
    else
    {
        [self layoutChoosedDevices];
    }
}

- (void) recoverScrollThumbCells{
    
    NSArray *audios = _scenario._audioDevices;
    [self showCells:1000 datas:audios];
    
    NSArray *videos = _scenario._videoDevices;
    [self showCells:2000 datas:videos];
    
    NSArray *envs = _scenario._envDevices;
    [self showCells:3000 datas:envs];
    
    NSArray *oths = _scenario._otherDevices;
    [self showCells:4000 datas:oths];
    
    NSArray *coms = _scenario._comDevices;
    [self showCells:5000 datas:coms];
    
}

- (void) layoutChoosedDevices{
    
    if(_selectedDevices == nil || [_selectedDevices count] == 0)
    {
        self._selectedDevices = [NSMutableDictionary dictionary];
        [self getDriversFromVeenoon];
    }
    else
    {
        NSArray *audios = [_selectedDevices objectForKey:@"audio"];
        [self showCells:1000 datas:audios];
        
        NSArray *videos = [_selectedDevices objectForKey:@"video"];
        [self showCells:2000 datas:videos];
        
        NSArray *envs = [_selectedDevices objectForKey:@"env"];
        [self showCells:3000 datas:envs];
        
        NSArray *chuangan = [_selectedDevices objectForKey:@"chuangan"];
        [self showCells:4000 datas:chuangan];
        
        NSArray *port = [_selectedDevices objectForKey:@"port"];
        [self showCells:5000 datas:port];
    }
   
}

- (void) getDriversFromVeenoon{
    
    IMP_BLOCK_SELF(EngineerPresetScenarioViewCtrl);
    
    RgsAreaObj *areaObj = [DataSync sharedDataSync]._currentArea;
    if(areaObj)
    {
        [KVNProgress show];
        [[RegulusSDK sharedRegulusSDK] GetDrivers:areaObj.m_id
                                       completion:^(BOOL result, NSArray *drivers, NSError *error) {
                                           
                                           if (error) {
                                               
                                               [KVNProgress dismiss];
                                           }
                                           else
                                           {
                                               
                                               [block_self prepareCurrentAreaDrivers:drivers];
                                               
                                               [KVNProgress dismiss];
                                           }
                                       }];
    }
    
}

- (void) prepareCurrentAreaDrivers:(NSArray*)drivers{
    
//    NSMutableArray *audios = [NSMutableArray array];
//    NSMutableArray *videos = [NSMutableArray array];
//    NSMutableArray *envs = [NSMutableArray array];
//
//    NSMutableDictionary *result = [NSMutableDictionary dictionary];
//    [result setObject:audios forKey:@"audio"];
//    [result setObject:videos forKey:@"video"];
//    [result setObject:envs forKey:@"env"];
//
//    self._selectedDevices = result;
//
//    for(RgsDriverObj *driver in drivers)
//    {
//        RgsDriverInfo *info = driver.info;
//
//        NSDictionary *device = [[DataCenter defaultDataCenter] driverWithKey:info.serial];
//
//        if(device)
//        {
//            NSString *classname = [device objectForKey:@"driver_class"];
//            Class someClass = NSClassFromString(classname);
//            BasePlugElement * obj = [[someClass alloc] init];
//
//            if(obj)
//            {
//                obj._name = [device objectForKey:@"name"];
//                obj._brand = [device objectForKey:@"brand"];
//                obj._type = [device objectForKey:@"ptype"];
//                obj._driverUUID = [device objectForKey:@"driver"];
//
//                obj._driverInfo = info;
//
//                obj._plugicon = [device objectForKey:@"icon"];
//                obj._plugicon_s = [device objectForKey:@"icon_s"];
//
//                obj._driver = driver;
//
//
//
//                NSString *type = [device objectForKey:@"type"];
//                if([type isEqualToString:@"audio"])
//                {
//                    [audios addObject:obj];
//                }
//                else if([type isEqualToString:@"video"])
//                {
//                    [videos addObject:obj];
//                }
//                else if([type isEqualToString:@"env"])
//                {
//                    [envs addObject:obj];
//                }
//            }
//
//        }
//
//    }
//
//    [self showCells:1000 datas:audios];
//    [self showCells:2000 datas:videos];
//    [self showCells:3000 datas:envs];
//
//
//    _scenario._audioDevices = audios;
//    _scenario._videoDevices = videos;
//    _scenario._envDevices = envs;
    
}


- (void) showCells:(int)tagBase datas:(NSArray*)datas{
    
    NSMutableArray *btncells = _drCells;
    
    
    int x = audioStartX;
    
    UIImageView *smicon = [[UIImageView alloc] initWithFrame:CGRectMake(25,
                                                                        _yVal,
                                                                        30,
                                                                        30)];
    smicon.layer.contentsGravity = kCAGravityCenter;
    [_content addSubview:smicon];
    
    UILabel *sectionL = [[UILabel alloc] initWithFrame:CGRectMake(60,
                                                                      _yVal,
                                                                      200,
                                                                      30)];
    sectionL.textColor = [UIColor whiteColor];
    sectionL.backgroundColor = [UIColor clearColor];
    sectionL.textAlignment = NSTextAlignmentLeft;
    [_content addSubview:sectionL];
    sectionL.font = [UIFont systemFontOfSize:14];
    sectionL.textColor = YELLOW_COLOR;
    
    if(tagBase == 1000)
    {
        sectionL.text  = @"音频设备";
        smicon.image = [UIImage imageNamed:@"sm_row_audio.png"];
    }
    else if(tagBase == 2000)
    {
        sectionL.text  = @"视频设备";
        smicon.image = [UIImage imageNamed:@"sm_row_video.png"];
    }
    else if(tagBase == 3000)
    {
        sectionL.text  = @"环境设备";
        smicon.image = [UIImage imageNamed:@"sm_row_env.png"];
    }
    else if(tagBase == 4000)
    {
        sectionL.text  = @"传感设备";
        smicon.image = [UIImage imageNamed:@"sm_sensor.png"];
    }
    else if(tagBase == 5000)
    {
        sectionL.text  = @"辅助设备";
        smicon.image = [UIImage imageNamed:@"sm_others.png"];
    }
    _yVal+=40;
    
    for(int i = 0; i < [datas count]; i++)
    {
        BasePlugElement *plug = [datas objectAtIndex:i];
        
        int drid = [plug getID];
        if(drid == 0)
        {
            if(plug.config && [plug.config objectForKey:@"driver_id"])
            {
                drid = [[plug.config objectForKey:@"driver_id"] intValue];
            }
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSNumber numberWithInteger:drid] forKey:@"id"];
        [dic setObject:[plug deviceName] forKey:@"name"];
        [dic setObject:[NSString stringWithFormat:@"%@", [plug class]] forKey:@"class"];
        if(plug._show_icon_name)
            [dic setObject:plug._show_icon_name forKey:@"icon"];
        if(plug._show_icon_sel_name)
            [dic setObject:plug._show_icon_sel_name forKey:@"icon_sel"];
        
        
        NSString *imageStr = [dic objectForKey:@"icon"];
        UIImage *eImg = [UIImage imageNamed:imageStr];
        
        DevicePlugButton *cellBtn = [[DevicePlugButton alloc] initWithFrame:CGRectMake(x,
                                                                                       _yVal,
                                                                                       E_CELL_WIDTH,
                                                                                       E_CELL_WIDTH)];
        cellBtn.tag = tagBase+i;
        cellBtn._mydata = dic;
        cellBtn._plug = plug;
        cellBtn._deviceType = tagBase;
        cellBtn._deviceTypeName = sectionL.text;
        [cellBtn addMyObserver];
        
        
        UILabel *btnL = [[UILabel alloc] initWithFrame:CGRectMake(x-15,
                                                                      _yVal+E_CELL_WIDTH+5,
                                                                      E_CELL_WIDTH+30,
                                                                      20)];
        btnL.textColor = [UIColor whiteColor];
        btnL.backgroundColor = [UIColor clearColor];
        btnL.textAlignment = NSTextAlignmentCenter;
        [_content addSubview:btnL];
        btnL.font = [UIFont systemFontOfSize:12];
        btnL.textColor = DARK_BLUE_COLOR2;
        btnL.text = [dic objectForKey:@"name"];
        
        cellBtn._drNameLabel = btnL;
        
        [cellBtn refreshPlugName];
        
        
        [cellBtn setBackgroundImage:eImg forState:UIControlStateNormal];
        
        [_content addSubview:cellBtn];
        [cellBtn addTarget:self
                    action:@selector(buttonAction:)
          forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(btnlongPressed:)];
        [cellBtn addGestureRecognizer:longPress];
        [btncells addObject:cellBtn];
        
        
        if(plug._isSelected)
        {
            [cellBtn setEditChanged];
        }
        
        x+=E_CELL_WIDTH;
        x+=space;
        
        
        if(x >= (CGRectGetWidth(_content.frame) - E_CELL_WIDTH))
        {
            if(i < [datas count] - 1)
            {
                _yVal += E_CELL_WIDTH;
                _yVal += 30;
                
                x = audioStartX;
            }
        }
        
    }
    
    _yVal += E_CELL_WIDTH;
    _yVal += 40;
    
    _content.contentSize = CGSizeMake(_content.frame.size.width,
                                      _yVal);
    
}


- (void) createScenarioAction:(UIButton*) sender{
    
    sender.enabled = NO;
    
    [_scenario prepareSenarioSlice];

    if(_isEditingScenario)
    {
        [_scenario saveEventScenario];
    }
    else
    {
        [_scenario createEventScenario];
    }
    
}

- (void) notifyScenarioResult:(NSNotification*)notify{
    
    scenarioButton.enabled = YES;
    
    NSDictionary *object = notify.object;
    BOOL res = [[object objectForKey:@"result"] boolValue];
    if(res)
    {
        
        //返回到场景列表页面
        UIViewController *engCtrl = nil;
        
        NSArray *ctrls = self.navigationController.viewControllers;
        for(UIViewController *vc in ctrls)
        {
            if([vc isKindOfClass:[EngineerScenarioSettingsViewCtrl class]])
            {
                engCtrl = vc;
                break;
            }
        }
        
        if(engCtrl){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Reload_Senario"
                                                                object:nil];
            [self.navigationController popToViewController:engCtrl animated:YES];
        }
        else
        {
            EngineerScenarioSettingsViewCtrl *ctrl = [[EngineerScenarioSettingsViewCtrl alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }

    }
}

- (void)buttonAction:(DevicePlugButton*)cellBtn{

    if(_isEditMode)//删除模式
    {
        return;
    }
    NSMutableDictionary *data = (NSMutableDictionary*)cellBtn._mydata;
    
    if(![data isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    
    NSString *class = [data objectForKey:@"class"];
    
    /////////
    id notifykey = [NSString stringWithFormat:@"%d-%@",
              [[data objectForKey:@"id"] intValue],
              [data objectForKey:@"class"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifykey
                                                        object:nil];
    /////////
    
    BasePlugElement *plug = cellBtn._plug;
    
    int baseTag = (int)cellBtn.tag/1000;

    if ([class isEqualToString:@"APowerESet"]) {
        
        EngineerElectronicSysConfigViewCtrl *ctrl = [[EngineerElectronicSysConfigViewCtrl alloc] init];
        ctrl._number = 8;
        ctrl._electronicSysArray = @[plug];
        ctrl.fromScenario = _isEditingScenario;
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
  
    if(baseTag == 1)
    {
        
        // player array
        if ([class isEqualToString:@"AudioEPlayer"]) {
            EngineerPlayerSettingsViewCtrl *ctrl = [[EngineerPlayerSettingsViewCtrl alloc] init];
            ctrl._playerSysArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([class isEqualToString:@"AudioEWirlessMike"]) {
            EngineerWirlessYaoBaoViewCtrl *ctrl = [[EngineerWirlessYaoBaoViewCtrl alloc] init];
            ctrl._wirelessYaoBaoSysArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([class isEqualToString:@"AudioEMix"]) {
            EngineerHunYinSysViewController *ctrl = [[EngineerHunYinSysViewController alloc] init];
            ctrl._hunyinSysArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([class isEqualToString:@"AudioEHand2Hand"]) {
            EngineerHandtoHandViewCtrl *ctrl = [[EngineerHandtoHandViewCtrl alloc] init];
            //传
            ctrl._handToHandSysArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([class isEqualToString:@"AudioEWirlessMeetingSys"]) {
            EngineerWirelessMeetingViewCtrl *ctrl = [[EngineerWirelessMeetingViewCtrl alloc] init];
            ctrl._wirelessMeetingArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number = 12;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([class isEqualToString:@"AudioEProcessor"]) {
            EngineerAudioProcessViewCtrl *ctrl = [[EngineerAudioProcessViewCtrl alloc] init];
            ctrl._audioProcessArray = @[plug];
            ctrl._currentAudioDevices = _scenario._audioDevices;
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([class isEqualToString:@"AudioEMinMax"]) {
            EngineerPVExpendViewCtrl *ctrl = [[EngineerPVExpendViewCtrl alloc] init];
            ctrl._pvExpendArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=16;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
    else if(baseTag == 2)
    {
        // wuxian array
        if ([class isEqualToString:@"VDVDPlayerSet"]) {
            EngineerDVDViewController *ctrl = [[EngineerDVDViewController alloc] init];
            ctrl._dvdSysArray = @[plug];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([class isEqualToString:@"VCameraSettingSet"]) {
            EngineerCameraViewController *ctrl = [[EngineerCameraViewController alloc] init];
            
            ctrl._cameraSysArray = @[plug];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([class isEqualToString:@"VRemoteSettingsSet"]) {
            EngineerRemoteVideoViewCtrl *ctrl = [[EngineerRemoteVideoViewCtrl alloc] init];
            
            ctrl._cameraArray = @[plug];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([class isEqualToString:@"VVideoProcessSet"]) {
            EngineerVideoProcessViewCtrl *ctrl = [[EngineerVideoProcessViewCtrl alloc] init];
            ctrl._videoProcessArray = @[plug];
            
            ctrl._currentVideoDevices = _scenario._videoDevices;
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([class isEqualToString:@"VPinJieSet"]) {
            EngineerVideoPinJieViewCtrl *ctrl = [[EngineerVideoPinJieViewCtrl alloc] init];
            ctrl._rowNumber=6;
            ctrl._colNumber=8;
            ctrl._pinjieSysArray = @[plug];// [NSMutableArray arrayWithObject:data];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([class isEqualToString:@"VTVSet"]) {
            EngineerTVViewController *ctrl = [[EngineerTVViewController alloc] init];
            ctrl._videoTVArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([class isEqualToString:@"VLuBoJiSet"]) {
            EngineerLuBoJiViewController *ctrl = [[EngineerLuBoJiViewController alloc] init];
            ctrl._lubojiArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([class isEqualToString:@"VTouyingjiSet"]) {
            EngineerTouYingJiViewCtrl *ctrl = [[EngineerTouYingJiViewCtrl alloc] init];
            ctrl._touyingjiArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
    else
    {
        if ([class isEqualToString:@"EDimmerLight"]) {
            
            EngineerLightViewController *ctrl = [[EngineerLightViewController alloc] init];
            ctrl._lightSysArray = @[plug];
            ctrl.fromScenario = _isEditingScenario;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        else if ([class isEqualToString:@"EDimmerSwitchLight"]) {
            
            EngineerDimmerSwitchViewController *ctrl = [[EngineerDimmerSwitchViewController alloc] init];
            ctrl._lightSysArray = @[plug];
            ctrl.fromScenario = _isEditingScenario;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([class isEqualToString:@"AirConditionPlug"]) {
            EngineerAireConditionViewCtrl *ctrl = [[EngineerAireConditionViewCtrl alloc] init];
            ctrl._airSysArray = @[plug];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([class isEqualToString:@"BlindPlugin"]) {
            EngineerElectronicAutoViewCtrl *ctrl = [[EngineerElectronicAutoViewCtrl alloc] init];
            ctrl._electronicSysArray = @[plug];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
//        if ([class isEqualToString:@"EDimmerSwitchLight"]) {
//            EngineerNewWindViewCtrl *ctrl = [[EngineerNewWindViewCtrl alloc] init];
//            ctrl._windSysArray= nil;// [NSMutableArray arrayWithObject:data];
//            ctrl._number=8;
//            [self.navigationController pushViewController:ctrl animated:YES];
//        }
//        // wuxian array
//        if ([name isEqualToString:@"地暖"]) {
//            EngineerFloorWarmViewCtrl *ctrl = [[EngineerFloorWarmViewCtrl alloc] init];
//            ctrl._floorWarmSysArray= nil;// [NSMutableArray arrayWithObject:data];
//            ctrl._number=8;
//            [self.navigationController pushViewController:ctrl animated:YES];
//        }
//        // wuxian array
//        if ([name isEqualToString:@"空气净化"]) {
//            EngineerAirCleanViewCtrl *ctrl = [[EngineerAirCleanViewCtrl alloc] init];
//            ctrl._airCleanSysArray= nil;// [NSMutableArray arrayWithObject:data];
//            ctrl._number=8;
//            [self.navigationController pushViewController:ctrl animated:YES];
//        }
//        // wuxian array
//        if ([name isEqualToString:@"加湿器"]) {
//            EngineerAddWetViewCtrl *ctrl = [[EngineerAddWetViewCtrl alloc] init];
//            ctrl._addWetSysArray= nil;// [NSMutableArray arrayWithObject:data];
//            ctrl._number=8;
//            [self.navigationController pushViewController:ctrl animated:YES];
//        }
//        // wuxian array
//        if ([name isEqualToString:@"监控"]) {
//            EngineerMonitorViewCtrl *ctrl = [[EngineerMonitorViewCtrl alloc] init];
//            ctrl._monitorRoomList = nil;// [NSMutableArray arrayWithObject:data];
//            ctrl._number=8;
//            [self.navigationController pushViewController:ctrl animated:YES];
//        }
//        // wuxian array
//        if ([name isEqualToString:@"能耗统计"]) {
//            EngineerInfoCollectViewCtrl *ctrl = [[EngineerInfoCollectViewCtrl alloc] init];
//            [self.navigationController pushViewController:ctrl animated:YES];
//        }
    }
    
}

- (void) editAction:(id)sender{
    
    if(_isEditMode)
        return;
    _isEditMode = YES;
    
    _doneBtn.hidden = NO;
    _setBtn.hidden = YES;
    
    [_deleteCells removeAllObjects];
    
    for(UIButton *btn in _drCells)
    {
        if(btn.tag > 100)
        {
            UIButton *btnDel = [UIButton buttonWithType:UIButtonTypeCustom];
            btnDel.frame = btn.bounds;
            btnDel.tag = btn.tag;
            
            [btn addSubview:btnDel];
            
            [btnDel setImage:[UIImage imageNamed:@"red_del_icon.png"]
                    forState:UIControlStateNormal];
            
            btnDel.imageEdgeInsets = UIEdgeInsetsMake(-30, -30, 0, 0);
            
            [btnDel addTarget:self
                       action:@selector(delButton:)
             forControlEvents:UIControlEventTouchUpInside];
            
            [_deleteCells addObject:btnDel];
        }
    }
}

- (void) doneAction:(id)sender{
    
    _isEditMode = NO;
    
    _doneBtn.hidden = YES;
    _setBtn.hidden = NO;
    
    for(UIButton *btn in _deleteCells)
    {
        [btn removeFromSuperview];
    }
    
    [_deleteCells removeAllObjects];
    
    
    [self reroderCells];
    
}

- (void) btnlongPressed:(UIGestureRecognizer*)sender{
    
    DevicePlugButton *cellBtn = sender.view;
    if(![cellBtn isKindOfClass:[DevicePlugButton class]])
        return;
    
    BasePlugElement *plug = cellBtn._plug;
    
    RgsDriverObj *dr = (RgsDriverObj*)plug._driver;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"重命名" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"设备名";
        textField.text = dr.name;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *drNameTxt = alertController.textFields.firstObject;
        NSString *drName = drNameTxt.text;
        if (drName && [drName length] > 0) {
            
            
            [[RegulusSDK sharedRegulusSDK] RenameDriver:dr.m_id
                                                   name:drName
                                             completion:^(BOOL result, NSError *error) {
                                                 
                                                 dr.name = drName;
                                                 plug._name = drName;
                                                 cellBtn._drNameLabel.text = drName;
                                             }];
            
        }
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
   
}

- (void) delButton:(UIButton*)cellBtn{
    
    DevicePlugButton *supBtn = (DevicePlugButton*)cellBtn.superview;
    if([supBtn isKindOfClass:[DevicePlugButton class]])
    {
        NSMutableArray *dataArray = nil;
        NSMutableArray *btnCells = _drCells;
        BasePlugElement *plug = supBtn._plug;
        int baseTag = supBtn._deviceType;
        if(baseTag == 1000)//音频
        {
            dataArray = [_selectedDevices objectForKey:@"audio"];
        }
        else if(baseTag == 2000)//视频
        {
            dataArray = [_selectedDevices objectForKey:@"video"];
        }
        else if(baseTag == 3000)
        {
            dataArray = [_selectedDevices objectForKey:@"env"];
        }
        else if(baseTag == 4000)
        {
            dataArray = [_selectedDevices objectForKey:@"chuangan"];
        }
        else if(baseTag == 5000)
        {
            dataArray = [_selectedDevices objectForKey:@"port"];
        }
        [dataArray removeObject:plug];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             supBtn.transform = CGAffineTransformMakeScale(0, 0);
                             
                         } completion:^(BOOL finished) {
                             
                             [supBtn removeFromSuperview];
                         }];
        
        
        //int x = audioStartX;
        
        if([supBtn isKindOfClass:[DevicePlugButton class]])
        {
            [(DevicePlugButton*)supBtn removeMyObserver];
            [((DevicePlugButton*)supBtn)._drNameLabel removeFromSuperview];
        }
        
        [btnCells removeObject:supBtn];
    }
    
}

- (void) reroderCells{
    
    int x = audioStartX;
    _yVal = 15;
    
    [[_content subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int lastType = 0;
    BOOL nextLine = NO;
    for(int i = 0; i < [_drCells count]; i++)
    {
        DevicePlugButton *btn = [_drCells objectAtIndex:i];
        [_content addSubview:btn];
        
        
        int curType = btn._deviceType;
        
        if(lastType != curType)
        {
            if(lastType != 0)
            {
                if(nextLine)
                {
                    _yVal+=10;
                }
                else
                {
                    _yVal += 40;
                    _yVal += E_CELL_WIDTH;
                }
                x = audioStartX;
            }
            
            lastType = curType;
            
            UIImageView *smicon = [[UIImageView alloc] initWithFrame:CGRectMake(30,
                                                                                _yVal,
                                                                                30,
                                                                                30)];
            smicon.layer.contentsGravity = kCAGravityCenter;
            [_content addSubview:smicon];
            
            UILabel *sectionL = [[UILabel alloc] initWithFrame:CGRectMake(60,
                                                                          _yVal,
                                                                          200,
                                                                          30)];
            sectionL.textColor = [UIColor whiteColor];
            sectionL.backgroundColor = [UIColor clearColor];
            sectionL.textAlignment = NSTextAlignmentLeft;
            [_content addSubview:sectionL];
            sectionL.font = [UIFont systemFontOfSize:14];
            sectionL.textColor = YELLOW_COLOR;
            
            
            
            if(lastType == 1000)
            {
                sectionL.text  = @"音频设备";
                smicon.image = [UIImage imageNamed:@"sm_row_audio.png"];
            }
            else if(lastType == 2000)
            {
                sectionL.text  = @"视频设备";
                smicon.image = [UIImage imageNamed:@"sm_row_video.png"];
            }
            else if(lastType == 3000)
            {
                sectionL.text  = @"环境设备";
                smicon.image = [UIImage imageNamed:@"sm_row_env.png"];
            }
            else if(lastType == 4000)
            {
                sectionL.text  = @"传感设备";
                smicon.image = [UIImage imageNamed:@"sm_sensor.png"];
            }
            else if(lastType == 5000)
            {
                sectionL.text  = @"辅助设备";
                smicon.image = [UIImage imageNamed:@"sm_others.png"];
            }
            
            _yVal+=40;
            
        }
        
        [UIView beginAnimations:nil context:nil];
        btn.frame = CGRectMake(x,
                               _yVal,
                               E_CELL_WIDTH,
                               E_CELL_WIDTH);
        [UIView commitAnimations];
        
        UILabel *btnL = [[UILabel alloc] initWithFrame:CGRectMake(x-15,
                                                                  _yVal+E_CELL_WIDTH+5,
                                                                  E_CELL_WIDTH+30,
                                                                  20)];
        btnL.textColor = [UIColor whiteColor];
        btnL.backgroundColor = [UIColor clearColor];
        btnL.textAlignment = NSTextAlignmentCenter;
        [_content addSubview:btnL];
        btnL.font = [UIFont systemFontOfSize:12];
        btnL.textColor = DARK_BLUE_COLOR;
        btnL.text = [btn._plug deviceName];
        
        btn._drNameLabel = btnL;
        
        x+=E_CELL_WIDTH;
        x+=space;
        
        nextLine = NO;
        
        if(x >= (CGRectGetWidth(_content.frame) - E_CELL_WIDTH))
        {
            if(i < [_drCells count] - 1)
            {
                _yVal += E_CELL_WIDTH;
                _yVal += 30;
                
                x = audioStartX;
                
                nextLine = YES;
            }
        }
        
    }
    
    _yVal += E_CELL_WIDTH;
    _yVal += 40;
    
    _content.contentSize = CGSizeMake(_content.frame.size.width,
                                      _yVal);
}


- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
