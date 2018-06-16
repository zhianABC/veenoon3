//
//  VAProcessorProxys.m
//  veenoon
//
//  Created by chen jack on 2018/5/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "VAProcessorProxys.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

/*
 SET_MUTE
 SET_UNMUTE
 SET_DIGIT_MUTE | options [True, False]
 SET_DIGIT_GRAIN
 SET_ANALOGY_GRAIN
 SET_INVERTED
 SET_MODE     | options [LINE, MIC]
 SET_MIC_DB   | options [.....]
 SET_48V      | ENABLE
 SET_NOISE_GATE
 SET_FB_CTRL
 SET_PRESS_LIMIT
 SET_DELAY
 SET_HIGH_FILTER
 SET_LOW_FILTER
 SET_PEQ
 */

@interface VAProcessorProxys ()
{
    float _voiceDb;
    BOOL _isMute;
    BOOL _isDigitalMute;
    float _digitalGain;
    
    BOOL _inverted;
    
    
    BOOL _isSetOK;
    
    BOOL _isFanKuiYiZhiStarted;
    BOOL _isZiDongHunYinStarted;
}
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;

@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;


@end

@implementation VAProcessorProxys
@synthesize delegate;

@synthesize _icon_name;
@synthesize _voiceInDevice;

@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;

@synthesize _mode;
@synthesize _is48V;
@synthesize _micDb;
@synthesize _isFanKuiYiZhiStarted;
@synthesize _isZiDongHunYinStarted;
@synthesize _zidonghunyinZengYi;
@synthesize _isHuiShengXiaoChu;
@synthesize _yanshiqiSlide;
@synthesize _yanshiqiYingChi;
@synthesize _yanshiqiMi;
@synthesize _yanshiqiHaoMiao;
@synthesize _yaxianFazhi;
@synthesize _yaxianXielv;
@synthesize _yaxianStartTime;
@synthesize _yaxianRecoveryTime;
@synthesize _zaoshengFazhi;
@synthesize _zaoshengHuifuTime;
@synthesize _zaoshengStartTime;
@synthesize _isZaoshengStarted;
@synthesize _lvbojunhengGaotongType;
@synthesize _lvboDitongArray;
@synthesize _lvboGaotongArray;
@synthesize _lvbojunhengDitongType;
@synthesize _RgsSceneDeviceOperationShadow;
@synthesize _lvboGaotongXielvArray;
@synthesize _lvbojunhengGaotongXielv;
@synthesize _lvboDitongXielvArray;
@synthesize _lvbojunhengDitongXielv;
@synthesize _lvboBoDuanArray;
@synthesize _lvbojunhengBoduanType;
@synthesize _islvboGaotongStart;
@synthesize _islvboBoduanStart;
@synthesize _islvboDitongStart;
@synthesize _lvboGaotongPinLv;
@synthesize _lvboBoduanPinlv;
@synthesize _lvboBoduanZengyi;
@synthesize _lvboBoduanQ;
@synthesize _lvboDitongPinlv;

@synthesize _xinhaofashengPinlv;
@synthesize _xinhaofashengZengyi;
@synthesize _xinhaofashengPinlvArray;
@synthesize _isXinhaofashengMute;
@synthesize _dianpingPinlv;
@synthesize _dianpingZengyi;
@synthesize _dianpingfanxiang;
@synthesize _isdianpingMute;
@synthesize _xinhaozhengxuanbo;
@synthesize _xinhaozhengxuanArray;

