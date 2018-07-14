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
    BOOL _isSetOK;
    
    BOOL _isFanKuiYiZhiStarted;
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
@synthesize _voiceDb;
@synthesize _isMute;
@synthesize _digitalGain;
@synthesize _isDigitalMute;
@synthesize _inverted;

@synthesize _yanshiqiSlide;
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

@synthesize _lvboBoDuanArray;
@synthesize _islvboGaotongStart;
@synthesize _islvboDitongStart;
@synthesize _lvboGaotongPinLv;
@synthesize _lvboBoduanPinlv;
@synthesize _lvboBoduanZengyi;
@synthesize _lvboBoduanQ;

@synthesize _lvboDitongFreq;
@synthesize _lvboDitongXielvArray;
@synthesize _lvboDitongSL;

@synthesize waves16_feq_gain_q;

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
@synthesize _isyaxianStart;

@synthesize _setMixSrc;

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
        
        _isFanKuiYiZhiStarted = NO;
        
        self._yanshiqiSlide = @"0.00";
        
        _isyaxianStart = YES;
        self._yaxianFazhi = @"0";
        self._yaxianXielv = @"2";
        self._yaxianStartTime = @"20";
        self._yaxianRecoveryTime = @"20";
        
        self._zaoshengFazhi = @"0";
        self._zaoshengStartTime = @"20";
        self._zaoshengHuifuTime = @"20";
        self._isZaoshengStarted = NO;
        
        
        self._lvbojunhengGaotongType = @"Bessel";
        self._lvboGaotongArray = [NSArray array];
        
        self._lvbojunhengDitongType = @"";
        self._lvboDitongArray = [NSArray array];
        
        self._lvboGaotongXielvArray = [NSArray array];
        self._lvbojunhengGaotongXielv = @"0";
        
        self._lvboDitongXielvArray = [NSArray array];
        self._lvboDitongSL = @"-6db";
       
        self._lvboBoDuanArray = [NSArray array];
        
        self._lvboGaotongPinLv = @"20";
        self._lvboDitongFreq = @"20000";
        
        
        self._lvboBoduanQ = @"4";
        self._lvboBoduanZengyi = @"5";
        self._lvboBoduanPinlv = @"6";
        
        self.waves16_feq_gain_q = [NSMutableArray array];
        
        //初始化16条线的数据
        NSArray *def_freq = @[@40,@60,@80,@100,@200,@300,@400,@500,@600,@700,@800,
                              @900,@1000,@2000,@3000,@4000];
        for(int i = 0; i < 16; i++)
        {
            id freq = [def_freq objectAtIndex:i];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:freq forKey:@"freq"];
            [dic setObject:@"0" forKey:@"gain"];
            [dic setObject:@"43" forKey:@"q"];
            [dic setObject:@"6.00" forKey:@"q_val"];
            [dic setObject:@"True" forKey:@"enable"];
            
            [dic setObject:[NSString stringWithFormat:@"%d", i+1]
                    forKey:@"band"];
            
            [waves16_feq_gain_q addObject:dic];
   
        }
        
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
        
        
        if(!_rgsProxyObj)
        {
            NSString *name = [data objectForKey:@"proxy_name"];
            if(name == nil)
                name = @"";
            
            self._rgsProxyObj = [[RgsProxyObj alloc] init];
            self._rgsProxyObj.m_id = proxy_id;
            self._rgsProxyObj.name = name;

        }
        
        
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

- (NSArray*)getWaveTypes{
    
    NSMutableArray *result = [NSMutableArray array];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_PEQ"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"TYPE"])
                {
                    [result addObjectsFromArray:param_info.available];
                    break;
                }
                
            }
        }
    }
    
    return result;
}

- (NSDictionary*)getWaveOptions{
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_PEQ"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"RATE"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"RATE_max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"RATE_min"];
                }
                else if([param_info.name isEqualToString:@"GAIN"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"GAIN_max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"GAIN_min"];
                }
                else if([param_info.name isEqualToString:@"Q"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"Q_max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"Q_min"];
                }
            }
        }
    }
    
    return result;
}

