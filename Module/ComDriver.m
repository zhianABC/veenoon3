//
//  ComDriver.m
//  veenoon
//
//  Created by chen jack on 2018/5/10.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "ComDriver.h"
#import "DataSync.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@interface ComDriver ()
{
    
}

@end


@implementation ComDriver

//@synthesize _proxyObj;
//@synthesize _comConnections;
@synthesize _comConnections;

//@synthesize _localSavedProxys;

- (id) init
{
    if(self = [super init])
    {
        
        self._show_icon_name = @"com_driver_icon.png";
        self._show_icon_sel_name = @"com_driver_icon_sel.png";
        
    }
    
    return self;
}

- (void) createDriver{
    
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;

    
    //Camera驱动
    if(area && _driverInfo && !_driver)
    {
        RgsDriverInfo *info = _driverInfo;
        
        IMP_BLOCK_SELF(ComDriver);
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
    
    
    
}

- (void) syncDriverComs{
    
    if(_driver
       && [_driver isKindOfClass:[RgsDriverObj class]]
       && ![_comConnections count])
    {
        IMP_BLOCK_SELF(ComDriver);
        
        RgsDriverObj *comd = _driver;
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
