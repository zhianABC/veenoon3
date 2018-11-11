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
    UIButton *iBtn;
    
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
@property (nonatomic, strong) NSMutableDictionary * _proxysMap;
@end

@implementation EngineerAudioProcessViewCtrl
@synthesize _audioProcessArray;
@synthesize _curProcessor;
@synthesize _proxys;

@synthesize _inputProxys;
@synthesize _outputProxys;

@synthesize _currentAudioDevices;
@synthesize _isChoosedCmdToScenario;

@synthesize _proxysMap;

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
    
    [self showBasePluginName:_curProcessor chooseEnabled:NO];

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
              action:@selector(settingAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    
    iBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iBtn.frame = CGRectMake(SCREEN_WIDTH-10-160, 0,160, 50);
    [bottomBar addSubview:iBtn];
    [iBtn setImage:[UIImage imageNamed:@"i_btn_white.png"]
           forState:UIControlStateNormal];
    [iBtn addTarget:self
              action:@selector(iconAction:)
    forControlEvents:UIControlEventTouchUpInside];
    iBtn.center = CGPointMake(SCREEN_WIDTH/2, iBtn.center.y);
    
    maxAnalogyGain = 12.0;
    minAnalogyGain = -70.0;
    
    _zengyiSlider = [[EngineerSliderView alloc]
                     initWithSliderBg:[UIImage imageNamed:@"engineer_zengyi3.png"]
                     frame:CGRectZero];
    
    [_zengyiSlider setRoadImage:[UIImage imageNamed:@"e_v_slider_road.png"]];
    [_zengyiSlider setIndicatorImage:[UIImage imageNamed:@"wireless_slide_s.png"]];
    _zengyiSlider.topEdge = 100;
    _zengyiSlider.bottomEdge = 60;
    _zengyiSlider.isUnLineStyle = YES;
    _zengyiSlider.maxValue = maxAnalogyGain;
    _zengyiSlider.minValue = minAnalogyGain;
    _zengyiSlider.delegate = self;
    [_zengyiSlider resetScale];
    _zengyiSlider.center = CGPointMake(TESLARIA_SLIDER_X, TESLARIA_SLIDER_Y);
    
    int height = 130;
    
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
        [scenarioButton setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        scenarioButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [scenarioButton addTarget:self
                           action:@selector(addToScenarioAction:)
                 forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    _inconView = [[AudioIconSettingView alloc]
                  initWithFrame:CGRectMake(0,
                                           SCREEN_HEIGHT,
                                           SCREEN_WIDTH, 100)
                  withCurrentAudios:_currentAudioDevices];
    _inconView.delegate = self;
    [self.view addSubview:_inconView];
    
    [self.view bringSubviewToFront:bottomBar];
    
    self._proxysMap = [NSMutableDictionary dictionary];
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyProxyGotCurStateVals:)
                                                 name:@"RgsDeviceNotify"
                                               object:nil];
     */
    
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
    
    [self._proxysMap removeAllObjects];
    
    [[_proxysView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_inputBtnArray removeAllObjects];
    
    int height = 5;
    int inputOutGap = 275;
    
    
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
    int cellHeight = 130;
    int leftRight = ENGINEER_VIEW_LEFT;
    int space = 8;
    int ySpace = 15;
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
                
//                if(![_curProcessor.config count])
//                    [vap getCurrentDataState];
            
            }
            else if([proxy.type isEqualToString:@"Audio Out"])
            {
                VAProcessorProxys *vap = [[VAProcessorProxys alloc] init];
                vap._rgsProxyObj = proxy;
                [_outputProxys addObject:vap];
                
//                if(![_curProcessor.config count])
//                    [vap getCurrentDataState];
//
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
        
        int row = index/colNumber;
        int col = index%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+ySpace*row+height+20;
        if (row>=1) {
            startY-=20;
        }
        CGRect rc = CGRectMake(startX, startY, cellWidth, cellHeight);
        SlideButton *btn = [[SlideButton alloc] initWithOffsetFrame:rc offset:10];
        btn.delegate = self;
        btn.longPressEnabled = YES;
        btn.tag = index;
        btn.data = vap;
        [_proxysView addSubview:btn];
        
        //将旋钮和ProxyId做成map，更新旋钮的初始状态
        if(vap._rgsProxyObj){
            [self._proxysMap setObject:btn
                                forKey:[NSNumber numberWithInteger:vap._rgsProxyObj.m_id]];
        }
        
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
        
        int row = i/colNumber;
        int col = i%colNumber;
        int startX = col*cellWidth+col*space+leftRight;
        int startY = row*cellHeight+ySpace*row+height+inputOutGap+20;
        
        if (row>=1) {
            startY-=20;
        }
        
        CGRect rc = CGRectMake(startX, startY, cellWidth, cellHeight);
        SlideButton *btn = [[SlideButton alloc] initWithOffsetFrame:rc offset:10];
        btn.tag = index;
        btn.delegate = self;
        btn.longPressEnabled = YES;
        btn.data = vap;
        [_proxysView addSubview:btn];
        
        //将旋钮和ProxyId做成map，更新旋钮的初始状态
        if(vap._rgsProxyObj){
            [self._proxysMap setObject:btn
                                forKey:[NSNumber numberWithInteger:vap._rgsProxyObj.m_id]];
        }
        
        btn._titleLabel.text = vap._rgsProxyObj.name;
        
        
        [_buttonArray addObject:btn];
        
        float p = fabs(([vap getAnalogyGain] - minAnalogyGain)/(maxAnalogyGain-minAnalogyGain));
        [btn setCircleValue:p];
        
        index++;
    }
    //[_curProcessor syncDriverIPProperty];
}

