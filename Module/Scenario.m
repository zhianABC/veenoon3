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

#import "AirConditionPlug.h"
#import "AirConditionProxy.h"

#import "DataBase.h"
#import "DataCenter.h"

#import "WebClient.h"
#import "MeetingRoom.h"

#import "UserDefaultsKV.h"

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

@synthesize delegate;

- (id)init
{
    if(self = [super init])
    {
        
        self.regulus_id = nil;
        
        MeetingRoom *room = [DataCenter defaultDataCenter]._currentRoom;
        if(room)
        {
            self.regulus_id = room.regulus_id;
        }
        
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

- (void) prepareDataForUploadCloud:(NSDictionary*)data{
    
   
    self._scenarioData = [NSMutableDictionary dictionaryWithDictionary:data];
    
    self._rgsDriver = [[RgsDriverObj alloc] init];
    _rgsDriver.m_id = [[data objectForKey:@"s_driver_id"] intValue];

}

- (void) fillWithData:(NSMutableDictionary*)data{
    
    self._scenarioData = [NSMutableDictionary dictionaryWithDictionary:data];
    
    self._rgsDriver = [[RgsDriverObj alloc] init];
    _rgsDriver.m_id = [[data objectForKey:@"s_driver_id"] intValue];
    
    int s_event_id = [[data objectForKey:@"s_event_id"] intValue];
    
    self._rgsSceneEvent = [[RgsEventObj alloc] init];
    _rgsSceneEvent.m_id = s_event_id;
    _rgsSceneEvent.parent_id = _rgsDriver.m_id;
    
    
    IMP_BLOCK_SELF(Scenario);
    
    [KVNProgress show];
    [[RegulusSDK sharedRegulusSDK] GetDriverEvents:_rgsDriver.m_id
                                        completion:^(BOOL result, NSArray *events, NSError *error) {
                                            if (result) {
                                                if ([events count]) {
                                                    
                                                    block_self._rgsSceneEvent = [events objectAtIndex:0];
                                                    
                                                }
                                                
                                                [KVNProgress dismiss];
                                            }
                                            else
                                            {
                                                [KVNProgress showErrorWithStatus:[error description]];
                                                [block_self postCreateScenarioNotifyResult:NO];
                                            }
                                        }];

}

- (void) loadDriverValues{
    
    
    [self getScenceEventOperations];
}

- (void) getScenceEventOperations{
    
    if(_rgsSceneEvent == nil)
        return;
    
    IMP_BLOCK_SELF(Scenario);
    [KVNProgress show];
    [[RegulusSDK sharedRegulusSDK] GetEventOperations:_rgsSceneEvent
                                           completion:^(BOOL result, NSArray *operatins, NSError *error) {
                                               
                                               [block_self initDrivers:operatins];
                                               
                                           }];
}

- (void) initDrivers:(NSArray*)operatins{
    
    [KVNProgress dismiss];
    
    if([operatins count])
    {
        NSMutableDictionary *map = [NSMutableDictionary dictionary];
        for(RgsSceneOperation *opt in operatins)
        {
            RgsSceneDeviceOperation *dopt = [opt getOperation];
            if([dopt isKindOfClass:[RgsSceneDeviceOperation class]])
            {
                id key = [NSString stringWithFormat:@"%d", (int)dopt.dev_id];
                NSMutableArray *arr = [map objectForKey:key];
                if(arr == nil)
                {
                    arr = [NSMutableArray array];
                    [map setObject:arr forKey:key];
                }
                
                [arr addObject:dopt];
                
            }
        }
        
        NSArray *audios = [_scenarioData objectForKey:@"audio"];
        [_audioDevices removeAllObjects];
        for(NSDictionary *a in audios){
            
            NSString *classname = [a objectForKey:@"class"];
            Class someClass = NSClassFromString(classname);
            BasePlugElement * obj = [[someClass alloc] init];
            [obj createByUserData:a withMap:map];
            
            [_audioDevices addObject:obj];
        }
        NSArray *videos = [_scenarioData objectForKey:@"video"];
        [_videoDevices removeAllObjects];
        for(NSDictionary *v in videos){
            
            NSString *classname = [v objectForKey:@"class"];
            Class someClass = NSClassFromString(classname);
            BasePlugElement * obj = [[someClass alloc] init];
            [obj createByUserData:v withMap:map];
            
            [_videoDevices addObject:obj];
        }
        NSArray *envs = [_scenarioData objectForKey:@"environment"];
        [_envDevices removeAllObjects];
        for(NSDictionary *env in envs){
            
            NSString *classname = [env objectForKey:@"class"];
            Class someClass = NSClassFromString(classname);
            BasePlugElement * obj = [[someClass alloc] init];
            [obj createByUserData:env withMap:map];
            
            [_envDevices addObject:obj];
        }
        
        
        //[self recoverDriverEvent];
    }
    
    if(delegate && [delegate respondsToSelector:@selector(didEndLoadingDiverValues)])
    {
        [delegate didEndLoadingDiverValues];
    }
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
    
    _client._method = @"/addscenario";
    _client._httpMethod = @"POST";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    _client._requestParam = param;
    
    User *u = [UserDefaultsKV getUser];
    if(u)
    {
        [param setObject:u._userId forKey:@"userID"];
    }
    
    [param setObject:regulus_id
              forKey:@"regulusID"];
    [param setObject:[NSString stringWithFormat:@"%d", (int)_rgsDriver.m_id]
              forKey:@"driverID"];
    
    NSString *name = [_scenarioData objectForKey:@"name"];
    NSString *en_name = [_scenarioData objectForKey:@"en_name"];
    
    if(name)
        [param setObject:name forKey:@"scenarioCName"];
    if(en_name)
        [param setObject:en_name forKey:@"scenarioEName"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_scenarioData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error: &error];
    
    NSString *jsonresult = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    if(jsonresult == nil)
        jsonresult  = @"";
    
    [param setObject:jsonresult forKey:@"scenarioContent"];
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
    } FailBlock:^(id lParam, id rParam) {
    
    }];
}

