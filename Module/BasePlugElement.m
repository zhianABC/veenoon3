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

@synthesize _driver_ip_property;
@synthesize _driver_port_property;
@synthesize _properties;
@synthesize _connections;
@synthesize _irCodeKeys;
//@synthesize _com;
@synthesize _comDriver;

@synthesize _show_icon_name;
@synthesize _show_icon_sel_name;

@synthesize _isSelected;

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
        self._name = @"";
        self._isSelected = NO;
        
        self._port = @"";
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

- (void) syncDriverIPProperty{
    
    if(self._driver_ip_property)
    {
        self._ipaddress = self._driver_ip_property.value;
        self._port = self._driver_port_property.value;
        
        return;
    }
    
    if(_driver && [_driver isKindOfClass:[RgsDriverObj class]])
    {
        IMP_BLOCK_SELF(BasePlugElement);
        
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
                        else if([pro.name isEqualToString:@"Port"])
                        {
                            block_self._driver_port_property = pro;
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
- (void) uploadDriverIPProperty{
    
    if(_driver
       && [_driver isKindOfClass:[RgsDriverObj class]])
    {
        IMP_BLOCK_SELF(BasePlugElement);
        
        RgsDriverObj *rd = (RgsDriverObj*)_driver;
        
        
        
        //保存到内存
        
        if(self._driver_port_property)
        {
            
            self._driver_port_property.value = self._port;
            [[RegulusSDK sharedRegulusSDK] SetDriverProperty:rd.m_id
                                               property_name:self._driver_port_property.name
                                              property_value:self._port
                                                  completion:nil];
        }
        
        if(self._driver_ip_property)
        {
            [KVNProgress show];
            
            self._driver_ip_property.value = self._ipaddress;
            [[RegulusSDK sharedRegulusSDK] SetDriverProperty:rd.m_id
                                               property_name:self._driver_ip_property.name
                                              property_value:self._ipaddress
                                                  completion:^(BOOL result, NSError *error) {
                                                      if (result) {
                                                          
                                                          [block_self showSuccess];
                                                      }
                                                      else{
                                                          
                                                          [KVNProgress dismiss];
                                                      }
                                                  }];
        }
        
        
        
        
    }
}

- (void) showSuccess{
    
    [KVNProgress showSuccess];
}

- (void) syncDriverComs{
    
}
- (void) createConnection:(RgsConnectionObj*)source withConnect:(RgsConnectionObj*)target{
    
}
@end
