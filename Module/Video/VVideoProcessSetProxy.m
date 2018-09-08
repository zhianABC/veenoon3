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
@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;


@end

@implementation VVideoProcessSetProxy
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _deviceId;
@synthesize _cmdMap;
@synthesize delegate;
@synthesize _deviceMatcherDic;
@synthesize _RgsSceneDeviceOperationShadow;

@synthesize _inputDevices;
@synthesize _outputDevices;

- (id) init
{
    if(self = [super init])
    {
        
        self._deviceMatcherDic = [NSMutableDictionary dictionary];
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
        
        self._outputDevices =  [NSMutableDictionary dictionary];
        self._inputDevices =  [NSMutableDictionary dictionary];
    }
    
    return self;
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
        
        
        if(delegate && [delegate respondsToSelector:@selector(didLoadedProxyCommand)])
        {
            [delegate didLoadedProxyCommand];
        }
    }
    else
    {
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

- (void) recoverWithDictionary:(NSArray*)datas{
    
    self._deviceMatcherDic = [NSMutableDictionary dictionary];
    
    [_RgsSceneDeviceOperationShadow removeAllObjects];
    NSMutableArray *opts = [NSMutableArray array];
    [_RgsSceneDeviceOperationShadow setObject:opts forKey:@"SET_P2P"];
    
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        _isSetOK = YES;
        
        NSString *cmd = dopt.cmd;
        NSDictionary *param = dopt.param;
        
        if([cmd isEqualToString:@"SET_P2P"])
        {
            NSString *inName = [param objectForKey:@"INPUT"];
            NSString *outName = [param objectForKey:@"OUTPUT"];
            
            NSMutableArray *outPutArray = [self._deviceMatcherDic objectForKey:inName];
            if (outPutArray) {
                if (![outPutArray containsObject:outName]) {
                    [outPutArray addObject:outName];
                }
            } else {
                outPutArray = [NSMutableArray array];
                [self._deviceMatcherDic setObject:outPutArray forKey:inName];
                
                [outPutArray addObject:outName];
            }
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            
            [opts addObject:opt];
        }
    }
}

- (void) saveInputDevice:(NSDictionary*)inputDev{
    
    NSString *inName = [inputDev objectForKey:@"ctrl_val"];
    [self._inputDevices setObject:inputDev forKey:inName];

}
- (void) saveOutputDevice:(NSDictionary*)outputDev{
    
    NSString *outName = [outputDev objectForKey:@"ctrl_val"];
    [self._outputDevices setObject:outputDev forKey:outName];
    
}

- (void) controlDeviceAdd:(NSDictionary*)inputDev
            withOutDevice:(NSDictionary*)outputDev {
    
    
    NSString *inName = [inputDev objectForKey:@"ctrl_val"];
    NSString *outName = [outputDev objectForKey:@"ctrl_val"];
    
    [self._inputDevices setObject:inputDev forKey:inName];
    [self._outputDevices setObject:outputDev forKey:outName];
    
    NSMutableArray *outPutArray = [self._deviceMatcherDic objectForKey:inName];
    if (outPutArray) {
        if (![outPutArray containsObject:outName]) {
            [outPutArray addObject:outName];
        }
    } else {
        outPutArray = [NSMutableArray array];
        [self._deviceMatcherDic setObject:outPutArray forKey:inName];
        
        [outPutArray addObject:outName];
    }
    
    [self sendAddDviceToCenter:inName
                 withOutDevice:outName
                        method:@"SET_P2P"];
}

- (void) controlDeviceRemove:(NSDictionary*)inputDev
               withOutDevice:(NSDictionary*)outputDev{
    
    NSString *inName = [inputDev objectForKey:@"ctrl_val"];
    NSString *outName = [outputDev objectForKey:@"ctrl_val"];
    
    [self._outputDevices removeObjectForKey:outName];
    
    NSMutableArray *outPutArray = [self._deviceMatcherDic objectForKey:inName];
    if (outPutArray) {
        [outPutArray removeObject:outName];
    }
    
    [self sendAddDviceToCenter:inName
                 withOutDevice:outName
                        method:@"SET_INVERT"];
}

- (void) sendAddDviceToCenter:(NSString*)inputName
                withOutDevice:(NSString*)outputName
                       method:(NSString*)method{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:method];
    
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
        
        NSInteger objid = _deviceId;
        if(_rgsProxyObj)
        {
            objid = _rgsProxyObj.m_id;
        }
        
        [[RegulusSDK sharedRegulusSDK] ControlDevice:objid
                                                 cmd:cmd.name
                                               param:param completion:nil];
    }
}

//生成场景片段
- (NSArray* ) generateEventOperation_p2p{
    
    NSMutableArray *results = [NSMutableArray array];
    for(NSString* inSrc in [self._deviceMatcherDic allKeys])
    {
        NSArray *outSrcs = [self._deviceMatcherDic objectForKey:inSrc];
        
        for(NSString *outSrc in outSrcs)
        {
            id opt = [self generateEventOperation:outSrc inSrc:inSrc];
            
            if(opt)
            {
                [results addObject:opt];
            }
        }
    }
    
    if([results count] == 0)
    {
       results = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_P2P"];
    }
    
    return results;
}

- (id) generateEventOperation:(NSString*)outSrc inSrc:(NSString*)inSrc{
    
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
                    [param setObject:inSrc forKey:param_info.name];
                } else if ([param_info.name isEqualToString:@"OUTPUT"])
                {
                    [param setObject:outSrc forKey:param_info.name];
                }
            }
        }
        
        NSInteger proxyid = _deviceId;
        if(_rgsProxyObj)
        {
            proxyid = _rgsProxyObj.m_id;
        }
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
        scene_opt.dev_id = proxyid;
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
