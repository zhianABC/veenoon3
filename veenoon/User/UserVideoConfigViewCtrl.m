//
//  UserVideoConfigViewCtrl.m
//  veenoon
//
//  Created by 安志良 on 2017/11/28.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "UserVideoConfigViewCtrl.h"
#import "UserVideoConfigView.h"
#import "UserVideoDVDDiskViewCtrl.h"
#import "UserVideoCameraSettingsViewCtrl.h"
#import "UserVideoRemoteShiXunViewCtrl.h"
#import "UserVideoLuBoJiViewCtrl.h"
#import "Scenario.h"
#import "VVideoProcessSet.h"
#import "VVideoProcessSetProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

#import "PlugsCtrlTitleHeader.h"
#import "TeslariaComboChooser.h"

#import "VCameraSettingSet.h"


@interface UserVideoConfigViewCtrl () <UserVideoConfigViewDelegate, VVideoProcessSetProxyDelegate, UIPopoverPresentationControllerDelegate> {
   
    int inputMin;
    int inputMax;
    
    int outputMax;
    int outputMin;
    
    
    UserVideoConfigView *_contrlPanl;
    
    PlugsCtrlTitleHeader *_selectSysBtn;
    TeslariaComboChooser *_chooser;
}
@property (nonatomic, strong) NSMutableArray *_inputDevices;
@property (nonatomic, strong) NSMutableArray *_outputDevices;
@property (nonatomic, strong) VVideoProcessSet *_curProcessor;
@property (nonatomic, strong) VVideoProcessSetProxy *_currentProxy;

@property (nonatomic, strong) NSMutableArray *_videoProcessers;


@end

@implementation UserVideoConfigViewCtrl
@synthesize _inputDevices;
@synthesize _outputDevices;
@synthesize _scenario;
@synthesize _curProcessor;
@synthesize _currentProxy;

@synthesize _videoProcessers;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setTitleAndImage:@"user_corner_video.png" withTitle:@"视频处理器"];
    
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
    
   
    _contrlPanl = [[UserVideoConfigView alloc]
                               initWithFrame:CGRectMake(0, 0,
                                                        SCREEN_WIDTH,
                                                        SCREEN_HEIGHT-114)];
    [self.view addSubview:_contrlPanl];
    
    //找出所有的视频处理器
    self._videoProcessers = [NSMutableArray array];
    for(BasePlugElement *plug in _scenario._videoDevices)
    {
        if([plug isKindOfClass:[VVideoProcessSet class]]){
            [_videoProcessers addObject:plug];
        }
    }
    
    if([_videoProcessers count])
        self._curProcessor = [_videoProcessers objectAtIndex:0];
    
    
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
    
    if([_videoProcessers count] > 1)
    {
        
        NSMutableArray *options = [NSMutableArray array];
        for(int i = 0; i < [_videoProcessers count]; i++)
        {
            
            VVideoProcessSet *plug = [_videoProcessers objectAtIndex:i];
            
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
        
        IMP_BLOCK_SELF(UserVideoConfigViewCtrl);
        _chooser._block = ^(id object, int index) {
            
            [block_self changeDevice:index];
        };
        
    }
    
}

