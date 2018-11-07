//
//  VProjectProxys.m
//  veenoon
//
//  Created by chen jack on 2018/5/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEMixProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

/*
 SET_POWER [ON, OFF]
 SET_INPUT [HDMI, COMP, USB, LAN]
 */

@interface AudioEMixProxy ()
{
    
    BOOL _isSetOK;
    
}
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;



@end

@implementation AudioEMixProxy
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;

@synthesize _deviceVol;
@synthesize _currentCameraPol;
@synthesize _cameraPol;
@synthesize _fayanPriority;
@synthesize _numberOfDaiBiao;
@synthesize _workMode;
@synthesize _zhuxiDaibiao;
@synthesize _mixPEQ;
@synthesize _mixPEQRate;
@synthesize _deviceId;
@synthesize _mixNoise;
@synthesize _mixPress;
@synthesize _mixLowFilter;
@synthesize _mixHighFilter;

@synthesize _RgsSceneDeviceOperationShadow;

@synthesize _pointsData;


- (id) init
{
    if(self = [super init])
    {
        _deviceVol = 0.0f;
        self._mixLowFilter = @"0";
        self._mixHighFilter = @"10";
        self._mixPEQ = @"4";
        self._mixNoise = @"7";
        self._mixPress = @"5";
        self._mixPEQRate = @"180";
        self._currentCameraPol = @"VISCA";
        self._workMode = nil;
        
        self._fayanPriority = 1;
        self._numberOfDaiBiao = 1;
        
        self._pointsData = [NSMutableDictionary dictionary];
        
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
        _cameraPol = [NSMutableArray array];
    }
    
    return self;
}

- (void) getCurrentDataState
{
    
    if(_rgsProxyObj)
    {
        IMP_BLOCK_SELF(AudioEMixProxy);
        [[RegulusSDK sharedRegulusSDK] GetProxyCurState:_rgsProxyObj.m_id completion:^(BOOL result, NSDictionary *state, NSError *error) {
            if (result) {
                if ([state count])
                {
                    [block_self parseStateInitsValues:state];
                }
            }
        }];
        
    }
}

- (void) parseStateInitsValues:(NSDictionary*)state{
    
    id val = [state objectForKey:@"VOL"];
    self._deviceVol = [val intValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PROXY_CUR_STATE_GOT_LB
                                                        object:@{@"proxy":@(_rgsProxyObj.m_id)}];
}

- (NSDictionary *)getScenarioSliceLocatedShadow{
    
    return _RgsSceneDeviceOperationShadow;
}

- (void) controlWorkMode:(NSString*)workMode {
    
    self._workMode = workMode;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_MODE"];
    
    NSString *commond = workMode;
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"MODE"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_LIST)
                    {
                        [param setObject:commond
                                  forKey:param_info.name];
                    }
                }
                else if([param_info.name isEqualToString:@"TARGET"])
                {
                    [param setObject:@"Local"
                              forKey:param_info.name];
                }
                
            }
            
        }
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        if(_deviceId)
            [[RegulusSDK sharedRegulusSDK] ControlDevice:_deviceId
                                                     cmd:cmd.name
                                                   param:param completion:nil];
    }
}

