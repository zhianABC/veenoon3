//
//  EngineerAudioProcessViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/12/19.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerAudioProcessViewCtrl.h"
#import "UIButton+Color.h"
#import "SlideButton.h"
#import "AudioProcessRightView.h"
#import "AudioInputSettingViewCtrl.h"
#import "AudioOutputSettingViewCtrl.h"
#import "AudioMatrixSettingViewCtrl.h"
#import "AudioIconSettingView.h"
#import "CustomPickerView.h"
#import "AudioEProcessor.h"
#import "VAProcessorProxys.h"

#import "KVNProgress.h"
#import "DataCenter.h"

#ifdef OPEN_REG_LIB_DEF
#import "RegulusSDK.h"
#endif

#import "DeviceCmdSlice.h"
#import "WaitDialog.h"

@interface EngineerAudioProcessViewCtrl () <EngineerSliderViewDelegate, CustomPickerViewDelegate, AudioProcessRightViewDelegate, AudioIconSettingViewDelegate, SlideButtonDelegate> {
    
    EngineerSliderView *_zengyiSlider;
    
    NSMutableArray *_buttonArray;
    NSMutableArray *_inputBtnArray;

    NSMutableArray *_selectedBtnArray;
    
    
    AudioProcessRightView *_rightView;
    BOOL isSettings;
    UIButton *okBtn;
    
    AudioIconSettingView *_inconView;
    BOOL isIcon;
    
    UIImageView *bottomBar;
    
    UIView *_proxysView;
    
    float maxAnalogyGain;
    float minAnalogyGain;
 
}
@property (nonatomic, strong) AudioEProcessor *_curProcessor;
@property (nonatomic, strong) NSArray *_proxys;

// <VAProcessorProxys>
@property (nonatomic, strong) NSMutableArray * _inputProxys;
@property (nonatomic, strong) NSMutableArray * _outputProxys;

@end

@implementation EngineerAudioProcessViewCtrl
@synthesize _audioProcessArray;
@synthesize _curProcessor;
@synthesize _proxys;

@synthesize _inputProxys;
@synthesize _outputProxys;

@synthesize _currentAudioDevices;

@synthesize _isChoosedCmdToScenario;

- (void) viewWillAppear:(BOOL)animated
{
    
    [self refreshProxyAnalogyGains];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([_audioProcessArray count])
        self._curProcessor = [_audioProcessArray objectAtIndex:0];
    
    isIcon = NO;
    isSettings = NO;
    _buttonArray = [[NSMutableArray alloc] init];
    
    
    _selectedBtnArray = [[NSMutableArray alloc] init];
    _inputBtnArray = [[NSMutableArray alloc] init];
    
    [self showBasePluginName:_curProcessor];

    [self setTitleAndImage:@"audio_corner_yinpinchuli.png" withTitle:@"音频处理器"];

    bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
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
    
    okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:okBtn];
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [okBtn addTarget:self
              action:@selector(settingAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    maxAnalogyGain = 12.0;
    minAnalogyGain = -70.0;
    
    _zengyiSlider = [[EngineerSliderView alloc]
                     initWithSliderBg:[UIImage imageNamed:@"engineer_zengyi3.png"]
                     frame:CGRectZero];
    
    [_zengyiSlider setRoadImage:[UIImage imageNamed:@"e_v_slider_road.png"]];
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_s.png"]];
    _zengyiSlider.topEdge = 90;
    _zengyiSlider.bottomEdge = 79;
    _zengyiSlider.maxValue = maxAnalogyGain;
    _zengyiSlider.minValue = minAnalogyGain;
    _zengyiSlider.delegate = self;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(SCREEN_WIDTH - 110, SCREEN_HEIGHT/2+50);
    
    int height = 150;
    
    _proxysView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           height-5,
                                                           SCREEN_WIDTH,
                                                           SCREEN_HEIGHT-height-60)];
    [self.view addSubview:_proxysView];
    
    [self.view addSubview:_zengyiSlider];

    [self.view bringSubviewToFront:bottomBar];
    [self.view bringSubviewToFront:_topBar];
    
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView =  NO;
    tapGesture.numberOfTapsRequired = 1;
    [_proxysView addGestureRecognizer:tapGesture];
    
    
    if(_isChoosedCmdToScenario)
    {
        UIButton* scenarioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        scenarioButton.frame = CGRectMake(SCREEN_WIDTH-120, 20, 100, 44);
        [self.view addSubview:scenarioButton];
        [scenarioButton setTitle:@"添加到场景" forState:UIControlStateNormal];
        [scenarioButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [scenarioButton setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
        scenarioButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [scenarioButton addTarget:self
                           action:@selector(addToScenarioAction:)
                 forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    [self getCurrentDeviceDriverProxys];
}

- (void) addToScenarioAction:(id)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didAddToScenarioSlice:cmds:)])
    {
        
        if(_curProcessor)
        {
            NSMutableArray *values = [NSMutableArray array];
            
            for (SlideButton *button in _selectedBtnArray) {
                
                id data = button.data;
                if([data isKindOfClass:[VAProcessorProxys class]])
                {
                    id opt = [(VAProcessorProxys*)data generateEventOperation_AnalogyGain];
                    
                    DeviceCmdSlice *dcmd = [[DeviceCmdSlice alloc] init];
                    dcmd._opt = opt;
                    dcmd._cmdNickName = @"设置输入音量";
                    dcmd._deviceName = [_curProcessor deviceName];
                    dcmd._proxyName = ((VAProcessorProxys*)data)._rgsProxyObj.name;
                    dcmd._plug = _curProcessor;
                    dcmd.dev_id = ((VAProcessorProxys*)data)._rgsProxyObj.m_id;
                    dcmd._value = [NSString stringWithFormat:@"%0.1f",
                                   [(VAProcessorProxys*)data getAnalogyGain]];
                    [values addObject:dcmd];
                }
                
            }
            
            [self.delegate didAddToScenarioSlice:_curProcessor
                                            cmds:values];
            
            [[WaitDialog sharedAlertDialog] setTitle:@"已添加"];
            [[WaitDialog sharedAlertDialog] animateShow];
        }
    }
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
    if ([_inconView superview]) {
        [_inconView removeFromSuperview];
    }
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
    isSettings = NO;
}



