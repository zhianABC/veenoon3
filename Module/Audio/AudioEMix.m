//
//  VTouyingjiSet.m
//  veenoon
//
//  Created by 安志良 on 2018/4/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEMix.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"
#import "AudioEMixProxy.h"

@interface AudioEMix ()
{
    
}

@end

@implementation AudioEMix


@synthesize _comDriver;
@synthesize _comDriverInfo;
@synthesize _proxyObj;

@synthesize _localSavedCommands;

- (id) init
{
    if(self = [super init])
    {
        
        //不需要ip
        self._ipaddress = @"192.168.1.1";
        self._show_icon_name = @"a_wx_2.png";
        self._show_icon_sel_name = @"a_wx_2_sel.png";
        
    }
    
    return self;
}

- (NSString*) deviceName{
    
    return audio_mixer_name;
}

- (void) syncDriverComs{
    /*
     if(_comDriver
     && [_comDriver isKindOfClass:[RgsDriverObj class]]
     && ![_comConnections count])
     {
     IMP_BLOCK_SELF(VTouyingjiSet);
     
     RgsDriverObj *comd = _comDriver;
     [[RegulusSDK sharedRegulusSDK] GetDriverConnects:comd.m_id
     completion:^(BOOL result, NSArray *connects, NSError *error) {
     if (result) {
     if ([connects count]) {
     
     block_self._comConnections = connects;
     NSMutableArray *coms = [NSMutableArray array];
     for(int i = 0; i < [connects count]; i++)
     {
     RgsConnectionObj *obj = [connects objectAtIndex:i];
     [coms addObject:obj.name];
     }
     
     block_self._comArray = coms;
     }
     }
     else
     {
     NSLog(@"+++++++++++++");
     NSLog(@"+++++++++++++");
     NSLog(@"sync com Driver Connection Error");
     NSLog(@"+++++++++++++");
     NSLog(@"+++++++++++++");
     //[KVNProgress showErrorWithStatus:[error description]];
     }
     }];
     
     }
     */
    if(_driver
       && [_driver isKindOfClass:[RgsDriverObj class]]
       && ![_connections count])
    {
        IMP_BLOCK_SELF(AudioEMix);
        
        RgsDriverObj *comd = _driver;
        [[RegulusSDK sharedRegulusSDK] GetDriverConnects:comd.m_id
                                              completion:^(BOOL result, NSArray *connects, NSError *error) {
                                                  if (result) {
                                                      if ([connects count]) {
                                                          
                                                          block_self._connections = connects;
                                                      }
                                                  }
                                                  else
                                                  {
                                                      NSLog(@"+++++++++++++");
                                                      NSLog(@"+++++++++++++");
                                                      NSLog(@"sync Driver Connection Error");
                                                      NSLog(@"+++++++++++++");
                                                      NSLog(@"+++++++++++++");
                                                      
                                                      //[KVNProgress showErrorWithStatus:[error description]];
                                                  }
                                              }];
        
    }
}

- (void) saveProject{
    [KVNProgress showSuccess];
}

- (void) createDriver{
    
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;
    
    //串口服务器驱动
    /*
     if(area && _comDriverInfo && !_comDriver)
     {
     RgsDriverInfo *info = _comDriverInfo;
     
     IMP_BLOCK_SELF(VTouyingjiSet);
     [[RegulusSDK sharedRegulusSDK] CreateDriver:area.m_id
     serial:info.serial
     completion:^(BOOL result, RgsDriverObj *driver, NSError *error) {
     if (result) {
     
     block_self._comDriver = driver;
     }
     
     }];
     }
     */
    //Camera驱动
    if(area && _driverInfo && !_driver)
    {
        RgsDriverInfo *info = _driverInfo;
        
        IMP_BLOCK_SELF(AudioEMix);
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
    /*
     if(_comDriver)
     {
     RgsDriverObj *dr = _comDriver;
     [[RegulusSDK sharedRegulusSDK] DeleteDriver:dr.m_id
     completion:^(BOOL result, NSError *error) {
     
     }];
     }
     */
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [[RegulusSDK sharedRegulusSDK] DeleteDriver:dr.m_id
                                         completion:^(BOOL result, NSError *error) {
                                             
                                         }];
    }
    
    
}

- (void) createConnection:(RgsConnectionObj*)source withConnect:(RgsConnectionObj*)target{
    
    if(target && source)
    {
        
        RgsConnectionObj * com_connt_obj = target;
        RgsConnectionObj * cam_connt_obj = source;
        
        //IMP_BLOCK_SELF(VDVDPlayerSet);
        
        [com_connt_obj Connect:cam_connt_obj completion:^(BOOL result, NSError *error) {
            if(result)
            {
                //block_self._com = target;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyRefreshTableWithCom" object:nil];
            }
        }];
    }
}


