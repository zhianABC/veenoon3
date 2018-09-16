//
//  EngineerWirlessYaoBaoViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/17.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerHunYinSysViewController.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "EngineerSliderView.h"
#import "SlideButton.h"
#import "BatteryView.h"
#import "SignalView.h"
#import "MixVoiceSettingsView.h"
#import "HunyinYinpinchuliViewCtrl.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "AudioEMixProxy.h"


@interface EngineerHunYinSysViewController () <CustomPickerViewDelegate, EngineerSliderViewDelegate, MixVoiceSettingsViewDelegate>{
    
    EngineerSliderView *_zengyiSlider;
    UIButton *okBtn;
    BOOL isSettings;
    MixVoiceSettingsView *_rightView;
}
@property (nonatomic, strong) AudioEMixProxy *_currentProxy;


@end

@implementation EngineerHunYinSysViewController
@synthesize _hunyinSysArray;
@synthesize _currentObj;
@synthesize _currentProxy;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_hunyinSysArray count]) {
        self._currentObj = [_hunyinSysArray objectAtIndex:0];
    }
    [super showBasePluginName:self._currentObj chooseEnabled:NO];
    
    
    [super setTitleAndImage:@"eng_small_mix_icon.png" withTitle:@"混音会议"];
    
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
    
    
    _zengyiSlider = [[EngineerSliderView alloc]
                     initWithSliderBg:[UIImage imageNamed:@"engineer_yunyin_n.png"]
                     frame:CGRectZero];
    [self.view addSubview:_zengyiSlider];
    [_zengyiSlider setRoadImage:[UIImage imageNamed:@"e_v_slider_road.png"]];
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_s.png"]];
    _zengyiSlider.topEdge = 90;
    _zengyiSlider.bottomEdge = 55;
    _zengyiSlider.maxValue = 31;
    _zengyiSlider.minValue = 0;
    _zengyiSlider.delegate = self;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(TESLARIA_SLIDER_X, TESLARIA_SLIDER_Y);
    
    int index = 0;
    int top = ENGINEER_VIEW_COMPONENT_TOP;
    
    int leftRight = ENGINEER_VIEW_LEFT;
    
    int cellWidth = 92;
    int cellHeight = 92;
    int colNumber = ENGINEER_VIEW_COLUMN_N;
    int space = ENGINEER_VIEW_COLUMN_GAP;

    for (int i = 0; i < 12; i++) {
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+top;
        
        
        UIImage *image = [UIImage imageNamed:@"slide_btn.png"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.layer.cornerRadius = 10;
        imageView.layer.borderWidth = 0;
        imageView.layer.borderColor = DARK_BLUE_COLOR.CGColor;
        imageView.clipsToBounds = YES;
        
        imageView.frame = CGRectMake(startX, startY, 100, 100);
        imageView.tag = index;
        imageView.userInteractionEnabled=YES;
        imageView.layer.contentsGravity = kCAGravityCenter;
        [self.view addSubview:imageView];
        
        index++;
    }
    
    [self getCurrentDeviceDriverProxys];
}

- (void) getCurrentDeviceDriverProxys{
    
    if(_currentObj == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerHunYinSysViewController);
    
    RgsDriverObj *driver = _currentObj._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    
                    [block_self loadedHunyinProxys:proxys];
                    
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];

    }
#endif
}

- (void) loadedHunyinProxys:(NSArray*)proxys{
    
    AudioEMixProxy* proxy = self._currentObj._proxyObj;
    
    if(proxy && [proxy isKindOfClass:[AudioEMixProxy class]])
    {
        self._currentProxy = proxy;
    }
    else
    {
        self._currentProxy = [[AudioEMixProxy alloc] init];
    }
    //_currentProxy.delegate = self;
    
    for(RgsProxyObj *pro in proxys)
    {
        if([pro.type isEqualToString:@"Audio Mixer"])
        {
            _currentProxy._rgsProxyObj = pro;
            [_currentProxy checkRgsProxyCommandLoad:nil];
            self._currentObj._proxyObj = _currentProxy;
            
            break;
        }
    }
    
    [_zengyiSlider setScaleValue:proxy._deviceVol];

}

- (void) handleTapGesture:(id)sender{
    
    if ([_rightView superview]) {
        
        CGRect rc = _rightView.frame;
        [UIView animateWithDuration:0.25
                         animations:^{
                             _rightView.frame = CGRectMake(SCREEN_WIDTH,
                                                     rc.origin.y,
                                                     rc.size.width,
                                                     rc.size.height);
                         } completion:^(BOOL finished) {
                             [_rightView removeFromSuperview];
                         }];
    }
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    isSettings = NO;
}
- (void) didSliderValueChanged:(float)value object:(id)object {
   
    float circleValue = value;
    
    [_currentObj._proxyObj controlDeviceVol:circleValue force:YES];
}

- (void) didSliderEndChanged:(id)object {
    
}

- (void) okAction:(id)sender{
    if (!isSettings) {
        if (_rightView == nil) {
            _rightView = [[MixVoiceSettingsView alloc]
                             initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                      64, 300, SCREEN_HEIGHT-114) withAudioMixSet:_currentObj];
            _rightView.delegate_=self;
        } else {
            [UIView beginAnimations:nil context:nil];
            _rightView.frame  = CGRectMake(SCREEN_WIDTH-300,
                                              64, 300, SCREEN_HEIGHT-114);
            [UIView commitAnimations];
        }
        
        [self.view addSubview:_rightView];
        [okBtn setTitle:@"关闭" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        if (_rightView) {
            [_rightView removeFromSuperview];
        }
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    }
}
- (void) didSelectButtonAction:(NSString*)value {
    HunyinYinpinchuliViewCtrl *ctrl = [[HunyinYinpinchuliViewCtrl alloc] init];
    
    ctrl._currentObj = _currentObj;
    
    [self.navigationController pushViewController:ctrl animated:YES];
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