- (void) changeDevice:(int)idx{
    
    VVideoProcessSet *plug = [_videoProcessers objectAtIndex:idx];
    
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
       // NSString *idStr = @"Unk";
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
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(UserVideoConfigViewCtrl);
    
    RgsDriverObj *driver = _curProcessor._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [KVNProgress show];
        
        [[RegulusSDK sharedRegulusSDK] GetDriverCommands:driver.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
            
            [KVNProgress dismiss];
            
            if (result) {
                if ([commands count]) {
                    [block_self loadedVideoCommands:commands];
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }
#endif
}


- (void) loadedVideoCommands:(NSArray*)cmds{
    
    RgsDriverObj *driver = _curProcessor._driver;
    
    id proxy = self._curProcessor._proxyObj;
    
    if(proxy && [proxy isKindOfClass:[VVideoProcessSetProxy class]])
    {
        self._currentProxy = proxy;
    }
    
    if(_currentProxy)
    {
        self._curProcessor._proxyObj = _currentProxy;
        
        _currentProxy.delegate = self;
        _currentProxy._deviceId = driver.m_id;
        [_currentProxy checkRgsProxyCommandLoad:cmds];
        
    }
    
}


- (void) loadedVideoProcessorProxy:(NSArray*)proxys{
    
    id proxy = self._curProcessor._proxyObj;
    
    if(proxy && [proxy isKindOfClass:[VVideoProcessSetProxy class]])
    {
        self._currentProxy = proxy;
    }
    
    if(_currentProxy)
    {
        _currentProxy.delegate = self;
        _currentProxy._rgsProxyObj = [proxys objectAtIndex:0];
        [_currentProxy checkRgsProxyCommandLoad:nil];
        
        self._curProcessor._proxyObj = _currentProxy;
    }
    
}

- (void) didLoadedProxyCommand {
    
    _currentProxy.delegate = nil;
    
    NSDictionary *inputSettings = [_currentProxy getVideoProcessInputSettings];
    
    inputMin = [[inputSettings objectForKey:@"min"] intValue];
    inputMax = [[inputSettings objectForKey:@"max"] intValue];
    
    NSDictionary *outputSettings = [_currentProxy getVideoProcessOutputSettings];
    
    outputMin = [[outputSettings objectForKey:@"min"] intValue];
    outputMax = [[outputSettings objectForKey:@"max"] intValue];
    
    [self updateView];
}

- (void) updateView{
    
    self._inputDevices = [NSMutableArray array];
    self._outputDevices = [NSMutableArray array];
    
    NSDictionary *inputs = _currentProxy._inputDevices;
    
    for(int i = inputMin; i <= inputMax; i++)
    {
        id key = [NSString stringWithFormat:@"%d", i];
        
        if([inputs objectForKey:key])
        {
            [self._inputDevices addObject:[inputs objectForKey:key]];
        }
        else
        {
            [self._inputDevices addObject:@{@"ctrl_val":key}];
        }
        
    }
    
    NSDictionary *outputs = _currentProxy._outputDevices;
    
    for(int i = outputMin; i <= outputMax; i++)
    {
        id key = [NSString stringWithFormat:@"%d", i];
        
        if([outputs objectForKey:key])
        {
            [self._outputDevices addObject:[outputs objectForKey:key]];
        }
        else
        {
            [self._outputDevices addObject:@{@"ctrl_val":key}];
        }
        
    }
   
    _contrlPanl._inputDatas = self._inputDevices;
    _contrlPanl._outputDatas = self._outputDevices;
    _contrlPanl.delegate_ = self;
    [_contrlPanl show];
 
    [_contrlPanl createP2P:_currentProxy._deviceMatcherDic];
}

- (void) didControlInOutState:(NSDictionary*)inSrc
                       outSrc:(NSDictionary*)outSrc
                       linked:(BOOL)linked{
    
    if(_currentProxy)
    {
        if(linked)
        {
        [_currentProxy controlDeviceAdd:inSrc
                          withOutDevice:outSrc];
        }
        else
        {
            [_currentProxy controlDeviceRemove:inSrc
                              withOutDevice:outSrc];
        }
    }
    
}


- (void) didPupConfigView:(StickerLayerView*)sticker {
    NSDictionary *dic = sticker._element;
    
    //NSString *deviceName = [dic objectForKey:@"name"];
    NSString *class = [dic objectForKey:@"class"];
        
    if(class)
    {
        BasePlugElement * target = nil;
        NSString *driverid = [dic objectForKey:@"driverid"];
        
        if(driverid)
        {
            for(BasePlugElement *obj in _scenario._videoDevices)
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
            if([target isKindOfClass:[VDVDPlayerSet class]])
            {
                UserVideoDVDDiskViewCtrl *ctrl = [[UserVideoDVDDiskViewCtrl alloc] init];
                ctrl._currentProcessor = (VDVDPlayerSet*) target;
                [self.navigationController pushViewController:ctrl animated:YES];
            }
            else if([target isKindOfClass:[VCameraSettingSet class]])
            {
                UserVideoCameraSettingsViewCtrl *ctrl = [[UserVideoCameraSettingsViewCtrl alloc] init];
                ctrl._currentProcessor = (VCameraSettingSet*) target;
                [self.navigationController pushViewController:ctrl animated:YES];
            }
        }
        
    }
        
//    if ([@"远程视讯" isEqualToString:deviceName]) {
//        UserVideoRemoteShiXunViewCtrl *ctrl = [[UserVideoRemoteShiXunViewCtrl alloc] init];
//        [self.navigationController pushViewController:ctrl animated:YES];
//    }
//    if ([deviceName containsString:video_camera_name]) {
//        UserVideoCameraSettingsViewCtrl *ctrl = [[UserVideoCameraSettingsViewCtrl alloc] init];
//        [self.navigationController pushViewController:ctrl animated:YES];
//    }
//    if ([@"录播机" isEqualToString:deviceName]) {
//        UserVideoLuBoJiViewCtrl *ctrl = [[UserVideoLuBoJiViewCtrl alloc] init];
//        [self.navigationController pushViewController:ctrl animated:YES];
//    }
}

- (void) okAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
