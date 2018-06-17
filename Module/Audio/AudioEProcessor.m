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
    
}
//以后实现
@property (nonatomic, strong) NSMutableArray *_inchannels;
@property (nonatomic, strong) NSMutableArray *_outchannels;


@end

@implementation AudioEProcessor

//中控上对应的数据
@synthesize _inAudioProxys;
@synthesize _outAudioProxys;

//配置数据，保存从中控数据结构转换来的数据
//以后实现
@synthesize _inchannels;
@synthesize _outchannels;

- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = @"192.168.1.100";
        
        self._inchannels = [NSMutableArray array];
        self._outchannels = [NSMutableArray array];
        
        self._show_icon_name = @"a_icon_7.png";
        self._show_icon_sel_name = @"a_icon_7_sel.png";
    }
    
    return self;
}

- (NSString*) deviceName{
    
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

- (void) syncDriverIPProperty{
    
    if(_driver_ip_property)
    {
        self._ipaddress = _driver_ip_property.value;
        return;
    }
    
    if(_driver && [_driver isKindOfClass:[RgsDriverObj class]])
    {
        IMP_BLOCK_SELF(AudioEProcessor);
        
        RgsDriverObj *rd = (RgsDriverObj*)_driver;
        [[RegulusSDK sharedRegulusSDK] GetDriverProperties:rd.m_id completion:^(BOOL result, NSArray *properties, NSError *error) {
            if (result) {
                if ([properties count]) {
                    
                    for(RgsPropertyObj *pro in properties)
                    {
                        if([pro.name isEqualToString:@"IP"])
                        {
                            block_self._driver_ip_property = pro;
                            block_self._ipaddress = pro.value;
                        }
                    }
                }
            }
            else
            {
                
            }
        }];
    }
}

- (void) uploadDriverIPProperty
{
    if(_driver
       && [_driver isKindOfClass:[RgsDriverObj class]]
       && _driver_ip_property)
    {
        IMP_BLOCK_SELF(AudioEProcessor);
        
        RgsDriverObj *rd = (RgsDriverObj*)_driver;
        
        //保存到内存
        _driver_ip_property.value = self._ipaddress;
        
        [KVNProgress show];
        
        [[RegulusSDK sharedRegulusSDK] SetDriverProperty:rd.m_id
                                          property_name:_driver_ip_property.name
                                         property_value:self._ipaddress
                                             completion:^(BOOL result, NSError *error) {
            if (result) {
                
                [block_self saveProject];
            }
            else{
                
                [KVNProgress dismiss];
            }
        }];
    }
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
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyRefreshTableWithCom" object:nil];
            }
            [KVNProgress dismiss];
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

- (NSDictionary *)objectToJson{
    
    NSMutableDictionary *allData = [NSMutableDictionary dictionary];
    
    [allData setValue:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
    
    //基本信息
    if(self._brand)
        [allData setObject:self._brand forKey:@"brand"];
    
    if(self._type)
        [allData setObject:self._type forKey:@"type"];
    
    if(self._deviceno)
        [allData setObject:self._deviceno forKey:@"deviceno"];
    
    if(self._ipaddress)
        [allData setObject:self._ipaddress forKey:@"ipaddress"];
    
    if(self._deviceid)
        [allData setObject:self._deviceid forKey:@"deviceid"];
    
    if(self._driverUUID)
        [allData setObject:self._driverUUID forKey:@"driverUUID"];
    
    if(self._comIdx)
        [allData setObject:[NSString stringWithFormat:@"%d",self._comIdx] forKey:@"com"];
    
    [allData setObject:[NSString stringWithFormat:@"%d",self._index] forKey:@"index"];
    
    
    if(_driverInfo)
    {
        RgsDriverInfo *info = _driverInfo;
        [allData setObject:info.serial forKey:@"driver_info_uuid"];
    }
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [allData setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"driver_id"];
    }

    if(_inAudioProxys)
    {
        NSMutableArray *proxys = [NSMutableArray array];
        
        for(VAProcessorProxys *vap in _inAudioProxys)
        {
            RgsProxyObj *proxy = vap._rgsProxyObj;
            
            NSMutableDictionary *proxyDic = [NSMutableDictionary dictionary];
            [proxys addObject:proxyDic];
            
            if(vap._icon_name)
            {
                [proxyDic setObject:vap._icon_name
                             forKey:@"icon_name"];
            }
            if(vap._voiceInDevice)
            {
                [proxyDic setObject:vap._voiceInDevice
                             forKey:@"voiceInDevice"];
            }
            
            [proxyDic setObject:[NSNumber numberWithInteger:proxy.m_id]
                         forKey:@"proxy_id"];
            
            [proxyDic setObject:[NSNumber numberWithInteger:proxy.name]
                         forKey:@"proxy_name"];
            
            [proxyDic setObject:[NSString stringWithFormat:@"%0.1f", [vap getAnalogyGain]]
                         forKey:@"analogy_gain"];
            
            [proxyDic setObject:[NSNumber numberWithBool:[vap isProxyMute]]
                         forKey:@"analogy_mute"];
            
            [proxyDic setObject:[NSString stringWithFormat:@"%0.1f", [vap getDigitalGain]]
                         forKey:@"digital_gain"];
            
            [proxyDic setObject:[NSNumber numberWithBool:[vap isProxyDigitalMute]]
                         forKey:@"digital_mute"];
            
            [proxyDic setObject:vap._mode forKey:@"mode"];
            
            [proxyDic setObject:vap._micDb forKey:@"mic_db"];
            
            [proxyDic setObject:[NSNumber numberWithBool:vap._is48V]
                         forKey:@"48v"];
            
            [proxyDic setObject:[NSNumber numberWithBool:[vap getInverted]]
                         forKey:@"inverted"];
            
            [proxyDic setObject:[vap getScenarioSliceLocatedShadow]
                         forKey:@"RgsSceneDeviceOperation"];
        }
        
        [allData setObject:proxys forKey:@"in_audio_proxys"];
       
    }
    
    if(_outAudioProxys)
    {
        NSMutableArray *proxys = [NSMutableArray array];
        
        for(VAProcessorProxys *vap in _outAudioProxys)
        {
            RgsProxyObj *proxy = vap._rgsProxyObj;
            
            NSMutableDictionary *proxyDic = [NSMutableDictionary dictionary];
            [proxys addObject:proxyDic];
            
            if(vap._icon_name)
            {
                [proxyDic setObject:vap._icon_name
                             forKey:@"icon_name"];
            }
            
            [proxyDic setObject:[NSNumber numberWithInteger:proxy.m_id]
                         forKey:@"proxy_id"];
            
            [proxyDic setObject:[NSNumber numberWithInteger:proxy.name]
                         forKey:@"proxy_name"];
            
            [proxyDic setObject:[NSString stringWithFormat:@"%0.1f", [vap getAnalogyGain]]
                         forKey:@"analogy_gain"];
            
            [proxyDic setObject:[NSNumber numberWithBool:[vap isProxyMute]]
                         forKey:@"analogy_mute"];
            
            [proxyDic setObject:[NSString stringWithFormat:@"%0.1f", [vap getDigitalGain]]
                         forKey:@"digital_gain"];
            
            [proxyDic setObject:[NSNumber numberWithBool:[vap isProxyDigitalMute]]
                         forKey:@"digital_mute"];
            
            [proxyDic setObject:vap._mode forKey:@"mode"];
            
            [proxyDic setObject:vap._micDb forKey:@"mic_db"];
            
            [proxyDic setObject:[NSNumber numberWithBool:vap._is48V]
                         forKey:@"48v"];
            
            [proxyDic setObject:[NSNumber numberWithBool:[vap getInverted]]
                         forKey:@"inverted"];
            
            [proxyDic setObject:[vap getScenarioSliceLocatedShadow]
                         forKey:@"RgsSceneDeviceOperation"];
        }
        
        [allData setObject:proxys forKey:@"out_audio_proxys"];
        
    }
    
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:allData
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error: &error];
//
//    NSString *jsonresult = [[NSString alloc] initWithData:jsonData
//                                                 encoding:NSUTF8StringEncoding];
    
    
    return allData;
}