- (void) controlHighFilter:(NSString*)highFilter {
    
    self._mixHighFilter = highFilter;
    
    float highFilterFloat = [highFilter floatValue];
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_HIGH_FILTER"];
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
                                          highFilterFloat]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          highFilterFloat]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"TARGET"])
                {
                    [param setObject:@"Local"
                              forKey:param_info.name];
                }
                
            }
            
        }
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        if(_deviceId)
            [[RegulusSDK sharedRegulusSDK] ControlDevice:_deviceId
                                                     cmd:cmd.name
                                                   param:param completion:nil];
    }
}
- (void) controlLowFilter:(NSString*)lowFilter {
    
    self._mixLowFilter = lowFilter;
    
    float lowFilterFloat = [lowFilter floatValue];
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_LOW_FILTER"];
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
                                          lowFilterFloat]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          lowFilterFloat]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"TARGET"])
                {
                    [param setObject:@"Local"
                              forKey:param_info.name];
                }
                
            }
            
        }
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        if(_deviceId)
            [[RegulusSDK sharedRegulusSDK] ControlDevice:_deviceId
                                                     cmd:cmd.name
                                                   param:param completion:nil];
    }
}
- (void) controlMixPEQ:(NSString*)mixPEQ withRate:(NSString*)peqRate {
   

    //存储
    [self._pointsData setObject:mixPEQ forKey:peqRate];
    
    
    float mixPEQFloat = [mixPEQ floatValue];
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_PEQ"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"RATE"])
                {
                    [param setObject:peqRate forKey:param_info.name];
                }
                else if ([param_info.name isEqualToString:@"GAIN"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          mixPEQFloat]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          mixPEQFloat]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"TARGET"])
                {
                    [param setObject:@"Local"
                              forKey:param_info.name];
                }
                
            }
            
        }
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        if(_deviceId)
            [[RegulusSDK sharedRegulusSDK] ControlDevice:_deviceId
                                                     cmd:cmd.name
                                                   param:param completion:nil];
    }
}
- (void) controlMixPress:(NSString*)mixPress {
    
    self._mixPress = mixPress;
    
    float mixPressFloat = [mixPress floatValue];
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_PRESS"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"LEVEL"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          mixPressFloat]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          mixPressFloat]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"TARGET"])
                {
                    [param setObject:@"Local"
                              forKey:param_info.name];
                }
                
            }
            
        }
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        if(_deviceId)
            [[RegulusSDK sharedRegulusSDK] ControlDevice:_deviceId
                                                     cmd:cmd.name
                                                   param:param completion:nil];
    }
}
- (void) controlMixNoise:(NSString*)mixNoise {
    
    self._mixNoise = mixNoise;
    
    float mixNoiseFloat = [mixNoise floatValue];
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_NOISE_GATE"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"LEVEL"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          mixNoiseFloat]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          mixNoiseFloat]
                                  forKey:param_info.name];
                        
                    }
                }
                else if([param_info.name isEqualToString:@"TARGET"])
                {
                    [param setObject:@"Local"
                              forKey:param_info.name];
                }
                
            }
            
        }
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        if(_deviceId)
            [[RegulusSDK sharedRegulusSDK] ControlDevice:_deviceId
                                                     cmd:cmd.name
                                                   param:param completion:nil];
    }
}


- (void) controlFayanPriority:(int)fayanPriority withType:(NSString*)type {
    
    
    self._zhuxiDaibiao = type;
    
    NSMutableArray *opts = [NSMutableArray array];
    
    if([type isEqualToString:@"设定主席"])
    {
        self._fayanPriority = fayanPriority;
        
        RgsSceneOperation *opt = [self generateEventOperation_priority];
        if(opt)
            [opts addObject:opt];
    }
    else
    {
        self._fayanPriority = 0;
        self._numberOfDaiBiao = fayanPriority;
       
        RgsSceneOperation *opt = [self generateEventOperation_priority];
        if(opt)
            [opts addObject:opt];
        
        
        opt = [self generateEventOperation_daibiao];
        if(opt)
            [opts addObject:opt];
        
    }
    
    if([opts count])
    [[RegulusSDK sharedRegulusSDK] ControlDeviceByOperation:opts
                                                 completion:nil];
    
}

- (NSMutableDictionary*)getPressMinMax {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_PRESS"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"LEVEL"])
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

- (NSMutableDictionary*)getNoiseMinMax {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_NOISE_GATE"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"LEVEL"])
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
- (NSMutableDictionary*)getPEQMinMax {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_PEQ"];
    NSMutableArray *peqRateArray = [NSMutableArray array];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"GAIN"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"min"];
                    break;
                } else if ([param_info.name isEqualToString:@"RATE"]) {
                    
                    [peqRateArray addObjectsFromArray:param_info.available];
                    
                    [result setObject:peqRateArray forKey:@"RATE"];
                }
            }
        }
    }
    
    return result;
}

- (void) initPEQDatas{
    
    if([_pointsData count])
        return;

    NSDictionary *dic = [self getPEQMinMax];
    
    NSArray *peqRateArray = [dic objectForKey:@"RATE"];
    if([peqRateArray count])
    {
        for(id key in peqRateArray)
            [_pointsData setObject:@"0.0" forKey:key];
    }
    
    
}

