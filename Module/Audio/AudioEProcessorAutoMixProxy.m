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
@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;

@end

@implementation AudioEProcessorAutoMixProxy

//zidonghunyin
@synthesize _zidonghunyinZengYi;
@synthesize _inputMap;
@synthesize _outputMap;
@synthesize _cmdMap;
@synthesize _rgsProxyObj;
@synthesize delegate;
@synthesize _rgsCommands;
@synthesize _RgsSceneDeviceOperationShadow;


- (id) init
{
    if(self = [super init])
    {
        self._zidonghunyinZengYi = @"2";
        
        self._inputMap = [NSMutableDictionary dictionary];
        self._outputMap = [NSMutableDictionary dictionary];
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void) getCurrentDataState
{
    if(_rgsProxyObj)
    {
               IMP_BLOCK_SELF(AudioEProcessorAutoMixProxy);
                [[RegulusSDK sharedRegulusSDK] GetProxyCurState:_rgsProxyObj.m_id completion:^(BOOL result, NSDictionary *state, NSError *error) {
                    if (result) {
                        if ([state count])
                        {
                            [block_self parseStateInitsValues:state];
                        }
                    }
                }];
        
//        [[RegulusSDK sharedRegulusSDK] QueryProxyStateInCallBack:_rgsProxyObj.m_id completion:nil];
//
    }
}

- (void) parseStateInitsValues:(NSDictionary*)state{

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

- (void) controlZidongHunyinBtn:(NSString*) proxyName
                       withType:(int)type
                      withState:(BOOL)state
                           exec:(BOOL)exec {
    if (type == 0) {
        if (state) {
            [_inputMap setObject:@1 forKey:proxyName];
        } else {
            [_inputMap setObject:@0 forKey:proxyName];
        }
    } else {
        if (state) {
            [_outputMap setObject:@1 forKey:proxyName];
        } else {
             [_outputMap setObject:@0 forKey:proxyName];
        }
    }
    
    //是否执行命令
    if(exec){
        [self controlAutoMixProxySelected:proxyName
                                 withType:type
                                withState:state];
    }
    
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
                                               param:param completion:nil];
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
                                               param:param completion:nil];
    }
    
}


- (id) generateEventOperation_inOuts:(NSString*)proxyName state:(int)state andType:(int)type{
    
    NSString *cmdName = @"SET_INPUT";
    if (type == 1) {
        cmdName = @"SET_OUTPUT";
    }
    
    RgsCommandInfo *cmd = nil;
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:cmdName];
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
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
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

- (NSArray*) generateEventOperation_inputs{
    
    NSMutableArray *results = [NSMutableArray array];
    
    NSString *cmdName = @"SET_INPUT";
    RgsCommandInfo *cmd = nil;
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:cmdName];
    if(cmd)
    {
        for(NSString* proxyName in [_inputMap allKeys])
        {
            int state = [[_inputMap objectForKey:proxyName] intValue];
            
            id opt = [self generateEventOperation_inOuts:proxyName
                                                   state:state
                                                 andType:0];
            
            if(opt)
            {
                [results addObject:opt];
            }
        }
    }
    else
    {
        NSArray *arrs = [_RgsSceneDeviceOperationShadow objectForKey:cmdName];
        if(arrs)
            [results addObjectsFromArray:arrs];
    }
    return results;
    
}
- (NSArray*) generateEventOperation_outpus{
    
    NSMutableArray *results = [NSMutableArray array];
    
    NSString *cmdName = @"SET_OUTPUT";
    RgsCommandInfo *cmd = nil;
    if(_cmdMap)
    cmd = [_cmdMap objectForKey:cmdName];
    if(cmd)
    {
        for(NSString* proxyName in [_outputMap allKeys])
        {
            int state = [[_outputMap objectForKey:proxyName] intValue];
            
            id opt = [self generateEventOperation_inOuts:proxyName
                                                   state:state
                                                 andType:1];
            
            if(opt)
            {
                [results addObject:opt];
            }
        }
    
    }
    else
    {
        NSArray *arrs = [_RgsSceneDeviceOperationShadow objectForKey:cmdName];
        if(arrs)
        [results addObjectsFromArray:arrs];
    }
    
    return results;
}
- (id) generateEventOperation_gain{
    
    RgsCommandInfo *cmd = nil;
    
    if(_cmdMap)
        cmd = [_cmdMap objectForKey:@"SET_A_VALUE"];

    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        float zidonghunyinZengyi = [_zidonghunyinZengYi floatValue];
        
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
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
        scene_opt.dev_id = _rgsProxyObj.m_id;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        

        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        return [_RgsSceneDeviceOperationShadow objectForKey:@"SET_A_VALUE"];

    }
    
    return nil;
}

- (void) recoverWithDictionary:(NSArray*)datas
{
    
    
    for(RgsSceneDeviceOperation *dopt in datas)
    {
        _isSetOK = YES;
        
        NSString *cmd = dopt.cmd;
        NSDictionary *param = dopt.param;
        
         if([cmd isEqualToString:@"SET_INPUT"]){
            
    
            NSString *src = [param objectForKey:@"INPUT"];
            NSString *enable = [param objectForKey:@"ENABLE"];

             if ([enable isEqualToString:@"True"]) {
                 [_inputMap setObject:@1 forKey:src];
             } else {
                 [_inputMap setObject:@0 forKey:src];
             }
             
             NSMutableArray *arrs = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_INPUT"];
             if(arrs == nil)
             {
                 arrs = [NSMutableArray array];
                 [_RgsSceneDeviceOperationShadow setObject:arrs forKey:@"SET_INPUT"];
             }
             
             RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                               cmd:dopt.cmd
                                                                             param:dopt.param];
             [arrs addObject:opt];
            
        }
        else if([cmd isEqualToString:@"SET_OUTPUT"])
        {
            NSString *src = [param objectForKey:@"OUTPUT"];
            NSString *enable = [param objectForKey:@"ENABLE"];
            
            if ([enable isEqualToString:@"True"]) {
                [_outputMap setObject:@1 forKey:src];
            } else {
                [_outputMap setObject:@0 forKey:src];
            }
            
            
            NSMutableArray *arrs = [_RgsSceneDeviceOperationShadow objectForKey:@"SET_OUTPUT"];
            if(arrs == nil)
            {
                arrs = [NSMutableArray array];
                [_RgsSceneDeviceOperationShadow setObject:arrs forKey:@"SET_OUTPUT"];
            }
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [arrs addObject:opt];
            
        }
        else if([cmd isEqualToString:@"SET_A_VALUE"])
        {
            NSString *src = [param objectForKey:@"VALUE"];
            self._zidonghunyinZengYi = src;
            
            RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:dopt.dev_id
                                                                              cmd:dopt.cmd
                                                                            param:dopt.param];
            [_RgsSceneDeviceOperationShadow setObject:opt forKey:cmd];
        }
        
    }
    
    //NSLog(@"===");
}


@end
