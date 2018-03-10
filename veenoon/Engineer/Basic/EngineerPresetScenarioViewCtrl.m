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

@interface EngineerPresetScenarioViewCtrl()  <ECPlusSelectViewDelegate>{
    ECPlusSelectView *ecp;
    
    UIScrollView *_audioScroll;
    UIScrollView *_videoScroll;
    UIScrollView *_envScroll;
    
    int audioStartX;
    int space;
    int audioStartY;
    
    NSString *_selectComName;
}
@end

@implementation EngineerPresetScenarioViewCtrl
@synthesize _meetingRoomDic;
@synthesize _scenarioName;
-(void) initData {
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    audioStartX = 30;
    space = 5;
    audioStartY = 50;
    
    ecp = [[ECPlusSelectView alloc]
                             initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                      64, 300, SCREEN_HEIGHT-114)];
    ecp.delegate = self;
    
    [self.view addSubview:ecp];
    
    UIView *topbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topbar.backgroundColor = THEME_COLOR;
    [self.view addSubview:topbar];
    
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
    _audioScroll.frame = CGRectMake(ENGINEER_VIEW_LEFT+50, ENGINEER_VIEW_TOP+100, SCREEN_WIDTH-(ENGINEER_VIEW_LEFT+50)-300, 150);
    int audioCount = (int) [[_curScenario objectForKey:@"audioArray"] count] + 1;
    _audioScroll.contentSize = CGSizeMake(audioStartX + audioCount*(77+space), 160);
    _audioScroll.userInteractionEnabled=YES;
    
    [self addComponentToEnd:_audioScroll dataDic:nil];
    
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT+50, ENGINEER_VIEW_TOP+255, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"视频管理";
    
    _videoScroll = [[UIScrollView alloc] init];
    [self.view addSubview:_videoScroll];
    _videoScroll.backgroundColor = [UIColor clearColor];
    _videoScroll.frame = CGRectMake(ENGINEER_VIEW_LEFT+50, ENGINEER_VIEW_TOP+285, SCREEN_WIDTH-(ENGINEER_VIEW_LEFT+50)-300, 150);
    _videoScroll.userInteractionEnabled=YES;
    int videoCount = (int)[[_curScenario objectForKey:@"videoArray"] count] + 1;
    _videoScroll.contentSize = CGSizeMake(audioStartX + videoCount*(77+space), 160);
    [self addComponentToEnd:_videoScroll dataDic:nil];
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(ENGINEER_VIEW_LEFT+50, ENGINEER_VIEW_TOP+440, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"环境管理";
    
    _envScroll = [[UIScrollView alloc] init];
    [self.view addSubview:_envScroll];
    _envScroll.backgroundColor = [UIColor clearColor];
    _envScroll.frame = CGRectMake(ENGINEER_VIEW_LEFT+50, ENGINEER_VIEW_TOP+470, SCREEN_WIDTH-(ENGINEER_VIEW_LEFT+50)-300, 150);
    _envScroll.userInteractionEnabled=YES;
    int envCount = (int)[[_curScenario objectForKey:@"envArray"] count] + 1;
    _envScroll.contentSize = CGSizeMake(audioStartX + envCount*(77+space), 160);
    [self addComponentToEnd:_envScroll dataDic:nil];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
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
}

