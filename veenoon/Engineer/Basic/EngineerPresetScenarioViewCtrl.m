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

#import "EngineerScenarioSettingsViewCtrl.h"

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
    
    audioStartX = 0;
    space = 10;
    audioStartY = 50;
    
    ecp = [[ECPlusSelectView alloc]
                             initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                      64, 300, SCREEN_HEIGHT-114)];
    ecp.delegate = self;
    
    
    
    UIView *topbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topbar.backgroundColor = THEME_COLOR;
    
    
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
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView =  YES;
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
 
    [self.view addSubview:ecp];
    
    [self.view addSubview:topbar];
    [self.view addSubview:bottomBar];
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
    
    int idx = tag - baseTag*1000;
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
    
    NSMutableDictionary *data = [dataArray objectAtIndex:idx];
    NSString *name = [data objectForKey:@"name"];

    if ([name isEqualToString:@"8路电源管理"] || [name isEqualToString:@"16路电源管理"]) {
        EngineerElectronicSysConfigViewCtrl *ctrl = [[EngineerElectronicSysConfigViewCtrl alloc] init];
        if ([name isEqualToString:@"8路电源管理"]) {
            ctrl._number = 8;
            ctrl._electronicSysArray = nil;// [NSMutableArray array];
        } else {
            ctrl._number = 16;
            ctrl._electronicSysArray = nil;// [NSMutableArray array];
        }
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
    if(baseTag == 1)
    {
        
        // player array
        if ([name isEqualToString:@"播放器"]) {
            EngineerPlayerSettingsViewCtrl *ctrl = [[EngineerPlayerSettingsViewCtrl alloc] init];
            ctrl._playerSysArray = [NSMutableArray arrayWithObject:data];
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        // wuxian array
        if ([name isEqualToString:@"无线麦"]) {
            EngineerWirlessYaoBaoViewCtrl *ctrl = [[EngineerWirlessYaoBaoViewCtrl alloc] init];
            ctrl._wirelessYaoBaoSysArray = [NSMutableArray arrayWithObject:data];
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

// if dataDic == nil, refresh scroll view
- (void) addComponentToEnd:(UIScrollView*) scrollView dataDic:(NSDictionary*)dataDic {
    
    NSMutableArray *dataArray = nil;
    
    int tagBase = 0;
    int addTag = 100;
    if (scrollView == _audioScroll) {
        tagBase = 1000;
        addTag = 0;
        dataArray = [_curScenario objectForKey:@"audioArray"];
    } else if (scrollView == _videoScroll) {
        addTag = 1;
        tagBase = 2000;
        dataArray = [_curScenario objectForKey:@"videoArray"];
    } else {
        addTag = 2;
        tagBase = 3000;
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
        UIImage *eImg = [UIImage imageNamed:imageStr];
        
        UIButton *cellBtn = [[UIButton alloc] initWithFrame:CGRectMake(x,
                                                                       audioStartY,
                                                                       E_CELL_WIDTH,
                                                                       E_CELL_WIDTH)];
        cellBtn.tag = tagBase+i;
        
        [cellBtn setBackgroundImage:eImg forState:UIControlStateNormal];
        
        [scrollView addSubview:cellBtn];
        [cellBtn addTarget:self
                    action:@selector(buttonAction:)
          forControlEvents:UIControlEventTouchUpInside];
      
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

    
    
    scrollView.contentSize = CGSizeMake(x+E_CELL_WIDTH, 150);
    
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