- (void) getCurrentDeviceDriverProxys{
    
    if(_curProcessor == nil)
        return;
    
    //如果有，就不需要重新请求了
    if([_curProcessor._inAudioProxys count] && [_curProcessor._outAudioProxys count])
    {
        [self initChannels];
        return;
    }
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerAudioProcessViewCtrl);
    
    RgsDriverObj *driver = _curProcessor._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                   
                    block_self._proxys = proxys;
                    [block_self initChannels];
                }
            }
            else{
                 [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }
    
#endif
}

- (void) refreshProxyAnalogyGains{
    
    if([_buttonArray count])
    {
        for(SlideButton *sbtn in _buttonArray)
        {
            VAProcessorProxys *proxy = sbtn.data;
            if(proxy && [proxy isKindOfClass:[VAProcessorProxys class]])
            {
                NSDictionary *dic = [proxy getAnalogyGainRange];
                float max = [[dic objectForKey:@"max"] floatValue];
                float min = [[dic objectForKey:@"min"] floatValue];
                if(max - min > 0)
                {
                    float p = fabs(([proxy getAnalogyGain] - min)/(max-min));
                    [sbtn setCircleValue:p];
                }
                
                BOOL isMute = [proxy isProxyMute];
                [sbtn muteSlider:isMute];
                
            }
        }
    }
}

