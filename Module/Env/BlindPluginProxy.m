//
//  BlindPluginProxy.m
//  veenoon
//
//  Created by 安志良 on 2018/8/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "BlindPluginProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@interface BlindPluginProxy ()
{
    
    BOOL _isSetOK;
    
}
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@property (nonatomic, strong) NSMutableDictionary *_optMaps;

@property (nonatomic, strong) NSMutableDictionary *_pointsData;

@end

@implementation BlindPluginProxy {
    
}

@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;
@synthesize delegate;
@synthesize _deviceId;
@synthesize _channelNumber;

@synthesize _optMaps;
@synthesize _rgsOpts;

- (NSDictionary*)getChRecords{
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_CH"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"CH"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"min"];
                }
            }
        }
    }
    
    return result;
}

- (int) getChannelNumber {
    int result = 0;
    int max=0;
    int min=0;
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_CH"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"CH"])
                {
                    if(param_info.max)
                        max = [param_info.max intValue];
                    if(param_info.min)
                        min = [param_info.min intValue];
                }
            }
        }
    }
    result = max - min +1;
    return result;
}
- (void) controlStatue:(int)state withCh:(int)ch {
    
    if(_optMaps == nil)
    {
        self._optMaps = [NSMutableDictionary dictionary];
    }
    
    
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_CH"];
    
    NSString *status = @"";
    if (state == 1) {
        status = @"FWD";
    } else if (state == 2) {
        status = @"STOP";
    } else if (state == 3) {
        status = @"REV";
    }
    
    if(state != 2)//停止的命令就不要了
        [self._optMaps setObject:status forKey:[NSNumber numberWithInt:ch]];
    
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
                
                if([param_info.name isEqualToString:@"STATUS"])
                {
                    [param setObject:status
                              forKey:param_info.name];
                }
            }
        }
        
        [[RegulusSDK sharedRegulusSDK] ControlDevice:_deviceId
                                                 cmd:cmd.name
                                               param:param completion:nil];
    }
}

////生成场景片段
- (NSArray*) generateEventOperation_ChState{
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_CH"];

    self._rgsOpts = [NSMutableArray array];
    
    if(cmd)
    {
        NSMutableArray *event_opts = [NSMutableArray array];
        for(id chkey in [_optMaps allKeys])
        {
            
            int iCh = [chkey intValue];
            NSString* status = [_optMaps objectForKey:chkey];
            
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
                    else if([param_info.name isEqualToString:@"STATUS"])
                    {
                        [param setObject:status
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

- (void) checkRgsProxyCommandLoad:(NSArray*)cmds{
    
    if(_rgsCommands){
        
        if(delegate && [delegate respondsToSelector:@selector(didLoadedProxyCommand)])
        {
            [delegate didLoadedProxyCommand];
        }
        
        return;
    }
    
    if(cmds && [cmds count])
    {
        self._cmdMap = [NSMutableDictionary dictionary];
        
        self._rgsCommands = cmds;
        for(RgsCommandInfo *cmd in cmds)
        {
            [self._cmdMap setObject:cmd forKey:cmd.name];
        }
        
        _isSetOK = YES;
        
        if(delegate && [delegate respondsToSelector:@selector(didLoadedProxyCommand)])
        {
            [delegate didLoadedProxyCommand];
        }
        
    }
}

- (void) recoverWithDictionary:(NSArray*)datas{
    
    self._rgsOpts = [NSMutableArray array];
    self._optMaps = [NSMutableDictionary dictionary];
    
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        _isSetOK = YES;
        
        NSString *cmd = dopt.cmd;
        NSDictionary *param = dopt.param;
        
        if([cmd isEqualToString:@"SET_CH"])
        {
            NSString *status = [param objectForKey:@"STATUS"];
            int ch = [[param objectForKey:@"CH"] intValue];
            
            [self._optMaps setObject:status
                                  forKey:[NSNumber numberWithInt:ch]];
            
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [_rgsOpts addObject:opt];
        }
        
    }
    
}

@end