- (id) init
{
    if(self = [super init])
    {
        _isMute = NO;
        _isDigitalMute = NO;
        _voiceDb = 0;
        _digitalGain = 0;
        
        _inverted = NO;
        self._is48V = NO;
        self._micDb = @"0db";
        
        self._mode = @"LINE"; //LINE or MIC
        
        self._icon_name = nil;
        
        _isSetOK = NO;
        
        _isFanKuiYiZhiStarted = YES;
        _isZiDongHunYinStarted = YES;
        _zidonghunyinZengYi = @"12.0";
        _isHuiShengXiaoChu = YES;
        
        _yanshiqiHaoMiao = @"3333";
        _yanshiqiMi = @"2222";
        _yanshiqiYingChi = @"1111";
        _yanshiqiSlide = @"0";
        
        _yaxianFazhi = @"-50";
        _yaxianXielv = @"5";
        _yaxianStartTime = @"20";
        _yaxianRecoveryTime = @"20";
        
        _zaoshengFazhi = @"9";
        _zaoshengStartTime = @"222";
        _zaoshengHuifuTime = @"333";
        _isZaoshengStarted = YES;
        
        
        _lvbojunhengGaotongType = @"巴特沃斯";
        _lvboGaotongArray = [NSArray arrayWithObjects:@"巴特沃斯", @"科沃斯", @"巴塞罗那", nil];
        
        _lvbojunhengDitongType = @"皇马";
        _lvboDitongArray = [NSArray arrayWithObjects:@"曼联", @"利物浦", @"切尔西", nil];
        
        _lvboGaotongXielvArray = [NSArray arrayWithObjects:@"黄蜂", @"湖人", @"火箭", nil];
        _lvbojunhengGaotongXielv = @"雷霆";
        
        _lvboDitongXielvArray = [NSArray arrayWithObjects:@"快船", @"公牛", @"骑士", nil];
        _lvbojunhengDitongXielv = @"活塞";
        
        _lvbojunhengBoduanType = @"山猫";
        _lvboBoDuanArray = [NSArray arrayWithObjects:@"76人", @"小牛", @"太阳", nil];
        
        _lvbojunhengGaotongXielv = @"-10";
        _lvboGaotongPinLv = @"8";
        _lvboDitongPinlv = @"2";
        _lvboBoduanQ = @"4";
        _lvboBoduanZengyi = @"5";
        _lvboBoduanPinlv = @"6";
        
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSDictionary *)getScenarioSliceLocatedShadow{
    
    return _RgsSceneDeviceOperationShadow;
}

- (void) recoverWithDictionary:(NSDictionary *)data
{
    NSInteger proxy_id = [[data objectForKey:@"proxy_id"] integerValue];
    
    if(!_rgsProxyObj || (_rgsProxyObj && (proxy_id == _rgsProxyObj.m_id)))
    {
        self._icon_name = [data objectForKey:@"icon_name"];
        
        self._voiceInDevice = [data objectForKey:@"voiceInDevice"];
        
        _voiceDb = [[data objectForKey:@"analogy_gain"] floatValue];
        _isMute = [[data objectForKey:@"analogy_mute"] boolValue];
        
        _digitalGain = [[data objectForKey:@"digital_gain"] floatValue];
        _isDigitalMute = [[data objectForKey:@"digital_mute"] boolValue];
        
        self._mode = [data objectForKey:@"mode"];
        self._micDb = [data objectForKey:@"mic_db"];
        
        _is48V = [[data objectForKey:@"48v"] boolValue];
        
        _inverted = [[data objectForKey:@"inverted"] boolValue];
        
        
        
        
        if([data objectForKey:@"RgsSceneDeviceOperation"]){
            self._RgsSceneDeviceOperationShadow = [data objectForKey:@"RgsSceneDeviceOperation"];
            _isSetOK = YES;
        }

    }
}

- (NSArray*)getModeOptions{

    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_MODE"];
    if(cmd)
    {
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                return param_info.available;
            }
            
        }
    }
    
    return nil;
}

- (NSArray*)getMicDbOptions{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_MIC_DB"];
    if(cmd)
    {
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                return param_info.available;
            }
            
        }
    }
    
    return nil;
}

- (NSDictionary*)getPressLimitOptions{
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_PRESS_LIMIT"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"TH"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"TH_max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"TH_min"];
                }
                else if([param_info.name isEqualToString:@"SL"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"SL_max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"SL_min"];
                }
                else if([param_info.name isEqualToString:@"START_DUR"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"START_DUR_max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"START_DUR_min"];
                }
                else if([param_info.name isEqualToString:@"RECOVER_DUR"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"RECOVER_DUR_max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"RECOVER_DUR_min"];
                }
            }
        }
    }
    
    return result;
}


- (BOOL) isProxyMute{
    
    return _isMute;
}

