//
//  UserLightConfigViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/2.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserLightConfigViewCtrl.h"
#import "JLightSliderView.h"
#import "JSlideView.h"
#import "UIButton+Color.h"
#import "IconCenterTextButton.h"
#import "Scenario.h"
#import "EDimmerLight.h"
#import "EDimmerLightProxys.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "PlugsCtrlTitleHeader.h"
#import "TeslariaComboChooser.h"
#import "EDimmerSwitchLight.h"
#import "DimmerLightSwitchView.h"


@interface UserLightConfigViewCtrl () <JLightSliderViewDelegate, UIPopoverPresentationControllerDelegate>{
    
    UIScrollView *_proxysView;

    PlugsCtrlTitleHeader *_selectSysBtn;
    TeslariaComboChooser *_chooser;
    
    DimmerLightSwitchView *_ligtSwitchView;
}
@property (nonatomic, strong) EDimmerLight *_curProcessor;
@property (nonatomic, strong) NSMutableArray *_devices;

//<IconCenterTextButton,IconCenterTextButton...>
@property (nonatomic, strong) NSMutableArray *_channelBtns;
@property (nonatomic, strong) NSArray *_proxys;

@end

@implementation UserLightConfigViewCtrl
@synthesize _scenario;
@synthesize _curProcessor;
@synthesize _devices;
@synthesize _channelBtns;

@synthesize _proxys;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self._channelBtns = [[NSMutableArray alloc] init];
    
    
    [self setTitleAndImage:@"env_corner_light.png" withTitle:@"照明"];
    
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
    [cancelBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancelBtn addTarget:self
                  action:@selector(cancelAction:)
        forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
   
    //找出所有的照明
    self._devices = [NSMutableArray array];
    for(BasePlugElement *plug in _scenario._envDevices)
    {
        if([plug isKindOfClass:[EDimmerLight class]]){
            [_devices addObject:plug];
        }
        else if([plug isKindOfClass:[EDimmerSwitchLight class]]){
            [_devices addObject:plug];
        }
    }
    
    if([_devices count]){
        self._curProcessor = [_devices objectAtIndex:0];
    }
    
    
    _selectSysBtn = [[PlugsCtrlTitleHeader alloc] initWithFrame:CGRectMake(50, 100, 80, 30)];
    [self.view addSubview:_selectSysBtn];
    [_selectSysBtn addTarget:self
                      action:@selector(chooseDevice:)
            forControlEvents:UIControlEventTouchUpInside];
    
    _ligtSwitchView = [[DimmerLightSwitchView alloc] initWithFrame:_proxysView.frame];
    _ligtSwitchView.backgroundColor = self.view.backgroundColor;
    
    if(_curProcessor)
    {
        [self refreshCurrentProcessor];
    }
}

- (void) refreshCurrentProcessor{
    
    [self showBasePluginName:self._curProcessor];
    
    
    if([_curProcessor isKindOfClass:[EDimmerLight class]])
    {
        //灯光调光
        if([_ligtSwitchView superview])
        [_ligtSwitchView removeFromSuperview];
        
        [self getCurrentDeviceDriverProxys];
    }
    else
    {
        //灯光开关模块
        
        _ligtSwitchView._curProcessor = (id)_curProcessor;
        [_ligtSwitchView load];
        
        [self.view insertSubview:_ligtSwitchView
                    aboveSubview:_proxysView];
        
    }
}


#pragma mark -- UIPopoverPresentationController ---

- (BOOL) popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
    return YES;
    
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
    
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    
    NSLog(@"dismissed");
    _chooser = nil;
}


#pragma mark -- 选择设备---