- (NSDictionary *)objectToJson{
    
    NSMutableDictionary *allData = [NSMutableDictionary dictionary];
    
    [allData setValue:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
    
    //基本信息
    if (self._name) {
        [allData setObject:self._name forKey:@"name"];
    }
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
        
        if(dr.name)
        {
            [allData setObject:dr.name forKey:@"driver_name"];
        }
    }
    if(_comDriverInfo)
    {
        RgsDriverInfo *info = _comDriverInfo;
        if(info.serial)
            [allData setObject:info.serial forKey:@"com_driver_info_uuid"];
    }
    if(_comDriver)
    {
        RgsDriverObj *dr = _comDriver;
        [allData setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"com_driver_id"];
    }
    
    if(_proxyObj)
    {
        AudioEMixProxy *proxy = _proxyObj;
        
        //proxy id
        [allData setObject:[NSString stringWithFormat:@"%d",(int)proxy._deviceId]
                    forKey:@"device_id"];
        
        // volumn
        [allData setObject:[NSString stringWithFormat:@"%f",proxy._deviceVol]
                    forKey:@"device_vol"];
        
        //摄像协议
        if(proxy._currentCameraPol)
        [allData setObject:proxy._currentCameraPol forKey:@"camera_pol"];
        
        //
        [allData setObject:[NSString stringWithFormat:@"%d",proxy._fayanPriority]
                    forKey:@"fayan_priority"];
        //
        if(proxy._mixHighFilter)
        [allData setObject:proxy._mixHighFilter forKey:@"mix_high_filter"];
        
        //
        if(proxy._mixLowFilter)
        [allData setObject:proxy._mixLowFilter forKey:@"mix_low_filter"];
        
        //
        if(proxy._mixNoise)
        [allData setObject:proxy._mixNoise forKey:@"mix_noise"];
        
        //
        if(proxy._mixPEQ)
        [allData setObject:proxy._mixPEQ forKey:@"mix_peq"];
        
        //
        if(proxy._mixPress)
        [allData setObject:proxy._mixPress forKey:@"mix_press"];
        
        //
        if(proxy._mixPEQRate)
        [allData setObject:proxy._mixPEQRate forKey:@"mix_peq_rate"];
        
        //
        if(proxy._workMode)
        [allData setObject:proxy._workMode forKey:@"work_mode"];
        
        //
        if(proxy._zhuxiDaibiao)
            [allData setObject:proxy._workMode forKey:@"zhuxi_daibiao"];
    }
    
    
    return allData;
}


- (void) jsonToObject:(NSDictionary*)json{
    
    //基本信息
    if([json objectForKey:@"name"])
        self._name = [json objectForKey:@"name"];
    
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
    dr.name = [json objectForKey:@"driver_name"];
    self._driver = dr;
    
    RgsDriverInfo *comdrinfo = [[RgsDriverInfo alloc] init];
    comdrinfo.serial = [json objectForKey:@"com_driver_info_uuid"];
    self._comDriverInfo = comdrinfo;
    
    RgsDriverObj *comdr = [[RgsDriverObj alloc] init];
    comdr.m_id = [[json objectForKey:@"com_driver_id"] integerValue];
    self._comDriver = comdr;
    
    
    self._localSavedCommands = [json objectForKey:@"commands"];
    
    
    AudioEMixProxy *proxy = [[AudioEMixProxy alloc] init];
    self._proxyObj  = proxy;
    
    
    //proxy id
    proxy._deviceId = [[json objectForKey:@"device_id"] integerValue];
    
    // volumn
    proxy._deviceVol = [[json objectForKey:@"device_vol"] floatValue];
    
    //摄像协议
    proxy._currentCameraPol = [json objectForKey:@"camera_pol"];
    
    //
    proxy._fayanPriority = [[json objectForKey:@"fayan_priority"] intValue];
    
    //
    proxy._mixHighFilter = [json objectForKey:@"mix_high_filter"];
    
    //
    proxy._mixLowFilter = [json objectForKey:@"mix_low_filter"];
    
    //
    proxy._mixNoise = [json objectForKey:@"mix_noise"];
    
    //
    proxy._mixPEQ = [json objectForKey:@"mix_peq"];
    
    //
    proxy._mixPress = [json objectForKey:@"mix_press"];
    
    //
    proxy._mixPEQRate = [json objectForKey:@"mix_peq_rate"];
    
    //
    proxy._workMode = [json objectForKey:@"work_mode"];
    
    //
    proxy._zhuxiDaibiao = [json objectForKey:@"zhuxi_daibiao"];
}


@end

