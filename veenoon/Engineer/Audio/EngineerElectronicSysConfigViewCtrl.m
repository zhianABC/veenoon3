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

@interface EngineerElectronicSysConfigViewCtrl () <CustomPickerViewDelegate, LightSliderButtonDelegate, PowerSettingViewDelegate>{
    
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
@property (nonatomic, strong) NSArray *_proxys;
@property (nonatomic, strong) NSMutableArray * _powerProxys;

@end

@implementation EngineerElectronicSysConfigViewCtrl
@synthesize _electronicSysArray;
@synthesize _currentObj;
@synthesize _number;
@synthesize _powerProxys;

@synthesize _proxys;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings=NO;
    
    _buttonArray = [[NSMutableArray alloc] init];
    _buttonSeideArray = [[NSMutableArray alloc] init];
    _buttonChannelArray = [[NSMutableArray alloc] init];
    _buttonNumberArray = [[NSMutableArray alloc] init];
    _selectedBtnArray = [[NSMutableArray alloc] init];
    
    [self setTitleAndImage:@"env_corner_dianyuanguanli.png" withTitle:@"电源管理"];
    
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
    
    
    [self showRightView];
    
    [self getCurrentDeviceDriverProxys];
    
    if(_currentObj)
        [_currentObj checkRgsDriverCommandLoad];
    
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
    
    _rightView._delegate = self;
}

- (void) layoutChannels {
    
    int index = 0;
    int top = ENGINEER_VIEW_COMPONENT_TOP-64;
    
    int leftRight = ENGINEER_VIEW_LEFT;
    
    int cellWidth = 92;
    int cellHeight = 92;
    int colNumber = 6;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    self._powerProxys = [NSMutableArray array];
    
    if([_currentObj._proxys count])//已经创建过
    {
        self._powerProxys = _currentObj._proxys;
    }
    else //没创建过
    {
        //创建
        for (int i = 0; i < [_proxys count]; i++) {
            
            RgsProxyObj * rgsProxy = [_proxys objectAtIndex:i];

            APowerESetProxy *apxy = [[APowerESetProxy alloc] init];
            apxy._rgsProxyObj = rgsProxy;
            [_powerProxys addObject:apxy];
        }
        
        _currentObj._proxys = _powerProxys;
    }
    
    for (int i = 0; i < [_powerProxys count]; i++) {
        
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
        
        
        
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2-40, 0, 80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        titleL.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:titleL];
        titleL.font = [UIFont boldSystemFontOfSize:11];
        titleL.textColor  = [UIColor whiteColor];
        titleL.text = [@"CH " stringByAppendingString:[NSString stringWithFormat:@"0%d",i+1]];
        [_buttonNumberArray addObject:titleL];
        
        [_buttonArray addObject:btn];
        
        NSDictionary *dic = [_currentObj getLabValueWithIndex:i];
        if(dic && [[dic objectForKey:@"status"] isEqualToString:@"ON"]){
            [btn turnOnOff:YES];
            
            titleL.textColor = YELLOW_COLOR;
            
            [_selectedBtnArray addObject:btn];
        }
        
        index++;
    }
    
    if([_powerProxys count])
    {
        //只读取一个，因为所有的out的commands相同
        NSMutableArray *proxyids = [NSMutableArray array];
        APowerESetProxy *ape = [_powerProxys objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInteger:ape._rgsProxyObj.m_id]];
        
        IMP_BLOCK_SELF(EngineerElectronicSysConfigViewCtrl);
        
        if(![ape haveProxyCommandLoaded])
        {
            [KVNProgress show];
            [[RegulusSDK sharedRegulusSDK] GetProxyCommandDict:proxyids
                                                    completion:^(BOOL result, NSDictionary *commd_dict, NSError *error) {
                                                        
                                                        [block_self loadAllCommands:commd_dict];
                                                        
                                                    }];
        }
    }
    
    int count = (int) [_currentObj._proxys count];
    if (count) {
        [_currentObj initLabs:count];
        [_rightView showLabs:count];
        
    }
}


- (void) loadAllCommands:(NSDictionary*)commd_dict{
    
    if([[commd_dict allValues] count])
    {
        NSArray *cmds = [[commd_dict allValues] objectAtIndex:0];
        
        for(APowerESetProxy *vap in _powerProxys)
        {
            [vap prepareLoadCommand:cmds];
        }
    }
    
    [KVNProgress dismiss];
}


