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
@synthesize config;


- (id) init
{
    if(self = [super init])
    {
        
        self._show_icon_name = @"ir_driver_icon.png";
        self._show_icon_sel_name = @"ir_driver_icon_sel.png";
        
        self._typeName = @"红外转发器";
    }
    
    return self;
}


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
                                                 block_self._name = driver.name;
                                                 
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifyRefreshTableWithCom" object:nil];
                                             }
                                             [KVNProgress dismiss];
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
    
    IMP_BLOCK_SELF(IRDirver);
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
    
}


@end
