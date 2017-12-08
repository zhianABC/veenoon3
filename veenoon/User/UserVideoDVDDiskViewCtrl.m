//
//  UserVideoDVDDiskViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/11/30.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserVideoDVDDiskViewCtrl.h"
#import "UIButton+Color.h"

@interface UserVideoDVDDiskViewCtrl () {
    UIButton *_volumnMinus;
    UIButton *_lastSing;
    UIButton *_playOrHold;
    UIButton *_nextSing;
    UIButton *_volumnAdd;
    
    BOOL isplay;
}
@end

@implementation UserVideoDVDDiskViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 30, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
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
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 60);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *lastVideoUpBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    lastVideoUpBtn.frame = CGRectMake(430, SCREEN_HEIGHT-500, 80, 80);
    lastVideoUpBtn.layer.cornerRadius = 5;
    lastVideoUpBtn.layer.borderWidth = 2;
    lastVideoUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    lastVideoUpBtn.clipsToBounds = YES;
    [lastVideoUpBtn setImage:[UIImage imageNamed:@"user_video_play_left.png"] forState:UIControlStateNormal];
    [lastVideoUpBtn setImage:[UIImage imageNamed:@"user_video_play_left.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:lastVideoUpBtn];
    
    [lastVideoUpBtn addTarget:self
               action:@selector(lastVideoUpBtnAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okPlayerBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    okPlayerBtn.frame = CGRectMake(515, SCREEN_HEIGHT-500, 80, 80);
    okPlayerBtn.layer.cornerRadius = 5;
    okPlayerBtn.layer.borderWidth = 2;
    okPlayerBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    okPlayerBtn.clipsToBounds = YES;
    [okPlayerBtn setTitle:@"ok" forState:UIControlStateNormal];
    [okPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    okPlayerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:okPlayerBtn];
    
    [lastVideoUpBtn addTarget:self action:@selector(okPlayerAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *volumnUpBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    volumnUpBtn.frame = CGRectMake(515, SCREEN_HEIGHT-585, 80, 80);
    volumnUpBtn.layer.cornerRadius = 5;
    volumnUpBtn.layer.borderWidth = 2;
    volumnUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    volumnUpBtn.clipsToBounds = YES;
    [volumnUpBtn setImage:[UIImage imageNamed:@"user_video_play_up.png"] forState:UIControlStateNormal];
    [volumnUpBtn setImage:[UIImage imageNamed:@"user_video_play_up.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:volumnUpBtn];
    
    [volumnUpBtn addTarget:self
                       action:@selector(volumnUpAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextPlayBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    nextPlayBtn.frame = CGRectMake(600, SCREEN_HEIGHT-500, 80, 80);
    nextPlayBtn.layer.cornerRadius = 5;
    nextPlayBtn.layer.borderWidth = 2;
    nextPlayBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    nextPlayBtn.clipsToBounds = YES;
    [nextPlayBtn setImage:[UIImage imageNamed:@"user_video_play_next.png"] forState:UIControlStateNormal];
    [nextPlayBtn setImage:[UIImage imageNamed:@"user_video_play_next.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:nextPlayBtn];
    
    [nextPlayBtn addTarget:self
                    action:@selector(nextPlayBtnAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *volumnDownBtn = [UIButton buttonWithColor:RGB(46, 105, 106) selColor:RGB(242, 148, 20)];
    volumnDownBtn.frame = CGRectMake(515, SCREEN_HEIGHT-415, 80, 80);
    volumnDownBtn.layer.cornerRadius = 5;
    volumnDownBtn.layer.borderWidth = 2;
    volumnDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    volumnDownBtn.clipsToBounds = YES;
    [volumnDownBtn setImage:[UIImage imageNamed:@"user_video_play_down.png"] forState:UIControlStateNormal];
    [volumnDownBtn setImage:[UIImage imageNamed:@"user_video_play_down.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:volumnDownBtn];
    
    [volumnDownBtn addTarget:self
                    action:@selector(volumnDownAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    int height = SCREEN_HEIGHT - 250;
    int width = 40;
    
    _volumnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
    _volumnMinus.frame = CGRectMake(0, 0, width, width);
    _volumnMinus.center = CGPointMake(SCREEN_WIDTH/2 - 100, height);
    [_volumnMinus setImage:[UIImage imageNamed:@"audio_player_minus_n.png"] forState:UIControlStateNormal];
    [_volumnMinus setImage:[UIImage imageNamed:@"audio_player_minus_s.png"] forState:UIControlStateHighlighted];
    [_volumnMinus addTarget:self action:@selector(volumnDownAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_volumnMinus];
    
    _lastSing = [UIButton buttonWithType:UIButtonTypeCustom];
    _lastSing.frame = CGRectMake(0, 0, width, width);
    _lastSing.center = CGPointMake(SCREEN_WIDTH/2 - 50, height);
    [_lastSing setImage:[UIImage imageNamed:@"audio_player_last_n.png"] forState:UIControlStateNormal];
    [_lastSing setImage:[UIImage imageNamed:@"audio_player_last_s.png"] forState:UIControlStateHighlighted];
    [_lastSing addTarget:self action:@selector(lastVideoUpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lastSing];
    
    isplay = NO;
    _playOrHold = [UIButton buttonWithType:UIButtonTypeCustom];
    _playOrHold.frame = CGRectMake(0, 0, width, width);
    _playOrHold.center = CGPointMake(SCREEN_WIDTH/2, height);
    [_playOrHold setImage:[UIImage imageNamed:@"audio_player_hold.png"] forState:UIControlStateNormal];
    [_playOrHold setImage:[UIImage imageNamed:@"audio_player_play.png"] forState:UIControlStateHighlighted];
    [_playOrHold addTarget:self action:@selector(okPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playOrHold];
    
    _nextSing = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextSing.frame = CGRectMake(0, 0, width, width);
    _nextSing.center = CGPointMake(SCREEN_WIDTH/2 + 50, height);
    [_nextSing setImage:[UIImage imageNamed:@"audio_player_next_n.png"] forState:UIControlStateNormal];
    [_nextSing setImage:[UIImage imageNamed:@"audio_player_next_s.png"] forState:UIControlStateHighlighted];
    [_nextSing addTarget:self action:@selector(nextPlayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextSing];
    
    _volumnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    _volumnAdd.frame = CGRectMake(0, 0, width, width);
    _volumnAdd.center = CGPointMake(SCREEN_WIDTH/2 + 100, height);
    [_volumnAdd setImage:[UIImage imageNamed:@"audio_layer_next_n.png"] forState:UIControlStateNormal];
    [_volumnAdd setImage:[UIImage imageNamed:@"audio_layer_next_s.png"] forState:UIControlStateHighlighted];
    [_volumnAdd addTarget:self action:@selector(volumnUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_volumnAdd];
}
- (void) nextPlayBtnAction:(id)sender{
    
}
- (void) volumnDownAction:(id)sender{
    
}
- (void) volumnUpAction:(id)sender{
    
}
- (void) okPlayerAction:(id)sender{
    
}

- (void) lastVideoUpBtnAction:(id)sender{
    
}

- (void) okAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