- (void) chooseDevice:(UIButton*)sender{
    
    if([_devices count] > 1)
    {
        
        NSMutableArray *options = [NSMutableArray array];
        for(int i = 0; i < [_devices count]; i++)
        {
            
            EDimmerLight *plug = [_devices objectAtIndex:i];
            
            RgsDriverObj *driver = (RgsDriverObj*)plug._driver;
            NSString *name = plug._ipaddress;
            if(driver && driver.name)
            {
                name = driver.name;
            }
            
            NSString *s = [NSString stringWithFormat:@"%02d %@", i+1, name];
            
            [options addObject:s];
        }
        
        _chooser = [[TeslariaComboChooser alloc] init];
        _chooser._dataArray = options;
        _chooser._titleStr = @"选择设备";
        _chooser._unit = @"";
        
        int h = (int)[_chooser._dataArray count]*30 + 50;
        _chooser._size = CGSizeMake(320, h);
        
        _chooser.modalPresentationStyle = UIModalPresentationPopover;
        _chooser.preferredContentSize =  CGSizeMake(320, h);
        _chooser.popoverPresentationController.delegate = self;
        _chooser.popoverPresentationController.sourceView = sender;
        _chooser.popoverPresentationController.sourceRect = sender.bounds;
        _chooser.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        [self presentViewController:_chooser animated:YES completion:nil];
        
        IMP_BLOCK_SELF(UserLightConfigViewCtrl);
        _chooser._block = ^(id object, int index) {
            
            [block_self changeDevice:index];
        };
        
    }
    
}

- (void) changeDevice:(int)idx{
    
    EDimmerLight *plug = [_devices objectAtIndex:idx];
    
    self._curProcessor = plug;
    
    if(_chooser)
    {
        [_chooser dismissViewControllerAnimated:YES
                                     completion:nil];
        
        _chooser = nil;
    }
    
    
    [self refreshCurrentProcessor];
}

- (void) showBasePluginName:(BasePlugElement*) basePlugElement {
    
    if (basePlugElement) {
        
        NSString *ipAddress = @"Unk";
        NSString *nameStr = basePlugElement._ipaddress;
        RgsDriverObj *driver = basePlugElement._driver;
        //NSString *idStr = @"Unk";
        if (driver != nil) {
            //idStr = [NSString stringWithFormat:@"%d", (int) driver.m_id];
            if(driver.name)
                nameStr = driver.name;
        }
        
        if (nameStr != nil) {
            ipAddress = nameStr;
        }
        
        NSString *showText = ipAddress;
        [_selectSysBtn setShowText:showText chooseEnabled:YES];
    }
}

