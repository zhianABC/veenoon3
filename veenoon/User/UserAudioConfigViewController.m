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
#import "UserYouXianViewController.h"
#import "UserDVDSettingsViewController.h"
#import "IconCenterTextButton.h"

#import "JSlideView.h"
#import "Scenario.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "AudioEProcessor.h"
#import "VAProcessorProxys.h"

@interface UserAudioConfigViewController () <JSlideViewDelegate> {
    
    
    IconCenterTextButton *_cdPlayerBtn;
    IconCenterTextButton *_sdPlayersBtn;
    IconCenterTextButton *_usbPlayersBtn;
    IconCenterTextButton *_dvdPlayerBtn;
    IconCenterTextButton *_wuxianhuatongBtn;
    IconCenterTextButton *_ejinhuiyi1Btn;
    IconCenterTextButton *_youxianPlayer2Btn;
    IconCenterTextButton *_youxianPlayer3Btn;
    
    JSlideView *_cdPlayerSlider;
    JSlideView *_sdPlayerSlider;
    JSlideView *_usbPlayerSlider;
    JSlideView *_wuxianPlayerSlider;
    JSlideView *_hunyinPlayerSlider;
    JSlideView *_youxianPlayerSlider;
    JSlideView *_youxianPlayerSlider2;
    JSlideView *_wuxianSysPlayerSlider;
    
    UIScrollView *_proxysView;
}

@property (nonatomic, strong) NSArray *_proxys;
@property (nonatomic, strong) NSMutableArray *_inputProxys;
@property (nonatomic, strong) NSMutableArray *_inputBtnArray;
@property (nonatomic, strong) AudioEProcessor *_curProcessor;

@end

@implementation UserAudioConfigViewController
@synthesize _curProcessor;
@synthesize _proxys;
@synthesize _inputProxys;
@synthesize _inputBtnArray;
@synthesize _scenario;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setTitleAndImage:@"user_corner_audio.png" withTitle:@"音频系统"];
    
    _proxysView = [[UIScrollView alloc]
                   initWithFrame:CGRectMake(0,
                                            64,
                                            SCREEN_WIDTH,
                                            SCREEN_HEIGHT-64-50)];
    [self.view addSubview:_proxysView];
    
    
    
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
    
    if([_scenario._AProcessorPlugs count])
    {
        self._curProcessor = [_scenario._AProcessorPlugs objectAtIndex:0];
    }
    
    [self getCurrentDeviceDriverProxys];
}



- (void) getCurrentDeviceDriverProxys{
    
    if(_curProcessor == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(UserAudioConfigViewController);
    
    RgsDriverObj *driver = _curProcessor._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    
                    block_self._proxys = proxys;
                    [block_self initChannels];
                }
            }
            else{
                [KVNProgress showErrorWithStatus:@"中控链接断开！"];
            }
        }];
    }
#endif
}

