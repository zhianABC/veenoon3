//
//  AudioEProcessorAutoMixProxy.m
//  veenoon
//
//  Created by 安志良 on 2018/6/23.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEProcessorSignalProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"


@interface AudioEProcessorSignalProxy ()
{
    BOOL _isSetOK;
}
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@property (nonatomic, strong) NSArray *_rgsCommands;

@end

@implementation AudioEProcessorSignalProxy

//zidonghunyin
@synthesize _xinhaofashengZengYi;
@synthesize _xinhaofashengOutputChanels;
@synthesize _cmdMap;
@synthesize _rgsProxyObj;
@synthesize delegate;
@synthesize _rgsCommands;
@synthesize _xinhaofashengPinlv;
@synthesize _isXinhaofashengMute;
@synthesize _xinhaofashengZhengxuan;


- (id) init
{
    if(self = [super init])
    {
        _xinhaofashengZengYi = @"10";
        _xinhaofashengPinlv = @"200";
        _xinhaofashengZhengxuan = @"Pink";
        _isXinhaofashengMute = NO;
        
        _xinhaofashengOutputChanels = [NSMutableArray array];
    }
    return self;
}

- (void) checkRgsProxyCommandLoad{
    
    if(_rgsProxyObj == nil || _rgsCommands){
        
        if(delegate && [delegate respondsToSelector:@selector(didLoadedProxyCommand)])
        {
            [delegate didLoadedProxyCommand];
        }
        
        return;
    }
    
    self._cmdMap = [NSMutableDictionary dictionary];
    
    IMP_BLOCK_SELF(AudioEProcessorSignalProxy);
    
    [KVNProgress show];
    
    [[RegulusSDK sharedRegulusSDK] GetProxyCommands:_rgsProxyObj.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
        
        [KVNProgress dismiss];
        
        if (result)
        {
            if ([commands count]) {
                
                block_self._rgsCommands = commands;
                for(RgsCommandInfo *cmd in commands)
                {
                    [block_self._cmdMap setObject:cmd forKey:cmd.name];
                }
                
                _isSetOK = YES;
                
                
                [block_self initDatasAfterPullData];
                [block_self callDelegateDidLoad];
            }
        }
        else
        {
            NSString *errorMsg = [NSString stringWithFormat:@"%@ - proxyid:%d",
                                  [error description], (int)_rgsProxyObj.m_id];
            
            [KVNProgress showErrorWithStatus:errorMsg];
            
            [block_self callDelegateDidLoad];
            
            [KVNProgress dismiss];
        }
        
    }];
}

- (void) callDelegateDidLoad{
    
    if(delegate && [delegate respondsToSelector:@selector(didLoadedProxyCommand)])
    {
        [delegate didLoadedProxyCommand];
    }
}

- (void) initDatasAfterPullData{
    
}

- (NSArray*)getSignalType{
    
    NSMutableArray *result = [NSMutableArray array];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SIG_TYPE"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"TYPE"])
                {
                    [result addObjectsFromArray:param_info.available];
                    break;
                }
                
            }
        }
    }
    
    return result;
}

#pragma mark ---- 自动混音 ----

- (NSDictionary*)getSignalRateSettings {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SIG_SINE_RATE"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"RATE"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"min"];
                    break;
                }
                
            }
        }
    }
    
    return result;
}

#pragma mark ---- 自动混音 ----

- (NSDictionary*)getSignalGainSettings {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SIG_GAIN"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"GAIN"])
                {
                    if(param_info.max)
                        [result setObject:param_info.max forKey:@"max"];
                    if(param_info.min)
                        [result setObject:param_info.min forKey:@"min"];
                    break;
                }
                
            }
        }
    }
    
    return result;
}

- (NSString*) getXinhaofashengZengYi {
    return self._xinhaofashengZengYi;
}
- (void) controlXinhaofashengZengYi:(NSString*) zengyiDB {
    self._xinhaofashengZengYi = zengyiDB;
    
    [self controlXinhaoZengyi];
}

- (void) controlXinhaoZengyi {
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_SIG_GAIN"];
    
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            double zidonghunyinZengyi = [_xinhaofashengZengYi doubleValue];
            
            for(RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"GAIN"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          zidonghunyinZengyi]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          zidonghunyinZengyi]
                                  forKey:param_info.name];
                        
                    }
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

- (NSMutableArray*) getXinhaofashengOutputChanels {
    return self._xinhaofashengOutputChanels;
}
- (void) controlXinhaofashengOutputChanels:(NSMutableArray*)zidonghunyinOutputChanels {
    self._xinhaofashengOutputChanels = zidonghunyinOutputChanels;
}
- (NSString*) getXinhaofashengPinlv {
    return self._xinhaofashengPinlv;
}
- (void) controlXinhaofashengPinlv:(NSString*) pinlv {
    self._xinhaofashengPinlv = pinlv;
    
    [self controlXinhaoPinlv];
}

- (void) controlXinhaoPinlv {
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_SIG_SINE_RATE"];
    
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            double zidonghunyinZengyi = [_xinhaofashengPinlv doubleValue];
            
            for(RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"RATE"])
                {
                    if(param_info.type == RGS_PARAM_TYPE_FLOAT)
                    {
                        
                        [param setObject:[NSString stringWithFormat:@"%0.1f",
                                          zidonghunyinZengyi]
                                  forKey:param_info.name];
                    }
                    else if(param_info.type == RGS_PARAM_TYPE_INT)
                    {
                        [param setObject:[NSString stringWithFormat:@"%0.0f",
                                          zidonghunyinZengyi]
                                  forKey:param_info.name];
                        
                    }
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
- (NSString*) getXinhaofashengZhengXuan {
    return self._xinhaofashengZhengxuan;
}
- (void) controlXinhaofashengZhengxuan:(NSString*) zhengxuan {
    self._xinhaofashengZhengxuan = zhengxuan;
    
    [self controlXinhaoZhengxuan];
}

- (void) controlXinhaoZhengxuan {
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SIG_TYPE"];
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"TYPE"])
                {
                    [param setObject:_xinhaofashengZhengxuan
                              forKey:param_info.name];
                }
            }
            
            if([param count])
            {
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
}


- (BOOL) isXinhaofashengMute {
    return self._isXinhaofashengMute;
}
- (void) controlXinhaofashengMute:(BOOL)isMute {
    self._isXinhaofashengMute = isMute;
    
    [self controlXinhaoMute];
}

-(void) controlXinhaoMute {
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_SIG_MUTE"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_isXinhaofashengMute)
        {
            tureOrFalse = @"True";
        }
        else
        {
            tureOrFalse = @"False";
        }
        
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"MUTE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                }
            }
        }
        
        if([param count])
        {
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
- (void) controlSignalWithOutState:(NSString*) proxyName withState:(BOOL)state {
    
    if (state) {
        [_xinhaofashengOutputChanels addObject:proxyName];
    } else {
        [_xinhaofashengOutputChanels removeObject:proxyName];
    }
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_SIG_OUT"];
    
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            
            NSString *name = [proxyName stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            [param setObject:name forKey:param_info.name];
            
            if(state)
            {
                [param setObject:@"True" forKey:@"ENABLE"];
            }
            else
            {
                [param setObject:@"False" forKey:@"ENABLE"];
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

@end

