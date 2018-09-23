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
@property (nonatomic, strong) NSMutableDictionary *config;
@end


@implementation VCameraSettingSet

@synthesize _comDriver;
@synthesize _comDriverInfo;

@synthesize _proxyObj;

@synthesize _localSavedProxys;
@synthesize config;
- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = nil;
        self._show_icon_name = @"v_icon_2.png";
        self._show_icon_sel_name = @"v_icon_2_sel.png";
        
        self._typeName = @"摄像机";
    }
    
    return self;
}

- (NSString*) deviceName{
    
    if(self._name)
        return self._name;
    
    return @"摄像机";
}


- (void) syncDriverComs{
    
    
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



- (void) saveProject{
    
    [KVNProgress showSuccess];
}

- (void) createDriver{
    
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;

    
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
    [config setValue:[NSString stringWithFormat:@"%@", [self class]] forKey:@"class"];
    if(_driver)
    {
        RgsDriverObj *dr = _driver;
        [config setObject:[NSNumber numberWithInteger:dr.m_id] forKey:@"driver_id"];
        [config setObject:[NSNumber numberWithBool:self._isSelected] forKey:@"s"];
    }
    return config;
}

- (void) createByUserData:(NSDictionary*)userdata withMap:(NSDictionary*)valMap{
    
    self.config = [NSMutableDictionary dictionaryWithDictionary:userdata];
    [config setObject:valMap forKey:@"opt_value_map"];
    
    int driver_id = [[config objectForKey:@"driver_id"] intValue];
    self._isSelected = [[config objectForKey:@"s"] boolValue];
    
    IMP_BLOCK_SELF(VCameraSettingSet);
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
    
    IMP_BLOCK_SELF(VCameraSettingSet);
    
    RgsDriverObj *driver = rgsd;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        [[RegulusSDK sharedRegulusSDK] GetDriverProxys:driver.m_id
                                            completion:^(BOOL result, NSArray *proxys, NSError *error) {
            if (result) {
                if ([proxys count]) {
                    
                    [block_self loadedCameraProxy:proxys];
                    
                }
            }
        }];
    }
}

- (void) loadedCameraProxy:(NSArray*)proxys{
    
    id proxy = self._proxyObj;
    
    VCameraProxys *vcam = nil;
    if(proxy && [proxy isKindOfClass:[VCameraProxys class]])
    {
        vcam = proxy;
    }
    else
    {
        vcam = [[VCameraProxys alloc] init];
        self._proxyObj = vcam;
    }
    
    vcam._rgsProxyObj = [proxys objectAtIndex:0];
   
    id key = [NSString stringWithFormat:@"%d", (int)vcam._rgsProxyObj.m_id];
    
    NSDictionary *map = [config objectForKey:@"opt_value_map"];
    [vcam recoverWithDictionary:[map objectForKey:key]];
    

}

@end
