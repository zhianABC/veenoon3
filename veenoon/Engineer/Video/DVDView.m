//
//  DVDView.m
//  veenoon
//
//  Created by chen jack on 2018/9/9.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "DVDView.h"
#import "RegulusSDK.h"
#import "VDVDPlayerSet.h"
#import "KVNProgress.h"
#import "VDVDPlayerProxy.h"
#import "UIButton+Color.h"

@interface DVDView (){
    
    UIButton *_volumnMinus;
    UIButton *_lastSing;
    UIButton *_playOrHold;
    UIButton *_nextSing;
    UIButton *_volumnAdd;
    
    BOOL isplay;
    
    UIButton *_luboBtn;
    UIButton *_tanchuBtn;
    UIButton *_addressBtn;
    
    UIButton *okBtn;
    BOOL isSettings;

}

@end

@implementation DVDView
@synthesize _currentObj;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        int height = SCREEN_HEIGHT - 150;
        int width = 80;
        
        
        _volumnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
        _volumnMinus.frame = CGRectMake(0, 0, width, width);
        _volumnMinus.center = CGPointMake(SCREEN_WIDTH/2 - 120, height);
        [_volumnMinus setImage:[UIImage imageNamed:@"audio_player_r_minus_n.png"] forState:UIControlStateNormal];
        [_volumnMinus setImage:[UIImage imageNamed:@"audio_player_minus_s.png"] forState:UIControlStateHighlighted];
        [_volumnMinus addTarget:self action:@selector(menuVoiceSub:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_volumnMinus];
        
        _lastSing = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastSing.frame = CGRectMake(0, 0, width, width);
        _lastSing.center = CGPointMake(SCREEN_WIDTH/2 - 60, height);
        [_lastSing setImage:[UIImage imageNamed:@"audio_player_r_last_n.png"] forState:UIControlStateNormal];
        [_lastSing setImage:[UIImage imageNamed:@"audio_player_last_s.png"] forState:UIControlStateHighlighted];
        [_lastSing addTarget:self action:@selector(menuPrevAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_lastSing];
        
        isplay = NO;
        _playOrHold = [UIButton buttonWithType:UIButtonTypeCustom];
        _playOrHold.frame = CGRectMake(0, 0, width, width);
        _playOrHold.center = CGPointMake(SCREEN_WIDTH/2, height);
        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_play.png"] forState:UIControlStateNormal];
        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_r_hold.png"] forState:UIControlStateHighlighted];
        [_playOrHold addTarget:self action:@selector(audioPlayHoldAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playOrHold];
        
        _nextSing = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextSing.frame = CGRectMake(0, 0, width, width);
        _nextSing.center = CGPointMake(SCREEN_WIDTH/2 + 60, height);
        [_nextSing setImage:[UIImage imageNamed:@"audio_player_r_next_n.png"] forState:UIControlStateNormal];
        [_nextSing setImage:[UIImage imageNamed:@"audio_player_next_s.png"] forState:UIControlStateHighlighted];
        [_nextSing addTarget:self action:@selector(menuNextAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextSing];
        
        _volumnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        _volumnAdd.frame = CGRectMake(0, 0, width, width);
        _volumnAdd.center = CGPointMake(SCREEN_WIDTH/2 + 120, height);
        [_volumnAdd setImage:[UIImage imageNamed:@"audio_layer_r_next_n.png"] forState:UIControlStateNormal];
        [_volumnAdd setImage:[UIImage imageNamed:@"audio_layer_next_s.png"] forState:UIControlStateHighlighted];
        [_volumnAdd addTarget:self action:@selector(menuVoiceAdd:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_volumnAdd];
        
        
        _luboBtn = [UIButton buttonWithColor:nil selColor:nil];
        _luboBtn.frame = CGRectMake(SCREEN_WIDTH-112, 70, 60, 60);
        _luboBtn.layer.cornerRadius = 5;
        _luboBtn.layer.borderWidth = 2;
        _luboBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        _luboBtn.clipsToBounds = YES;
        [_luboBtn setImage:[UIImage imageNamed:@"engineer_lubo_n.png"] forState:UIControlStateNormal];
        [_luboBtn setImage:[UIImage imageNamed:@"engineer_lubo_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:_luboBtn];
        
        [_luboBtn addTarget:self
                     action:@selector(powerAction:)
           forControlEvents:UIControlEventTouchUpInside];
        
        
        _tanchuBtn = [UIButton buttonWithColor:nil selColor:nil];
        _tanchuBtn.frame = CGRectMake(SCREEN_WIDTH - 182, 70, 60, 60);
        _tanchuBtn.layer.cornerRadius = 5;
        _tanchuBtn.layer.borderWidth = 2;
        _tanchuBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        _tanchuBtn.clipsToBounds = YES;
        [_tanchuBtn setImage:[UIImage imageNamed:@"engineer_tanchu_n.png"] forState:UIControlStateNormal];
        [_tanchuBtn setImage:[UIImage imageNamed:@"engineer_tanchu_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:_tanchuBtn];
        
        [_tanchuBtn addTarget:self
                       action:@selector(tanchuAction:)
             forControlEvents:UIControlEventTouchUpInside];
        
        _addressBtn = [UIButton buttonWithColor:nil selColor:nil];
        _addressBtn.frame = CGRectMake(SCREEN_WIDTH - 252, 70, 60, 60);
        _addressBtn.layer.cornerRadius = 5;
        _addressBtn.layer.borderWidth = 2;
        _addressBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        _addressBtn.clipsToBounds = YES;
        [_addressBtn setImage:[UIImage imageNamed:@"engineer_address_n.png"] forState:UIControlStateNormal];
        [_addressBtn setImage:[UIImage imageNamed:@"engineer_address_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:_addressBtn];
        
        [_addressBtn addTarget:self
                        action:@selector(detailAction:)
              forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *lastVideoUpBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
        lastVideoUpBtn.frame = CGRectMake(0, 0, 80, 80);
        lastVideoUpBtn.layer.cornerRadius = 5;
        lastVideoUpBtn.layer.borderWidth = 2;
        lastVideoUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        lastVideoUpBtn.clipsToBounds = YES;
        [lastVideoUpBtn setImage:[UIImage imageNamed:@"engineer_left_n.png"] forState:UIControlStateNormal];
        [lastVideoUpBtn setImage:[UIImage imageNamed:@"engineer_left_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:lastVideoUpBtn];
        
        [lastVideoUpBtn addTarget:self
                           action:@selector(menuLeftAction:)
                 forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *okPlayerBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
        okPlayerBtn.frame = CGRectMake(0, 0, 80, 80);
        okPlayerBtn.layer.cornerRadius = 5;
        okPlayerBtn.layer.borderWidth = 2;
        okPlayerBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        okPlayerBtn.clipsToBounds = YES;
        [okPlayerBtn setTitle:@"OK" forState:UIControlStateNormal];
        [okPlayerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okPlayerBtn setTitleColor:NEW_ER_BUTTON_SD_COLOR forState:UIControlStateHighlighted];
        okPlayerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:okPlayerBtn];
        
        [okPlayerBtn addTarget:self action:@selector(okPlayAction:)
              forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *volumnUpBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
        volumnUpBtn.frame = CGRectMake(0, 0, 80, 80);
        volumnUpBtn.layer.cornerRadius = 5;
        volumnUpBtn.layer.borderWidth = 2;
        volumnUpBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        volumnUpBtn.clipsToBounds = YES;
        [volumnUpBtn setImage:[UIImage imageNamed:@"engineer_up_n.png"] forState:UIControlStateNormal];
        [volumnUpBtn setImage:[UIImage imageNamed:@"engineer_up_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:volumnUpBtn];
        
        [volumnUpBtn addTarget:self
                        action:@selector(menuUpAction:)
              forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *nextPlayBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
        nextPlayBtn.frame = CGRectMake(0, 0, 80, 80);
        nextPlayBtn.layer.cornerRadius = 5;
        nextPlayBtn.layer.borderWidth = 2;
        nextPlayBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        nextPlayBtn.clipsToBounds = YES;
        [nextPlayBtn setImage:[UIImage imageNamed:@"engineer_next_n.png"] forState:UIControlStateNormal];
        [nextPlayBtn setImage:[UIImage imageNamed:@"engineer_next_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:nextPlayBtn];
        
        [nextPlayBtn addTarget:self
                        action:@selector(menuRightAction:)
              forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *volumnDownBtn = [UIButton buttonWithColor:NEW_ER_BUTTON_GRAY_COLOR2 selColor:NEW_ER_BUTTON_BL_COLOR];
        volumnDownBtn.frame = CGRectMake(0, 0, 80, 80);
        volumnDownBtn.layer.cornerRadius = 5;
        volumnDownBtn.layer.borderWidth = 2;
        volumnDownBtn.layer.borderColor = [UIColor clearColor].CGColor;;
        volumnDownBtn.clipsToBounds = YES;
        [volumnDownBtn setImage:[UIImage imageNamed:@"engineer_down_n.png"] forState:UIControlStateNormal];
        [volumnDownBtn setImage:[UIImage imageNamed:@"engineer_down_s.png"] forState:UIControlStateHighlighted];
        [self addSubview:volumnDownBtn];
        
        [volumnDownBtn addTarget:self
                          action:@selector(menuDownAction:)
                forControlEvents:UIControlEventTouchUpInside];
        
        
        okPlayerBtn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        lastVideoUpBtn.center = CGPointMake(SCREEN_WIDTH/2-85, SCREEN_HEIGHT/2);
        volumnUpBtn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-85);
        volumnDownBtn.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2+85);
        nextPlayBtn.center = CGPointMake(SCREEN_WIDTH/2+85, SCREEN_HEIGHT/2);
        
    }
    
    return self;
}



- (void) loadCurrentDeviceDriverProxys{
    
    if(_currentObj == nil)
        return;
    
#ifdef OPEN_REG_LIB_DEF
    
    IMP_BLOCK_SELF(DVDView);
    
    RgsDriverObj *driver = _currentObj._driver;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    
                    [block_self loadedDVDDriverProxy:proxys];
                    
                }
            }
            else{
                [KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    }
#endif
}

- (void) loadedDVDDriverProxy:(NSArray*)proxys{
    
    id proxy = self._currentObj._proxyObj;
    
    VDVDPlayerProxy *vcam = nil;
    if(proxy && [proxy isKindOfClass:[VDVDPlayerProxy class]])
    {
        vcam = proxy;
    }
    else
    {
        vcam = [[VDVDPlayerProxy alloc] init];
    }
    
    vcam._rgsProxyObj = [proxys objectAtIndex:0];
    [vcam checkRgsProxyCommandLoad];
    
    self._currentObj._proxyObj = vcam;
    
}


- (void) okPlayAction:(id)sender {
    
    
}
- (void) powerAction:(id)sender{
    
    VDVDPlayerProxy *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceMenu:@"Power"];
}

- (void) menuVoiceSub:(id)sender{
    
    
}
- (void) menuVoiceAdd:(id)sender{
    
    
}
- (void) menuPrevAction:(id)sender{
    
    VDVDPlayerProxy *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceMenu:@"PREV"];
}
- (void) menuNextAction:(id)sender{
    
    VDVDPlayerProxy *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceMenu:@"NEXT"];
}


- (void) tanchuAction:(id)sender{
    
    VDVDPlayerProxy *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceMenu:@"DISC_OPEN"];
}
- (void) detailAction:(id)sender{
    
    VDVDPlayerProxy *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceMenu:@"DETAIL"];
}


- (void) audioPlayHoldAction:(id)sender{
    if (isplay) {
        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_play.png"] forState:UIControlStateNormal];
        isplay = NO;
        
        VDVDPlayerProxy *vcam = _currentObj._proxyObj;
        if(vcam)
            [vcam controlDeviceMenu:@"PAUSE"];
        
    } else {
        [_playOrHold setImage:[UIImage imageNamed:@"audio_player_r_hold.png"] forState:UIControlStateNormal];
        isplay = YES;
        
        VDVDPlayerProxy *vcam = _currentObj._proxyObj;
        if(vcam)
            [vcam controlDeviceMenu:@"PLAY"];
    }
}


- (void) menuUpAction:(id)sender{
    
    VDVDPlayerProxy *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceMenu:@"UP"];
}

- (void) menuRightAction:(id)sender{
    
    VDVDPlayerProxy *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceMenu:@"RIGHT"];
}

- (void) menuDownAction:(id)sender{
    
    VDVDPlayerProxy *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceMenu:@"DOWN"];
}

- (void) menuLeftAction:(id)sender{
    
    VDVDPlayerProxy *vcam = _currentObj._proxyObj;
    if(vcam)
        [vcam controlDeviceMenu:@"LEFT"];
}

@end
