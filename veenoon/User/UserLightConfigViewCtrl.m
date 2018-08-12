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


@interface UserLightConfigViewCtrl () <JLightSliderViewDelegate, UIPopoverPresentationControllerDelegate>{
    
    UIScrollView *_proxysView;
    
    NSMutableArray *_buttonArray;
    
    PlugsCtrlTitleHeader *_selectSysBtn;
    TeslariaComboChooser *_chooser;
}
@property (nonatomic, strong) EDimmerLight *_curProcessor;
@property (nonatomic, strong) NSMutableArray *_devices;

@end

@implementation UserLightConfigViewCtrl
@synthesize _scenario;
@synthesize _curProcessor;
@synthesize _devices;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buttonArray = [[NSMutableArray alloc] init];

    
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
   
    //找出所有的照明
    self._devices = [NSMutableArray array];
    for(BasePlugElement *plug in _scenario._envDevices)
    {
        if([plug isKindOfClass:[EDimmerLight class]]){
            [_devices addObject:plug];
        }
    }
    
    if([_devices count])
        self._curProcessor = [_devices objectAtIndex:0];
    
    
    _selectSysBtn = [[PlugsCtrlTitleHeader alloc] initWithFrame:CGRectMake(50, 100, 80, 30)];
    [self.view addSubview:_selectSysBtn];
    [_selectSysBtn addTarget:self
                      action:@selector(chooseDevice:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    [self refreshCurrentProcessor];
}

- (void) refreshCurrentProcessor{
    
    [self showBasePluginName:self._curProcessor];
    [self getCurrentDeviceDriverProxys];
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
        NSString *idStr = @"Unk";
        if (driver != nil) {
            idStr = [NSString stringWithFormat:@"%d", (int) driver.m_id];
            if(driver.name)
                nameStr = driver.name;
        }
        
        if (nameStr != nil) {
            ipAddress = nameStr;
        }
        
        NSString *showText = [[idStr stringByAppendingString:@" - "] stringByAppendingString:ipAddress];
        [_selectSysBtn setShowText:showText];
    }
}

- (void) getCurrentDeviceDriverProxys{
    
    if(_curProcessor == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(UserLightConfigViewCtrl);
    
    RgsDriverObj *driver = _curProcessor._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        
        [[RegulusSDK sharedRegulusSDK] GetDriverCommands:driver.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
            if (result) {
                if ([commands count]) {
                    [block_self loadedLightCommands:commands];
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }
#endif
}

- (void) loadedLightCommands:(NSArray*)cmds{
    
    RgsDriverObj *driver = _curProcessor._driver;
    
    id proxy = _curProcessor._proxyObj;
    
    EDimmerLightProxys *vpro = nil;
    if(proxy && [proxy isKindOfClass:[EDimmerLightProxys class]])
    {
        vpro = proxy;
    }
    else
    {
        vpro = [[EDimmerLightProxys alloc] init];
    }
    
    vpro._deviceId = driver.m_id;
    [vpro checkRgsProxyCommandLoad:cmds];
    if([_curProcessor._localSavedCommands count])
    {
        NSDictionary *local = [_curProcessor._localSavedCommands objectAtIndex:0];
        [vpro recoverWithDictionary:local];
    }
    
    self._curProcessor._proxyObj = vpro;
    
    int count = [vpro getNumberOfLights];
    //[self layoutChannels];
    
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
    
    NSDictionary *chLevelMap = [(EDimmerLightProxys*)_curProcessor._proxyObj getChLevelRecords];
    
    int x = left;
    for (int i = 0; i < count; i++) {
        
        if(i % countOfPage == 0 && i) {
            x = i/countOfPage * SCREEN_WIDTH + left;
        }
        
        NSString *txt = [NSString stringWithFormat:@"CH %02d", i+1];
        
        IconCenterTextButton *lightBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(x, buttonHeight, width, width*2)];
        
        [lightBtn buttonWithIcon:[UIImage imageNamed:@"user_light_bg_n.png"]
                    selectedIcon:[UIImage imageNamed:@"user_light_bg_s.png"]
                            text:txt
                     normalColor:SINGAL_COLOR
                        selColor:RGB(230, 151, 50)];
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
        
        //lightSlider
        id key = [NSString stringWithFormat:@"%d", i+1];
        if([chLevelMap objectForKey:key])
        {
            int level = [[chLevelMap objectForKey:key] intValue];
            [lightSlider setScaleValue:level];
        }
        
        x+=120;
        
        [_buttonArray addObject:lightBtn];
    }
}

- (void) didSliderValueChanged:(float)value object:(id)object{
    
    int circleValue = value*100.0f;
    
    EDimmerLightProxys *vpro = self._curProcessor._proxyObj;
    int ch = 1;
    
    if([object isKindOfClass:[JLightSliderView class]])
        ch = (int)((JLightSliderView*)object).tag + 1;
    
    if([vpro isKindOfClass:[EDimmerLightProxys class]])
    {
        [vpro controlDeviceLightLevel:circleValue ch:ch];
    }
    
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
