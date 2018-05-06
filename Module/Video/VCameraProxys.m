//
//  VCameraProxys.m
//  veenoon
//
//  Created by chen jack on 2018/5/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "VCameraProxys.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

/*
 SET_ZOOM
 MOVE [UP, DOWN, LEFT, RIGHT, STOP]
 */

@interface VCameraProxys ()
{
    
    
    
}
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;



@end

@implementation VCameraProxys
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;

@synthesize _zoom;
@synthesize _move;

@synthesize _save;
@synthesize _load;


- (id) init
{
    if(self = [super init])
    {
        _save = 0;
        _load = 0;
    }
    
    return self;
}

- (NSArray*)getDirectOptions{

    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"MOVE"];
    if(cmd)
    {
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                return param_info.available;
            }
            
        }
    }
    
    return nil;
}

- (void) checkRgsProxyCommandLoad{
    
    if(_rgsProxyObj == nil || _rgsCommands)
        return;
    
    self._cmdMap = [NSMutableDictionary dictionary];
    
    IMP_BLOCK_SELF(VCameraProxys);
    
    [[RegulusSDK sharedRegulusSDK] GetProxyCommands:_rgsProxyObj.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
        if (result)
        {
            if ([commands count]) {
                block_self._rgsCommands = commands;
                for(RgsCommandInfo *cmd in commands)
                {
                    [block_self._cmdMap setObject:cmd forKey:cmd.name];
                }
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

- (void) controlDeviceDirection:(NSString*)direct{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"MOVE"];
    self._move = direct;
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:direct forKey:param_info.name];
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

- (void) controlDeviceSavePostion{
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SAVE"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_FLOAT)
            {
                [param setObject:[NSString stringWithFormat:@"%0.1f",(float)_save]
                          forKey:param_info.name];
            }
            else if(param_info.type == RGS_PARAM_TYPE_INT)
            {
                [param setObject:[NSString stringWithFormat:@"%d",_save]
                          forKey:param_info.name];
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

- (void) controlDeviceLoadPostion{
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"LOAD"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_FLOAT)
            {
                [param setObject:[NSString stringWithFormat:@"%0.1f",(float)_save]
                          forKey:param_info.name];
            }
            else if(param_info.type == RGS_PARAM_TYPE_INT)
            {
                [param setObject:[NSString stringWithFormat:@"%d",_save]
                          forKey:param_info.name];
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

- (void) controlDeviceZoom:(NSString*)zoom{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_ZOOM"];
    self._zoom = zoom;
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:zoom forKey:param_info.name];
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

- (void) stopControlDeviceDirection{
    
    [self controlDeviceDirection:@"STOP"];
}

- (BOOL) isSetChanged{
    
    if(_cmdMap)
        return YES;
    
    return NO;
}

- (id) generateEventOperation_Postion{
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"LOAD"];
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_FLOAT)
            {
                [param setObject:[NSString stringWithFormat:@"%0.1f",(float)_save]
                          forKey:param_info.name];
            }
            else if(param_info.type == RGS_PARAM_TYPE_INT)
            {
                [param setObject:[NSString stringWithFormat:@"%d",_save]
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
    
    return nil;
}

@end
