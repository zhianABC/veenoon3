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
#import "EngineerCleanWaterViewCtrl.h"
#import "EngineerAddWetViewCtrl.h"
#import "EngineerDoorAccessViewCtrl.h"
#import "EngineerMonitorViewCtrl.h"
#import "EngineerInfoCollectViewCtrl.h"
#import "EngineerScenarioSettingsViewCtrl.h"

#import "Scenario.h"
#import "APowerESet.h"
#import "AudioEPlayer.h"
#import "VDVDPlayerSet.h"
#import "AudioEWirlessMike.h"

#define E_CELL_WIDTH   60


@interface EngineerPresetScenarioViewCtrl()  <ECPlusSelectViewDelegate>{
    ECPlusSelectView *ecp;
    
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
}
@property (nonatomic, strong) NSMutableArray *_audioCells;
@property (nonatomic, strong) NSMutableArray *_videoCells;
@property (nonatomic, strong) NSMutableArray *_envCells;

@property (nonatomic, strong) NSMutableArray *_deleteCells;
@property (nonatomic, strong) NSMutableDictionary *_buttonTagWithDataMap;

@property (nonatomic, strong) Scenario *_scenario;


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
@synthesize _buttonTagWithDataMap;

@synthesize _scenario;
@synthesize _aDataCheckTestMap;
@synthesize _vDataCheckTestMap;
@synthesize _eDataCheckTestMap;


