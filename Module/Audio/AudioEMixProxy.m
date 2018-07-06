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


@end

@implementation AudioEMixProxy
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;

@synthesize _deviceVol;
@synthesize _currentCameraPol;
@synthesize _cameraPol;

@synthesize _deviceId;
@synthesize _RgsSceneDeviceOperationShadow;


- (id) init
{
    if(self = [super init])
    {
        _deviceVol = 20.0f;
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
        _cameraPol = [NSMutableArray array];
    }
    
    return self;
}

- (NSDictionary *)getScenarioSliceLocatedShadow{
    
    return _RgsSceneDeviceOperationShadow;
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


- (void) recoverWithDictionary:(NSDictionary*)data{
    
    NSInteger proxy_id = [[data objectForKey:@"proxy_id"] intValue];
    if(proxy_id == _deviceId)
    {
        
        if([data objectForKey:@"RgsSceneDeviceOperation"]){
            self._RgsSceneDeviceOperationShadow = [data objectForKey:@"RgsSceneDeviceOperation"];
            _isSetOK = YES;
        }
        
        
    }
    
}
- (void) controlDeviceCameraPol:(NSString*)cameraPol {
    _currentCameraPol = cameraPol;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_CAM_POL"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_FLOAT)
            {
                [param setObject:_currentCameraPol forKey:param_info.name];
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
//SET_VOL
- (void) controlDeviceVol:(float)db force:(BOOL)force{
    
    _deviceVol = db;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_VOL"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"VOL"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          db]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          db]
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


@end

