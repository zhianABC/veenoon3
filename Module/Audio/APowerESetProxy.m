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
        
        self._channelsMap = [NSMutableDictionary dictionary];
        
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
        
        
    }
    
    return self;
}
- (void) controlRelayStatus:(NSString*)relayStatus {
    _relayStatus = relayStatus;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_RELAY"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST && [param_info.name isEqualToString:@"STATUS"])
            {
                [param setObject:_relayStatus forKey:param_info.name];
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

- (void) controlRelayDuration:(BOOL)isBreak withDuration:(int)duration {
    if (isBreak) {
        _breakDuration = duration;
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
            [[RegulusSDK sharedRegulusSDK] ControlDevice:_rgsProxyObj.m_id
                                                     cmd:cmd.name
                                                   param:param completion:^(BOOL result, NSError *error) {
                                                       if (result) {
                                                           
                                                       }
                                                       else{
                                                           
                                                       }
                                                   }];
        }
    } else {
        _linkDuration = duration;
        RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_LINK_DUR"];
        if(cmd)
        {
            NSMutableDictionary * param = [NSMutableDictionary dictionary];
            if([cmd.params count])
            {
                RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
                if(param_info.type == RGS_PARAM_TYPE_LIST && [param_info.name isEqualToString:@"DUR"])
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
                                                   param:param completion:^(BOOL result, NSError *error) {
                                                       if (result) {
                                                           
                                                       }
                                                       else{
                                                           
                                                       }
                                                   }];
        }
    }
}
- (void) recoverWithDictionary:(NSDictionary *)data
{
    
    
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

@end

