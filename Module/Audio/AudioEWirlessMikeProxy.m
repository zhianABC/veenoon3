//
//  AudioEWirlessMikeProxy.m
//  veenoon
//
//  Created by chen jack on 2018/11/13.
//  Copyright © 2018 jack. All rights reserved.
//

#import "AudioEWirlessMikeProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "DriverCmdSync.h"

@interface AudioEWirlessMikeProxy ()
{
    BOOL _isSetOK;
}
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;

@end

@implementation AudioEWirlessMikeProxy

@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;
@synthesize _RgsSceneDeviceOperationShadow;

@synthesize _freqVal;//频率
@synthesize _freqops;

@synthesize _groups;//组-通道
@synthesize _groupVal;

@synthesize _dbs;//增益
@synthesize _dbVal;

@synthesize _sq;
@synthesize _sqVal;


- (id) init
{
    if(self = [super init])
    {
        
      
    }
    
    return self;
}

- (BOOL) haveProxyCommandLoaded{
    
    if(_rgsCommands)
        return YES;
    
    return NO;
    
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
        
        IMP_BLOCK_SELF(AudioEWirlessMikeProxy);
        
        [[RegulusSDK sharedRegulusSDK] GetProxyCommands:_rgsProxyObj.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
            if (result)
            {
                [block_self saveProxyCmds:commands];
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

- (void) saveProxyCmds:(NSArray*)commands{
    
    if ([commands count]) {
        self._rgsCommands = commands;
        for(RgsCommandInfo *cmd in commands)
        {
            [self._cmdMap setObject:cmd forKey:cmd.name];
        }
        
        _isSetOK = YES;
        
        [[DriverCmdSync sharedCMDSync] setValue:commands
                                         forKey:@"AudioEWirlessMikeProxy"];
    }
}

- (BOOL) isSetChanged{
    
    return _isSetOK;
}


- (void) recoverWithDictionary:(NSArray*)datas{
    
    [_RgsSceneDeviceOperationShadow removeAllObjects];
    
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        _isSetOK = YES;
        
        /*
        NSString *cmd = dopt.cmd;
        NSDictionary *param = dopt.param;
        
        
        if([cmd isEqualToString:@"SET_MODE"])
        {
            self._workMode = [param objectForKey:@"MODE"];
        }
        else if([cmd isEqualToString:@"SET_PRIORITY"])
        {
            self._fayanPriority = [[param objectForKey:@"COUNT"] intValue];
        }
        else if([cmd isEqualToString:@"SET_MIC_OPEN_MAX"])
        {
            self._numberOfDaiBiao = [[param objectForKey:@"COUNT"] intValue];
        }
        else if([cmd isEqualToString:@"SET_VOL"])
        {
            self._deviceVol = [[param objectForKey:@"VOL"] floatValue];
        }
        else if([cmd isEqualToString:@"SET_CAM_POL"])
        {
            self._currentCameraPol = [param objectForKey:@"POL"];
        }
        else if([cmd isEqualToString:@"SET_PEQ"]){
            
            NSString *rate = [param objectForKey:@"RATE"];
            NSString *gain = [param objectForKey:@"GAIN"];
            
            [self._pointsData setObject:gain forKey:rate];
            
            
            NSMutableArray *peqs = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_PEQ"];
            if(peqs == nil)
            {
                peqs = [NSMutableArray array];
                [_RgsSceneDeviceOperationShadow setObject:peqs forKey:@"SET_PEQ"];
            }
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [peqs addObject:opt];
            
        }
        else if([cmd isEqualToString:@"SET_PRESS"]){
            
            self._mixPress = [param objectForKey:@"LEVEL"];
            
        }
        else if([cmd isEqualToString:@"SET_NOISE_GATE"])
        {
            self._mixNoise = [param objectForKey:@"LEVEL"];
        }
        else if([cmd isEqualToString:@"SET_HIGH_FILTER"])
        {
            self._mixHighFilter = [param objectForKey:@"RATE"];
        }
        else if([cmd isEqualToString:@"SET_LOW_FILTER"])
        {
            self._mixLowFilter = [param objectForKey:@"RATE"];
        }
        
        
        if(![cmd isEqualToString:@"SET_PEQ"])
        {
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [_RgsSceneDeviceOperationShadow setObject:opt forKey:cmd];
        }
         */
    }
    
}

@end
