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

@property (nonatomic, strong) NSMutableDictionary *_pointsData;

@end

@implementation AudioEMixProxy
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;

@synthesize _deviceVol;
@synthesize _currentCameraPol;
@synthesize _cameraPol;
@synthesize _fayanPriority;
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
        _deviceVol = 20.0f;
        self._mixLowFilter = @"14";
        self._mixHighFilter = @"60";
        self._mixPEQ = @"4";
        self._mixNoise = @"7";
        self._mixPress = @"5";
        self._mixPEQRate = @"180";
        self._currentCameraPol = @"VISCA";
        self._workMode = @"Speak";
        
        self._fayanPriority = 1;
        
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
        _cameraPol = [NSMutableArray array];
    }
    
    return self;
}

- (NSDictionary *)getScenarioSliceLocatedShadow{
    
    return _RgsSceneDeviceOperationShadow;
}

- (void) controlWorkMode:(NSString*)workMode {
    
    self._workMode = workMode;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_MODE"];
    
    NSString *commond = nil;
    
    if ([_workMode isEqualToString:@"语音激励"]) {
        commond = @"Speak";
    } else if ([_workMode isEqualToString:@"标准发言"]) {
        commond = @"Work";
    } else {
        commond = @"";
    }
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
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_HIGHT_FILTER"];
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
   
    
    self._mixPEQ = mixPEQ;
    self._mixPEQRate = peqRate;
    
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
                    [param setObject:_mixPEQRate forKey:param_info.name];
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
    
    self._fayanPriority = fayanPriority;
    self._zhuxiDaibiao = type;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_PRIORITY"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"COUNT"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%d", _fayanPriority]
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
    
    self._pointsData = [NSMutableDictionary dictionary];
    
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

- (void) recoverWithDictionary:(NSDictionary*)data{
    
    NSInteger proxy_id = [[data objectForKey:@"proxy_id"] intValue];
    if(proxy_id == _deviceId)
    {
        
        if([data objectForKey:@"RgsSceneDeviceOperation"]){
            NSDictionary *dic = [data objectForKey:@"RgsSceneDeviceOperation"];
            self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionaryWithDictionary:dic];
            _isSetOK = YES;
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
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_MODE"];
    NSString *commond = nil;
    
    if ([_workMode isEqualToString:@"语音激励"]) {
        commond = @"Speak";
    } else if ([_workMode isEqualToString:@"标准发言"]) {
        commond = @"Work";
    } else {
        commond = @"";
    }
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_deviceId] forKey:@"dev_id"];
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_deviceId] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_PRIORITY"];
        
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_PRIORITY"];
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_deviceId] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_VOL"];
        
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_VOL"];
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_deviceId] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_CAM_POL"];
        
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_CAM_POL"];
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
            
            RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
            scene_opt.dev_id = _deviceId;
            scene_opt.cmd = cmd.name;
            scene_opt.param = param;
            
            //用于保存还原
            NSMutableDictionary *slice = [NSMutableDictionary dictionary];
            [slice setObject:[NSNumber numberWithInteger:_deviceId] forKey:@"dev_id"];
            [slice setObject:cmd.name forKey:@"cmd"];
            [slice setObject:param forKey:@"param"];
            
            NSMutableDictionary *peq_map = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_PEQ"];
            if(peq_map == nil)
            {
                peq_map = [NSMutableDictionary dictionary];
                [_RgsSceneDeviceOperationShadow setObject:peq_map forKey:@"SET_PEQ"];
            }
            
            [peq_map setObject:slice forKey:bandKey];
            
            [_RgsSceneDeviceOperationShadow setObject:peq_map forKey:@"SET_PEQ"];
            
            
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
        
        NSMutableDictionary *peq_map = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_PEQ"];
        if(peq_map)
        {
            NSArray *bandKeys = [peq_map allKeys];
            
            for(NSString *bandKey in bandKeys)
            {
                NSDictionary *cmdsRev = [peq_map objectForKey:bandKey];
                if(cmdsRev)
                {
                    RgsSceneOperation * opt = [[RgsSceneOperation alloc]
                                               initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
                                               cmd:[cmdsRev objectForKey:@"cmd"]
                                               param:[cmdsRev objectForKey:@"param"]];
                    
                    [results addObject:opt];
                }
            }
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_deviceId] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_PRESS"];
        
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_PRESS"];
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_deviceId] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_NOISE_GATE"];
        
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_NOISE_GATE"];
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
- (id) generateEventOperation_hp{
    
    if(self._mixHighFilter == nil)
        return nil;
    
    float highFilterFloat = [_mixHighFilter floatValue];
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_HIGHT_FILTER"];
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_deviceId] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_HIGHT_FILTER"];
        
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_HIGHT_FILTER"];
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_deviceId] forKey:@"dev_id"];
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

@end

