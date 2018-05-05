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
@synthesize _com;
@synthesize _deviceid;
@synthesize _index;
@synthesize _comArray;
@synthesize _driverUUID;

- (id) init
{
    if(self = [super init])
    {
        self._brand = @"";
        self._type = @"";
        self._deviceno = @"";
        self._com = @"";
        self._ipaddress = @"";
        self._deviceid = @"";
        self._index = 0;
        
        self._name = @"";
    }
    
    return self;
}

- (NSString*) showName{
    
    NSString *name = [NSString stringWithFormat:@"%@ - %@ - %@",
                      _brand, _name, _deviceno];
    
    return name;
}

- (NSString *)objectToJsonString{
    
    return nil;
}

- (void) jsonStringToObject:(NSString*)json{
 
}

@end
