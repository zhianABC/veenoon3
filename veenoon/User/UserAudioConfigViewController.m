//
//  UserAudioConfigViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/23.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "UserAudioConfigViewController.h"
#import "UserAudioPlayerSettingsViewCtrl.h"
#import "UserWuXianHuaTongViewCtrl.h"
#import "UserHuiYinViewController.h"
#import "JSlideView.h"

@interface UserAudioConfigViewController () {
    UIButton *_cdPlayerBtn;
    UIButton *_sdPlayersBtn;
    UIButton *_usbPlayersBtn;
    UIButton *_wuxianPlayersBtn;
    UIButton *_hunyinPlayersBtn;
    UIButton *_youxianPlayer1Btn;
    UIButton *_youxianPlayer2Btn;
    UIButton *_youxianPlayer3Btn;
    
    JSlideView *_cdPlayerSlider;
    JSlideView *_sdPlayerSlider;
    JSlideView *_usbPlayerSlider;
    JSlideView *_wuxianPlayerSlider;
    JSlideView *_hunyinPlayerSlider;
    JSlideView *_youxianPlayerSlider;
    JSlideView *_youxianPlayerSlider2;
    JSlideView *_wuxianSysPlayerSlider;
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
    
    int sliderHeight = 550;
    int sliderLeftRight = 100;
    
    _cdPlayerSlider = [[JSlideView alloc]
               initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light.png"]
               frame:CGRectZero];
    [self.view addSubview:_cdPlayerSlider];
    [_cdPlayerSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _cdPlayerSlider.topEdge = 60;
    _cdPlayerSlider.bottomEdge = 55;
    _cdPlayerSlider.maxValue = 20;
    _cdPlayerSlider.minValue = -20;
    [_cdPlayerSlider resetScale];
    _cdPlayerSlider.center = CGPointMake(sliderLeftRight, sliderHeight);
    
    
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
    
    _sdPlayerSlider = [[JSlideView alloc]
                       initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light.png"]
                       frame:CGRectZero];
    [self.view addSubview:_sdPlayerSlider];
    [_sdPlayerSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _sdPlayerSlider.topEdge = 60;
    _sdPlayerSlider.bottomEdge = 55;
    _sdPlayerSlider.maxValue = 20;
    _sdPlayerSlider.minValue = -20;
    [_sdPlayerSlider resetScale];
    _sdPlayerSlider.center = CGPointMake(sliderLeftRight+rowGap, sliderHeight);
    
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
    
    _usbPlayerSlider = [[JSlideView alloc]
                       initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light.png"]
                       frame:CGRectZero];
    [self.view addSubview:_usbPlayerSlider];
    [_usbPlayerSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _usbPlayerSlider.topEdge = 60;
    _usbPlayerSlider.bottomEdge = 55;
    _usbPlayerSlider.maxValue = 20;
    _usbPlayerSlider.minValue = -20;
    [_usbPlayerSlider resetScale];
    _usbPlayerSlider.center = CGPointMake(sliderLeftRight+rowGap*2, sliderHeight);
    
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
    UILongPressGestureRecognizer *longPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed3:)];
    [_wuxianPlayersBtn addGestureRecognizer:longPress3];
    [self.view addSubview:_wuxianPlayersBtn];
    
    _wuxianPlayerSlider = [[JSlideView alloc]
                        initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light.png"]
                        frame:CGRectZero];
    [self.view addSubview:_wuxianPlayerSlider];
    [_wuxianPlayerSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _wuxianPlayerSlider.topEdge = 60;
    _wuxianPlayerSlider.bottomEdge = 55;
    _wuxianPlayerSlider.maxValue = 20;
    _wuxianPlayerSlider.minValue = -20;
    [_wuxianPlayerSlider resetScale];
    _wuxianPlayerSlider.center = CGPointMake(sliderLeftRight+rowGap*3, sliderHeight);
    
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
    UILongPressGestureRecognizer *longPress4 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed4:)];
    [_hunyinPlayersBtn addGestureRecognizer:longPress4];
    [self.view addSubview:_hunyinPlayersBtn];
    
