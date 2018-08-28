//
//  VTouyingjiSet.m
//  veenoon
//
//  Created by 安志良 on 2018/4/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "VVideoProcessSet.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"
#import "VProjectProxys.h"
#import "VVideoProcessSetProxy.h"

@interface VVideoProcessSet ()
{
    
}

@end

@implementation VVideoProcessSet


@synthesize _comDriver;
@synthesize _comDriverInfo;
@synthesize _proxyObj;

@synthesize _localSavedCommands;

@synthesize _localSavedProxys;

- (id) init
{
    if(self = [super init])
    {
        
        //不需要ip
        self._ipaddress = @"192.168.1.1";
        self._show_icon_name = @"v_icon_5.png";
        self._show_icon_sel_name = @"v_icon_5_sel.png";
        
    }
    
    return self;
}

- (NSString*) deviceName{
    
    return video_process_name;
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
        
        IMP_BLOCK_SELF(VVideoProcessSet);
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
    
    if (_localSavedCommands) {
        [allData setObject:_localSavedCommands forKey:@"commands"];
    }
    
    if (_proxyObj) {
        VVideoProcessSetProxy *proxy = (VVideoProcessSetProxy*) _proxyObj;
        
        if(proxy._deviceMatcherDic)
            [allData setObject:proxy._deviceMatcherDic forKey:@"video_process"];
        
        if(proxy._inputDevices)
            [allData setObject:proxy._inputDevices forKey:@"input_devices"];
        
        if(proxy._outputDevices)
            [allData setObject:proxy._outputDevices forKey:@"output_devices"];
    
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
    
    self._localSavedCommands = [json objectForKey:@"commands"];

    VVideoProcessSetProxy *proxy = [[VVideoProcessSetProxy alloc] init];
    self._proxyObj = proxy;
    
    proxy._outputDevices = [json objectForKey:@"output_devices"];
    proxy._inputDevices = [json objectForKey:@"input_devices"];
    proxy._deviceMatcherDic = [json objectForKey:@"video_process"];
    
    NSDictionary *local = [self._localSavedCommands objectAtIndex:0];
    [proxy recoverWithDictionary:local];
}

@end
