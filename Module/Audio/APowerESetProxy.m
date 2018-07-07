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

@synthesize _deviceId;
@synthesize _RgsSceneDeviceOperationShadow;

@synthesize _channelsMap;

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

