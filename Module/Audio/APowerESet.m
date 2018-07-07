//
//  APowerESet.m
//  veenoon
//
//  Created by chen jack on 2018/3/30.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "APowerESet.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"
#import "APowerESetProxy.h"

@interface APowerESet ()
{
    
}


@end

@implementation APowerESet
@synthesize _lines;
@synthesize _proxyObj;
@synthesize _localSavedCommands;
@synthesize _proxys;

- (id) init
{
    if(self = [super init])
    {
        
        //不需要ip
        self._ipaddress = @"192.168.3.7";
        self._show_icon_name = @"dy_08.png";
        self._show_icon_sel_name = @"dy_08_sel.png";
        
    }
    
    return self;
}

- (NSString*) deviceName{
    
    return audio_power_sequencer;
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
        IMP_BLOCK_SELF(APowerESet);
        
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

- (void) uploadDriverIPProperty
{
    if(_driver
       && [_driver isKindOfClass:[RgsDriverObj class]]
       && _driver_ip_property)
    {
        IMP_BLOCK_SELF(APowerESet);
        
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
        
        IMP_BLOCK_SELF(APowerESet);
        
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

- (void) initLabs:(int)num{
    
    self._lines = [NSMutableArray array];
    
    for(int i = 0; i < num; i++)
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"OFF" forKey:@"status"];
        [dic setObject:@"1" forKey:@"seconds"];
        [dic setObject:[NSString stringWithFormat:@"Channel %02d", i+1] forKey:@"name"];
        [_lines addObject:dic];
    }
    
    self._ipaddress = @"192.168.1.100";
    
}

- (void) setLabValue:(BOOL)offon withIndex:(int)index{
    
    NSMutableDictionary *value = [_lines objectAtIndex:index];
    
    if(offon)
    {
         [value setObject:@"ON" forKey:@"status"];
    }
    else
    {
        [value setObject:@"OFF" forKey:@"status"];
    }
}

- (void) setLabDelaySecs:(int)secs withIndex:(int)index{
    
    NSMutableDictionary *value = [_lines objectAtIndex:index];
    [value setObject:[NSString stringWithFormat:@"%d",secs]
              forKey:@"seconds"];
}

- (NSDictionary *)getLabValueWithIndex:(int)index{
    
    return [_lines objectAtIndex:index];
}

- (int) checkIsSameSeconds{
    
    int res = 0;
    
    BOOL same = YES;
    int cur = 1;
    
    for(int i = 0; i < [_lines count]; i++)
    {
        NSMutableDictionary *value = [_lines objectAtIndex:i];
        int s = [[value objectForKey:@"seconds"] intValue];
        if(i == 0)
            cur = s;
        else
        {
            if(cur != s){
                same = NO;
                break;
            }
        }
    }
    
    if(same)
    {
        res = cur;
    }
    
    return res;
}

- (void) prepareAllCmds
{
    
    if([_proxys count])
    {
        NSMutableArray *proxyids = [NSMutableArray array];
        //只读取一个，因为所有的Channel的commands相同
        APowerESetProxy *vap = [_proxys objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInt:vap._rgsProxyObj.m_id]];
        
        IMP_BLOCK_SELF(APowerESet);
        
        [[RegulusSDK sharedRegulusSDK] GetProxyCommandDict:proxyids
                                                completion:^(BOOL result, NSDictionary *commd_dict, NSError *error) {
                                                    
                                                    [block_self loadCommands:commd_dict];
                                                    
                                                }];
    }
    
}

- (void) loadCommands:(NSDictionary*)commd_dict{
    
    NSMutableArray *audio_channels = _proxys;
    
    if([[commd_dict allValues] count])
    {
        NSArray *cmds = [[commd_dict allValues] objectAtIndex:0];
        
        for(APowerESetProxy *vap in audio_channels)
        {
            [vap prepareLoadCommand:cmds];
        }
    }
    
}

@end