- (NSMutableDictionary*)getHighFilterMinMax {
    
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

- (NSMutableDictionary*)getLowFilterMinMax {
    
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
                    if(param_info.max){
                        
                        float f = [param_info.max floatValue];
                        if(f < 1000)
                        {
                            f = f*1000;
                        }
                        
                        [result setObject:[NSString stringWithFormat:@"%0.0f",f] forKey:@"max"];
                    }
                    if(param_info.min){
                        
                        float f = [param_info.min floatValue];
                        if(f < 1000)
                        {
                            f = f*1000;
                        }
                        
                        [result setObject:[NSString stringWithFormat:@"%0.0f",f]
                                   forKey:@"min"];
                    }
                    break;
                }
            }
        }
    }
    
    return result;
}

- (NSMutableDictionary*)getPriorityMinMax {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_PRIORITY"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"COUNT"])
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

- (NSMutableArray*)getCameraPol{
    
    [_cameraPol removeAllObjects];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_CAM_POL"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"POL"])
                {
                    if (param_info.available) {
                        [_cameraPol addObjectsFromArray:param_info.available];
                    }
                    break;
                }
            }
        }
    }
    
    return _cameraPol;
}

- (NSString *)gainWithPEQWithBand:(NSString*)bandkey{
    
    if(_pointsData == nil)
        return nil;
    
    NSString *gain = [_pointsData objectForKey:bandkey];
    
    return gain;
}

- (void) recoverWithDictionary:(NSArray*)datas{
    
    [_RgsSceneDeviceOperationShadow removeAllObjects];
    
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        _isSetOK = YES;
        
        NSString *cmd = dopt.cmd;
        NSDictionary *param = dopt.param;
        
        if([cmd isEqualToString:@"SET_MODE"])
        {
            self._workMode = [param objectForKey:@"MODE"];
        }
        else if([cmd isEqualToString:@"SET_PRIORITY"])
        {
            self._fayanPriority = [[param objectForKey:@"COUNT"] intValue];
        }
        else if([cmd isEqualToString:@"SET_MIC_OPEN_MAX"])
        {
            self._numberOfDaiBiao = [[param objectForKey:@"COUNT"] intValue];
        }
        else if([cmd isEqualToString:@"SET_VOL"])
        {
            self._deviceVol = [[param objectForKey:@"VOL"] floatValue];
        }
        else if([cmd isEqualToString:@"SET_CAM_POL"])
        {
            self._currentCameraPol = [param objectForKey:@"POL"];
        }
        else if([cmd isEqualToString:@"SET_PEQ"]){
            
            NSString *rate = [param objectForKey:@"RATE"];
            NSString *gain = [param objectForKey:@"GAIN"];
            
            [self._pointsData setObject:gain forKey:rate];
            
            
            NSMutableArray *peqs = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_PEQ"];
            if(peqs == nil)
            {
                peqs = [NSMutableArray array];
                [_RgsSceneDeviceOperationShadow setObject:peqs forKey:@"SET_PEQ"];
            }
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [peqs addObject:opt];
            
        }
        else if([cmd isEqualToString:@"SET_PRESS"]){
            
            self._mixPress = [param objectForKey:@"LEVEL"];
            
        }
        else if([cmd isEqualToString:@"SET_NOISE_GATE"])
        {
            self._mixNoise = [param objectForKey:@"LEVEL"];
        }
        else if([cmd isEqualToString:@"SET_HIGH_FILTER"])
        {
            self._mixHighFilter = [param objectForKey:@"RATE"];
        }
        else if([cmd isEqualToString:@"SET_LOW_FILTER"])
        {
            self._mixLowFilter = [param objectForKey:@"RATE"];
        }
        
        
        if(![cmd isEqualToString:@"SET_PEQ"])
        {
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [_RgsSceneDeviceOperationShadow setObject:opt forKey:cmd];
        }
    }
    
}
- (void) controlDeviceCameraPol:(NSString*)cameraPol {
    
    self._currentCameraPol = cameraPol;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_CAM_POL"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"POL"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_LIST)
                    {
                        [param setObject:_currentCameraPol
                                  forKey:param_info.name];
                    }
                }
                
            }
            
        }
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        if(_deviceId)
            [[RegulusSDK sharedRegulusSDK] ControlDevice:_deviceId
                                                     cmd:cmd.name
                                                   param:param completion:nil];
    }
}
//SET_VOL
- (void) controlDeviceVol:(float)db force:(BOOL)force{
   
    _deviceVol = db;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_VOL"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for (RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"VOL"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          _deviceVol]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          _deviceVol]
                                  forKey:param_info.name];
                        
                    }
                }
            }
            
        }
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        if(_deviceId)
            [[RegulusSDK sharedRegulusSDK] ControlDevice:_deviceId
                                                     cmd:cmd.name
                                                   param:param completion:nil];
    }
}