/*
 int leftRight = 50;
 int number = 8;
 int height = 150;
 int rowGap = 115;
 int width = (SCREEN_WIDTH - leftRight*2) / number;
 
 _cdPlayerBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight, height, width, width)];
 [_cdPlayerBtn buttonWithIcon:[UIImage imageNamed:@"cd_player_n.png"] selectedIcon:[UIImage imageNamed:@"cd_player_s.png"] text:@"CD播放器" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
 [_cdPlayerBtn addTarget:self action:@selector(cdPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
 UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
 [_cdPlayerBtn addGestureRecognizer:longPress0];
 [self.view addSubview:_cdPlayerBtn];
 
 int sliderHeight = 475;
 int sliderLeftRight = 110;
 
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
 
 
 _sdPlayersBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap, height, width, width)];
 [_sdPlayersBtn buttonWithIcon:[UIImage imageNamed:@"sd_player_n.png"] selectedIcon:[UIImage imageNamed:@"sd_player_s.png"] text:@"SD播放器" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
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
 
 _usbPlayersBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap*2, height, width, width)];
 [_usbPlayersBtn buttonWithIcon:[UIImage imageNamed:@"usb_player_n.png"] selectedIcon:[UIImage imageNamed:@"usb_player_s.png"] text:@"USB播放器" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
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
 
 _dvdPlayerBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap*3, height, width, width)];
 [_dvdPlayerBtn buttonWithIcon:[UIImage imageNamed:@"user_video_dvd_n.png"] selectedIcon:[UIImage imageNamed:@"user_video_dvd_s.png"] text:@"USB播放器" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
 [_dvdPlayerBtn addTarget:self action:@selector(dvdPlayerAction:) forControlEvents:UIControlEventTouchUpInside];
 UILongPressGestureRecognizer *longPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed3:)];
 [_dvdPlayerBtn addGestureRecognizer:longPress3];
 [self.view addSubview:_dvdPlayerBtn];
 
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
 
 _wuxianhuatongBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap*4, height, width, width)];
 [_wuxianhuatongBtn buttonWithIcon:[UIImage imageNamed:@"huatong_player_n.png"] selectedIcon:[UIImage imageNamed:@"huatong_player_s.png"] text:@"无线手持话筒" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
 [_wuxianhuatongBtn addTarget:self action:@selector(wuxianhuatongAction:) forControlEvents:UIControlEventTouchUpInside];
 UILongPressGestureRecognizer *longPress4 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed4:)];
 [_wuxianhuatongBtn addGestureRecognizer:longPress4];
 [self.view addSubview:_wuxianhuatongBtn];
 
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
 
 _ejinhuiyi1Btn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap*5, height, width, width)];
 [_ejinhuiyi1Btn buttonWithIcon:[UIImage imageNamed:@"huiyinhuiyi_player_n.png"] selectedIcon:[UIImage imageNamed:@"huiyinhuiyi_player_s.png"] text:@"鹅颈会议" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
 [_ejinhuiyi1Btn addTarget:self action:@selector(ejinAction:) forControlEvents:UIControlEventTouchUpInside];
 UILongPressGestureRecognizer *longPress5 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed5:)];
 [_ejinhuiyi1Btn addGestureRecognizer:longPress5];
 [self.view addSubview:_ejinhuiyi1Btn];
 
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
 
 _youxianPlayer2Btn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap*6, height, width, width)];
 [_youxianPlayer2Btn buttonWithIcon:[UIImage imageNamed:@"youxianxitong_player_n.png"] selectedIcon:[UIImage imageNamed:@"youxianxitong_player_s.png"] text:@"有线会议" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
 [_youxianPlayer2Btn addTarget:self action:@selector(youxianPlayer2Action:) forControlEvents:UIControlEventTouchUpInside];
 UILongPressGestureRecognizer *longPress6 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed6:)];
 [_youxianPlayer2Btn addGestureRecognizer:longPress6];
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
 
 _youxianPlayer3Btn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(leftRight+rowGap*7, height, width, width)];
 [_youxianPlayer3Btn buttonWithIcon:[UIImage imageNamed:@"youxianxitong_player_n.png"] selectedIcon:[UIImage imageNamed:@"youxianxitong_player_n.png"] text:@"无线会议" normalColor:[UIColor whiteColor] selColor:RGB(230, 151, 50)];
 [_youxianPlayer3Btn addTarget:self action:@selector(youxianPlayer3Action:) forControlEvents:UIControlEventTouchUpInside];
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
 */

