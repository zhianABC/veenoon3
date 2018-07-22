//
//  Scenario.m
//  veenoon
//
//  Created by chen jack on 2018/3/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "Scenario.h"
#import "APowerESet.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "DataSync.h"

#import "AudioEProcessor.h"
#import "VAProcessorProxys.h"
#import "AudioEProcessorSignalProxy.h"
#import "AudioEProcessorAutoMixProxy.h"

#import "VCameraSettingSet.h"
#import "VCameraProxys.h"

#import "VTouyingjiSet.h"
#import "VProjectProxys.h"

#import "EDimmerLight.h"
#import "EDimmerLightProxys.h"

#import "EDimmerSwitchLight.h"
#import "EDimmerSwitchLightProxy.h"

#import "VVideoProcessSet.h"
#import "VVideoProcessSetProxy.h"

#import "APowerESet.h"
#import "APowerESetProxy.h"

#import "AudioEMix.h"
#import "AudioEMixProxy.h"

#import "VTVSet.h"
#import "VTVSetProxy.h"

#import "VDVDPlayerSet.h"
#import "VDVDPlayerProxy.h"

#import "DataBase.h"

#import "WebClient.h"

@interface Scenario ()
{
    WebClient *_client;
}
@property (nonatomic, strong) RgsDriverObj *_rgsDriver;
@property (nonatomic, strong) RgsSceneObj *_rgsScene;
@property (nonatomic, strong) RgsEventObj *_rgsSceneEvent;

@property (nonatomic, strong) NSMutableDictionary *_scenarioData;

@end

@implementation Scenario
@synthesize regulus_id;
@synthesize _rgsSceneObj;

@synthesize _rgsSceneEvent;
@synthesize _rgsScene;
@synthesize _rgsDriver;

@synthesize _audioDevices;
@synthesize _videoDevices;
@synthesize _envDevices;
@synthesize _comDevices;

@synthesize _areas;

@synthesize _eventOperations;

@synthesize _scenarioData;

- (id)init
{
    if(self = [super init])
    {
        
        self.regulus_id = nil;
        [self initData];
       
    }
    
    return self;
}

- (void) initData{
    
    self._eventOperations = [NSMutableArray array];
    self._scenarioData = [NSMutableDictionary dictionary];
    
    self._audioDevices = [NSMutableArray array];
    self._videoDevices = [NSMutableArray array];
    self._envDevices = [NSMutableArray array];
    
    NSMutableArray *audio = [NSMutableArray array];
    [_scenarioData setObject:audio forKey:@"audio"];
    
    NSMutableArray *video = [NSMutableArray array];
    [_scenarioData setObject:video forKey:@"video"];
    
    NSMutableArray *env = [NSMutableArray array];
    [_scenarioData setObject:env forKey:@"environment"];
    
    [_scenarioData setObject:@"场景" forKey:@"name"];
    
    if(regulus_id)
        [_scenarioData setObject:regulus_id
                          forKey:@"regulus_id"];
    
}

- (NSMutableDictionary *)senarioData{
    
    return _scenarioData;
}

- (void) fillWithData:(NSMutableDictionary*)data{
    
    self._scenarioData = data;
    
    self._rgsDriver = [[RgsDriverObj alloc] init];
    _rgsDriver.m_id = [[data objectForKey:@"s_driver_id"] intValue];
    
    
    NSArray *audios = [data objectForKey:@"audio"];
    for(NSDictionary *a in audios){
        
        NSString *classname = [a objectForKey:@"class"];
        Class someClass = NSClassFromString(classname);
        BasePlugElement * obj = [[someClass alloc] init];
        [obj jsonToObject:a];
        
        [_audioDevices addObject:obj];
    }
    NSArray *videos = [data objectForKey:@"video"];
    for(NSDictionary *v in videos){
        
        NSString *classname = [v objectForKey:@"class"];
        Class someClass = NSClassFromString(classname);
        BasePlugElement * obj = [[someClass alloc] init];
        [obj jsonToObject:v];
        
        [_videoDevices addObject:obj];
    }
    NSArray *envs = [data objectForKey:@"environment"];
    for(NSDictionary *env in envs){
        
        NSString *classname = [env objectForKey:@"class"];
        Class someClass = NSClassFromString(classname);
        BasePlugElement * obj = [[someClass alloc] init];
        [obj jsonToObject:env];
        
        [_envDevices addObject:obj];
    }
    
    
    [self recoverDriverEvent];

}

- (void) uploadToServer{
    
    if(regulus_id == nil)
    {
        return;
    }
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/addroom";
    _client._httpMethod = @"POST";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    _client._requestParam = param;
    
    [param setObject:@"1" forKey:@"userID"];
    [param setObject:regulus_id forKey:@"regulusUserID"];
    [param setObject:regulusid forKey:@"regulusID"];
    [param setObject:@"房间" forKey:@"roomName"];
    [param setObject:@"111111" forKey:@"regulusPassword"];
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
    } FailBlock:^(id lParam, id rParam) {
    
    }];
}