- (void) initChannels{
    
    [[_proxysView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_inputBtnArray removeAllObjects];
    
    int height = 5;
    int inputOutGap = 282;
    
    
    UILabel* subTL = [[UILabel alloc] initWithFrame:CGRectMake(50, height-5, 100, 20)];
    subTL.backgroundColor = [UIColor clearColor];
    [_proxysView addSubview:subTL];
    subTL.font = [UIFont boldSystemFontOfSize:16];
    subTL.textColor  = [UIColor whiteColor];
    subTL.text = @"InPuts";
    
    subTL = [[UILabel alloc] initWithFrame:CGRectMake(50, height+inputOutGap-5, 100, 20)];
    subTL.backgroundColor = [UIColor clearColor];
    [_proxysView addSubview:subTL];
    subTL.font = [UIFont boldSystemFontOfSize:16];
    subTL.textColor  = [UIColor whiteColor];
    subTL.text = @"OutPuts";
    
    int colNumber = ENGINEER_VIEW_COLUMN_N;
    int index = 0;
    int cellWidth = 92;
    int cellHeight = 120;
    int leftRight = ENGINEER_VIEW_LEFT;
    int space = 8;
    
    if(_curProcessor._inAudioProxys == nil ||
       _curProcessor._outAudioProxys == nil)
    {
        self._inputProxys = [NSMutableArray array];
        self._outputProxys = [NSMutableArray array];
        
        for(RgsProxyObj *proxy in _proxys)
        {
            if([proxy.type isEqualToString:@"Audio In"])
            {
                VAProcessorProxys *vap = [[VAProcessorProxys alloc] init];
                vap._rgsProxyObj = proxy;
                [_inputProxys addObject:vap];
                
                //[vap checkRgsProxyCommandLoad];
            }
            else if([proxy.type isEqualToString:@"Audio Out"])
            {
                VAProcessorProxys *vap = [[VAProcessorProxys alloc] init];
                vap._rgsProxyObj = proxy;
                [_outputProxys addObject:vap];
                
                //[vap checkRgsProxyCommandLoad];
            }
            else if ([proxy.type isEqualToString:@"Audio Signal"])
            {
                AudioEProcessorSignalProxy *vap = [[AudioEProcessorSignalProxy alloc] init];
                vap._rgsProxyObj = proxy;
                
                _curProcessor._singalProxy = vap;
            }
            else if ([proxy.type isEqualToString:@"Audio AutoMix"]) {
                AudioEProcessorAutoMixProxy *vap = [[AudioEProcessorAutoMixProxy alloc] init];
                vap._rgsProxyObj = proxy;
                
                _curProcessor._autoMixProxy = vap;
            }
        }
        _curProcessor._inAudioProxys = _inputProxys;
        _curProcessor._outAudioProxys = _outputProxys;
        
        ///加载输出输出Proxy的Commands数据
        [_curProcessor prepareAllAudioInCmds];
        [_curProcessor prepareAllAudioOutCmds];
        
    }
    else
    {
        self._inputProxys = _curProcessor._inAudioProxys;
        self._outputProxys = _curProcessor._outAudioProxys;
        
        ///加载输出输出Proxy的Commands数据
        [_curProcessor prepareAllAudioInCmds];
        [_curProcessor prepareAllAudioOutCmds];

        
    }
    for (int i = 0; i < [_inputProxys count]; i++) {
        
        VAProcessorProxys *vap = [_inputProxys objectAtIndex:i];
        
        NSDictionary *dic = [_curProcessor inputChannelAtIndex:i];
        if(dic)
        {
            [vap recoverWithDictionary:dic];
        }
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+height+20;
        
        SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(startX, startY, cellWidth, cellHeight)];
        btn.delegate = self;
        btn.tag = index;
        btn.data = vap;
        [_proxysView addSubview:btn];
        
        [_inputBtnArray addObject:btn];
        
        btn._titleLabel.text = vap._rgsProxyObj.name;
        
        [_buttonArray addObject:btn];
        
        
        /////
        NSDictionary *indevice = vap._voiceInDevice;
        if(indevice)
        {
            NSString *imageName = [indevice objectForKey:@"icon_s"];
            UIImage *img = [UIImage imageNamed:imageName];
            if(img)
            {
                [btn changToIcon:img];
            }
        }
        
        
        float p = fabs(([vap getAnalogyGain] - minAnalogyGain)/(maxAnalogyGain-minAnalogyGain));
        [btn setCircleValue:p];
        
        index++;
    }
    
    for (int i = 0; i < [_outputProxys count]; i++) {
        
        VAProcessorProxys *vap = [_outputProxys objectAtIndex:i];
        
        NSDictionary *dic = [_curProcessor outChannelAtIndex:i];
        if(dic)
        {
            [vap recoverWithDictionary:dic];
        }
        
        int row = i/colNumber;
        int col = i%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+space*row+height+20+inputOutGap;
        
        SlideButton *btn = [[SlideButton alloc] initWithFrame:CGRectMake(startX, startY, cellWidth, cellHeight)];
        btn.tag = index;
        btn.delegate = self;
        btn.data = vap;
        [_proxysView addSubview:btn];
        
        
        btn._titleLabel.text = vap._rgsProxyObj.name;
        
        
        [_buttonArray addObject:btn];
        
        float p = fabs(([vap getAnalogyGain] - minAnalogyGain)/(maxAnalogyGain-minAnalogyGain));
        [btn setCircleValue:p];
        
        index++;
    }
    //[_curProcessor syncDriverIPProperty];
}

