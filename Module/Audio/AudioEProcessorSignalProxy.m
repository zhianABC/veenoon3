//
//  AudioEProcessorAutoMixProxy.m
//  veenoon
//
//  Created by 安志良 on 2018/6/23.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEProcessorSignalProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"


@interface AudioEProcessorSignalProxy ()
{
    BOOL _isSetOK;
}
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;

@end

@implementation AudioEProcessorSignalProxy

//zidonghunyin
@synthesize _xinhaofashengZengYi;
@synthesize _xinhaofashengOutputChanels;
@synthesize _cmdMap;
@synthesize _rgsProxyObj;
@synthesize delegate;
@synthesize _rgsCommands;
@synthesize _xinhaofashengPinlv;
@synthesize _isXinhaofashengMute;
@synthesize _xinhaofashengZhengxuan;
@synthesize _RgsSceneDeviceOperationShadow;


- (id) init
{
    if(self = [super init])
    {
        self._xinhaofashengZengYi = @"10";
        self._xinhaofashengPinlv = @"200";
        self._xinhaofashengZhengxuan = @"Pink";
        _isXinhaofashengMute = NO;
        
        self._xinhaofashengOutputChanels = [NSMutableDictionary dictionary];
        
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
        
    }
    return self;
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
    
    IMP_BLOCK_SELF(AudioEProcessorSignalProxy);
    
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

- (void) callDelegateDidLoad{
    
    if(delegate && [delegate respondsToSelector:@selector(didLoadedProxyCommand)])
    {
        [delegate didLoadedProxyCommand];
    }
}

- (void) initDatasAfterPullData{
    
}

- (NSArray*)getSignalType{
    
    NSMutableArray *result = [NSMutableArray array];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SIG_TYPE"];
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

#pragma mark ---- 自动混音 ----

- (NSDictionary*)getSignalRateSettings {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SIG_SINE_RATE"];
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

#pragma mark ---- 自动混音 ----

- (NSDictionary*)getSignalGainSettings {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SIG_GAIN"];
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
                }
                
            }
        }
    }
    
    return result;
}

- (NSString*) getXinhaofashengZengYi {
    return self._xinhaofashengZengYi;
}
- (void) controlXinhaofashengZengYi:(NSString*) zengyiDB {
    self._xinhaofashengZengYi = zengyiDB;
    
    [self controlXinhaoZengyi];
}

- (void) controlXinhaoZengyi {
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_SIG_GAIN"];
    
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            double zidonghunyinZengyi = [_xinhaofashengZengYi doubleValue];
            
            for(RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"GAIN"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          zidonghunyinZengyi]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          zidonghunyinZengyi]
                                  forKey:param_info.name];
                        
                    }
                }
            }
            
        }
        
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:nil];
    }
}

- (NSString*) getXinhaofashengPinlv {
    return self._xinhaofashengPinlv;
}
- (void) controlXinhaofashengPinlv:(NSString*) pinlv {
    self._xinhaofashengPinlv = pinlv;
    
    [self controlXinhaoPinlv];
}

- (void) controlXinhaoPinlv {
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_SIG_SINE_RATE"];
    
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            double zidonghunyinZengyi = [_xinhaofashengPinlv doubleValue];
            
            for(RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"RATE"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          zidonghunyinZengyi]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          zidonghunyinZengyi]
                                  forKey:param_info.name];
                        
                    }
                }
            }
            
        }
        
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:nil];
    }
}
- (NSString*) getXinhaofashengZhengXuan {
    return self._xinhaofashengZhengxuan;
}
- (void) controlXinhaofashengZhengxuan:(NSString*) zhengxuan {
    self._xinhaofashengZhengxuan = zhengxuan;
    
    [self controlXinhaoZhengxuan];
}

- (void) controlXinhaoZhengxuan {
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SIG_TYPE"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"TYPE"])
                {
                    [param setObject:_xinhaofashengZhengxuan
                              forKey:param_info.name];
                }
            }
            
            if([param count])
            {
                [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                         cmd:cmd.name
                                                       param:param completion:nil];
            }
            
        }
    }
}


- (BOOL) isXinhaofashengMute {
    return self._isXinhaofashengMute;
}
- (void) controlXinhaofashengMute:(BOOL)isMute {
    self._isXinhaofashengMute = isMute;
    
    [self controlXinhaoMute];
}

-(void) controlXinhaoMute {
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SIG_MUTE"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_isXinhaofashengMute)
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
                if([param_info.name isEqualToString:@"MUTE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                }
            }
        }
        
        if([param count])
        {
            [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                     cmd:cmd.name
                                                   param:param completion:nil];
        }
    }
}
- (void) controlSignalWithOutState:(NSString*) proxyName withState:(BOOL)state {
    
    
    if (state) {
        [_xinhaofashengOutputChanels setObject:@1 forKey:proxyName];
    } else {
        [_xinhaofashengOutputChanels setObject:@0 forKey:proxyName];
    }
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_SIG_OUT"];
    
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            
            NSString *name = [proxyName stringByReplacingOccurrencesOfString:@" " withString:@""];
            [param setObject:name forKey:param_info.name];
            
            if(state)
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
                                               param:param completion:nil];
    }
}

