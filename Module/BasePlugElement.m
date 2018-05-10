//
//  BasePlugElement.m
//  veenoon
//
//  Created by chen jack on 2018/4/21.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "BasePlugElement.h"

@implementation BasePlugElement
@synthesize _name;
@synthesize _brand;
@synthesize _type;
@synthesize _deviceno;
@synthesize _ipaddress;
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
    }
    
    return self;
}

- (NSString*) showName{
    
    NSString *name = [NSString stringWithFormat:@"%@ - %@ - %@",
                      _brand, _name, _deviceno];
    
    self._isViewed = YES;
    
    return name;
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
@end
