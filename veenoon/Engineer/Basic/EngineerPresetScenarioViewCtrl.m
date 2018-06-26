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

#import "CreateScenarioViewController.h"
#import "UIButton+Color.h"

#ifdef OPEN_REG_LIB_DEF
#import "RegulusSDK.h"
#endif

#define E_CELL_WIDTH   60


@interface EngineerPresetScenarioViewCtrl()  <ECPlusSelectViewDelegate>{
    
    UIScrollView *_audioScroll;
    UIScrollView *_videoScroll;
    UIScrollView *_envScroll;
    
    int audioStartX;
    int space;
    int audioStartY;
    
    NSString *_selectComName;
    
    BOOL _isEditMode;
    UIButton *_setBtn;
    UIButton *_doneBtn;
    
    UIButton *scenarioButton;
    
    BOOL _isEditingScenario;
}
@property (nonatomic, strong) NSMutableArray *_audioCells;
@property (nonatomic, strong) NSMutableArray *_videoCells;
@property (nonatomic, strong) NSMutableArray *_envCells;

@property (nonatomic, strong) NSMutableArray *_deleteCells;
//@property (nonatomic, strong) NSMutableDictionary *_buttonTagWithDataMap;

@property (nonatomic, strong) NSMutableDictionary *_aDataCheckTestMap;
@property (nonatomic, strong) NSMutableDictionary *_vDataCheckTestMap;
@property (nonatomic, strong) NSMutableDictionary *_eDataCheckTestMap;

@end

@implementation EngineerPresetScenarioViewCtrl
@synthesize _meetingRoomDic;
@synthesize _scenarioName;

@synthesize _audioCells;
@synthesize _videoCells;
@synthesize _envCells;

@synthesize _deleteCells;
//@synthesize _buttonTagWithDataMap;

@synthesize _scenario;
@synthesize _aDataCheckTestMap;
@synthesize _vDataCheckTestMap;
@synthesize _eDataCheckTestMap;

@synthesize _selectedDevices;



