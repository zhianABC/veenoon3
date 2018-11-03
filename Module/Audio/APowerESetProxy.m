//
//  EDimmerLightProxys.m
//  veenoon
//
//  Created by chen jack on 2018/5/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "APowerESetProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@interface APowerESetProxy ()
{
    BOOL _isSetOK;
    
}
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;
@property (nonatomic, strong) NSMutableDictionary* _channelsMap;

@end


@implementation APowerESetProxy
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;
@synthesize _relayStatus;
@synthesize _deviceId;
@synthesize _RgsSceneDeviceOperationShadow;
@synthesize _linkDuration;
@synthesize _channelsMap;
@synthesize _breakDuration;
@synthesize _level;

- (id) init
{
    if(self = [super init])
    {
        self._level = 0;
        self._linkDuration = 0;
        self._breakDuration = 0;
        
        self._relayStatus = @"Break";
        
        self._channelsMap = [NSMutableDictionary dictionary];
        
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
        
        
    }
    
    return self;
}

- (BOOL) isOnOff{
    
    if([_relayStatus isEqualToString:@"Link"])
        return YES;
    
    return NO;
}


- (void) getCurrentDataState
{
    if(_rgsProxyObj)
    {
        IMP_BLOCK_SELF(APowerESetProxy);
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
    
    id val = [state objectForKey:@"STATUS"];
    self._relayStatus = val;
    
    val = [state objectForKey:@"LINK_DUR"];
    self._linkDuration = [val intValue];
    
    val = [state objectForKey:@"BREAK_DUR"];
    self._breakDuration = [val intValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PROXY_CUR_STATE_GOT_LB
                                                            object:@{@"proxy":@(_rgsProxyObj.m_id)}];
}

- (void) recoverWithDictionary:(NSArray*)datas
{
    [_RgsSceneDeviceOperationShadow removeAllObjects];
    
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        _isSetOK = YES;
        
        NSString *cmd = dopt.cmd;
        NSDictionary *param = dopt.param;
        
        if([cmd isEqualToString:@"SET_RELAY"])
        {
            self._relayStatus = [param objectForKey:@"STATUS"];

        }
        else if([cmd isEqualToString:@"SET_BREAK_DUR"])
        {
            _breakDuration = [[param objectForKey:@"DUR"] intValue];
        
        }
        else if([cmd isEqualToString:@"SET_LINK_DUR"])
        {
            _linkDuration = [[param objectForKey:@"DUR"] intValue];
            
        }
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                          cmd:dopt.cmd
                                                                        param:dopt.param];
        [_RgsSceneDeviceOperationShadow setObject:opt forKey:cmd];
    }
}

- (void) controlRelayStatus:(NSString*)relayStatus {
    
    self._relayStatus = relayStatus;
    
    if(_relayStatus == nil)
        return;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_RELAY"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if([param_info.name isEqualToString:@"STATUS"])
            {
                [param setObject:_relayStatus forKey:param_info.name];
            }
        }
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                 cmd:cmd.name
                                               param:param completion:nil];
    }
}

- (void) controlRelayDuration:(BOOL)isBreak withDuration:(int)duration exec:(BOOL)exec{
   
    if (isBreak)
    {
        _breakDuration = duration;
        RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_BREAK_DUR"];
        if(cmd && exec)
        {
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            if([cmd.params count])
            {
                RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
                if([param_info.name isEqualToString:@"DUR"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1d",_breakDuration]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0d",_breakDuration]
                                  forKey:param_info.name];
                    }
                }
            }
            [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                     cmd:cmd.name
                                                   param:param completion:nil];
        }
    }
    else
    {
        _linkDuration = duration;
        RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_LINK_DUR"];
        if(cmd && exec)
        {
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            if([cmd.params count])
            {
                RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
                if([param_info.name isEqualToString:@"DUR"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1d",_linkDuration]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0d",_linkDuration]
                                  forKey:param_info.name];
                    }
                }
            }
            [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                     cmd:cmd.name
                                                   param:param completion:nil];
        }
    }
}


- (BOOL) haveProxyCommandLoaded{
    
    if(_rgsCommands)
        return YES;
    
    return NO;
    
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


- (void) initDatasAfterPullData{
    
}


- (BOOL) isSetChanged{
    
    return _isSetOK;
}

- (NSDictionary *)getChLevelRecords{
    
    return _channelsMap;
}

- (NSDictionary *)getScenarioSliceLocatedShadow{
    
    return _RgsSceneDeviceOperationShadow;
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
    }
    else
    {
        if(_rgsProxyObj == nil || _rgsCommands)
            return;
        
        self._cmdMap = [NSMutableDictionary dictionary];
        
        IMP_BLOCK_SELF(APowerESetProxy);
        
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

- (id) generateEventOperation_status{
    
    if(_relayStatus == nil)
        return nil;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_RELAY"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if([param_info.name isEqualToString:@"STATUS"])
            {
                [param setObject:_relayStatus forKey:param_info.name];
            }
        }
        int proxyid = (int)_rgsProxyObj.m_id;
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
        scene_opt.dev_id = proxyid;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:proxyid] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_RELAY"];
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        return [_RgsSceneDeviceOperationShadow objectForKey:@"SET_RELAY"];
    }
    
    return nil;
    
}
- (id) generateEventOperation_breakDur{
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_BREAK_DUR"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if([param_info.name isEqualToString:@"DUR"])
            {
                if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.1d",_breakDuration]
                              forKey:param_info.name];
                }
                else if(param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0d",_breakDuration]
                              forKey:param_info.name];
                }
            }
        }
        int proxyid = (int)_rgsProxyObj.m_id;
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
        scene_opt.dev_id = proxyid;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:proxyid] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"SET_BREAK_DUR"];
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        return [_RgsSceneDeviceOperationShadow objectForKey:@"SET_BREAK_DUR"];
    }
    
    return nil;
}
- (id) generateEventOperation_linkDur{
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_LINK_DUR"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if([param_info.name isEqualToString:@"DUR"])
            {
                if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.1d",_linkDuration]
                              forKey:param_info.name];
                }
                else if(param_info.type == RGS_PARAM_TYPE_INT)
                {
                    [param setObject:[NSString stringWithFormat:@"%0.0d",_linkDuration]
                              forKey:param_info.name];
                }
            }
        }
        int proxyid = (int)_rgsProxyObj.m_id;
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
        scene_opt.dev_id = proxyid;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
    
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        return [_RgsSceneDeviceOperationShadow objectForKey:@"SET_LINK_DUR"];
    }
    
    return nil;
}

@end