-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer{
    NSString *name = [gestureRecognizer valueForKey:@"name"];
    
    NSMutableArray *envArray = [_curScenario objectForKey:@"envArray"];
    NSMutableArray *lightArray;
    NSMutableArray *airConditionArray;
    NSMutableArray *electronicAutoArray;
    NSMutableArray *newWindArray;
    NSMutableArray *floorWarmArray;
    NSMutableArray *airCleanArray;
    NSMutableArray *cleanWarterArray;
    NSMutableArray *addWetArray;
    NSMutableArray *doorAccessArray;
    NSMutableArray *monitorArray;
    NSMutableArray *inforCollectArray;
    
    for (id envSys in envArray) {
        if ([[envSys objectForKey:@"name"] isEqualToString:@"lightSys"]) {
            lightArray = [envSys objectForKey:@"value"];
        }
        if ([[envSys objectForKey:@"name"] isEqualToString:@"airConditionSys"]) {
            airConditionArray = [envSys objectForKey:@"value"];
        }
        if ([[envSys objectForKey:@"name"] isEqualToString:@"electronicAutoSys"]) {
            electronicAutoArray = [envSys objectForKey:@"value"];
        }
        if ([[envSys objectForKey:@"name"] isEqualToString:@"newWindSys"]) {
            newWindArray = [envSys objectForKey:@"value"];
        }
        if ([[envSys objectForKey:@"name"] isEqualToString:@"floorWarmSys"]) {
            floorWarmArray = [envSys objectForKey:@"value"];
        }
        if ([[envSys objectForKey:@"name"] isEqualToString:@"airCleanSys"]) {
            airCleanArray = [envSys objectForKey:@"value"];
        }
        if ([[envSys objectForKey:@"name"] isEqualToString:@"cleanWarterSys"]) {
            cleanWarterArray = [envSys objectForKey:@"value"];
        }
        if ([[envSys objectForKey:@"name"] isEqualToString:@"addWetSys"]) {
            addWetArray = [envSys objectForKey:@"value"];
        }
        if ([[envSys objectForKey:@"name"] isEqualToString:@"doorAccessSys"]) {
            doorAccessArray = [envSys objectForKey:@"value"];
        }
        if ([[envSys objectForKey:@"name"] isEqualToString:@"monitorSys"]) {
            monitorArray = [envSys objectForKey:@"value"];
        }
        if ([[envSys objectForKey:@"name"] isEqualToString:@"infoCollectSys"]) {
            inforCollectArray = [envSys objectForKey:@"value"];
        }
    }
    
    if (lightArray == nil) {
        lightArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"lightSys" forKey:@"name"];
        [playerDic setObject:lightArray forKey:@"value"];
        
        //[envArray addObject:playerDic];
    }
    if (airConditionArray == nil) {
        airConditionArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"airConditionSys" forKey:@"name"];
        [playerDic setObject:airConditionArray forKey:@"value"];
        
        //[envArray addObject:playerDic];
    }
    if (electronicAutoArray == nil) {
        electronicAutoArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"electronicAutoSys" forKey:@"name"];
        [playerDic setObject:electronicAutoArray forKey:@"value"];
        
        //[envArray addObject:playerDic];
    }
    if (newWindArray == nil) {
        newWindArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"newWindSys" forKey:@"name"];
        [playerDic setObject:newWindArray forKey:@"value"];
        
        //[envArray addObject:playerDic];
    }
    if (floorWarmArray == nil) {
        floorWarmArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"floorWarmSys" forKey:@"name"];
        [playerDic setObject:floorWarmArray forKey:@"value"];
        
        //[envArray addObject:playerDic];
    }
    if (airCleanArray == nil) {
        airCleanArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"airCleanSys" forKey:@"name"];
        [playerDic setObject:airCleanArray forKey:@"value"];
        
        //[envArray addObject:playerDic];
    }
    if (cleanWarterArray == nil) {
        cleanWarterArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"cleanWarterSys" forKey:@"name"];
        [playerDic setObject:cleanWarterArray forKey:@"value"];
        
        //[envArray addObject:playerDic];
    }
    if (addWetArray == nil) {
        addWetArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"addWetSys" forKey:@"name"];
        [playerDic setObject:addWetArray forKey:@"value"];
        
        //[envArray addObject:playerDic];
    }
    if (doorAccessArray == nil) {
        doorAccessArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"doorAccessSys" forKey:@"name"];
        [playerDic setObject:doorAccessArray forKey:@"value"];
        
        //[envArray addObject:playerDic];
    }
    if (monitorArray == nil) {
        monitorArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"monitorSys" forKey:@"name"];
        [playerDic setObject:monitorArray forKey:@"value"];
        
        //[envArray addObject:playerDic];
    }
    if (inforCollectArray == nil) {
        inforCollectArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"infoCollectSys" forKey:@"name"];
        [playerDic setObject:inforCollectArray forKey:@"value"];
        
        //[envArray addObject:playerDic];
    }
    
    // wuxian array
    if ([name isEqualToString:@"照明"]) {
        EngineerLightViewController *ctrl = [[EngineerLightViewController alloc] init];
        ctrl._lightSysArray= lightArray;
        ctrl._number=8;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"空调"]) {
        EngineerAireConditionViewCtrl *ctrl = [[EngineerAireConditionViewCtrl alloc] init];
        ctrl._airSysArray= airConditionArray;
        ctrl._number=8;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"电动马达"]) {
        EngineerElectronicAutoViewCtrl *ctrl = [[EngineerElectronicAutoViewCtrl alloc] init];
        ctrl._electronicSysArray= electronicAutoArray;
        ctrl._number=8;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"新风"]) {
        EngineerNewWindViewCtrl *ctrl = [[EngineerNewWindViewCtrl alloc] init];
        ctrl._windSysArray= newWindArray;
        ctrl._number=8;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"地暖"]) {
        EngineerFloorWarmViewCtrl *ctrl = [[EngineerFloorWarmViewCtrl alloc] init];
        ctrl._floorWarmSysArray= floorWarmArray;
        ctrl._number=8;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"空气净化"]) {
        EngineerAirCleanViewCtrl *ctrl = [[EngineerAirCleanViewCtrl alloc] init];
        ctrl._airCleanSysArray= airCleanArray;
        ctrl._number=8;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"净水"]) {
        EngineerCleanWaterViewCtrl *ctrl = [[EngineerCleanWaterViewCtrl alloc] init];
        ctrl._cleanWaterSysArray= cleanWarterArray;
        ctrl._number=8;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"加湿器"]) {
        EngineerAddWetViewCtrl *ctrl = [[EngineerAddWetViewCtrl alloc] init];
        ctrl._addWetSysArray= addWetArray;
        ctrl._number=8;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"门禁"]) {
        EngineerDoorAccessViewCtrl *ctrl = [[EngineerDoorAccessViewCtrl alloc] init];
        ctrl._doorAccessSysArray = doorAccessArray;
        ctrl._number=8;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"监控"]) {
        EngineerMonitorViewCtrl *ctrl = [[EngineerMonitorViewCtrl alloc] init];
        ctrl._monitorRoomList = monitorArray;
        ctrl._number=8;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"能耗统计"]) {
        EngineerInfoCollectViewCtrl *ctrl = [[EngineerInfoCollectViewCtrl alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    NSMutableArray *videoArray = [_curScenario objectForKey:@"videoArray"];
    NSMutableArray *dvdSysArray;
    NSMutableArray *cameraSysArray;
    NSMutableArray *remoteVideoSysArray;
    NSMutableArray *videoInSysArray;
    NSMutableArray *videoOutSysArray;
    NSMutableArray *pinjieSysArray;
    NSMutableArray *tvSysArray;
    NSMutableArray *lubojiSysArray;
    NSMutableArray *touyingjiSysArray;
    for (id videoSys in videoArray) {
        if ([[videoSys objectForKey:@"name"] isEqualToString:@"dvdSys"]) {
            dvdSysArray = [videoSys objectForKey:@"value"];
        }
        if ([[videoSys objectForKey:@"name"] isEqualToString:@"cameraSys"]) {
            cameraSysArray = [videoSys objectForKey:@"value"];
        }
        if ([[videoSys objectForKey:@"name"] isEqualToString:@"remoteVideoSys"]) {
            remoteVideoSysArray = [videoSys objectForKey:@"value"];
        }
        if ([[videoSys objectForKey:@"name"] isEqualToString:@"videoInSys"]) {
            videoInSysArray = [videoSys objectForKey:@"value"];
        }
        if ([[videoSys objectForKey:@"name"] isEqualToString:@"videoOutSys"]) {
            videoOutSysArray = [videoSys objectForKey:@"value"];
        }
        if ([[videoSys objectForKey:@"name"] isEqualToString:@"pinjieSys"]) {
            pinjieSysArray = [videoSys objectForKey:@"value"];
        }
        if ([[videoSys objectForKey:@"name"] isEqualToString:@"tvSys"]) {
            tvSysArray = [videoSys objectForKey:@"value"];
        }
        if ([[videoSys objectForKey:@"name"] isEqualToString:@"lubojiSys"]) {
            lubojiSysArray = [videoSys objectForKey:@"value"];
        }
        if ([[videoSys objectForKey:@"name"] isEqualToString:@"touyingjiSys"]) {
            touyingjiSysArray = [videoSys objectForKey:@"value"];
        }
    }
    if (dvdSysArray == nil) {
        dvdSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"dvdSys" forKey:@"name"];
        [playerDic setObject:dvdSysArray forKey:@"value"];
        
        //[videoArray addObject:playerDic];
    }
    if (cameraSysArray == nil) {
        cameraSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"cameraSys" forKey:@"name"];
        [playerDic setObject:cameraSysArray forKey:@"value"];
        
        //[videoArray addObject:playerDic];
    }
    if (remoteVideoSysArray == nil) {
        remoteVideoSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"remoteVideoSys" forKey:@"name"];
        [playerDic setObject:remoteVideoSysArray forKey:@"value"];
        
        //[videoArray addObject:playerDic];
    }
    if (videoInSysArray == nil) {
        videoInSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"videoInSys" forKey:@"name"];
        [playerDic setObject:videoInSysArray forKey:@"value"];
        
        //[videoArray addObject:playerDic];
    }
    if (videoOutSysArray == nil) {
        videoOutSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"videoOutSys" forKey:@"name"];
        [playerDic setObject:videoOutSysArray forKey:@"value"];
        
        //[videoArray addObject:playerDic];
    }
    if (pinjieSysArray == nil) {
        pinjieSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"pinjieSys" forKey:@"name"];
        [playerDic setObject:pinjieSysArray forKey:@"value"];
        
        //[videoArray addObject:playerDic];
    }
    if (tvSysArray == nil) {
        tvSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"tvSys" forKey:@"name"];
        [playerDic setObject:tvSysArray forKey:@"value"];
        
        //[videoArray addObject:playerDic];
    }
    if (lubojiSysArray == nil) {
        lubojiSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"lubojiSys" forKey:@"name"];
        [playerDic setObject:lubojiSysArray forKey:@"value"];
        
        //[videoArray addObject:playerDic];
    }
    if (touyingjiSysArray == nil) {
        touyingjiSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"touyingjiSys" forKey:@"name"];
        [playerDic setObject:touyingjiSysArray forKey:@"value"];
        
        //[videoArray addObject:playerDic];
    }
    // wuxian array
    if ([name isEqualToString:@"视频播放器"]) {
        EngineerDVDViewController *ctrl = [[EngineerDVDViewController alloc] init];
        ctrl._dvdSysArray = dvdSysArray;
        ctrl._number=16;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"摄像机"]) {
        EngineerCameraViewController *ctrl = [[EngineerCameraViewController alloc] init];
        ctrl._cameraSysArray = cameraSysArray;
        ctrl._number=16;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"远程视讯"]) {
        EngineerRemoteVideoViewCtrl *ctrl = [[EngineerRemoteVideoViewCtrl alloc] init];
        ctrl._remoteVideoArray = remoteVideoSysArray;
        ctrl._number=16;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"视频处理"]) {
        EngineerVideoProcessViewCtrl *ctrl = [[EngineerVideoProcessViewCtrl alloc] init];
        ctrl._inNumber=18;
        ctrl._outNumber=14;
        ctrl._videoProcessInArray = videoInSysArray;
        ctrl._videoProcessOutArray = videoOutSysArray;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    // wuxian array
    if ([name isEqualToString:@"拼接屏"]) {
        EngineerVideoPinJieViewCtrl *ctrl = [[EngineerVideoPinJieViewCtrl alloc] init];
        ctrl._rowNumber=6;
        ctrl._colNumber=8;
        ctrl._pinjieSysArray = pinjieSysArray;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"液晶电视"]) {
        EngineerTVViewController *ctrl = [[EngineerTVViewController alloc] init];
        ctrl._videoTVArray = tvSysArray;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"录播机"]) {
        EngineerLuBoJiViewController *ctrl = [[EngineerLuBoJiViewController alloc] init];
        ctrl._lubojiArray = lubojiSysArray;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"投影仪"]) {
        EngineerTouYingJiViewCtrl *ctrl = [[EngineerTouYingJiViewCtrl alloc] init];
        ctrl._touyingjiArray = touyingjiSysArray;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    NSMutableArray *audioArray = [_curScenario objectForKey:@"audioArray"];
    NSMutableArray *electronic8SysArray;
    NSMutableArray *electronic16SysArray;
    NSMutableArray *playerSysArray;
    NSMutableArray *wirelessYaobaoArray;
    NSMutableArray *hunyinSysArray;
    NSMutableArray *handToHandSysArray;
    NSMutableArray *wirelessMeetingArray;
    NSMutableArray *audioProcessArray;
    NSMutableArray *pvExpendArray;
    for (id audioSys in audioArray) {
        if ([[audioSys objectForKey:@"name"] isEqualToString:@"electronic8Sys"]) {
            electronic8SysArray = [audioSys objectForKey:@"value"];
        }
        if ([[audioSys objectForKey:@"name"] isEqualToString:@"electronic16Sys"]) {
            electronic16SysArray = [audioSys objectForKey:@"value"];
        }
        if ([[audioSys objectForKey:@"name"] isEqualToString:@"playerSys"]) {
            playerSysArray = [audioSys objectForKey:@"value"];
        }
        if ([[audioSys objectForKey:@"name"] isEqualToString:@"wirelessYaobaoSys"]) {
            wirelessYaobaoArray = [audioSys objectForKey:@"value"];
        }
        if ([[audioSys objectForKey:@"name"] isEqualToString:@"hunyinSys"]) {
            hunyinSysArray = [audioSys objectForKey:@"value"];
        }
        if ([[audioSys objectForKey:@"name"] isEqualToString:@"handToHandSys"]) {
            handToHandSysArray = [audioSys objectForKey:@"value"];
        }
        if ([[audioSys objectForKey:@"name"] isEqualToString:@"wirelessMeetingSys"]) {
            wirelessMeetingArray = [audioSys objectForKey:@"value"];
        }
        if ([[audioSys objectForKey:@"name"] isEqualToString:@"audioProcessSys"]) {
            audioProcessArray = [audioSys objectForKey:@"value"];
        }
        if ([[audioSys objectForKey:@"name"] isEqualToString:@"pvExpendSys"]) {
            pvExpendArray = [audioSys objectForKey:@"value"];
        }
    }
    if (electronic8SysArray == nil) {
        electronic8SysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *electronic8SysDic = [[NSMutableDictionary alloc] init];
        [electronic8SysDic setObject:@"electronic8Sys" forKey:@"name"];
        [electronic8SysDic setObject:electronic8SysArray forKey:@"value"];
        
        //[audioArray addObject:electronic8SysDic];
    }
    if (electronic16SysArray == nil) {
        electronic16SysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *electronic16SysDic = [[NSMutableDictionary alloc] init];
        [electronic16SysDic setObject:@"electronic16Sys" forKey:@"name"];
        [electronic16SysDic setObject:electronic16SysArray forKey:@"value"];
        
        //[audioArray addObject:electronic16SysDic];
    }
    if (playerSysArray == nil) {
        playerSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"playerSys" forKey:@"name"];
        [playerDic setObject:playerSysArray forKey:@"value"];
        
        //[audioArray addObject:playerDic];
    }
    
    if (wirelessYaobaoArray == nil) {
        wirelessYaobaoArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"wirelessYaobaoSys" forKey:@"name"];
        [playerDic setObject:wirelessYaobaoArray forKey:@"value"];
        
        //[audioArray addObject:playerDic];
    }
    
    if (hunyinSysArray == nil) {
        hunyinSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"hunyinSys" forKey:@"name"];
        [playerDic setObject:hunyinSysArray forKey:@"value"];
        
        //[audioArray addObject:playerDic];
    }
    
    if (handToHandSysArray == nil) {
        handToHandSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"handToHandSys" forKey:@"name"];
        [playerDic setObject:handToHandSysArray forKey:@"value"];
        
        //[audioArray addObject:playerDic];
    }
    
    if (wirelessMeetingArray == nil) {
        wirelessMeetingArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"wirelessMeetingSys" forKey:@"name"];
        [playerDic setObject:wirelessMeetingArray forKey:@"value"];
        
        //[audioArray addObject:playerDic];
    }
    if (audioProcessArray == nil) {
        audioProcessArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"audioProcessSys" forKey:@"name"];
        [playerDic setObject:audioProcessArray forKey:@"value"];
        
        //[audioArray addObject:playerDic];
    }
    if (pvExpendArray == nil) {
        pvExpendArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"pvExpendSys" forKey:@"name"];
        [playerDic setObject:pvExpendArray forKey:@"value"];
        
        //[audioArray addObject:playerDic];
    }
    
    if ([name isEqualToString:@"8路电源管理"] || [name isEqualToString:@"16路电源管理"]) {
        EngineerElectronicSysConfigViewCtrl *ctrl = [[EngineerElectronicSysConfigViewCtrl alloc] init];
        if ([name isEqualToString:@"8路电源管理"]) {
            ctrl._number = 8;
            ctrl._electronicSysArray = electronic8SysArray;
        } else {
            ctrl._number = 16;
            ctrl._electronicSysArray = electronic16SysArray;
        }
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // player array
    if ([name isEqualToString:@"播放器"]) {
        EngineerPlayerSettingsViewCtrl *ctrl = [[EngineerPlayerSettingsViewCtrl alloc] init];
        ctrl._playerSysArray = playerSysArray;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    // wuxian array
    if ([name isEqualToString:@"无线麦"]) {
        EngineerWirlessYaoBaoViewCtrl *ctrl = [[EngineerWirlessYaoBaoViewCtrl alloc] init];
        ctrl._wirelessYaoBaoSysArray = wirelessYaobaoArray;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"混音系统"]) {
        EngineerHunYinSysViewController *ctrl = [[EngineerHunYinSysViewController alloc] init];
        ctrl._hunyinSysArray = hunyinSysArray;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    // wuxian array
    if ([name isEqualToString:@"有线会议麦"]) {
        EngineerHandtoHandViewCtrl *ctrl = [[EngineerHandtoHandViewCtrl alloc] init];
        ctrl._handToHandSysArray = handToHandSysArray;
        ctrl._number = 12;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    // wuxian array
    if ([name isEqualToString:@"无线会议麦"]) {
        EngineerWirelessMeetingViewCtrl *ctrl = [[EngineerWirelessMeetingViewCtrl alloc] init];
        ctrl._wirelessMeetingArray = wirelessMeetingArray;
        ctrl._number = 12;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"音频处理"]) {
        EngineerAudioProcessViewCtrl *ctrl = [[EngineerAudioProcessViewCtrl alloc] init];
        ctrl._audioProcessArray = audioProcessArray;
        ctrl._inputNumber=16;
        ctrl._outputNumber=16;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    // wuxian array
    if ([name isEqualToString:@"功放"]) {
        EngineerPVExpendViewCtrl *ctrl = [[EngineerPVExpendViewCtrl alloc] init];
        ctrl._pvExpendArray = pvExpendArray;
        ctrl._number=16;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

// if dataDic == nil, refresh scroll view
- (void) addComponentToEnd:(UIScrollView*) scrollView dataDic:(NSDictionary*)dataDic {
    
    NSMutableArray *dataArray = nil;
    if (scrollView == _audioScroll) {
        dataArray = [_curScenario objectForKey:@"audioArray"];
    } else if (scrollView == _videoScroll) {
        dataArray = [_curScenario objectForKey:@"videoArray"];
    } else {
        dataArray = [_curScenario objectForKey:@"envArray"];
    }
    
    if(dataDic)
        [dataArray addObject:dataDic];
    
    [[scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int x = audioStartX;
    for(int i = 0; i < [dataArray count]; i++)
    {
        NSDictionary *dic = [dataArray objectAtIndex:i];
        
        NSString *imageStr = [dic objectForKey:@"icon"];
        UIImage *roomImage = [UIImage imageNamed:imageStr];
        UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
        roomeImageView.tag = i;
        [scrollView addSubview:roomeImageView];
        roomeImageView.frame = CGRectMake(x, audioStartY, 77, 77);
        roomeImageView.userInteractionEnabled=YES;

        x+=77;
        x+=space;
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        [tapGesture setValue:[dic objectForKey:@"name"] forKey:@"name"];
        [roomeImageView addGestureRecognizer:tapGesture];

    }
    
    scrollView.contentSize = CGSizeMake(x+50, 160);
    
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
