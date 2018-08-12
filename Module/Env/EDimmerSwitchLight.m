//
//  EDimmerSwitchLight.m
//  veenoon
//
//  Created by chen jack on 2018/5/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "EDimmerSwitchLight.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "DataCenter.h"
#import "DataSync.h"
#import "EDimmerSwitchLightProxy.h"

@interface EDimmerSwitchLight ()
{
    
}


@end

@implementation EDimmerSwitchLight
{
    
}

@synthesize _localSavedCommands;

@synthesize _proxyObj;

- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = @"192.168.1.100";
        
        self._show_icon_name = @"hj_icon_1.png";
        self._show_icon_sel_name = @"hj_icon_1_sel.png";
        
    }
    
    return self;
}

- (NSString*) deviceName{
    
    return @"开关照明";
}

- (void) syncDriverIPProperty{
    
    if(_driver_ip_property)
    {
        self._ipaddress = _driver_ip_property.value;
        return;
    }
    
    if(_driver && [_driver isKindOfClass:[RgsDriverObj class]])
    {
        IMP_BLOCK_SELF(EDimmerSwitchLight);
        
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
        IMP_BLOCK_SELF(EDimmerSwitchLight);
        
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
        
        IMP_BLOCK_SELF(EDimmerSwitchLight);
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
    
    if(_proxyObj)
    {
        EDimmerSwitchLightProxy *vprj = _proxyObj;
        
        if(vprj._deviceId)
        {
            NSMutableArray *commands = [NSMutableArray array];
            NSMutableDictionary *cmdDic = [NSMutableDictionary dictionary];
            [commands addObject:cmdDic];
            
            [cmdDic setObject:[NSNumber numberWithInteger:vprj._deviceId] forKey:@"proxy_id"];
            [cmdDic setObject:[vprj getChLevelRecords] forKey:@"ch_level"];
           
            [cmdDic setObject:[vprj getScenarioSliceLocatedShadow]
                       forKey:@"RgsSceneDeviceOperation"];
            
            [allData setObject:commands forKey:@"commands"];
        }
    }
    
//        NSError *error = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:allData
//                                                           options:NSJSONWritingPrettyPrinted
//                                                             error: &error];
//    
//        NSString *jsonresult = [[NSString alloc] initWithData:jsonData
//                                                     encoding:NSUTF8StringEncoding];
    
    
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
    
    self._localSavedCommands = [json objectForKey:@"commands"];
    
    if([_localSavedCommands count])
    {
        RgsDriverObj *driver = self._driver;
        EDimmerSwitchLightProxy *vpro = [[EDimmerSwitchLightProxy alloc] init];
        vpro._deviceId = driver.m_id;
        NSDictionary *local = [self._localSavedCommands objectAtIndex:0];
        [vpro recoverWithDictionary:local];
        self._proxyObj = vpro;
    }
    
}

@end