    _hunyinPlayerSlider = [[JSlideView alloc]
                           initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light.png"]
                           frame:CGRectZero];
    [self.view addSubview:_hunyinPlayerSlider];
    [_hunyinPlayerSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _hunyinPlayerSlider.topEdge = 60;
    _hunyinPlayerSlider.bottomEdge = 55;
    _hunyinPlayerSlider.maxValue = 20;
    _hunyinPlayerSlider.minValue = -20;
    [_hunyinPlayerSlider resetScale];
    _hunyinPlayerSlider.center = CGPointMake(sliderLeftRight+rowGap*4, sliderHeight);
    
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
    
    _youxianPlayerSlider = [[JSlideView alloc]
                           initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light.png"]
                           frame:CGRectZero];
    [self.view addSubview:_youxianPlayerSlider];
    [_youxianPlayerSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _youxianPlayerSlider.topEdge = 60;
    _youxianPlayerSlider.bottomEdge = 55;
    _youxianPlayerSlider.maxValue = 20;
    _youxianPlayerSlider.minValue = -20;
    [_youxianPlayerSlider resetScale];
    _youxianPlayerSlider.center = CGPointMake(sliderLeftRight+rowGap*5, sliderHeight);
    
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
    
    _youxianPlayerSlider2 = [[JSlideView alloc]
                            initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light.png"]
                            frame:CGRectZero];
    [self.view addSubview:_youxianPlayerSlider2];
    [_youxianPlayerSlider2 setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _youxianPlayerSlider2.topEdge = 60;
    _youxianPlayerSlider2.bottomEdge = 55;
    _youxianPlayerSlider2.maxValue = 20;
    _youxianPlayerSlider2.minValue = -20;
    [_youxianPlayerSlider2 resetScale];
    _youxianPlayerSlider2.center = CGPointMake(sliderLeftRight+rowGap*6, sliderHeight);
    
    _youxianPlayer3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _youxianPlayer3Btn.frame = CGRectMake(leftRight+rowGap*7, height, width, width);
    [_youxianPlayer3Btn setImage:[UIImage imageNamed:@"youxianxitong_player_n.png"] forState:UIControlStateNormal];
    [_youxianPlayer3Btn setImage:[UIImage imageNamed:@"youxianxitong_player_s.png"] forState:UIControlStateHighlighted];
    [_youxianPlayer3Btn setTitle:@"无线系统" forState:UIControlStateNormal];
    [_youxianPlayer3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_youxianPlayer3Btn setTitleColor:RGB(230, 151, 50) forState:UIControlStateHighlighted];
    _youxianPlayer3Btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_youxianPlayer3Btn setTitleEdgeInsets:UIEdgeInsetsMake(_youxianPlayer3Btn.imageView.frame.size.height+10,-90,-20,20)];
    [_youxianPlayer3Btn setImageEdgeInsets:UIEdgeInsetsMake(-10.0,0.0,_youxianPlayer3Btn.titleLabel.bounds.size.height, 0)];
    [_youxianPlayer3Btn addTarget:self action:@selector(wuSysxianPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_youxianPlayer3Btn];
    
    _wuxianSysPlayerSlider = [[JSlideView alloc]
                             initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light.png"]
                             frame:CGRectZero];
    [self.view addSubview:_wuxianSysPlayerSlider];
    [_wuxianSysPlayerSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
    _wuxianSysPlayerSlider.topEdge = 60;
    _wuxianSysPlayerSlider.bottomEdge = 55;
    _wuxianSysPlayerSlider.maxValue = 20;
    _wuxianSysPlayerSlider.minValue = -20;
    [_wuxianSysPlayerSlider resetScale];
    _wuxianSysPlayerSlider.center = CGPointMake(sliderLeftRight+rowGap*7, sliderHeight);
    
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
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void) longPressed3:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        UserWuXianHuaTongViewCtrl *controller = [[UserWuXianHuaTongViewCtrl alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void) longPressed4:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        UserHuiYinViewController *controller = [[UserHuiYinViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void) wuSysxianPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_n.png"] forState:UIControlStateNormal];
    [_sdPlayersBtn setImage:[UIImage imageNamed:@"sd_player_n.png"] forState:UIControlStateNormal];
    [_usbPlayersBtn setImage:[UIImage imageNamed:@"usb_player_n.png"] forState:UIControlStateNormal];
    [_wuxianPlayersBtn setImage:[UIImage imageNamed:@"huatong_player_n.png"] forState:UIControlStateNormal];
    [_hunyinPlayersBtn setImage:[UIImage imageNamed:@"huiyinhuiyi_player_n.png"] forState:UIControlStateNormal];
}

- (void) youxianPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_n.png"] forState:UIControlStateNormal];
    [_sdPlayersBtn setImage:[UIImage imageNamed:@"sd_player_n.png"] forState:UIControlStateNormal];
    [_usbPlayersBtn setImage:[UIImage imageNamed:@"usb_player_n.png"] forState:UIControlStateNormal];
    [_wuxianPlayersBtn setImage:[UIImage imageNamed:@"huatong_player_n.png"] forState:UIControlStateNormal];
    [_hunyinPlayersBtn setImage:[UIImage imageNamed:@"huiyinhuiyi_player_n.png"] forState:UIControlStateNormal];
}

- (void) hunyinPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_n.png"] forState:UIControlStateNormal];
    [_sdPlayersBtn setImage:[UIImage imageNamed:@"sd_player_n.png"] forState:UIControlStateNormal];
    [_usbPlayersBtn setImage:[UIImage imageNamed:@"usb_player_n.png"] forState:UIControlStateNormal];
    [_wuxianPlayersBtn setImage:[UIImage imageNamed:@"huatong_player_n.png"] forState:UIControlStateNormal];
    [_hunyinPlayersBtn setImage:[UIImage imageNamed:@"huiyinhuiyi_player_s.png"] forState:UIControlStateNormal];
}

- (void) wuxianPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_n.png"] forState:UIControlStateNormal];
    [_sdPlayersBtn setImage:[UIImage imageNamed:@"sd_player_n.png"] forState:UIControlStateNormal];
    [_usbPlayersBtn setImage:[UIImage imageNamed:@"usb_player_n.png"] forState:UIControlStateNormal];
    [_wuxianPlayersBtn setImage:[UIImage imageNamed:@"huatong_player_s.png"] forState:UIControlStateNormal];
    [_hunyinPlayersBtn setImage:[UIImage imageNamed:@"huiyinhuiyi_player_n.png"] forState:UIControlStateNormal];
}

- (void) usbPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_n.png"] forState:UIControlStateNormal];
    [_sdPlayersBtn setImage:[UIImage imageNamed:@"sd_player_n.png"] forState:UIControlStateNormal];
    [_usbPlayersBtn setImage:[UIImage imageNamed:@"usb_player_s.png"] forState:UIControlStateNormal];
    [_wuxianPlayersBtn setImage:[UIImage imageNamed:@"huatong_player_n.png"] forState:UIControlStateNormal];
    [_hunyinPlayersBtn setImage:[UIImage imageNamed:@"huiyinhuiyi_player_n.png"] forState:UIControlStateNormal];
}

- (void) sdPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_n.png"] forState:UIControlStateNormal];
    [_sdPlayersBtn setImage:[UIImage imageNamed:@"sd_player_s.png"] forState:UIControlStateNormal];
    [_usbPlayersBtn setImage:[UIImage imageNamed:@"usb_player_n.png"] forState:UIControlStateNormal];
    [_wuxianPlayersBtn setImage:[UIImage imageNamed:@"huatong_player_n.png"] forState:UIControlStateNormal];
    [_hunyinPlayersBtn setImage:[UIImage imageNamed:@"huiyinhuiyi_player_n.png"] forState:UIControlStateNormal];
    
}

- (void) cdPlayerAction:(id)sender{
    [_cdPlayerBtn setImage:[UIImage imageNamed:@"cd_player_s.png"] forState:UIControlStateNormal];
    [_sdPlayersBtn setImage:[UIImage imageNamed:@"sd_player_n.png"] forState:UIControlStateNormal];
    [_usbPlayersBtn setImage:[UIImage imageNamed:@"usb_player_n.png"] forState:UIControlStateNormal];
    [_wuxianPlayersBtn setImage:[UIImage imageNamed:@"huatong_player_n.png"] forState:UIControlStateNormal];
    [_hunyinPlayersBtn setImage:[UIImage imageNamed:@"huiyinhuiyi_player_n.png"] forState:UIControlStateNormal];
}

@end