- (NSString *)name{
    
    NSString *name = [_scenarioData objectForKey:@"name"];
    
    return name;
}
- (void) updateProperty{
    
    if(regulus_id == nil)
    {
        return;
    }
    
    if(_client == nil)
    {
        _client = [[WebClient alloc] initWithDelegate:self];
    }
    
    _client._method = @"/updatescenarionameicon";
    _client._httpMethod = @"POST";
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    _client._requestParam = param;
    
    [param setObject:regulus_id
              forKey:@"regulusID"];
    [param setObject:[NSString stringWithFormat:@"%d", (int)_rgsDriver.m_id]
              forKey:@"driverID"];
    
    NSString *name = [_scenarioData objectForKey:@"name"];
    NSString *en_name = [_scenarioData objectForKey:@"en_name"];
    
    if(name)
        [param setObject:name forKey:@"scenarioCName"];
    if(en_name)
        [param setObject:en_name forKey:@"scenarioEName"];
    
    NSString *smallIcon = [_scenarioData objectForKey:@"small_icon"];
    NSString *userIcon = [_scenarioData objectForKey:@"icon_user"];
    
    if(smallIcon)
        [param setObject:smallIcon forKey:@"scenarioPic"];
    if(userIcon)
        [param setObject:userIcon forKey:@"userPic"];
    
    [_client requestWithSusessBlock:^(id lParam, id rParam) {
        
    } FailBlock:^(id lParam, id rParam) {
        
    }];
}

- (void) recoverDriverEvent{
    
    IMP_BLOCK_SELF(Scenario);
    if(_rgsDriver.m_id)
    {
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
}

- (void) addEventOperation:(RgsSceneOperation*)rgsSceneOp{
    
    [_eventOperations addObject:rgsSceneOp];
    
    
}

- (void) uploadToRegulusCenter{
    
    if(regulus_id == nil || _rgsDriver == nil)
    {
        return;
    }
    
  
    [KVNProgress show];
    
    NSMutableDictionary *udata = [NSMutableDictionary dictionary];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_scenarioData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error: &error];
    
    NSString *jsonresult = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    if(jsonresult)
    {
        jsonresult = [jsonresult stringByReplacingOccurrencesOfString:@" "
                                                           withString:@""];
        jsonresult = [jsonresult stringByReplacingOccurrencesOfString:@"\n"
                                                           withString:@""];
    }
    
    if(jsonresult == nil)
        jsonresult  = @"";
    
    [udata setObject:jsonresult forKey:@"content"];
    
    [[RegulusSDK sharedRegulusSDK] SetUserData:_rgsDriver.m_id
                                          data:udata
                                    completion:^(BOOL result, NSError *error) {
                                        
                                        if (result) {
                                            
                                            [KVNProgress showSuccess];
                                        }
                                        else
                                        {
                                            [KVNProgress showErrorWithStatus:[error description]];
                                            
                                        }
                                        
                                    }];
    
    
  
}

