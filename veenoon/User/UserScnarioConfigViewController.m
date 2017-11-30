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
#import "UserMonitorListViewCtrl.h"


@interface UserScnarioConfigViewController () {
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

@implementation UserScnarioConfigViewController

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
    _botomView.backgroundColor = RGB(63, 58, 55);
    [self.view addSubview:_botomView];
    
    int left = 70;
    int rowGap = (SCREEN_WIDTH - left * 2)/5;
    int height = 0;
    _audioSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _audioSysBtn.frame = CGRectMake(left, height, 80, 132);
    [_audioSysBtn setImage:[UIImage imageNamed:@"audio_sys_n.png"] forState:UIControlStateNormal];
    [_audioSysBtn setImage:[UIImage imageNamed:@"audio_sys_s.png"] forState:UIControlStateHighlighted];
    [_audioSysBtn setTitle:@"音频系统" forState:UIControlStateNormal];
    [_audioSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_audioSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _audioSysBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_audioSysBtn setTitleEdgeInsets:UIEdgeInsetsMake(_audioSysBtn.imageView.frame.size.height+10,-80,-20,-20)];
    [_audioSysBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_audioSysBtn.titleLabel.bounds.size.height, 0)];
    [_audioSysBtn addTarget:self action:@selector(audioSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_audioSysBtn];
    
    
    _videoSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _videoSysBtn.frame = CGRectMake(left+rowGap, height, 80, 132);
    [_videoSysBtn setImage:[UIImage imageNamed:@"video_sys_n.png"] forState:UIControlStateNormal];
    [_videoSysBtn setImage:[UIImage imageNamed:@"video_sys_s.png"] forState:UIControlStateHighlighted];
    [_videoSysBtn setTitle:@"视频系统" forState:UIControlStateNormal];
    [_videoSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_videoSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _videoSysBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_videoSysBtn setTitleEdgeInsets:UIEdgeInsetsMake(_videoSysBtn.imageView.frame.size.height+10,-80,-20,-20)];
    [_videoSysBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_videoSysBtn.titleLabel.bounds.size.height, 0)];
    [_videoSysBtn addTarget:self action:@selector(videoSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_videoSysBtn];
    
    _lightSysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lightSysBtn.frame = CGRectMake(left+rowGap*2, height, 80, 132);
    [_lightSysBtn setImage:[UIImage imageNamed:@"light_sys_n.png"] forState:UIControlStateNormal];
    [_lightSysBtn setImage:[UIImage imageNamed:@"light_sys_s.png"] forState:UIControlStateHighlighted];
    [_lightSysBtn setTitle:@"灯光" forState:UIControlStateNormal];
    [_lightSysBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_lightSysBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _lightSysBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_lightSysBtn setTitleEdgeInsets:UIEdgeInsetsMake(_lightSysBtn.imageView.frame.size.height+10,-90,-20,-20)];
    [_lightSysBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_lightSysBtn.titleLabel.bounds.size.height, 0)];
    [_lightSysBtn addTarget:self action:@selector(lightSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_lightSysBtn];
    
    _airConditionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _airConditionBtn.frame = CGRectMake(left+rowGap*3, height, 80, 132);
    [_airConditionBtn setImage:[UIImage imageNamed:@"air_condition_n.png"] forState:UIControlStateNormal];
    [_airConditionBtn setImage:[UIImage imageNamed:@"air_condition_s.png"] forState:UIControlStateHighlighted];
    [_airConditionBtn setTitle:@"空调" forState:UIControlStateNormal];
    [_airConditionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_airConditionBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _airConditionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_airConditionBtn setTitleEdgeInsets:UIEdgeInsetsMake(_airConditionBtn.imageView.frame.size.height+10,-90,-20,-20)];
    [_airConditionBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_airConditionBtn.titleLabel.bounds.size.height, 0)];
    [_airConditionBtn addTarget:self action:@selector(airConditionSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_airConditionBtn];
    
    _electricAutoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _electricAutoBtn.frame = CGRectMake(left+rowGap*4, height, 80, 132);
    [_electricAutoBtn setImage:[UIImage imageNamed:@"electric_auto_n.png"] forState:UIControlStateNormal];
    [_electricAutoBtn setImage:[UIImage imageNamed:@"electric_auto_s.png"] forState:UIControlStateHighlighted];
    [_electricAutoBtn setTitle:@"电动马达" forState:UIControlStateNormal];
    [_electricAutoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_electricAutoBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _electricAutoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_electricAutoBtn setTitleEdgeInsets:UIEdgeInsetsMake(_electricAutoBtn.imageView.frame.size.height+10,-80,-20,-20)];
    [_electricAutoBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_electricAutoBtn.titleLabel.bounds.size.height, 0)];
    [_electricAutoBtn addTarget:self action:@selector(electricSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_electricAutoBtn];
    
    _newWindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _newWindBtn.frame = CGRectMake(left+rowGap*5, height, 80, 132);
    [_newWindBtn setImage:[UIImage imageNamed:@"new_wind_sys_n.png"] forState:UIControlStateNormal];
    [_newWindBtn setImage:[UIImage imageNamed:@"new_wind_sys_s.png"] forState:UIControlStateHighlighted];
    [_newWindBtn setTitle:@"新风" forState:UIControlStateNormal];
    [_newWindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_newWindBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _newWindBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_newWindBtn setTitleEdgeInsets:UIEdgeInsetsMake(_newWindBtn.imageView.frame.size.height+10,-90,-20,-20)];
    [_newWindBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_newWindBtn.titleLabel.bounds.size.height, 0)];
    [_newWindBtn addTarget:self action:@selector(newWindSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_newWindBtn];
    
    _floorWarmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _floorWarmBtn.frame = CGRectMake(left+rowGap*6, height, 80, 132);
    [_floorWarmBtn setImage:[UIImage imageNamed:@"floor_warm_n.png"] forState:UIControlStateNormal];
    [_floorWarmBtn setImage:[UIImage imageNamed:@"floor_warm_s.png"] forState:UIControlStateHighlighted];
    [_floorWarmBtn setTitle:@"地暖" forState:UIControlStateNormal];
    [_floorWarmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_floorWarmBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _floorWarmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_floorWarmBtn setTitleEdgeInsets:UIEdgeInsetsMake(_floorWarmBtn.imageView.frame.size.height+10,-90,-20,-20)];
    [_floorWarmBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_floorWarmBtn.titleLabel.bounds.size.height, -10)];
    [_floorWarmBtn addTarget:self action:@selector(floorWarmSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_floorWarmBtn];
    
    _airCleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _airCleanBtn.frame = CGRectMake(left+rowGap*7, height, 80, 132);
    [_airCleanBtn setImage:[UIImage imageNamed:@"air_clean_sys_n.png"] forState:UIControlStateNormal];
    [_airCleanBtn setImage:[UIImage imageNamed:@"air_clean_sys_s.png"] forState:UIControlStateHighlighted];
    [_airCleanBtn setTitle:@"空气净化" forState:UIControlStateNormal];
    [_airCleanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_airCleanBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _airCleanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_airCleanBtn setTitleEdgeInsets:UIEdgeInsetsMake(_airCleanBtn.imageView.frame.size.height+10,-95,-20,-30)];
    [_airCleanBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_airCleanBtn.titleLabel.bounds.size.height, -15)];
    [_airCleanBtn addTarget:self action:@selector(airCleanSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_airCleanBtn];
    
    _waterCleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _waterCleanBtn.frame = CGRectMake(left+rowGap*8, height, 80, 132);
    [_waterCleanBtn setImage:[UIImage imageNamed:@"clean_warter_n.png"] forState:UIControlStateNormal];
    [_waterCleanBtn setImage:[UIImage imageNamed:@"clean_warter_s.png"] forState:UIControlStateHighlighted];
    [_waterCleanBtn setTitle:@"净水" forState:UIControlStateNormal];
    [_waterCleanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_waterCleanBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _waterCleanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_waterCleanBtn setTitleEdgeInsets:UIEdgeInsetsMake(_waterCleanBtn.imageView.frame.size.height+10,-90,-20,-20)];
    [_waterCleanBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_waterCleanBtn.titleLabel.bounds.size.height, 0)];
    [_waterCleanBtn addTarget:self action:@selector(warterCleanSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_waterCleanBtn];
    
    _addWetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addWetBtn.frame = CGRectMake(left+rowGap*9, height, 80, 132);
    [_addWetBtn setImage:[UIImage imageNamed:@"add_wet_sys_n.png"] forState:UIControlStateNormal];
    [_addWetBtn setImage:[UIImage imageNamed:@"add_wet_sys_s.png"] forState:UIControlStateHighlighted];
    [_addWetBtn setTitle:@"加湿器" forState:UIControlStateNormal];
    [_addWetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addWetBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _addWetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_addWetBtn setTitleEdgeInsets:UIEdgeInsetsMake(_addWetBtn.imageView.frame.size.height+10,-85,-20,-30)];
    [_addWetBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_addWetBtn.titleLabel.bounds.size.height, -15)];
    [_addWetBtn addTarget:self action:@selector(addWetSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_addWetBtn];
    
    _doorAccessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _doorAccessBtn.frame = CGRectMake(left+rowGap*10, height, 80, 132);
    [_doorAccessBtn setImage:[UIImage imageNamed:@"door_access_n.png"] forState:UIControlStateNormal];
    [_doorAccessBtn setImage:[UIImage imageNamed:@"door_access_s.png"] forState:UIControlStateHighlighted];
    [_doorAccessBtn setTitle:@"门禁" forState:UIControlStateNormal];
    [_doorAccessBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_doorAccessBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _doorAccessBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_doorAccessBtn setTitleEdgeInsets:UIEdgeInsetsMake(_doorAccessBtn.imageView.frame.size.height+10,-90,-20,-20)];
    [_doorAccessBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_doorAccessBtn.titleLabel.bounds.size.height, 0)];
    [_doorAccessBtn addTarget:self action:@selector(doorAccessSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_doorAccessBtn];
    
    _monitorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _monitorBtn.frame = CGRectMake(left+rowGap*11, height, 80, 132);
    [_monitorBtn setImage:[UIImage imageNamed:@"monitor_sys_n.png"] forState:UIControlStateNormal];
    [_monitorBtn setImage:[UIImage imageNamed:@"monitor_sys_s.png"] forState:UIControlStateHighlighted];
    [_monitorBtn setTitle:@"监控" forState:UIControlStateNormal];
    [_monitorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_monitorBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _monitorBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_monitorBtn setTitleEdgeInsets:UIEdgeInsetsMake(_monitorBtn.imageView.frame.size.height+10,-95,-20,-30)];
    [_monitorBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_monitorBtn.titleLabel.bounds.size.height, 0)];
    [_monitorBtn addTarget:self action:@selector(monitorSysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_monitorBtn];
    
    _energyCollectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _energyCollectBtn.frame = CGRectMake(left+rowGap*12, height, 80, 132);
    [_energyCollectBtn setImage:[UIImage imageNamed:@"energy_collect_n.png"] forState:UIControlStateNormal];
    [_energyCollectBtn setImage:[UIImage imageNamed:@"energy_collect_s.png"] forState:UIControlStateHighlighted];
    [_energyCollectBtn setTitle:@"能耗统计" forState:UIControlStateNormal];
    [_energyCollectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_energyCollectBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _energyCollectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_energyCollectBtn setTitleEdgeInsets:UIEdgeInsetsMake(_energyCollectBtn.imageView.frame.size.height+10,-80,-20,-25)];
    [_energyCollectBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_energyCollectBtn.titleLabel.bounds.size.height, 0)];
    [_energyCollectBtn addTarget:self action:@selector(energySysAction:) forControlEvents:UIControlEventTouchUpInside];
    [_botomView addSubview:_energyCollectBtn];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(60, 45, 60, 40);
    [self.view addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"user_config_back_n.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"user_config_back_s.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self
                action:@selector(backAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(60, SCREEN_HEIGHT-264, 200, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:36];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = @"专业培训";
    
    UILabel* titleL2 = [[UILabel alloc] initWithFrame:CGRectMake(60, SCREEN_HEIGHT-209, 200, 40)];
    titleL2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL2];
    titleL2.font = [UIFont boldSystemFontOfSize:24];
    titleL2.textColor  = RGB(242, 148, 20);
    titleL2.text = @"Taining";
}

- (void) backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) energySysAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) monitorSysAction:(id)sender{
    UserMonitorListViewCtrl *controller = [[UserMonitorListViewCtrl alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
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
    UserVideoConfigViewCtrl *controller = [[UserVideoConfigViewCtrl alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
   // [self.navigationController popViewControllerAnimated:YES];
}

- (void) audioSysAction:(id)sender{
    UserAudioConfigViewController *controller = [[UserAudioConfigViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
