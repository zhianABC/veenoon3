//
//  BlindPluginProxy.m
//  veenoon
//
//  Created by 安志良 on 2018/8/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AirQualityPlugProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@interface AirQualityPlugProxy ()
{
    
    BOOL _isSetOK;
    
}
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;

@property (nonatomic, strong) NSMutableDictionary *_pointsData;

@end

@implementation AirQualityPlugProxy {
    
}
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;
@synthesize delegate;
@synthesize _deviceId;
@synthesize _channelNumber;

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
    
    _isSetOK = YES;
}

@end