-(void) initData {
    
    self._audioCells = [NSMutableArray array];
    self._videoCells = [NSMutableArray array];
    self._envCells = [NSMutableArray array];
    self._deleteCells = [NSMutableArray array];
  
    
    if (_meetingRoomDic) {
        [_meetingRoomDic removeAllObjects];
    } else {
        _meetingRoomDic = [[NSMutableDictionary alloc] init];
    }
    
    if(_scenario == nil)
    {
        self._scenario = [[Scenario alloc] init];
        self._scenario.room_id = 1;
        
        _isEditingScenario = NO;
        
        if(_selectedDevices)
        {
        _scenario._audioDevices = [_selectedDevices objectForKey:@"audio"];
        _scenario._videoDevices = [_selectedDevices objectForKey:@"video"];
        _scenario._envDevices = [_selectedDevices objectForKey:@"env"];
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
    
    BOOL checkAllEdited = YES;
    for(DevicePlugButton *btn in _audioCells)
    {
        if([btn isKindOfClass:[DevicePlugButton class]])
        {
        if(!btn._isEdited)
        {
            checkAllEdited = NO;
            break;
        }
        }
    }
    if(checkAllEdited)
    {
        for(DevicePlugButton *btn in _videoCells)
        {
            if([btn isKindOfClass:[DevicePlugButton class]])
            {
            if(!btn._isEdited)
            {
                checkAllEdited = NO;
                break;
            }
            }
        }
    }
    if(checkAllEdited)
    {
        for(DevicePlugButton *btn in _envCells)
        {
            if([btn isKindOfClass:[DevicePlugButton class]])
            {
            if(!btn._isEdited)
            {
                checkAllEdited = NO;
                break;
            }
            }
        }
    }
    
    if(checkAllEdited)
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
    
    self.view.backgroundColor = BLACK_COLOR;
    
    [self initData];
    
    audioStartX = 0;
    space = 20;
    audioStartY = 50;
    
    _isEditMode = NO;
    
    
    [[DataSync sharedDataSync] loadingLocalDrivers];
    

    
    UIView *topbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topbar.backgroundColor = BLACK_COLOR;
    
    
    UILabel *centerTitleL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 25, 200, 30)];
    centerTitleL.textColor = [UIColor whiteColor];
    centerTitleL.backgroundColor = [UIColor clearColor];
    centerTitleL.textAlignment = NSTextAlignmentCenter;
    [topbar addSubview:centerTitleL];
    centerTitleL.text = @"设备调试";
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT+50, ENGINEER_VIEW_TOP+70, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"音频管理";
    
    
    
    _audioScroll = [[UIScrollView alloc] init];
    [self.view addSubview:_audioScroll];
    _audioScroll.backgroundColor = [UIColor clearColor];
    _audioScroll.frame = CGRectMake(ENGINEER_VIEW_LEFT+50,
                                    ENGINEER_VIEW_TOP+85,
                                    SCREEN_WIDTH-(ENGINEER_VIEW_LEFT+50)*2, 150);
    int audioCount = (int) [[_curScenario objectForKey:@"audioArray"] count] + 1;
    _audioScroll.contentSize = CGSizeMake(audioStartX + audioCount*(E_CELL_WIDTH+space),
                                          150);
    _audioScroll.userInteractionEnabled=YES;
    
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT+50,
                                                             ENGINEER_VIEW_TOP+255,
                                                             SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"视频管理";
    
    _videoScroll = [[UIScrollView alloc] init];
    [self.view addSubview:_videoScroll];
    _videoScroll.backgroundColor = [UIColor clearColor];
    _videoScroll.frame = CGRectMake(ENGINEER_VIEW_LEFT+50,
                                    ENGINEER_VIEW_TOP+270,
                                    SCREEN_WIDTH-(ENGINEER_VIEW_LEFT+50)*2,
                                    150);
    _videoScroll.userInteractionEnabled=YES;
    int videoCount = (int)[[_curScenario objectForKey:@"videoArray"] count] + 1;
    _videoScroll.contentSize = CGSizeMake(audioStartX + videoCount*(E_CELL_WIDTH+space), 150);
  
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT+50,
                                                             ENGINEER_VIEW_TOP+440,
                                                             SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"环境管理";
    
    _envScroll = [[UIScrollView alloc] init];
    [self.view addSubview:_envScroll];
    _envScroll.backgroundColor = [UIColor clearColor];
    _envScroll.frame = CGRectMake(ENGINEER_VIEW_LEFT+50,
                                  ENGINEER_VIEW_TOP+455,
                                  SCREEN_WIDTH-(ENGINEER_VIEW_LEFT+50)*2, 150);
    _envScroll.userInteractionEnabled=YES;
    int envCount = (int)[[_curScenario objectForKey:@"envArray"] count] + 1;
    _envScroll.contentSize = CGSizeMake(audioStartX + envCount*(E_CELL_WIDTH+space), 150);
  
    
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
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:topbar];
    [self.view addSubview:bottomBar];

    scenarioButton = [UIButton buttonWithColor:YELLOW_COLOR selColor:nil];
    scenarioButton.frame = CGRectMake(SCREEN_WIDTH-120, 84, 100, 40);
    [self.view addSubview:scenarioButton];
    scenarioButton.layer.cornerRadius = 3;
    scenarioButton.clipsToBounds = YES;
    [scenarioButton setTitle:@"生成场景" forState:UIControlStateNormal];
    [scenarioButton setTitleColor:B_GRAY_COLOR forState:UIControlStateNormal];
    //[scenarioButton setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    scenarioButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [scenarioButton addTarget:self
                       action:@selector(createScenarioAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    scenarioButton.enabled = NO;
    scenarioButton.alpha = 0.5;

    
    _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:_doneBtn];
    [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doneBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
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
    
    NSMutableArray *audios = [NSMutableArray array];
    NSMutableArray *videos = [NSMutableArray array];
    NSMutableArray *envs = [NSMutableArray array];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:audios forKey:@"audio"];
    [result setObject:videos forKey:@"video"];
    [result setObject:envs forKey:@"env"];
    
    self._selectedDevices = result;
    
    for(RgsDriverObj *driver in drivers)
    {
        RgsDriverInfo *info = driver.info;
        
        NSDictionary *device = [[DataCenter defaultDataCenter] driverWithKey:info.serial];
        
        if(device)
        {
            NSString *classname = [device objectForKey:@"driver_class"];
            Class someClass = NSClassFromString(classname);
            BasePlugElement * obj = [[someClass alloc] init];
            
            if(obj)
            {
                obj._name = [device objectForKey:@"name"];
                obj._brand = [device objectForKey:@"brand"];
                obj._type = [device objectForKey:@"ptype"];
                obj._driverUUID = [device objectForKey:@"brand"];
                
                obj._driverInfo = info;
                
                obj._plugicon = [device objectForKey:@"icon"];
                obj._plugicon_s = [device objectForKey:@"icon_s"];
                
                obj._driver = driver;
                
                
                
                NSString *type = [device objectForKey:@"type"];
                if([type isEqualToString:@"audio"])
                {
                    [audios addObject:obj];
                }
                else if([type isEqualToString:@"video"])
                {
                    [videos addObject:obj];
                }
                else if([type isEqualToString:@"env"])
                {
                    [envs addObject:obj];
                }
            }

        }
        
    }

    [self showCells:1000 datas:audios];
    [self showCells:2000 datas:videos];
    [self showCells:3000 datas:envs];
    
    
    _scenario._audioDevices = audios;
    _scenario._videoDevices = videos;
    _scenario._envDevices = envs;
    
}


