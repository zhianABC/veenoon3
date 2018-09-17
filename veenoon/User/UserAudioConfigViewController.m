//
//  UserAudioConfigViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/11/23.
//  Copyright © 2017年 jack. All rights reserved.
//
#import "UserAudioConfigViewController.h"
#import "UserAudioPlayerSettingsViewCtrl.h"
#import "UserWuXianHuaTongViewCtrl.h"
#import "UserHuiYinViewController.h"
#import "UserYouXianViewController.h"
#import "UserDVDSettingsViewController.h"
#import "IconCenterTextButton.h"

#import "JSlideView.h"
#import "Scenario.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "AudioEProcessor.h"
#import "VAProcessorProxys.h"
#import "AudioEMix.h"
#import "DataSync.h"

#import "PlugsCtrlTitleHeader.h"
#import "TeslariaComboChooser.h"

@interface UserAudioConfigViewController () <JSlideViewDelegate, UIPopoverPresentationControllerDelegate> {
    
    
    IconCenterTextButton *_cdPlayerBtn;
    IconCenterTextButton *_sdPlayersBtn;
    IconCenterTextButton *_usbPlayersBtn;
    IconCenterTextButton *_dvdPlayerBtn;
    IconCenterTextButton *_wuxianhuatongBtn;
    IconCenterTextButton *_ejinhuiyi1Btn;
    IconCenterTextButton *_youxianPlayer2Btn;
    IconCenterTextButton *_youxianPlayer3Btn;
    
    JSlideView *_cdPlayerSlider;
    JSlideView *_sdPlayerSlider;
    JSlideView *_usbPlayerSlider;
    JSlideView *_wuxianPlayerSlider;
    JSlideView *_hunyinPlayerSlider;
    JSlideView *_youxianPlayerSlider;
    JSlideView *_youxianPlayerSlider2;
    JSlideView *_wuxianSysPlayerSlider;
    
    UIScrollView *_proxysView;
    
    PlugsCtrlTitleHeader *_selectSysBtn;
    TeslariaComboChooser *_chooser;
}

@property (nonatomic, strong) NSArray *_proxys;
@property (nonatomic, strong) NSMutableArray *_inputProxys;
@property (nonatomic, strong) NSMutableArray *_inputBtnArray;
@property (nonatomic, strong) AudioEProcessor *_curProcessor;

@property (nonatomic, strong) NSMutableArray *_iconBtns;

@property (nonatomic, strong) NSMutableArray *_audioProcessers;

@end

@implementation UserAudioConfigViewController
@synthesize _curProcessor;
@synthesize _proxys;
@synthesize _inputProxys;
@synthesize _inputBtnArray;
@synthesize _scenario;