- (BOOL) isProxyMute{
    
    return _isMute;
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

- (void) initDatasAfterPullData{
    
    self._lvboGaotongArray = [self getHighFilters];
    self._lvboGaotongXielvArray = [self getHighSL];
    
    
    if([self._lvboGaotongArray count])
        self._lvbojunhengGaotongType = [self._lvboGaotongArray objectAtIndex:0];
    
    if([self._lvboGaotongXielvArray count])
    {
        self._lvbojunhengGaotongXielv = [_lvboGaotongXielvArray objectAtIndex:0];
    }
    
    
    self._lvboDitongArray = [self getLowFilters];
    if([self._lvboDitongArray count])
        self._lvbojunhengDitongType = [self._lvboDitongArray objectAtIndex:0];
    
    self._lvboDitongXielvArray = [self getLowSL];
    if([self._lvboDitongXielvArray count])
        self._lvboDitongSL = [self._lvboDitongXielvArray objectAtIndex:0];
    
    
    self._lvboBoDuanArray = [self getWaveTypes];
    if([self._lvboBoDuanArray count])
    {
        NSString *bandDefType = [self._lvboBoDuanArray objectAtIndex:0];
        for(NSMutableDictionary *dic in waves16_feq_gain_q)
        {
            [dic setObject:bandDefType forKey:@"type"];
        }
    }
    
}

- (BOOL) haveProxyCommandLoaded{
    
    if(_rgsCommands)
        return YES;
    
    return NO;
    
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
                
                
                [block_self initDatasAfterPullData];
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

- (void) prepareLoadCommand:(NSArray*)cmds{
    
    if ([cmds count]) {
        
        self._cmdMap = [NSMutableDictionary dictionary];
        
        self._rgsCommands = cmds;
        for(RgsCommandInfo *cmd in cmds)
        {
            [self._cmdMap setObject:cmd forKey:cmd.name];
        }
    
        [self initDatasAfterPullData];
    }
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
#pragma mark ---- 延时器 ----

- (NSDictionary*)getSetDelayOptions{
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_DELAY"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"DUR"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"min"];
                    
                    break;
                }
            }
        }
    }
    
    return result;
}

- (NSString*) getYanshiqiSlide {
    return _yanshiqiSlide;
}

- (void) controlYanshiqiSlide:(NSString*) yanshiqiSlide {
    
    _yanshiqiSlide = yanshiqiSlide;
    
    RgsCommandInfo *cmd = nil;
    RgsCommandParamInfo * cmd_param_info = nil;
    cmd = [_cmdMap objectForKey:@"SET_DELAY"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"DUR"])
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
                                      [yanshiqiSlide floatValue]]
                              forKey:cmd_param_info.name];
                }
                else if(cmd_param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0f",
                                      [yanshiqiSlide floatValue]]
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
#pragma mark ---- 反馈抑制 ----

- (BOOL) isFanKuiYiZhiStarted{
    
    return _isFanKuiYiZhiStarted;
}

- (void) controlFanKuiYiZhi:(BOOL)isFanKuiYiZhiStarted { 
    _isFanKuiYiZhiStarted = isFanKuiYiZhiStarted;
    
    [self sendFBCallBack];
}

