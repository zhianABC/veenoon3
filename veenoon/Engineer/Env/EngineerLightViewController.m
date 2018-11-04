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
    
    NSMutableArray *_selectedBtnArray;
    
    EngineerSliderView *_zengyiSlider;
    
    BOOL isSettings;
    LightRightView *_rightView;
    UIButton *okBtn;
    
    UIView *_proxysView;
}
@property (nonatomic, strong) EDimmerLight *_curProcessor;
@property (nonatomic, strong) NSArray *_proxys;
@property (nonatomic, strong) NSMutableDictionary *_proxyObjMap;
@end

@implementation EngineerLightViewController
@synthesize _lightSysArray;
@synthesize _number;
@synthesize _curProcessor;
@synthesize _proxys;
@synthesize _proxyObjMap;
@synthesize fromScenario;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings = NO;
    
    _buttonArray = [[NSMutableArray alloc] init];
    _buttonSeideArray = [[NSMutableArray alloc] init];
    _buttonChannelArray = [[NSMutableArray alloc] init];
    _selectedBtnArray = [[NSMutableArray alloc] init];
    
    [super setTitleAndImage:@"env_corner_light.png" withTitle:@"照明"];
    
    if([_lightSysArray count])
        self._curProcessor = [_lightSysArray objectAtIndex:0];
    
    [super showBasePluginName:self._curProcessor chooseEnabled:NO];
    
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
    
    _zengyiSlider.indicatorImgS = [UIImage imageNamed:@"wireless_slide_light_s.png"];
    _zengyiSlider.indicatorImgN = [UIImage imageNamed:@"wireless_slide_light_n.png"];
    _zengyiSlider.indicatorMuteImg = _zengyiSlider.indicatorImgN;
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_light_s.png"]];
    _zengyiSlider.topEdge = 90;
    _zengyiSlider.bottomEdge = 55;
    _zengyiSlider.maxValue = 100;
    _zengyiSlider.minValue = 0;
    _zengyiSlider.delegate = self;
    _zengyiSlider._muteEnabled = NO;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(TESLARIA_SLIDER_X, TESLARIA_SLIDER_Y);
    
    if(!fromScenario){
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyProxyGotCurStateVals:)
                                                 name:NOTIFY_PROXY_CUR_STATE_GOT_LB
                                               object:nil];
    }
    
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
    
    
    self._proxyObjMap = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < [tmpProxyObjs count]; i++) {
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        EDimmerLightProxys *apxy = [tmpProxyObjs objectAtIndex:i];
        
        LightSliderButton *btn = [[LightSliderButton alloc] initWithFrame:CGRectMake(startX, startY, 120, 120)];
        btn.tag = i;
        btn.delegate = self;
        [_proxysView addSubview:btn];
        btn.longPressEnabled = YES;
        
        btn.data = apxy;
        
        int level = apxy._level;
        float f = level/100.0;
        [btn setCircleValue:f];
    
        btn._titleLabel.alpha = 0.5;
        btn._titleLabel.text = [@"CH " stringByAppendingString:[NSString stringWithFormat:@"0%d",i+1]];
        
        [_buttonArray addObject:btn];
        
        if(!fromScenario)
        {
        if(apxy._rgsProxyObj){
            [_proxyObjMap setObject:btn forKey:@(apxy._rgsProxyObj.m_id)];
            
            btn._titleLabel.text = apxy._rgsProxyObj.name;
            
            [apxy getCurrentDataState];
        }
        }
        
        index++;
    }
    
    if([tmpProxyObjs count])
    {
        //只读取一个，因为所有的out的commands相同
        NSMutableArray *proxyids = [NSMutableArray array];
        EDimmerLightProxys *ape = [tmpProxyObjs objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInteger:ape._rgsProxyObj.m_id]];
        
        IMP_BLOCK_SELF(EngineerLightViewController);
        
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

#pragma mark -- Long Press Delegate -- 修改名字
- (void) didLongPressSlideButton:(LightSliderButton*)slbtn{
    
    EDimmerLightProxys* proxy = slbtn.data;
    if([proxy isKindOfClass:[EDimmerLightProxys class]])
    {
        NSString *alert = @"修改通道名称";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:alert preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"通道名称";
            textField.text = proxy._rgsProxyObj.name;
            //textField.keyboardType = UIKeyboardTypeDecimalPad;
        }];
        
        
        IMP_BLOCK_SELF(EngineerLightViewController);
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *alValTxt = alertController.textFields.firstObject;
            NSString *val = alValTxt.text;
            if (val && [val length] > 0) {
                
                [block_self resetProxyName:val
                                     proxy:proxy
                                  slideBtn:slbtn];
            }
        }]];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (void) resetProxyName:(NSString*)name proxy:(EDimmerLightProxys*)proxy slideBtn:(LightSliderButton*)btn{
    
    
    btn._titleLabel.text = name;
    proxy._rgsProxyObj.name = name;
    
    [[RegulusSDK sharedRegulusSDK] RenameProxy:proxy._rgsProxyObj.m_id
                                          name:name
                                    completion:nil];
    
}