- (BOOL) isFanKuiYiZhiStarted{
    
    return _isFanKuiYiZhiStarted;
}

- (BOOL) isZiDongHunYinStarted{
    
    return _isZiDongHunYinStarted;
}

- (BOOL) isProxyDigitalMute{
    
    return _isDigitalMute;
}
- (float) getDigitalGain{

    return _digitalGain;
}

- (float) getAnalogyGain{
    
    return _voiceDb;
}

- (BOOL) getInverted{
    
    return _inverted;
}

- (BOOL) isSetChanged{
    
    return _isSetOK;
}

- (void) callDelegateDidLoad{
    
    if(delegate && [delegate respondsToSelector:@selector(didLoadedProxyCommand)])
    {
        [delegate didLoadedProxyCommand];
    }
}

- (void) checkRgsProxyCommandLoad{
    
    if(_rgsProxyObj == nil || _rgsCommands){
        
        if(delegate && [delegate respondsToSelector:@selector(didLoadedProxyCommand)])
        {
            [delegate didLoadedProxyCommand];
        }
        
        return;
    }
    
    self._cmdMap = [NSMutableDictionary dictionary];
    
    IMP_BLOCK_SELF(VAProcessorProxys);
    
    [KVNProgress show];
    
    [[RegulusSDK sharedRegulusSDK] GetProxyCommands:_rgsProxyObj.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
        
        [KVNProgress dismiss];
        
        if (result)
        {
            if ([commands count]) {
                
                block_self._rgsCommands = commands;
                for(RgsCommandInfo *cmd in commands)
                {
                    [block_self._cmdMap setObject:cmd forKey:cmd.name];
                }
                
                _isSetOK = YES;
                
                [block_self callDelegateDidLoad];
            }
        }
        else
        {
            NSString *errorMsg = [NSString stringWithFormat:@"%@ - proxyid:%d",
                               [error description], (int)_rgsProxyObj.m_id];
            
            [KVNProgress showErrorWithStatus:errorMsg];
            
            [block_self callDelegateDidLoad];
            
            [KVNProgress dismiss];
        }
       
    }];
}




//SET_ANALOGY_GRAIN
- (void) controlDeviceDb:(float)db force:(BOOL)force{

    _voiceDb = db;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_ANALOGY_GRAIN"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_FLOAT)
            {
                [param setObject:[NSString stringWithFormat:@"%0.1f",_voiceDb]
                          forKey:param_info.name];
            }
        }
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:^(BOOL result, NSError *error) {
            if (result) {
                
            }
            else{
                
            }
        }];
    }
}

- (void) controlDeviceDigitalGain:(float)digVal{
    
    _digitalGain = digVal;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_DIGIT_GRAIN"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_FLOAT)
            {
                [param setObject:[NSString stringWithFormat:@"%0.1f",digVal]
                          forKey:param_info.name];
            }
            else if(param_info.type == RGS_PARAM_TYPE_INT)
            {
                [param setObject:[NSString stringWithFormat:@"%0.0f",digVal]
                          forKey:param_info.name];
            }
        }
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:^(BOOL result, NSError *error) {
                                                   if (result) {
                                                       
                                                   }
                                                   else{
                                                       
                                                   }
                                               }];
    }
}
- (void) controlDeviceMute:(BOOL)isMute{
    
    RgsCommandInfo *cmd = nil;
    if(isMute)
    {
        cmd = [_cmdMap objectForKey:@"SET_MUTE"];
        
        _isMute = YES;
    }
    else
    {
        cmd = [_cmdMap objectForKey:@"SET_UNMUTE"];
        
        _isMute = NO;
    }
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:^(BOOL result, NSError *error) {
                                                   if (result) {
                                                       
                                                   }
                                                   else{
                                                       
                                                   }
                                               }];
    }
}