- (void) getCurrentDeviceDriverProxys{
    
    if(_curProcessor == nil)
        return;
    
    //如果有，就不需要重新请求了
    if([_curProcessor._proxys count])
    {
        [self layoutChannels];
        return;
    }
    
    IMP_BLOCK_SELF(UserLightConfigViewCtrl);
    
    RgsDriverObj *driver = _curProcessor._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    NSMutableArray *proxysArray = [NSMutableArray array];
                    for (RgsProxyObj *proxyObj in proxys) {
                        if ([proxyObj.type isEqualToString:@"light_v2"]) {
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
}

- (void) layoutChannels{
    
    [[_proxysView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_channelBtns removeAllObjects];
    
    NSMutableArray *tmpProxyObjs = [NSMutableArray array];
    
    if([_curProcessor._proxys count])//已经创建过
    {
        tmpProxyObjs = _curProcessor._proxys;
    }
    else //没创建过
    {
        //创建
        for (int i = 0; i < [_proxys count]; i++) {
            
            RgsProxyObj * rgsProxy = [_proxys objectAtIndex:i];
            
            EDimmerLightProxys *apxy = [[EDimmerLightProxys alloc] init];
            apxy._rgsProxyObj = rgsProxy;
            [tmpProxyObjs addObject:apxy];
        }
        
        _curProcessor._proxys = tmpProxyObjs;
    }
    
    int count = (int)[tmpProxyObjs count];
    
    int countOfPage = 8;
    
    if(count < 8)
        countOfPage = count;
    
    int sliderHeight = 475-64;
    int left = (SCREEN_WIDTH-count*120)/2.0 + 30;
    
    int buttonHeight = 50+64;
    int width = 60;
    
    int pages = count/countOfPage;
    if (count % countOfPage > 0) {
        pages++;
    }
    
    int x = left;
    for (int i = 0; i < count; i++) {
        
        EDimmerLightProxys *apxy = [tmpProxyObjs objectAtIndex:i];
        
        if(i % countOfPage == 0 && i) {
            x = i/countOfPage * SCREEN_WIDTH + left;
        }
        
        NSString *txt = [NSString stringWithFormat:@"CH %02d", i+1];
        
        IconCenterTextButton *lightBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(x, buttonHeight, width, width*2)];
        
        [lightBtn buttonWithIcon:[UIImage imageNamed:@"user_light_bg_n.png"]
                    selectedIcon:[UIImage imageNamed:@"user_light_bg_s.png"]
                            text:txt
                     normalColor:RGB(121, 117, 115)
                        selColor:YELLOW_COLOR];
        [_proxysView addSubview:lightBtn];
        lightBtn.tag = i;
        
        JLightSliderView *lightSlider = [[JLightSliderView alloc]
                                         initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light2.png"]
                                         frame:CGRectZero];
        [_proxysView addSubview:lightSlider];
        [lightSlider setRoadImage:[UIImage imageNamed:@"v_slider_bg_light2.png"]];
        lightSlider.topEdge = 60;
        lightSlider.bottomEdge = 55;
        lightSlider.maxValue = 100;
        lightSlider.minValue = 0;
        [lightSlider resetScale];
        lightSlider.center = CGPointMake(lightBtn.center.x, sliderHeight);
        lightSlider.tag = i;
        lightSlider.delegate = self;
        
        lightSlider.data = apxy;
        
        int level = apxy._level;
        [lightSlider setScaleValue:level];
        
        if(level > 0)
        {
            [lightBtn setBtnHighlited:YES];
            
            float alpha = level/100.0;
            if(alpha < 0.2)
                alpha = 0.2;
            [lightBtn setBtnAlpha:alpha];
        }
        
        x+=120;
        
        [_channelBtns addObject:lightBtn];
    }
    
    if([tmpProxyObjs count])
    {
        //只读取一个，因为所有的out的commands相同
        NSMutableArray *proxyids = [NSMutableArray array];
        EDimmerLightProxys *ape = [tmpProxyObjs objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInteger:ape._rgsProxyObj.m_id]];
        
        IMP_BLOCK_SELF(UserLightConfigViewCtrl);
        
        if(![ape haveProxyCommandLoaded])
        {
            [KVNProgress show];
            [[RegulusSDK sharedRegulusSDK] GetProxyCommandDict:proxyids
                                                    completion:^(BOOL result, NSDictionary *commd_dict, NSError *error) {
                                                        
                                                        [block_self loadAllCommands:commd_dict];
                                                        
                                                    }];
        }
    }
}


- (void) loadAllCommands:(NSDictionary*)commd_dict{
    
    if([[commd_dict allValues] count])
    {
        NSArray *cmds = [[commd_dict allValues] objectAtIndex:0];
        
        for(EDimmerLightProxys *vap in _curProcessor._proxys)
        {
            [vap checkRgsProxyCommandLoad:cmds];
        }
    }
    
    [KVNProgress dismiss];
}


- (void) didSliderValueChanged:(float)value object:(id)object{
    
    int circleValue = value;
    
    JLightSliderView *btn = object;
    EDimmerLightProxys *vpro = btn.data;
   
    int ch = (int)btn.tag + 1;
    
    if([vpro isKindOfClass:[EDimmerLightProxys class]])
    {
        [vpro controlDeviceLightLevel:circleValue
                                 exec:YES];
    }
    
    if(ch - 1 < [_channelBtns count])
    {
        IconCenterTextButton *lightBtn =  [_channelBtns objectAtIndex:ch-1];
        if(circleValue > 0)
        {
            [lightBtn setBtnHighlited:YES];
            
            float alpha = value/100.0;
            if(alpha < 0.2)
                alpha = 0.2;
            [lightBtn setBtnAlpha:alpha];
        }
        else
        {
            [lightBtn setBtnHighlited:NO];
        }
    }
    
}

- (void) didSliderEndChanged:(id)object{
    
    JLightSliderView *sliderCtrl = object;
    int value = [sliderCtrl getScaleValue];
   
    EDimmerLightProxys *vpro = sliderCtrl.data;
    
    int ch = (int)sliderCtrl.tag + 1;

    if(ch - 1 < [_channelBtns count])
    {
        IconCenterTextButton *lightBtn =  [_channelBtns objectAtIndex:ch-1];
        if(value > 0)
        {
            
            [lightBtn setBtnHighlited:YES];
            
            float alpha = value/100.0;
            if(alpha < 0.2)
                alpha = 0.2;
            [lightBtn setBtnAlpha:alpha];
        }
        else
        {
            [lightBtn setBtnHighlited:NO];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        
        if(vpro)
        {
            if([vpro isKindOfClass:[EDimmerLightProxys class]])
            {
                [vpro controlDeviceLightLevel:value
                                         exec:YES];
            }
        }
    });
    
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
