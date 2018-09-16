//
//  CameraView.m
//  veenoon
//
//  Created by chen jack on 2018/9/9.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "CameraView.h"
#import "UIButton+Color.h"
#import "RegulusSDK.h"
#import "VCameraProxys.h"
#import "VCameraSettingSet.h"
#import "KVNProgress.h"

@interface CameraView ()
{
    UIButton *_numberBtn;
}

@end

@implementation CameraView
@synthesize _vCamera;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame withButtonColor:(UIColor*) color withButtonSelColor:(UIColor*) selColor
{
    if(self = [super initWithFrame:frame])
    {
        
        int playerLeft = -60;
        int playerHeight = 85;
        
        UIButton *minusBtn = [UIButton buttonWithColor:color selColor:selColor];
        minusBtn.frame = CGRectMake(230+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
        minusBtn.layer.cornerRadius = 5;
        minusBtn.layer.borderWidth = 2;
        minusBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        minusBtn.clipsToBounds = YES;
        [minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [minusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [minusBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        [self addSubview:minusBtn];
        
        [minusBtn addTarget:self
                     action:@selector(minusAction:)
           forControlEvents:UIControlEventTouchUpInside];
        
        _numberBtn = [UIButton buttonWithColor:color selColor:selColor];
        _numberBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
        _numberBtn.layer.cornerRadius = 5;
        _numberBtn.layer.borderWidth = 2;
        _numberBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        _numberBtn.clipsToBounds = YES;
        [_numberBtn setTitle:@"1" forState:UIControlStateNormal];
        [_numberBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateNormal];
        [_numberBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        _numberBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self addSubview:_numberBtn];
        
        UIButton *invokeBtn = [UIButton buttonWithColor:color selColor:selColor];
        invokeBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
        invokeBtn.layer.cornerRadius = 5;
        invokeBtn.layer.borderWidth = 2;
        invokeBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        invokeBtn.clipsToBounds = YES;
        [invokeBtn setTitle:@"调用" forState:UIControlStateNormal];
        [invokeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [invokeBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        [self addSubview:invokeBtn];
        
        [invokeBtn addTarget:self
                      action:@selector(invokeAction:)
            forControlEvents:UIControlEventTouchDown];
        
        UIButton *addBtn = [UIButton buttonWithColor:color selColor:selColor];
        addBtn.frame = CGRectMake(400+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
        addBtn.layer.cornerRadius = 5;
        addBtn.layer.borderWidth = 2;
        addBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        addBtn.clipsToBounds = YES;
        [addBtn setTitle:@"+" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        [self addSubview:addBtn];
        
        [addBtn addTarget:self
                   action:@selector(addAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *storeBtn = [UIButton buttonWithColor:color selColor:selColor];
        storeBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-415+playerHeight, 80, 80);
        storeBtn.layer.cornerRadius = 5;
        storeBtn.layer.borderWidth = 2;
        storeBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        storeBtn.clipsToBounds = YES;
        [storeBtn setTitle:@"存储" forState:UIControlStateNormal];
        [storeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [storeBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        [self addSubview:storeBtn];
        
        [storeBtn addTarget:self
                     action:@selector(storeAction:)
           forControlEvents:UIControlEventTouchDown];
        
        playerLeft = 320;
        
        UIButton *tBtn = [UIButton buttonWithColor:color selColor:selColor];
        tBtn.frame = CGRectMake(230+playerLeft, SCREEN_HEIGHT-500+playerHeight-85, 80, 80);
        tBtn.layer.cornerRadius = 5;
        tBtn.layer.borderWidth = 2;
        tBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        tBtn.clipsToBounds = YES;
        [tBtn setTitle:@"T" forState:UIControlStateNormal];
        [tBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        [self addSubview:tBtn];
        
        [tBtn addTarget:self
                 action:@selector(tAction:)
       forControlEvents:UIControlEventTouchDown];
        
        UIButton *directLeftBtn = [UIButton buttonWithColor:color selColor:selColor];
        directLeftBtn.frame = CGRectMake(230+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
        directLeftBtn.layer.cornerRadius = 5;
        directLeftBtn.layer.borderWidth = 2;
        directLeftBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        directLeftBtn.clipsToBounds = YES;
        [directLeftBtn setImage:[UIImage imageNamed:@"engineer_left_n.png"] forState:UIControlStateNormal];
        [directLeftBtn setImage:[UIImage imageNamed:@"engineer_left_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:directLeftBtn];
        
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
        
        UIButton *okPlayerBtn = [UIButton buttonWithColor:color selColor:selColor];
        okPlayerBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
        okPlayerBtn.layer.cornerRadius = 5;
        okPlayerBtn.layer.borderWidth = 2;
        okPlayerBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        okPlayerBtn.clipsToBounds = YES;
        [okPlayerBtn setTitle:@"ok" forState:UIControlStateNormal];
        [okPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okPlayerBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        okPlayerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        [self addSubview:okPlayerBtn];
        
        [okPlayerBtn addTarget:self action:@selector(audioPlayHoldAction:)
              forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *wBtn = [UIButton buttonWithColor:color selColor:selColor];
        wBtn.frame = CGRectMake(315+playerLeft+85, SCREEN_HEIGHT-585+playerHeight, 80, 80);
        wBtn.layer.cornerRadius = 5;
        wBtn.layer.borderWidth = 2;
        wBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        wBtn.clipsToBounds = YES;
        [wBtn setTitle:@"W" forState:UIControlStateNormal];
        [wBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [wBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        [self addSubview:wBtn];
        
        [wBtn addTarget:self
                 action:@selector(wAction:)
       forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *directUpBtn = [UIButton buttonWithColor:color selColor:selColor];
        directUpBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-585+playerHeight, 80, 80);
        directUpBtn.layer.cornerRadius = 5;
        directUpBtn.layer.borderWidth = 2;
        directUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        directUpBtn.clipsToBounds = YES;
        [directUpBtn setImage:[UIImage imageNamed:@"engineer_up_n.png"] forState:UIControlStateNormal];
        [directUpBtn setImage:[UIImage imageNamed:@"engineer_up_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:directUpBtn];
        
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
        
        
        UIButton *zoomOutBtn = [UIButton buttonWithColor:color selColor:selColor];
        zoomOutBtn.frame = CGRectMake(315+playerLeft+85, SCREEN_HEIGHT-415+playerHeight, 80, 80);
        zoomOutBtn.layer.cornerRadius = 5;
        zoomOutBtn.layer.borderWidth = 2;
        zoomOutBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        zoomOutBtn.clipsToBounds = YES;
        [zoomOutBtn setImage:[UIImage imageNamed:@"engineer_zoom_minus_n.png"] forState:UIControlStateNormal];
        [zoomOutBtn setImage:[UIImage imageNamed:@"engineer_zoom_minus_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:zoomOutBtn];
        
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
        
        
        UIButton *directRightBtn = [UIButton buttonWithColor:color selColor:selColor];
        directRightBtn.frame = CGRectMake(400+playerLeft, SCREEN_HEIGHT-500+playerHeight, 80, 80);
        directRightBtn.layer.cornerRadius = 5;
        directRightBtn.layer.borderWidth = 2;
        directRightBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        directRightBtn.clipsToBounds = YES;
        [directRightBtn setImage:[UIImage imageNamed:@"engineer_next_n.png"] forState:UIControlStateNormal];
        [directRightBtn setImage:[UIImage imageNamed:@"engineer_next_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:directRightBtn];
        
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
        
        
        
        UIButton *zoomInBtn = [UIButton buttonWithColor:color selColor:selColor];
        zoomInBtn.frame = CGRectMake(315+playerLeft-85, SCREEN_HEIGHT-415+playerHeight, 80, 80);
        zoomInBtn.layer.cornerRadius = 5;
        zoomInBtn.layer.borderWidth = 2;
        zoomInBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        zoomInBtn.clipsToBounds = YES;
        [zoomInBtn setImage:[UIImage imageNamed:@"engineer_zoom_add_n.png"] forState:UIControlStateNormal];
        [zoomInBtn setImage:[UIImage imageNamed:@"engineer_zoom_add_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:zoomInBtn];
        
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
        
        
        UIButton *volumnDownBtn = [UIButton buttonWithColor:color selColor:selColor];
        volumnDownBtn.frame = CGRectMake(315+playerLeft, SCREEN_HEIGHT-415+playerHeight, 80, 80);
        volumnDownBtn.layer.cornerRadius = 5;
        volumnDownBtn.layer.borderWidth = 2;
        volumnDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        volumnDownBtn.clipsToBounds = YES;
        [volumnDownBtn setImage:[UIImage imageNamed:@"engineer_down_n.png"] forState:UIControlStateNormal];
        [volumnDownBtn setImage:[UIImage imageNamed:@"engineer_down_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:volumnDownBtn];
        
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
        
    }
    
    return self;
}


- (void) camerDirectStopAction:(id)sender{
    
    VCameraProxys *vcam = _vCamera._proxyObj;
    if(vcam)
        [vcam stopControlDeviceDirection];
}

- (void) directLeftAction:(id)sender{
    
    VCameraProxys *vcam = _vCamera._proxyObj;
    if(vcam)
        [vcam controlDeviceDirection:@"LEFT"];
}

- (void) directRightAction:(id)sender{
    
    VCameraProxys *vcam = _vCamera._proxyObj;
    if(vcam)
        [vcam controlDeviceDirection:@"RIGHT"];
}

- (void) camerDirectUPAction:(id)sender{
    
    VCameraProxys *vcam = _vCamera._proxyObj;
    if(vcam)
        [vcam controlDeviceDirection:@"UP"];
}

- (void) camerDirectDownAction:(id)sender{
    
    VCameraProxys *vcam = _vCamera._proxyObj;
    if(vcam)
        [vcam controlDeviceDirection:@"DOWN"];
}

- (void) zoomInAction:(id)sender{
    
    VCameraProxys *vcam = _vCamera._proxyObj;
    if(vcam)
        [vcam controlDeviceZoom:@"IN"];
}

- (void) zoomOutAction:(id)sender{
    
    VCameraProxys *vcam = _vCamera._proxyObj;
    if(vcam)
        [vcam controlDeviceZoom:@"OUT"];
}

- (void) zoomStop:(id)sender{
    
    VCameraProxys *vcam = _vCamera._proxyObj;
    if(vcam)
        [vcam controlDeviceZoom:@"STOP"];
}

- (void) loadCurrentDeviceDriver{
    
    if(_vCamera == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(CameraView);
    
    RgsDriverObj *driver = _vCamera._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    
                    [block_self loadedCameraProxy:proxys];
                    
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }
#endif
}

- (void) loadedCameraProxy:(NSArray*)proxys{
    
    id proxy = self._vCamera._proxyObj;
    
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
    
    if(vcam._load)
    {
        [_numberBtn setTitle:[NSString stringWithFormat:@"%d", vcam._load]
                    forState:UIControlStateNormal];
        
    }
    else
    {
        [_numberBtn setTitle:[NSString stringWithFormat:@"%d", vcam._save]
                    forState:UIControlStateNormal];
    }
    
    self._vCamera._proxyObj = vcam;
    //[_vCamera syncDriverIPProperty];
    [_vCamera syncDriverComs];
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
//    if (isplay) {
//        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_r_hold.png"] forState:UIControlStateNormal];
//        isplay = NO;
//    } else {
//        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_play.png"] forState:UIControlStateNormal];
//        isplay = YES;
//    }
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
    
    VCameraProxys *vcam = _vCamera._proxyObj;
    if(vcam){
        
        NSString *currentValue = _numberBtn.titleLabel.text;
        int value = [currentValue intValue];
        vcam._save = value;
        
        [vcam controlDeviceSavePostion];
    }
    
}

- (void) invokeAction:(id)sender{
    
    VCameraProxys *vcam = _vCamera._proxyObj;
    if(vcam){
        
        NSString *currentValue = _numberBtn.titleLabel.text;
        int value = [currentValue intValue];
        vcam._save = value;
        
        [vcam controlDeviceLoadPostion];
    }
}


@end