- (void) checkRgsProxyCommandLoad:(NSArray*)cmds{
    
    
    if(cmds && [cmds count])
    {
        self._cmdMap = [NSMutableDictionary dictionary];
        
        self._rgsCommands = cmds;
        for(RgsCommandInfo *cmd in cmds)
        {
            [self._cmdMap setObject:cmd forKey:cmd.name];
        }
        
        _isSetOK = YES;
        
        //初始化数据
        if(_pointsData == nil)
        {
            [self initPEQDatas];
        }
        
    }
    else
    {
        if(_rgsProxyObj == nil || _rgsCommands)
            return;
        
        self._cmdMap = [NSMutableDictionary dictionary];
        
        IMP_BLOCK_SELF(AudioEMixProxy);
        
        [[RegulusSDK sharedRegulusSDK] GetProxyCommands:_rgsProxyObj.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
            if (result)
            {
                if ([commands count]) {
                    block_self._rgsCommands = commands;
                    for(RgsCommandInfo *cmd in commands)
                    {
                        [block_self._cmdMap setObject:cmd forKey:cmd.name];
                    }
                    
                    _isSetOK = YES;
                }
            }
            else
            {
                NSString *errorMsg = [NSString stringWithFormat:@"%@ - proxyid:%d",
                                      [error description], (int)_rgsProxyObj.m_id];
                
                [KVNProgress showErrorWithStatus:errorMsg];
            }
            
        }];
    }
    
}

- (BOOL) isSetChanged{
    
    return _isSetOK;
}


- (id) generateEventOperation_mode{
    
    if(self._workMode == nil)
        return nil;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_MODE"];
    NSString *commond = _workMode;
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"MODE"])
            {
                if(param_info.type == RGS_PARAM_TYPE_LIST)
                {
                    [param setObject:commond
                              forKey:param_info.name];
                }
            }
            else if([param_info.name isEqualToString:@"TARGET"])
            {
                [param setObject:@"Local"
                          forKey:param_info.name];
            }
            
        }
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _deviceId;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        return [_RgsSceneDeviceOperationShadow objectForKey:@"SET_MODE"];
    }
    return nil;
}
- (id) generateEventOperation_priority{

    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_PRIORITY"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"COUNT"])
            {
                [param setObject:[NSString stringWithFormat:@"%d", _fayanPriority]
                          forKey:param_info.name];
            }
        }
        
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _deviceId;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;

        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        return [_RgsSceneDeviceOperationShadow objectForKey:@"SET_PRIORITY"];
    }
    return nil;
}

- (id) generateEventOperation_daibiao{
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_MIC_OPEN_MAX"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"MAX"])
            {
                [param setObject:[NSString stringWithFormat:@"%d", _numberOfDaiBiao]
                          forKey:param_info.name];
            }
        }
        
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _deviceId;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        RgsSceneOperation * opt = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_MIC_OPEN_MAX"];
        return opt;
    }
    return nil;
}

