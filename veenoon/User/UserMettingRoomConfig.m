//
//  UserMettingRoomConfig.m
//  veenoon
//
//  Created by 安志良 on 2017/11/22.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserMeetingRoomConfig.h"

@interface UserMeetingRoomConfig () {
    NSMutableDictionary *meetingRoomDic;
    
    UIButton *_trainingBtn;
    UIButton *_envirementControlBtn;
    UIButton *_guestBtn;
    UIButton *_envirementLightBtn;
    UIButton *_discussionBtn;
    UIButton *_leaveMeetingBtn;
}

@end

@implementation UserMeetingRoomConfig
@synthesize meetingRoomDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(60, SCREEN_HEIGHT -45, 60, 40);
    [self.view addSubview:backBtn];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [backBtn addTarget:self action:@selector(backAction:)
      forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 200, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:20];
    titleL.textColor  = [UIColor whiteColor];
    titleL.text = [meetingRoomDic objectForKey:@"roomname"];
    
    _trainingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _trainingBtn.frame = CGRectMake(SCREEN_WIDTH/2-481, 70, 481, 250);
    [_trainingBtn setImage:[UIImage imageNamed:@"user_training_n.png"] forState:UIControlStateNormal];
    [_trainingBtn setImage:[UIImage imageNamed:@"user_training_s.png"] forState:UIControlStateHighlighted];
    [_trainingBtn addTarget:self action:@selector(userTrainingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_trainingBtn];
    
    _envirementControlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _envirementControlBtn.frame = CGRectMake(SCREEN_WIDTH/2, 70, 481, 250);
    [_envirementControlBtn setImage:[UIImage imageNamed:@"envirement_control_n.png"] forState:UIControlStateNormal];
    [_envirementControlBtn setImage:[UIImage imageNamed:@"envirement_control_s.png"] forState:UIControlStateHighlighted];
    [_envirementControlBtn addTarget:self action:@selector(enviromentControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_envirementControlBtn];
    
    _guestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _guestBtn.frame = CGRectMake(SCREEN_WIDTH/2-481, 70+260, 481, 250);
    [_guestBtn setImage:[UIImage imageNamed:@"guest_reception_n.png"] forState:UIControlStateNormal];
    [_guestBtn setImage:[UIImage imageNamed:@"guest_reception_s.png"] forState:UIControlStateHighlighted];
    [_guestBtn addTarget:self action:@selector(gusetAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_guestBtn];
    
    _envirementLightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _envirementLightBtn.frame = CGRectMake(SCREEN_WIDTH/2, 70+260, 481, 250);
    [_envirementLightBtn setImage:[UIImage imageNamed:@"envirement_light_n.png"] forState:UIControlStateNormal];
    [_envirementLightBtn setImage:[UIImage imageNamed:@"envirement_light_s.png"] forState:UIControlStateHighlighted];
    [_envirementLightBtn addTarget:self action:@selector(envirementLightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_envirementLightBtn];
    
    _discussionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _discussionBtn.frame = CGRectMake(SCREEN_WIDTH/2, 70+260+260, 481, 250);
    [_discussionBtn setImage:[UIImage imageNamed:@"meeting_discuss_n.png"] forState:UIControlStateNormal];
    [_discussionBtn setImage:[UIImage imageNamed:@"meeting_discuss_n.png"] forState:UIControlStateHighlighted];
    [_discussionBtn addTarget:self action:@selector(discussMeetingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_discussionBtn];
    
    _leaveMeetingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leaveMeetingBtn.frame = CGRectMake(SCREEN_WIDTH/2+481, 70+260+260, 481, 250);
    [_leaveMeetingBtn setImage:[UIImage imageNamed:@"close_system_n.png"] forState:UIControlStateNormal];
    [_leaveMeetingBtn setImage:[UIImage imageNamed:@"close_system_s.png"] forState:UIControlStateHighlighted];
    [_leaveMeetingBtn addTarget:self action:@selector(leaveMeetingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leaveMeetingBtn];
    
    
}
- (void) leaveMeetingAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) discussMeetingAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) envirementLightAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) gusetAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) userTrainingAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) enviromentControlAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
