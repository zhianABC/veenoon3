//
//  AudioEMinMax.m
//  veenoon
//
//  Created by chen jack on 2018/3/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "AudioEMinMax.h"
#import "RegulusSDK.h"
#import "DataSync.h"
#import "KVNProgress.h"
#import "AudioEMinMaxProxy.h"

@implementation AudioEMinMax
@synthesize _proxys;


- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = @"192.168.1.100";
        
        self._show_icon_name = @"a_icon_8.png";
        self._show_icon_sel_name = @"a_icon_8_sel.png";
        
    }
    
    return self;
}

- (void) createDriver{
    
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;
    if(area && _driverInfo && !_driver)
    {
        RgsDriverInfo *info = _driverInfo;
        
        IMP_BLOCK_SELF(AudioEMinMax);
        
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


- (NSString*) deviceName{
    
    if(self._name)
        return self._name;
    
    return @"功放";
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
    
    IMP_BLOCK_SELF(AudioEMinMax);
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
    
    IMP_BLOCK_SELF(AudioEMinMax);
    
    [[RegulusSDK sharedRegulusSDK] GetDriverProxys:rgsd.m_id
                                        completion:^(BOOL result, NSArray *proxys, NSError *error) {
                                            if (result) {
                                                if ([proxys count]) {
                                                    
                                                    NSMutableArray *proxysArray = [NSMutableArray array];
                                                    for (RgsProxyObj *proxyObj in proxys) {
                                                        if ([proxyObj.type isEqualToString:@"Relay"]) {
                                                            [proxysArray addObject:proxyObj];
                                                        }
                                                    }
                                                    [block_self prepareChannels:proxysArray];
                                                }
                                            }
                                        }];
}


- (void) prepareChannels:(NSArray*)proxys{
    
    self._proxys = [NSMutableArray array];

    NSDictionary *map = [self.config objectForKey:@"opt_value_map"];
    
    for(RgsProxyObj *proxy in proxys)
    {
        
        id key = [NSString stringWithFormat:@"%d", (int)proxy.m_id];
        
        if([proxy.type isEqualToString:@"Speaker"])
        {
            AudioEMinMaxProxy *vap = [[AudioEMinMaxProxy alloc] init];
            vap._rgsProxyObj = proxy;
            
            NSArray *vals = [map objectForKey:key];
            [vap recoverWithDictionary:vals];
            
            [_proxys addObject:vap];
            
        }
    }
}

@end
