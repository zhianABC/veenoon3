//
//  SensorProxy.m
//  veenoon
//
//  Created by chen jack on 2018/11/5.
//  Copyright © 2018 jack. All rights reserved.
//

#import "SensorProxy.h"
#import "RegulusSDK.h"

@implementation SensorProxy
@synthesize connection;
@synthesize _proxyId;
@synthesize _sensorType;

- (void) refreshData
{
    if([connection.bound_connect_str count])
    {
        NSString *str = [connection.bound_connect_str objectAtIndex:0];
        if([str containsString:@"PM2.5"])
        {
            //PM2.5
            _sensorType = 1;
        }
        else if([str containsString:@"Temperature"])
        {
            //温度
            _sensorType = 2;
        }
        else
        {
            //湿度
           _sensorType = 3;
        }
    }
    
    IMP_BLOCK_SELF(SensorProxy);
    
    [[RegulusSDK sharedRegulusSDK] GetDriverProxys:connection.driver_id completion:^(BOOL result, NSArray *proxys, NSError *error) {
        
        if([proxys count])
        {
            RgsProxyObj *proxy = [proxys objectAtIndex:0];
            block_self._proxyId = (int)proxy.m_id;
        }
        
    }];
    
}

@end
