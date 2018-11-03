//
//  EDimmerLight.m
//  veenoon
//
//  Created by chen jack on 2018/5/7.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "EDimmerLight.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"
#import "DataCenter.h"
#import "DataSync.h"
#import "EDimmerLightProxys.h"

@interface EDimmerLight ()
{
    
}
@end

@implementation EDimmerLight
{
    BOOL _isSetOK;
}

@synthesize _localSavedCommands;
@synthesize _proxys;

- (id) init
{
    if(self = [super init])
    {
        
        self._ipaddress = @"192.168.1.100";
        
        self._show_icon_name = @"hj_icon_1.png";
        self._show_icon_sel_name = @"hj_icon_1_sel.png";
        
        self._typeName = env_dimmer_light;
        
    }
    
    return self;
}

- (NSString*) deviceName{
    
    if(self._name)
        return self._name;
    
    return env_dimmer_light;
}

- (void) saveProject{
    
    [KVNProgress showSuccess];
}

- (void) createDriver{
    
    RgsAreaObj *area = [DataSync sharedDataSync]._currentArea;
    if(area && _driverInfo && !_driver)
    {
        RgsDriverInfo *info = _driverInfo;
        
        IMP_BLOCK_SELF(EDimmerLight);
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


- (void) prepareAllCmds
{
    
    if([_proxys count])
    {
        NSMutableArray *proxyids = [NSMutableArray array];
        //只读取一个，因为所有的Channel的commands相同
        EDimmerLightProxys *vap = [_proxys objectAtIndex:0];
        [proxyids addObject:[NSNumber numberWithInt:(int)vap._rgsProxyObj.m_id]];
        
        IMP_BLOCK_SELF(EDimmerLight);
        
        [[RegulusSDK sharedRegulusSDK] GetProxyCommandDict:proxyids
                                                completion:^(BOOL result, NSDictionary *commd_dict, NSError *error) {
                                                    
                                                    [block_self loadCommands:commd_dict];
                                                    
                                                }];
    }
    
}

- (void) loadCommands:(NSDictionary*)commd_dict{
    
    if([[commd_dict allValues] count])
    {
        NSArray *cmds = [[commd_dict allValues] objectAtIndex:0];
        
        for(EDimmerLightProxys *vap in _proxys)
        {
            [vap checkRgsProxyCommandLoad:cmds];
        }
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
    return self.config;
}

- (void) createByUserData:(NSDictionary*)userdata withMap:(NSDictionary*)valMap{
    
    self.config = [NSMutableDictionary dictionaryWithDictionary:userdata];
    [self.config setObject:valMap forKey:@"opt_value_map"];
    
    int driver_id = [[self.config objectForKey:@"driver_id"] intValue];
    self._isSelected = [[self.config objectForKey:@"s"] boolValue];
    
    IMP_BLOCK_SELF(EDimmerLight);
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
    
    IMP_BLOCK_SELF(EDimmerLight);
    [[RegulusSDK sharedRegulusSDK] GetDriverProxys:rgsd.m_id
                                        completion:^(BOOL result, NSArray *proxys, NSError *error) {
                                            if (result) {
                                                if ([proxys count]) {
                                                    
                                                    NSMutableArray *proxysArray = [NSMutableArray array];
                                                    for (RgsProxyObj *proxyObj in proxys) {
                                                        if ([proxyObj.type isEqualToString:@"light_v2"]) {
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
    
    for(int i = 0; i < [proxys count]; i++)
    {
        RgsProxyObj *proxy = [proxys objectAtIndex:i];
        
        id key = [NSString stringWithFormat:@"%d", (int)proxy.m_id];
        
        EDimmerLightProxys *apxy = [[EDimmerLightProxys alloc] init];
        apxy._rgsProxyObj = proxy;
        
        NSArray *vals = [map objectForKey:key];
        [apxy recoverWithDictionary:vals];
        
        [_proxys addObject:apxy];
    }
}


@end
