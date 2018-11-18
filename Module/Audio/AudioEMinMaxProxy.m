//
//  AudioEMinMaxProxy.m
//  veenoon
//
//  Created by chen jack on 2018/11/18.
//  Copyright © 2018 jack. All rights reserved.
//

#import "AudioEMinMaxProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "DriverCmdSync.h"


@interface AudioEMinMaxProxy ()
{
    BOOL _isSetOK;
    BOOL _isMute;
    int _volume;
    
    int maxVol;
    int minVol;
}
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;

@end

@implementation AudioEMinMaxProxy
@synthesize _rgsProxyObj;

@synthesize _rgsCommands;
@synthesize _cmdMap;
@synthesize _RgsSceneDeviceOperationShadow;

- (id) init
{
    if(self = [super init])
    {
        minVol = -32;
        maxVol = 0;
        
        _volume = -32;
        _isMute = NO;
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (BOOL)getMute{
    
    return _isMute;
}

- (int)getVol{
    
    return _volume;
}
- (int)getMinVolRange{
    return minVol;
}
- (int)getMaxVolRange{
    return maxVol;
}


- (void) getCurrentDataState
{
    if(_rgsProxyObj)
    {
        IMP_BLOCK_SELF(AudioEMinMaxProxy);
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
    
    _isMute = NO;
    
    NSString *val = [state objectForKey:@"MUTE"];
    if([val isKindOfClass:[NSString class]])
    {
        if([[val lowercaseString] isEqualToString:@"true"])
        {
            _isMute = YES;
        }
    }
    
    val = [state objectForKey:@"VOLUME"];
    _volume = [val intValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PROXY_CUR_STATE_GOT_LB
                                                        object:@{@"proxy":@(_rgsProxyObj.m_id)}];
}


- (void) syncDeviceDataRealtime{
    
    if(_rgsProxyObj)
        [[RegulusSDK sharedRegulusSDK] QueryProxyStateInCallBack:_rgsProxyObj.m_id completion:nil];
    
}

- (void) updateRealtimeData:(NSDictionary*)data{
    
    /*
    
     */
}

- (BOOL) haveProxyCommandLoaded{
    
    if(_rgsCommands)
        return YES;
    
    return NO;
    
}

- (void) checkRgsProxyCommandLoad:(NSArray*)cmds{
    
    
    if(cmds && [cmds count])
    {
        self._cmdMap = [NSMutableDictionary dictionary];
        
        self._rgsCommands = cmds;
        for(RgsCommandInfo *cmd in cmds)
        {
            [self._cmdMap setObject:cmd forKey:cmd.name];
            
            if([cmd.name isEqualToString:@"SET_VOLUME"])
            {
                for( RgsCommandParamInfo * param_info in cmd.params)
                {
                    if([param_info.name isEqualToString:@"VOL"])
                    {
                        if(param_info.max)
                            maxVol = [param_info.max intValue];
                        if(param_info.min)
                            minVol = [param_info.min intValue];
                        break;
                    }
                }
            }
        }
        
        _isSetOK = YES;
        
        
    }
    else
    {
        if(_rgsProxyObj == nil || _rgsCommands)
            return;
        
        self._cmdMap = [NSMutableDictionary dictionary];
        
        IMP_BLOCK_SELF(AudioEMinMaxProxy);
        
        [[RegulusSDK sharedRegulusSDK] GetProxyCommands:_rgsProxyObj.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
            if (result)
            {
                [block_self saveProxyCmds:commands];
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

- (void) saveProxyCmds:(NSArray*)commands{
    
    if ([commands count]) {
        
        self._rgsCommands = commands;
        
        for(RgsCommandInfo *cmd in commands)
        {
            [self._cmdMap setObject:cmd forKey:cmd.name];
            
            if([cmd.name isEqualToString:@"SET_VOLUME"])
            {
                for( RgsCommandParamInfo * param_info in cmd.params)
                {
                    if([param_info.name isEqualToString:@"VOL"])
                    {
                        if(param_info.max)
                            maxVol = [param_info.max intValue];
                        if(param_info.min)
                            minVol = [param_info.min intValue];
                        break;
                    }
                }
            }
        }
        
        _isSetOK = YES;
        
        [[DriverCmdSync sharedCMDSync] syncCmdMap:commands
                                           andKey:@"AudioEMinMaxProxy"];
    }
}

- (BOOL) isSetChanged{
    
    return _isSetOK;
}


- (void) recoverWithDictionary:(NSArray*)datas{
    
    [_RgsSceneDeviceOperationShadow removeAllObjects];
    
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        _isSetOK = YES;
        
        
         NSString *cmd = dopt.cmd;
         NSDictionary *param = dopt.param;
         
         
         if([cmd isEqualToString:@"SET_MUTE"])
         {
             NSString *enable = [param objectForKey:@"ENABLE"];
             if([enable isEqualToString:@"True"])
             {
                 _isMute = YES;
             }
             else
             {
                 _isMute = NO;
             }
             
         }
         else if([cmd isEqualToString:@"SET_VOLUME"])
         {
             _volume = [[param objectForKey:@"VOL"] intValue];
         }
         
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                          cmd:dopt.cmd
                                                                        param:dopt.param];
        [_RgsSceneDeviceOperationShadow setObject:opt forKey:cmd];
        
    }
    
}

- (void) controlDeviceMute:(BOOL)isMute exec:(BOOL)exec{
    
    _isSetOK = YES;
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_MUTE"];
    
    _isMute = isMute;
    
    NSString * tureOrFalse = @"False";
    if(_isMute)
        tureOrFalse = @"True";
    
    if(exec && cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"ENABLE"])
            {
                [param setObject:tureOrFalse
                          forKey:param_info.name];
            }
        }
        
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:nil];
    }
}

- (id) generateEventOperation_Mute{
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_MUTE"];
    if(cmd)
    {
        NSString * tureOrFalse = @"False";
        if(_isMute)
            tureOrFalse = @"True";
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"ENABLE"])
            {
                [param setObject:tureOrFalse
                          forKey:param_info.name];
            }
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
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
        return  [_RgsSceneDeviceOperationShadow objectForKey:@"SET_MUTE"];
    }
    return nil;
}

- (void) controlDeviceVol:(int)vol exec:(BOOL)exec{
    
    _isSetOK = YES;
    
    _volume = vol;

    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_VOLUME"];
    
    if(exec && cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"VOL"])
            {
                [param setObject:[NSString stringWithFormat:@"%d", _volume]
                          forKey:param_info.name];
            }
        }
        
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:nil];
    }
    
}
- (id) generateEventOperation_Vol{
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_VOLUME"];
    if(cmd)
    {
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"VOL"])
            {
                [param setObject:[NSString stringWithFormat:@"%d", _volume]
                          forKey:param_info.name];
            }
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
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
        return  [_RgsSceneDeviceOperationShadow objectForKey:@"SET_VOLUME"];
    }
    return nil;
}


@end
