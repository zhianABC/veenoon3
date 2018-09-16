//
//  EngineerLightViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerLightViewController.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "LightSliderButton.h"
#import "EngineerSliderView.h"
#import "LightRightView.h"
#import "EDimmerLight.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "EDimmerLightProxys.h"

@interface EngineerLightViewController () <CustomPickerViewDelegate, EngineerSliderViewDelegate, LightSliderButtonDelegate>{
    
    NSMutableArray *_buttonArray;
    
    NSMutableArray *_buttonSeideArray;
    NSMutableArray *_buttonChannelArray;
    NSMutableArray *_buttonNumberArray;
    
    NSMutableArray *_selectedBtnArray;
    
    EngineerSliderView *_zengyiSlider;
    
    BOOL isSettings;
    LightRightView *_rightView;
    UIButton *okBtn;
    
    UIView *_proxysView;
}
@property (nonatomic, strong) EDimmerLight *_curProcessor;


@end

@implementation EngineerLightViewController
@synthesize _lightSysArray;
@synthesize _number;
@synthesize _curProcessor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings=NO;
    
    _buttonArray = [[NSMutableArray alloc] init];
    _buttonSeideArray = [[NSMutableArray alloc] init];
    _buttonChannelArray = [[NSMutableArray alloc] init];
    _buttonNumberArray = [[NSMutableArray alloc] init];
    _selectedBtnArray = [[NSMutableArray alloc] init];
    
    [super setTitleAndImage:@"env_corner_light.png" withTitle:@"照明"];
    
    if([_lightSysArray count])
        self._curProcessor = [_lightSysArray objectAtIndex:0];
    
    [super showBasePluginName:self._curProcessor];
    
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
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(okAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    
    _proxysView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           64,
                                                           SCREEN_WIDTH,
                                                           SCREEN_HEIGHT-64-50)];
    [self.view addSubview:_proxysView];
    
    
    _zengyiSlider = [[EngineerSliderView alloc]
                     initWithSliderBg:[UIImage imageNamed:@"engineer_zengyi2_n.png"]
                     frame:CGRectZero];
    [self.view addSubview:_zengyiSlider];
    
    //[_zengyiSlider setRoadImage:[UIImage imageNamed:@"e_v_slider_road.png"]];
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_s.png"]];
    _zengyiSlider.topEdge = 90;
    _zengyiSlider.bottomEdge = 55;
    _zengyiSlider.maxValue = 100;
    _zengyiSlider.minValue = 0;
    _zengyiSlider.delegate = self;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(TESLARIA_SLIDER_X, TESLARIA_SLIDER_Y);
    
    [self getCurrentDeviceDriverProxys];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture2:)];
    tapGesture.cancelsTouchesInView =  NO;
    tapGesture.numberOfTapsRequired = 1;
    [_proxysView addGestureRecognizer:tapGesture];
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

- (void) layoutChannels{
    
    int index = 0;
    int top = ENGINEER_VIEW_COMPONENT_TOP-64;
    
    int leftRight = ENGINEER_VIEW_LEFT;
    
    int cellWidth = 92;
    int cellHeight = 92;
    int colNumber = ENGINEER_VIEW_COLUMN_N;
    int space = ENGINEER_VIEW_COLUMN_GAP;
    
    
    NSDictionary *chLevelMap = [(EDimmerLightProxys*)_curProcessor._proxyObj getChLevelRecords];
    
    for (int i = 0; i < self._number; i++) {
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        LightSliderButton *btn = [[LightSliderButton alloc] initWithFrame:CGRectMake(startX, startY, 120, 120)];
        btn.tag = i;
        btn.delegate = self;
        [_proxysView addSubview:btn];
        
        id key = [NSString stringWithFormat:@"%d", i+1];
        if([chLevelMap objectForKey:key])
        {
            int level = [[chLevelMap objectForKey:key] intValue];
            float f = level/100.0;
            [btn setCircleValue:f];
        }
        
    
        UILabel* titleL = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2-40, 0, 80, 20)];
        titleL.backgroundColor = [UIColor clearColor];
        titleL.alpha = 0.5;
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
    
    if(_curProcessor == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerLightViewController);
    
    RgsDriverObj *driver = _curProcessor._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
//        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
//            if (result) {
//                if ([proxys count]) {
//
//                   // block_self._proxys = proxys;
//                   // [block_self initChannels];
//                }
//            }
//            else{
//                [KVNProgress showErrorWithStatus:[error description]];
//            }
//        }];
        
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
    
    
    self._curProcessor._proxyObj = vpro;
    [_curProcessor syncDriverIPProperty];
    
    self._number = [vpro getNumberOfLights];
    [self layoutChannels];
}

- (void) didSliderValueChanged:(float)value object:(id)object {
    
    float circleValue = (value + 0.0f)/100.0f;
    
     EDimmerLightProxys *vpro = self._curProcessor._proxyObj;
    
    for (LightSliderButton *button in _selectedBtnArray) {
        
        [button setCircleValue:circleValue];
        
        int ch = (int)button.tag + 1;
        if([vpro isKindOfClass:[EDimmerLightProxys class]])
        {
            [vpro controlDeviceLightLevel:(int)value
                                       ch:ch
                                     exec:NO];

        }
    }
    
    if(vpro)
    {
        //控制命令
        NSArray *opts = [vpro generateEventOperation_ChLevel];
        
        if([opts count])
            [[RegulusSDK sharedRegulusSDK] ControlDeviceByOperation:opts
                                                         completion:nil];
    }
}