- (void) controlInverted:(BOOL)invert{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_INVERTED"];
    NSString* tureOrFalse = @"False";
    if(invert)
    {
        tureOrFalse = @"True";
        _inverted = YES;
    }
    else
    {
        tureOrFalse = @"False";
        _inverted = NO;
    }
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:tureOrFalse forKey:param_info.name];
            }
            
        }
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:^(BOOL result, NSError *error) {
                                                   if (result) {
                                                       
                                                   }
                                                   else{
                                                       
                                                   }
                                               }];
    }
}
- (NSString*) getYanshiqiSlide {
    return _yanshiqiSlide;
}
- (void) controlYanshiqiSlide:(NSString*) yanshiqiSlide {
    _yanshiqiSlide = yanshiqiSlide;
}
- (NSString*) getYanshiqiYingChi {
    return _yanshiqiYingChi;
}
- (void) controlYanshiqiYingChi:(NSString*) yanshiqiYingChi {
    _yanshiqiYingChi = yanshiqiYingChi;
}
- (NSString*) getYanshiqiMi {
    return _yanshiqiMi;
}
- (void) controlYanshiqiMi:(NSString*) yanshiqiMi {
    _yanshiqiMi = yanshiqiMi;
}
- (NSString*) getYanshiqiHaoMiao {
    return _yanshiqiHaoMiao;
}
- (void) controlYanshiqiHaoMiao:(NSString*) yanshiqiHaoMiao {
    _yanshiqiHaoMiao = yanshiqiHaoMiao;
}
- (void) controlHuiShengXiaoChu:(BOOL)isHuiShengXiaoChu {
    _isHuiShengXiaoChu = isHuiShengXiaoChu;
}
- (BOOL) isHuiShengXiaoChuStarted {
    return _isHuiShengXiaoChu;
}


- (void) controlFanKuiYiZhi:(BOOL)isFanKuiYiZhiStarted { 
    _isFanKuiYiZhiStarted = isFanKuiYiZhiStarted;
}

- (void) controlZiDongHunYin:(BOOL)isZiDongHunYinStarted {
    _isZiDongHunYinStarted = isZiDongHunYinStarted;
}
- (NSString*) getZidonghuiyinZengYi {
    return _zidonghunyinZengYi;
}
- (void) controlZiDongHunYinZengYi:(NSString*) zengyiDB {
    self._zidonghunyinZengYi = zengyiDB;
}

