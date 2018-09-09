//
//  EngineerCameraViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserVideoCameraSettingsViewCtrl.h"
#import "UIButton+Color.h"

@interface UserVideoCameraSettingsViewCtrl () {
    
    UIButton *_numberBtn;
    
    UIButton *_volumnMinus;
    UIButton *_lastSing;
    UIButton *_playOrHold;
    UIButton *_nextSing;
    UIButton *_volumnAdd;
    
    BOOL isplay;
}
@end

@implementation UserVideoCameraSettingsViewCtrl
@synthesize _cameraSysArray;
@synthesize _number;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setTitleAndImage:@"video_corner_shexiangji.png" withTitle:video_camera_name];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"user_botom_Line.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    int playerLeft = -60;
    int playerHeight = 85;
    
    UIButton *minusBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    minusBtn.frame = CGRectMake(230+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    minusBtn.layer.cornerRadius = 5;
    minusBtn.layer.borderWidth = 2;
    minusBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    minusBtn.clipsToBounds = YES;
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.view addSubview:minusBtn];
    
    [minusBtn addTarget:self
                 action:@selector(minusAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    _numberBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    _numberBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    _numberBtn.layer.cornerRadius = 5;
    _numberBtn.layer.borderWidth = 2;
    _numberBtn.userInteractionEnabled=NO;
    _numberBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _numberBtn.clipsToBounds = YES;
    [_numberBtn setTitle:@"0" forState:UIControlStateNormal];
    [_numberBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [_numberBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    _numberBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:_numberBtn];
    
    UIButton *invokeBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    invokeBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    invokeBtn.layer.cornerRadius = 5;
    invokeBtn.layer.borderWidth = 2;
    invokeBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    invokeBtn.clipsToBounds = YES;
    [invokeBtn setTitle:@"调用" forState:UIControlStateNormal];
    [invokeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [invokeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.view addSubview:invokeBtn];
    
    [invokeBtn addTarget:self
                  action:@selector(invokeAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    addBtn.frame = CGRectMake(400+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    addBtn.layer.cornerRadius = 5;
    addBtn.layer.borderWidth = 2;
    addBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    addBtn.clipsToBounds = YES;
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.view addSubview:addBtn];
    
    [addBtn addTarget:self
               action:@selector(addAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *storeBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    storeBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-415+playerHeight, 80, 80);
    storeBtn.layer.cornerRadius = 5;
    storeBtn.layer.borderWidth = 2;
    storeBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    storeBtn.clipsToBounds = YES;
    [storeBtn setTitle:@"存储" forState:UIControlStateNormal];
    [storeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [storeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.view addSubview:storeBtn];
    
    [storeBtn addTarget:self
                 action:@selector(storeAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    playerLeft = 320;
    
    UIButton *tBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    tBtn.frame = CGRectMake(230+playerLeft, SCREEN_HEIGHT-500+playerHeight-85, 80, 80);
    tBtn.layer.cornerRadius = 5;
    tBtn.layer.borderWidth = 2;
    tBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    tBtn.clipsToBounds = YES;
    [tBtn setTitle:@"T" forState:UIControlStateNormal];
    [tBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.view addSubview:tBtn];
    
    [tBtn addTarget:self
             action:@selector(tAction:)
   forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *lastVideoUpBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    lastVideoUpBtn.frame = CGRectMake(230+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    lastVideoUpBtn.layer.cornerRadius = 5;
    lastVideoUpBtn.layer.borderWidth = 2;
    lastVideoUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    lastVideoUpBtn.clipsToBounds = YES;
    [lastVideoUpBtn setImage:[UIImage imageNamed:@"engineer_left_n.png"] forState:UIControlStateNormal];
    [lastVideoUpBtn setImage:[UIImage imageNamed:@"engineer_left_n.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:lastVideoUpBtn];
    
    [lastVideoUpBtn addTarget:self
                       action:@selector(lastSingAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okPlayerBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    okPlayerBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    okPlayerBtn.layer.cornerRadius = 5;
    okPlayerBtn.layer.borderWidth = 2;
    okPlayerBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    okPlayerBtn.clipsToBounds = YES;
    [okPlayerBtn setTitle:@"ok" forState:UIControlStateNormal];
    [okPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    okPlayerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:okPlayerBtn];
    
    [okPlayerBtn addTarget:self action:@selector(audioPlayHoldAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *wBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    wBtn.frame = CGRectMake(315+playerLeft+85, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    wBtn.layer.cornerRadius = 5;
    wBtn.layer.borderWidth = 2;
    wBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    wBtn.clipsToBounds = YES;
    [wBtn setTitle:@"W" forState:UIControlStateNormal];
    [wBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.view addSubview:wBtn];
    
    [wBtn addTarget:self
             action:@selector(wAction:)
   forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *volumnUpBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    volumnUpBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    volumnUpBtn.layer.cornerRadius = 5;
    volumnUpBtn.layer.borderWidth = 2;
    volumnUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    volumnUpBtn.clipsToBounds = YES;
    [volumnUpBtn setImage:[UIImage imageNamed:@"engineer_up_n.png"] forState:UIControlStateNormal];
    [volumnUpBtn setImage:[UIImage imageNamed:@"engineer_up_n.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:volumnUpBtn];
    
    [volumnUpBtn addTarget:self
                    action:@selector(volumnAddAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *zoomMinusBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    zoomMinusBtn.frame = CGRectMake(315+playerLeft+85, SCREEN_HEIGHT-415+playerHeight, 80, 80);
    zoomMinusBtn.layer.cornerRadius = 5;
    zoomMinusBtn.layer.borderWidth = 2;
    zoomMinusBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    zoomMinusBtn.clipsToBounds = YES;
    [zoomMinusBtn setImage:[UIImage imageNamed:@"engineer_zoom_minus_n.png"] forState:UIControlStateNormal];
    [zoomMinusBtn setImage:[UIImage imageNamed:@"engineer_zoom_minus_n.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:zoomMinusBtn];
    
    [zoomMinusBtn addTarget:self
                     action:@selector(zoomMinusAction:)
           forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *nextPlayBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    nextPlayBtn.frame = CGRectMake(400+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    nextPlayBtn.layer.cornerRadius = 5;
    nextPlayBtn.layer.borderWidth = 2;
    nextPlayBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    nextPlayBtn.clipsToBounds = YES;
    [nextPlayBtn setImage:[UIImage imageNamed:@"engineer_next_n.png"] forState:UIControlStateNormal];
    [nextPlayBtn setImage:[UIImage imageNamed:@"engineer_next_n.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:nextPlayBtn];
    
    [nextPlayBtn addTarget:self
                    action:@selector(nextSingAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *zoomAddBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    zoomAddBtn.frame = CGRectMake(315+playerLeft-85, SCREEN_HEIGHT-415+playerHeight, 80, 80);
    zoomAddBtn.layer.cornerRadius = 5;
    zoomAddBtn.layer.borderWidth = 2;
    zoomAddBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    zoomAddBtn.clipsToBounds = YES;
    [zoomAddBtn setImage:[UIImage imageNamed:@"engineer_zoom_add_n.png"] forState:UIControlStateNormal];
    [zoomAddBtn setImage:[UIImage imageNamed:@"engineer_zoom_add_n.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:zoomAddBtn];
    
    [zoomAddBtn addTarget:self
                   action:@selector(zoomAddAction:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *volumnDownBtn = [UIButton buttonWithColor:NEW_UR_BUTTON_GRAY_COLOR selColor:NEW_ER_BUTTON_SD_COLOR];
    volumnDownBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-415+playerHeight, 80, 80);
    volumnDownBtn.layer.cornerRadius = 5;
    volumnDownBtn.layer.borderWidth = 2;
    volumnDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    volumnDownBtn.clipsToBounds = YES;
    [volumnDownBtn setImage:[UIImage imageNamed:@"engineer_down_n.png"] forState:UIControlStateNormal];
    [volumnDownBtn setImage:[UIImage imageNamed:@"engineer_down_n.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:volumnDownBtn];
    
    [volumnDownBtn addTarget:self
                      action:@selector(volumnMinusAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
}
- (void) zoomMinusAction:(id)sender{
    
}
- (void) zoomAddAction:(id)sender{
    
}
- (void) wAction:(id)sender{
    
}
- (void) tAction:(id)sender{
    
}

- (void) nextSingAction:(id)sender{
    
}

- (void) audioPlayHoldAction:(id)sender{
    if (isplay) {
        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_r_hold.png"] forState:UIControlStateNormal];
        isplay = NO;
    } else {
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
- (void) addAction:(id)sender{
    NSString *currentValue = _numberBtn.titleLabel.text;
    int value = [currentValue intValue];
    
    value++;
    
    [_numberBtn setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
}

- (void) minusAction:(id)sender{
    NSString *currentValue = _numberBtn.titleLabel.text;
    int value = [currentValue intValue];
    if (value == 0) {
        return;
    }
    value--;
    
    [_numberBtn setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
}

- (void) storeAction:(id)sender{
    
}

- (void) invokeAction:(id)sender{
    
}
- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
