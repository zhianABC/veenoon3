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
@property (nonatomic, strong) NSMutableArray *_rgOpts;
@property (nonatomic, strong) NSMutableDictionary* _channelsMap;

@end


@implementation EDimmerLightProxys
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;

@synthesize _deviceId;
@synthesize _rgOpts;

@synthesize _channelsMap;

@synthesize _level;

- (id) init
{
    if(self = [super init])
    {
        self._level = 0;
        
        self._channelsMap = [NSMutableDictionary dictionary];
        
        self._rgOpts = [NSMutableArray array];
        
       
    }
    
    return self;
}

- (BOOL) isSetChanged{
    
    return _isSetOK;
}

- (NSDictionary *)getChLevelRecords{
    
    return _channelsMap;
}



- (void) recoverWithDictionary:(NSArray*)datas
{
    self._rgOpts = [NSMutableArray array];
    
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        _isSetOK = YES;
        
        NSString *cmd = dopt.cmd;
        NSDictionary *param = dopt.param;
        
        if([cmd isEqualToString:@"SET_CH_LEVEL"])
        {
            int lv = [[param objectForKey:@"LEVEL"] intValue];
            int ch = [[param objectForKey:@"CH"] intValue];
            
            [self._channelsMap setObject:[NSNumber numberWithInt:lv]
                                  forKey:[NSString stringWithFormat:@"%d", ch]];
            
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [_rgOpts addObject:opt];
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

- (int)getNumberOfLights{
    
    int max = 0;
    RgsCommandInfo *cmd = [self._cmdMap objectForKey:@"SET_CH_LEVEL"];
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

- (void) controlDeviceLightLevel:(int)levelValue ch:(int)ch exec:(BOOL)exec{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_CH_LEVEL"];
    self._level = levelValue;
    
    [self._channelsMap setObject:[NSNumber numberWithInt:_level]
                          forKey:[NSString stringWithFormat:@"%d", ch]];
    
    if(cmd && exec)
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
                else if([param_info.name isEqualToString:@"LEVEL"])
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
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_CH_LEVEL"];
    
    if(cmd)
    {
        NSMutableArray *event_opts = [NSMutableArray array];

        for(id chkey in [_channelsMap allKeys])
        {
            
            int iCh = [chkey intValue];
            int iLevel = [[_channelsMap objectForKey:chkey] intValue];
            
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
                    else if([param_info.name isEqualToString:@"LEVEL"])
                    {
                        [param setObject:[NSString stringWithFormat:@"%d", iLevel]
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
            
            [_rgOpts addObject:opt];
        }
        
        
        
        return event_opts;
    }
    else
    {
        return _rgOpts;
    }
    
    return nil;
}

@end
