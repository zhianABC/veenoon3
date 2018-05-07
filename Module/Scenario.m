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

#import "VCameraSettingSet.h"
#import "VCameraProxys.h"

#import "VTouyingjiSet.h"
#import "VProjectProxys.h"

#import "DataBase.h"

@interface Scenario ()
{
    
}
@property (nonatomic, strong) RgsDriverObj *_rgsDriver;
@property (nonatomic, strong) RgsSceneObj *_rgsScene;
@property (nonatomic, strong) RgsEventObj *_rgsSceneEvent;

@property (nonatomic, strong) NSMutableDictionary *_scenarioData;

@end

@implementation Scenario
@synthesize room_id;
@synthesize _rgsSceneObj;

@synthesize _rgsSceneEvent;
@synthesize _rgsScene;
@synthesize _rgsDriver;

@synthesize _A8PowerPlugs;
@synthesize _A16PowerPlugs;
@synthesize _VDVDPlayers;
@synthesize _AWirelessMikePlugs;
@synthesize _AHand2HandPlugs;
@synthesize _AProcessorPlugs;


@synthesize _VCameraSettings;
@synthesize _VRemoteSettings;
@synthesize _VVideoProcess;
@synthesize _VPinJie;
@synthesize _VTV;
@synthesize _VLuBoJi;
@synthesize _VTouyingji;

@synthesize _APlayerPlugs;

@synthesize _areas;

@synthesize _eventOperations;

@synthesize _scenarioData;

- (id)init
{
    if(self = [super init])
    {
        
        self.room_id = 1;
        [self initData];
       
    }
    
    return self;
}

- (void) initData{
    
    self._eventOperations = [NSMutableArray array];
    self._scenarioData = [NSMutableDictionary dictionary];
    
    NSMutableArray *audio = [NSMutableArray array];
    [_scenarioData setObject:audio forKey:@"audio"];
    
    NSMutableArray *video = [NSMutableArray array];
    [_scenarioData setObject:video forKey:@"video"];
    
    NSMutableArray *env = [NSMutableArray array];
    [_scenarioData setObject:env forKey:@"environment"];
    
    [_scenarioData setObject:@"场景" forKey:@"name"];
    
    [_scenarioData setObject:[NSNumber numberWithInt:room_id]
                      forKey:@"room_id"];
    
}

- (NSMutableDictionary *)senarioData{
    
    return _scenarioData;
}

- (void) fillWithData:(NSMutableDictionary*)data{
    
    self._scenarioData = data;
    
    self._rgsDriver = [[RgsDriverObj alloc] init];
    _rgsDriver.m_id = [[data objectForKey:@"s_driver_id"] intValue];
    
    
    self._AProcessorPlugs = [NSMutableArray array];
    self._VCameraSettings = [NSMutableArray array];
    self._VTouyingji = [NSMutableArray array];
    
    NSArray *audios = [data objectForKey:@"audio"];
    for(NSDictionary *a in audios){
        
        NSString *classname = [a objectForKey:@"class"];
        Class someClass = NSClassFromString(classname);
        BasePlugElement * obj = [[someClass alloc] init];
        [obj jsonToObject:a];
        
        if([obj isKindOfClass:[AudioEProcessor class]])
        {
            [_AProcessorPlugs addObject:obj];
        }
    }
    NSArray *videos = [data objectForKey:@"video"];
    for(NSDictionary *v in videos){
        
        NSString *classname = [v objectForKey:@"class"];
        Class someClass = NSClassFromString(classname);
        BasePlugElement * obj = [[someClass alloc] init];
        [obj jsonToObject:v];
        
        if([obj isKindOfClass:[VCameraSettingSet class]])
        {
            [_VCameraSettings addObject:obj];
        }
        else if([obj isKindOfClass:[VTouyingjiSet class]])
        {
            [_VTouyingji addObject:obj];
        }
    }
    NSArray *envs = [data objectForKey:@"environment"];
    for(NSDictionary *env in envs){
        
        NSString *classname = [env objectForKey:@"class"];
        Class someClass = NSClassFromString(classname);
        BasePlugElement * obj = [[someClass alloc] init];
        [obj jsonToObject:env];
    }
    
    
    [self recoverDriverEvent];

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

     IMP_BLOCK_SELF(Scenario);
    
    [[RegulusSDK sharedRegulusSDK] ReloadProject:^(BOOL result, NSError *error) {
        if(result)
        {
            NSLog(@"reload project.");
            
            [KVNProgress showSuccess];
            [block_self postCreateScenarioNotifyResult:YES];
        }
        else{
            NSLog(@"%@",[error description]);
            
            [KVNProgress showErrorWithStatus:[error description]];
            [block_self postCreateScenarioNotifyResult:NO];
        }
    }];
}


- (void) prepareSenarioSlice{
    
    [self initData];
    
    //音频处理
    if([self._AProcessorPlugs count])
    {
        [self createAudioProcessScenario];
    }
    //摄像机
    if([self._VCameraSettings count])
    {
        [self createVideoCameraScenario];
    }
    //投影机
    if([self._VTouyingji count])
    {
        [self createVideoProjectScenario];
    }
    
    
}

#pragma mark -----Create 场景 ---

- (void) createAudioProcessScenario{
    
    NSMutableArray *audios = [_scenarioData objectForKey:@"audio"];
   

    for(AudioEProcessor *ap in self._AProcessorPlugs)
    {
    
        NSArray *audioIn = ap._inAudioProxys;
        //NSArray *audioOut = ap._outAudioProxys;
        
        for(VAProcessorProxys *vap in audioIn)
        {
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
            }
        }
       
        NSDictionary *data = [ap objectToJson];
        [audios addObject:data];
        
    }
}

- (void) createVideoCameraScenario{
    
    NSMutableArray *videos = [_scenarioData objectForKey:@"video"];
    
    for(VCameraSettingSet *vcam in self._VCameraSettings)
    {
        
        VCameraProxys *cam = vcam._proxyObj;
        if([cam isSetChanged])
        {
            RgsSceneOperation *rsp = [cam generateEventOperation_Postion];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
        }
        
        NSDictionary *data = [vcam objectToJson];
        [videos addObject:data];
    }
}

- (void) createVideoProjectScenario{
    
    NSMutableArray *videos = [_scenarioData objectForKey:@"video"];
    
    for(VTouyingjiSet *vprj in self._VTouyingji)
    {
        
        VProjectProxys *proj = vprj._proxyObj;
        if([proj isSetChanged])
        {
            RgsSceneOperation *rsp = [proj generateEventOperation_Input];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
            rsp = [proj generateEventOperation_Power];
            if(rsp)
            {
                [self addEventOperation:rsp];
            }
        }
        
        NSDictionary *data = [vprj objectToJson];
        [videos addObject:data];
    }
}



@end
