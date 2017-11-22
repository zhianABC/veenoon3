//
//  UserTrainingViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/22.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserTrainingViewController.h"

@interface UserTrainingViewController () {
    UIButton *_audioSysBtn;
    UIButton *_videoSysBtn;
    UIButton *_lightSysBtn;
    UIButton *_airConditionBtn;
    UIButton *_electricAutoBtn;
    UIButton *_newWindBtn;
    UIButton *_floorWarmBtn;
    UIButton *_airCleanBtn;
    UIButton *_waterCleanBtn;
    UIButton *_addWetBtn;
    UIButton *_doorAccessBtn;
    UIButton *_monitorBtn;
    UIButton *_energyCollectBtn;
    
    UIScrollView *_botomView;
}

@end

@implementation UserTrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_training_bg.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:titleIcon];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-102, SCREEN_WIDTH, 2)];
    line2.backgroundColor = RGB(120, 116, 114);
    [self.view addSubview:line2];
    
    _botomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
    _botomView.contentSize =  CGSizeMake(SCREEN_WIDTH*2 + 300, 100);
    _botomView.scrollEnabled=YES;
    _botomView.backgroundColor = RGB(63, 58, 55);
    [self.view addSubview:_botomView];
    
    int left = 70;
    int rowGap = (SCREEN_WIDTH - left * 2)/5;
    int height = 20;
    _audioSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _audioSysBtn.frame = CGRectMake(left, height, 60, 60);
    [_audioSysBtn setImage:[UIImage imageNamed:@"audio_sys_n.png"] forState:UIControlStateNormal];
    [_audioSysBtn setImage:[UIImage imageNamed:@"audio_sys_s.png"] forState:UIControlStateHighlighted];
    [_audioSysBtn addTarget:self action:@selector(audioSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_audioSysBtn];
    
    _videoSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _videoSysBtn.frame = CGRectMake(left+rowGap, height, 50, 50);
    [_videoSysBtn setImage:[UIImage imageNamed:@"video_sys_n.png"] forState:UIControlStateNormal];
    [_videoSysBtn setImage:[UIImage imageNamed:@"video_sys_s.png"] forState:UIControlStateHighlighted];
    [_videoSysBtn addTarget:self action:@selector(videoSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_videoSysBtn];
    
    _lightSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lightSysBtn.frame = CGRectMake(left+rowGap*2, height, 50, 50);
    [_lightSysBtn setImage:[UIImage imageNamed:@"light_sys_n.png"] forState:UIControlStateNormal];
    [_lightSysBtn setImage:[UIImage imageNamed:@"light_sys_s.png"] forState:UIControlStateHighlighted];
    [_lightSysBtn addTarget:self action:@selector(lightSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_lightSysBtn];
    
    _airConditionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _airConditionBtn.frame = CGRectMake(left+rowGap*3, height, 50, 50);
    [_airConditionBtn setImage:[UIImage imageNamed:@"air_condition_n.png"] forState:UIControlStateNormal];
    [_airConditionBtn setImage:[UIImage imageNamed:@"air_condition_s.png"] forState:UIControlStateHighlighted];
    [_airConditionBtn addTarget:self action:@selector(airConditionSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_airConditionBtn];
    
    _electricAutoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _electricAutoBtn.frame = CGRectMake(left+rowGap*4, height, 50, 50);
    [_electricAutoBtn setImage:[UIImage imageNamed:@"electric_auto_n.png"] forState:UIControlStateNormal];
    [_electricAutoBtn setImage:[UIImage imageNamed:@"electric_auto_s.png"] forState:UIControlStateHighlighted];
    [_electricAutoBtn addTarget:self action:@selector(electricSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_electricAutoBtn];
    
    _newWindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _newWindBtn.frame = CGRectMake(left+rowGap*5, height, 50, 50);
    [_newWindBtn setImage:[UIImage imageNamed:@"new_wind_sys_n.png"] forState:UIControlStateNormal];
    [_newWindBtn setImage:[UIImage imageNamed:@"new_wind_sys_s.png"] forState:UIControlStateHighlighted];
    [_newWindBtn addTarget:self action:@selector(newWindSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_newWindBtn];
    
    _floorWarmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _floorWarmBtn.frame = CGRectMake(left+rowGap*6, height, 50, 50);
    [_floorWarmBtn setImage:[UIImage imageNamed:@"floor_warm_n.png"] forState:UIControlStateNormal];
    [_floorWarmBtn setImage:[UIImage imageNamed:@"floor_warm_s.png"] forState:UIControlStateHighlighted];
    [_floorWarmBtn addTarget:self action:@selector(floorWarmSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_floorWarmBtn];
    
    _airCleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _airCleanBtn.frame = CGRectMake(left+rowGap*7, height, 50, 50);
    [_airCleanBtn setImage:[UIImage imageNamed:@"air_clean_sys_n.png"] forState:UIControlStateNormal];
    [_airCleanBtn setImage:[UIImage imageNamed:@"air_clean_sys_s.png"] forState:UIControlStateHighlighted];
    [_airCleanBtn addTarget:self action:@selector(airCleanSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_airCleanBtn];
    
    _waterCleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _waterCleanBtn.frame = CGRectMake(left+rowGap*8, height, 50, 50);
    [_waterCleanBtn setImage:[UIImage imageNamed:@"clean_warter_n.png"] forState:UIControlStateNormal];
    [_waterCleanBtn setImage:[UIImage imageNamed:@"clean_warter_s.png"] forState:UIControlStateHighlighted];
    [_waterCleanBtn addTarget:self action:@selector(warterCleanSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_waterCleanBtn];
    
    _addWetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addWetBtn.frame = CGRectMake(left+rowGap*9, height, 50, 50);
    [_addWetBtn setImage:[UIImage imageNamed:@"add_wet_sys_n.png"] forState:UIControlStateNormal];
    [_addWetBtn setImage:[UIImage imageNamed:@"add_wet_sys_s.png"] forState:UIControlStateHighlighted];
    [_addWetBtn addTarget:self action:@selector(addWetSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_addWetBtn];
    
    _doorAccessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doorAccessBtn.frame = CGRectMake(left+rowGap*10, height, 50, 50);
    [_doorAccessBtn setImage:[UIImage imageNamed:@"door_access_n.png"] forState:UIControlStateNormal];
    [_doorAccessBtn setImage:[UIImage imageNamed:@"door_access_s.png"] forState:UIControlStateHighlighted];
    [_doorAccessBtn addTarget:self action:@selector(doorAccessSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_doorAccessBtn];
    
    _monitorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _monitorBtn.frame = CGRectMake(left+rowGap*11, height, 50, 50);
    [_monitorBtn setImage:[UIImage imageNamed:@"monitor_sys_n.png"] forState:UIControlStateNormal];
    [_monitorBtn setImage:[UIImage imageNamed:@"monitor_sys_s.png"] forState:UIControlStateHighlighted];
    [_monitorBtn addTarget:self action:@selector(monitorSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_monitorBtn];
    
    _energyCollectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _energyCollectBtn.frame = CGRectMake(left+rowGap*12, height, 50, 50);
    [_energyCollectBtn setImage:[UIImage imageNamed:@"energy_collect_n.png"] forState:UIControlStateNormal];
    [_energyCollectBtn setImage:[UIImage imageNamed:@"energy_collect_s.png"] forState:UIControlStateHighlighted];
    [_energyCollectBtn addTarget:self action:@selector(energySysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_energyCollectBtn];
}

- (void) energySysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) monitorSysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) doorAccessSysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addWetSysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) warterCleanSysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) airCleanSysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) floorWarmSysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) newWindSysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) electricSysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) airConditionSysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) lightSysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) videoSysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) audioSysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
