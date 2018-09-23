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
        
        self._typeName = video_process_name;
    }
    
    return self;
}

- (NSString*) deviceName{
    
    if(self._name)
        return self._name;
    
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
                                                 block_self._name = driver.name;
                                                 
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyRefreshTableWithCom" object:nil];
                                             }
                                             [KVNProgress showSuccess];
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
    
    
    return allData;
}


- (void) jsonToObject:(NSDictionary*)json{
    
    
}

- (NSDictionary *)userData{
    
    self.config = [NSMutableDictionary dictionary];
    [self.config setValue:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [self.config setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"driver_id"];
        [self.config setObject:[NSNumber numberWithBool:self._isSelected] forKey:@"s"];
    }
    
    if (_proxyObj) {
        VVideoProcessSetProxy *proxy = (VVideoProcessSetProxy*) _proxyObj;
        
        if(proxy._inputDevices)
            [self.config setObject:proxy._inputDevices forKey:@"input_devices"];
        
        if(proxy._outputDevices)
            [self.config setObject:proxy._outputDevices forKey:@"output_devices"];
        
    }
    return self.config;
}

- (void) createByUserData:(NSDictionary*)userdata withMap:(NSDictionary*)valMap{
    
    self.config = [NSMutableDictionary dictionaryWithDictionary:userdata];
    [self.config setObject:valMap forKey:@"opt_value_map"];
    
    int driver_id = [[self.config objectForKey:@"driver_id"] intValue];
    self._isSelected = [[self.config objectForKey:@"s"] boolValue];
    
    IMP_BLOCK_SELF(VVideoProcessSet);
    [[RegulusSDK sharedRegulusSDK] GetRgsObjectByID:driver_id
                                         completion:^(BOOL result, id RgsObject, NSError *error) {
                                             
                                             if(result)
                                             {
                                                 [block_self successGotDriver:RgsObject];
                                             }
                                         }];
}


- (void) successGotDriver:(RgsDriverObj*)rgsd{
    
    self._driver = rgsd;
    self._driverInfo = rgsd.info;
    
    self._name = rgsd.name;
    
    IMP_BLOCK_SELF(VVideoProcessSet);
    [[RegulusSDK sharedRegulusSDK] GetDriverCommands:rgsd.m_id completion:^(BOOL result, NSArray *commands, NSError *error) {
        if (result) {
            if ([commands count]) {
                [block_self loadedVideoCommands:commands];
            }
        }
        
    }];
}


- (void) loadedVideoCommands:(NSArray*)cmds{
    
    RgsDriverObj *driver = self._driver;
    
    id proxy = self._proxyObj;
    
    VVideoProcessSetProxy *vpro = nil;
    if(proxy && [proxy isKindOfClass:[VVideoProcessSetProxy class]])
    {
        vpro = proxy;
    }
    else
    {
        vpro = [[VVideoProcessSetProxy alloc] init];
    }
    
    id key = [NSString stringWithFormat:@"%d", (int)driver.m_id];
    
    NSDictionary *inp = [self.config objectForKey:@"input_devices"];
    NSDictionary *oup = [self.config objectForKey:@"output_devices"];
    
    if([inp count])
    {
        for(id d in [inp allValues])
        {
            [vpro saveInputDevice:d];
        }
    }
    if([oup count])
    {
        for(id d in [oup allValues])
        {
            [vpro saveOutputDevice:d];
        }
    }
    
    vpro._deviceId = driver.m_id;
    [vpro checkRgsProxyCommandLoad:cmds];
    
    NSDictionary *map = [self.config objectForKey:@"opt_value_map"];
    [vpro recoverWithDictionary:[map objectForKey:key]];
    
    self._proxyObj = vpro;
 
}



@end
