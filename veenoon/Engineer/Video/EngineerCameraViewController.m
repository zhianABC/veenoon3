//
//  EngineerCameraViewController.m
//  veenoon
//
//  Created by 安志良 on 2017/12/24.
//  Copyright © 2017年 jack. All rights reserved.
//

#import "EngineerCameraViewController.h"
#import "UIButton+Color.h"
#import "CustomPickerView.h"
#import "VCameraSettingSet.h"
#import "BrandCategoryNoUtil.h"
#import "PlugsCtrlTitleHeader.h"
#import "RegulusSDK.h"
#import "VCameraProxys.h"
#import "KVNProgress.h"

@interface EngineerCameraViewController () <CustomPickerViewDelegate>{
    
    PlugsCtrlTitleHeader *_selectSysBtn;
    
    CustomPickerView *_customPicker;
    
    UIButton *_numberBtn;
    
    UIButton *_volumnMinus;
    UIButton *_lastSing;
    UIButton *_playOrHold;
    UIButton *_nextSing;
    UIButton *_volumnAdd;
    
    BOOL isplay;
    
    UIButton *okBtn;
    
    VCameraSettingSet *_currentObj;
}
@property (nonatomic, strong) VCameraSettingSet *_currentObj;
@end

@implementation EngineerCameraViewController
@synthesize _cameraSysArray;
@synthesize _number;
@synthesize _currentObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_cameraSysArray count]) {
        self._currentObj = [_cameraSysArray objectAtIndex:0];
    }
    
    [super setTitleAndImage:@"video_corner_shexiangji.png" withTitle:video_camera_name];
    
    UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomBar];
    
    //缺切图，把切图贴上即可。
    bottomBar.backgroundColor = [UIColor grayColor];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.image = [UIImage imageNamed:@"botomo_icon.png"];
    
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
              action:@selector(settingsAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    _selectSysBtn = [[PlugsCtrlTitleHeader alloc] initWithFrame:CGRectMake(50, 100, 80, 30)];
    [_selectSysBtn addTarget:self action:@selector(sysSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectSysBtn];
    
    if (_currentObj) {
        NSString *nameStr = [BrandCategoryNoUtil generatePickerValue:_currentObj._brand withCategory:_currentObj._type withNo:_currentObj._deviceno];
        [_selectSysBtn setShowText:nameStr];
    }
    
    int playerLeft = -60;
    int playerHeight = 50;
    
    UIButton *minusBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    minusBtn.frame = CGRectMake(230+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    minusBtn.layer.cornerRadius = 5;
    minusBtn.layer.borderWidth = 2;
    minusBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    minusBtn.clipsToBounds = YES;
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [minusBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    [self.view addSubview:minusBtn];
    
    [minusBtn addTarget:self
                       action:@selector(minusAction:)
             forControlEvents:UIControlEventTouchUpInside];
    
    _numberBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:RGB(0, 89, 118)];
    _numberBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    _numberBtn.layer.cornerRadius = 5;
    _numberBtn.layer.borderWidth = 2;
    _numberBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    _numberBtn.clipsToBounds = YES;
    [_numberBtn setTitle:@"1" forState:UIControlStateNormal];
    [_numberBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateNormal];
    [_numberBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    _numberBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:_numberBtn];
    
    UIButton *invokeBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    invokeBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    invokeBtn.layer.cornerRadius = 5;
    invokeBtn.layer.borderWidth = 2;
    invokeBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    invokeBtn.clipsToBounds = YES;
    [invokeBtn setTitle:@"调用" forState:UIControlStateNormal];
    [invokeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [invokeBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    [self.view addSubview:invokeBtn];
    
    [invokeBtn addTarget:self
                    action:@selector(invokeAction:)
          forControlEvents:UIControlEventTouchDown];
    
    UIButton *addBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    addBtn.frame = CGRectMake(400+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    addBtn.layer.cornerRadius = 5;
    addBtn.layer.borderWidth = 2;
    addBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    addBtn.clipsToBounds = YES;
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    [self.view addSubview:addBtn];
    
    [addBtn addTarget:self
                    action:@selector(addAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *storeBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    storeBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-415+playerHeight, 80, 80);
    storeBtn.layer.cornerRadius = 5;
    storeBtn.layer.borderWidth = 2;
    storeBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    storeBtn.clipsToBounds = YES;
    [storeBtn setTitle:@"存储" forState:UIControlStateNormal];
    [storeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [storeBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    [self.view addSubview:storeBtn];
    
    [storeBtn addTarget:self
                      action:@selector(storeAction:)
            forControlEvents:UIControlEventTouchDown];
    
    playerLeft = 320;
    
    UIButton *tBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    tBtn.frame = CGRectMake(230+playerLeft, SCREEN_HEIGHT-500+playerHeight-85, 80, 80);
    tBtn.layer.cornerRadius = 5;
    tBtn.layer.borderWidth = 2;
    tBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    tBtn.clipsToBounds = YES;
    [tBtn setTitle:@"T" forState:UIControlStateNormal];
    [tBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    [self.view addSubview:tBtn];
    
    [tBtn addTarget:self
                       action:@selector(tAction:)
             forControlEvents:UIControlEventTouchDown];
    
    UIButton *directLeftBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    directLeftBtn.frame = CGRectMake(230+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    directLeftBtn.layer.cornerRadius = 5;
    directLeftBtn.layer.borderWidth = 2;
    directLeftBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    directLeftBtn.clipsToBounds = YES;
    [directLeftBtn setImage:[UIImage imageNamed:@"engineer_left_n.png"] forState:UIControlStateNormal];
    [directLeftBtn setImage:[UIImage imageNamed:@"engineer_left_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:directLeftBtn];
    
    [directLeftBtn addTarget:self
                       action:@selector(directLeftAction:)
             forControlEvents:UIControlEventTouchDown];
    
    [directLeftBtn addTarget:self
                    action:@selector(camerDirectStopAction:)
          forControlEvents:UIControlEventTouchCancel];
    [directLeftBtn addTarget:self
                    action:@selector(camerDirectStopAction:)
          forControlEvents:UIControlEventTouchUpOutside];
    [directLeftBtn addTarget:self
                    action:@selector(camerDirectStopAction:)
          forControlEvents:UIControlEventTouchUpInside];

    UIButton *okPlayerBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    okPlayerBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    okPlayerBtn.layer.cornerRadius = 5;
    okPlayerBtn.layer.borderWidth = 2;
    okPlayerBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    okPlayerBtn.clipsToBounds = YES;
    [okPlayerBtn setTitle:@"ok" forState:UIControlStateNormal];
    [okPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okPlayerBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    okPlayerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:okPlayerBtn];
    
    [okPlayerBtn addTarget:self action:@selector(audioPlayHoldAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *wBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    wBtn.frame = CGRectMake(315+playerLeft+85, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    wBtn.layer.cornerRadius = 5;
    wBtn.layer.borderWidth = 2;
    wBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    wBtn.clipsToBounds = YES;
    [wBtn setTitle:@"W" forState:UIControlStateNormal];
    [wBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [wBtn setTitleColor:RGB(255, 180, 0) forState:UIControlStateHighlighted];
    [self.view addSubview:wBtn];
    
    [wBtn addTarget:self
             action:@selector(wAction:)
   forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *directUpBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    directUpBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
    directUpBtn.layer.cornerRadius = 5;
    directUpBtn.layer.borderWidth = 2;
    directUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    directUpBtn.clipsToBounds = YES;
    [directUpBtn setImage:[UIImage imageNamed:@"engineer_up_n.png"] forState:UIControlStateNormal];
    [directUpBtn setImage:[UIImage imageNamed:@"engineer_up_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:directUpBtn];
    
    [directUpBtn addTarget:self
                      action:@selector(camerDirectUPAction:)
            forControlEvents:UIControlEventTouchDown];
    
    [directUpBtn addTarget:self
                      action:@selector(camerDirectStopAction:)
            forControlEvents:UIControlEventTouchCancel];
    [directUpBtn addTarget:self
                      action:@selector(camerDirectStopAction:)
            forControlEvents:UIControlEventTouchUpOutside];
    [directUpBtn addTarget:self
                      action:@selector(camerDirectStopAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *zoomOutBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    zoomOutBtn.frame = CGRectMake(315+playerLeft+85, SCREEN_HEIGHT-415+playerHeight, 80, 80);
    zoomOutBtn.layer.cornerRadius = 5;
    zoomOutBtn.layer.borderWidth = 2;
    zoomOutBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    zoomOutBtn.clipsToBounds = YES;
    [zoomOutBtn setImage:[UIImage imageNamed:@"engineer_zoom_minus_n.png"] forState:UIControlStateNormal];
    [zoomOutBtn setImage:[UIImage imageNamed:@"engineer_zoom_minus_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:zoomOutBtn];
    
    [zoomOutBtn addTarget:self
                   action:@selector(zoomOutAction:)
         forControlEvents:UIControlEventTouchDown];
    
    [zoomOutBtn addTarget:self
                      action:@selector(zoomStop:)
            forControlEvents:UIControlEventTouchCancel];
    [zoomOutBtn addTarget:self
                      action:@selector(zoomStop:)
            forControlEvents:UIControlEventTouchUpOutside];
    [zoomOutBtn addTarget:self
                      action:@selector(zoomStop:)
            forControlEvents:UIControlEventTouchUpInside];

    [wBtn addTarget:self
                     action:@selector(zoomOutAction:)
           forControlEvents:UIControlEventTouchDown];
    
    
    [wBtn addTarget:self
                     action:@selector(zoomStop:)
           forControlEvents:UIControlEventTouchCancel];
    [wBtn addTarget:self
                     action:@selector(zoomStop:)
           forControlEvents:UIControlEventTouchUpOutside];
    [wBtn addTarget:self
                     action:@selector(zoomStop:)
           forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *directRightBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    directRightBtn.frame = CGRectMake(400+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
    directRightBtn.layer.cornerRadius = 5;
    directRightBtn.layer.borderWidth = 2;
    directRightBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    directRightBtn.clipsToBounds = YES;
    [directRightBtn setImage:[UIImage imageNamed:@"engineer_next_n.png"] forState:UIControlStateNormal];
    [directRightBtn setImage:[UIImage imageNamed:@"engineer_next_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:directRightBtn];
    
    [directRightBtn addTarget:self
                    action:@selector(directRightAction:)
          forControlEvents:UIControlEventTouchDown];
    
    [directRightBtn addTarget:self
                    action:@selector(camerDirectStopAction:)
          forControlEvents:UIControlEventTouchCancel];
    [directRightBtn addTarget:self
                    action:@selector(camerDirectStopAction:)
          forControlEvents:UIControlEventTouchUpOutside];
    [directRightBtn addTarget:self
                    action:@selector(camerDirectStopAction:)
          forControlEvents:UIControlEventTouchUpInside];

    
    
    UIButton *zoomInBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    zoomInBtn.frame = CGRectMake(315+playerLeft-85, SCREEN_HEIGHT-415+playerHeight, 80, 80);
    zoomInBtn.layer.cornerRadius = 5;
    zoomInBtn.layer.borderWidth = 2;
    zoomInBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    zoomInBtn.clipsToBounds = YES;
    [zoomInBtn setImage:[UIImage imageNamed:@"engineer_zoom_add_n.png"] forState:UIControlStateNormal];
    [zoomInBtn setImage:[UIImage imageNamed:@"engineer_zoom_add_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:zoomInBtn];
    
    [zoomInBtn addTarget:self
                   action:@selector(zoomInAction:)
         forControlEvents:UIControlEventTouchDown];
    
    [zoomInBtn addTarget:self
                     action:@selector(zoomStop:)
           forControlEvents:UIControlEventTouchCancel];
    [zoomInBtn addTarget:self
                     action:@selector(zoomStop:)
           forControlEvents:UIControlEventTouchUpOutside];
    [zoomInBtn addTarget:self
                     action:@selector(zoomStop:)
           forControlEvents:UIControlEventTouchUpInside];

    [tBtn addTarget:self
                   action:@selector(zoomOutAction:)
         forControlEvents:UIControlEventTouchDown];
    
    [tBtn addTarget:self
                   action:@selector(zoomStop:)
         forControlEvents:UIControlEventTouchCancel];
    [tBtn addTarget:self
                   action:@selector(zoomStop:)
         forControlEvents:UIControlEventTouchUpOutside];
    [tBtn addTarget:self
                   action:@selector(zoomStop:)
         forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *volumnDownBtn = [UIButton buttonWithColor:RGB(0, 89, 118) selColor:BLUE_DOWN_COLOR];
    volumnDownBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-415+playerHeight, 80, 80);
    volumnDownBtn.layer.cornerRadius = 5;
    volumnDownBtn.layer.borderWidth = 2;
    volumnDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
    volumnDownBtn.clipsToBounds = YES;
    [volumnDownBtn setImage:[UIImage imageNamed:@"engineer_down_n.png"] forState:UIControlStateNormal];
    [volumnDownBtn setImage:[UIImage imageNamed:@"engineer_down_s.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:volumnDownBtn];
    
    [volumnDownBtn addTarget:self
                      action:@selector(camerDirectDownAction:)
            forControlEvents:UIControlEventTouchDown];
    
    [volumnDownBtn addTarget:self
                      action:@selector(camerDirectStopAction:)
            forControlEvents:UIControlEventTouchCancel];
    [volumnDownBtn addTarget:self
                      action:@selector(camerDirectStopAction:)
            forControlEvents:UIControlEventTouchUpOutside];
    [volumnDownBtn addTarget:self
                      action:@selector(camerDirectStopAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    [self getCurrentDeviceDriverProxys];
    
}

- (void) camerDirectStopAction:(id)sender{
    
    VCameraProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam stopControlDeviceDirection];
}

- (void) directLeftAction:(id)sender{
    
    VCameraProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceDirection:@"LEFT"];
}

- (void) directRightAction:(id)sender{
    
    VCameraProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceDirection:@"RIGHT"];
}

- (void) camerDirectUPAction:(id)sender{
    
    VCameraProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceDirection:@"UP"];
}

- (void) camerDirectDownAction:(id)sender{
    
    VCameraProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceDirection:@"DOWN"];
}

- (void) zoomInAction:(id)sender{
    
    VCameraProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceZoom:@"IN"];
}

- (void) zoomOutAction:(id)sender{
    
    VCameraProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceZoom:@"OUT"];
}

- (void) zoomStop:(id)sender{
    
    VCameraProxys *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceZoom:@"STOP"];
}

- (void) getCurrentDeviceDriverProxys{
    
    if(_currentObj == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(EngineerCameraViewController);
    
    RgsDriverObj *driver = _currentObj._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    
                    [block_self loadedCameraProxy:proxys];
                    
                }
            }
            else{
                [KVNProgress showErrorWithStatus:@"中控链接断开！"];
            }
        }];
    }
#endif
}

- (void) loadedCameraProxy:(NSArray*)proxys{
    
    id proxy = self._currentObj._proxyObj;
    
    VCameraProxys *vcam = nil;
    if(proxy && [proxy isKindOfClass:[VCameraProxys class]])
    {
        vcam = proxy;
    }
    else
    {
        vcam = [[VCameraProxys alloc] init];
    }
    
    vcam._rgsProxyObj = [proxys objectAtIndex:0];
    [vcam checkRgsProxyCommandLoad];
    
    if([_currentObj._localSavedProxys count])
    {
        NSDictionary *local = [_currentObj._localSavedProxys objectAtIndex:0];
        [vcam recoverWithDictionary:local];
        
        [_numberBtn setTitle:[NSString stringWithFormat:@"%d", vcam._load]
                    forState:UIControlStateNormal];
    }
    else
    {
        [_numberBtn setTitle:[NSString stringWithFormat:@"%d", vcam._save]
                    forState:UIControlStateNormal];
    }
    
    self._currentObj._proxyObj = vcam;
    [_currentObj syncDriverIPProperty];
    [_currentObj syncDriverComs];
}

- (void) zoomMinusAction:(id)sender{
    
}
- (void) zoomAddAction:(id)sender{
    
}
- (void) wAction:(id)sender{
    
}
- (void) tAction:(id)sender{
    
}


- (void) audioPlayHoldAction:(id)sender{
    if (isplay) {
        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_r_hold.png"] forState:UIControlStateNormal];
        isplay = NO;
    } else {
        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_play.png"] forState:UIControlStateNormal];
        isplay = YES;
    }
}

- (void) addAction:(id)sender{
    NSString *currentValue = _numberBtn.titleLabel.text;
    int value = [currentValue intValue];
    
    value++;
    
    [_numberBtn setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
}

- (void) minusAction:(id)sender{
    NSString *currentValue = _numberBtn.titleLabel.text;
    int value = [currentValue intValue];
    if (value <= 1) {
        return;
    }
    value--;
    
    [_numberBtn setTitle:[NSString stringWithFormat:@"%d", value] forState:UIControlStateNormal];
}

- (void) storeAction:(id)sender{
    
    VCameraProxys *vcam = _currentObj._proxyObj;
    if(vcam){
        
        NSString *currentValue = _numberBtn.titleLabel.text;
        int value = [currentValue intValue];
        vcam._save = value;
        
        [vcam controlDeviceSavePostion];
    }

}

- (void) invokeAction:(id)sender{
    
    VCameraProxys *vcam = _currentObj._proxyObj;
    if(vcam){
        
        NSString *currentValue = _numberBtn.titleLabel.text;
        int value = [currentValue intValue];
        vcam._save = value;
        
        [vcam controlDeviceLoadPostion];
    }
}

- (void) selectCurrentMike:(VCameraSettingSet*)mike{
    
    self._currentObj = mike;
    [self updateCurrentMikeState:mike._deviceno];
}

- (void) updateCurrentMikeState:(NSString *)deviceno{
    
    NSString *nameStr = [BrandCategoryNoUtil generatePickerValue:_currentObj._brand withCategory:_currentObj._type withNo:_currentObj._deviceno];
    [_selectSysBtn setShowText:nameStr];

}

- (void) sysSelectAction:(id)sender{
    
    [self.view addSubview:_dActionView];
    
    IMP_BLOCK_SELF(EngineerCameraViewController);
    _dActionView._callback = ^(int tagIndex, id obj)
    {
        [block_self selectCurrentMike:obj];
    };
    
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for(VCameraSettingSet *mike in _cameraSysArray) {
        NSString *nameStr = [BrandCategoryNoUtil generatePickerValue:mike._brand withCategory:mike._type withNo:mike._deviceno];
        [arr addObject:@{@"object":mike,@"name":nameStr}];
    }
    
    _dActionView._selectIndex = _currentObj._index;
    [_dActionView setSelectDatas:arr];
    
}
- (void) chooseDeviceAtIndex:(int)idx{
    
    self._currentObj = [_cameraSysArray objectAtIndex:idx];
    
    [self updateCurrentMikeState:_currentObj._deviceno];
    
}

#pragma mark -- Right View Delegate ---
- (void) dissmissSettingView{
    [self handleTapGesture:nil];
}


- (void) handleTapGesture:(id)sender{
    
    [okBtn setTitle:@"设置" forState:UIControlStateNormal];
}


- (void) settingsAction:(id)sender{
    
}

- (void) cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
