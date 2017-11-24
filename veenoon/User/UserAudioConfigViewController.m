//
//  UserAudioConfigViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/23.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "UserAudioConfigViewController.h"
#import "UserAudioPlayerSettingsViewCtrl.h"

@interface UserAudioConfigViewController () {
    UIButton *_cdPlayerBtn;
    UIButton *_sdPlayersBtn;
    UIButton *_usbPlayersBtn;
    UIButton *_wuxianPlayersBtn;
    UIButton *_hunyinPlayersBtn;
    UIButton *_youxianPlayer1Btn;
    UIButton *_youxianPlayer2Btn;
    UIButton *_youxianPlayer3Btn;
}

@end

@implementation UserAudioConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(63, 58, 55);
    
    UIImageView *titleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_view_title.png"]];
    [self.view addSubview:titleIcon];
    titleIcon.frame = CGRectMake(70, 30, 70, 10);
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1)];
    line.backgroundColor = RGB(83, 78, 75);
    [self.view addSubview:line];
    
    int leftRight = 70;
    int number = 8;
    int height = 200;
    int rowGap = 130;
    int width = (SCREEN_WIDTH - leftRight*2) / number;
    
    _cdPlayerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cdPlayerBtn.frame = CGRectMake(leftRight, height, width, width);
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_n.png"] forState:UIControlStateNormal];
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_s.png"] forState:UIControlStateHighlighted];
    [_cdPlayerBtn setTitle:@"CD播放器" forState:UIControlStateNormal];
    [_cdPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cdPlayerBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _cdPlayerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_cdPlayerBtn setTitleEdgeInsets:UIEdgeInsetsMake(_cdPlayerBtn.imageView.frame.size.height+10,-80,-20,40)];
    [_cdPlayerBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_cdPlayerBtn.titleLabel.bounds.size.height, 0)];
    [_cdPlayerBtn addTarget:self action:@selector(cdPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
    [_cdPlayerBtn addGestureRecognizer:longPress0];
    [self.view addSubview:_cdPlayerBtn];
    
    
    _sdPlayersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sdPlayersBtn.frame = CGRectMake(leftRight+rowGap, height, width, width);
    [_sdPlayersBtn setImage:[UIImage imageNamed:@"sd_player_n.png"] forState:UIControlStateNormal];
    [_sdPlayersBtn setImage:[UIImage imageNamed:@"sd_player_s.png"] forState:UIControlStateHighlighted];
    [_sdPlayersBtn setTitle:@"SD播放器" forState:UIControlStateNormal];
    [_sdPlayersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sdPlayersBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _sdPlayersBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_sdPlayersBtn setTitleEdgeInsets:UIEdgeInsetsMake(_sdPlayersBtn.imageView.frame.size.height+10,-80,-20,40)];
    [_sdPlayersBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_sdPlayersBtn.titleLabel.bounds.size.height, 0)];
    [_sdPlayersBtn addTarget:self action:@selector(sdPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed1:)];
    [_sdPlayersBtn addGestureRecognizer:longPress1];
    [self.view addSubview:_sdPlayersBtn];
    
    _usbPlayersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _usbPlayersBtn.frame = CGRectMake(leftRight+rowGap*2, height, width, width);
    [_usbPlayersBtn setImage:[UIImage imageNamed:@"usb_player_n.png"] forState:UIControlStateNormal];
    [_usbPlayersBtn setImage:[UIImage imageNamed:@"usb_player_s.png"] forState:UIControlStateHighlighted];
    [_usbPlayersBtn setTitle:@"USB播放器" forState:UIControlStateNormal];
    [_usbPlayersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_usbPlayersBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _usbPlayersBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_usbPlayersBtn setTitleEdgeInsets:UIEdgeInsetsMake(_usbPlayersBtn.imageView.frame.size.height+10,-90,-20,25)];
    [_usbPlayersBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_usbPlayersBtn.titleLabel.bounds.size.height, 0)];
    [_usbPlayersBtn addTarget:self action:@selector(usbPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed2:)];
    [_usbPlayersBtn addGestureRecognizer:longPress2];
    [self.view addSubview:_usbPlayersBtn];
    
    _wuxianPlayersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _wuxianPlayersBtn.frame = CGRectMake(leftRight+rowGap*3+10, height, width, width);
    [_wuxianPlayersBtn setImage:[UIImage imageNamed:@"huatong_player_n.png"] forState:UIControlStateNormal];
    [_wuxianPlayersBtn setImage:[UIImage imageNamed:@"huatong_player_s.png"] forState:UIControlStateHighlighted];
    [_wuxianPlayersBtn setTitle:@"无线手持话筒" forState:UIControlStateNormal];
    [_wuxianPlayersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_wuxianPlayersBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _wuxianPlayersBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_wuxianPlayersBtn setTitleEdgeInsets:UIEdgeInsetsMake(_wuxianPlayersBtn.imageView.frame.size.height+10,-90,-20,25)];
    [_wuxianPlayersBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_wuxianPlayersBtn.titleLabel.bounds.size.height, 0)];
    [_wuxianPlayersBtn addTarget:self action:@selector(wuxianPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_wuxianPlayersBtn];
    
    _hunyinPlayersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _hunyinPlayersBtn.frame = CGRectMake(leftRight+rowGap*4, height, width, width);
    [_hunyinPlayersBtn setImage:[UIImage imageNamed:@"huiyinhuiyi_player_n.png"] forState:UIControlStateNormal];
    [_hunyinPlayersBtn setImage:[UIImage imageNamed:@"huiyinhuiyi_player_s.png"] forState:UIControlStateHighlighted];
    [_hunyinPlayersBtn setTitle:@"混音会议" forState:UIControlStateNormal];
    [_hunyinPlayersBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_hunyinPlayersBtn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _hunyinPlayersBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_hunyinPlayersBtn setTitleEdgeInsets:UIEdgeInsetsMake(_hunyinPlayersBtn.imageView.frame.size.height+10,-80,-20,30)];
    [_hunyinPlayersBtn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_hunyinPlayersBtn.titleLabel.bounds.size.height, 0)];
    [_hunyinPlayersBtn addTarget:self action:@selector(hunyinPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hunyinPlayersBtn];
    
    _youxianPlayer1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _youxianPlayer1Btn.frame = CGRectMake(leftRight+rowGap*5, height, width, width);
    [_youxianPlayer1Btn setImage:[UIImage imageNamed:@"youxianxitong_player_n.png"] forState:UIControlStateNormal];
    [_youxianPlayer1Btn setImage:[UIImage imageNamed:@"youxianxitong_player_s.png"] forState:UIControlStateHighlighted];
    [_youxianPlayer1Btn setTitle:@"有线系统" forState:UIControlStateNormal];
    [_youxianPlayer1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_youxianPlayer1Btn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _youxianPlayer1Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_youxianPlayer1Btn setTitleEdgeInsets:UIEdgeInsetsMake(_youxianPlayer1Btn.imageView.frame.size.height+10,-90,-20,20)];
    [_youxianPlayer1Btn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_youxianPlayer1Btn.titleLabel.bounds.size.height, 0)];
    [_youxianPlayer1Btn addTarget:self action:@selector(youxianPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_youxianPlayer1Btn];
    
    _youxianPlayer2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _youxianPlayer2Btn.frame = CGRectMake(leftRight+rowGap*6, height, width, width);
    [_youxianPlayer2Btn setImage:[UIImage imageNamed:@"youxianxitong_player_n.png"] forState:UIControlStateNormal];
    [_youxianPlayer2Btn setImage:[UIImage imageNamed:@"youxianxitong_player_s.png"] forState:UIControlStateHighlighted];
    [_youxianPlayer2Btn setTitle:@"有线系统" forState:UIControlStateNormal];
    [_youxianPlayer2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_youxianPlayer2Btn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _youxianPlayer2Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_youxianPlayer2Btn setTitleEdgeInsets:UIEdgeInsetsMake(_youxianPlayer2Btn.imageView.frame.size.height+10,-90,-20,20)];
    [_youxianPlayer2Btn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_youxianPlayer2Btn.titleLabel.bounds.size.height, 0)];
    [_youxianPlayer2Btn addTarget:self action:@selector(youxianPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_youxianPlayer2Btn];
    
    _youxianPlayer3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _youxianPlayer3Btn.frame = CGRectMake(leftRight+rowGap*7, height, width, width);
    [_youxianPlayer3Btn setImage:[UIImage imageNamed:@"youxianxitong_player_n.png"] forState:UIControlStateNormal];
    [_youxianPlayer3Btn setImage:[UIImage imageNamed:@"youxianxitong_player_s.png"] forState:UIControlStateHighlighted];
    [_youxianPlayer3Btn setTitle:@"有线系统" forState:UIControlStateNormal];
    [_youxianPlayer3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_youxianPlayer3Btn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _youxianPlayer3Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_youxianPlayer3Btn setTitleEdgeInsets:UIEdgeInsetsMake(_youxianPlayer3Btn.imageView.frame.size.height+10,-90,-20,20)];
    [_youxianPlayer3Btn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_youxianPlayer3Btn.titleLabel.bounds.size.height, 0)];
    [_youxianPlayer3Btn addTarget:self action:@selector(youxianPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_youxianPlayer3Btn];
}

- (void) longPressed0:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        
        UserAudioPlayerSettingsViewCtrl *controller = [[UserAudioPlayerSettingsViewCtrl alloc] init];
        controller.playerState = CDPlayer;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void) longPressed1:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        
        UserAudioPlayerSettingsViewCtrl *controller = [[UserAudioPlayerSettingsViewCtrl alloc] init];
        controller.playerState = SDPlayer;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void) longPressed2:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        UserAudioPlayerSettingsViewCtrl *controller = [[UserAudioPlayerSettingsViewCtrl alloc] init];
        controller.playerState = USBPlaer;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void) youxianPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_n.png"] forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) hunyinPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_n.png"] forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) wuxianPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_n.png"] forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) usbPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_n.png"] forState:UIControlStateNormal];
}

- (void) sdPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_n.png"] forState:UIControlStateNormal];
    
}

- (void) cdPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_s.png"] forState:UIControlStateNormal];
}

@end
