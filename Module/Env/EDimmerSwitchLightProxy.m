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
@property (nonatomic, strong) NSMutableArray *_rgsOpts;
@property (nonatomic, strong) NSMutableDictionary* _channelsMap;

@end


@implementation EDimmerSwitchLightProxy
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;

@synthesize _deviceId;
@synthesize _rgsOpts;

@synthesize _channelsMap;

@synthesize _power;

- (id) init
{
    if(self = [super init])
    {
        self._power = 0;
        
        self._channelsMap = [NSMutableDictionary dictionary];
        
        self._rgsOpts = [NSMutableArray array];
        
       
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
    
//    id val = [state objectForKey:@"STATUS"];
//    self._relayStatus = val;
//
//    val = [state objectForKey:@"LINK_DUR"];
//    self._linkDuration = [val intValue];
//
//    val = [state objectForKey:@"BREAK_DUR"];
//    self._breakDuration = [val intValue];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PROXY_CUR_STATE_GOT_LB
//                                                        object:@{@"proxy":@(_rgsProxyObj.m_id)}];
}


- (BOOL) isSetChanged{
    
    return _isSetOK;
}

- (NSDictionary *)getChLevelRecords{
    
    return _channelsMap;
}


- (void) recoverWithDictionary:(NSArray*)datas{
    
    self._rgsOpts = [NSMutableArray array];
    
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        _isSetOK = YES;
        
        NSString *cmd = dopt.cmd;
        NSDictionary *param = dopt.param;
        
        if([cmd isEqualToString:@"SET_CH"])
        {
            NSString *onoff = [param objectForKey:@"POWER"];
            int ch = [[param objectForKey:@"CH"] intValue];
            
            BOOL lv = YES;
            if([onoff isEqualToString:@"OFF"])
                lv = NO;
            
            [self._channelsMap setObject:[NSNumber numberWithInt:lv]
                                  forKey:[NSString stringWithFormat:@"%d", ch]];
            
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [_rgsOpts addObject:opt];
        }
        
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

- (int)getNumberOfLights{
    
    int max = 0;
    RgsCommandInfo *cmd = [self._cmdMap objectForKey:@"SET_CH"];
    if(cmd)
    {
        for(RgsCommandParamInfo *cmdparam in cmd.params)
        {
            if([cmdparam.name isEqualToString:@"CH"])
            {
                max = [cmdparam.max intValue];
                break;
            }
        }
    }
    
    //不要初始化了，没有操控的channel就不需要执行
//    for(int i = 0; i < max; i++){
//
//        [_channelsMap setObject:@0 forKey:[NSNumber numberWithInt:i]];
//    }
    
    return max;
}

- (void) controlDeviceLightPower:(int)powerValue ch:(int)ch{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_CH"];
    self._power = powerValue;
    
    [self._channelsMap setObject:[NSNumber numberWithInt:_power]
                          forKey:[NSString stringWithFormat:@"%d", ch]];
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            for(RgsCommandParamInfo *param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"CH"])
                {
                    [param setObject:[NSString stringWithFormat:@"%d", ch]
                              forKey:param_info.name];
                }
                else if([param_info.name isEqualToString:@"POWER"])
                {
                    NSString *onoff = @"OFF";
                    if(_power)
                    {
                        onoff = @"ON";
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
        cmd = [_cmdMap objectForKey:@"SET_CH"];
    
    if(cmd)
    {
        NSMutableArray *event_opts = [NSMutableArray array];
        for(id chkey in [_channelsMap allKeys])
        {
            
            int iCh = [chkey intValue];
            int iPower = [[_channelsMap objectForKey:chkey] intValue];
            
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            if([cmd.params count])
            {
                for(RgsCommandParamInfo *param_info in cmd.params)
                {
                    if([param_info.name isEqualToString:@"CH"])
                    {
                        [param setObject:[NSString stringWithFormat:@"%d", iCh]
                                  forKey:param_info.name];
                    }
                    else if([param_info.name isEqualToString:@"POWER"])
                    {
                        NSString *onoff = @"OFF";
                        if(iPower)
                        {
                            onoff = @"ON";
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
            
            [_rgsOpts addObject:opt];
        }
        
        return event_opts;
    }
    else
    {
        return _rgsOpts;
    }
    
    return nil;
}

@end