@synthesize _iconBtns;
@synthesize _audioProcessers;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleAndImage:@"user_corner_audio.png" withTitle:@"音频系统"];
    
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

    
    //找出所有的音频处理器
    self._audioProcessers = [NSMutableArray array];
    for(BasePlugElement *plug in _scenario._audioDevices)
    {
        if([plug isKindOfClass:[AudioEProcessor class]]){
            [_audioProcessers addObject:plug];
        }
    }
    
    if([_audioProcessers count])
        self._curProcessor = [_audioProcessers objectAtIndex:0];
    
    
    _selectSysBtn = [[PlugsCtrlTitleHeader alloc] initWithFrame:CGRectMake(50, 100, 80, 30)];
    [self.view addSubview:_selectSysBtn];
    [_selectSysBtn addTarget:self
                      action:@selector(chooseDevice:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    [self refreshCurrentProcessor];
}

- (void) refreshCurrentProcessor{
    
    [self showBasePluginName:self._curProcessor];
    self._iconBtns = [NSMutableArray array];
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
    
    if([_audioProcessers count] > 1)
    {
    
        NSMutableArray *options = [NSMutableArray array];
        for(int i = 0; i < [_audioProcessers count]; i++)
        {
            
            AudioEProcessor *plug = [_audioProcessers objectAtIndex:i];
            
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
        
        IMP_BLOCK_SELF(UserAudioConfigViewController);
        _chooser._block = ^(id object, int index) {
            
            [block_self changeDevice:index];
        };
        
    }
    
}

- (void) changeDevice:(int)idx{
    
    AudioEProcessor *plug = [_audioProcessers objectAtIndex:idx];
    
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
    if([_curProcessor._inAudioProxys count] && [_curProcessor._outAudioProxys count])
    {
        [self initChannels];
        return;
    }
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(UserAudioConfigViewController);
    
    RgsDriverObj *driver = _curProcessor._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        
        [KVNProgress show];
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            
            [KVNProgress dismiss];
            
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


- (void) initChannels{
    
    //清空一下
    self._inputProxys = [NSMutableArray array];
    self._inputBtnArray = [NSMutableArray array];
    
    //如果有，就不需要重新请求了
    if([_curProcessor._inAudioProxys count] )
    {
        self._inputProxys = _curProcessor._inAudioProxys;
    }
    else
    {
        for(RgsProxyObj *proxy in _proxys)
        {
            if([proxy.type isEqualToString:@"Audio In"])
            {
                VAProcessorProxys *vap = [[VAProcessorProxys alloc] init];
                vap._rgsProxyObj = proxy;
                [_inputProxys addObject:vap];
            }
        }
        _curProcessor._inAudioProxys = _inputProxys;
        
    }
    
    [[_proxysView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    
    ///加载输出输出Proxy的Commands数据
    [_curProcessor prepareAllAudioInCmds];
    
    int sliderHeight = 475-64;
    int sliderLeftRight = 90;
    
    int count = (int)[_inputProxys count];
    int pages = count/8;
    if(count%8 > 0)
    {
        pages++;
    }
    
    for (int i = 0; i < [_inputProxys count]; i++) {
        
        
        if(i % 8 == 0 && i)
        {
            sliderLeftRight = i/8 * SCREEN_WIDTH+90;
        }
        
        VAProcessorProxys *vap = [_inputProxys objectAtIndex:i];
        
        
        JSlideView *sliderCtrl = [[JSlideView alloc]
                           initWithSliderBg:[UIImage imageNamed:@"v_slider_bg_light.png"]
                           frame:CGRectZero];
        [_proxysView addSubview:sliderCtrl];
        [sliderCtrl setRoadImage:[UIImage imageNamed:@"v_slider_road.png"]];
        sliderCtrl.topEdge = 54;
        sliderCtrl.bottomEdge = 54;
        sliderCtrl.maxValue = 12;
        sliderCtrl.minValue = -70;
        sliderCtrl.isUnLineStyle = YES;
        [sliderCtrl resetScale];
        sliderCtrl.delegate = self;
        sliderCtrl.data = vap;
        sliderCtrl.center = CGPointMake(sliderLeftRight, sliderHeight);
        
        [sliderCtrl setScaleValue:[vap getAnalogyGain]];
        
        if(vap._voiceInDevice)
        {
            
            NSString *icon = [vap._voiceInDevice objectForKey:@"user_show_icon"];
            NSString *icon_s = [vap._voiceInDevice objectForKey:@"user_show_icon_s"];
            NSString *name = [vap._voiceInDevice objectForKey:@"name"];
            if(icon && icon_s && name)
            {
                IconCenterTextButton* inDevice = [[IconCenterTextButton alloc]
                                                  initWithFrame:CGRectMake(0, 0, 150, 150)];
                [inDevice buttonWithIcon:[UIImage imageNamed:icon]
                            selectedIcon:[UIImage imageNamed:icon_s]
                                    text:name
                             normalColor:NEW_UR_BUTTON_GRAY_COLOR
                                selColor:NEW_ER_BUTTON_SD_COLOR];
                
                inDevice.vdata = vap._voiceInDevice;
                
                inDevice.center = CGPointMake(sliderLeftRight, CGRectGetMinY(sliderCtrl.frame) - 130);
                [inDevice addTarget:self action:@selector(inDeviceAction:) forControlEvents:UIControlEventTouchUpInside];
                
                UILongPressGestureRecognizer *longPress0 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed0:)];
                [inDevice addGestureRecognizer:longPress0];
                
                [_proxysView addSubview:inDevice];
                [_iconBtns addObject:inDevice];
            }

        }
        
        
        sliderLeftRight+=120;
    
    }
    
    int ww1 = pages*SCREEN_WIDTH;
   
    
    _proxysView.contentSize = CGSizeMake(ww1, _proxysView.frame.size.height);
    _proxysView.pagingEnabled = YES;
    
}

- (void) didSliderValueChanged:(float)value object:(id)object{
    
    JSlideView *jsl = object;
    if(jsl && [jsl isKindOfClass:[JSlideView class]])
    {
        id data = jsl.data;
        if([data isKindOfClass:[VAProcessorProxys class]])
        {
            [(VAProcessorProxys*)data controlDeviceDb:value
                                                force:YES];
            
        }
    }
    
    _proxysView.scrollEnabled = NO;
}
- (void) didSliderEndChanged:(id)object{
    
    JSlideView *jsl = object;
    if(jsl && [jsl isKindOfClass:[JSlideView class]])
    {
        id data = jsl.data;
        if([data isKindOfClass:[VAProcessorProxys class]])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                
                float value = [jsl getScaleValue];
                [(VAProcessorProxys*)data controlDeviceDb:value
                                                    force:YES];
            });
            
        }
    }
    
    _proxysView.scrollEnabled = YES;
}