- (void) showCells:(int)tagBase datas:(NSArray*)datas{
    
    UIScrollView * scroll = nil;
    NSMutableArray *btncells = nil;
    if(tagBase == 1000){
        scroll = _audioScroll;
        btncells = _audioCells;
    }
    if(tagBase == 2000){
        scroll = _videoScroll;
        btncells = _videoCells;
    }
    if(tagBase == 3000){
        scroll = _envScroll;
        btncells = _envCells;
    }
    
    int x = audioStartX;
    
    for(int i = 0; i < [datas count]; i++)
    {
        BasePlugElement *plug = [datas objectAtIndex:i];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[NSNumber numberWithInteger:[plug getID]] forKey:@"id"];
        [dic setObject:[plug deviceName] forKey:@"name"];
        if(plug._show_icon_name)
            [dic setObject:plug._show_icon_name forKey:@"icon"];
        if(plug._show_icon_sel_name)
            [dic setObject:plug._show_icon_sel_name forKey:@"icon_sel"];
        
        
        NSString *imageStr = [dic objectForKey:@"icon"];
        UIImage *eImg = [UIImage imageNamed:imageStr];
        
        DevicePlugButton *cellBtn = [[DevicePlugButton alloc] initWithFrame:CGRectMake(x,
                                                                                       audioStartY,
                                                                                       E_CELL_WIDTH,
                                                                                       E_CELL_WIDTH)];
        cellBtn.tag = tagBase+i;
        cellBtn._mydata = dic;
        [cellBtn addMyObserver];
        
        
        [cellBtn setBackgroundImage:eImg forState:UIControlStateNormal];
        
        [scroll addSubview:cellBtn];
        [cellBtn addTarget:self
                    action:@selector(buttonAction:)
          forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnlongPressed:)];
        [cellBtn addGestureRecognizer:longPress];
        
        [btncells addObject:cellBtn];
        
        
        if(_isEditingScenario)
        {
            [cellBtn setEditChanged];
        }
        
        x+=E_CELL_WIDTH;
        x+=space;
        
    }
    scroll.contentSize = CGSizeMake(x+E_CELL_WIDTH, 150);
    
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
    
//    CreateScenarioViewController *cr = [[CreateScenarioViewController alloc] init];
//    cr._selectedDevices = _selectedDevices;
//    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:cr];
//    navi.navigationBarHidden = YES;
//
//    [self presentViewController:navi
//                       animated:YES
//                     completion:nil];
    
}

- (void) notifyScenarioResult:(NSNotification*)notify{
    
    scenarioButton.enabled = YES;
    
    NSDictionary *object = notify.object;
    BOOL res = [[object objectForKey:@"result"] boolValue];
    if(res)
    {
        //编辑/保存
      if(_isEditingScenario)
      {
          
      }
        
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
            ctrl._room_id = 1;
            [self.navigationController pushViewController:ctrl animated:YES];
        }

    }
}

