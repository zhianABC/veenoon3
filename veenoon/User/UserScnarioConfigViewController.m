//
//  UserTrainingViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/22.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserScnarioConfigViewController.h"
#import "UserAudioConfigViewController.h"
#import "UserVideoConfigViewCtrl.h"
#import "UserLightConfigViewCtrl.h"
#import "UserElectronicAutoViewCtrl.h"
#import "UserAirConditionViewCtrl.h"
#import "UserNewWindViewCtrl.h"
#import "UserFloorWarmViewCtrl.h"
#import "UserAirCleanViewCtrl.h"
#import "UserAddWetViewCtrl.h"
#import "UserInfoCollectViewCtrl.h"
#import "UserDoorAccessViewCtrl.h"
#import "UserWaterCleanViewCtrl.h"
#import "UserMonitorSettingsViewCtrl.h"

#import "IconCenterTextButton.h"
#import "Scenario.h"

@interface UserScnarioConfigViewController () {
    IconCenterTextButton *_audioSysBtn;
    IconCenterTextButton *_videoSysBtn;
    IconCenterTextButton *_lightSysBtn;
    IconCenterTextButton *_airConditionBtn;
    IconCenterTextButton *_electricAutoBtn;
    IconCenterTextButton *_newWindBtn;
    IconCenterTextButton *_floorWarmBtn;
    IconCenterTextButton *_airCleanBtn;
    IconCenterTextButton *_waterCleanBtn;
    IconCenterTextButton *_addWetBtn;
    IconCenterTextButton *_doorAccessBtn;
    IconCenterTextButton *_monitorBtn;
    IconCenterTextButton *_energyCollectBtn;
    
    UIScrollView *_botomView;
}

@end