- (NSString*) getYaxianFazhi {
    return _yaxianFazhi;
}
- (void) controlYaxianFazhi:(NSString*) yaxianFazhi {
    
    self._yaxianFazhi = yaxianFazhi;
    
    RgsCommandInfo *cmd = nil;
    RgsCommandParamInfo * cmd_param_info = nil;
    cmd = [_cmdMap objectForKey:@"SET_PRESS_LIMIT"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"TH"])
                {
                    cmd_param_info = param_info;
                    break;
                }
                
            }
            
            if(cmd_param_info)
            {
                if(cmd_param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.1f",
                                      [yaxianFazhi floatValue]]
                              forKey:cmd_param_info.name];
                }
                else if(cmd_param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0f",
                                      [yaxianFazhi floatValue]]
                              forKey:cmd_param_info.name];
                }
                
                [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                         cmd:cmd.name
                                                       param:param completion:^(BOOL result, NSError *error) {
                                                           if (result) {
                                                               
                                                           }
                                                           else{
                                                               
                                                           }
                                                       }];
            }
            
        }
    }
    
}
- (NSString*) getYaxianXielv {
    return _yaxianXielv;
}
- (void) controlYaxianXielv:(NSString*) yaxianXielv {
    
    self._yaxianXielv = yaxianXielv;
    
    RgsCommandInfo *cmd = nil;
    RgsCommandParamInfo * cmd_param_info = nil;
    cmd = [_cmdMap objectForKey:@"SET_PRESS_LIMIT"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"SL"])
                {
                    cmd_param_info = param_info;
                    break;
                }
                
            }
            
            if(cmd_param_info)
            {
                if(cmd_param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.1f",
                                      [yaxianXielv floatValue]]
                              forKey:cmd_param_info.name];
                }
                else if(cmd_param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0f",
                                      [yaxianXielv floatValue]]
                              forKey:cmd_param_info.name];
                }
                
                [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                         cmd:cmd.name
                                                       param:param completion:^(BOOL result, NSError *error) {
                                                           if (result) {
                                                               
                                                           }
                                                           else{
                                                               
                                                           }
                                                       }];
            }
            
        }
    }
    
}
- (NSString*) getYaxianStartTime {
    return _yaxianStartTime;
}
- (void) controlYaxianStartTime:(NSString*) yaxianStartTime {
    
    self._yaxianStartTime = yaxianStartTime;
    
    RgsCommandInfo *cmd = nil;
    RgsCommandParamInfo * cmd_param_info = nil;
    cmd = [_cmdMap objectForKey:@"SET_PRESS_LIMIT"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"START_DUR"])
                {
                    cmd_param_info = param_info;
                    break;
                }
                
            }
            
            if(cmd_param_info)
            {
                if(cmd_param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.1f",
                                      [yaxianStartTime floatValue]]
                              forKey:cmd_param_info.name];
                }
                else if(cmd_param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0f",
                                      [yaxianStartTime floatValue]]
                              forKey:cmd_param_info.name];
                }
                
                [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                         cmd:cmd.name
                                                       param:param completion:^(BOOL result, NSError *error) {
                                                           if (result) {
                                                               
                                                           }
                                                           else{
                                                               
                                                           }
                                                       }];
            }
            
        }
    }
    
}
- (NSString*) getYaxianRecoveryTime {
    return _yaxianRecoveryTime;
}
- (void) controlYaxianRecoveryTime:(NSString*) yaxianRecoveryTime {
    
    self._yaxianRecoveryTime = yaxianRecoveryTime;
    
    RgsCommandInfo *cmd = nil;
    RgsCommandParamInfo * cmd_param_info = nil;
    cmd = [_cmdMap objectForKey:@"SET_PRESS_LIMIT"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"RECOVER_DUR"])
                {
                    cmd_param_info = param_info;
                    break;
                }
                
            }
            
            if(cmd_param_info)
            {
                if(cmd_param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.1f",
                                      [yaxianRecoveryTime floatValue]]
                              forKey:cmd_param_info.name];
                }
                else if(cmd_param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0f",
                                      [yaxianRecoveryTime floatValue]]
                              forKey:cmd_param_info.name];
                }
                
                [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                         cmd:cmd.name
                                                       param:param completion:^(BOOL result, NSError *error) {
                                                           if (result) {
                                                               
                                                           }
                                                           else{
                                                               
                                                           }
                                                       }];
            }
            
        }
    }
    
}

- (BOOL) isZaoshengStarted {
    return _isZaoshengStarted;
}
- (void) controlZaoshengStarted:(BOOL)isZaoshengStarted {
    self._isZaoshengStarted = isZaoshengStarted;
}
- (NSString*) getZaoshengFazhi {
    return _zaoshengFazhi;
}
- (void) controlZaoshengFazhi:(NSString*) zaoshengFazhi {
    self._zaoshengFazhi = zaoshengFazhi;
}
- (NSString*) getZaoshengStartTime {
    return self._zaoshengStartTime;
}
- (void) controlZaoshengStartTime:(NSString*) zaoshengStartTime {
    self._zaoshengStartTime = zaoshengStartTime;
}
- (NSString*) getZaoshengRecoveryTime {
    return self._zaoshengHuifuTime;
}
- (void) controlZaoshengRecoveryTime:(NSString*) zaoshengHuifuTime {
    self._zaoshengHuifuTime = zaoshengHuifuTime;
}


- (NSString*) getGaoTongType {
    return self._lvbojunhengGaotongType;
}
- (void) controlGaoTongType:(NSString*) gaotongType {
    self._lvbojunhengGaotongType = gaotongType;
}

- (NSArray*) getLvBoGaoTongArray {
    return self._lvboGaotongArray;
}

- (NSString*) getDiTongType {
    return self._lvbojunhengDitongType;
}
- (void) controlDiTongType:(NSString*) ditongtype {
    self._lvbojunhengDitongType = ditongtype;
}
- (NSArray*) getLvBoDiTongArray {
    return self._lvboDitongArray;
}

- (NSString*) getGaoTongXieLv {
    return self._lvbojunhengGaotongXielv;
}
- (void) controlGaoTongXieLv:(NSString*) gaotongxielv {
    self._lvbojunhengGaotongXielv = gaotongxielv;
}
- (NSArray*) getLvBoGaoTongXielvArray {
    return self._lvboGaotongXielvArray;
}