-(void) sendFBCallBack {
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_FB_CTRL"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_isFanKuiYiZhiStarted)
        {
            tureOrFalse = @"True";
        }
        else
        {
            tureOrFalse = @"False";
        }
        
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"ENABLE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                }
            }
            
            if([param count])
            {
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

#pragma mark ---- 信号发生器 ----

- (NSDictionary*)getSigOuccorOptions{
    
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

#pragma mark ---- 压限器 ----

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

- (NSString*) getYaxianFazhi {
    return _yaxianFazhi;
}
- (void) controlYaxianFazhi:(NSString*) yaxianFazhi {
    
    self._yaxianFazhi = yaxianFazhi;
    [self sendPressLimitCmd];
}
- (BOOL) isYaXianStarted {
    return _isyaxianStart;
}
- (void) controlYaXianStarted:(BOOL)isyaxianstarted {
    
    _isyaxianStart = isyaxianstarted;
    [self sendPressLimitCmd];
}

- (NSString*) getYaxianXielv {
    return _yaxianXielv;
}
- (void) controlYaxianXielv:(NSString*) yaxianXielv {
    
    self._yaxianXielv = yaxianXielv;
    [self sendPressLimitCmd];
    
}
- (NSString*) getYaxianStartTime {
    return _yaxianStartTime;
}
- (void) controlYaxianStartTime:(NSString*) yaxianStartTime {
    
    self._yaxianStartTime = yaxianStartTime;
    [self sendPressLimitCmd];
    
}
- (NSString*) getYaxianRecoveryTime {
    return _yaxianRecoveryTime;
}
- (void) controlYaxianRecoveryTime:(NSString*) yaxianRecoveryTime {
    
    self._yaxianRecoveryTime = yaxianRecoveryTime;
    [self sendPressLimitCmd];
    
}

- (void) sendPressLimitCmd{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_PRESS_LIMIT"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_isyaxianStart)
        {
            tureOrFalse = @"True";
        }
        else
        {
            tureOrFalse = @"False";
        }
        
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"ENABLE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"TH"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [_yaxianFazhi floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [_yaxianFazhi floatValue]]
                                  forKey:param_info.name];
                    }
                }
                else if([param_info.name isEqualToString:@"SL"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [_yaxianXielv floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [_yaxianXielv floatValue]]
                                  forKey:param_info.name];
                    }
                }
                else if([param_info.name isEqualToString:@"START_DUR"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [_yaxianStartTime floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [_yaxianStartTime floatValue]]
                                  forKey:param_info.name];
                    }
                }
                else if([param_info.name isEqualToString:@"RECOVER_DUR"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [_yaxianRecoveryTime floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [_yaxianRecoveryTime floatValue]]
                                  forKey:param_info.name];
                    }
                }
            }
            
            if([param count])
            {
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

#pragma mark ---- 噪声门 ----

- (NSDictionary*)getNoiseGateOptions {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_NOISE_GATE"];
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

- (BOOL) isZaoshengStarted {
    return _isZaoshengStarted;
}
- (void) controlZaoshengStarted:(BOOL)isZaoshengStarted {
    self._isZaoshengStarted = isZaoshengStarted;
    
    [self sendNoiseGate];
}
- (NSString*) getZaoshengFazhi {
    return _zaoshengFazhi;
}
- (void) controlZaoshengFazhi:(NSString*) zaoshengFazhi {
    self._zaoshengFazhi = zaoshengFazhi;
    
    [self sendNoiseGate];
}
- (NSString*) getZaoshengStartTime {
    return self._zaoshengStartTime;
}
- (void) controlZaoshengStartTime:(NSString*) zaoshengStartTime {
    self._zaoshengStartTime = zaoshengStartTime;
    
    [self sendNoiseGate];
}
- (NSString*) getZaoshengRecoveryTime {
    return self._zaoshengHuifuTime;
}
- (void) controlZaoshengRecoveryTime:(NSString*) zaoshengHuifuTime {
    self._zaoshengHuifuTime = zaoshengHuifuTime;
    
    [self sendNoiseGate];
}

-(void) sendNoiseGate {
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_NOISE_GATE"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_isZaoshengStarted)
        {
            tureOrFalse = @"True";
        }
        else
        {
            tureOrFalse = @"False";
        }
        
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"ENABLE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"TH"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [_zaoshengFazhi floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [_zaoshengFazhi floatValue]]
                                  forKey:param_info.name];
                    }
                }
                else if([param_info.name isEqualToString:@"START_DUR"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [_zaoshengStartTime floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [_zaoshengStartTime floatValue]]
                                  forKey:param_info.name];
                    }
                }
                else if([param_info.name isEqualToString:@"RECOVER_DUR"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [_zaoshengHuifuTime floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [_zaoshengHuifuTime floatValue]]
                                  forKey:param_info.name];
                    }
                }
            }
            
            if([param count])
            {
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


#pragma mark ----- GaoTong High Filter -----

- (BOOL) isLvboGaotongStart {
    return self._islvboGaotongStart;
}
- (void) controlLVboGaotongStart:(BOOL) lvboGaotongStart {
    
    self._islvboGaotongStart = lvboGaotongStart;
    [self sendHighFilterCmd];
}

- (NSString*) getLvboGaotongPinlv {
    return self._lvboGaotongPinLv;
}
- (void) controlHighFilterFreq:(NSString*) freq {
    
    self._lvboGaotongPinLv = freq;
    [self sendHighFilterCmd];
}


- (NSArray*)getHighFilters{
    
    NSMutableArray *result = [NSMutableArray array];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_HIGH_FILTER"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"TYPE"])
                {
                    [result addObjectsFromArray:param_info.available];
                    break;
                }
                
            }
        }
    }
    
    return result;
}

