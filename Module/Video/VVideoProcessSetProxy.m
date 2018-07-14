//
//  VVideoProcessSetProxy.m
//  veenoon
//
//  Created by 安志良 on 2018/6/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "VVideoProcessSetProxy.h"
#import "KVNProgress.h"
#import "RegulusSDK.h"

@interface VVideoProcessSetProxy ()
{
    
    BOOL _isSetOK;
    
}

@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;


@end

@implementation VVideoProcessSetProxy
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;
@synthesize delegate;
@synthesize _deviceMatcherDic;

- (id) init
{
    if(self = [super init])
    {
        
        _deviceMatcherDic = [NSMutableDictionary dictionary];
        
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
    
    IMP_BLOCK_SELF(VVideoProcessSetProxy);
    
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

- (NSDictionary*)getVideoProcessInputSettings {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_P2P"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"INPUT"])
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

- (NSDictionary*)getVideoProcessOutputSettings {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_P2P"];
    if(cmd)
    {
        if([cmd.params count])
        {
            
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"OUTPUT"])
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

- (void) recoverWithDictionary:(NSDictionary*)data{
    
    NSInteger proxy_id = [[data objectForKey:@"proxy_id"] intValue];
    if(!_rgsProxyObj || (_rgsProxyObj && (proxy_id == _rgsProxyObj.m_id)))
    {
        
    }
    
}

- (void) controlDeviceAdd:(NSString*)inputName withOutDevice:(NSString*)outputName {
    NSMutableArray *outPutArray = [_deviceMatcherDic objectForKey:inputName];
    if (outPutArray) {
        if (![outPutArray containsObject:outputName]) {
            [outPutArray addObject:outputName];
        }
    } else {
        outPutArray = [NSMutableArray array];
        [_deviceMatcherDic setObject:outPutArray forKey:inputName];
        
        [outPutArray addObject:outputName];
    }
    
    [self sendAddDviceToCenter:inputName withOutDevice:outputName];
}

- (void) sendAddDviceToCenter:(NSString*)inputName withOutDevice:(NSString*)outputName {
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"SET_P2P"];
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            for( RgsCommandParamInfo * param_info in cmd.params)
            {
                if([param_info.name isEqualToString:@"INPUT"])
                {
                    [param setObject:inputName forKey:param_info.name];
                } else if ([param_info.name isEqualToString:@"OUTPUT"])
                {
                    [param setObject:outputName forKey:param_info.name];
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

@end