@implementation UserScnarioConfigViewController
@synthesize _data;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_training_bg.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-134, SCREEN_WIDTH, 2)];
    line2.backgroundColor = RGB(120, 116, 114);
    [self.view addSubview:line2];
    
    _botomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-132, SCREEN_WIDTH, 134)];
    _botomView.contentSize =  CGSizeMake(SCREEN_WIDTH*2 + 300, 132);
    _botomView.scrollEnabled=YES;
    _botomView.backgroundColor = USER_GRAY_COLOR;
    [self.view addSubview:_botomView];
    
    int left = 70;
    int rowGap = (SCREEN_WIDTH - left * 2)/5;
    int height = 10;
    _audioSysBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left, height, 80, 100)];
    [_audioSysBtn buttonWithIcon:[UIImage imageNamed:@"audio_sys_n.png"] selectedIcon:[UIImage imageNamed:@"audio_sys_s.png"] text:@"音频系统" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_audioSysBtn addTarget:self action:@selector(audioSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_audioSysBtn];
    
    
    _videoSysBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap, height, 80, 100)];
    [_videoSysBtn buttonWithIcon:[UIImage imageNamed:@"video_sys_n.png"] selectedIcon:[UIImage imageNamed:@"video_sys_s.png"] text:@"视频系统" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_videoSysBtn addTarget:self action:@selector(videoSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_videoSysBtn];
    
    _lightSysBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*2, height, 80, 100)];
    [_lightSysBtn buttonWithIcon:[UIImage imageNamed:@"light_sys_n.png"] selectedIcon:[UIImage imageNamed:@"light_sys_s.png"] text:@"灯光" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_lightSysBtn addTarget:self action:@selector(lightSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_lightSysBtn];
    
    
    _airConditionBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*3, height, 80, 100)];
    [_airConditionBtn buttonWithIcon:[UIImage imageNamed:@"air_condition_n.png"] selectedIcon:[UIImage imageNamed:@"air_condition_s.png"] text:@"空调" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_airConditionBtn addTarget:self action:@selector(airConditionSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_airConditionBtn];
    
    _electricAutoBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*4, height, 80, 100)];
    [_electricAutoBtn buttonWithIcon:[UIImage imageNamed:@"electric_auto_n.png"] selectedIcon:[UIImage imageNamed:@"electric_auto_s.png"] text:@"电动马达" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_electricAutoBtn addTarget:self action:@selector(electricSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_electricAutoBtn];
    
    
    _newWindBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*5, height, 80, 100)];
    [_newWindBtn buttonWithIcon:[UIImage imageNamed:@"new_wind_sys_n.png"] selectedIcon:[UIImage imageNamed:@"new_wind_sys_s.png"] text:@"新风" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_newWindBtn addTarget:self action:@selector(newWindSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_newWindBtn];
    
    _floorWarmBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*6, height, 80, 100)];
    [_floorWarmBtn buttonWithIcon:[UIImage imageNamed:@"floor_warm_n.png"] selectedIcon:[UIImage imageNamed:@"floor_warm_s.png"] text:@"地暖" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_floorWarmBtn addTarget:self action:@selector(floorWarmSysAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_botomView addSubview:_floorWarmBtn];
    
    _airCleanBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*6, height, 80, 100)];
    [_airCleanBtn buttonWithIcon:[UIImage imageNamed:@"air_clean_sys_n.png"] selectedIcon:[UIImage imageNamed:@"air_clean_sys_s.png"] text:@"空气净化" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_airCleanBtn addTarget:self action:@selector(airCleanSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_airCleanBtn];
    
    _addWetBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*7, height, 80, 100)];
    [_addWetBtn buttonWithIcon:[UIImage imageNamed:@"add_wet_sys_n.png"] selectedIcon:[UIImage imageNamed:@"add_wet_sys_s.png"] text:@"加湿器" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_addWetBtn addTarget:self action:@selector(addWetSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_addWetBtn];
    
    
    _monitorBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*8, height, 80, 100)];
    [_monitorBtn buttonWithIcon:[UIImage imageNamed:@"monitor_sys_n.png"] selectedIcon:[UIImage imageNamed:@"monitor_sys_s.png"] text:@"监控" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_monitorBtn addTarget:self action:@selector(monitorSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_monitorBtn];
    
    _energyCollectBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(left+rowGap*10, height, 80, 100)];
    [_energyCollectBtn buttonWithIcon:[UIImage imageNamed:@"energy_collect_n.png"] selectedIcon:[UIImage imageNamed:@"energy_collect_s.png"] text:@"能耗统计" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
    [_energyCollectBtn addTarget:self action:@selector(energySysAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_botomView addSubview:_energyCollectBtn];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(60, 45, 60, 40);
    [self.view addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"user_config_back_n.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"user_config_back_s.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self
                action:@selector(backAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(60, SCREEN_HEIGHT-264, SCREEN_WIDTH, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:36];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = [[_data senarioData] objectForKey:@"name"];
    
    UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(60, SCREEN_HEIGHT-209, SCREEN_WIDTH, 40)];
    titleL2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL2];
    titleL2.font = [UIFont boldSystemFontOfSize:24];
    titleL2.textColor  = [UIColor whiteColor];
    titleL2.alpha = 0.5;
    titleL2.text = [[_data senarioData] objectForKey:@"en_name"];
}

- (void) backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) energySysAction:(id)sender{
    UserInfoCollectViewCtrl *ctrl = [[UserInfoCollectViewCtrl alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) monitorSysAction:(id)sender{
    UserMonitorSettingsViewCtrl *controller = [[UserMonitorSettingsViewCtrl alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) doorAccessSysAction:(id)sender{
    UserDoorAccessViewCtrl *ctrl = [[UserDoorAccessViewCtrl alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) addWetSysAction:(id)sender{
    UserAddWetViewCtrl *ctrl = [[UserAddWetViewCtrl alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) warterCleanSysAction:(id)sender{
    UserWaterCleanViewCtrl *ctrl = [[UserWaterCleanViewCtrl alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) airCleanSysAction:(id)sender{
    UserAirCleanViewCtrl *ctrl = [[UserAirCleanViewCtrl alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) floorWarmSysAction:(id)sender{
    UserFloorWarmViewCtrl *ctrl = [[UserFloorWarmViewCtrl alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) newWindSysAction:(id)sender{
    UserNewWindViewCtrl *ctrl = [[UserNewWindViewCtrl alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) electricSysAction:(id)sender{
    UserElectronicAutoViewCtrl *ctrl = [[UserElectronicAutoViewCtrl alloc] init];
    ctrl._scenario = _data;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) airConditionSysAction:(id)sender{
    UserAirConditionViewCtrl *ctrl = [[UserAirConditionViewCtrl alloc] init];
    ctrl._scenario = _data;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) lightSysAction:(id)sender{
    UserLightConfigViewCtrl *ctrl = [[UserLightConfigViewCtrl alloc] init];
    ctrl._scenario = _data;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void) videoSysAction:(id)sender{
    UserVideoConfigViewCtrl *controller = [[UserVideoConfigViewCtrl alloc] init];
    controller._scenario = _data;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) audioSysAction:(id)sender{
    UserAudioConfigViewController *controller = [[UserAudioConfigViewController alloc] init];
    controller._scenario = _data;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