- (void) didSliderEndChanged:(float)value object:(id)object {
    
//    EngineerSliderView *sliderCtrl = object;
//    float value = [sliderCtrl getScaleValue];
//
    float circleValue = (value)/100.0f;
    
    EDimmerLightProxys *vpro = self._curProcessor._proxyObj;
    
    for (LightSliderButton *button in _selectedBtnArray) {
        
        [button setCircleValue:circleValue];
        
        int ch = (int)button.tag + 1;
        if([vpro isKindOfClass:[EDimmerLightProxys class]])
        {
            [vpro controlDeviceLightLevel:(int)value
                                       ch:ch
                                     exec:NO];
            
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        
        if(vpro)
        {
            //控制命令
            NSArray *opts = [vpro generateEventOperation_ChLevel];
            
            if([opts count])
                [[RegulusSDK sharedRegulusSDK] ControlDeviceByOperation:opts
                                                             completion:nil];
        }
    });
    
}



- (void) didSlideButtonValueChanged:(float)value slbtn:(LightSliderButton*)slbtn{
    
    int circleValue = value*100.0f;
    
    EDimmerLightProxys *vpro = self._curProcessor._proxyObj;
    int ch = (int)slbtn.tag + 1;
    if([vpro isKindOfClass:[EDimmerLightProxys class]])
    {
        [vpro controlDeviceLightLevel:circleValue
                                   ch:ch
                                 exec:YES];
    }
    
    [_zengyiSlider setScaleValue:circleValue];
}

- (void) didSlideButtonValueEndChanged:(float)value slbtn:(LightSliderButton*)slbtn{
    
    int circleValue = value*100.0f;
    [_zengyiSlider setScaleValue:circleValue];
    
    EDimmerLightProxys *vpro = self._curProcessor._proxyObj;
    int ch = (int)slbtn.tag + 1;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        
        if([vpro isKindOfClass:[EDimmerLightProxys class]])
        {
            [vpro controlDeviceLightLevel:circleValue
                                       ch:ch
                                     exec:YES];
        }
    });
    
}

- (void) didTappedMSelf:(LightSliderButton*)slbtn{
    
    // want to choose it
    if (![_selectedBtnArray containsObject:slbtn]) {
        
        [_selectedBtnArray addObject:slbtn];

        UILabel *numberL = [_buttonNumberArray objectAtIndex:slbtn.tag];
        numberL.textColor = NEW_ER_BUTTON_SD_COLOR;
        numberL.alpha = 1.0;

        [slbtn enableValueSet:YES];
        
    }
    else
    {
        // remove it
        [_selectedBtnArray removeObject:slbtn];

        UILabel *numberL = [_buttonNumberArray objectAtIndex:slbtn.tag];
        numberL.textColor = [UIColor whiteColor];;
        numberL.alpha = 0.5;
        
        [slbtn enableValueSet:NO];
    }
}

-(void)handleTapGesture:(UIGestureRecognizer*)gestureRecognizer {
    
    int tag = (int) gestureRecognizer.view.tag;
    
    LightSliderButton *btn;
    for (LightSliderButton *button in _selectedBtnArray) {
        if (button.tag == tag) {
            btn = button;
            break;
        }
    }
    // want to choose it
    if (btn == nil) {
        LightSliderButton *button = [_buttonArray objectAtIndex:tag];
        [_selectedBtnArray addObject:button];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:tag];
        numberL.alpha = 1.0;
        numberL.textColor = NEW_ER_BUTTON_SD_COLOR;
        
        [button enableValueSet:YES];
    } else {
        // remove it
        [_selectedBtnArray removeObject:btn];
        
        UILabel *numberL = [_buttonNumberArray objectAtIndex:tag];
        numberL.textColor = [UIColor whiteColor];;
        numberL.alpha = 0.5;
        
        [btn enableValueSet:NO];
    }
}

- (void) okAction:(id)sender{
    
    if (!isSettings) {
        
        if(_rightView == nil)
        {
        _rightView = [[LightRightView alloc]
                      initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                               64, 300, SCREEN_HEIGHT-114)];
        } else {
            [UIView beginAnimations:nil context:nil];
            _rightView.frame  = CGRectMake(SCREEN_WIDTH-300,
                                     64, 300, SCREEN_HEIGHT-114);
            [UIView commitAnimations];
        }
        [self.view addSubview:_rightView];
        
        _rightView._currentObj = _curProcessor;
        [_rightView refreshView:_curProcessor];
        
        
        [okBtn setTitle:@"关闭" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        
        if (_rightView) {
            [_rightView removeFromSuperview];
        }
        
//        [_rightView saveCurrentSetting];
//        [_curProcessor uploadDriverIPProperty];

        
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
