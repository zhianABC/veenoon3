//
//  VTVSetProxy.m
//  veenoon
//
//  Created by chen jack on 2018/7/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "VTVSetProxy.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@interface VTVSetProxy ()
{
    
    
    BOOL _isSetOK;
}
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;
@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;

@end

@implementation VTVSetProxy
@synthesize _rgsCommands;
@synthesize _rgsProxyObj;
@synthesize _cmdMap;
@synthesize _RgsSceneDeviceOperationShadow;


- (id) init
{
    if(self = [super init])
    {
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSDictionary *)getScenarioSliceLocatedShadow{
    
    return _RgsSceneDeviceOperationShadow;
}
- (void) recoverWithDictionary:(NSDictionary*)data{
    
    NSInteger proxy_id = [[data objectForKey:@"proxy_id"] intValue];
    if(!_rgsProxyObj || (_rgsProxyObj && (proxy_id == _rgsProxyObj.m_id)))
    {
       
        //Load data
        ////......
        ////
        if([data objectForKey:@"RgsSceneDeviceOperation"]){
            NSDictionary *dic = [data objectForKey:@"RgsSceneDeviceOperation"];
            self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionaryWithDictionary:dic];
            _isSetOK = YES;
        }
    }
    
}

- (void) checkRgsProxyCommandLoad{
    
    if(_rgsProxyObj == nil || _rgsCommands)
        return;
    
    self._cmdMap = [NSMutableDictionary dictionary];
    
    IMP_BLOCK_SELF(VTVSetProxy);
    
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


- (void) controlDeviceMenu:(NSString*)menuName{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:menuName];
    
    if(cmd)
    {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        if([cmd.params count])
        {
            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
            [param setObject:menuName forKey:param_info.name];
            
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


- (BOOL) isSetChanged{
    
    return _isSetOK;
}

- (id) generateEventOperation_Postion{
    
    //    RgsCommandInfo *cmd = nil;
    //
    //    if(_cmdMap)
    //        cmd = [_cmdMap objectForKey:@"LOAD"];
    //
    //    if(cmd)
    //    {
    //        NSMutableDictionary * param = [NSMutableDictionary dictionary];
    //        if([cmd.params count])
    //        {
    //            RgsCommandParamInfo * param_info = [cmd.params objectAtIndex:0];
    //
    //
    //        }
    //        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc]init];
    //        scene_opt.dev_id = _rgsProxyObj.m_id;
    //        scene_opt.cmd = cmd.name;
    //        scene_opt.param = param;
    //
    //        //用于保存还原
    //        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
    //        [slice setObject:[NSNumber numberWithInteger:_rgsProxyObj.m_id] forKey:@"dev_id"];
    //        [slice setObject:cmd.name forKey:@"cmd"];
    //        [slice setObject:param forKey:@"param"];
    //        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"LOAD"];
    //
    //
    //        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
    //                                                                          cmd:scene_opt.cmd
    //                                                                        param:scene_opt.param];
    //
    //        return opt;
    //    }
    //    else
    //    {
    //        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"LOAD"];
    //        if(cmdsRev)
    //        {
    //            RgsSceneOperation * opt = [[RgsSceneOperation alloc]
    //                                       initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
    //                                       cmd:[cmdsRev objectForKey:@"cmd"]
    //                                       param:[cmdsRev objectForKey:@"param"]];
    //
    //            return opt;
    //        }
    //    }
    return nil;
}


@end