#pragma mark --Proxy Current State Got
- (void) notifyProxyGotCurStateVals:(NSNotification*)notify{
    
    NSDictionary *obj = notify.object;
    
    if(obj && [obj objectForKey:@"proxy"])
    {
        id key = [obj objectForKey:@"proxy"];
        
        id ctrl = [_proxyObjMap objectForKey:key];
        if([ctrl isKindOfClass:[LightSliderButton class]])
        {
            LightSliderButton *pbtn = ctrl;
            EDimmerLightProxys *apxy = pbtn.data;
            
            int level = apxy._level;
            float f = level/100.0;
            [pbtn setCircleValue:f];
        }
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
    
    IMP_BLOCK_SELF(EngineerLightViewController);
    
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

- (void) didSliderValueChanged:(float)value object:(id)object {
    
    float circleValue = (value + 0.0f)/100.0f;

    NSMutableArray *opts = [NSMutableArray array];
    
    for (LightSliderButton *button in _selectedBtnArray) {
        
        [button setCircleValue:circleValue];
       
        EDimmerLightProxys *apxy = button.data;
        
        if([apxy isKindOfClass:[EDimmerLightProxys class]])
        {
            [apxy controlDeviceLightLevel:(int)value
                                     exec:NO];
            
            //控制命令
            NSArray *tmps = [apxy generateEventOperation_ChLevel];
    
            [opts addObjectsFromArray:tmps];
        }
    }
    
    if(opts)
    {
        
        if([opts count])
            [[RegulusSDK sharedRegulusSDK] ControlDeviceByOperation:opts
                                                         completion:nil];
    }
}

- (void) didSliderEndChanged:(float)value object:(id)object {
    
    float circleValue = (value)/100.0f;
 
    NSMutableArray *opts = [NSMutableArray array];
    
    for (LightSliderButton *button in _selectedBtnArray) {
        
        [button setCircleValue:circleValue];
        
        EDimmerLightProxys *apxy = button.data;
        
        if([apxy isKindOfClass:[EDimmerLightProxys class]])
        {
            [apxy controlDeviceLightLevel:(int)value
                                     exec:NO];
            
            //控制命令
            NSArray *tmps = [apxy generateEventOperation_ChLevel];
            
            [opts addObjectsFromArray:tmps];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        
       //控制命令
        if([opts count])
            [[RegulusSDK sharedRegulusSDK] ControlDeviceByOperation:opts
                                                         completion:nil];
    });
    
}



- (void) didSlideButtonValueChanged:(float)value slbtn:(LightSliderButton*)slbtn{
    
    int circleValue = value*100.0f;
    
    EDimmerLightProxys *vpro = slbtn.data;
    if([vpro isKindOfClass:[EDimmerLightProxys class]])
    {
        [vpro controlDeviceLightLevel:circleValue
                                 exec:YES];
    }
    
    [_zengyiSlider setScaleValue:circleValue];
}

- (void) didSlideButtonValueEndChanged:(float)value slbtn:(LightSliderButton*)slbtn{
    
    int circleValue = value*100.0f;
    [_zengyiSlider setScaleValue:circleValue];
    
    EDimmerLightProxys *vpro = slbtn.data;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        
        if([vpro isKindOfClass:[EDimmerLightProxys class]])
        {
            [vpro controlDeviceLightLevel:circleValue
                                     exec:YES];
        }
    });
    
}

- (void) didTappedMSelf:(LightSliderButton*)slbtn{
    
    // want to choose it
    if (![_selectedBtnArray containsObject:slbtn]) {
        
        [_selectedBtnArray addObject:slbtn];

        slbtn._titleLabel.alpha = 1.0;
        slbtn._titleLabel.textColor = NEW_ER_BUTTON_SD_COLOR;
        
        [slbtn enableValueSet:YES];
        
    }
    else
    {
        // remove it
        [_selectedBtnArray removeObject:slbtn];

        slbtn._titleLabel.alpha = 0.5;
        slbtn._titleLabel.textColor = [UIColor whiteColor];
        
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
        
        button._titleLabel.alpha = 1.0;
        button._titleLabel.textColor = NEW_ER_BUTTON_SD_COLOR;
        
        [button enableValueSet:YES];
    } else {
        // remove it
        [_selectedBtnArray removeObject:btn];
        
        btn._titleLabel.textColor = [UIColor whiteColor];
        btn._titleLabel.alpha = 0.5;
        
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

- (void) dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
