//
//  VTouyingjiSet.m
//  veenoon
//
//  Created by 安志良 on 2018/4/25.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "VTouyingjiSet.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"
#import "VProjectProxys.h"

@interface VTouyingjiSet ()
{
    
}
@property (nonatomic, strong) NSMutableDictionary *config;
@end

@implementation VTouyingjiSet


@synthesize _comDriver;
@synthesize _comDriverInfo;
@synthesize _proxyObj;

@synthesize _localSavedCommands;
@synthesize config;

- (id) init
{
    if(self = [super init])
    {
        
        //不需要ip
        self._ipaddress = nil;
        self._show_icon_name = @"v_icon_9.png";
        self._show_icon_sel_name = @"v_icon_9_sel.png";
        
        self._typeName = @"投影机";
    }
    
    return self;
}

- (NSString*) deviceName{
    
    if(self._name)
        return self._name;
    
    return @"投影机";
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
        IMP_BLOCK_SELF(VTouyingjiSet);
        
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
        
        IMP_BLOCK_SELF(VTouyingjiSet);
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
    
    IMP_BLOCK_SELF(VTouyingjiSet);
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
    
    IMP_BLOCK_SELF(VTouyingjiSet);
    
    RgsDriverObj *driver = rgsd;
    if([driver isKindOfClass:[RgsDriverObj class]])
    {
        
        [[RegulusSDK sharedRegulusSDK] GetDriverCommands:driver.m_id
                                              completion:^(BOOL result, NSArray *commands, NSError *error) {
            if (result) {
                if ([commands count]) {
                    [block_self loadedProjectCommands:commands];
                }
            }
        }];
    }

}

- (void) loadedProjectCommands:(NSArray*)cmds{
    
    RgsDriverObj *driver = self._driver;
    
    id proxy = self._proxyObj;
    
    VProjectProxys *vpro = nil;
    if(proxy && [proxy isKindOfClass:[VProjectProxys class]])
    {
        vpro = proxy;
    }
    else
    {
        vpro = [[VProjectProxys alloc] init];
        self._proxyObj = vpro;
    }
    
    vpro._deviceId = driver.m_id;
    [vpro checkRgsProxyCommandLoad:cmds];
    
    id key = [NSString stringWithFormat:@"%d", (int)driver.m_id];
    
    NSDictionary *map = [config objectForKey:@"opt_value_map"];
    [vpro recoverWithDictionary:[map objectForKey:key]];

}


@end