- (void) getCurrentDeviceDriverProxys {
    
    if(_currentObj == nil)
        return;
    
    //如果有，就不需要重新请求了
    if([_currentObj._proxys count])
    {
        [self layoutChannels];
        return;
    }
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerElectronicSysConfigViewCtrl);
    
    RgsDriverObj *driver = _currentObj._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    NSMutableArray *proxysArray = [NSMutableArray array];
                    for (RgsProxyObj *proxyObj in proxys) {
                        if ([proxyObj.type isEqualToString:@"Relay"]) {
                            [proxysArray addObject:proxyObj];
                        }
                    }
                    block_self._proxys = proxysArray;
                    [block_self layoutChannels];
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }
#endif
}

- (void) didTappedMSelf:(LightSliderButton*)slbtn{
    
    int idx = (int)slbtn.tag;
    
    APowerESetProxy *proxyObj = nil;
    if(idx < [_powerProxys count])
    {
        proxyObj = [_powerProxys objectAtIndex:idx];
    }
    
    // want to choose it
    if (![_selectedBtnArray containsObject:slbtn]) {
        
        [_selectedBtnArray addObject:slbtn];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:slbtn.tag];
        numberL.textColor = YELLOW_COLOR;
        
        [slbtn enableValueSet:YES];
        
        if(proxyObj && [proxyObj isKindOfClass:[APowerESetProxy class]])
        {
            [_currentObj setLabValue:YES
                           withIndex:idx];
            
            //控制 开
            [proxyObj controlRelayStatus:@"Link"];
        }
        
    } else {
        // remove it
        [_selectedBtnArray removeObject:slbtn];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:slbtn.tag];
        numberL.textColor = [UIColor whiteColor];;
        
        [slbtn enableValueSet:NO];
        
        if(proxyObj && [proxyObj isKindOfClass:[APowerESetProxy class]])
        {
            [_currentObj setLabValue:NO
                           withIndex:idx];
            
            //控制 关
            [proxyObj controlRelayStatus:@"Break"];
        }
    }
}

- (void) didControlSwitchAllPower:(BOOL) isPowerOn{
    
    if(_currentObj)
        [_currentObj controlPower:isPowerOn];
    
    for(LightSliderButton *btn in _buttonArray)
    {
        UILabel *numberL = [_buttonNumberArray objectAtIndex:btn.tag];
        APowerESetProxy *powerProxy = [_powerProxys objectAtIndex:btn.tag];
        
        [_currentObj setLabValue:isPowerOn
                       withIndex:(int)btn.tag];
        
        if(isPowerOn)
        {
            numberL.textColor = YELLOW_COLOR;
            [btn enableValueSet:YES];
            powerProxy._relayStatus = @"Link";
        }
        else
        {
            numberL.textColor = [UIColor whiteColor];
            [btn enableValueSet:NO];
            powerProxy._relayStatus = @"Break";
        }
    }
}
- (void) didControlRelayDuration:(int)relayIndex withDuration:(int)duration {
    
    if (relayIndex == -1) {
        
        //批量执行
        NSMutableArray *opts = [NSMutableArray array];
        
        
        for (LightSliderButton *slider in _buttonArray) {
            
            BOOL isEnabel = !slider._isEnabel;
            int index = (int) slider.tag;
            APowerESetProxy *powerProxy = [_powerProxys objectAtIndex:index];
            if (isEnabel)
            {
                [powerProxy controlRelayDuration:YES
                                    withDuration:duration
                                            exec:NO];
                
                //控制命令
                RgsSceneOperation *opt = [powerProxy generateEventOperation_breakDur];
                if(opt)
                    [opts addObject:opt];
                
            }
            else
            {
                [powerProxy controlRelayDuration:NO
                                    withDuration:duration
                                            exec:NO];
                
                //控制命令
                RgsSceneOperation *opt = [powerProxy generateEventOperation_linkDur];
                if(opt)
                    [opts addObject:opt];
            }
            
        }
        
        //批量执行
        if([opts count])
            [[RegulusSDK sharedRegulusSDK] ControlDeviceByOperation:opts
                                                         completion:nil];
        
    }
    else
    {
        LightSliderButton *slider = [_buttonArray objectAtIndex:relayIndex];
        
        BOOL isEnabel = !slider._isEnabel;
        int index = (int) slider.tag;
        APowerESetProxy *powerProxy = [_powerProxys objectAtIndex:index];
        if (isEnabel) {
            [powerProxy controlRelayDuration:YES
                                withDuration:duration
                                        exec:YES];
        } else {
            [powerProxy controlRelayDuration:NO
                                withDuration:duration
                                        exec:YES];
        }
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
