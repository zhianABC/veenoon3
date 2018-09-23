//
//  AudioEProcessor.m
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEProcessor.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"
#import "VAProcessorProxys.h"


@interface AudioEProcessor ()
{
    BOOL _isSetOK;
}
//以后实现
@property (nonatomic, strong) NSMutableArray *_inchannels;
@property (nonatomic, strong) NSMutableArray *_outchannels;
@property (nonatomic, strong) NSArray *_rgsCommands;
@property (nonatomic, strong) NSMutableDictionary *_cmdMap;

@property (nonatomic, strong) NSMutableDictionary *_RgsSceneDeviceOperationShadow;

@end

@implementation AudioEProcessor
@synthesize _isHuiShengXiaoChu;
//中控上对应的数据
@synthesize _inAudioProxys;
@synthesize _outAudioProxys;
@synthesize delegate;
@synthesize _rgsCommands;
@synthesize _cmdMap;
@synthesize _autoMixProxy;
@synthesize _singalProxy;

//配置数据，保存从中控数据结构转换来的数据
//以后实现
@synthesize _inchannels;
@synthesize _outchannels;

@synthesize _RgsSceneDeviceOperationShadow;


- (id) init
{
    if(self = [super init])
    {
        _isHuiShengXiaoChu = NO;
        
        self._ipaddress = @"192.168.1.100";
        
        self._inchannels = [NSMutableArray array];
        self._outchannels = [NSMutableArray array];
        
        self._show_icon_name = @"a_icon_7.png";
        self._show_icon_sel_name = @"a_icon_7_sel.png";
        
        self._typeName = audio_process_name;
        
        _isSetOK = NO;
        
        self._RgsSceneDeviceOperationShadow = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void) checkRgsProxyCommandLoad{
    
    if(_rgsCommands){
        
        if(delegate && [delegate respondsToSelector:@selector(didLoadedProxyCommand)])
        {
            [delegate didLoadedProxyCommand];
        }
        
        return;
    }
    
    self._cmdMap = [NSMutableDictionary dictionary];
    
    IMP_BLOCK_SELF(AudioEProcessor);
    
    [KVNProgress show];
    
    [[RegulusSDK sharedRegulusSDK] GetDriverCommands:((RgsDriverObj*)_driver).m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
        
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
                                  [error description], (int)((RgsDriverObj*)_driver).m_id];
            
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

- (void) controlHuiShengXiaoChu:(BOOL)isHuiShengXiaoChu {
    _isHuiShengXiaoChu = isHuiShengXiaoChu;
    
    [self sendEchoCancle];
}
- (BOOL) isHuiShengXiaoChuStarted {
    return _isHuiShengXiaoChu;
}

-(void) sendEchoCancle {
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"ECHO_CANCLE"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_isHuiShengXiaoChu)
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
                if([param_info.name isEqualToString:@"ENABLE"])
                {
                    [param setObject:tureOrFalse
                              forKey:param_info.name];
                }
            }
            
            if([param count])
            {
                [[RegulusSDK sharedRegulusSDK] ControlDevice:((RgsDriverObj*) _driver).m_id
                                                         cmd:cmd.name
                                                       param:param completion:nil];
            }
            
        }
    }
}

- (NSString*) deviceName{
    
    if(self._name)
        return self._name;
    
    return audio_process_name;
}

- (void) initInputChannels:(int)num{
    
    
}
- (int) inputChannelsCount{
    
    return (int)[_inchannels count];
}
- (NSMutableDictionary *)inputChannelAtIndex:(int)index{

    if(index < [_inchannels count])
        return [_inchannels objectAtIndex:index];
    
    return nil;
}

- (void) initOutChannels:(int)num{
    
  
}
- (int) outChannelsCount{
    
    return (int)[_outchannels count];
}
- (NSMutableDictionary *)outChannelAtIndex:(int)index{
    
    if(index < [_outchannels count])
        return [_outchannels objectAtIndex:index];
    
    return nil;
}


- (void) saveProject{
    
    [KVNProgress showSuccess];
    
//    [KVNProgress show];
//
//    [[RegulusSDK sharedRegulusSDK] ReloadProject:^(BOOL result, NSError *error) {
//        if(result)
//        {
//            NSLog(@"reload project.");
//
//            [KVNProgress showSuccess];
//        }
//        else{
//            NSLog(@"%@",[error description]);
//
//            [KVNProgress showSuccess];
//        }
//    }];
}

- (void) createDriver{
    
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;
    if(area && _driverInfo && !_driver)
    {
        RgsDriverInfo *info = _driverInfo;
        
        IMP_BLOCK_SELF(AudioEProcessor);
        
        [KVNProgress show];
        [[RegulusSDK sharedRegulusSDK] CreateDriver:area.m_id
                                             serial:info.serial
                                         completion:^(BOOL result, RgsDriverObj *driver, NSError *error) {
            if (result) {
                
                block_self._driver = driver;
                block_self._name = driver.name;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyRefreshTableWithCom" object:nil];
            }
            [KVNProgress showSuccess];
        }];
    }
}

