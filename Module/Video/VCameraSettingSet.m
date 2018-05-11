//
//  VCameraSettingSet.m
//  veenoon
//
//  Created by 安志良 on 2018/4/22.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "VCameraSettingSet.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"
#import "VCameraProxys.h"

@interface VCameraSettingSet ()
{
    
}

@end


@implementation VCameraSettingSet

@synthesize _comDriver;
@synthesize _comDriverInfo;

@synthesize _proxyObj;

@synthesize _localSavedProxys;

- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = nil;
        
    }
    
    return self;
}

- (NSString*) deviceName{
    
    return @"录播摄像机";
}


- (void) syncDriverIPProperty{
    
    /*
    if(_driver_ip_property)
    {
        self._ipaddress = _driver_ip_property.value;
        return;
    }
    
    if(_comDriver && [_comDriver isKindOfClass:[RgsDriverObj class]])
    {
        IMP_BLOCK_SELF(VCameraSettingSet);
        
        RgsDriverObj *rd = (RgsDriverObj*)_comDriver;
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
     */
}

- (void) syncDriverComs{
    /*
    if(_comDriver
       && [_comDriver isKindOfClass:[RgsDriverObj class]]
       && ![_comConnections count])
    {
        IMP_BLOCK_SELF(VCameraSettingSet);
        
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
                //[KVNProgress showErrorWithStatus:[error description]];
            }
        }];
    
    }
     */
    
    if(_driver
       && [_driver isKindOfClass:[RgsDriverObj class]]
       && ![_connections count])
    {
        IMP_BLOCK_SELF(VCameraSettingSet);
        
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

- (void) uploadDriverIPProperty
{
    /*
    if(_comDriver
       && [_comDriver isKindOfClass:[RgsDriverObj class]]
       && _driver_ip_property)
    {
        IMP_BLOCK_SELF(VCameraSettingSet);
        
        RgsDriverObj *rd = (RgsDriverObj*)_comDriver;
        
        //保存到内存
        _driver_ip_property.value = self._ipaddress;
        
        [[RegulusSDK sharedRegulusSDK] SetDriverProperty:rd.m_id
                                           property_name:_driver_ip_property.name
                                          property_value:self._ipaddress
                                              completion:^(BOOL result, NSError *error) {
                                                  if (result) {
                                                      
                                                      [block_self saveProject];
                                                  }
                                                  else{
                                                      
                                                  }
                                              }];
    }
     */
}

- (void) saveProject{
    
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
    
    //串口服务器驱动
    /*不需要了
    if(area && _comDriverInfo && !_comDriver)
    {
        RgsDriverInfo *info = _comDriverInfo;
        
        IMP_BLOCK_SELF(VCameraSettingSet);
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
        
        IMP_BLOCK_SELF(VCameraSettingSet);
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
    
    /*不需要了
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

- (void) createConnection:(RgsConnectionObj*)target{
    
    if(target && [_connections count])
    {
        
        RgsConnectionObj * com_connt_obj = target;
        RgsConnectionObj * cam_connt_obj = [_connections objectAtIndex:0];
        
        IMP_BLOCK_SELF(VCameraSettingSet);
        
        [com_connt_obj Connect:cam_connt_obj completion:^(BOOL result, NSError *error) {
            if(result)
            {
                block_self._com = target;
                
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
        [allData setObject:info.serial forKey:@"driver_info_uuid"];
    }
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [allData setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"driver_id"];
    }
    
    if(_comDriverInfo)
    {
        RgsDriverInfo *info = _comDriverInfo;
        [allData setObject:info.serial forKey:@"com_driver_info_uuid"];
    }
    if(_comDriver)
    {
        RgsDriverObj *dr = _comDriver;
        [allData setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"com_driver_id"];
    }
    
    if(_proxyObj)
    {
        VCameraProxys *vcam = _proxyObj;
        
        RgsProxyObj *proxy = vcam._rgsProxyObj;
        
        NSMutableArray *proxys = [NSMutableArray array];
        NSMutableDictionary *proxyDic = [NSMutableDictionary dictionary];
        [proxys addObject:proxyDic];
        
        [proxyDic setObject:[NSNumber numberWithInteger:proxy.m_id] forKey:@"proxy_id"];
        [proxyDic setObject:[NSNumber numberWithInteger:vcam._save] forKey:@"load"];
        
        [proxyDic setObject:[vcam getScenarioSliceLocatedShadow]
                     forKey:@"RgsSceneDeviceOperation"];
        
        [allData setObject:proxys forKey:@"proxys"];
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
    
    RgsDriverInfo *comdrinfo = [[RgsDriverInfo alloc] init];
    comdrinfo.serial = [json objectForKey:@"com_driver_info_uuid"];
    self._comDriverInfo = comdrinfo;
    
    RgsDriverObj *comdr = [[RgsDriverObj alloc] init];
    comdr.m_id = [[json objectForKey:@"com_driver_id"] integerValue];
    self._comDriver = comdr;
    
    
    self._localSavedProxys = [json objectForKey:@"proxys"];
    
    if([_localSavedProxys count])
    {
        VCameraProxys *vcam = [[VCameraProxys alloc] init];
        NSDictionary *local = [self._localSavedProxys objectAtIndex:0];
        [vcam recoverWithDictionary:local];
        self._proxyObj = vcam;

    }
}


@end