#pragma mark --Proxy Current State Got
- (void) notifyProxyGotCurStateVals:(NSNotification*)notify{
    
    RgsDeviceNoteObj *obj = notify.object;
    
    if(obj.device_id && [obj.param isKindOfClass:[NSDictionary class]])
    {
        id key = [NSNumber numberWithInteger:obj.device_id];
        
        id ctrl = [_proxysMap objectForKey:key];
        if([ctrl isKindOfClass:[SlideButton class]])
        {
            SlideButton *pbtn = ctrl;
            VAProcessorProxys *proxy = pbtn.data;
            
            [proxy parseStateInitsValues:obj.param];
            
            float p = fabs(([proxy getAnalogyGain] - minAnalogyGain)/(maxAnalogyGain-minAnalogyGain));
            [pbtn setCircleValue:p];
            
            BOOL isMute = [proxy isProxyMute];
            [pbtn muteSlider:isMute];
        }
    }
}

//value = 0....1
- (void) didSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    float circleValue = minAnalogyGain + (value * (maxAnalogyGain - minAnalogyGain));
    slbtn._valueLabel.text = [NSString stringWithFormat:@"%0.1f dB", circleValue];
    
    id data = slbtn.data;
    if([data isKindOfClass:[VAProcessorProxys class]])
    {
        [(VAProcessorProxys*)data controlDeviceDb:circleValue
                                            force:YES];
        
        [_zengyiSlider setScaleValue:circleValue];
    }
}

- (void) didEndSlideButtonValueChanged:(float)value slbtn:(SlideButton*)slbtn{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        
        id data = slbtn.data;
        if([data isKindOfClass:[VAProcessorProxys class]])
        {
            float circleValue = minAnalogyGain + (value * (maxAnalogyGain - minAnalogyGain));
            
            [(VAProcessorProxys*)data controlDeviceDb:circleValue
                                                force:YES];
            
            [_zengyiSlider setScaleValue:circleValue];
        }
    });

}


#pragma mark ---Engineer Slide ---
- (void) didSliderValueChanged:(float)value object:(id)object {
    
    float circleValue = value;
    
    //批量执行
    NSMutableArray *opts = [NSMutableArray array];
    
    for (SlideButton *button in _selectedBtnArray) {
        
        button._valueLabel.text = [NSString stringWithFormat:@"%0.1f dB", circleValue];
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
        
        button._valueLabel.text = [NSString stringWithFormat:@"%0.1f dB", circleValue];
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
    
    if([opts count]){
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            
            [[RegulusSDK sharedRegulusSDK] ControlDeviceByOperation:opts
                                                         completion:nil];
        });

    }
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
            VAProcessorProxys *proxy = data;
            [proxy checkRgsProxyCommandLoad];
            
            [_zengyiSlider setScaleValue:[proxy getAnalogyGain]];
            
            
            BOOL isMute = [proxy isProxyMute];
            [_zengyiSlider setMuteVal:isMute];
        }
        
        

    } else {
        // remove it
        [_selectedBtnArray removeObject:btn];
        
        [btn enableValueSet:NO];

    }
}

- (void) didLongPressSlideButton:(SlideButton*)slbtn{
    
    VAProcessorProxys* proxy = slbtn.data;
    if([proxy isKindOfClass:[VAProcessorProxys class]])
    {
        NSString *alert = @"修改通道名称";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:alert preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"通道名称";
            textField.text = proxy._rgsProxyObj.name;
            //textField.keyboardType = UIKeyboardTypeDecimalPad;
        }];
        
        
        IMP_BLOCK_SELF(EngineerAudioProcessViewCtrl);
        
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

- (void) resetProxyName:(NSString*)name proxy:(VAProcessorProxys*)proxy slideBtn:(SlideButton*)btn{
    
    btn._titleLabel.text = name;
    proxy._rgsProxyObj.name = name;
    
    [[RegulusSDK sharedRegulusSDK] RenameProxy:proxy._rgsProxyObj.m_id
                                          name:name
                                    completion:nil];
    
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
        [okBtn setTitle:@"关闭" forState:UIControlStateNormal];
        
        isSettings = YES;
    } else {
        if ([_rightView superview]) {
            [_rightView removeFromSuperview];
        }
        [okBtn setTitle:@"设置" forState:UIControlStateNormal];
        isSettings = NO;
    
    }
}

- (void) iconAction:(id)sender{
    
    //如果在显示，消失
    if(CGRectGetMinY(_inconView.frame) < SCREEN_HEIGHT)
    {
        [iBtn setImage:[UIImage imageNamed:@"i_btn_white.png"]
               forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             
                             _inconView.frame  = CGRectMake(0,
                                                            SCREEN_HEIGHT,
                                                            SCREEN_WIDTH,
                                                            100);
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else//如果没显示，显示
    {
        
        [iBtn setImage:[UIImage imageNamed:@"i_btn_yellow.png"]
               forState:UIControlStateNormal];
        
        
        [UIView beginAnimations:nil context:nil];
        _inconView.frame  = CGRectMake(0,
                                       SCREEN_HEIGHT-150,
                                       SCREEN_WIDTH,
                                       100);
        [UIView commitAnimations];
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
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc
{
    [self._proxysMap removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
