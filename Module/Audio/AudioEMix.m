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
#import "VProjectProxys.h"

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
        self._ipaddress = nil;
        self._show_icon_name = @"a_wx_2.png";
        self._show_icon_sel_name = @"a_wx_2_sel.png";
        
    }
    
    return self;
}

- (NSString*) deviceName{
    
    return @"会议";
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
     IMP_BLOCK_SELF(VTouyingjiSet);
     
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

- (void) uploadDriverIPProperty
{
    /*
     if(_comDriver
     && [_comDriver isKindOfClass:[RgsDriverObj class]]
     && _driver_ip_property)
     {
     IMP_BLOCK_SELF(VTouyingjiSet);
     
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
        VProjectProxys *vprj = _proxyObj;
        
        if(vprj._deviceId)
        {
            NSMutableArray *commands = [NSMutableArray array];
            NSMutableDictionary *cmdDic = [NSMutableDictionary dictionary];
            [commands addObject:cmdDic];
            
            [cmdDic setObject:[NSNumber numberWithInteger:vprj._deviceId] forKey:@"proxy_id"];
            [cmdDic setObject:vprj._power forKey:@"power"];
            [cmdDic setObject:vprj._input forKey:@"input"];
            
            [cmdDic setObject:[vprj getScenarioSliceLocatedShadow]
                       forKey:@"RgsSceneDeviceOperation"];
            
            [allData setObject:commands forKey:@"commands"];
        }
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
    
    
    self._localSavedCommands = [json objectForKey:@"commands"];
    
    if([_localSavedCommands count])
    {
        RgsDriverObj *driver = self._driver;
        VProjectProxys *vpro = [[VProjectProxys alloc] init];
        vpro._deviceId = driver.m_id;
        NSDictionary *local = [self._localSavedCommands objectAtIndex:0];
        [vpro recoverWithDictionary:local];
        self._proxyObj = vpro;
    }
    
}


@end