- (void) recoverDriverEvent{
    
    IMP_BLOCK_SELF(Scenario);
    
    [[RegulusSDK sharedRegulusSDK] GetDriverEvents:_rgsDriver.m_id
                                        completion:^(BOOL result, NSArray *events, NSError *error) {
        if (result) {
            if ([events count]) {
                
                block_self._rgsSceneEvent = [events objectAtIndex:0];
            }
        }
        else
        {
            NSLog(@"++++++++++recoverDriverEvent++++++++++Error");
        }
    }];
}

- (void) addEventOperation:(RgsSceneOperation*)rgsSceneOp{
    
    [_eventOperations addObject:rgsSceneOp];
    
    
}

- (void) postCreateScenarioNotifyResult:(BOOL)success{
    
    if(success)
    {
        //保存数据库
        [[DataBase sharedDatabaseInstance] saveScenario:_scenarioData];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notify_Scenario_Create_Result"
                                                        object:@{@"result":[NSNumber numberWithBool:success]}];
    
}

- (void) createEventScenario
{
    RgsDriverInfo *info = [[DataSync sharedDataSync] driverInfoByUUID:UUID_Regulus_Scene];
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;
    IMP_BLOCK_SELF(Scenario);
    
    if(info && area && [_eventOperations count])
    {
        [KVNProgress show];
        
        if(_rgsDriver == nil)
        {
            [[RegulusSDK sharedRegulusSDK] CreateDriver:area.m_id
                                                 serial:info.serial
                                             completion:^(BOOL result, RgsDriverObj *driver, NSError *error) {
                                                 if (result) {
                                                     
                                                     block_self._rgsDriver = driver;
                                                     
                                                     [block_self getDriverEvent];
                                                 }
                                                 else
                                                 {
                                                     [KVNProgress showErrorWithStatus:[error description]];
                                                     [block_self postCreateScenarioNotifyResult:NO];
                                                 }
                                             }];
        }
        else
        {
            [block_self getDriverEvent];
        }
        
    }
    else
    {
        [self postCreateScenarioNotifyResult:NO];
    }
    
}

- (void) saveEventScenario{
    
    
    if(_rgsDriver && [_eventOperations count])
    {
        [KVNProgress show];
        
        [self getDriverEvent];
    }
    else
    {
        [self postCreateScenarioNotifyResult:NO];
    }
    
}


- (void) getDriverEvent{
    
     IMP_BLOCK_SELF(Scenario);
    
    [[RegulusSDK sharedRegulusSDK] GetDriverEvents:_rgsDriver.m_id
                                        completion:^(BOOL result, NSArray *events, NSError *error) {
        if (result) {
            if ([events count]) {
                
                block_self._rgsSceneEvent = [events objectAtIndex:0];
                
                [block_self setEventOptions];
            }
        }
        else
        {
            [KVNProgress showErrorWithStatus:[error description]];
            [block_self postCreateScenarioNotifyResult:NO];
        }
    }];
}

- (void) setEventOptions{
    
    IMP_BLOCK_SELF(Scenario);
    
    [_scenarioData setObject:[NSNumber numberWithInteger:_rgsDriver.m_id]
                      forKey:@"s_driver_id"];
    
    [_scenarioData setObject:[NSNumber numberWithInteger:_rgsSceneEvent.m_id]
                      forKey:@"s_event_id"];
    
    [[RegulusSDK sharedRegulusSDK] SetEventOperatons:_rgsSceneEvent
                                           operation:_eventOperations
                                          completion:^(BOOL result, NSError *error) {
                                              if (result) {
                                                  
                                                 
                                                  [block_self reloadProject];
                                                  
                                              }
                                              else
                                              {
                                                  [KVNProgress showErrorWithStatus:[error description]];
                                                  [block_self postCreateScenarioNotifyResult:NO];
                                              }
                                          }];
}

- (void) reloadProject{

     //IMP_BLOCK_SELF(Scenario);
    
    [KVNProgress showSuccess];
    [self postCreateScenarioNotifyResult:YES];
    
}


