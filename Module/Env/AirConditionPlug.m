//
//  AirConditionPlug.m
//  veenoon
//
//  Created by chen jack on 2018/6/28.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AirConditionPlug.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"
#import "AirConditionProxy.h"


@implementation AirConditionPlug

@synthesize _IRDriver;
@synthesize _IRDriverInfo;

@synthesize _proxyObj;

@synthesize _localSavedProxys;

- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = nil;
        self._show_icon_name = @"hj_icon_2.png";
        self._show_icon_sel_name = @"hj_icon_2_sel.png";
        
    }
    
    return self;
}

- (NSString*) deviceName{
    
    return @"空调";
}


- (void) syncDriverIPProperty{
    
    
}

- (void) syncDriverComs{
    
    
    if(_driver
       && [_driver isKindOfClass:[RgsDriverObj class]]
       && ![_connections count])
    {
        IMP_BLOCK_SELF(AirConditionPlug);
        
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
                                                      //[KVNProgress showErrorWithStatus:[error description]];
                                                  }
                                              }];
        
    }
}

- (void) createDriver{
    
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;
    
    
    //Camera驱动
    if(area && _driverInfo && !_driver)
    {
        RgsDriverInfo *info = _driverInfo;
        
        IMP_BLOCK_SELF(AirConditionPlug);
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
        
        if(info.serial)
            [allData setObject:info.serial forKey:@"driver_info_uuid"];
    }
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [allData setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"driver_id"];
    }
    
    if(_IRDriverInfo)
    {
        RgsDriverInfo *info = _IRDriverInfo;
        
        if(info.serial)
            [allData setObject:info.serial forKey:@"com_driver_info_uuid"];
    }
    if(_IRDriver)
    {
        RgsDriverObj *dr = _IRDriver;
        [allData setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"com_driver_id"];
    }
    
    if(_proxyObj)
    {
        AirConditionProxy *vcam = _proxyObj;
        
        RgsProxyObj *proxy = vcam._rgsProxyObj;
        
        NSMutableArray *proxys = [NSMutableArray array];
        NSMutableDictionary *proxyDic = [NSMutableDictionary dictionary];
        [proxys addObject:proxyDic];
        
        [proxyDic setObject:[NSNumber numberWithInteger:proxy.m_id] forKey:@"proxy_id"];
        //[proxyDic setObject:[NSNumber numberWithInteger:vcam._save] forKey:@"load"];
        
        [proxyDic setObject:[vcam getScenarioSliceLocatedShadow]
                     forKey:@"RgsSceneDeviceOperation"];
        
        [allData setObject:proxys forKey:@"proxys"];
    }
    
    
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
    
    RgsDriverInfo *comdrinfo = [[RgsDriverInfo alloc] init];
    comdrinfo.serial = [json objectForKey:@"com_driver_info_uuid"];
    self._IRDriverInfo = comdrinfo;
    
    RgsDriverObj *comdr = [[RgsDriverObj alloc] init];
    comdr.m_id = [[json objectForKey:@"com_driver_id"] integerValue];
    self._IRDriver = comdr;
    
    
    self._localSavedProxys = [json objectForKey:@"proxys"];
    
    if([_localSavedProxys count])
    {
        AirConditionProxy *vcam = [[AirConditionProxy alloc] init];
        NSDictionary *local = [self._localSavedProxys objectAtIndex:0];
        [vcam recoverWithDictionary:local];
        self._proxyObj = vcam;
        
    }
}

@end