- (NSString*) getDiTongXieLv {
    return self._lvbojunhengDitongXielv;
}
- (void) controlDiTongXieLv:(NSString*) ditongxielv {
    self._lvbojunhengDitongXielv = ditongxielv;
}
- (NSArray*) getLvBoDiTongXielvArray {
    return _lvboDitongXielvArray;
}

- (NSString*) getBoduanType {
    return _lvbojunhengBoduanType;
}
- (void) controlBoduanType:(NSString*) boduanType {
    self._lvbojunhengBoduanType = boduanType;
}
- (NSArray*) getLvBoBoDuanArray {
    return _lvboBoDuanArray;
}

- (BOOL) isLvboGaotongStart {
    return self._islvboGaotongStart;
}
- (void) controlLVboGaotongStart:(BOOL) lvboGaotongStart {
    self._islvboGaotongStart = lvboGaotongStart;
}

- (NSString*) getLvboGaotongPinlv {
    return self._lvboGaotongPinLv;
}
- (void) controlLvBoGaotongPinlv:(NSString*) lvbogaotongPinlv {
    self._lvboGaotongPinLv = lvbogaotongPinlv;
}

- (BOOL) islvboBoduanStart {
    return self._islvboBoduanStart;
}
- (void) controllvboBoduanStart:(BOOL) lvboBoduanStart {
    self._islvboBoduanStart = lvboBoduanStart;
}

- (NSString*) getlvboBoduanPinlv {
    return self._lvboBoduanPinlv;
}
- (void) controllvboBoduanPinlv:(NSString*) lvboBoduanPinlv {
    self._lvboBoduanPinlv = lvboBoduanPinlv;
}

- (NSString*) getlvboBoduanZengyi {
    return self._lvboBoduanZengyi;
}
- (void) controllvboBoduanZengyi:(NSString*) lvboBoduanZengyi {
    self._lvboBoduanZengyi = lvboBoduanZengyi;
}

-(NSString*) getlvboBoduanQ {
    return self._lvboBoduanQ;
}
-(void) controllvboBoduanQ:(NSString*) lvboBoduanQ {
    self._lvboBoduanQ = lvboBoduanQ;
}

-(BOOL) islvboDitongStart {
    return self._islvboDitongStart;
}
-(void) controllvboDitongStart:(BOOL) lvboDitongStart {
    self._islvboDitongStart = lvboDitongStart;
}

-(NSString*) getlvboDitongPinlv {
    return self._lvboDitongPinlv;
}
-(void) controllvboDitongPinlv:(NSString*) lvboDitongPinlv {
    self._lvboDitongPinlv = lvboDitongPinlv;
}

-(NSString*) getXinhaofashengPinlv {
    return _xinhaofashengPinlv;
}
-(void) controlXinHaofashengPinlv:(NSString*)xinhaofashengPinlv {
    self._xinhaofashengPinlv = xinhaofashengPinlv;
}
-(NSArray*) getXinhaofashengPinlvArray {
    return self._xinhaofashengPinlvArray;
}
-(NSString*) getXinhaoZhengxuanbo {
    return self._xinhaozhengxuanbo;
}
-(void) controlXinhaoZhengxuanbo:(NSString*)zhengxuanbo {
    self._xinhaozhengxuanbo = zhengxuanbo;
}
-(NSArray*) getXinhaofashengZhengxuanArray {
    return self._xinhaozhengxuanArray;
}
-(BOOL) isXinhaofashengMute {
    return self._isXinhaofashengMute;
}
-(void) controlXinhaofashengMute:(BOOL)xinhaofashengMute {
    self._isXinhaofashengMute = xinhaofashengMute;
}
-(NSString*) getXinhaofashengZengyi {
    return _xinhaofashengZengyi;
}
-(void) controlXinhaofashengZengyi:(NSString*)xinhaofashengZengyi {
    self._xinhaofashengZengyi = xinhaofashengZengyi;
}