- (void) didSliderMuteChanged:(BOOL)mute object:(id)object{
    
    JSlideView *jsl = object;
    if(jsl && [jsl isKindOfClass:[JSlideView class]])
    {
        id data = jsl.data;
        if([data isKindOfClass:[VAProcessorProxys class]])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            
                [(VAProcessorProxys*)data controlDigtalMute:mute];
            });
            
        }
    }
}


- (void) okAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) longPressed0:(id)sender{
    
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        // no need anything here
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        
        id btn = press.view;
        
        if([btn isKindOfClass:[IconCenterTextButton class]])
        {
            IconCenterTextButton *icbtn = (IconCenterTextButton*)btn;
            NSDictionary *data = icbtn.vdata;
            NSString *name = [data objectForKey:@"name"];
            NSString *class = [data objectForKey:@"class"];
            
            if([name isEqualToString:@"播放器"]
               || [name isEqualToString:@"硬盘存储器"]
               || [name isEqualToString:@"SD"])
            {
                UserAudioPlayerSettingsViewCtrl *controller = [[UserAudioPlayerSettingsViewCtrl alloc] init];
                controller.playerState = CDPlayer;
                [self.navigationController pushViewController:controller animated:YES];

            }
            else if([name isEqualToString:@"USB"])
            {
                UserDVDSettingsViewController *controller = [[UserDVDSettingsViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else if([name isEqualToString:@"无线麦"])
            {
                UserWuXianHuaTongViewCtrl *controller = [[UserWuXianHuaTongViewCtrl alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else if([name isEqualToString:@"有线麦"])
            {
                UserYouXianViewController *controller = [[UserYouXianViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else if(class && [class isEqualToString:@"AudioEMix"])
            {
                BasePlugElement * target = nil;
                NSString *driverid = [data objectForKey:@"driverid"];

                if(driverid)
                {
                    for(BasePlugElement *obj in _scenario._audioDevices)
                    {
                        if(obj._driver)
                        {
                            RgsDriverObj *driver = obj._driver;
                            if(driver.m_id == [driverid integerValue]){
                                target = obj;
                                break;
                            }
                        }
                    }
                }
                if(target)
                {
                    UserHuiYinViewController *controller = [[UserHuiYinViewController alloc] init];
                    controller._processor = (AudioEMix*)target;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
        
        
    }
}


- (void) inDeviceAction:(IconCenterTextButton*)sender{
   
    for(IconCenterTextButton *icbtn in _iconBtns)
    {
        if(icbtn == sender)
        {
            [icbtn setBtnHighlited:YES];
        }
        else
        {
            [icbtn setBtnHighlited:NO];
        }
    }
    
}

@end
