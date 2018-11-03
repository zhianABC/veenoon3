//
//  EDimmerLightProxys.m
//  veenoon
//
//  Created by chen jack on 2018/5/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "EDimmerLightProxys.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@interface EDimmerLightProxys ()
{
    BOOL _isSetOK;
    
}
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@property (nonatomic, strong) NSMutableDictionary *_rgsOpts;

@end


@implementation EDimmerLightProxys
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;

@synthesize _deviceId;

@synthesize _level;
@synthesize _rgsOpts;

- (id) init
{
    if(self = [super init])
    {
        self._level = 0;
       
    }
    
    return self;
}

- (void) getCurrentDataState
{

    if(_rgsProxyObj)
    {
        IMP_BLOCK_SELF(EDimmerLightProxys);
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
    
    id val = [state objectForKey:@"LEVEL"];
    self._level = [val intValue];

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PROXY_CUR_STATE_GOT_LB
                                                        object:@{@"proxy":@(_rgsProxyObj.m_id)}];
}
- (BOOL) isSetChanged{
    
    return _isSetOK;
}


- (void) recoverWithDictionary:(NSArray*)datas
{
    self._rgsOpts = [NSMutableDictionary dictionary];
    
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        _isSetOK = YES;
        
        NSString *cmd = dopt.cmd;
        NSDictionary *param = dopt.param;
        
        if([cmd isEqualToString:@"SET_LIGHT_LEVEL"])
        {
            self._level = [[param objectForKey:@"LEVEL"] intValue];
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
        
        IMP_BLOCK_SELF(EDimmerLightProxys);
        
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

- (void) controlDeviceLightLevel:(int)levelValue exec:(BOOL)exec{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_LIGHT_LEVEL"];
    self._level = levelValue;
    
    if(cmd && exec)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            for(RgsCommandParamInfo *param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"LEVEL"])
                {
                    [param setObject:[NSString stringWithFormat:@"%d", _level]
                              forKey:param_info.name];
                }
            }
        }
        
        //NSLog(@"=====%@", [NSString stringWithFormat:@"%d", _level]);
        
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

- (NSArray*) generateEventOperation_ChLevel{
    
    RgsCommandInfo *cmd = nil;
    
    NSMutableArray *event_opts = [NSMutableArray array];

    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_LIGHT_LEVEL"];
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            for(RgsCommandParamInfo *param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"LEVEL"])
                {
                    [param setObject:[NSString stringWithFormat:@"%d", _level]
                              forKey:param_info.name];
                }
            }
        }
        //NSLog(@"=====%@", [NSString stringWithFormat:@"%d", iLevel]);
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
        RgsSceneOperation * opt = [_rgsOpts objectForKey:@"SET_LIGHT_LEVEL"];
       
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