- (NSArray*)getHighSL{
    
    NSMutableArray *result = [NSMutableArray array];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_HIGH_FILTER"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"SL"])
                {
                    [result addObjectsFromArray:param_info.available];
                    break;
                }
                
            }
        }
    }
    
    return result;
}

- (NSDictionary*)getHighRateRange{
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_HIGH_FILTER"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"RATE"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"RATE_max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"RATE_min"];
                    break;
                }
                
            }
        }
    }
    
    return result;
}

- (NSString*) getGaoTongType {
    return self._lvbojunhengGaotongType;
}

- (void) controlGaoTongType:(NSString*) gaotongType {
    
    self._lvbojunhengGaotongType = gaotongType;
    
    [self sendHighFilterCmd];
}

- (NSArray*) getLvBoGaoTongArray {
    return self._lvboGaotongArray;
}



- (NSString*) getGaoTongXieLv {
    return self._lvbojunhengGaotongXielv;
}
- (void) controlGaoTongXieLv:(NSString*) gaotongxielv {
   
    self._lvbojunhengGaotongXielv = gaotongxielv;
    
    [self sendHighFilterCmd];
    
}
- (NSArray*) getLvBoGaoTongXielvArray {
    return self._lvboGaotongXielvArray;
}

- (void) sendHighFilterCmd{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_HIGH_FILTER"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_islvboGaotongStart)
        {
            tureOrFalse = @"True";
        }
        else
        {
            tureOrFalse = @"False";
        }
    
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"TYPE"])
                {
                    [param setObject:_lvbojunhengGaotongType
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"SL"])
                {
                    [param setObject:_lvbojunhengGaotongXielv
                              forKey:param_info.name];
                    
                }
                else if([param_info.name isEqualToString:@"RATE"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [_lvboGaotongPinLv floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [_lvboGaotongPinLv floatValue]]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"ENABLE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                    
                }
            }
            
            if([param count])
            {
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


#pragma mark -----Low Filter------


- (NSArray*)getLowFilters{
    
    NSMutableArray *result = [NSMutableArray array];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_LOW_FILTER"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"TYPE"])
                {
                    [result addObjectsFromArray:param_info.available];
                    break;
                }
                
            }
        }
    }
    
    return result;
}

- (NSArray*)getLowSL{
    
    NSMutableArray *result = [NSMutableArray array];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_LOW_FILTER"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"SL"])
                {
                    [result addObjectsFromArray:param_info.available];
                    break;
                }
                
            }
        }
    }
    
    return result;
}

- (NSString*) getDiTongXieLv {
    
    return self._lvboDitongSL;
    
}
- (void) controlDiTongXieLv:(NSString*) ditongxielv {
    
    self._lvboDitongSL = ditongxielv;
    
    [self sendLowFilterCmd];
    
}
- (NSArray*) getLvBoDiTongXielvArray {
    
    return _lvboDitongXielvArray;
    
}

- (NSDictionary*)getLowRateRange{
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_LOW_FILTER"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"RATE"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"RATE_max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"RATE_min"];
                    break;
                }
                
            }
        }
    }
    
    return result;
}


- (NSString*) getDiTongType {
    return self._lvbojunhengDitongType;
}
- (void) controlDiTongType:(NSString*) ditongtype {
    
    self._lvbojunhengDitongType = ditongtype;
    [self sendLowFilterCmd];
}

-(BOOL) islvboDitongStart {
    return self._islvboDitongStart;
}
-(void) controllvboDitongStart:(BOOL) lvboDitongStart {
    
    self._islvboDitongStart = lvboDitongStart;
    [self sendLowFilterCmd];
}

-(NSString*) getLowFilterFreq {
    return self._lvboDitongFreq;
}
-(void) controlLowFilterFreq:(NSString*) lvboDitongPinlv {
    
    self._lvboDitongFreq = lvboDitongPinlv;
    [self sendLowFilterCmd];
}



