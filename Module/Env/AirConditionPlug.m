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

@interface AirConditionPlug ()
{
    
}

@end

@implementation AirConditionPlug

@synthesize _IRDriver;
@synthesize _IRDriverInfo;

@synthesize _proxyObj;


- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = nil;
        self._show_icon_name = @"hj_icon_2.png";
        self._show_icon_sel_name = @"hj_icon_2_sel.png";
        
        self._typeName = @"空调";
    }
    
    return self;
}

- (NSString*) deviceName{

    if(self._name)
        return self._name;
    
    return @"空调";
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
    
    IMP_BLOCK_SELF(AirConditionPlug);
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