- (void) initChannels{
    
    //清空一下
    self._inputProxys = [NSMutableArray array];
    self._inputBtnArray = [NSMutableArray array];
    
    [[_proxysView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
   

    for(RgsProxyObj *proxy in _proxys)
    {
        if([proxy.type isEqualToString:@"Audio In"])
        {
            VAProcessorProxys *vap = [[VAProcessorProxys alloc] init];
            vap._rgsProxyObj = proxy;
            [_inputProxys addObject:vap];
            
            [vap checkRgsProxyCommandLoad];
            
        }
    }
    
    _curProcessor._inAudioProxys = _inputProxys;
    
    
    int sliderHeight = 475-64;
    int sliderLeftRight = 110;
    
    
    for (int i = 0; i < [_inputProxys count]; i++) {
        
        VAProcessorProxys *vap = [_inputProxys objectAtIndex:i];
        
        NSDictionary *dic = [_curProcessor inputChannelAtIndex:i];
        if(dic)
        {
            [vap recoverWithDictionary:dic];
        }
        
        
        
        JSlideView *sliderCtrl = [[JSlideView alloc]
                           initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light.png"]
                           frame:CGRectZero];
        [_proxysView addSubview:sliderCtrl];
        [sliderCtrl setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
        sliderCtrl.topEdge = 60;
        sliderCtrl.bottomEdge = 55;
        sliderCtrl.maxValue = 12;
        sliderCtrl.minValue = -70;
        [sliderCtrl resetScale];
        sliderCtrl.delegate = self;
        sliderCtrl.data = vap;
        sliderCtrl.center = CGPointMake(sliderLeftRight, sliderHeight);
        
        sliderLeftRight+=110;
    
    }
    
    _proxysView.contentSize = CGSizeMake(sliderLeftRight+110, _proxysView.frame.size.height);
    
    //[_curProcessor syncDriverIPProperty];
}

- (void) didSliderValueChanged:(float)value object:(id)object{
    
    //float circleValue = -70 + (value * 82);
    
    JSlideView *jsl = object;
    if(jsl && [jsl isKindOfClass:[JSlideView class]])
    {
        id data = jsl.data;
        if([data isKindOfClass:[VAProcessorProxys class]])
        {
            //float circleValue = -70 + (value * 82);
            [(VAProcessorProxys*)data controlDeviceDb:value force:NO];
            
        }
    }
}


- (void) okAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        UserDVDSettingsViewController *controller = [[UserDVDSettingsViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void) longPressed4:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        UserWuXianHuaTongViewCtrl *controller = [[UserWuXianHuaTongViewCtrl alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void) longPressed6:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        UserYouXianViewController *controller = [[UserYouXianViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void) longPressed5:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        UserHuiYinViewController *controller = [[UserHuiYinViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void) youxianPlayer3Action:(id)sender{
    [_cdPlayerBtn setBtnHighlited:NO];
    [_sdPlayersBtn setBtnHighlited:NO];
    [_usbPlayersBtn setBtnHighlited:NO];
    [_dvdPlayerBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_ejinhuiyi1Btn setBtnHighlited:NO];
    [_youxianPlayer2Btn setBtnHighlited:NO];
    [_youxianPlayer3Btn setBtnHighlited:YES];
}
- (void) youxianPlayer2Action:(id)sender{
    [_cdPlayerBtn setBtnHighlited:NO];
    [_sdPlayersBtn setBtnHighlited:NO];
    [_usbPlayersBtn setBtnHighlited:NO];
    [_dvdPlayerBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_ejinhuiyi1Btn setBtnHighlited:NO];
    [_youxianPlayer2Btn setBtnHighlited:YES];
    [_youxianPlayer3Btn setBtnHighlited:NO];
}

- (void) ejinAction:(id)sender{
    [_cdPlayerBtn setBtnHighlited:NO];
    [_sdPlayersBtn setBtnHighlited:NO];
    [_usbPlayersBtn setBtnHighlited:NO];
    [_dvdPlayerBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_ejinhuiyi1Btn setBtnHighlited:YES];
    [_youxianPlayer2Btn setBtnHighlited:NO];
    [_youxianPlayer3Btn setBtnHighlited:NO];
}

- (void) wuxianhuatongAction:(id)sender{
    [_cdPlayerBtn setBtnHighlited:NO];
    [_sdPlayersBtn setBtnHighlited:NO];
    [_usbPlayersBtn setBtnHighlited:NO];
    [_dvdPlayerBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:YES];
    [_ejinhuiyi1Btn setBtnHighlited:NO];
    [_youxianPlayer2Btn setBtnHighlited:NO];
    [_youxianPlayer3Btn setBtnHighlited:NO];
}

- (void) dvdPlayerAction:(id)sender{
    [_cdPlayerBtn setBtnHighlited:NO];
    [_sdPlayersBtn setBtnHighlited:NO];
    [_usbPlayersBtn setBtnHighlited:NO];
    [_dvdPlayerBtn setBtnHighlited:YES];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_ejinhuiyi1Btn setBtnHighlited:NO];
    [_youxianPlayer2Btn setBtnHighlited:NO];
    [_youxianPlayer3Btn setBtnHighlited:NO];
}

- (void) usbPlayerAction:(id)sender{
    [_cdPlayerBtn setBtnHighlited:NO];
    [_sdPlayersBtn setBtnHighlited:NO];
    [_usbPlayersBtn setBtnHighlited:YES];
    [_dvdPlayerBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_ejinhuiyi1Btn setBtnHighlited:NO];
    [_youxianPlayer2Btn setBtnHighlited:NO];
    [_youxianPlayer3Btn setBtnHighlited:NO];
}

- (void) sdPlayerAction:(id)sender{
    [_cdPlayerBtn setBtnHighlited:NO];
    [_sdPlayersBtn setBtnHighlited:YES];
    [_usbPlayersBtn setBtnHighlited:NO];
    [_dvdPlayerBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_ejinhuiyi1Btn setBtnHighlited:NO];
    [_youxianPlayer2Btn setBtnHighlited:NO];
    [_youxianPlayer3Btn setBtnHighlited:NO];
    
}

- (void) cdPlayerAction:(id)sender{
    [_cdPlayerBtn setBtnHighlited:YES];
    [_sdPlayersBtn setBtnHighlited:NO];
    [_usbPlayersBtn setBtnHighlited:NO];
    [_dvdPlayerBtn setBtnHighlited:NO];
    [_wuxianhuatongBtn setBtnHighlited:NO];
    [_ejinhuiyi1Btn setBtnHighlited:NO];
    [_youxianPlayer2Btn setBtnHighlited:NO];
    [_youxianPlayer3Btn setBtnHighlited:NO];
}

@end