-(NSString*) getDianpingPinlv {
    return _dianpingPinlv;
}
-(void) controlDianpingPinlv:(NSString*)dianpingPinlv {
    self._dianpingPinlv = dianpingPinlv;
}
-(NSString*) getDianpingfanxiang {
    return _dianpingfanxiang;
}
-(void) controlDianpingfanxian:(NSString*)dianpingfanxiang {
    self._dianpingfanxiang = dianpingfanxiang;
}
-(BOOL) isDianpingMute {
    return self._isdianpingMute;
}
-(void) controlDianpingMute:(BOOL)dianpingMute {
    self._isdianpingMute = dianpingMute;
}
-(NSString*) getDianpingZengyi {
    return self._dianpingZengyi;
}
-(void) controlDianpingZengyi:(NSString*)dianpingZengyi {
    self._dianpingZengyi = dianpingZengyi;
}

- (void) controlDigtalMute:(BOOL)isMute{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_DIGIT_MUTE"];
    NSString* tureOrFalse = @"False";
    if(isMute)
    {
        tureOrFalse = @"True";
        _isDigitalMute = YES;
    }
    else
    {
        tureOrFalse = @"False";
        _isDigitalMute = NO;
    }
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:tureOrFalse forKey:param_info.name];
            }
           
        }
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:^(BOOL result, NSError *error) {
                                                   if (result) {
                                                       
                                                   }
                                                   else{
                                                       
                                                   }
                                               }];
    }
}

- (void) control48V:(BOOL)is48v{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_48V"];
    NSString* tureOrFalse = @"False";
    
    self._is48V = is48v;
    
    if(_is48V)
    {
        tureOrFalse = @"True";
    }
    else
    {
        tureOrFalse = @"False";
    }
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:tureOrFalse forKey:param_info.name];
            }
            
        }
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:^(BOOL result, NSError *error) {
                                                   if (result) {
                                                       
                                                   }
                                                   else{
                                                       
                                                   }
                                               }];
    }
}

- (void) controlDeviceMode:(NSString*)mode{
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
    cmd = [_cmdMap objectForKey:@"SET_MODE"];
    self._mode = mode;
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:mode forKey:param_info.name];
            }
            
        }
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:^(BOOL result, NSError *error) {
                                                   if (result) {
                                                       
                                                   }
                                                   else{
                                                       
                                                   }
                                               }];
    }
}

- (void) controlDeviceMicDb:(NSString*)db{
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
    cmd = [_cmdMap objectForKey:@"SET_MIC_DB"];
    self._micDb = db;
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:_micDb forKey:param_info.name];
            }
            
        }
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:^(BOOL result, NSError *error) {
                                                   if (result) {
                                                       
                                                   }
                                                   else{
                                                       
                                                   }
                                               }];
    }
}

- (id) generateEventOperation_AnalogyGain
{
    RgsCommandInfo *cmd = nil;
    if(_cmdMap)
    {
        cmd = [_cmdMap objectForKey:@"SET_ANALOGY_GRAIN"];
    }
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_FLOAT)
            {
                [param setObject:[NSString stringWithFormat:@"%0.1f",_voiceDb]
                          forKey:param_info.name];
            }
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_ANALOGY_GRAIN"];

        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_ANALOGY_GRAIN"];
        if(cmdsRev)
        {
            RgsSceneOperation * opt = [[RgsSceneOperation alloc]
                                       initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
                                       cmd:[cmdsRev objectForKey:@"cmd"]
                                       param:[cmdsRev objectForKey:@"param"]];
            
            return opt;
        }
    }
    return nil;
}
- (id) generateEventOperation_Mute{
    
    RgsCommandInfo *cmd = nil;
    NSString *cmd_name = nil;
    if(_cmdMap)
    {
        if(_isMute)
        {
            cmd_name = @"SET_MUTE";
        }
        else
        {
            cmd_name = @"SET_UNMUTE";
        }
        
        cmd = [_cmdMap objectForKey:cmd_name];
    }
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:cmd_name];
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:cmd_name];
        if(cmdsRev)
        {
            RgsSceneOperation * opt = [[RgsSceneOperation alloc]
                                       initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
                                       cmd:[cmdsRev objectForKey:@"cmd"]
                                       param:[cmdsRev objectForKey:@"param"]];
            
            return opt;
        }
    }
    return nil;
}