-(void)buttonAction:(DevicePlugButton*)cellBtn{
    
    int tag = (int)cellBtn.tag;
    int baseTag = tag/1000;
    
    int index = tag%1000;
    
    NSArray *devices = nil;
    if(baseTag == 1)//音频
    {
        if(_isEditingScenario)
        {
            devices = _scenario._audioDevices;
        }
        else
        {
            devices = [_selectedDevices objectForKey:@"audio"];
        }
    }
    else if(baseTag == 2)//视频
    {
        if(_isEditingScenario)
        {
            devices = _scenario._videoDevices;
        }
        else
        {
        devices = [_selectedDevices objectForKey:@"video"];
        }
    }
    else
    {
        if(_isEditingScenario)
        {
            devices = _scenario._envDevices;
        }
        else
        {
        devices = [_selectedDevices objectForKey:@"env"];
        }
    }
    
    if(_isEditMode)//删除模式
    {
        return;
    }
    
    
    NSMutableDictionary *data = (NSMutableDictionary*)cellBtn._mydata;
    NSString *name = [data objectForKey:@"name"];
    
    /////////
    id notifykey = [NSString stringWithFormat:@"%d-%@",
              [[data objectForKey:@"id"] intValue],
              [data objectForKey:@"name"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifykey
                                                        object:nil];
    /////////
    
    BasePlugElement *plug = [devices objectAtIndex:index];

    if ([name isEqualToString:@"8路电源管理"]) {
        
        EngineerElectronicSysConfigViewCtrl *ctrl = [[EngineerElectronicSysConfigViewCtrl alloc] init];
        ctrl._number = 8;
        if(baseTag == 1)//Audio
        {
            ctrl._electronicSysArray = @[plug];
        }
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
    else if ([name isEqualToString:@"16路电源管理"]) {
        
        EngineerElectronicSysConfigViewCtrl *ctrl = [[EngineerElectronicSysConfigViewCtrl alloc] init];
        ctrl._number = 16;
        if(baseTag == 1)//Audio
        {
            ctrl._electronicSysArray = @[plug];
        }
        ctrl._electronicSysArray = nil;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    if(baseTag == 1)
    {
        
        // player array
        if ([name isEqualToString:@"播放器"]) {
            EngineerPlayerSettingsViewCtrl *ctrl = [[EngineerPlayerSettingsViewCtrl alloc] init];
            ctrl._playerSysArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([name isEqualToString:@"无线麦"]) {
            EngineerWirlessYaoBaoViewCtrl *ctrl = [[EngineerWirlessYaoBaoViewCtrl alloc] init];
            ctrl._wirelessYaoBaoSysArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:audio_mixer_name]) {
            EngineerHunYinSysViewController *ctrl = [[EngineerHunYinSysViewController alloc] init];
            ctrl._hunyinSysArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([name isEqualToString:@"有线会议麦"]) {
            EngineerHandtoHandViewCtrl *ctrl = [[EngineerHandtoHandViewCtrl alloc] init];
            //传
            ctrl._handToHandSysArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([name isEqualToString:@"无线会议麦"]) {
            EngineerWirelessMeetingViewCtrl *ctrl = [[EngineerWirelessMeetingViewCtrl alloc] init];
            ctrl._wirelessMeetingArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number = 12;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:audio_process_name]) {
            EngineerAudioProcessViewCtrl *ctrl = [[EngineerAudioProcessViewCtrl alloc] init];
            ctrl._audioProcessArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"功放"]) {
            EngineerPVExpendViewCtrl *ctrl = [[EngineerPVExpendViewCtrl alloc] init];
            ctrl._pvExpendArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=16;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
    else if(baseTag == 2)
    {
        // wuxian array
        if ([name isEqualToString:@"视频播放器"]) {
            EngineerDVDViewController *ctrl = [[EngineerDVDViewController alloc] init];
            ctrl._dvdSysArray = @[plug];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:video_camera_name]) {
            EngineerCameraViewController *ctrl = [[EngineerCameraViewController alloc] init];
            
            ctrl._cameraSysArray = @[plug];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"远程视讯"]) {
            EngineerRemoteVideoViewCtrl *ctrl = [[EngineerRemoteVideoViewCtrl alloc] init];
            
            ctrl._cameraArray = @[plug];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:video_process_name]) {
            EngineerVideoProcessViewCtrl *ctrl = [[EngineerVideoProcessViewCtrl alloc] init];
            ctrl._videoProcessArray = @[plug];
            
            [ctrl updateProxyCommandValIsLoaded];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([name isEqualToString:@"拼接屏"]) {
            EngineerVideoPinJieViewCtrl *ctrl = [[EngineerVideoPinJieViewCtrl alloc] init];
            ctrl._rowNumber=6;
            ctrl._colNumber=8;
            ctrl._pinjieSysArray = @[plug];// [NSMutableArray arrayWithObject:data];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"液晶电视"]) {
            EngineerTVViewController *ctrl = [[EngineerTVViewController alloc] init];
            ctrl._videoTVArray = @[plug];
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"录播机"]) {
            EngineerLuBoJiViewController *ctrl = [[EngineerLuBoJiViewController alloc] init];
            ctrl._lubojiArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:video_touying_name]) {
            EngineerTouYingJiViewCtrl *ctrl = [[EngineerTouYingJiViewCtrl alloc] init];
            ctrl._touyingjiArray = @[plug];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
    else
    {
        if ([name isEqualToString:@"照明"]) {
            
            EngineerLightViewController *ctrl = [[EngineerLightViewController alloc] init];
            ctrl._lightSysArray = @[plug];// [NSMutableArray arrayWithObject:data];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"空调"]) {
            EngineerAireConditionViewCtrl *ctrl = [[EngineerAireConditionViewCtrl alloc] init];
            ctrl._airSysArray= nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"电动马达"]) {
            EngineerElectronicAutoViewCtrl *ctrl = [[EngineerElectronicAutoViewCtrl alloc] init];
            ctrl._electronicSysArray= nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"新风"]) {
            EngineerNewWindViewCtrl *ctrl = [[EngineerNewWindViewCtrl alloc] init];
            ctrl._windSysArray= nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"地暖"]) {
            EngineerFloorWarmViewCtrl *ctrl = [[EngineerFloorWarmViewCtrl alloc] init];
            ctrl._floorWarmSysArray= nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"空气净化"]) {
            EngineerAirCleanViewCtrl *ctrl = [[EngineerAirCleanViewCtrl alloc] init];
            ctrl._airCleanSysArray= nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"加湿器"]) {
            EngineerAddWetViewCtrl *ctrl = [[EngineerAddWetViewCtrl alloc] init];
            ctrl._addWetSysArray= nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"监控"]) {
            EngineerMonitorViewCtrl *ctrl = [[EngineerMonitorViewCtrl alloc] init];
            ctrl._monitorRoomList = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"能耗统计"]) {
            EngineerInfoCollectViewCtrl *ctrl = [[EngineerInfoCollectViewCtrl alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
    
}


- (void) doneAction:(id)sender{
    
    _isEditMode = NO;
    
    _doneBtn.hidden = YES;
    
    for(UIButton *btn in _deleteCells)
    {
        [btn removeFromSuperview];
    }
    
    [_deleteCells removeAllObjects];
    
}

- (void) btnlongPressed:(id)sender{
    
    if(_isEditMode)
        return;
    _isEditMode = YES;
    
    _doneBtn.hidden = NO;
    
    [_deleteCells removeAllObjects];
    
    for(UIButton *btn in _audioCells)
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
    
    for(UIButton *btn in _videoCells)
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
    
    for(UIButton *btn in _envCells)
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

- (void) delButton:(UIButton*)cellBtn{
    
    UIView *supBtn = cellBtn.superview;
    
    int tag = (int)supBtn.tag;
    int baseTag = tag/1000;
    int idx = tag%1000;
    
    NSMutableArray *dataArray = nil;
    NSMutableArray *btnCells = nil;
    if(baseTag == 1)//音频
    {
        dataArray = [_selectedDevices objectForKey:@"audio"];
        btnCells = _audioCells;
    }
    else if(baseTag == 2)//视频
    {
        dataArray = [_selectedDevices objectForKey:@"video"];
        btnCells = _videoCells;
    }
    else//环境
    {
        dataArray = [_selectedDevices objectForKey:@"env"];
        btnCells = _envCells;
    }

//    BasePlugElement *plug = [dataArray objectAtIndex:idx];
//    [plug removeDriver];

    [dataArray removeObjectAtIndex:idx];

    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         supBtn.transform = CGAffineTransformMakeScale(0, 0);
                         
                     } completion:^(BOOL finished) {
                         
                         [supBtn removeFromSuperview];
                     }];
    
    
    int x = audioStartX;
    
    if([supBtn isKindOfClass:[DevicePlugButton class]])
    {
        [(DevicePlugButton*)supBtn removeMyObserver];
    }
    
    [btnCells removeObject:supBtn];
    
    for(int i = 0; i < [btnCells count]; i++)
    {
        [UIView beginAnimations:nil context:nil];
        
        UIButton *b = [btnCells objectAtIndex:i];
        b.frame = CGRectMake(x,
                             audioStartY,
                             E_CELL_WIDTH,
                             E_CELL_WIDTH);
        
        [UIView commitAnimations];
        
        b.tag = baseTag*1000+i;
        
        x+=E_CELL_WIDTH;
        x+=space;
    }
    
}


- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