-(void) initData {
    
    self._audioCells = [NSMutableArray array];
    self._videoCells = [NSMutableArray array];
    self._envCells = [NSMutableArray array];
    self._deleteCells = [NSMutableArray array];
    self._buttonTagWithDataMap = [NSMutableDictionary dictionary];
    
    
    self._aDataCheckTestMap = [NSMutableDictionary dictionary];
    self._vDataCheckTestMap = [NSMutableDictionary dictionary];
    self._eDataCheckTestMap = [NSMutableDictionary dictionary];
    
    if (_meetingRoomDic) {
        [_meetingRoomDic removeAllObjects];
    } else {
        _meetingRoomDic = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableArray *scenarioArray = [_meetingRoomDic objectForKey:@"scenarioArray"];
    if (scenarioArray == nil) {
        NSMutableArray *scenarioArray = [[NSMutableArray alloc] init];
        [_meetingRoomDic setObject:scenarioArray forKey:@"scenarioArray"];
        
    }
    
    if (_scenarioName == nil) {
        _scenarioName = @"";
        NSMutableDictionary *scenarioDic = [[NSMutableDictionary alloc] init];
        [scenarioDic setObject:_scenarioName forKey:@"scenarioName"];
        [scenarioArray addObject:scenarioDic];
        
        _curScenario = scenarioDic;
    } else {
        for (id dic in scenarioArray) {
            NSString *sName = [dic objectForKey:@"scenarioName"];
            if ([sName isEqualToString:_scenarioName]) {
                _curScenario = dic;
                break;
            }
        }
    }
    NSMutableArray *audioArray = [_curScenario objectForKey:@"audioArray"];
    if (audioArray == nil) {
        NSMutableArray *audioArray = [[NSMutableArray alloc] init];
        [_curScenario setObject:audioArray forKey:@"audioArray"];
    }
    
    NSMutableArray *videoArray = [_curScenario objectForKey:@"videoArray"];
    if (videoArray == nil) {
        NSMutableArray *videoArray = [[NSMutableArray alloc] init];
        [_curScenario setObject:videoArray forKey:@"videoArray"];
    }
    
    NSMutableArray *envArray = [_curScenario objectForKey:@"envArray"];
    if (envArray == nil) {
        NSMutableArray *envArray = [[NSMutableArray alloc] init];
        [_curScenario setObject:envArray forKey:@"envArray"];
    }
    
    
    self._scenario = [[Scenario alloc] init];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    audioStartX = 0;
    space = 20;
    audioStartY = 50;
    
    _isEditMode = NO;
    
    ecp = [[ECPlusSelectView alloc]
                             initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                      64, 300, SCREEN_HEIGHT-114)];
    ecp.delegate = self;
    
    
    
    UIView *topbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topbar.backgroundColor = THEME_COLOR;
    
    UIButton *scenarioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scenarioButton.frame = CGRectMake(SCREEN_WIDTH-120, 20, 100, 44);
    [topbar addSubview:scenarioButton];
    [scenarioButton setTitle:@"生成场景" forState:UIControlStateNormal];
    [scenarioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [scenarioButton setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    scenarioButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [scenarioButton addTarget:self
                 action:@selector(createScenarioAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [topbar addSubview:line];
    
    UILabel *centerTitleL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 25, 200, 30)];
    centerTitleL.textColor = [UIColor whiteColor];
    centerTitleL.backgroundColor = [UIColor clearColor];
    centerTitleL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:centerTitleL];
    centerTitleL.text = @"设置场景";
    
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
    
    [self addComponentToEnd:_audioScroll dataDic:nil];
    
    
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
    [self addComponentToEnd:_videoScroll dataDic:nil];
    
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
    [self addComponentToEnd:_envScroll dataDic:nil];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           SCREEN_HEIGHT-50,
                                                                           SCREEN_WIDTH, 50)];
    
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
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
    
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:_setBtn];
    [_setBtn setTitle:@"设置" forState:UIControlStateNormal];
    [_setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_setBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    _setBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_setBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
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

    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView =  YES;
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
 
    [self.view addSubview:ecp];
    
    [self.view addSubview:topbar];
    [self.view addSubview:bottomBar];
}
- (void) createScenarioAction:(id) sender{
    EngineerScenarioSettingsViewCtrl *ctrl = [[EngineerScenarioSettingsViewCtrl alloc] init];
    
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (void) handleTapGesture:(UIGestureRecognizer*)sender{
    
    CGPoint pt = [sender locationInView:self.view];
    
    if(pt.x < SCREEN_WIDTH-300)
    {
    
    CGRect rc = ecp.frame;
    rc.origin.x = SCREEN_WIDTH;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         ecp.frame = rc;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    }
}

-(void) okAction:(id)sender {
    
    CGRect rc = ecp.frame;
    if(rc.origin.x < SCREEN_WIDTH)
    {
        rc.origin.x = SCREEN_WIDTH;
    }
    else
    {
        rc.origin.x = SCREEN_WIDTH-300;
    }
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         ecp.frame = rc;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
//    EngineerScenarioSettingsViewCtrl *ctrl = [[EngineerScenarioSettingsViewCtrl alloc] init];
//
//    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) addAction:(UIButton*)sender{
    
    if(_isEditMode)
        return;
    
    [ecp expandSection:(int)sender.tag];
    
    CGRect rc = ecp.frame;
    rc.origin.x = SCREEN_WIDTH-300;
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         ecp.frame = rc;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
}

-(void)buttonAction:(UIButton*)cellBtn{
    
    int tag = (int)cellBtn.tag;
    int baseTag = tag/1000;
    
    NSArray *dataArray = nil;
    if(baseTag == 1)//音频
    {
        dataArray = [_curScenario objectForKey:@"audioArray"];
    }
    else if(baseTag == 2)//视频
    {
        dataArray = [_curScenario objectForKey:@"videoArray"];
    }
    else
    {
        dataArray = [_curScenario objectForKey:@"envArray"];
    }
    
    if(_isEditMode)//删除模式
    {
        
        return;
    }
 
    id  key = [NSNumber numberWithInteger:cellBtn.tag];
    NSMutableDictionary *data = [_buttonTagWithDataMap
                                  objectForKey:key];
    
    NSString *name = [data objectForKey:@"name"];

    if ([name isEqualToString:@"8路电源管理"]) {
        
        EngineerElectronicSysConfigViewCtrl *ctrl = [[EngineerElectronicSysConfigViewCtrl alloc] init];
        ctrl._number = 8;
        if(baseTag == 1)//Audio
        {
            ctrl._electronicSysArray = _scenario._A8PowerPlugs;
        }
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
    else if ([name isEqualToString:@"16路电源管理"]) {
        
        EngineerElectronicSysConfigViewCtrl *ctrl = [[EngineerElectronicSysConfigViewCtrl alloc] init];
        ctrl._number = 16;
        if(baseTag == 1)//Audio
        {
            ctrl._electronicSysArray = _scenario._A16PowerPlugs;
        }
        ctrl._electronicSysArray = nil;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    if(baseTag == 1)
    {
        
        // player array
        if ([name isEqualToString:@"播放器"]) {
            EngineerPlayerSettingsViewCtrl *ctrl = [[EngineerPlayerSettingsViewCtrl alloc] init];
            ctrl._playerSysArray = _scenario._APlayerPlugs;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([name isEqualToString:@"无线麦"]) {
            EngineerWirlessYaoBaoViewCtrl *ctrl = [[EngineerWirlessYaoBaoViewCtrl alloc] init];
            ctrl._wirelessYaoBaoSysArray = _scenario._AWirelessMikePlugs;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"混音系统"]) {
            EngineerHunYinSysViewController *ctrl = [[EngineerHunYinSysViewController alloc] init];
            ctrl._hunyinSysArray = [NSMutableArray arrayWithObject:data];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([name isEqualToString:@"有线会议麦"]) {
            EngineerHandtoHandViewCtrl *ctrl = [[EngineerHandtoHandViewCtrl alloc] init];
            
            //传
            ctrl._handToHandSysArray = nil;//[NSMutableArray arrayWithObject:data];
            ctrl._number = 12;
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
        if ([name isEqualToString:@"音频处理"]) {
            EngineerAudioProcessViewCtrl *ctrl = [[EngineerAudioProcessViewCtrl alloc] init];
            ctrl._audioProcessArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._inputNumber=16;
            ctrl._outputNumber=16;
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
            ctrl._dvdSysArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=16;
                
            ctrl._dvdSysArray = _scenario._VDVDPlayers;
            
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"摄像机"]) {
            EngineerCameraViewController *ctrl = [[EngineerCameraViewController alloc] init];
            ctrl._cameraSysArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=16;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"远程视讯"]) {
            EngineerRemoteVideoViewCtrl *ctrl = [[EngineerRemoteVideoViewCtrl alloc] init];
            ctrl._remoteVideoArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=16;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"视频处理"]) {
            EngineerVideoProcessViewCtrl *ctrl = [[EngineerVideoProcessViewCtrl alloc] init];
            ctrl._inNumber=18;
            ctrl._outNumber=14;
            ctrl._videoProcessInArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._videoProcessOutArray = nil;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([name isEqualToString:@"拼接屏"]) {
            EngineerVideoPinJieViewCtrl *ctrl = [[EngineerVideoPinJieViewCtrl alloc] init];
            ctrl._rowNumber=6;
            ctrl._colNumber=8;
            ctrl._pinjieSysArray = nil;// [NSMutableArray arrayWithObject:data];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"液晶电视"]) {
            EngineerTVViewController *ctrl = [[EngineerTVViewController alloc] init];
            ctrl._videoTVArray = [NSMutableArray arrayWithObject:data];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"录播机"]) {
            EngineerLuBoJiViewController *ctrl = [[EngineerLuBoJiViewController alloc] init];
            ctrl._lubojiArray = [NSMutableArray arrayWithObject:data];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        // wuxian array
        if ([name isEqualToString:@"投影仪"]) {
            EngineerTouYingJiViewCtrl *ctrl = [[EngineerTouYingJiViewCtrl alloc] init];
            ctrl._touyingjiArray = [NSMutableArray arrayWithObject:data];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
    else
    {
        if ([name isEqualToString:@"照明"]) {
            
            EngineerLightViewController *ctrl = [[EngineerLightViewController alloc] init];
            ctrl._lightSysArray = nil;// [NSMutableArray arrayWithObject:data];
            ctrl._number=8;
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
        if ([name isEqualToString:@"净水"]) {
            EngineerCleanWaterViewCtrl *ctrl = [[EngineerCleanWaterViewCtrl alloc] init];
            ctrl._cleanWaterSysArray= nil;//[NSMutableArray arrayWithObject:data];
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
        if ([name isEqualToString:@"门禁"]) {
            EngineerDoorAccessViewCtrl *ctrl = [[EngineerDoorAccessViewCtrl alloc] init];
            ctrl._doorAccessSysArray = nil;// [NSMutableArray arrayWithObject:data];
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
- (void) initVDVDPlayers {
    
    if([_scenario._VDVDPlayers count] == 0)
    {
        NSMutableArray *powers = [NSMutableArray array];
        
        for(int i = 0; i < 3; i++)
        {
            VDVDPlayerSet *pset = [[VDVDPlayerSet alloc] init];
            pset._com = @"191.16.1.100";
            pset._brand = @"brand1";
            pset._type = @"type1";
            pset._deviceno = [NSString stringWithFormat:@"%d", i];
            pset._irArray = [NSMutableArray array];
            [powers addObject:pset];
        }
        
        _scenario._VDVDPlayers = powers;
    }
}

- (void) init8Powers{
    
    if([_scenario._A8PowerPlugs count] == 0)
    {
        NSMutableArray *powers = [NSMutableArray array];
        
        for(int i = 0; i < 3; i++)
        {
            APowerESet *pset = [[APowerESet alloc] init];
            [pset initLabs:8];
            pset._brand = @"brand1";
            
            [powers addObject:pset];
        }
        
        _scenario._A8PowerPlugs = powers;
    }
}

- (void) init16Powers{
    
    if([_scenario._A16PowerPlugs count] == 0)
    {
        NSMutableArray *powers = [NSMutableArray array];
        
        for(int i = 0; i < 3; i++)
        {
            APowerESet *pset = [[APowerESet alloc] init];
            [pset initLabs:16];
            pset._brand = @"brand1";
            
            [powers addObject:pset];
        }
        
        _scenario._A16PowerPlugs = powers;
    }
}

- (void) initAudioEPlayers{
    
    if([_scenario._APlayerPlugs count] == 0)
    {
        NSMutableArray *palyers = [NSMutableArray array];
        
        for(int i = 0; i < 3; i++)
        {
            AudioEPlayer *pset = [[AudioEPlayer alloc] init];
            pset._brand = @"brand1";
            
            [palyers addObject:pset];
        }
        
        _scenario._APlayerPlugs = palyers;
    }
}

- (void) initWirelessMikePlugs{
    
    if([_scenario._AWirelessMikePlugs count] == 0)
    {
        NSMutableArray *mikes = [NSMutableArray array];
        
        for(int i = 0; i < 3; i++)
        {
            AudioEWirlessMike *pset = [[AudioEWirlessMike alloc] init];
            pset._brand = @"品牌";
            pset._type = @"型号";
            pset._index = i;
            pset._deviceno = [NSString stringWithFormat:@"%02d", i+1];
            [pset initChannels:2];
            [mikes addObject:pset];
        }
        
        _scenario._AWirelessMikePlugs = mikes;
    }
}

// if dataDic == nil, refresh scroll view
- (void) addComponentToEnd:(UIScrollView*) scrollView dataDic:(NSDictionary*)dataDic {
    
    
    NSMutableArray *dataArray = nil;
    NSMutableArray *btnCells = nil;
    
    NSString *name = nil;
    if(dataDic)
    {
        name = [dataDic objectForKey:@"name"];
    }
    
    int tagBase = 0;
    int addTag = 100;
    if (scrollView == _audioScroll) {
        tagBase = 1000;
        addTag = 0;
        dataArray = [_curScenario objectForKey:@"audioArray"];
        
        btnCells = _audioCells;
        
        if(name)
        {
            if([_aDataCheckTestMap objectForKey:name])
            {
                return;
            }
            [_aDataCheckTestMap setObject:dataDic forKey:name];
            
            if([name isEqualToString:@"8路电源管理"])
            {
                [self init8Powers];
            }
            else if([name isEqualToString:@"16路电源管理"])
            {
                [self init16Powers];
            }
            else if([name isEqualToString:@"播放器"])
            {
                [self initAudioEPlayers];
            }
            else if([name isEqualToString:@"无线麦"])
            {
                [self initWirelessMikePlugs];
            }
        }
        
    } else if (scrollView == _videoScroll) {
        addTag = 1;
        tagBase = 2000;
        dataArray = [_curScenario objectForKey:@"videoArray"];
        
        btnCells = _videoCells;
        
        if(name)
        {
            if([_vDataCheckTestMap objectForKey:name])
            {
                return;
            }
            
            [_vDataCheckTestMap setObject:dataDic forKey:name];
            
            if([name isEqualToString:@"视频播放器"])
            {
                [self initVDVDPlayers];
            }
        }
        
    } else {
        addTag = 2;
        tagBase = 3000;
        dataArray = [_curScenario objectForKey:@"envArray"];
        
        btnCells = _envCells;
        
        if(name)
        {
            if([_eDataCheckTestMap objectForKey:name])
            {
                return;
            }
            
            [_eDataCheckTestMap setObject:dataDic forKey:name];
        }
    }
    
    //保存数据到数组
    if(dataDic){
        [dataArray addObject:dataDic];
    }
    
    [[scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [btnCells removeAllObjects];
    
    int x = audioStartX;
    for(int i = 0; i < [dataArray count]; i++)
    {
        NSDictionary *dic = [dataArray objectAtIndex:i];
        
        NSString *imageStr = [dic objectForKey:@"icon"];
        UIImage *eImg = [UIImage imageNamed:imageStr];
        
        UIButton *cellBtn = [[UIButton alloc] initWithFrame:CGRectMake(x,
                                                                       audioStartY,
                                                                       E_CELL_WIDTH,
                                                                       E_CELL_WIDTH)];
        cellBtn.tag = tagBase+i;
        
        
        [_buttonTagWithDataMap setObject:dic
                                  forKey:[NSNumber numberWithInteger:cellBtn.tag]];
        
        [cellBtn setBackgroundImage:eImg forState:UIControlStateNormal];
        
        [scrollView addSubview:cellBtn];
        [cellBtn addTarget:self
                    action:@selector(buttonAction:)
          forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnlongPressed:)];
        [cellBtn addGestureRecognizer:longPress];
        
        [btnCells addObject:cellBtn];
        
        
        
        
        x+=E_CELL_WIDTH;
        x+=space;
        
    }
    
    UIButton *addElem = [UIButton buttonWithType:UIButtonTypeCustom];
    addElem.frame = CGRectMake(x, audioStartY, E_CELL_WIDTH, E_CELL_WIDTH);
    [addElem setImage:[UIImage imageNamed:@"engineer_scenario_add_n.png"] forState:UIControlStateNormal];
    addElem.tag = addTag;
    [scrollView addSubview:addElem];
    
    [addElem addTarget:self
                    action:@selector(addAction:)
          forControlEvents:UIControlEventTouchUpInside];

    
    [btnCells addObject:addElem];
    
    scrollView.contentSize = CGSizeMake(x+E_CELL_WIDTH, 150);
    
}

- (void) doneAction:(id)sender{
    
    _isEditMode = NO;
    
    _setBtn.hidden = NO;
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
    
    _setBtn.hidden = YES;
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
    
    [self handleTapGesture:nil];
}

- (void) delButton:(UIButton*)cellBtn{
    
    int tag = (int)cellBtn.tag;
    int baseTag = tag/1000;
    
    NSMutableArray *dataArray = nil;
    NSMutableArray *btnCells = nil;
    if(baseTag == 1)//音频
    {
        dataArray = [_curScenario objectForKey:@"audioArray"];
        btnCells = _audioCells;
    }
    else if(baseTag == 2)//视频
    {
        dataArray = [_curScenario objectForKey:@"videoArray"];
        btnCells = _videoCells;
    }
    else//环境
    {
        dataArray = [_curScenario objectForKey:@"envArray"];
        btnCells = _envCells;
    }
    
    id  key = [NSNumber numberWithInteger:cellBtn.tag];
    NSDictionary *selectedData = [_buttonTagWithDataMap
                                  objectForKey:key];
    

    [dataArray removeObject:selectedData];
 
    
    UIView *supBtn = cellBtn.superview;
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         supBtn.transform = CGAffineTransformMakeScale(0, 0);
                         
                     } completion:^(BOOL finished) {
                         
                         [supBtn removeFromSuperview];
                     }];
    
    
    int x = audioStartX;
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
        
        x+=E_CELL_WIDTH;
        x+=space;
    }
    
    [_buttonTagWithDataMap removeObjectForKey:key];
}



- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt {
    
    CGPoint viewPoint = [self.view convertPoint:pt fromView:ecp];
    NSString *type = [data objectForKey:@"type"];
    BOOL isInAudio = CGRectContainsPoint(_audioScroll.frame, viewPoint);
    BOOL isInVideo = CGRectContainsPoint(_videoScroll.frame, viewPoint);
    BOOL isInEnv = CGRectContainsPoint(_envScroll.frame, viewPoint);
    
    if (([type isEqualToString:@"音频插件"] || [type isEqualToString:@"电源插件"]) && isInAudio) {
        [self addComponentToEnd:_audioScroll dataDic:data];
    } else if (([type isEqualToString:@"视频插件"] || [type isEqualToString:@"电源插件"]) && isInVideo) {
        [self addComponentToEnd:_videoScroll dataDic:data];
    } else if ([type isEqualToString:@"环境插件"] && isInEnv) {
        [self addComponentToEnd:_envScroll dataDic:data];
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