- (id) generateEventOperation_DigitalGain
{
    RgsCommandInfo *cmd = nil;
   
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_DIGIT_GRAIN"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_FLOAT)
            {
                [param setObject:[NSString stringWithFormat:@"%0.1f",_digitalGain]
                          forKey:param_info.name];
            }
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_DIGIT_GRAIN"];
        
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_DIGIT_GRAIN"];
        if(cmdsRev)
        {
            RgsSceneOperation * opt = [[RgsSceneOperation alloc]
                                       initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
                                       cmd:[cmdsRev objectForKey:@"cmd"]
                                       param:[cmdsRev objectForKey:@"param"]];
            
            return opt;
        }
    }
    return nil;
}

- (id) generateEventOperation_DigitalMute{
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
    cmd = [_cmdMap objectForKey:@"SET_DIGIT_MUTE"];
    NSString* tureOrFalse = @"False";
    if(_isDigitalMute)
    {
        tureOrFalse = @"True";
    }
    else
    {
        tureOrFalse = @"False";
    }
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];

        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:tureOrFalse forKey:param_info.name];
            }
            
        }
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_DIGIT_MUTE"];
        
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_DIGIT_MUTE"];
        if(cmdsRev)
        {
            RgsSceneOperation * opt = [[RgsSceneOperation alloc]
                                       initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
                                       cmd:[cmdsRev objectForKey:@"cmd"]
                                       param:[cmdsRev objectForKey:@"param"]];
            
            return opt;
        }
    }
    return nil;
}
- (id) generateEventOperation_Mode{
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
    cmd = [_cmdMap objectForKey:@"SET_MODE"];

    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:_mode forKey:param_info.name];
            }
            
        }
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_MODE"];
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_MODE"];
        if(cmdsRev)
        {
            RgsSceneOperation * opt = [[RgsSceneOperation alloc]
                                       initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
                                       cmd:[cmdsRev objectForKey:@"cmd"]
                                       param:[cmdsRev objectForKey:@"param"]];
            
            return opt;
        }
    }
    return nil;
}

- (id) generateEventOperation_MicDb{
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
    cmd = [_cmdMap objectForKey:@"SET_MIC_DB"];
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:_micDb forKey:param_info.name];
            }
            
        }
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_MIC_DB"];

        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_MIC_DB"];
        if(cmdsRev)
        {
            RgsSceneOperation * opt = [[RgsSceneOperation alloc]
                                       initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
                                       cmd:[cmdsRev objectForKey:@"cmd"]
                                       param:[cmdsRev objectForKey:@"param"]];
            
            return opt;
        }
    }
    return nil;
}
- (id) generateEventOperation_48v{
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
    cmd = [_cmdMap objectForKey:@"SET_48V"];
    
    NSString* tureOrFalse = @"False";
    if(_is48V)
    {
        tureOrFalse = @"True";
    }
    else
    {
        tureOrFalse = @"False";
    }
 
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:tureOrFalse forKey:param_info.name];
            }
            
        }
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_48V"];
        

        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_48V"];
        if(cmdsRev)
        {
            RgsSceneOperation * opt = [[RgsSceneOperation alloc]
                                       initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
                                       cmd:[cmdsRev objectForKey:@"cmd"]
                                       param:[cmdsRev objectForKey:@"param"]];
            
            return opt;
        }
    }
    return nil;
}

- (id) generateEventOperation_Inverted{
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_INVERTED"];
    
    NSString* tureOrFalse = @"False";
    if(_inverted)
    {
        tureOrFalse = @"True";
    }
    else
    {
        tureOrFalse = @"False";
    }
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:tureOrFalse forKey:param_info.name];
            }
            
        }
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_INVERTED"];

        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_INVERTED"];
        if(cmdsRev)
        {
            RgsSceneOperation * opt = [[RgsSceneOperation alloc]
                                       initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
                                       cmd:[cmdsRev objectForKey:@"cmd"]
                                       param:[cmdsRev objectForKey:@"param"]];
            
            return opt;
        }
    }
    return nil;
}

@end
