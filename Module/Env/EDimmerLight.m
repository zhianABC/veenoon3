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
@property (nonatomic, strong) NSMutableDictionary *config;

@end

@implementation EDimmerLight
{
    
}

@synthesize _localSavedCommands;
@synthesize config;
@synthesize _proxyObj;

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
    [[RegulusSDK sharedRegulusSDK] GetDriverCommands:rgsd.m_id
                                          completion:^(BOOL result, NSArray *commands, NSError *error) {
        if (result) {
            if ([commands count]) {
                [block_self loadedLightCommands:commands];
            }
        }
        
    }];
}


- (void) loadedLightCommands:(NSArray*)cmds{
    
    RgsDriverObj *driver = self._driver;
    
    id proxy = self._proxyObj;
    
    EDimmerLightProxys *vpro = nil;
    if(proxy && [proxy isKindOfClass:[EDimmerLightProxys class]])
    {
        vpro = proxy;
    }
    else
    {
        vpro = [[EDimmerLightProxys alloc] init];
    }
    
    id key = [NSString stringWithFormat:@"%d", (int)driver.m_id];
    
    NSDictionary *map = [config objectForKey:@"opt_value_map"];
    [vpro recoverWithDictionary:[map objectForKey:key]];
    
    vpro._deviceId = driver.m_id;
    [vpro checkRgsProxyCommandLoad:cmds];
    
    self._proxyObj = vpro;
   
}


@end
