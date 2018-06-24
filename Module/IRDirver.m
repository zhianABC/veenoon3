//
//  IRDirver.m
//  veenoon
//
//  Created by chen jack on 2018/6/24.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "IRDirver.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "DataSync.h"

@implementation IRDirver
@synthesize _irConnections;


- (void) createDriver{
    
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;
    
    
    //Camera驱动
    if(area && _driverInfo && !_driver)
    {
        RgsDriverInfo *info = _driverInfo;
        
        IMP_BLOCK_SELF(IRDirver);
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



- (void) syncDriverIPProperty{
    
    if(_driver_ip_property)
    {
        self._ipaddress = _driver_ip_property.value;
        return;
    }
    
    if(_driver && [_driver isKindOfClass:[RgsDriverObj class]])
    {
        IMP_BLOCK_SELF(IRDirver);
        
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

- (void) syncDriverComs{
    
    if(_driver
       && [_driver isKindOfClass:[RgsDriverObj class]]
       && ![_irConnections count])
    {
        IMP_BLOCK_SELF(IRDirver);
        
        RgsDriverObj *comd = _driver;
        [[RegulusSDK sharedRegulusSDK] GetDriverConnects:comd.m_id
                                              completion:^(BOOL result, NSArray *connects, NSError *error) {
                                                  if (result) {
                                                      if ([connects count]) {
                                                          
                                                          block_self._irConnections = connects;
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
    
}

- (void) uploadDriverIPProperty
{
    
    if(_driver
       && [_driver isKindOfClass:[RgsDriverObj class]]
       && _driver_ip_property)
    {
        IMP_BLOCK_SELF(IRDirver);
        
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

@end
