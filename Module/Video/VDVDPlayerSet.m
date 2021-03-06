//
//  VDVDPlayerSet.m
//  veenoon
//
//  Created by 安志良 on 2018/4/16.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "VDVDPlayerSet.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"
#import "VDVDPlayerProxy.h"

@interface VDVDPlayerSet ()
{
    
}

@end


@implementation VDVDPlayerSet
@synthesize _IRDriver;
@synthesize _IRDriverInfo;

@synthesize _proxyObj;

@synthesize _localSavedProxys;

- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = nil;
        self._show_icon_name = @"v_icon_1.png";
        self._show_icon_sel_name = @"v_icon_1_sel.png";
        
        self._typeName = @"视频播放器";
    }
    
    return self;
}

- (NSString*) deviceName{
    
    if(self._name)
        return self._name;
    
    return @"视频播放器";
}


- (void) syncDriverComs{
    
    
    if(_driver
       && [_driver isKindOfClass:[RgsDriverObj class]]
       && ![_connections count])
    {
        IMP_BLOCK_SELF(VDVDPlayerSet);
        
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
        
        IMP_BLOCK_SELF(VDVDPlayerSet);
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

//- (void) createConnection:(RgsConnectionObj*)source withConnect:(RgsConnectionObj*)target{
//    
//    if(target && source)
//    {
//        
//        RgsConnectionObj * com_connt_obj = target;
//        RgsConnectionObj * cam_connt_obj = source;
//        
//        //IMP_BLOCK_SELF(VDVDPlayerSet);
//        
//        [com_connt_obj Connect:cam_connt_obj completion:^(BOOL result, NSError *error) {
//            if(result)
//            {
//                //block_self._com = target;
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyRefreshTableWithCom" object:nil];
//            }
//        }];
//    }
//}


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
    return self.config;
}

- (void) createByUserData:(NSDictionary*)userdata withMap:(NSDictionary*)valMap{
    
    self.config = [NSMutableDictionary dictionaryWithDictionary:userdata];
    [self.config setObject:valMap forKey:@"opt_value_map"];
    
    int driver_id = [[self.config objectForKey:@"driver_id"] intValue];
    self._isSelected = [[self.config objectForKey:@"s"] boolValue];
    
    IMP_BLOCK_SELF(VDVDPlayerSet);
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
    
    //红外
}

@end
