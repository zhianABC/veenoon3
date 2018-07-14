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
                                               param:param completion:^(BOOL result, NSError *error) {
                                                   if (result) {
                                                       
                                                   }
                                                   else{
                                                       
                                                   }
                                               }];
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
                                               param:param completion:^(BOOL result, NSError *error) {
                                                   if (result) {
                                                       
                                                   }
                                                   else{
                                                       
                                                   }
                                               }];
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
                                                   param:param completion:^(BOOL result, NSError *error) {
                                                       if (result) {
                                                           
                                                       }
                                                       else{
                                                           
                                                       }
                                                   }];
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
                                               param:param completion:^(BOOL result, NSError *error) {
                                                   if (result) {
                                                       
                                                   }
                                                   else{
                                                       
                                                   }
                                               }];
    }
}

- (NSArray*) generateEventOperation_sigOut{

    NSMutableArray *results = [NSMutableArray array];
    for(NSString* proxyName in [_xinhaofashengOutputChanels allKeys])
    {
        int state = [[_xinhaofashengOutputChanels objectForKey:proxyName] intValue];
        
        id opt = [self generateEventOperation_sigOutWith:proxyName state:state];
        
        if(opt)
        {
            [results addObject:opt];
        }
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        
        NSMutableDictionary *src_map = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_SIG_OUT"];
        if(src_map == nil)
        {
            src_map = [NSMutableDictionary dictionary];
            [_RgsSceneDeviceOperationShadow setObject:src_map forKey:@"SET_SIG_OUT"];
        }
        [src_map setObject:slice forKey:proxyName];
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSMutableDictionary *src_map = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_SIG_OUT"];
        if(src_map )
        {
            NSDictionary *cmdsRev = [src_map objectForKey:proxyName];
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_SIG_MUTE"];
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_SIG_MUTE"];
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_SIG_TYPE"];
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_SIG_TYPE"];
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_SIG_SINE_RATE"];
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
       
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_SIG_SINE_RATE"];
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
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_SIG_GAIN"];
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_SIG_GAIN"];
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