- (void) removeDriver{
    
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [[RegulusSDK sharedRegulusSDK] DeleteDriver:dr.m_id
                                         completion:^(BOOL result, NSError *error) {
                                             
                                         }];
    }
}

- (void) prepareAllAudioInCmds
{
    
    if([_inAudioProxys count])
    {
        NSMutableArray *proxyids = [NSMutableArray array];
        //只读取一个，因为所有的Channel的commands相同
        VAProcessorProxys *vap = [_inAudioProxys objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInt:(int)vap._rgsProxyObj.m_id]];
    
        IMP_BLOCK_SELF(AudioEProcessor);
        
        [[RegulusSDK sharedRegulusSDK] GetProxyCommandDict:proxyids
                                                completion:^(BOOL result, NSDictionary *commd_dict, NSError *error) {
                                                    
                                                    [block_self loadAudioInCommands:commd_dict];
                                                    
                                                }];
    }
    
}

- (void) loadAudioInCommands:(NSDictionary*)commd_dict{
    
    NSMutableArray *audio_channels = _inAudioProxys;
    
    if([[commd_dict allValues] count])
    {
        NSArray *cmds = [[commd_dict allValues] objectAtIndex:0];
        
        for(VAProcessorProxys *vap in audio_channels)
        {
            [vap prepareLoadCommand:cmds];
        }
    }

}

- (void) prepareAllAudioOutCmds{
    
    if([_outAudioProxys count])
    {
        NSMutableArray *proxyids = [NSMutableArray array];
        //只读取一个，因为所有的Channel的commands相同
        VAProcessorProxys *vap = [_outAudioProxys objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInt:vap._rgsProxyObj.m_id]];
        
        IMP_BLOCK_SELF(AudioEProcessor);
        
        [[RegulusSDK sharedRegulusSDK] GetProxyCommandDict:proxyids
                                                completion:^(BOOL result, NSDictionary *commd_dict, NSError *error) {
                                                    
                                                    [block_self loadAudioOutCommands:commd_dict];
                                                    
                                                }];
    }
}

- (void) loadAudioOutCommands:(NSDictionary*)commd_dict{
    
    NSMutableArray *audio_channels = _outAudioProxys;
    
    if([[commd_dict allValues] count])
    {
        NSArray *cmds = [[commd_dict allValues] objectAtIndex:0];
        
        for(VAProcessorProxys *vap in audio_channels)
        {
            [vap prepareLoadCommand:cmds];
        }
    }
    
}

//回声消除
- (id) generateEventOperation_echo{
    
    RgsCommandInfo *cmd = nil;
    cmd = [_cmdMap objectForKey:@"ECHO_CANCLE"];
    if(cmd)
    {
        NSString* tureOrFalse = @"False";
        if(_isHuiShengXiaoChu)
        {
            tureOrFalse = @"True";
        }
        else
        {
            tureOrFalse = @"False";
        }
        
        
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        
        for( RgsCommandParamInfo * param_info in cmd.params)
        {
            if([param_info.name isEqualToString:@"ENABLE"])
            {
                [param setObject:tureOrFalse
                          forKey:param_info.name];
            }
        }
        
        int proxyid = (int)((RgsDriverObj*) _driver).m_id;
        
        RgsSceneDeviceOperation * scene_opt = [[RgsSceneDeviceOperation alloc] init];
        scene_opt.dev_id = proxyid;
        scene_opt.cmd = cmd.name;
        scene_opt.param = param;
        
        //用于保存还原
        NSMutableDictionary *slice = [NSMutableDictionary dictionary];
        [slice setObject:[NSNumber numberWithInteger:proxyid] forKey:@"dev_id"];
        [slice setObject:cmd.name forKey:@"cmd"];
        [slice setObject:param forKey:@"param"];
        [_RgsSceneDeviceOperationShadow setObject:slice forKey:@"ECHO_CANCLE"];
        
        RgsSceneOperation * opt = [[RgsSceneOperation alloc] initCmdWithParam:scene_opt.dev_id
                                                                          cmd:scene_opt.cmd
                                                                        param:scene_opt.param];
        
        return opt;
    }
    else
    {
        NSDictionary *cmdsRev = [_RgsSceneDeviceOperationShadow objectForKey:@"ECHO_CANCLE"];
        if(cmdsRev)
        {
            RgsSceneOperation * opt = [[RgsSceneOperation alloc]
                                       initCmdWithParam:[[cmdsRev objectForKey:@"dev_id"] integerValue]
                                       cmd:[cmdsRev objectForKey:@"cmd"]
                                       param:[cmdsRev objectForKey:@"param"]];
            
            return opt;
        }
    }
    
    return nil;
}

