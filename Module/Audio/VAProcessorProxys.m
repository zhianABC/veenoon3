//
//  VAProcessorProxys.m
//  veenoon
//
//  Created by chen jack on 2018/5/4.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "VAProcessorProxys.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@interface VAProcessorProxys ()
{
    float _voiceDb;
    BOOL _isMute;
    BOOL _isDigitalMute;
    float _digitalGain;
}
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@end

@implementation VAProcessorProxys
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;

- (id) init
{
    if(self = [super init])
    {
        _isMute = NO;
        _isDigitalMute = NO;
        _voiceDb = 0;
        _digitalGain = 0;
    }
    
    return self;
}

- (BOOL) isProxyMute{
    
    return _isMute;
}
- (BOOL) isProxyDigitalMute{
    
    return _isDigitalMute;
}
- (void) checkRgsProxyCommandLoad{
    
    if(_rgsProxyObj == nil || _rgsCommands)
        return;
    
    self._cmdMap = [NSMutableDictionary dictionary];
    
    IMP_BLOCK_SELF(VAProcessorProxys);
    
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


/*
 SET_MUTE
 SET_UNMUTE
 SET_DIGIT_MUTE options [True, False]
 SET_DIGIT_GRAIN
 SET_ANALOGY_GRAIN
 SET_INVERTED
 SET_MODE  options [LINE, MIC]
 SET_MIC_DB
 SET_48V
 SET_NOISE_GATE
 SET_FB_CTRL
 SET_PRESS_LIMIT
 SET_DELAY
 SET_HIGH_FILTER
 SET_LOW_FILTER
 SET_PEQ
 */
//SET_ANALOGY_GRAIN
- (void) controlDeviceDb:(float)db force:(BOOL)force{
    
//    if(!force)
//    {
//        int iv = _voiceDb;
//        int now = db;
//        
//        if(iv == now)
//            return;
//    }
    _voiceDb = db;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_ANALOGY_GRAIN"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_FLOAT)
            {
                [param setObject:[NSString stringWithFormat:@"%0.1f",_voiceDb]
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

- (void) controlDeviceDigitalGain:(float)digVal{
    
    _digitalGain = digVal;
    
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_DIGIT_GRAIN"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_FLOAT)
            {
                [param setObject:[NSString stringWithFormat:@"%0.1f",digVal]
                          forKey:param_info.name];
            }
            else if(param_info.type == RGS_PARAM_TYPE_INT)
            {
                [param setObject:[NSString stringWithFormat:@"%0.0f",digVal]
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
- (void) controlDeviceMute:(BOOL)isMute{
    
    RgsCommandInfo *cmd = nil;
    if(isMute)
    {
        cmd = [_cmdMap objectForKey:@"SET_MUTE"];
        
        _isMute = YES;
    }
    else
    {
        cmd = [_cmdMap objectForKey:@"SET_UNMUTE"];
        
        _isMute = NO;
    }
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
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

- (void) controlDigtalMute:(BOOL)isMute{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_DIGIT_MUTE"];
    NSString* tureOrFalse = @"False";
    if(isMute)
    {
        tureOrFalse = @"True";
        _isDigitalMute = YES;
    }
    else
    {
        tureOrFalse = @"False";
        _isDigitalMute = NO;
    }
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:tureOrFalse forKey:param_info.name];
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

- (id) generateEventOperation_AnalogyGain
{
    RgsCommandInfo *cmd = [_cmdMap objectForKey:@"SET_ANALOGY_GRAIN"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_FLOAT)
            {
                [param setObject:[NSString stringWithFormat:@"%0.1f",_voiceDb]
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
- (id) generateEventOperation_Mute{
    
    RgsCommandInfo *cmd = nil;
    if(_isMute)
    {
        cmd = [_cmdMap objectForKey:@"SET_MUTE"];
    }
    else
    {
        cmd = [_cmdMap objectForKey:@"SET_UNMUTE"];
    }
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
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
- (id) generateEventOperation_DigitalMute{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_DIGIT_MUTE"];
    NSString* tureOrFalse = @"False";
    if(_isDigitalMute)
    {
        tureOrFalse = @"True";
    }
    else
    {
        tureOrFalse = @"False";
    }
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];

        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            if(param_info.type == RGS_PARAM_TYPE_LIST)
            {
                [param setObject:tureOrFalse forKey:param_info.name];
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