- (void) prepareSenarioSlice{
    
    //[self initData];
    
    self._eventOperations = [NSMutableArray array];
    
    if(_scenarioData == nil){
        
        self._scenarioData = [NSMutableDictionary dictionary];
        
        [_scenarioData setObject:@"场景" forKey:@"name"];
        
        if(regulus_id)
            [_scenarioData setObject:regulus_id
                              forKey:@"regulus_id"];

    }
    
    NSMutableArray *audio = [NSMutableArray array];
    [_scenarioData setObject:audio forKey:@"audio"];
    
    NSMutableArray *video = [NSMutableArray array];
    [_scenarioData setObject:video forKey:@"video"];
    
    NSMutableArray *env = [NSMutableArray array];
    [_scenarioData setObject:env forKey:@"environment"];
    
    
    //音频处理
    if([self._audioDevices count])
    {
        [self createAudioScenario];
    }
    //摄像机
    if([self._videoDevices count])
    {
        [self createVideoScenario];
    }
    //环境
    if([self._envDevices count])
    {
        [self createEvnScenario];
    }
    
}

#pragma mark -----Create 场景 ---


- (void)processAudioProcessorProxy:(VAProcessorProxys*)vap{
    
    if([vap isSetChanged])
    {
        RgsSceneOperation *rsp = [vap generateEventOperation_AnalogyGain];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        rsp = [vap generateEventOperation_Mute];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        rsp = [vap generateEventOperation_DigitalGain];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        
        rsp = [vap generateEventOperation_DigitalMute];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        
        rsp = [vap generateEventOperation_Mode];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        
        rsp = [vap generateEventOperation_48v];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        
        rsp = [vap generateEventOperation_MicDb];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        
        rsp = [vap generateEventOperation_Inverted];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        
        rsp = [vap generateEventOperation_hp];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        
        rsp = [vap generateEventOperation_lp];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        
        NSArray *rsps = [vap generateEventOperation_peq];
        for(id sp in rsps)
        {
            [self addEventOperation:sp];
        }
        
        rsp = [vap generateEventOperation_limitPress];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        
        rsps = [vap generateEventOperation_mixSrc];
        for(id sp in rsps)
        {
            [self addEventOperation:sp];
        }
        
        rsps = [vap generateEventOperation_mixValue];
        for(id sp in rsps)
        {
            [self addEventOperation:sp];
        }
        
        rsp = [vap generateEventOperation_noiseGate];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        
        rsp = [vap generateEventOperation_fbLimit];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
        
        rsp = [vap generateEventOperation_delay];
        if(rsp)
        {
            [self addEventOperation:rsp];
        }
    }
}

- (void) createAudioScenario{

    NSMutableArray *audios = [_scenarioData objectForKey:@"audio"];
    
    for(id ap in _audioDevices)
    {
        
        if([ap isKindOfClass:[AudioEProcessor class]])
        {
            NSArray *audioIn = ((AudioEProcessor*)ap)._inAudioProxys;
            NSArray *audioOut = ((AudioEProcessor*)ap)._outAudioProxys;
            
            for(VAProcessorProxys *vap in audioIn)
            {
                [self processAudioProcessorProxy:vap];
            }
            
            for(VAProcessorProxys *vap in audioOut)
            {
                [self processAudioProcessorProxy:vap];
            }
            
            id rsp = [ap generateEventOperation_echo];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
            
            AudioEProcessorSignalProxy *sinalproxy = ((AudioEProcessor*)ap)._singalProxy;
            
            if(sinalproxy)
            {
                NSArray* rsps = [sinalproxy generateEventOperation_sigOut];
                for(id rsp in rsps)
                {
                    [self addEventOperation:rsp];
                }
                
                id rsp = [sinalproxy generateEventOperation_sigType];
                if(rsp)
                {
                    [self addEventOperation:rsp];
                }
                
                rsp = [sinalproxy generateEventOperation_sigMute];
                if(rsp)
                {
                    [self addEventOperation:rsp];
                }
                
                rsp = [sinalproxy generateEventOperation_sigGain];
                if(rsp)
                {
                    [self addEventOperation:rsp];
                }
                
                rsp = [sinalproxy generateEventOperation_sigSineRate];
                if(rsp)
                {
                    [self addEventOperation:rsp];
                }
            }
            
            AudioEProcessorAutoMixProxy *amixproxy = ((AudioEProcessor*)ap)._autoMixProxy;
            if(amixproxy)
            {
                NSArray* rsps = [amixproxy generateEventOperation_inputs];
                for(id rsp in rsps)
                {
                    [self addEventOperation:rsp];
                }
                rsps = [amixproxy generateEventOperation_outpus];
                for(id rsp in rsps)
                {
                    [self addEventOperation:rsp];
                }
                
                id rsp = [amixproxy generateEventOperation_gain];
                if(rsp)
                {
                    [self addEventOperation:rsp];
                }
            }
            
            NSDictionary *data = [ap objectToJson];
            [audios addObject:data];
        }
        else if ([ap isKindOfClass:[APowerESet class]])
        {
            NSArray *proxys = ((APowerESet*)ap)._proxys;
            
            //全开/全关
            RgsSceneOperation* rsp = [ap generateEventOperation_power];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
        
            for(APowerESetProxy *proxy in proxys)
            {
                RgsSceneOperation* rsp = [proxy generateEventOperation_status];
                if(rsp)
                {
                    [self addEventOperation:rsp];
                }
                
                rsp = [proxy generateEventOperation_breakDur];
                if(rsp)
                {
                    [self addEventOperation:rsp];
                }
                
                rsp = [proxy generateEventOperation_linkDur];
                if(rsp)
                {
                    [self addEventOperation:rsp];
                }
            }
            
            NSDictionary *data = [ap objectToJson];
            [audios addObject:data];
        }
        else if ([ap isKindOfClass:[AudioEMix class]])
        {
            AudioEMixProxy *proxy = ((AudioEMix*)ap)._proxyObj;
            
            RgsSceneOperation* rsp = [proxy generateEventOperation_mode];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
            rsp = [proxy generateEventOperation_priority];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
            rsp = [proxy generateEventOperation_vol];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
            rsp = [proxy generateEventOperation_camPol];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
            NSArray *rsps = [proxy generateEventOperation_peq];
            for(id rsp in rsps)
            {
                [self addEventOperation:rsp];
            }
            rsp = [proxy generateEventOperation_press];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
            rsp = [proxy generateEventOperation_noiseGate];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
            rsp = [proxy generateEventOperation_hp];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
            rsp = [proxy generateEventOperation_lp];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
            
            NSDictionary *data = [ap objectToJson];
            [audios addObject:data];
        }
    }
    
}