//value = 0....1
- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    float circleValue = minAnalogyGain + (value * (maxAnalogyGain - minAnalogyGain));
    slbtn._valueLabel.text = [NSString stringWithFormat:@"%0.1f db", circleValue];
    
    id data = slbtn.data;
    if([data isKindOfClass:[VAProcessorProxys class]])
    {
        [(VAProcessorProxys*)data controlDeviceDb:circleValue
                                            force:YES];
        
        [_zengyiSlider setScaleValue:circleValue];
    }
}

- (void) didEndSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    id data = slbtn.data;
    if([data isKindOfClass:[VAProcessorProxys class]])
    {
        float circleValue = minAnalogyGain + (value * (maxAnalogyGain - minAnalogyGain));
        [(VAProcessorProxys*)data controlDeviceDb:circleValue
                                            force:YES];
        
        [_zengyiSlider setScaleValue:circleValue];
    }
}


#pragma mark ---Engineer Slide ---
- (void) didSliderValueChanged:(float)value object:(id)object {
    
    float circleValue = value;
    
    //批量执行
    NSMutableArray *opts = [NSMutableArray array];
    
    for (SlideButton *button in _selectedBtnArray) {
        
        button._valueLabel.text = [NSString stringWithFormat:@"%0.1f db", circleValue];
        [button setCircleValue:fabs((value - minAnalogyGain)/(maxAnalogyGain - minAnalogyGain))];
        
        id data = button.data;
        if([data isKindOfClass:[VAProcessorProxys class]])
        {
            [(VAProcessorProxys*)data controlDeviceDb:circleValue
                                                force:NO];
            
            //控制命令
            RgsSceneOperation *opt = [(VAProcessorProxys*)data
                                      generateEventOperation_AnalogyGain];
            if(opt)
                [opts addObject:opt];
        }
    }

    
    if([opts count])
        [[RegulusSDK sharedRegulusSDK] ControlDeviceByOperation:opts
                                                     completion:nil];
    
}

- (void) didSliderEndChanged:(float)value object:(id)object{
    
    float circleValue = value;
    
    //批量执行
    NSMutableArray *opts = [NSMutableArray array];
    
    
    for (SlideButton *button in _selectedBtnArray) {
        
        button._valueLabel.text = [NSString stringWithFormat:@"%0.1f db", circleValue];
        [button setCircleValue:fabs((value - minAnalogyGain)/(maxAnalogyGain - minAnalogyGain))];
        
        id data = button.data;
        if([data isKindOfClass:[VAProcessorProxys class]])
        {
            [(VAProcessorProxys*)data controlDeviceDb:circleValue
                                                force:NO];
            
            //控制命令
            RgsSceneOperation *opt = [(VAProcessorProxys*)data
                                      generateEventOperation_AnalogyGain];
            if(opt)
                [opts addObject:opt];
        }
    }
    
    if([opts count])
        [[RegulusSDK sharedRegulusSDK] ControlDeviceByOperation:opts
                                                     completion:nil];
}

- (void) didSliderMuteChanged:(BOOL)mute object:(id)object{
    
    //批量执行
    NSMutableArray *opts = [NSMutableArray array];
    
    for (SlideButton *button in _selectedBtnArray) {
       
        [button muteSlider:mute];
        
        id data = button.data;
        if([data isKindOfClass:[VAProcessorProxys class]])
        {
            [(VAProcessorProxys*)data controlDeviceMute:mute
                                                   exec:NO];
            
            //控制命令
            RgsSceneOperation *opt = [(VAProcessorProxys*)data
                                      generateEventOperation_Mute];
            if(opt)
                [opts addObject:opt];
        }
    }
    
    if([opts count])
        [[RegulusSDK sharedRegulusSDK] ControlDeviceByOperation:opts
                                                     completion:nil];
}