- (void) jsonToObject:(NSDictionary*)json{
    
    //基本信息
    if([json objectForKey:@"brand"])
        self._brand = [json objectForKey:@"brand"];
    
    if([json objectForKey:@"type"])
        self._type = [json objectForKey:@"type"];
    
    if([json objectForKey:@"deviceno"])
        self._deviceno = [json objectForKey:@"deviceno"];
    
    if([json objectForKey:@"ipaddress"])
        self._ipaddress = [json objectForKey:@"ipaddress"];
    
    if([json objectForKey:@"deviceid"])
        self._deviceid = [json objectForKey:@"deviceid"];
    
    if([json objectForKey:@"driverUUID"])
        self._driverUUID = [json objectForKey:@"driverUUID"];
    
    if([json objectForKey:@"com"])
        self._comIdx = [[json objectForKey:@"com"] intValue];
    
    self._index = [[json objectForKey:@"index"] intValue];
  
    RgsDriverInfo *drinfo = [[RgsDriverInfo alloc] init];
    drinfo.serial = [json objectForKey:@"driver_info_uuid"];
    self._driverInfo = drinfo;
    
    RgsDriverObj *dr = [[RgsDriverObj alloc] init];
    dr.m_id = [[json objectForKey:@"driver_id"] integerValue];
    self._driver = dr;
    
    self._inchannels = [json objectForKey:@"in_audio_proxys"];
    self._outchannels = [json objectForKey:@"out_audio_proxys"];
    
    self._inAudioProxys = [NSMutableArray array];
    for(NSDictionary *dic in _inchannels)
    {
        VAProcessorProxys *vap = [[VAProcessorProxys alloc] init];
        [vap recoverWithDictionary:dic];
        [_inAudioProxys addObject:vap];
    }
    self._outAudioProxys = [NSMutableArray array];
    for(NSDictionary *dic in _outchannels)
    {
        VAProcessorProxys *vap = [[VAProcessorProxys alloc] init];
        [vap recoverWithDictionary:dic];
        [_outAudioProxys addObject:vap];
    }
}

@end
