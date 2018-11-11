//
//  BasePlugElement.m
//  veenoon
//
//  Created by chen jack on 2018/4/21.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "BasePlugElement.h"
#import "RegulusSDK.h"
#import "KVNProgress.h"

@implementation BasePlugElement
@synthesize _name;
@synthesize _brand;
@synthesize _type;
@synthesize _deviceno;
@synthesize _ipaddress;
@synthesize _port;
@synthesize _deviceid;
@synthesize _index;
@synthesize _comIdx;
@synthesize _comArray;
@synthesize _driverUUID;
@synthesize _isViewed;
@synthesize _plugicon;
@synthesize _plugicon_s;

@synthesize _driver;
@synthesize _driverInfo;

//@synthesize _driverProperties;
//@synthesize _driver_ip_property;
//@synthesize _driver_port_property;
@synthesize _properties;
@synthesize _connections;
@synthesize _irCodeKeys;
//@synthesize _com;
@synthesize _comDriver;

@synthesize _show_icon_name;
@synthesize _show_icon_sel_name;

@synthesize _isSelected;

@synthesize _typeName;
@synthesize config;

@synthesize _tmpIsScenarioPlug;

- (id) init
{
    if(self = [super init])
    {
        self._brand = @"";
        self._type = @"";
        self._deviceno = @"";
        self._ipaddress = @"";
        self._deviceid = @"";
        self._index = 0;
        self._comIdx = 0;
        self._name = nil;
        self._isSelected = NO;
        
        self._port = @"";
        
        self._tmpIsScenarioPlug = NO;
    }
    
    return self;
}

- (NSString*) showName{
    
    NSString *name = [NSString stringWithFormat:@"%@ - %@ - %@",
                      _brand, _name, _deviceno];
    
    self._isViewed = YES;
    
    return name;
}

- (int) getID{
    
    int myid = 0;
    if(_driver)
    {
        myid = (int)((RgsDriverObj*)_driver).m_id;
    }
    return myid;
}

- (NSString*) deviceName
{
    return _name;
}

- (NSDictionary *)objectToJson{
    
    return nil;
}

- (void) jsonToObject:(NSDictionary*)json{
 
}

- (void) createDriver{
    
}

- (void) removeDriver{
    
}

- (void) syncDriverProperty{
    
    if(self._properties)
    {
        for(RgsPropertyObj *pro in _properties)
        {
            if([pro.name isEqualToString:@"IP"])
            {
                self._ipaddress = pro.value;
            }
            else if([pro.name isEqualToString:@"Port"])
            {
                self._port = pro.value;
            }
        }
        return;
    }
    
    if(_driver && [_driver isKindOfClass:[RgsDriverObj class]])
    {
        IMP_BLOCK_SELF(BasePlugElement);
        
        RgsDriverObj *rd = (RgsDriverObj*)_driver;
        [[RegulusSDK sharedRegulusSDK] GetDriverProperties:rd.m_id completion:^(BOOL result, NSArray *properties, NSError *error) {
            if (result) {
                if ([properties count]) {
                    
                    block_self._properties = properties;
                    
                    for(RgsPropertyObj *pro in properties)
                    {
                        if([pro.name isEqualToString:@"IP"])
                        {
                            block_self._ipaddress = pro.value;
                        }
                        else if([pro.name isEqualToString:@"Port"])
                        {
                            block_self._port = pro.value;
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

- (void) uploadDriverProperty{
    
    if(_driver
       && [_driver isKindOfClass:[RgsDriverObj class]])
    {
        RgsDriverObj *rd = (RgsDriverObj*)_driver;
        
        for(RgsPropertyObj *pro in _properties)
        {
            [[RegulusSDK sharedRegulusSDK] SetDriverProperty:rd.m_id
                                               property_name:pro.name
                                              property_value:pro.value
                                                  completion:nil];
        }
        
    }
    
    [KVNProgress showSuccess];
}

- (void) showSuccess{
    
    [KVNProgress showSuccess];
}

- (void) syncDriverComs{
    
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


- (NSDictionary *)userData{
    
    return nil;
}
- (void) createByUserData:(NSDictionary*)userdata withMap:(NSDictionary*)valMap{
    
}
@end
