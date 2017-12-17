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

@interface EngineerPresetScenarioViewCtrl<ECPlusSelectViewDelegate> () {
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
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 30, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(75, 163, 202);
    [self.view addSubview:line];
    
    int startX=50;
    int startY = 70;
    
    UILabel *portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY+5, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:20];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"设置场景";
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX+50, startY+100, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"音频管理";
    
    _audioScroll = [[UIScrollView alloc] init];
    [self.view addSubview:_audioScroll];
    _audioScroll.backgroundColor = [UIColor clearColor];
    _audioScroll.frame = CGRectMake(startX+50, startY+130, SCREEN_WIDTH-(startX+50)-300, 160);
    int audioCount = (int) [[_curScenario objectForKey:@"audioArray"] count] + 1;
    _audioScroll.contentSize = CGSizeMake(audioStartX + audioCount*(77+space), 160);
    _audioScroll.userInteractionEnabled=YES;
    int index = 0;
    for (id audioDic in [_curScenario objectForKey:@"audioArray"]) {
        int audioX = audioStartX + index*(77+space);
        
        NSString *imageStr = (NSString*)[audioDic objectForKey:@"icon"];
        UIImage *roomImage = [UIImage imageNamed:imageStr];
        UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
        roomeImageView.tag = index + 1000;
        [_audioScroll addSubview:roomeImageView];
        roomeImageView.frame = CGRectMake(audioX, audioStartY, 77, 77);
        roomeImageView.userInteractionEnabled=YES;
        index++;
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        [tapGesture setValue:[audioDic objectForKey:@"name"] forKey:@"name"];
        [roomeImageView addGestureRecognizer:tapGesture];
    }
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX+50, startY+300, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"视频管理";
    
    _videoScroll = [[UIScrollView alloc] init];
    [self.view addSubview:_videoScroll];
    _videoScroll.backgroundColor = [UIColor clearColor];
    _videoScroll.frame = CGRectMake(startX+50, startY+330, SCREEN_WIDTH-(startX+50)-300, 160);
    _videoScroll.userInteractionEnabled=YES;
    int videoCount = (int)[[_curScenario objectForKey:@"videoArray"] count] + 1;
    _videoScroll.contentSize = CGSizeMake(audioStartX + videoCount*(77+space), 160);
    int index2 = 0;
    for (id videoDic in [_curScenario objectForKey:@"videoArray"]) {
        int audioX = audioStartX + index2*(77+space);
        
        NSString *imageStr = [videoDic objectForKey:@"icon"];
        UIImage *roomImage = [UIImage imageNamed:imageStr];
        UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
        roomeImageView.tag = index2 + 2000;
        [_videoScroll addSubview:roomeImageView];
        roomeImageView.frame = CGRectMake(audioX, audioStartY, 77, 77);
        roomeImageView.userInteractionEnabled=YES;
        index2++;
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        [tapGesture setValue:[videoDic objectForKey:@"name"] forKey:@"name"];
        [roomeImageView addGestureRecognizer:tapGesture];
    }
    
    portDNSLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX+50, startY+500, SCREEN_WIDTH-80, 30)];
    portDNSLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:portDNSLabel];
    portDNSLabel.font = [UIFont boldSystemFontOfSize:16];
    portDNSLabel.textColor  = [UIColor whiteColor];
    portDNSLabel.text = @"环境管理";
    
    _envScroll = [[UIScrollView alloc] init];
    [self.view addSubview:_envScroll];
    _envScroll.backgroundColor = [UIColor clearColor];
    _envScroll.frame = CGRectMake(startX+50, startY+530, SCREEN_WIDTH-(startX+50)-300, 160);
    _envScroll.userInteractionEnabled=YES;
    int envCount = (int)[[_curScenario objectForKey:@"envArray"] count] + 1;
    _envScroll.contentSize = CGSizeMake(audioStartX + envCount*(77+space), 160);
    int index3 = 0;
    for (id envDic in [_curScenario objectForKey:@"audioArray"]) {
        int audioX = audioStartX + index3*(77+space);
        
        NSString *imageStr = [envDic objectForKey:@"icon"];
        UIImage *roomImage = [UIImage imageNamed:imageStr];
        UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
        roomeImageView.tag = index + 3000;
        [_envScroll addSubview:roomeImageView];
        roomeImageView.frame = CGRectMake(audioX, audioStartY, 77, 77);
        roomeImageView.userInteractionEnabled=YES;
        index3++;
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.cancelsTouchesInView =  NO;
        tapGesture.numberOfTapsRequired = 1;
        [tapGesture setValue:[envDic objectForKey:@"name"] forKey:@"name"];
        [roomeImageView addGestureRecognizer:tapGesture];
    }
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0,160, 60);
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
    NSMutableArray *audioArray = [_curScenario objectForKey:@"audioArray"];
    NSMutableArray *electronic8SysArray;
    NSMutableArray *electronic16SysArray;
    NSMutableArray *playerSysArray;
    for (id audioSys in audioArray) {
        if ([[audioSys objectForKey:@"name"] isEqualToString:@"electronic8Sys"]) {
            electronic8SysArray = [audioSys objectForKey:@"value"];
        }
        if ([[audioSys objectForKey:@"name"] isEqualToString:@"electronic16Sys"]) {
            electronic16SysArray = [audioSys objectForKey:@"value"];
        }
        if ([[audioSys objectForKey:@"name"] isEqualToString:@"playerArray"]) {
            playerSysArray = [audioSys objectForKey:@"value"];
        }
    }
    if (electronic8SysArray == nil) {
        electronic8SysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *electronic8SysDic = [[NSMutableDictionary alloc] init];
        [electronic8SysDic setObject:@"electronic8Sys" forKey:@"name"];
        [electronic8SysDic setObject:electronic8SysArray forKey:@"value"];
        
        [audioArray addObject:electronic8SysDic];
    }
    if (electronic16SysArray == nil) {
        electronic16SysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *electronic16SysDic = [[NSMutableDictionary alloc] init];
        [electronic16SysDic setObject:@"electronic16Sys" forKey:@"name"];
        [electronic16SysDic setObject:electronic16SysArray forKey:@"value"];
        
        [audioArray addObject:electronic16SysDic];
    }
    if (playerSysArray == nil) {
        playerSysArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *playerDic = [[NSMutableDictionary alloc] init];
        [playerDic setObject:@"playerSys" forKey:@"name"];
        [playerDic setObject:playerSysArray forKey:@"value"];
        
        [audioArray addObject:playerDic];
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
}