- (void) createVideoScenario{
    
    
    NSMutableArray *videos = [_scenarioData objectForKey:@"video"];
    
    for(id dev in self._videoDevices)
    {
        if([dev isKindOfClass:[VCameraSettingSet class]])
        {
            VCameraProxys *cam = ((VCameraSettingSet*)dev)._proxyObj;
            if([cam isSetChanged])
            {
                RgsSceneOperation *rsp = [cam generateEventOperation_Postion];
                if(rsp)
                {
                    [self addEventOperation:rsp];
                }
            }
            
            NSDictionary *data = [dev objectToJson];
            [videos addObject:data];
        }
        else if([dev isKindOfClass:[VTouyingjiSet class]])
        {
            VProjectProxys *proj = ((VTouyingjiSet*)dev)._proxyObj;
            if([proj isSetChanged])
            {
                RgsSceneOperation* rsp = [proj generateEventOperation_Power];
                if(rsp)
                {
                    [self addEventOperation:rsp];
                }
                
                rsp = [proj generateEventOperation_Input];
                if(rsp)
                {
                    [self addEventOperation:rsp];
                }
                
            }
            
            NSDictionary *data = [dev objectToJson];
            [videos addObject:data];
        }
        else if([dev isKindOfClass:[VTVSet class]])
        {
            NSDictionary *data = [dev objectToJson];
            [videos addObject:data];
        }
        else if([dev isKindOfClass:[VDVDPlayerSet class]])
        {
            NSDictionary *data = [dev objectToJson];
            [videos addObject:data];
        }
        else if([dev isKindOfClass:[VVideoProcessSet class]])
        {
            VVideoProcessSetProxy *proj = ((VVideoProcessSet*)dev)._proxyObj;
            
            NSArray *rsps = [proj generateEventOperation_p2p];
            for(id rsp in rsps)
            {
                [self addEventOperation:rsp];
            }
            
            NSDictionary *data = [dev objectToJson];
            [videos addObject:data];
        }
    }
    
}

- (void) createEvnScenario{
    
    
    NSMutableArray *evns = [_scenarioData objectForKey:@"environment"];
    
    for(id dev in self._envDevices)
    {
        if([dev isKindOfClass:[EDimmerLight class]])
        {
            EDimmerLightProxys *proj = ((EDimmerLight*)dev)._proxyObj;
            if([proj isSetChanged])
            {
                NSArray *rsps = [proj generateEventOperation_ChLevel];
                if(rsps && [rsps count])
                {
                    for(id rsp in rsps)
                    {
                        [self addEventOperation:rsp];
                    }
                }
            }
            
            NSDictionary *data = [dev objectToJson];
            [evns addObject:data];
        }
        else if([dev isKindOfClass:[EDimmerSwitchLight class]])
        {
            EDimmerSwitchLightProxy *proj = ((EDimmerSwitchLight*)dev)._proxyObj;
            if([proj isSetChanged])
            {
                NSArray *rsps = [proj generateEventOperation_ChPower];
                if(rsps && [rsps count])
                {
                    for(id rsp in rsps)
                    {
                        [self addEventOperation:rsp];
                    }
                }
            }
            
            NSDictionary *data = [dev objectToJson];
            [evns addObject:data];
        }
    }
    
}


@end