- (id) generateEventOperation_vol{
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_VOL"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for (RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"VOL"])
            {
                if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.1f",
                                      _deviceVol]
                              forKey:param_info.name];
                }
                else if(param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0f",
                                      _deviceVol]
                              forKey:param_info.name];
                    
                }
            }
            else if([param_info.name isEqualToString:@"TARGET"])
            {
                [param setObject:@"Local"
                          forKey:param_info.name];
            }
            
        }
        
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _deviceId;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        

        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        RgsSceneOperation * opt = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_VOL"];
        return opt;
    }
    return nil;
}
- (id) generateEventOperation_camPol{
    
    if(self._currentCameraPol == nil)
        return nil;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_CAM_POL"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"POL"])
            {
                [param setObject:_currentCameraPol
                          forKey:param_info.name];
            }
            else if([param_info.name isEqualToString:@"TARGET"])
            {
                [param setObject:@"Local"
                          forKey:param_info.name];
            }
            
        }
        
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _deviceId;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
    
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        RgsSceneOperation * opt = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_CAM_POL"];
        return opt;
    }
    return nil;
}
- (NSArray*) generateEventOperation_peq{
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_PEQ"];
    if(cmd)
    {
        NSMutableArray *results = [NSMutableArray array];
        
        for(NSString *bandKey in [_pointsData allKeys])
        {
            NSString *gain = [_pointsData objectForKey:bandKey];
            
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"RATE"])
                {
                    [param setObject:bandKey forKey:param_info.name];
                }
                else if ([param_info.name isEqualToString:@"GAIN"])
                {
                    [param setObject:gain
                              forKey:param_info.name];
                }
            }
            
            if(_rgsProxyObj)
            {
                _deviceId = _rgsProxyObj.m_id;
            }
            
            RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
            scene_opt.dev_id = _deviceId;
            scene_opt.cmd = cmd.name;
            scene_opt.param = param;
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                              cmd:scene_opt.cmd
                                                                            param:scene_opt.param];
            
            
            [results addObject:opt];

        }
        
        return results;
        
    }
    else
    {
        NSMutableArray *results = [NSMutableArray array];
        NSArray *peqs = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_PEQ"];
        if(peqs)
        {
            [results addObjectsFromArray:peqs];
        }
        
        return results;
    }
    return nil;
}
- (id) generateEventOperation_press{
    
    if(self._mixPress == nil)
        return nil;

    float mixPressFloat = [_mixPress floatValue];
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_PRESS"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"LEVEL"])
            {
                if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.1f",
                                      mixPressFloat]
                              forKey:param_info.name];
                }
                else if(param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0f",
                                      mixPressFloat]
                              forKey:param_info.name];
                    
                }
            }
            
        }
        
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _deviceId;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        RgsSceneOperation * opt = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_PRESS"];
        return opt;
    }
    return nil;
    
}
- (id) generateEventOperation_noiseGate{
    
    if(self._mixNoise == nil)
        return nil;

    float mixNoiseFloat = [_mixNoise floatValue];
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_NOISE_GATE"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"LEVEL"])
            {
                if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.1f",
                                      mixNoiseFloat]
                              forKey:param_info.name];
                }
                else if(param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0f",
                                      mixNoiseFloat]
                              forKey:param_info.name];
                    
                }
            }
            else if([param_info.name isEqualToString:@"TARGET"])
            {
                [param setObject:@"Local"
                          forKey:param_info.name];
            }
            
        }
        
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _deviceId;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        RgsSceneOperation * opt = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_NOISE_GATE"];
        return opt;
    }
    return nil;
}
- (id) generateEventOperation_hp{
    
    if(self._mixHighFilter == nil)
        return nil;
    
    float highFilterFloat = [_mixHighFilter floatValue];
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_HIGH_FILTER"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"RATE"])
            {
                if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.1f",
                                      highFilterFloat]
                              forKey:param_info.name];
                }
                else if(param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0f",
                                      highFilterFloat]
                              forKey:param_info.name];
                    
                }
            }
            else if([param_info.name isEqualToString:@"TARGET"])
            {
                [param setObject:@"Local"
                          forKey:param_info.name];
            }
            
        }
        
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _deviceId;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        RgsSceneOperation * opt = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_HIGH_FILTER"];
        return opt;
    }
    return nil;
}
- (id) generateEventOperation_lp{
    
    if(self._mixLowFilter == nil)
        return nil;
    
    float lowFilterFloat = [_mixLowFilter floatValue];
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_LOW_FILTER"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"RATE"])
            {
                if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.1f",
                                      lowFilterFloat]
                              forKey:param_info.name];
                }
                else if(param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0f",
                                      lowFilterFloat]
                              forKey:param_info.name];
                    
                }
            }
            else if([param_info.name isEqualToString:@"TARGET"])
            {
                [param setObject:@"Local"
                          forKey:param_info.name];
            }
            
        }
        
        if(_rgsProxyObj)
        {
            _deviceId = _rgsProxyObj.m_id;
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
        scene_opt.dev_id = _deviceId;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        RgsSceneOperation * opt = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_LOW_FILTER"];
        return opt;
    }
    return nil;
}

@end

