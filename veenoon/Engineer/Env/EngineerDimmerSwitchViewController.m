//
//  EngineerDimmerSwitchViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/29.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerDimmerSwitchViewController.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "LightSliderButton.h"
#import "EngineerSliderView.h"
#import "DSwitchLightRightView.h"
#import "EDimmerSwitchLight.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "EDimmerSwitchLightProxy.h"

@interface EngineerDimmerSwitchViewController () <CustomPickerViewDelegate, LightSliderButtonDelegate>{
    
    NSMutableArray *_buttonArray;
    
    NSMutableArray *_buttonSeideArray;
    NSMutableArray *_buttonChannelArray;

    
    BOOL isSettings;
    DSwitchLightRightView *_rightView;
    UIButton *okBtn;
    
    UIView *_proxysView;
}
@property (nonatomic, strong) EDimmerSwitchLight *_curProcessor;
@property (nonatomic, strong) NSArray *_proxys;
@property (nonatomic, strong) NSMutableDictionary *_proxyObjMap;

@end

@implementation EngineerDimmerSwitchViewController
@synthesize _lightSysArray;
@synthesize _number;
@synthesize _curProcessor;
@synthesize _proxys;
@synthesize _proxyObjMap;
@synthesize fromScenario;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSettings=NO;
    
    _buttonArray = [[NSMutableArray alloc] init];
    _buttonSeideArray = [[NSMutableArray alloc] init];
    _buttonChannelArray = [[NSMutableArray alloc] init];
    
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
//
    
    
    
    _proxysView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           64,
                                                           SCREEN_WIDTH,
                                                           SCREEN_HEIGHT-64-50)];
    [self.view addSubview:_proxysView];
    
    if(!fromScenario)
    {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyProxyGotCurStateVals:)
                                                 name:NOTIFY_PROXY_CUR_STATE_GOT_LB
                                               object:nil];
    }
    
    [self getCurrentDeviceDriverProxys];
    
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
    int colNumber = 8;
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
            
            EDimmerSwitchLightProxy *apxy = [[EDimmerSwitchLightProxy alloc] init];
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

        EDimmerSwitchLightProxy *apxy = [tmpProxyObjs objectAtIndex:i];
        
        LightSliderButton *btn = [[LightSliderButton alloc] initWithFrame:CGRectMake(startX, startY, 120, 120)];
        btn.tag = i;
        btn.delegate = self;
        [_proxysView addSubview:btn];
        btn.longPressEnabled = YES;
        
        btn._grayBackgroundImage = [UIImage imageNamed:@"dianyuanshishiqi_n.png"];
        btn._lightBackgroundImage = [UIImage imageNamed:@"dianyuanshishiqi_s.png"];

        [btn hiddenProgress];
        
        btn.data = apxy;
        
        [btn turnOnOff:apxy._power];
    
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
        EDimmerSwitchLightProxy *ape = [tmpProxyObjs objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInteger:ape._rgsProxyObj.m_id]];
        
        IMP_BLOCK_SELF(EngineerDimmerSwitchViewController);
        
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
        
        for(EDimmerSwitchLightProxy *vap in _curProcessor._proxys)
        {
            [vap checkRgsProxyCommandLoad:cmds];
        }
    }
    
    [KVNProgress dismiss];
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
    
    IMP_BLOCK_SELF(EngineerDimmerSwitchViewController);
    
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



#pragma mark -- Long Press Delegate -- 修改名字
- (void) didLongPressSlideButton:(LightSliderButton*)slbtn{
    
    EDimmerSwitchLightProxy* proxy = slbtn.data;
    if([proxy isKindOfClass:[EDimmerSwitchLightProxy class]])
    {
        NSString *alert = @"修改通道名称";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:alert preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"通道名称";
            textField.text = proxy._rgsProxyObj.name;
            //textField.keyboardType = UIKeyboardTypeDecimalPad;
        }];
        
        
        IMP_BLOCK_SELF(EngineerDimmerSwitchViewController);
        
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

- (void) resetProxyName:(NSString*)name
                  proxy:(EDimmerSwitchLightProxy*)proxy
               slideBtn:(LightSliderButton*)btn{
    
    
    btn._titleLabel.text = name;
    proxy._rgsProxyObj.name = name;
    
    [[RegulusSDK sharedRegulusSDK] RenameProxy:proxy._rgsProxyObj.m_id
                                          name:name
                                    completion:nil];
    
}


- (void) didTappedMSelf:(LightSliderButton*)slbtn{

    EDimmerSwitchLightProxy *vpro = slbtn.data;

    // want to choose it
    if (!vpro._power) {
    
        slbtn._titleLabel.alpha = 1.0;
        slbtn._titleLabel.textColor = NEW_ER_BUTTON_SD_COLOR;

        [slbtn enableValueSet:YES];
        
        if([vpro isKindOfClass:[EDimmerSwitchLightProxy class]])
        {
            [vpro controlDeviceLightPower:1];
        }
        
    } else {
        // remove it
     
        slbtn._titleLabel.alpha = 0.5;
        slbtn._titleLabel.textColor = [UIColor whiteColor];

        [slbtn enableValueSet:NO];
        
        if([vpro isKindOfClass:[EDimmerSwitchLightProxy class]])
        {
            [vpro controlDeviceLightPower:0];
        }
    }
}

- (void) okAction:(id)sender{
    
    if (!isSettings) {
        
        if(_rightView == nil)
        {
        _rightView = [[DSwitchLightRightView alloc]
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
        
        [_rightView saveCurrentSetting];
        //[_curProcessor uploadDriverIPProperty];

        
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    }
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
            EDimmerSwitchLightProxy *apxy = pbtn.data;
            
            [pbtn turnOnOff:apxy._power];
            
            if(apxy._power){
                pbtn._titleLabel.alpha = 1.0;
                pbtn._titleLabel.textColor = NEW_ER_BUTTON_SD_COLOR;
            }
            else
            {
                pbtn._titleLabel.alpha = 0.5;
                pbtn._titleLabel.textColor = [UIColor whiteColor];
            }
        }
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