- (void) didTappedMSelf:(SlideButton*)slbtn{
    
    int tag = (int)slbtn.tag;
    
    SlideButton *btn = nil;
    for (SlideButton *button in _selectedBtnArray) {
        if (button.tag == tag) {
            btn = button;
            break;
        }
    }
    // want to choose it
    if (btn == nil) {
        SlideButton *button = [_buttonArray objectAtIndex:tag];
        [_selectedBtnArray addObject:button];
        
        [button enableValueSet:YES];
        
        id data = button.data;
        if([data isKindOfClass:[VAProcessorProxys class]])
        {
            [(VAProcessorProxys*)data checkRgsProxyCommandLoad];
            
            [_zengyiSlider setScaleValue:[(VAProcessorProxys*)data getAnalogyGain]];
        }
        
        

    } else {
        // remove it
        [_selectedBtnArray removeObject:btn];
        
        [btn enableValueSet:NO];

    }
}

- (void) didEndDragingElecCell:(NSDictionary *)data pt:(CGPoint)pt {
    
    CGPoint viewPoint = [self.view convertPoint:pt fromView:_inconView];
    
    //NSLog(@"%f - %f", viewPoint.x, viewPoint.y);
    
    NSString *imageName = [data objectForKey:@"icon_s"];
    UIImage *img = [UIImage imageNamed:imageName];
    if(img) {
        for (SlideButton *button in _inputBtnArray) {
            CGRect rect = [self.view convertRect:button.frame fromView:button.superview];
            if (CGRectContainsPoint(rect, viewPoint)) {
                
                [button changToIcon:img];
                
                id vap = button.data;
                if([vap isKindOfClass:[VAProcessorProxys class]])
                {
                    ((VAProcessorProxys*)vap)._icon_name = imageName;
                    ((VAProcessorProxys*)vap)._voiceInDevice = data;
                    
                    [[DataCenter defaultDataCenter] cacheScenarioOnLocalDB];
                }
            }
        }
    }
    
    NSLog(@"ssss");
}


- (void) settingAction:(id)sender{
    
    if ([_inconView superview]) {
        [_inconView removeFromSuperview];
    }
    if (!isSettings) {
        if (_rightView == nil) {
            _rightView = [[AudioProcessRightView alloc]
                          initWithFrame:CGRectMake(SCREEN_WIDTH-300,
                                                   64, 300, SCREEN_HEIGHT-114)];
            _rightView.delegate_ = self;
        } else {
            [UIView beginAnimations:nil context:nil];
            _rightView.frame  = CGRectMake(SCREEN_WIDTH-300,
                                           64, 300, SCREEN_HEIGHT-114);
            [UIView commitAnimations];
        }
        
        _rightView._processor = _curProcessor;
        
        [self.view addSubview:_rightView];
        [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        if ([_rightView superview]) {
            [_rightView removeFromSuperview];
        }
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    
    }
}


#pragma mark -- Right View Delegate ---
- (void) dissmissSettingView{
    [self handleTapGesture:nil];
}

- (void) didSelectButtonAction:(NSString*)value {
    if ([@"输入设置" isEqualToString:value])
    {
        AudioInputSettingViewCtrl *ctrl = [[AudioInputSettingViewCtrl alloc] init];
        ctrl._processor = _curProcessor;
        
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else if ([@"输出设置" isEqualToString:value])
    {
        AudioOutputSettingViewCtrl *ctrl = [[AudioOutputSettingViewCtrl alloc] init];
        ctrl._processor = _curProcessor;
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
    else if ([@"矩阵路由" isEqualToString:value])
    {
        AudioMatrixSettingViewCtrl *ctrl = [[AudioMatrixSettingViewCtrl alloc] init];
        ctrl._processor = _curProcessor;
        
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else
    {
        
        if (_rightView) {
            [_rightView removeFromSuperview];
            
            if (_inconView == nil) {
                _inconView = [[AudioIconSettingView alloc]
                              initWithFrame:CGRectMake(SCREEN_WIDTH-180,
                                                       64, 180, SCREEN_HEIGHT-114) withCurrentAudios:_currentAudioDevices];
                _inconView.delegate = self;
            } else {
                [UIView beginAnimations:nil context:nil];
                _inconView.frame  = CGRectMake(SCREEN_WIDTH-180,
                                               64, 180, SCREEN_HEIGHT-114);
                [UIView commitAnimations];
            }
            
            [self.view insertSubview:_inconView belowSubview:bottomBar];
            [okBtn setTitle:@"保存" forState:UIControlStateNormal];
        }
    }
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