- (NSDictionary *)objectToJson{
    
    NSMutableDictionary *allData = [NSMutableDictionary dictionary];
    
    [allData setValue:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
    
    
    
    return allData;
}

- (void) jsonToObject:(NSDictionary*)json{
   
}

- (NSDictionary *)userData{
    
    self.config = [NSMutableDictionary dictionary];
    [self.config setValue:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [self.config setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"driver_id"];
        [self.config setObject:[NSNumber numberWithBool:self._isSelected] forKey:@"s"];
    }
    
    if(_inAudioProxys)
    {
        NSMutableDictionary *proxysMapRef = [NSMutableDictionary dictionary];
        
        for(VAProcessorProxys *vap in _inAudioProxys)
        {
            RgsProxyObj *proxy = vap._rgsProxyObj;
            if(vap._icon_name && vap._voiceInDevice)
            {
                NSMutableDictionary *proxyDic = [NSMutableDictionary dictionary];
                [proxyDic setObject:vap._icon_name
                             forKey:@"icon_name"];
                
                [proxyDic setObject:vap._voiceInDevice
                             forKey:@"voiceInDevice"];
                //增益
                [proxysMapRef setObject:proxyDic
                             forKey:[NSString stringWithFormat:@"%d",(int)proxy.m_id]];
            }
        }
        
        if([proxysMapRef count])
            [self.config setObject:proxysMapRef forKey:@"in_audio_proxys"];
    }
    
    return self.config;
}



- (void) createByUserData:(NSDictionary*)userdata withMap:(NSDictionary*)valMap{
    
    self.config = [NSMutableDictionary dictionaryWithDictionary:userdata];
    [self.config setObject:valMap forKey:@"opt_value_map"];
    
    int driver_id = [[self.config objectForKey:@"driver_id"] intValue];
    self._isSelected = [[self.config objectForKey:@"s"] boolValue];
    
    IMP_BLOCK_SELF(AudioEProcessor);
    [[RegulusSDK sharedRegulusSDK] GetRgsObjectByID:driver_id
                                         completion:^(BOOL result, id RgsObject, NSError *error) {
                                             
                                             if(result)
                                             {
                                                 [block_self successGotDriver:RgsObject];
                                             }
                                         }];
}

- (void) successGotDriver:(RgsDriverObj*)rgsd{
    
    self._driver = rgsd;
    self._driverInfo = rgsd.info;
 
    self._name = rgsd.name;
    
    IMP_BLOCK_SELF(AudioEProcessor);
    [[RegulusSDK sharedRegulusSDK] GetDriverProxys:rgsd.m_id
                                        completion:^(BOOL result, NSArray *proxys, NSError *error) {
        if (result) {
            if ([proxys count]) {
                [block_self prepareInOutChannels:proxys];
            }
        }
        
    }];
}

- (void) prepareInOutChannels:(NSArray*)proxys{
    
    self._inAudioProxys = [NSMutableArray array];
    self._outAudioProxys = [NSMutableArray array];
    
    NSDictionary *mapRef = [self.config objectForKey:@"in_audio_proxys"];
    
    NSDictionary *map = [self.config objectForKey:@"opt_value_map"];

    for(RgsProxyObj *proxy in proxys)
    {
        
        id key = [NSString stringWithFormat:@"%d", (int)proxy.m_id];
        
        if([proxy.type isEqualToString:@"Audio In"])
        {
            VAProcessorProxys *vap = [[VAProcessorProxys alloc] init];
            vap._rgsProxyObj = proxy;
            
            NSDictionary *ref = [mapRef objectForKey:key];
            if(ref)
            {
                vap._icon_name = [ref objectForKey:@"icon_name"];
                vap._voiceInDevice = [ref objectForKey:@"voiceInDevice"];
            }
            
            NSArray *vals = [map objectForKey:key];
            [vap recoverWithDictionary:vals];
            
            [_inAudioProxys addObject:vap];
    
        }
        else if([proxy.type isEqualToString:@"Audio Out"])
        {
            VAProcessorProxys *vap = [[VAProcessorProxys alloc] init];
            vap._rgsProxyObj = proxy;
            
            NSArray *vals = [map objectForKey:key];
            [vap recoverWithDictionary:vals];
            
            [_outAudioProxys addObject:vap];
        }
        else if ([proxy.type isEqualToString:@"Audio Signal"])
        {
            AudioEProcessorSignalProxy *vap = [[AudioEProcessorSignalProxy alloc] init];
            vap._rgsProxyObj = proxy;
            
            NSArray *vals = [map objectForKey:key];
            [vap recoverWithDictionary:vals];

            self._singalProxy = vap;
        }
        else if ([proxy.type isEqualToString:@"Audio AutoMix"]) {
            
            AudioEProcessorAutoMixProxy *vap = [[AudioEProcessorAutoMixProxy alloc] init];
            vap._rgsProxyObj = proxy;
            
            NSArray *vals = [map objectForKey:key];
            [vap recoverWithDictionary:vals];
            
            self._autoMixProxy = vap;
        }
    }
    
    _isSetOK = YES;
}

@end