- (void) syncDataFromRegulus{

    if(_rgsDriver == nil)
    {
        self._rgsDriver = [[RgsDriverObj alloc] init];
        
        if(_rgsSceneObj)
        {
            _rgsDriver.m_id = _rgsSceneObj.m_id;
        }

    }
    
    if(_rgsDriver == nil)
        return;
    
    IMP_BLOCK_SELF(Scenario);
    
    [KVNProgress show];
    
    [[RegulusSDK sharedRegulusSDK] GetUserData:_rgsDriver.m_id
                                    completion:^(BOOL result, NSDictionary *data, NSError *error) {
                                        
                                        [KVNProgress dismiss];
                                        
                                        if(result)
                                        {
                                            [block_self recoverFromUserData:data];
                                        }
                                    }];
}

- (void) recoverFromUserData:(NSDictionary*)data{
    
    NSString *scenario_content = [data objectForKey:@"content"];
    NSData *bdata = [scenario_content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:bdata
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
    if([dic isKindOfClass:[NSDictionary class]])
        [self fillWithData:dic];
}

- (void) postCreateScenarioNotifyResult:(BOOL)success{
    
    if(success)
    {
        [_scenarioData setObject:regulus_id forKey:@"regulus_id"];
        
        //保存数据库
        [[DataBase sharedDatabaseInstance] saveScenario:_scenarioData];
        [self performSelectorOnMainThread:@selector(uploadToRegulusCenter)
                               withObject:nil
                            waitUntilDone:NO];
        
#ifdef REALTIME_NETWORK_MODEL
        [self uploadToServer];
#endif
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
    
    for(BasePlugElement* ap in _audioDevices)
    {
        if(!ap._isSelected)
            continue;
        
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
            
            id rsp = [(AudioEProcessor*)ap generateEventOperation_echo];
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
            
            NSDictionary *data = [ap userData];
            [audios addObject:data];
        }
        else if ([ap isKindOfClass:[APowerESet class]])
        {
            NSArray *proxys = ((APowerESet*)ap)._proxys;
            
            //全开/全关
            RgsSceneOperation* rsp = [(APowerESet*)ap generateEventOperation_power];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
            else
            {
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
            }
            NSDictionary *data = [ap userData];
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
            
            NSDictionary *data = [ap userData];
            [audios addObject:data];
        }
    }
    
    
    if([audios count] == 0)
        [_scenarioData removeObjectForKey:@"audio"];
}

- (void) createVideoScenario{
    
    
    NSMutableArray *videos = [_scenarioData objectForKey:@"video"];
    
    for(BasePlugElement* dev in self._videoDevices)
    {
        if(!dev._isSelected)
            continue;
        
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
            
            NSDictionary *data = [dev userData];
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
            
            NSDictionary *data = [dev userData];
            [videos addObject:data];
        }
        else if([dev isKindOfClass:[VTVSet class]])
        {
            NSDictionary *data = [dev userData];
            [videos addObject:data];
        }
        else if([dev isKindOfClass:[VDVDPlayerSet class]])
        {
            NSDictionary *data = [dev userData];
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
            
            NSDictionary *data = [dev userData];
            [videos addObject:data];
        }
    }
    
    
    if([videos count] == 0)
        [_scenarioData removeObjectForKey:@"video"];
}

- (void) createEvnScenario{
    
    
    NSMutableArray *evns = [_scenarioData objectForKey:@"environment"];
    
    for(BasePlugElement* dev in self._envDevices)
    {
        if(!dev._isSelected)
            continue;
        
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
            
            NSDictionary *data = [dev userData];
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
            
            NSDictionary *data = [dev userData];
            [evns addObject:data];
        }
        else if([dev isKindOfClass:[AirConditionPlug class]])
        {
//            AirConditionProxy *proj = ((AirConditionPlug*)dev)._proxyObj;
//            if([proj isSetChanged])
//            {
//                NSArray *rsps = [proj ];
//                if(rsps && [rsps count])
//                {
//                    for(id rsp in rsps)
//                    {
//                        [self addEventOperation:rsp];
//                    }
//                }
//            }
            
            NSDictionary *data = [dev userData];
            [evns addObject:data];
        }
    }
    
    if([evns count] == 0)
        [_scenarioData removeObjectForKey:@"environment"];
}


@end
