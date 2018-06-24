//
//  AudioEProcessorAutoMixProxy.m
//  veenoon
//
//  Created by 安志良 on 2018/6/23.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEProcessorAutoMixProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"


@interface AudioEProcessorAutoMixProxy ()
{
    BOOL _isSetOK;
}
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@property (nonatomic, strong) NSArray *_rgsCommands;

@end

@implementation AudioEProcessorAutoMixProxy

//zidonghunyin
@synthesize _zidonghunyinZengYi;
@synthesize _zidonghunyinInputChanels;
@synthesize _zidonghunyinOutputChanels;
@synthesize _cmdMap;
@synthesize _rgsProxyObj;
@synthesize delegate;
@synthesize _rgsCommands;


- (id) init
{
    if(self = [super init])
    {
        _zidonghunyinZengYi = @"2";
        
        _zidonghunyinInputChanels = [NSMutableArray array];
        _zidonghunyinOutputChanels = [NSMutableArray array];
        
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
    
    IMP_BLOCK_SELF(AudioEProcessorAutoMixProxy);
    
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

#pragma mark ---- 自动混音 ----

- (NSDictionary*)getAutoMixCmdSettings{
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_A_VALUE"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"VALUE"])
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

- (void) controlZidongHunyinBtn:(NSString*) proxyName withType:(int)type withState:(BOOL)state {
    if (type == 0) {
        if (state) {
            [_zidonghunyinInputChanels addObject:proxyName];
        } else {
            [_zidonghunyinInputChanels removeObject:proxyName];
        }
    } else {
        if (state) {
            [_zidonghunyinOutputChanels addObject:proxyName];
        } else {
            [_zidonghunyinOutputChanels removeObject:proxyName];
        }
    }
    [self controlAutoMixProxySelected:proxyName withType:type withState:state];
    
}

- (void) controlAutoMixProxySelected:(NSString*) proxyName withType:(int)type withState:(BOOL)state {
    NSString *inputOrOutPut = @"SET_INPUT";
    if (type == 1) {
        inputOrOutPut = @"SET_OUTPUT";
    }
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:inputOrOutPut];
    
    
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

- (NSString*) getZidonghuiyinZengYi {
    return _zidonghunyinZengYi;
}
- (void) controlZiDongHunYinZengYi:(NSString*) zengyiDB {
    self._zidonghunyinZengYi = zengyiDB;
    
    [self controlAutoMixZengyi];
}

- (void) controlAutoMixZengyi {
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_A_VALUE"];
    
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            double zidonghunyinZengyi = [_zidonghunyinZengYi doubleValue];
            
            for(RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"VALUE"])
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

- (NSMutableArray*) getZidonghunyinInputChanels {
    return _zidonghunyinInputChanels;
}
- (void) controlZidonghunyinInputChanels:(NSMutableArray*)zidonghunyinInputChanels {
    self._zidonghunyinInputChanels = zidonghunyinInputChanels;
}
- (NSMutableArray*) getZidonghunyinOutputChanels {
    return _zidonghunyinOutputChanels;
}
- (void) controlZidonghunyinOutputChanels:(NSMutableArray*)zidonghunyinOutputChanels {
    self._zidonghunyinOutputChanels = _zidonghunyinOutputChanels;
}

@end
