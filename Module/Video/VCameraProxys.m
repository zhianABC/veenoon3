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
- (void) stopControlDeviceDirection{
    
    [self controlDeviceDirection:@"STOP"];
}

@end
