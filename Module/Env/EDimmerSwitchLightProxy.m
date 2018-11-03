//
//  EDimmerSwitchLightProxy.m
//  veenoon
//
//  Created by chen jack on 2018/5/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "EDimmerSwitchLightProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@interface EDimmerSwitchLightProxy ()
{
    BOOL _isSetOK;
    
}
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@property (nonatomic, strong) NSMutableDictionary *_rgsOpts;

@end


@implementation EDimmerSwitchLightProxy
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;

@synthesize _deviceId;
@synthesize _rgsOpts;

@synthesize _power;

- (id) init
{
    if(self = [super init])
    {
        self._power = 0;
    
       
    }
    
    return self;
}

- (void) getCurrentDataState
{
    if(_rgsProxyObj)
    {
        IMP_BLOCK_SELF(EDimmerSwitchLightProxy);
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
    
    id val = [state objectForKey:@"SWITCH"];
    if(val && [val isEqualToString:@"On"])
    {
        self._power = 1;
    }
    else
    {
        self._power = 0;
    }

//    val = [state objectForKey:@"LINK_DUR"];
//    self._linkDuration = [val intValue];
//
//    val = [state objectForKey:@"BREAK_DUR"];
//    self._breakDuration = [val intValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PROXY_CUR_STATE_GOT_LB
                                                        object:@{@"proxy":@(_rgsProxyObj.m_id)}];
}


- (BOOL) isSetChanged{
    
    return _isSetOK;
}


- (void) recoverWithDictionary:(NSArray*)datas{
    
    self._rgsOpts = [NSMutableDictionary dictionary];
    
    self._power = 0;
    
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        _isSetOK = YES;
        
        NSString *cmd = dopt.cmd;
        NSDictionary *param = dopt.param;
        
        if([cmd isEqualToString:@"SET_SWITCH"])
        {
            NSString *sval = [param objectForKey:@"SWITCH"];
            if(sval && [sval isEqualToString:@"On"])
            {
                self._power = 1;
            }
        }
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                          cmd:dopt.cmd
                                                                        param:dopt.param];
        [_rgsOpts setObject:opt forKey:cmd];
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
    }
    else
    {
        if(_rgsProxyObj == nil || _rgsCommands)
            return;
        
        self._cmdMap = [NSMutableDictionary dictionary];
        
        IMP_BLOCK_SELF(EDimmerSwitchLightProxy);
        
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

- (void) controlDeviceLightPower:(int)powerValue{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SWITCH"];
    self._power = powerValue;
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            for(RgsCommandParamInfo *param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"SWITCH"])
                {
                    NSString *onoff = @"Off";
                    if(_power)
                    {
                        onoff = @"On";
                    }
                    [param setObject:onoff
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

- (NSArray*) generateEventOperation_ChPower{
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_SWITCH"];
    
    NSMutableArray *event_opts = [NSMutableArray array];
    
    if(cmd)
    {
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            for(RgsCommandParamInfo *param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"SWITCH"])
                {
                    NSString *onoff = @"Off";
                    if(_power)
                    {
                        onoff = @"On";
                    }
                    
                    [param setObject:onoff
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
        
        [event_opts addObject:opt];
        
        return event_opts;
    }
    else
    {
        RgsSceneOperation * opt = [_rgsOpts objectForKey:@"SET_SWITCH"];
        
        if(opt)
            [event_opts addObject:opt];
        
        return event_opts;
    }
    
    return nil;
}

- (BOOL) haveProxyCommandLoaded{
    
    if(_rgsCommands)
        return YES;
    
    return NO;
    
}

@end
