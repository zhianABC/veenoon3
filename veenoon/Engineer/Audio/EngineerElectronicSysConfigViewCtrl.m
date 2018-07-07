//
//  EngineerElectonicSysConfigViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/14.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "EngineerElectronicSysConfigViewCtrl.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "LightSliderButton.h"
#import "EngineerSliderView.h"
#import "PowerSettingView.h"
#import "EDimmerSwitchLight.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "APowerESet.h"
#import "EDimmerSwitchLightProxy.h"
#import "APowerESetProxy.h"

@interface EngineerElectronicSysConfigViewCtrl () <CustomPickerViewDelegate, LightSliderButtonDelegate>{
    
    NSMutableArray *_buttonArray;
    
    NSMutableArray *_buttonSeideArray;
    NSMutableArray *_buttonChannelArray;
    NSMutableArray *_buttonNumberArray;
    
    NSMutableArray *_selectedBtnArray;
    
    BOOL isSettings;
    PowerSettingView *_rightView;
    UIButton *okBtn;
    
    UIView *_proxysView;
}


@end

@implementation EngineerElectronicSysConfigViewCtrl
@synthesize _electronicSysArray;
@synthesize _currentObj;
@synthesize _number;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings=NO;
    
    _buttonArray = [[NSMutableArray alloc] init];
    _buttonSeideArray = [[NSMutableArray alloc] init];
    _buttonChannelArray = [[NSMutableArray alloc] init];
    _buttonNumberArray = [[NSMutableArray alloc] init];
    _selectedBtnArray = [[NSMutableArray alloc] init];
    
    [self setTitleAndImage:@"env_corner_light.png" withTitle:@"照明"];
    
    if([_electronicSysArray count])
        self._currentObj = [_electronicSysArray objectAtIndex:0];
    
    [self showBasePluginName:_currentObj];
    
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
    [cancelBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    _proxysView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           64,
                                                           SCREEN_WIDTH,
                                                           SCREEN_HEIGHT-64-50)];
    [self.view addSubview:_proxysView];
    
    
    [self getCurrentDeviceDriverProxys];
    
    [self showRightView];
}

- (void) showRightView{
    
    if(_rightView == nil)
    {
        _rightView = [[PowerSettingView alloc]
                      initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                               64, 300, SCREEN_HEIGHT-114)];
    } else {
        [UIView beginAnimations:nil context:nil];
        _rightView.frame  = CGRectMake(SCREEN_WIDTH-300,
                                       64, 300, SCREEN_HEIGHT-114);
        [UIView commitAnimations];
    }
    [self.view addSubview:_rightView];
    
    _rightView._objSet = _currentObj;
    [_rightView refreshView:_currentObj];
    
}

- (void) handleTapGesture2:(UIGestureRecognizer*)sender{
    
    CGPoint pt = [sender locationInView:self.view];
    
    if(pt.x < SCREEN_WIDTH-300)
    {
        
        CGRect rc = _rightView.frame;
        rc.origin.x = SCREEN_WIDTH;
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             _rightView.frame = rc;
                             
                         } completion:^(BOOL finished) {
                             
                         }];
        
        
        okBtn.hidden = NO;
        isSettings = NO;
    }
}

- (void) layoutChannels {
    
    int index = 0;
    int top = ENGINEER_VIEW_COMPONENT_TOP-64;
    
    int leftRight = ENGINEER_VIEW_LEFT;
    
    int cellWidth = 92;
    int cellHeight = 92;
    int colNumber = 6;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    
    NSDictionary *chLevelMap = [(APowerESetProxy*)self._currentObj._proxyObj getChLevelRecords];
    
    for (int i = 0; i < self._number; i++) {
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        
        LightSliderButton *btn = [[LightSliderButton alloc] initWithFrame:CGRectMake(startX, startY, 120, 120)];
        btn.tag = i;
        btn.delegate = self;
        [_proxysView addSubview:btn];
        
        btn._grayBackgroundImage = [UIImage imageNamed:@"dianyuanshishiqi_n.png"];
        btn._lightBackgroundImage = [UIImage imageNamed:@"dianyuanshishiqi_s.png"];
        
        [btn hiddenProgress];
        
        [btn turnOnOff:NO];
        
        id key = [NSNumber numberWithInt:i+1];
        if([chLevelMap objectForKey:key])
        {
            BOOL power = [[chLevelMap objectForKey:key] boolValue];
            [btn turnOnOff:power];
        }
        
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2-40, 0, 80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:11];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = [@"CH " stringByAppendingString:[NSString stringWithFormat:@"0%d",i+1]];
        [_buttonNumberArray addObject:titleL];
        
        [_buttonArray addObject:btn];
        
        index++;
    }
    
}

- (void) getCurrentDeviceDriverProxys{
    
    if(_currentObj == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerElectronicSysConfigViewCtrl);
    
    RgsDriverObj *driver = _currentObj._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        
        [[RegulusSDK sharedRegulusSDK] GetDriverCommands:driver.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
            if (result) {
                if ([commands count]) {
                    [block_self loadedLightCommands:commands];
                }
            }
            else{
                [KVNProgress showErrorWithStatus:@"中控链接断开！"];
            }
        }];
    }
#endif
}

- (void) loadedLightCommands:(NSArray*)cmds{
    
    RgsDriverObj *driver = _currentObj._driver;
    
    id proxy = _currentObj._proxyObj;
    
    EDimmerSwitchLightProxy *vpro = nil;
    if(proxy && [proxy isKindOfClass:[EDimmerSwitchLightProxy class]])
    {
        vpro = proxy;
    }
    else
    {
        vpro = [[EDimmerSwitchLightProxy alloc] init];
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
    
    self._number = [vpro getNumberOfLights];
    [self layoutChannels];
}

- (void) didTappedMSelf:(LightSliderButton*)slbtn{
    
    EDimmerSwitchLightProxy *vpro = self._currentObj._proxyObj;
    int ch = (int)slbtn.tag + 1;
    
    // want to choose it
    if (![_selectedBtnArray containsObject:slbtn]) {
        
        [_selectedBtnArray addObject:slbtn];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:slbtn.tag];
        numberL.textColor = YELLOW_COLOR;
        
        [slbtn enableValueSet:YES];
        
        if([vpro isKindOfClass:[EDimmerSwitchLightProxy class]])
        {
            [vpro controlDeviceLightPower:1 ch:ch];
        }
        
    } else {
        // remove it
        [_selectedBtnArray removeObject:slbtn];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:slbtn.tag];
        numberL.textColor = [UIColor whiteColor];;
        
        [slbtn enableValueSet:NO];
        
        if([vpro isKindOfClass:[EDimmerSwitchLightProxy class]])
        {
            [vpro controlDeviceLightPower:0 ch:ch];
        }
    }
}

- (void) okAction:(id)sender{
    
    if (!isSettings) {
        
        if(_rightView == nil)
        {
            _rightView = [[PowerSettingView alloc]
                          initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                   64, 300, SCREEN_HEIGHT-114)];
        } else {
            [UIView beginAnimations:nil context:nil];
            _rightView.frame  = CGRectMake(SCREEN_WIDTH-300,
                                           64, 300, SCREEN_HEIGHT-114);
            [UIView commitAnimations];
        }
        [self.view addSubview:_rightView];
        
        _rightView._objSet = _currentObj;
        [_rightView refreshView:_currentObj];
        
        
        [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        if (_rightView) {
            [_rightView removeFromSuperview];
        }
        
        [_rightView saveCurrentSetting];
        [_currentObj uploadDriverIPProperty];
        
        
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
