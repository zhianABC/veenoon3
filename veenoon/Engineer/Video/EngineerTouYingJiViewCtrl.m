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

@interface EngineerTouYingJiViewCtrl () <CustomPickerViewDelegate>{
    PlugsCtrlTitleHeader *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    UIButton *_powerOnBtn;
    UIButton *_powerOffBtn;
    
    BOOL isSettings;
    UIButton *okBtn;
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
    
    [super setTitleAndImage:@"video_corner_shipinbofang.png" withTitle:@"投影机"];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
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
    
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(settingsAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _selectSysBtn = [[PlugsCtrlTitleHeader alloc] initWithFrame:CGRectMake(50, 100, 80, 30)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    if (_currentObj) {
        NSString *nameStr = [BrandCategoryNoUtil generatePickerValue:_currentObj._brand withCategory:_currentObj._type withNo:_currentObj._deviceno];
        [_selectSysBtn setShowText:nameStr];
    }
    
    _powerOnBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    _powerOnBtn.frame = CGRectMake(70, SCREEN_HEIGHT-140, 60, 60);
    _powerOnBtn.layer.cornerRadius = 5;
    _powerOnBtn.layer.borderWidth = 2;
    _powerOnBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _powerOnBtn.clipsToBounds = YES;
    [_powerOnBtn setImage:[UIImage imageNamed:@"engineer_lubo_n.png"] forState:UIControlStateNormal];
    [_powerOnBtn setImage:[UIImage imageNamed:@"engineer_lubo_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_powerOnBtn];
    
    [_powerOnBtn addTarget:self
                 action:@selector(powerOnAction:)
       forControlEvents:UIControlEventTouchUpInside];
    
    _powerOffBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    _powerOffBtn.frame = _powerOnBtn.frame;
    _powerOffBtn.layer.cornerRadius = 5;
    _powerOffBtn.layer.borderWidth = 2;
    _powerOffBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _powerOffBtn.clipsToBounds = YES;
    [_powerOffBtn setImage:[UIImage imageNamed:@"engineer_lubo_s.png"] forState:UIControlStateNormal];
    [_powerOffBtn setImage:[UIImage imageNamed:@"engineer_lubo_n.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:_powerOffBtn];
    
    [_powerOffBtn addTarget:self
                    action:@selector(powerOffAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    _powerOffBtn.hidden = YES;
    
    
    
    int playerLeft = 215;
    int playerHeight = 60;
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(280+playerLeft, SCREEN_HEIGHT-625+playerHeight, 80, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:14];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = @"投影幕";
    
    UIButton *yingmuUpBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    yingmuUpBtn.frame = CGRectMake(280+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    yingmuUpBtn.layer.cornerRadius = 5;
    yingmuUpBtn.layer.borderWidth = 2;
    yingmuUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingmuUpBtn.clipsToBounds = YES;
    [yingmuUpBtn setImage:[UIImage imageNamed:@"engineer_up_n.png"] forState:UIControlStateNormal];
    [yingmuUpBtn setImage:[UIImage imageNamed:@"engineer_up_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:yingmuUpBtn];
    
    [yingmuUpBtn addTarget:self
                    action:@selector(yingmuUpAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yingmuStopBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    yingmuStopBtn.frame = CGRectMake(280+playerLeft, SCREEN_HEIGHT-485+playerHeight, 80, 80);
    yingmuStopBtn.layer.cornerRadius = 5;
    yingmuStopBtn.layer.borderWidth = 2;
    yingmuStopBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingmuStopBtn.clipsToBounds = YES;
    [yingmuStopBtn setTitle:@"停" forState:UIControlStateNormal];
    [yingmuStopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yingmuStopBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    [self.view addSubview:yingmuStopBtn];
    
    [yingmuStopBtn addTarget:self
                      action:@selector(yingmuStopAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *yingmuDownBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    yingmuDownBtn.frame = CGRectMake(280+playerLeft, SCREEN_HEIGHT-385+playerHeight, 80, 80);
    yingmuDownBtn.layer.cornerRadius = 5;
    yingmuDownBtn.layer.borderWidth = 2;
    yingmuDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingmuDownBtn.clipsToBounds = YES;
    [yingmuDownBtn setImage:[UIImage imageNamed:@"engineer_down_n.png"] forState:UIControlStateNormal];
    [yingmuDownBtn setImage:[UIImage imageNamed:@"engineer_down_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:yingmuDownBtn];
    
    [yingmuDownBtn addTarget:self
                    action:@selector(yingmuDownAction:)
          forControlEvents:UIControlEventTouchUpInside];
    playerLeft-=30;
    
    titleL = [[UILabel alloc] initWithFrame:CGRectMake(455+playerLeft, SCREEN_HEIGHT-625+playerHeight, 80, 40)];
    titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleL];
    titleL.font = [UIFont boldSystemFontOfSize:14];
    titleL.textColor  = [UIColor whiteColor];
    titleL.textAlignment=NSTextAlignmentCenter;
    titleL.text = @"投影机";
    
    UIButton *yingjiUpBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    yingjiUpBtn.frame = CGRectMake(455+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    yingjiUpBtn.layer.cornerRadius = 5;
    yingjiUpBtn.layer.borderWidth = 2;
    yingjiUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingjiUpBtn.clipsToBounds = YES;
    [yingjiUpBtn setImage:[UIImage imageNamed:@"engineer_up_n.png"] forState:UIControlStateNormal];
    [yingjiUpBtn setImage:[UIImage imageNamed:@"engineer_up_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:yingjiUpBtn];
    
    [yingjiUpBtn addTarget:self
                    action:@selector(yingjiUpAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yingjiStopBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    yingjiStopBtn.frame = CGRectMake(455+playerLeft, SCREEN_HEIGHT-485+playerHeight, 80, 80);
    yingjiStopBtn.layer.cornerRadius = 5;
    yingjiStopBtn.layer.borderWidth = 2;
    yingjiStopBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingjiStopBtn.clipsToBounds = YES;
    [yingjiStopBtn setTitle:@"停" forState:UIControlStateNormal];
    [yingjiStopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yingjiStopBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    [self.view addSubview:yingjiStopBtn];
    
    [yingjiStopBtn addTarget:self
                      action:@selector(yingjiStopAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yingjiDownBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    yingjiDownBtn.frame = CGRectMake(455+playerLeft, SCREEN_HEIGHT-385+playerHeight, 80, 80);
    yingjiDownBtn.layer.cornerRadius = 5;
    yingjiDownBtn.layer.borderWidth = 2;
    yingjiDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    yingjiDownBtn.clipsToBounds = YES;
    [yingjiDownBtn setImage:[UIImage imageNamed:@"engineer_down_n.png"] forState:UIControlStateNormal];
    [yingjiDownBtn setImage:[UIImage imageNamed:@"engineer_down_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:yingjiDownBtn];
    
    [yingjiDownBtn addTarget:self
                      action:@selector(yingjiDownAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    playerLeft = 15;
    playerHeight=-40;
    
    UIButton *hmi1Btn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    hmi1Btn.frame = CGRectMake(155+playerLeft, SCREEN_HEIGHT-435+playerHeight, 80, 80);
    hmi1Btn.layer.cornerRadius = 5;
    hmi1Btn.layer.borderWidth = 2;
    hmi1Btn.layer.borderColor = [UIColor clearColor].CGColor;;
    hmi1Btn.clipsToBounds = YES;
    [hmi1Btn setTitle:@"HDMI" forState:UIControlStateNormal];
    [hmi1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hmi1Btn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    [self.view addSubview:hmi1Btn];
    
    [hmi1Btn addTarget:self
                      action:@selector(hdmiAction:)
            forControlEvents:UIControlEventTouchDown];
    
    UIButton *vgaBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    vgaBtn.frame = CGRectMake(255+playerLeft, SCREEN_HEIGHT-435+playerHeight, 80, 80);
    vgaBtn.layer.cornerRadius = 5;
    vgaBtn.layer.borderWidth = 2;
    vgaBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    vgaBtn.clipsToBounds = YES;
    [vgaBtn setTitle:@"VGA" forState:UIControlStateNormal];
    [vgaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vgaBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    [self.view addSubview:vgaBtn];
    
    [vgaBtn addTarget:self
                      action:@selector(vgaAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *usbBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    usbBtn.frame = CGRectMake(155+playerLeft, SCREEN_HEIGHT-335+playerHeight, 80, 80);
    usbBtn.layer.cornerRadius = 5;
    usbBtn.layer.borderWidth = 2;
    usbBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    usbBtn.clipsToBounds = YES;
    [usbBtn setTitle:@"USB" forState:UIControlStateNormal];
    [usbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [usbBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    [self.view addSubview:usbBtn];
    
    [usbBtn addTarget:self
                      action:@selector(usbAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *netBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    netBtn.frame = CGRectMake(255+playerLeft, SCREEN_HEIGHT-335+playerHeight, 80, 80);
    netBtn.layer.cornerRadius = 5;
    netBtn.layer.borderWidth = 2;
    netBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    netBtn.clipsToBounds = YES;
    [netBtn setTitle:@"网络" forState:UIControlStateNormal];
    [netBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [netBtn setTitleColor:RGB(242, 148, 20) forState:UIControlStateHighlighted];
    [self.view addSubview:netBtn];
    
    [netBtn addTarget:self
                      action:@selector(lanAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
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
                [KVNProgress showErrorWithStatus:@"中控链接断开！"];
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
                [KVNProgress showErrorWithStatus:@"中控链接断开！"];
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
    
    if([_currentObj._localSavedCommands count])
    {
        NSDictionary *local = [_currentObj._localSavedCommands objectAtIndex:0];
        [vpro recoverWithDictionary:local];
    }
    
    self._currentObj._proxyObj = vpro;
    [_currentObj syncDriverIPProperty];
    [_currentObj syncDriverComs];
}


- (void) hdmiAction:(id)sender{
    
    VProjectProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceInput:@"HDMI"];
}
- (void) vgaAction:(id)sender{
    
    VProjectProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceInput:@"COMP"];
}
- (void) usbAction:(id)sender{
    
    VProjectProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceInput:@"USB"];
}
- (void) lanAction:(id)sender{
    
    VProjectProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceInput:@"LAN"];
}

- (void) powerOnAction:(id)sender{
    
    _powerOnBtn.hidden = YES;
    _powerOffBtn.hidden = NO;
    
    VProjectProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDevicePower:@"ON"];
    
}
- (void) powerOffAction:(id)sender{
    
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


- (void) selectCurrentMike:(VTouyingjiSet*)mike{
    
    
    self._currentObj = mike;
    
    
    [self updateCurrentMikeState:mike._deviceno];
}

- (void) updateCurrentMikeState:(NSString *)deviceno{
    
    NSString *nameStr = [BrandCategoryNoUtil generatePickerValue:_currentObj._brand withCategory:_currentObj._type withNo:_currentObj._deviceno];
    [_selectSysBtn setShowText:nameStr];
    
    
}
- (void) sysSelectAction:(id)sender{
    
    [self.view addSubview:_dActionView];
    
    IMP_BLOCK_SELF(EngineerTouYingJiViewCtrl);
    _dActionView._callback = ^(int tagIndex, id obj)
    {
        [block_self selectCurrentMike:obj];
    };
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for(VTouyingjiSet *mike in _touyingjiArray) {
        NSString *nameStr = [BrandCategoryNoUtil generatePickerValue:mike._brand withCategory:mike._type withNo:mike._deviceno];
        [arr addObject:@{@"object":mike,@"name":nameStr}];
    }
    
    _dActionView._selectIndex = _currentObj._index;
    [_dActionView setSelectDatas:arr];
}

- (void) chooseDeviceAtIndex:(int)idx{
    
    self._currentObj = [_touyingjiArray objectAtIndex:idx];
    
    [self updateCurrentMikeState:_currentObj._deviceno];
    
}


#pragma mark -- Right View Delegate ---
- (void) dissmissSettingView{
    [self handleTapGesture:nil];
}


- (void) handleTapGesture:(id)sender{
    
    
  
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    isSettings = NO;
}


- (void) settingsAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

