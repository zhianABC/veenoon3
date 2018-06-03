//
//  UserLightConfigViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/2.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserLightConfigViewCtrl.h"
#import "JLightSliderView.h"
#import "UIButton+Color.h"
#import "IconCenterTextButton.h"
#import "Scenario.h"
#import "EDimmerLight.h"
#import "EDimmerLightProxys.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@interface UserLightConfigViewCtrl () <JLightSliderViewDelegate>{
    
    UIScrollView *_proxysView;
    
    NSMutableArray *_buttonArray;
}
@property (nonatomic, strong) EDimmerLight *_curProcessor;

@end

@implementation UserLightConfigViewCtrl
@synthesize _scenario;
@synthesize _curProcessor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buttonArray = [[NSMutableArray alloc] init];
    
    if([_scenario._envDevices count])
    {
        for(BasePlugElement *plug in _scenario._envDevices)
        {
            if([plug isKindOfClass:[EDimmerLight class]])
                self._curProcessor = (EDimmerLight*)plug;
        }
    }
    
    [super setTitleAndImage:@"env_corner_light.png" withTitle:@"照明"];
    
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
    
    
    
    [self getCurrentDeviceDriverProxys];
    
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
                [KVNProgress showErrorWithStatus:@"中控链接断开！"];
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
    
    
    
    int sliderHeight = 475-64;
    int sliderLeftRight = 90;
    
    int buttonHeight = 50+64;
    int width = 60;
    
    int pages = count/8;
    if (count % 8 > 0) {
        pages++;
    }
    
    for (int i = 0; i < count; i++) {
        
        if(i % 8 == 0 && i) {
            sliderLeftRight = i/8 * SCREEN_WIDTH+90;
        }
        
        NSString *txt = [NSString stringWithFormat:@"CH %02d", i+1];
        
        IconCenterTextButton *lightBtn = [[IconCenterTextButton alloc] initWithFrame:CGRectMake(sliderLeftRight-30, buttonHeight, width, width*2)];
        
        [lightBtn buttonWithIcon:[UIImage imageNamed:@"user_light_bg_n.png"] selectedIcon:[UIImage imageNamed:@"user_light_bg_s.png"]
                            text:txt
                     normalColor:SINGAL_COLOR
                        selColor:RGB(230, 151, 50)];
        [_proxysView addSubview:lightBtn];
        lightBtn.tag = i;
        
        JLightSliderView *lightSlider = [[JLightSliderView alloc]
                                         initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light2.png"]
                                         frame:CGRectZero];
        [_proxysView addSubview:lightSlider];
        [lightSlider setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
        lightSlider.topEdge = 60;
        lightSlider.bottomEdge = 55;
        lightSlider.maxValue = 100;
        lightSlider.minValue = 0;
        [lightSlider resetScale];
        lightSlider.center = CGPointMake(sliderLeftRight, sliderHeight);
        lightSlider.tag = i;
        
        //lightSlider
        
        
        sliderLeftRight+=120;
        
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