- (void) addComponentToEnd:(UIScrollView*) scrollView dataDic:(NSMutableDictionary*)dataDic {
    NSMutableArray *dataArray = nil;
    if (scrollView == _audioScroll) {
        dataArray = [_curScenario objectForKey:@"audioArray"];
    } else if (scrollView == _videoScroll) {
        dataArray = [_curScenario objectForKey:@"videoArray"];
    } else {
        dataArray = [_curScenario objectForKey:@"envArray"];
    }
    
    int count = (int) [dataArray count];
    
    int audioX = audioStartX + count*(77+space);
    
    NSString *imageStr = [dataDic objectForKey:@"icon"];
    UIImage *roomImage = [UIImage imageNamed:imageStr];
    UIImageView *roomeImageView = [[UIImageView alloc] initWithImage:roomImage];
    roomeImageView.tag = count;
    [scrollView addSubview:roomeImageView];
    roomeImageView.frame = CGRectMake(audioX, audioStartY, 77, 77);
    roomeImageView.userInteractionEnabled=YES;
    
    scrollView.contentSize = CGSizeMake(audioStartX + (count+1)*(77+space), 160);
    
    [dataArray addObject:dataDic];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView =  NO;
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture setValue:[dataDic objectForKey:@"name"] forKey:@"name"];
    [roomeImageView addGestureRecognizer:tapGesture];
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