- (void) sendLowFilterCmd{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_LOW_FILTER"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_islvboDitongStart)
        {
            tureOrFalse = @"True";
        }
        else
        {
            tureOrFalse = @"False";
        }
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"TYPE"])
                {
                    [param setObject:_lvbojunhengDitongType
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"SL"])
                {
                    [param setObject:_lvboDitongSL
                              forKey:param_info.name];
                    
                }
                else if([param_info.name isEqualToString:@"RATE"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [_lvboDitongFreq floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [_lvboDitongFreq floatValue]]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"ENABLE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                    
                }
            }
            
            if([param count])
            {
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

#pragma mark --- Brand -----

- (NSArray*) getLvBoBoDuanArray {
    return _lvboBoDuanArray;
}


- (void) controlBandLineType:(NSString*) lineType band:(int)band {

    if(band < [waves16_feq_gain_q count])
    {
        NSMutableDictionary *dic = [waves16_feq_gain_q objectAtIndex:band];
        [dic setObject:lineType forKey:@"type"];
        
        [self sendBandControlCmd:band];
    }
    

}

- (void) controlBandEnabled:(BOOL) enable band:(int)band {
    
    NSString* tureOrFalse = @"False";
    if(enable)
    {
        tureOrFalse = @"True";
    }
    else
    {
        tureOrFalse = @"False";
    }
    
    if(band < [waves16_feq_gain_q count])
    {
        NSMutableDictionary *dic = [waves16_feq_gain_q objectAtIndex:band];
        [dic setObject:tureOrFalse forKey:@"enable"];
        
        [self sendBandControlCmd:band];
        
    }
    
    
    
    
}

- (void) controlBrandFreqAndGain:(NSString*) freq gain:(NSString*)gain brand:(int)brand{
    
    if(brand < [waves16_feq_gain_q count])
    {
        NSMutableDictionary *dic = [waves16_feq_gain_q objectAtIndex:brand];
        
        [dic setObject:freq
                forKey:@"freq"];
        
        [dic setObject:gain
                forKey:@"gain"];
        
        [self sendBandControlCmd:brand];
    }
}


- (void) sendBandControlCmd:(int)band{
    
    
    NSMutableDictionary *dic = [waves16_feq_gain_q objectAtIndex:band];
    
    id freq = [dic objectForKey:@"freq"];
    id gain = [dic objectForKey:@"gain"];
    id q = [dic objectForKey:@"q"];
    id tureOrFalse = [dic objectForKey:@"enable"];
    id type = [dic objectForKey:@"type"];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_PEQ"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"RATE"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [freq floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [freq floatValue]]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"GAIN"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [gain floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [gain floatValue]]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"SEG"])
                {
                    [param setObject:[NSString stringWithFormat:@"%d",
                                      band+1]
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"ENABLE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"Q"])
                {
                    [param setObject:q
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"TYPE"])
                {
                    [param setObject:type
                              forKey:param_info.name];
                }
                
            }
            
            //NSLog(@"%@", [param description]);
            
            if([param count])
            {
                
                
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

- (void) controlBrandFreq:(NSString*) freq brand:(int)brand{
   

    if(brand < [waves16_feq_gain_q count])
    {
        NSMutableDictionary *dic = [waves16_feq_gain_q objectAtIndex:brand];
        
        [dic setObject:freq
                forKey:@"freq"];
        
        [self sendBandControlCmd:brand];
    }
  
}

- (void) controlBrandGain:(NSString*) gain brand:(int)brand{
    
    
    if(brand < [waves16_feq_gain_q count])
    {
        NSMutableDictionary *dic = [waves16_feq_gain_q objectAtIndex:brand];
        
        [dic setObject:gain
                forKey:@"gain"];
        
        [self sendBandControlCmd:brand];
    }
}

-(void) controlBrandQ:(NSString*)qIndex qVal:(NSString*)qVal brand:(int)brand{
    
    if(brand < [waves16_feq_gain_q count])
    {
        NSMutableDictionary *dic = [waves16_feq_gain_q objectAtIndex:brand];
        
        [dic setObject:qVal
                forKey:@"q_val"];
        [dic setObject:qIndex
                forKey:@"q"];
        
        
        [self sendBandControlCmd:brand];
    }
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

#pragma mark ----矩阵路由----

- (NSDictionary*)getMatrixCmdSettings{
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_MIX_VALUE"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"VALUE"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"min"];
                    break;
                }
                
            }
        }
    }
    
    return result;
}

- (void) controlMatrixSrc:(VAProcessorProxys *)proxy selected:(BOOL)selected{
    
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_MIX_SOURCE"];
  
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            
            NSString *name = proxy._rgsProxyObj.name;
            name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            [param setObject:name forKey:param_info.name];
            
            if(selected)
            {
                [param setObject:@"True" forKey:@"ENABLE"];
            }
            else
            {
                [param setObject:@"False" forKey:@"ENABLE"];
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

- (void) controlMatrixSrcValue:(VAProcessorProxys *)proxy th:(float)th{
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_MIX_VALUE"];
    
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
           
            for(RgsCommandParamInfo * param_info in cmd.params)
            {
            
                if([param_info.name isEqualToString:@"SRC"])
                {
                    NSString *name = proxy._rgsProxyObj.name;
                    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [param setObject:name forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"VALUE"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          th]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          th]
                                  forKey:param_info.name];
                        
                    }
                }
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

#pragma mark ----生成场景片段------

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

//高通
- (id) generateEventOperation_hp{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_HIGH_FILTER"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_islvboGaotongStart)
        {
            tureOrFalse = @"True";
        }
        else
        {
            tureOrFalse = @"False";
        }
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"TYPE"])
                {
                    [param setObject:_lvbojunhengGaotongType
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"SL"])
                {
                    [param setObject:_lvbojunhengGaotongXielv
                              forKey:param_info.name];
                    
                }
                else if([param_info.name isEqualToString:@"RATE"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [_lvboGaotongPinLv floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [_lvboGaotongPinLv floatValue]]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"ENABLE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                    
                }
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
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_HIGH_FILTER"];
        
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
        
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_HIGH_FILTER"];
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

//低通
- (id) generateEventOperation_lp{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_LOW_FILTER"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_islvboDitongStart)
        {
            tureOrFalse = @"True";
        }
        else
        {
            tureOrFalse = @"False";
        }
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"TYPE"])
                {
                    [param setObject:_lvbojunhengDitongType
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"SL"])
                {
                    [param setObject:_lvboDitongSL
                              forKey:param_info.name];
                    
                }
                else if([param_info.name isEqualToString:@"RATE"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [_lvboDitongFreq floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [_lvboDitongFreq floatValue]]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"ENABLE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                    
                }
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
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_LOW_FILTER"];
        
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
        
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_LOW_FILTER"];
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

- (NSArray *) generateEventOperation_peq{
    
    NSMutableArray *results = [NSMutableArray array];
    for(int band = 0; band < [waves16_feq_gain_q count]; band++)
    {
        id opt = [self generateEventOperation_peqAtBand:band];
        
        if(opt)
        {
            [results addObject:opt];
        }
    }
    
    return results;
}

- (id) generateEventOperation_peqAtBand:(int)band{
    
    NSMutableDictionary *dic = [waves16_feq_gain_q objectAtIndex:band];
    
    id freq = [dic objectForKey:@"freq"];
    id gain = [dic objectForKey:@"gain"];
    id q = [dic objectForKey:@"q"];
    id tureOrFalse = [dic objectForKey:@"enable"];
    id type = [dic objectForKey:@"type"];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_PEQ"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"RATE"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [freq floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [freq floatValue]]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"GAIN"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          [gain floatValue]]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          [gain floatValue]]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"SEG"])
                {
                    [param setObject:[NSString stringWithFormat:@"%d",
                                      band+1]
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"ENABLE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"Q"])
                {
                    [param setObject:q
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"TYPE"])
                {
                    [param setObject:type
                              forKey:param_info.name];
                }
                
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
        
        NSMutableDictionary *peq_map = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_PEQ"];
        if(peq_map == nil)
        {
            peq_map = [NSMutableDictionary dictionary];
            [_RgsSceneDeviceOperationShadow setObject:peq_map forKey:@"SET_PEQ"];
        }
        
        [peq_map setObject:slice forKey:[NSString stringWithFormat:@"%d", band]];
        
        
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSMutableDictionary *peq_map = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_PEQ"];
        if(peq_map)
        {
            NSDictionary *cmdsRev = [peq_map objectForKey:[NSString stringWithFormat:@"%d", band]];
            if(cmdsRev)
            {
                RgsSceneOperation * opt = [[RgsSceneOperation alloc]
                                           initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
                                           cmd:[cmdsRev objectForKey:@"cmd"]
                                           param:[cmdsRev objectForKey:@"param"]];
                
                return opt;
            }
        }
    }
    
    return nil;
}

@end