- (NSArray*) generateEventOperation_sigOut{

    NSMutableArray *results = [NSMutableArray array];
    
    RgsCommandInfo *cmd = nil;
    if(_cmdMap)
    cmd = [_cmdMap objectForKey:@"SET_SIG_OUT"];
    
    if(cmd)
    {
        for(NSString* proxyName in [_xinhaofashengOutputChanels allKeys])
        {
            int state = [[_xinhaofashengOutputChanels objectForKey:proxyName] intValue];
            
            id opt = [self generateEventOperation_sigOutWith:proxyName state:state];
            
            if(opt)
            {
                [results addObject:opt];
            }
        }
    
    }
    else
    {
        NSArray *arrs = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_SIG_OUT"];
        if(arrs)
        [results addObjectsFromArray:arrs];
    }
    return results;
    
}

- (id) generateEventOperation_sigOutWith:(NSString*)proxyName state:(int)state{
    
    RgsCommandInfo *cmd = nil;
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_SIG_OUT"];
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            NSString *name = [proxyName stringByReplacingOccurrencesOfString:@" " withString:@""];
            [param setObject:name forKey:param_info.name];
            
            if(state)
            {
                [param setObject:@"True" forKey:@"ENABLE"];
            }
            else
            {
                [param setObject:@"False" forKey:@"ENABLE"];
            }
            
        }
    
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    
    return nil;
    
}

- (id) generateEventOperation_sigMute{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SIG_MUTE"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_isXinhaofashengMute)
        {
            tureOrFalse = @"True";
        }
        else
        {
            tureOrFalse = @"False";
        }
        
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"MUTE"])
            {
                [param setObject:tureOrFalse
                          forKey:param_info.name];
            }
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        

        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        return [_RgsSceneDeviceOperationShadow objectForKey:@"SET_SIG_MUTE"];
    }
    
    return nil;
}
- (id) generateEventOperation_sigType{
    
    if(_xinhaofashengZhengxuan == nil)
        return nil;
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SIG_TYPE"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"TYPE"])
            {
                [param setObject:_xinhaofashengZhengxuan
                          forKey:param_info.name];
            }
        }

        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        return [_RgsSceneDeviceOperationShadow objectForKey:@"SET_SIG_TYPE"];
    }
    
    return nil;
}
- (id) generateEventOperation_sigSineRate{
    
    if(_xinhaofashengPinlv == nil)
        return nil;
    
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_SIG_SINE_RATE"];
    
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        float zidonghunyinZengyi = [_xinhaofashengPinlv floatValue];
        
        for(RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"RATE"])
            {
                if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    
                    [param setObject:[NSString stringWithFormat:@"%0.1f",
                                      zidonghunyinZengyi]
                              forKey:param_info.name];
                }
                else if(param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0f",
                                      zidonghunyinZengyi]
                              forKey:param_info.name];
                    
                }
            }
        }
            
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
       
    }
    else
    {
        return [_RgsSceneDeviceOperationShadow objectForKey:@"SET_SIG_SINE_RATE"];
    }
    
    return nil;
}
- (id) generateEventOperation_sigGain{
    
    if(_xinhaofashengZengYi == nil)
        return nil;
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_SIG_GAIN"];
    
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        float zidonghunyinZengyi = [_xinhaofashengZengYi floatValue];
        
        for(RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"GAIN"])
            {
                if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    
                    [param setObject:[NSString stringWithFormat:@"%0.1f",
                                      zidonghunyinZengyi]
                              forKey:param_info.name];
                }
                else if(param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0f",
                                      zidonghunyinZengyi]
                              forKey:param_info.name];
                    
                }
            }
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        return [_RgsSceneDeviceOperationShadow objectForKey:@"SET_SIG_GAIN"];
    }
    
    return nil;
}

/////场景还原
- (void) recoverWithDictionary:(NSArray*)datas{
    
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        _isSetOK = YES;
        
        NSString *cmd = dopt.cmd;
        NSDictionary *param = dopt.param;
        
        if([cmd isEqualToString:@"SET_SIG_OUT"]){
            
            
            NSString *src = [param objectForKey:@"OUT"];
            NSString *enable = [param objectForKey:@"ENABLE"];
            
            if ([enable isEqualToString:@"True"]) {
                [_xinhaofashengOutputChanels setObject:@1 forKey:src];
            } else {
                [_xinhaofashengOutputChanels setObject:@0 forKey:src];
            }
            
            
            NSMutableArray *arrs = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_SIG_OUT"];
            if(arrs == nil)
            {
                arrs = [NSMutableArray array];
                [_RgsSceneDeviceOperationShadow setObject:arrs forKey:@"SET_SIG_OUT"];
            }
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [arrs addObject:opt];
            
            
        }
        else
        {
            if([cmd isEqualToString:@"SET_SIG_MUTE"])
            {
                NSString *enable = [param objectForKey:@"MUTE"];
                
                if ([enable isEqualToString:@"True"]) {
                    _isXinhaofashengMute = YES;
                } else {
                    _isXinhaofashengMute = NO;
                }
                
            }
            else if([cmd isEqualToString:@"SET_SIG_TYPE"])
            {
                NSString *src = [param objectForKey:@"TYPE"];
                self._xinhaofashengZhengxuan = src;
                
            }
            else if([cmd isEqualToString:@"SET_SIG_SINE_RATE"])
            {
                NSString *src = [param objectForKey:@"RATE"];
                self._xinhaofashengPinlv = src;
                
            }
            else if([cmd isEqualToString:@"SET_SIG_GAIN"])
            {
                NSString *src = [param objectForKey:@"GAIN"];
                self._xinhaofashengZengYi = src;
                
            }
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [_RgsSceneDeviceOperationShadow setObject:opt forKey:cmd];
        }
    }
}

@end

