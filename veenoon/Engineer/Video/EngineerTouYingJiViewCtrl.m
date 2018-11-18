//
//  EngineerLuBoJiViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerTouYingJiViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "PlugsCtrlTitleHeader.h"
#import "VTouyingjiSet.h"
#import "BrandCategoryNoUtil.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "VProjectProxys.h"
#import "Utilities.h"

@interface EngineerTouYingJiViewCtrl () <CustomPickerViewDelegate>{
    UIButton *_powerOnBtn;
    UIButton *_powerOffBtn;
    
    BOOL isSettings;
    UIButton *okBtn;
    
    UIButton *_previousBtn;
}
@end

@implementation EngineerTouYingJiViewCtrl
@synthesize _touyingjiArray;
@synthesize _currentObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_touyingjiArray count]) {
        self._currentObj = [_touyingjiArray objectAtIndex:0];
    }
    [super showBasePluginName:self._currentObj chooseEnabled:NO];
    
    [super setTitleAndImage:@"video_corner_shipinbofang.png" withTitle:@"投影机"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon_black.png"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0,160, 50);
    [bottomBar addSubview:cancelBtn];
    [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
//    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"保存" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(settingsAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _powerOnBtn = [UIButton buttonWithColor:nil selColor:nil];
    _powerOnBtn.frame = CGRectMake(SCREEN_WIDTH-112, 70, 60, 60);
    _powerOnBtn.layer.cornerRadius = 5;
    _powerOnBtn.layer.borderWidth = 2;
    _powerOnBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _powerOnBtn.clipsToBounds = YES;
    [_powerOnBtn setImage:[UIImage imageNamed:@"engineer_lubo_n.png"] forState:UIControlStateNormal];
    [_powerOnBtn setImage:[UIImage imageNamed:@"engineer_lubo_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_powerOnBtn];
    
    NSString *powerOn = [self._currentObj._proxyObj getDevicePower];
    if ([@"ON" isEqualToString:powerOn]) {
        [_powerOnBtn setImage:[UIImage imageNamed:@"engineer_lubo_s.png"] forState:UIControlStateNormal];
    } else {
        [_powerOnBtn setImage:[UIImage imageNamed:@"engineer_lubo_n.png"] forState:UIControlStateNormal];
    }
    
    [_powerOnBtn addTarget:self
                 action:@selector(powerOnAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    int playerLeft = 265;
    int playerHeight = 100;
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(280+playerLeft, SCREEN_HEIGHT-625+playerHeight, 80, 40)];
    titleL.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:14];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = @"投影幕";
    
    UIButton *yingmuUpBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    yingmuUpBtn.frame = CGRectMake(280+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    yingmuUpBtn.layer.cornerRadius = 5;
    yingmuUpBtn.layer.borderWidth = 2;
    yingmuUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingmuUpBtn.clipsToBounds = YES;
    [yingmuUpBtn setImage:[UIImage imageNamed:@"engineer_up_n.png"] forState:UIControlStateNormal];
    [yingmuUpBtn setImage:[UIImage imageNamed:@"engineer_up_s.png"] forState:UIControlStateHighlighted];
//    [self.view addSubview:yingmuUpBtn];
    
    [yingmuUpBtn addTarget:self
                    action:@selector(yingmuUpAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yingmuStopBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    yingmuStopBtn.frame = CGRectMake(280+playerLeft, SCREEN_HEIGHT-485+playerHeight, 80, 80);
    yingmuStopBtn.layer.cornerRadius = 5;
    yingmuStopBtn.layer.borderWidth = 2;
    yingmuStopBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingmuStopBtn.clipsToBounds = YES;
    [yingmuStopBtn setTitle:@"停" forState:UIControlStateNormal];
    [yingmuStopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yingmuStopBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
//    [self.view addSubview:yingmuStopBtn];
    
    [yingmuStopBtn addTarget:self
                      action:@selector(yingmuStopAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *yingmuDownBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    yingmuDownBtn.frame = CGRectMake(280+playerLeft, SCREEN_HEIGHT-385+playerHeight, 80, 80);
    yingmuDownBtn.layer.cornerRadius = 5;
    yingmuDownBtn.layer.borderWidth = 2;
    yingmuDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingmuDownBtn.clipsToBounds = YES;
    [yingmuDownBtn setImage:[UIImage imageNamed:@"engineer_down_n.png"] forState:UIControlStateNormal];
    [yingmuDownBtn setImage:[UIImage imageNamed:@"engineer_down_s.png"] forState:UIControlStateHighlighted];
//    [self.view addSubview:yingmuDownBtn];
    
    [yingmuDownBtn addTarget:self
                    action:@selector(yingmuDownAction:)
          forControlEvents:UIControlEventTouchUpInside];
    playerLeft-=30;
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(455+playerLeft, SCREEN_HEIGHT-625+playerHeight, 80, 40)];
    titleL.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:14];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = @"投影机";
    
    UIButton *yingjiUpBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    yingjiUpBtn.frame = CGRectMake(455+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    yingjiUpBtn.layer.cornerRadius = 5;
    yingjiUpBtn.layer.borderWidth = 2;
    yingjiUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingjiUpBtn.clipsToBounds = YES;
    [yingjiUpBtn setImage:[UIImage imageNamed:@"engineer_up_n.png"] forState:UIControlStateNormal];
    [yingjiUpBtn setImage:[UIImage imageNamed:@"engineer_up_s.png"] forState:UIControlStateHighlighted];
//    [self.view addSubview:yingjiUpBtn];
    
    [yingjiUpBtn addTarget:self
                    action:@selector(yingjiUpAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yingjiStopBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    yingjiStopBtn.frame = CGRectMake(455+playerLeft, SCREEN_HEIGHT-485+playerHeight, 80, 80);
    yingjiStopBtn.layer.cornerRadius = 5;
    yingjiStopBtn.layer.borderWidth = 2;
    yingjiStopBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingjiStopBtn.clipsToBounds = YES;
    [yingjiStopBtn setTitle:@"停" forState:UIControlStateNormal];
    [yingjiStopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yingjiStopBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
//    [self.view addSubview:yingjiStopBtn];
    
    [yingjiStopBtn addTarget:self
                      action:@selector(yingjiStopAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yingjiDownBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    yingjiDownBtn.frame = CGRectMake(455+playerLeft, SCREEN_HEIGHT-385+playerHeight, 80, 80);
    yingjiDownBtn.layer.cornerRadius = 5;
    yingjiDownBtn.layer.borderWidth = 2;
    yingjiDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingjiDownBtn.clipsToBounds = YES;
    [yingjiDownBtn setImage:[UIImage imageNamed:@"engineer_down_n.png"] forState:UIControlStateNormal];
    [yingjiDownBtn setImage:[UIImage imageNamed:@"engineer_down_s.png"] forState:UIControlStateHighlighted];
//    [self.view addSubview:yingjiDownBtn];
    
    [yingjiDownBtn addTarget:self
                      action:@selector(yingjiDownAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hmi1Btn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    hmi1Btn.frame = CGRectMake(0,0, 80, 80);
    hmi1Btn.layer.cornerRadius = 5;
    hmi1Btn.layer.borderWidth = 2;
    hmi1Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    hmi1Btn.clipsToBounds = YES;
    [hmi1Btn setTitle:@"HDMI" forState:UIControlStateNormal];
    [hmi1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hmi1Btn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:hmi1Btn];
    
    [hmi1Btn addTarget:self
                      action:@selector(hdmiAction:)
            forControlEvents:UIControlEventTouchDown];
    
    UIButton *vgaBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    vgaBtn.frame = CGRectMake(0,0, 80, 80);
    vgaBtn.layer.cornerRadius = 5;
    vgaBtn.layer.borderWidth = 2;
    vgaBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    vgaBtn.clipsToBounds = YES;
    [vgaBtn setTitle:@"VGA" forState:UIControlStateNormal];
    [vgaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vgaBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:vgaBtn];
    
    [vgaBtn addTarget:self
                      action:@selector(vgaAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *usbBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    usbBtn.frame = CGRectMake(0,0, 80, 80);
    usbBtn.layer.cornerRadius = 5;
    usbBtn.layer.borderWidth = 2;
    usbBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    usbBtn.clipsToBounds = YES;
    [usbBtn setTitle:@"USB" forState:UIControlStateNormal];
    [usbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [usbBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:usbBtn];
    
    [usbBtn addTarget:self
                      action:@selector(usbAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *netBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
    netBtn.frame = CGRectMake(0,0, 80, 80);
    netBtn.layer.cornerRadius = 5;
    netBtn.layer.borderWidth = 2;
    netBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    netBtn.clipsToBounds = YES;
    [netBtn setTitle:@"网络" forState:UIControlStateNormal];
    [netBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [netBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    [self.view addSubview:netBtn];
    
    [netBtn addTarget:self
                      action:@selector(lanAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    hmi1Btn.center = CGPointMake(SCREEN_WIDTH/2 - 10-40, SCREEN_HEIGHT/2-10-40);
    vgaBtn.center = CGPointMake(SCREEN_WIDTH/2 + 10+40, SCREEN_HEIGHT/2-10-40);
    usbBtn.center = CGPointMake(SCREEN_WIDTH/2 - 10-40, SCREEN_HEIGHT/2+10+40);
    netBtn.center = CGPointMake(SCREEN_WIDTH/2 + 10+40, SCREEN_HEIGHT/2+10+40);
    
    [self getCurrentDeviceDriverProxys];
}

- (void) getCurrentDeviceDriverProxys{
    
    if(_currentObj == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerTouYingJiViewCtrl);
    
    RgsDriverObj *driver = _currentObj._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        /* 投影机 - 没有Proxy，直接访问Commands
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    
                    [block_self loadedCameraProxy:proxys];
                    
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
         */
        
        [[RegulusSDK sharedRegulusSDK] GetDriverCommands:driver.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
            if (result) {
                if ([commands count]) {
                    [block_self loadedProjectCommands:commands];
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }
#endif
}

- (void) loadedProjectCommands:(NSArray*)cmds{
    
    RgsDriverObj *driver = _currentObj._driver;
    
    id proxy = self._currentObj._proxyObj;
    
    VProjectProxys *vpro = nil;
    if(proxy && [proxy isKindOfClass:[VProjectProxys class]])
    {
        vpro = proxy;
    }
    else
    {
        vpro = [[VProjectProxys alloc] init];
    }

    vpro._deviceId = driver.m_id;
    [vpro checkRgsProxyCommandLoad:cmds];
    
    self._currentObj._proxyObj = vpro;
    //[_currentObj syncDriverIPProperty];
    [_currentObj syncDriverComs];
}


- (void) hdmiAction:(UIButton*)sender{
    
    VProjectProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceInput:@"HDMI"];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    if (_previousBtn) {
        [_previousBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previousBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
    
    _previousBtn = sender;
}
- (void) vgaAction:(UIButton*)sender{
    
    VProjectProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceInput:@"COMP"];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    if (_previousBtn) {
        [_previousBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previousBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
    
    _previousBtn = sender;
}
- (void) usbAction:(UIButton*)sender{
    
    VProjectProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceInput:@"USB"];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    if (_previousBtn) {
        [_previousBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previousBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
    
    _previousBtn = sender;
}
- (void) lanAction:(UIButton*)sender{
    
    VProjectProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceInput:@"LAN"];
    
    [sender setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
    [sender changeNormalColor:NEW_ER_BUTTON_BL_COLOR];
    
    if (_previousBtn) {
        [_previousBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previousBtn changeNormalColor:NEW_ER_BUTTON_GRAY_COLOR2];
    }
    
    _previousBtn = sender;
}

- (void) powerOnAction:(id)sender{
    
    id lastPowerTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPowerTime"];
    int nowTime = [[NSDate date] timeIntervalSince1970];
    if(lastPowerTime)
    {
        int span = nowTime - [lastPowerTime intValue];
        if(span < 300)
        {
            [Utilities showMessage:@"投影机保护中，请5分钟后尝试！" ctrl:self];
            
            return;
        }
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", nowTime]
                                              forKey:@"lastPowerTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    VProjectProxys *vcam = _currentObj._proxyObj;
    
    NSString *powerOn = [self._currentObj._proxyObj getDevicePower];
    if ([@"ON" isEqualToString:powerOn]) {
        [_powerOnBtn setImage:[UIImage imageNamed:@"engineer_lubo_n.png"] forState:UIControlStateNormal];
        [vcam controlDevicePower:@"OFF"];
    } else {
        [_powerOnBtn setImage:[UIImage imageNamed:@"engineer_lubo_s.png"] forState:UIControlStateNormal];
        [vcam controlDevicePower:@"ON"];
    }
}
- (void) powerOffAction:(id)sender{
    
    id lastPowerTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPowerTime"];
    int nowTime = [[NSDate date] timeIntervalSince1970];
    if(lastPowerTime)
    {
        int span = nowTime - [lastPowerTime intValue];
        if(span < 180)
        {
            [Utilities showMessage:@"投影机保护中，请3分钟后尝试！" ctrl:self];
            
            return;
        }
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", nowTime]
                                              forKey:@"lastPowerTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    _powerOnBtn.hidden = NO;
    _powerOffBtn.hidden = YES;
    
    VProjectProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDevicePower:@"OFF"];
}

- (void) yingjiDownAction:(id)sender{
    
}
- (void) yingmuDownAction:(id)sender{
    
}
- (void) yingjiStopAction:(id)sender{
    
}
- (void) yingmuStopAction:(id)sender{
    
}
- (void) yingmuUpAction:(id)sender{
    
}
- (void) yingjiUpAction:(id)sender{
    
}

- (void) settingsAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

