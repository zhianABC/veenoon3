//
//  UserAudioPlayerSettingsViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/11/24.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "UserAudioPlayerSettingsViewCtrl.h"
#import "UIButton+Color.h"

@interface UserAudioPlayerSettingsViewCtrl () {
    UIButton *_volumnMinus;
    UIButton *_lastSing;
    UIButton *_playOrHold;
    UIButton *_nextSing;
    UIButton *_volumnAdd;
    
    UIImageView *playerIndicator;
    
    BOOL isplay;
    
    UIButton *_tanchuBtn;
    UIButton *_luboBtn;
}

@end

@implementation UserAudioPlayerSettingsViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.playerState == USBPlaer) {
        [super setTitleAndImage:@"user_corner_usb.png" withTitle:@"USB"];
    } else if (self.playerState == CDPlayer) {
        [super setTitleAndImage:@"user_corner_cd.png" withTitle:@"CD"];
    } else {
        [super setTitleAndImage:@"user_corner_sd.png" withTitle:@"SD"];
    }
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int height = SCREEN_HEIGHT - 150;
    int width = 80;
    
    _volumnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
    _volumnMinus.frame = CGRectMake(0, 0, width, width);
    _volumnMinus.center = CGPointMake(SCREEN_WIDTH/2 - 120, height);
    [_volumnMinus setImage:[UIImage imageNamed:@"audio_player_minus_n.png"] forState:UIControlStateNormal];
    [_volumnMinus setImage:[UIImage imageNamed:@"audio_player_minus_s.png"] forState:UIControlStateHighlighted];
    [_volumnMinus addTarget:self action:@selector(volumnMinusAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_volumnMinus];
    
    _lastSing = [UIButton buttonWithType:UIButtonTypeCustom];
    _lastSing.frame = CGRectMake(0, 0, width, width);
    _lastSing.center = CGPointMake(SCREEN_WIDTH/2 - 60, height);
    [_lastSing setImage:[UIImage imageNamed:@"audio_player_last_n.png"] forState:UIControlStateNormal];
    [_lastSing setImage:[UIImage imageNamed:@"audio_player_last_s.png"] forState:UIControlStateHighlighted];
    [_lastSing addTarget:self action:@selector(lastSingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lastSing];
    
    isplay = NO;
    _playOrHold = [UIButton buttonWithType:UIButtonTypeCustom];
    _playOrHold.frame = CGRectMake(0, 0, width, width);
    _playOrHold.center = CGPointMake(SCREEN_WIDTH/2, height);
    [_playOrHold setImage:[UIImage imageNamed:@"audio_player_hold.png"] forState:UIControlStateNormal];
    [_playOrHold setImage:[UIImage imageNamed:@"audio_player_play.png"] forState:UIControlStateHighlighted];
    [_playOrHold addTarget:self action:@selector(audioPlayHoldAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playOrHold];
    
    _nextSing = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextSing.frame = CGRectMake(0, 0, width, width);
    _nextSing.center = CGPointMake(SCREEN_WIDTH/2 + 60, height);
    [_nextSing setImage:[UIImage imageNamed:@"audio_player_next_n.png"] forState:UIControlStateNormal];
    [_nextSing setImage:[UIImage imageNamed:@"audio_player_next_s.png"] forState:UIControlStateHighlighted];
    [_nextSing addTarget:self action:@selector(nextSingAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextSing];
    
    _volumnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    _volumnAdd.frame = CGRectMake(0, 0, width, width);
    _volumnAdd.center = CGPointMake(SCREEN_WIDTH/2 + 120, height);
    [_volumnAdd setImage:[UIImage imageNamed:@"audio_layer_next_n.png"] forState:UIControlStateNormal];
    [_volumnAdd setImage:[UIImage imageNamed:@"audio_layer_next_s.png"] forState:UIControlStateHighlighted];
    [_volumnAdd addTarget:self action:@selector(volumnAddAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_volumnAdd];
    
    playerIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audio_player_title_s.png"]];
    [self.view addSubview:playerIndicator];
    playerIndicator.frame = CGRectMake(0, 0, 322, 322);
    playerIndicator.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 400);
    
    _luboBtn = [UIButton buttonWithColor:nil selColor:nil];
    _luboBtn.frame = CGRectMake(SCREEN_WIDTH-112, 70, 60, 60);
    _luboBtn.layer.cornerRadius = 5;
    _luboBtn.layer.borderWidth = 2;
    _luboBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _luboBtn.clipsToBounds = YES;
    [_luboBtn setImage:[UIImage imageNamed:@"engineer_lubo_n1.png"] forState:UIControlStateNormal];
    [_luboBtn setImage:[UIImage imageNamed:@"engineer_lubo_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_luboBtn];
    
    [_luboBtn addTarget:self
                 action:@selector(powerAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    
    _tanchuBtn = [UIButton buttonWithColor:nil selColor:nil];
    _tanchuBtn.frame = CGRectMake(SCREEN_WIDTH - 182, 70, 60, 60);
    _tanchuBtn.layer.cornerRadius = 5;
    _tanchuBtn.layer.borderWidth = 2;
    _tanchuBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _tanchuBtn.clipsToBounds = YES;
    [_tanchuBtn setImage:[UIImage imageNamed:@"engineer_tanchu_n1.png"] forState:UIControlStateNormal];
    [_tanchuBtn setImage:[UIImage imageNamed:@"engineer_tanchu_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_tanchuBtn];
    
    [_tanchuBtn addTarget:self
                   action:@selector(tanchuAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
}
- (void) powerAction:(id)sender{
    
}
- (void) tanchuAction:(id)sender{
    
}
- (void) nextSingAction:(id)sender{
    
}

- (void) audioPlayHoldAction:(id)sender{
    if (isplay) {
        [playerIndicator setImage:[UIImage imageNamed: @"audio_player_title_s.png"]];
        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_hold.png"] forState:UIControlStateNormal];
        isplay = NO;
    } else {
        [playerIndicator setImage:[UIImage imageNamed: @"audio_player_title_s.png"]];
        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_play.png"] forState:UIControlStateNormal];
        isplay = YES;
    }
}

- (void) lastSingAction:(id)sender{
    
}

- (void) volumnMinusAction:(id)sender{
    
}

- (void) volumnAddAction:(id)sender{
    
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
